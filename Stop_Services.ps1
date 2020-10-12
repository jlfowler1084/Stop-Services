$ErrorActionPreference = 'Continue'
$Date = (Get-Date -Format "yyyy-MM-dd HH.mm")
$Time = (Get-Date -Format "dddd MM/dd/yyyy HH:mm -K")
$Logfile = "Enter Log file here"

$AderantAppServers = @('Server01',
                       'Server02',
                       'Server03',
                       'Server04')

$SmartTimeServers = @('Server05')

$AderantAppServices = @(                        
                        'Service01',
                        'Service02',
                        'Service03',
                        'Service04'
                        'Service05'                       
                        )

$SmartTimeServices = @('Service06')

Write-Host "Attempting to stop Aderant services and set startup type to Disabled" -ForegroundColor Green
Add-Content $Logfile "$ENV:Username initiated StopAderantServicesProd.ps1 - Will attempt to stop Aderant Services $Time"

foreach ($AppServer in $AderantAppServers) {
    Foreach ($AppService in $AderantAppServices){
        $AppServerConnection = Test-Connection -ComputerName $AppServer -Count 1 -Quiet
        IF ($AppServerConnection -eq $True ) {
        Try {
                Write-Host "Stopping $AppService Service on $AppServer and Setting Startup Type to Disabled" -ForegroundColor Green             
                Get-Service -ComputerName $Appserver -Name $AppService | Stop-Service -ErrorAction stop
                Set-Service -ComputerName $AppServer -Name $AppService -StartupType Disabled -ErrorAction Stop
                Add-content $logfile "Stopped $AppService Service on $AppServer and Setting Startup Type to Disabled $Time"
            } Catch {
                write-host $error[0].Exception
                Add-Content $Logfile $Error[0].Exception
            } Finally {}
            } Else {
                Write-host "$AppServer Not online, unable to stop $AppService" -ForegroundColor Red
                Add-Content $Logfile "$AppServer is offline, unable to stop $AppService $Time"
            }
        }
    }
            

Start-Sleep -Seconds 5

foreach ($SmartTimeServer in $SmartTimeServers) {
    Start-Sleep -Seconds 5
    Foreach ($SmartTimeService in $SmartTimeServices){
        $SmartTimeServerConnection = Test-Connection -ComputerName $SmartTimeServer -Count 1 -Quiet
        IF ($SmartTimeServerConnection -eq $True ) {
        Try {
            write-host "Stopping $SmartTimeService Service on $SmartTimeServer and Setting Startup Type to Disabled" -ForegroundColor Green
            Get-Service -ComputerName $SmartTimeServer -Name $SmartTimeService | Stop-Service -erroraction stop
            Set-Service -ComputerName $SmartTimeServer -Name $SmartTimeService -StartupType Disabled -erroraction stop
            Add-content $logfile "Stopped $SmartTimeService Service on $SmartTimeServer and Setting Startup Type to Disabled $Time"
            } Catch {
                write-host $error[0].Exception
                Add-Content $Logfile $Error[0].Exception
            } Finally {}
            } Else {
                Write-host "$SmartTimeServer Not online, Unable to stop $SmartTimeService" -ForegroundColor Red
                Add-Content $Logfile "$SmartTimeServer is offline, unable to stop $SmartTimeService $Time"
            }
        }
    }


         
 Add-Content $Logfile "Operation Complete $Time"
 write-host "Operation Complete - Please confirm applicable services have been stopped with the startup type set to disabled" -ForegroundColor Green        
  
