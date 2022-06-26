Login-PowerBIServiceAccount

[datetime]$getenddate = Get-Date
[datetime]$getstartdate = (Get-Date $getenddate).AddDays(-30)

$enddate = Get-Date $getenddate -format "yyyy-MM-dd"
$startdate = Get-Date $getstartdate -format "yyyy-MM-dd"

$difference = New-TimeSpan -Start $getstartdate -End $getenddate
$days = [Math]::Ceiling($difference.TotalDays)

$activityEvents = @()

1..$days | ForEach-Object {
  $getstartdate = $getstartdate.AddDays(1)
  $startdate = Get-Date $getstartdate -format "yyyy-MM-dd"
  $startdate
  $activityevent = (Get-PowerBIActivityEvent -EndDateTime "$($startdate)T23:59:59" -StartDateTime "$($startdate)T00:00:00" -ResultType JsonString | ConvertFrom-Json)
  $activityEvents += $activityevent
}

$activityEvents | Select-Object * | Export-Csv -NoTypeInformation -Path "$(Get-Location)\Get-ActivityEvents.csv"