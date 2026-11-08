# Check Windows Build Status
Write-Host "🔍 Checking GitHub Actions build status..." -ForegroundColor Cyan

$REPO_OWNER = "228659"
$REPO_NAME = "emby-gpui-client"
$WORKFLOW_NAME = "Build Windows Release"

Write-Host ""
Write-Host "🌐 Repository: https://github.com/$REPO_OWNER/$REPO_NAME/actions" -ForegroundColor Yellow
Write-Host ""

# Check for recent workflow runs (requires authentication)
# For now, just show instructions

Write-Host "📋 Instructions:" -ForegroundColor Green
Write-Host "1. Open: https://github.com/$REPO_OWNER/$REPO_NAME/actions" -ForegroundColor White
Write-Host "2. Click 'Build Windows Release' workflow" -ForegroundColor White
Write-Host "3. Click 'Run workflow' button if not started yet" -ForegroundColor White
Write-Host "4. Wait ~5-8 minutes for build to complete" -ForegroundColor White
Write-Host "5. Download artifact from 'Artifacts' section" -ForegroundColor White

Write-Host ""
Write-Host "⏱️ Estimated time remaining: 5-10 minutes" -ForegroundColor Magenta
Write-Host ""
Read-Host "Press Enter to exit"