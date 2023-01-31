$ipAddresses = Get-Content .\servers.txt
$pingResults = @()

foreach ($ip in $ipAddresses) {
  $ping = Test-Connection -ComputerName $ip -Count 1 -ErrorAction SilentlyContinue

  if ($ping) {
      $pingResults += New-Object PSObject -Property @{
      Hostname = $ip
      Response = "Success"
    }
  } else {
	  $pingResults += New-Object PSObject -Property @{
      Hostname = $ip
      Response = "Failure"
    }
  }
}
$pingResults | Export-Csv .\ping_results.csv -NoTypeInformation
