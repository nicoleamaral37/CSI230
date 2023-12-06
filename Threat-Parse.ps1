$input = read-host "
[I]PTables
[W]indows
Choose a ruleset"
$drop_urls = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules', 'https://rules.emergingthreats.net/blockrules/compromised-ips.txt')

foreach ($u in $drop_urls)
{
    $temp = $u.split("/")
    $fileName = $temp[-1]
    
    if( Test-Path $fileName)
    {
        continue
    }
    else
    {
        Invoke-WebRequest -Uri $u -OutFile $fileName
    }
}

$inputPaths = @('.\compromised-ips.txt', '.\emerging-botcc.rules')

$regexDrop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

        Select-String -path $inputPaths -Pattern $regexDrop |`
        ForEach-Object {$_.Matches } |`
        ForEach-Object {$_.value } | Sort-Object | Get-Unique |
        Out-File -FilePath "ips-bad.tmp"

switch ($input)
{
    i 
    {
        (Get-Content -Path ".\ips-bad.tmp") | % `
        {$_ -replace "^", "iptables -A INPUT -s " -replace "$", " -j DROP"} |`
        Out-File -FilePath "iptables.bash"
    }

    w
    {
        (Get-Content -Path ".\ips-bad.tmp") | % `
        {$_ -replace "^", "netsh advfirewall firewall add rule name= 'BLOCK IP ADDRESS - 
        'dir=in action=block remoteip="} |`
        Out-File -FilePath "windowsRuleset.bash"
    }
    
}



