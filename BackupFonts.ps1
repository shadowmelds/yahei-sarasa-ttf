# Define the backup directory name
$BackupDir = Join-Path -Path $PSScriptRoot -ChildPath "fonts_backup"
$SystemFontsDir = "C:\Windows\Fonts"

# Create the backup directory if it doesn't exist
if (-not (Test-Path -Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir | Out-Null
    Write-Host "Created backup folder: $BackupDir" -ForegroundColor Cyan
}

# Get all .ttf and .ttc files in the current script directory
$LocalFonts = Get-ChildItem -Path $PSScriptRoot -File | Where-Object { $_.Extension -match '^\.tt[cf]$' }

if ($null -eq $LocalFonts -or $LocalFonts.Count -eq 0) {
    Write-Host "No .ttf or .ttc files found in the current directory." -ForegroundColor Yellow
    exit
}

Write-Host "Starting backup process for $(@($LocalFonts).Count) potential fonts..." -ForegroundColor White

foreach ($Font in $LocalFonts) {
    $FontName = $Font.Name
    $SystemFontPath = Join-Path -Path $SystemFontsDir -ChildPath $FontName

    # Check if the font exists in the Windows Fonts directory
    if (Test-Path -Path $SystemFontPath) {
        $DestinationPath = Join-Path -Path $BackupDir -ChildPath $FontName
        
        try {
            Copy-Item -Path $SystemFontPath -Destination $DestinationPath -Force -ErrorAction Stop
            Write-Host "Successfully backed up: $FontName" -ForegroundColor Green
        }
        catch {
            Write-Host "Failed to backup $FontName. It might be in use or access is denied." -ForegroundColor Red
        }
    }
    else {
        # Note: Windows Font directory can be picky about case sensitivity in some environments
        Write-Host "Skip: $FontName not found in $SystemFontsDir" -ForegroundColor Gray
    }
}

Write-Host "`nBackup process complete." -ForegroundColor Cyan