
function menu()
{
    cls
    write-host -BackgroundColor blue -ForegroundColor white "
[R]unning Processes
[S]ervices
[T]CP network sockets
[U]ser account information
[N]etworkAdapterConfiguration information
[L]ocal configuration manager settings
[V]PN
[C]omputer info
[D]NS server IP addresses
[Z]ip file creation
[Q]uit"

    
    $readSelection = read-host -Prompt "Please select one of the options above: "

    
    if ($readSelection -match "^[qQ]$")
    {
        break
    }

   $readPath = read-host -prompt "Enter directory to store results in: "

   while(-not(Test-Path $readPath -IsValid))
   {
        write-host "invalid path"
        $readPath = read-host -prompt "Enter directory to store results in: "
   }



    processing -selection $readSelection -path $readPath
    hash -path $readPath

}


function processing ()
{
Param([string]$selection, [string] $path)

   
    if($selection -match "^[rR]$")
    {
        Get-Process | Select-object ProcessName, Path, ID | `
        Export-Csv -Path "$path" -NoTypeInformation
    }

    elseif($selection -match "^[sS]$")
    {
        Gwmi win32_service |`
        select DisplayName, PathName |`
        Export-Csv -Path "$path" -NoTypeInformation
    }

    elseif($selection -match "^[tT]$")
    {
        Get-NetTCPConnection |`
        Export-Csv -Path "$path" -NoTypeInformation
    }

    elseif($selection -match "^[uU]$")
    {
        gwmi win32_UserProfile |`
        Export-Csv -Path "$path" -NoTypeInformation
    }

    elseif($selection -match "^[nN]$")
    {
        gwmi win32_networkadapterconfiguration |`
        Export-Csv -Path "$path" -NoTypeInformation
    }

    #Honestly not sure, the info just looked interesting
    elseif($selection -match "^[lL]$")
    {
        Get-DscLocalConfigurationManager |`
        Export-Csv -Path "$path" -NoTypeInformation
    }

    #It might be helpful to know what VPN's the computer has access to
    elseif($selection -match "^[vV]$")
    {
        Get-VpnConnection  |`
        Export-Csv -Path "$path" -NoTypeInformation
    }

    #Other aspects of get-computerinfo might have been more useful but I didn't want to put my info out there
    elseif($selection -match "^[cC]$")
    {
        Get-ComputerInfo "*version"  |`
        Export-Csv -Path "$path" -NoTypeInformation
    }
    #Again, not sure, the info just looked interesting
    elseif($selection -match "^[dD]$")
    {
        gwmi win32_networkadapterconfiguration |`
        Export-Csv -Path "$path" -NoTypeInformation
    }

    elseif($selection -match "^[zZ]$")
    {
        $toBeZipped = read-host -prompt "Enter directory to zip: "
        while(-not(Test-Path $readPath -IsValid))
        {
            write-host "invalid path"
            $toBeZipped = read-host -prompt "Enter directory to zip: "
        }

        $compress = @{
        Path = "$toBeZipped"
        CompressionLevel = "Fastest"
        DestinationPath = "$path" + "\theZip.zip"
        }

        Compress-Archive @compress -update
        hash
     }

    else
    {
        write-host "invalid entry"
        sleep 2
        menu
    }

    hash
    write-host "Writing complete"
    sleep 3
    menu

}


function hash()
{
    if($selection -match "^[zZ]$")
    {
        Get-FileHash "$path" |`
        Export-Csv -Path "C:\Users\nicol\Documents\Incident Response Toolkit PARENT\ChecksumsOfZip.csv" -NoTypeInformation
    }
    else
    {
        Get-FileHash "$path" |`
        Export-Csv -Path "C:\Users\nicol\Documents\Incident Response Toolkit PARENT\Incident Response Toolkit\Checksums.csv" -NoTypeInformation -append
    }


}

menu