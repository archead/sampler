param (
    [string]$InputVideo,
    [int]$SegmentCount = 10,
    [int]$SegmentDuration = 15
)

$outputVideo = (Get-Item $InputVideo).Basename + "_sample.mkv"
$tempFolder = "temp_segments"

# Ensure the temporary folder exists
if (-Not (Test-Path $tempFolder)) {
    New-Item -ItemType Directory -Path $tempFolder | Out-Null
}

# Get the duration of the video using ffprobe
$videoDuration = (ffprobe -i $InputVideo -show_entries format=duration -v quiet -of csv="p=0").Trim()
if (-Not [double]::TryParse($videoDuration, [ref]$null)) {
    Write-Error "Failed to retrieve video duration. Ensure the input file is valid."
    exit 1
}

# Ensure the temporary folder is empty
Get-ChildItem -Path $tempFolder -Recurse | Remove-Item -Force -Recurse

# Randomly extract segments
$random = New-Object System.Random
$segmentPaths = @()
for ($i = 0; $i -lt $SegmentCount; $i++) {
    $startTime = [math]::Floor($random.NextDouble() * ($videoDuration - $SegmentDuration))
    $segmentPath = Join-Path $tempFolder ("segment_$i.mkv")
    ffmpeg -y -ss $startTime -i $InputVideo -t $SegmentDuration -c copy $segmentPath | Out-Null
    $segmentPaths += ("segment_$i.mkv") # Store relative segment name
}

# Create a text file listing the segments for concatenation
$concatFile = Join-Path $tempFolder "concat_list.txt"
$segmentPaths | ForEach-Object { "file '\$_'" } | Set-Content -Path $concatFile

# Concatenate the segments
ffmpeg -y -f concat -safe 0 -i $concatFile -c copy $outputVideo | Out-Null

# Cleanup temporary folder
Remove-Item -Path $tempFolder -Recurse -Force

Write-Host "Random segments have been concatenated and saved to $outputVideo"
