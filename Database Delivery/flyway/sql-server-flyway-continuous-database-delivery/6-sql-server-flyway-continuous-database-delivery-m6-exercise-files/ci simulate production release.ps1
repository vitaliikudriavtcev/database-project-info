$ErrorActionPreference = 'Stop'

Push-Location; Import-Module sqlps -DisableNameChecking; Pop-Location

$serverPath = "SQLSERVER:\SQL\localhost\Default"
$databaseName = "payroll_simulate_prod"
$sourceDatabaseName = "payroll"
$restoreFrom = "C:\backups\payroll\prod.bak"

$databasePath = join-path $serverPath "Databases\$databaseName"
if(Test-Path $databasePath)
{
        Write-Host "Deleting database $databaseName"
        Invoke-SqlCmd "USE [master]; ALTER DATABASE [$databaseName] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [$databaseName]"
}

$server = Get-Item $serverPath
$dataFilePath = join-path $server.Information.MasterDBPath "$databaseName.mdf"
$logFilePath = join-path $server.Information.MasterDBPath "$($databaseName)_log.ldf"
$files = @()
$files += New-Object Microsoft.SqlServer.Management.Smo.RelocateFile($sourceDatabaseName, $dataFilePath)
$files += New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("$($sourceDatabaseName)_log", $logFilePath)
Write-Host "Relocating database files to:"
$files | Format-List

Write-Host "Restoring last production backup"
Restore-SqlDatabase -Path $serverPath -Database $databaseName -BackupFile $restoreFrom -RelocateFile $files

Write-Host "Applying latest migrations to the production backup"
flyway -configFile="conf\simulate_prod.conf" migrate
if ($LastExitCode -ne 0) {
    throw "flyway migrate failed with exit code $LastExitCode."
}