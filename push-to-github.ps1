# 🚀 一键推送到 GitHub
# Instructions: Replace YOUR_USERNAME below with your actual GitHub username

$YOUR_GITHUB_USERNAME = "YourUsername"  # 👈 REPLACE THIS WITH YOUR GITHUB USERNAME!
$REPO_NAME = "emby-gpui-client"

if ($env:GITHUB_TOKEN) {
    $REPO_URL = "https://x-access-token:`$env:GITHUB_TOKEN@github.com/$YOUR_GITHUB_USERNAME/$REPO_NAME.git"
} else {
    $REPO_URL = "https://github.com/$YOUR_GITHUB_USERNAME/$REPO_NAME.git"
}

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "📤 Pushing to GitHub Repository..." -ForegroundColor Yellow
Write-Host "Repository: $REPO_URL" -ForegroundColor Gray
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Stage all files
git add .
Write-Host "[✓] Files staged" -ForegroundColor Green

# Create commit
git commit -m "Initial Emby GPUI Client project with complete architecture" -allow-empty
Write-Host "[✓] Changes committed" -ForegroundColor Green

# Set branch name
git branch -M main
Write-Host "[✓] Branch renamed to 'main'" -ForegroundColor Green

# Remove old remote if exists
git remote remove origin 2>$null
Write-Host "[✓] Removed old remote (if any)" -ForegroundColor Green

# Add new remote
git remote add origin $REPO_URL
Write-Host "[✓] Remote configured" -ForegroundColor Green

# Force push to main branch
Write-Host ""
Write-Host "🚀 Pushing to GitHub..." -ForegroundColor Yellow
try {
    git push -u origin main --force
    
    Write-Host ""
    Write-Host "✅ SUCCESS!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🌐 Your repository is now live at:" -ForegroundColor Cyan
    Write-Host "   https://github.com/$YOUR_GITHUB_USERNAME/$REPO_NAME" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "🎯 Next steps:" -ForegroundColor Yellow
    Write-Host "   1. Visit the repository URL above" -ForegroundColor Gray
    Write-Host "   2. Go to 'Actions' tab" -ForegroundColor Gray
    Write-Host "   3. Wait for CI/CD pipeline to run (5-10 minutes)" -ForegroundColor Gray
    Write-Host "   4. Download artifact from Actions → Downloads" -ForegroundColor Gray
    Write-Host ""
} catch {
    Write-Host "❌ Push failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Try running manually in PowerShell:" -ForegroundColor Yellow
    Write-Host "  git push -u origin main --force" -ForegroundColor White
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")