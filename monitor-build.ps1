# Monitor GitHub Actions Build Status
$REPO_OWNER = "228659"
$REPO_NAME = "emby-gpui-client"
$API_URL = "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/actions/runs"

Write-Host "🔍 Monitoring build status..." -ForegroundColor Cyan
Write-Host ""

# Get recent workflow runs (requires authentication)
try {
    $response = Invoke-RestMethod -Uri "$API_URL?per_page=5" -Headers @{
        "Authorization" = "Bearer $env:GITHUB_TOKEN"
    }
    
    $runs = $response.workflow_runs
    
    if ($runs.Count -eq 0) {
        Write-Host "⚠️ No recent builds found." -ForegroundColor Yellow
        Write-Host "Please manually trigger: https://github.com/$REPO_OWNER/$REPO_NAME/actions/workflows/windows-only.yml" -ForegroundColor Cyan
        exit
    }
    
    foreach ($run in $runs) {
        Write-Host "Build: $($run.name)" -ForegroundColor White
        Write-Host "Status: $($run.status)" -ForegroundColor $(if($run.status -eq 'completed'){'Green'} else {'Yellow'})
        Write-Host "Conclusion: $($run.conclusion)" -ForegroundColor $(if($run.conclusion -eq 'success'){'Green'} elseif($run.conclusion -eq 'failure'){'Red'} else {'White'})
        Write-Host "Time: $([datetime]::.Parse($run.created_at).ToString('yyyy-MM-dd HH:mm:ss'))" -ForegroundColor Gray
        Write-Host "---" -ForegroundColor Gray
    }
} catch {
    Write-Host "❌ Unable to fetch build status via API" -ForegroundColor Red
    Write-Host ""
    Write-Host "Alternative: Visit https://github.com/$REPO_OWNER/$REPO_NAME/actions" -ForegroundColor Cyan
}