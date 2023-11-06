
function select_service() 
{
    cls

    $services = Get-Service | where { $_.status -eq "Running" -or $_.status -eq "Stopped"} #for funsies
    $services | Out-Host

    $arrServices = @('all', 'stopped', 'running')

    $readService = read-host -Prompt "Please enter 'all' to view all services, 'running' to view running services, or 'stopped' to view stopped services, or 'q' to quit"

    if ($readService -match "^[qQ]$")
    {
        break
    }

    service_check -serviceToSearch $readService
}

function service_check()
{
    Param([string]$ServiceToSearch)

    if ( $arrServices -match $serviceToSearch)
    {
        write-host -BackgroundColor Green -ForegroundColor white "Please wait, it may take a few moments to retrieve specified services."
        sleep 2
        view_service -ServiceToSearch $serviceToSearch
    }
    else
    {
         write-host -BackgroundColor Red -ForegroundColor white "Specified service type doesn't exist ."
         sleep 2
         select_service
    }
}

function view_service()
{
    cls 

    if($serviceToSearch -eq "all")
    {
      get-service
    }

    elseif ($serviceToSearch -eq "running")
    {
        Get-Service | where { $_.status -eq "Running"}
    }

    elseif ($serviceToSearch -eq "stopped")
    {
        Get-Service | where { $_.status -eq "Stopped"}
    }

    read-host -Prompt "Press enter when you are finished."

    select_log

}

select_Log
