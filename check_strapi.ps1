# Check Strapi Installation Status
$ip = "3.128.55.15"

Write-Host "Checking Strapi installation on $ip..." -ForegroundColor Cyan
Write-Host ""

# Test port 1337
Write-Host "Testing port 1337..." -ForegroundColor Yellow
$portTest = Test-NetConnection -ComputerName $ip -Port 1337 -WarningAction SilentlyContinue

if ($portTest.TcpTestSucceeded) {
    Write-Host "Port 1337 is OPEN - Strapi is running!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Access your Strapi instance:" -ForegroundColor Green
    Write-Host "  Admin Panel: http://$ip`:1337/admin" -ForegroundColor Cyan
    Write-Host "  API Endpoint: http://$ip`:1337/api" -ForegroundColor Cyan
} else {
    Write-Host "Port 1337 is CLOSED - Strapi is still installing" -ForegroundColor Red
    Write-Host ""
    Write-Host "Installation typically takes 5-10 minutes." -ForegroundColor Yellow
    Write-Host "Please wait and run this script again in a few minutes." -ForegroundColor Yellow
}

Write-Host ""
$currentTime = Get-Date -Format "HH:mm:ss"
Write-Host "Current time: $currentTime" -ForegroundColor Gray
