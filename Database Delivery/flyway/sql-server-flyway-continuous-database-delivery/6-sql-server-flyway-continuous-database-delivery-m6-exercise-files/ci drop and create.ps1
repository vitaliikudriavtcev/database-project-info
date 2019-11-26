$ErrorActionPreference = 'Stop'

Push-Location; Import-Module sqlps -DisableNameChecking; Pop-Location

$serverPath = "SQLSERVER:\SQL\localhost\Default"
$databaseName = "payroll_ci"

$databasePath = join-path $serverPath "Databases\$databaseName"
if(Test-Path $databasePath)
{
        Invoke-SqlCmd "USE [master]; ALTER DATABASE [$databaseName] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [$databaseName]"
}
Invoke-SqlCmd "CREATE DATABASE [$databaseName]"

flyway -configFile="conf\ci.conf" migrate
if ($LastExitCode -ne 0) {
    throw "flyway migrate failed with exit code $LastExitCode."
}