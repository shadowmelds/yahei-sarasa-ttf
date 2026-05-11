# Check for Administrator privileges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Please run this script as Administrator!" -ForegroundColor Red
    pause
    exit
}

$path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink"

function Move-MSYHToTop {
    param([string]$fontName)
    try {
        $val = Get-ItemProperty -Path $path -Name $fontName -ErrorAction SilentlyContinue
        if ($null -eq $val) { return }

        $currentValues = $val | Select-Object -ExpandProperty $fontName
        
        # 1. Extract (Cut) all lines containing MSYH exactly as they are
        $msyhLines = $currentValues | Where-Object { $_ -match "MSYH" }
        
        # 2. If no MSYH lines exist, do nothing and skip
        if ($null -eq $msyhLines -or $msyhLines.Count -eq 0) {
            Write-Host "SKIPPED: No MSYH found in $fontName" -ForegroundColor Gray
            return
        }

        # 3. Get the remaining lines (those without MSYH)
        $remainingLines = $currentValues | Where-Object { $_ -notmatch "MSYH" }
        
        # 4. Combine: MSYH lines at top + remaining lines below
        # This keeps your original parameters like 128,96 or others intact.
        $newValues = @($msyhLines) + @($remainingLines)
        
        # 5. Write back to Registry
        Set-ItemProperty -Path $path -Name $fontName -Value $newValues
        Write-Host "SUCCESS: MSYH lines moved to top for -> $fontName" -ForegroundColor Green
    }
    catch {
        Write-Host "FAILED: Error processing $fontName" -ForegroundColor Red
    }
}

Write-Host "Starting REAL Cut & Paste Optimization (Preserving original parameters)..." -ForegroundColor Cyan

# Handle manual targets
$manualFonts = @("Segoe UI", "Tahoma", "Microsoft Sans Serif")
foreach ($f in $manualFonts) {
    Move-MSYHToTop $f
}

# Handle dynamic Segoe UI Variable targets
$regKey = Get-Item -Path $path
$segoeVariants = $regKey.GetValueNames() | Where-Object { $_ -like "Segoe UI Variable*" }

foreach ($variant in $segoeVariants) {
    Move-MSYHToTop $variant
}

Write-Host "`nDone! All original MSYH configurations have been moved to the top." -ForegroundColor White
pause