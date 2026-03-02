$Ns   = @(256, 384, 512, 768, 1024, 1280, 1536, 1792, 2048)
$reps = 3
$csv  = "timings.csv"
"n,rep,time_s" | Set-Content $csv -Encoding ascii

foreach ($n in $Ns) {
  for ($r = 1; $r -le $reps; $r++) {
    $out = (& .\matMulSeq.exe $n 2>&1 | Out-String)
    $m = [regex]::Match($out, 'Calculation time:\s+([0-9]*\.?[0-9]+)\s+seconds')
    if ($m.Success) {
      $t = $m.Groups[1].Value
      "$n,$r,$t" | Add-Content $csv -Encoding ascii
      Write-Host "n=$n rep=$r t=$t"
    } else {
      Write-Host "Parse failed for n=$n rep=$r"
    }
  }
}