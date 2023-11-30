#I'm not 100% sure what I'm meant to do since I'm not familiar with ssh. Since the server in the video 
#doesn't work and I don't have or know how to make my own the program just breaks.
$address = read-host "Please enter the SSH server address:"

$port = read-host "Please enter the SSH server port (default is 22):"

# where-object wasn't working so I changed it to an if, I'm not really sure if it does the same thing.
if (([string]::IsNullOrEmpty($port)))
{
    $port = 22
}

# Get the credentials
$credential = Get-Credential -Message "Please enter your SSH credentials"

# Create an SSH session
# I dont think this is running the way it was intended? It looks like it should just input everything 
# for the user without opening the sshsession window.
$session = New-SSHSession -ComputerName $serverAddress -Port $serverPort -Credential $credential

if ($session.Connected) {
    Write-Host "SSH session established! Commands can now be executed on the remote server."

    while ($true) {

        $the_cmd = read-host -prompt "Enter a command to execute on the server (type 'exit' to end the session):"
        
        if ($command -eq "exit") {
            break
        }

        $result = Invoke-SSHCommand -SSHSession $session -Command $command
        Write-Host $result.Output -ForegroundColor Green
    }

    $localFile = Read-Host "Enter the path of the local file you'd like to upload:"

    $remotePath = Read-Host "Enter the remote path where you'd like to upload the file:"
    
    #securley transfer a local file to the specified remote host path.
    Set-SCPFile -ComputerName $address -Credential $credential -RemotePath $remotePath -LocalFile $localFile

    # Close the SSH session
    Remove-SSHSession -SSHSession $session
    Write-Host "SSH session closed."
} else {
    Write-Host "Failed to establish an SSH session. Please check the server address, port, and credentials, then try again."
}
