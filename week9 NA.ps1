#running processes
Get-Process | Select-object ProcessName, Path, ID | `
Export-Csv -Path "C:\users\nicol\Desktop\myProcess.csv" -NoTypeInformation

#running services
Get-Service | Where { $_.status -eq "Running" } |`
Export-Csv -Path "C:\users\nicol\Desktop\myService.csv" -NoTypeInformation

# Get the DHCP server IP. 
ipconfig /all | Select-String -Pattern "DHCP Server"
# Get the DNS server IP.
ipconfig /all | Select-String -Pattern "\d\.\d\.\d\.\d"

#Open/close Calculator
start-process C:\Windows\System32\calc.exe
Start-Sleep -Seconds 1
Stop-Process -Name CalculatorApp


#other stuff, just playing around

#Get-WmiObject -Class Win32_service | select Name, PathName, ProcessId

#Get-WmiObject -list | where { $_.Name -like "win32_[n-o]*" } | sort-object

#Get-WmiObject -Class win32_Account | Get-Member

#Get-WmiObject -Class win32_networkadapterconfiguration | where { $_.IPAddress -like "IPAddress"}

#Get-WmiObject Win32_NetworkAdapterConfiguration -Filter "DHCPEnabled=$true"| select DHCPServer, DefaultGateway, DNSDomain, IPAddress
