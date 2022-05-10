# 기존 VM이 있고 해당 VM에 대해서 스냅샷 뜨고 스냅샷을 통해서 다른 구독으로 매니지드 디스크를 만드는 스크립트

# Sripts start ready
$time = (Get-Date).toString("yyyyMMdd_HHmmss")

$path = 'C:\work\'

$logpath = $path + $time + '_run.log'
$filepath = $path + 'vmlist.csv'
$location = 'koreacentral'
Start-Transcript $logpath

# screen clear
cls

# var
$SubMigrate = ''
$SubProd = ''
$Tenant = ''
$RgProd = 'test-rg2'

# Az Login
Connect-AzAccount -TenantId $Tenant -Subscription $SubMigrate
Set-AzContext -Subscription $SubMigrate

# Get-AzSubscription

$MgVms = Import-CSV $filepath -delimiter "," 

write-host "########### START ###########" $time

ForEach ($MgVm in $MgVms){
    # Migrate VM Stop

    Write-Host "`n`n## Start" $vm.VMName "VM stop check ##"
    $VmStatus = (get-azvm -Name $MgVm.VmName -ResourceGroupName $MgVm.RgMigrate -Status).Statuses[1].DisplayStatus
    Write-Host $MgVm.VMName 'VM status check :'  $VmStatus
    if($VmStatus -eq 'VM running'){
        Write-Host $MgVm.VMName 'VM stopping'
        $VmStopStatus = (Stop-AzVM -Name $MgVm.VmName -ResourceGroupName $MgVm.RgMigrate -Force).Status
        if($VmStopStatus -eq 'Succeeded'){
            Write-Host $MgVm.VMName 'VM stop succeeded'
        }else{
            Write-Host $MgVm.VMName 'VM stop failed, script exit, Manaul check VM status'
            exit
        }
    }else{
        Write-Host $MgVm.VMName 'VM is already stop or another status, Manaul check status'
        exit
    }

    # VM create disk snapshot
    Write-Host "`n`n## Start " $MgVm.VMName " VM create disk snapshot ##"
    $SnapshotName = $MgVm.VMName + '-ss'
    $vm = Get-AzVM `
        -ResourceGroupName $MgVm.RgMigrate `
        -Name $MgVm.VMName
    $snapshot =  New-AzSnapshotConfig `
        -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id `
        -Location $location `
        -CreateOption copy
    New-AzSnapshot `
        -Snapshot $snapshot `
        -SnapshotName $snapshotName `
        -ResourceGroupName $MgVm.RgMigrate
    # Get-AzSnapshot `
    #     -ResourceGroupName $MgVm.RgMigrate


    # create managed disk from snapshot
    Write-Host "`n`n## Start " $MgVm.VMName " VM create managed disk from snapshot ##"

    $DiskNameOS = $MgVm.VMName + "_OsDisk_1"
 
    $snapshotinfo = Get-AzSnapshot -ResourceGroupName $MgVm.RgMigrate -SnapshotName $snapshotName
    Set-AzContext -Subscription $SubProd
    New-AzDisk -DiskName $DiskNameOS `
        (New-AzDiskConfig  `
            -Location $Location `
            -CreateOption Copy `
            -SourceResourceId $snapshotinfo.Id `
            -SkuName Standard_LRS) `
        -ResourceGroupName $RgProd

    # # create prod VM
    # Write-Host "`n`n## Start " $MgVm.VMName " create prod VM ##"

}
write-host "########### END ###########"
