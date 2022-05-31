# kmscheck.ps1
# Windows 2012, 2012 R2, 2016, 2019 KMS Key Change and activation Script
# Windows use on Auzre, AzureKMSUse setting 1
# KeyCheckMode is just check KMS Key Serial, not change key and activation
# Windows KMS Client key is public. url : https://docs.microsoft.com/ko-kr/windows-server/get-started/kms-client-activation-keys

# Options
$KeyCheckMode = 1 # 1=True, 0=False
$AuzreKMSUse = 1 # 1=True, 0=False

$WS2012Check_en = systeminfo | Select-String -pattern "OS Name:"
$WS2012Check_kr = systeminfo | Select-String -pattern "OS 이름:"

if ( $WS2012Check_en -eq "") {
    $OSLang = "kr"
    $WS2012Check = $WS2012Check_kr
}
else {
    $OSLang = "en"
    $WS2012Check = $WS2012Check_en
}

if ( $WS2012Check -like "*Microsoft Windows Server 2012*") {    
    switch ( $OSLang ) {
        'en' {
            $OsName = $WS2012Check -creplace 'OS Name:', ''
            
        }
        'kr' {
            $OsName = $WS2012Check -creplace 'OS 이름:', ''
        }
    }
    $OsName = $OsName.TrimStart()
}
else {
    $OsName = (get-computerinfo).OsName
}

# Windows Version Edition Check
Write-Host "OSName : ", $OsName
switch ( $OsName ) {
    # Windows Server 2012
    'Microsoft Windows Server 2012' {
        $kmskey = "BN3D2-R7TKB-3YPBD-8DRP2-27GG4"
    }
    'Microsoft Windows Server 2012 Standard' {
        $kmskey = "XC9B7-NBPP2-83J2H-RHMBY-92BT4"
    }
    'Microsoft Windows Server 2012 Datacenter' {
        $kmskey = "48HP8-DN98B-MYWDG-T2DCC-8W83P"
    }
    # Windows Server 2012 R2
    'Microsoft Windows Server 2012 R2 Standard' {
        $kmskey = "D2N9P-3P6X9-2R39C-7RTCD-MDVJX"
    }
    'Microsoft Windows Server 2012 R2 Datacenter' {
        $kmskey = "W3GGN-FT8W3-Y4M27-J84CP-Q3VJ9"
    }
    'Microsoft Windows Server 2012 R2 Essentials' {
        $kmskey = "KNC87-3J2TX-XB4WP-VCPJV-M4FWM"
    }
    # Windows Server 2016
    'Microsoft Windows Server 2016 Datacenter' {
        $kmskey = "CB7KF-BWN84-R7R2Y-793K2-8XDDG"
    }
    'Microsoft Windows Server 2016 Standard' {
        $kmskey = "WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY"
    }
    'Microsoft Windows Server 2016 Essentials' {
        $kmskey = "JCKRF-N37P4-C2D82-9YXRT-4M63B"
    }
    # Windows Server 2019
    'Microsoft Windows Server 2019 Datacenter' {
        $kmskey = "WMDGN-G9PQG-XVVXX-R3X43-63DFG"
    }
    'Microsoft Windows Server 2019 Standard' {
        $kmskey = "N69G4-B89J2-4G8F4-WWYCC-J464C"
    }
    'Microsoft Windows Server 2019 Essentials' {
        $kmskey = "WVDHN-86M7X-466P6-VHXV7-YY726"
    }
}

if ( $KeyCheckMode -eq 0 ) {
    if ( $AuzreKMSUse -eq 1 ) {
        write-host "### KMS Server Change (Azure)"
        Invoke-Expression "$env:windir\system32\cscript.exe $env:windir\system32\slmgr.vbs /skms kms.core.windows.net:1688"
    }

    write-host "### Insert KMS Key"
    Invoke-Expression "$env:windir\system32\cscript.exe $env:windir\system32\slmgr.vbs /ipk $kmskey"

    write-host "### KMS Key Activation"
    sleep 10
    Invoke-Expression "$env:windir\system32\cscript.exe $env:windir\system32\slmgr.vbs /ato"
    Read-Host -Prompt "Press any key to continue"       
}
else {
    write-host ""
    write-host "#########################################################"
    write-host "###########           KEY CHECK MODE          ###########"
    write-host "########### KMS NOT ACTIVATE, JUST KEY CHECK  ###########"
    write-host "#########################################################"
    write-host "OSName  : " $OsName
    write-host "KMS Key : " $kmskey
}