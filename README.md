# Random Video Segment Extractor

A PowerShell script extracts random segments from a given video, concatenates them, and outputs a new video file. The user can specify the number of segments to extract and the duration of each segment. The resulting video is saved in `.mkv` format.

## Prerequisites

- **FFmpeg**: This script relies on FFmpeg and ffprobe for video manipulation. Ensure these tools are installed and available in your system's PATH.
  - `winget install ffmpeg`

## Usage

You can run the script with the following parameters:

- **`$InputVideo`** (string): Path to the input video file.
- **`$SegmentCount`** (int): The number of segments to extract (default: 10).
- **`$SegmentDuration`** (int): The duration of each segment in seconds (default: 15).

### Example Usage

```powershell
.\sampler.ps1 video.mp4
```

```powershell
.\sampler.ps1 -InputVideo "C:\path\to\video.mp4" -SegmentCount 5 -SegmentDuration 10
```

