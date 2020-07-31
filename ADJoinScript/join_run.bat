@echo off
mkdir c:\join
copy * c:\join
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""C:\join\ADjoinscripts.ps1""' -Verb RunAs}" 
pause
