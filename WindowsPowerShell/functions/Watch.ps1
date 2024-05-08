function watch($seconds, $cmd){
    while ($true){
        Clear-Host
        Write-Host -ForegroundColor Green 'Every ' $seconds ' second(s) do: ' $cmd
        Invoke-Expression $cmd
        Start-Sleep $seconds
    }
}