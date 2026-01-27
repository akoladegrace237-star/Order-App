# Simple PowerShell Web Server for Mini Order App
# Run this script to make your app accessible on mobile/iPad

$port = 8080
$path = Get-Location

Write-Host "Starting Mini Order App Server..." -ForegroundColor Green
Write-Host "Serving from: $path" -ForegroundColor Cyan

# Get local IP address
try {
    $localIP = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Wi-Fi*" | Where-Object {$_.IPAddress -like "192.168.*" -or $_.IPAddress -like "10.*" -or $_.IPAddress -like "172.*"})[0].IPAddress
} catch {
    $localIP = $null
}

if (-not $localIP) {
    try {
        $localIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*"})[0].IPAddress
    } catch {
        $localIP = "localhost"
    }
}

Write-Host ""
Write-Host "🌐 Access your app from any device on your network:" -ForegroundColor Yellow
Write-Host "   Computer: http://localhost:$port/mini-order-app.html" -ForegroundColor White
Write-Host "   Mobile/iPad: http://$localIP`:$port/mini-order-app.html" -ForegroundColor White
Write-Host ""
Write-Host "📱 On your mobile/iPad:" -ForegroundColor Magenta
Write-Host "   1. Make sure you're on the same Wi-Fi network" -ForegroundColor White
Write-Host "   2. Open a web browser (Safari/Chrome)" -ForegroundColor White
Write-Host "   3. Type the Mobile/iPad URL above" -ForegroundColor White
Write-Host ""
Write-Host "⏹️  Press Ctrl+C to stop the server" -ForegroundColor Red
Write-Host ""

# Create HTTP listener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://+:$port/")

try {
    $listener.Start()
    Write-Host "✅ Server started successfully!" -ForegroundColor Green

    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        # Get requested file path
        $localPath = $request.Url.LocalPath.TrimStart('/')
        if ([string]::IsNullOrEmpty($localPath)) {
            $localPath = "mini-order-app.html"
        }
        
        $filePath = Join-Path $path $localPath
        
        Write-Host "📥 Request: $($request.HttpMethod) $($request.Url.LocalPath) from $($request.RemoteEndPoint.Address)" -ForegroundColor Gray
        
        if (Test-Path $filePath -PathType Leaf) {
            # Determine content type
            $contentType = "text/html"
            $extension = [System.IO.Path]::GetExtension($filePath).ToLower()
            switch ($extension) {
                ".html" { $contentType = "text/html" }
                ".css" { $contentType = "text/css" }
                ".js" { $contentType = "application/javascript" }
                ".json" { $contentType = "application/json" }
                ".png" { $contentType = "image/png" }
                ".jpg" { $contentType = "image/jpeg" }
                ".jpeg" { $contentType = "image/jpeg" }
                ".gif" { $contentType = "image/gif" }
                ".ico" { $contentType = "image/x-icon" }
            }
            
            # Set headers to prevent caching during development
            $response.Headers.Add("Cache-Control", "no-cache, no-store, must-revalidate")
            $response.Headers.Add("Pragma", "no-cache")
            $response.Headers.Add("Expires", "0")
            
            $response.ContentType = $contentType
            $response.StatusCode = 200
            
            $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
            $response.ContentLength64 = $fileBytes.Length
            $response.OutputStream.Write($fileBytes, 0, $fileBytes.Length)
        } else {
            # File not found
            $response.StatusCode = 404
            $response.ContentType = "text/html"
            $notFoundHtml = @"
<!DOCTYPE html>
<html>
<head>
    <title>404 - File Not Found</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; background: #f5f5f5; }
        .error { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); max-width: 500px; margin: 0 auto; }
        .error h1 { color: #e74c3c; margin-bottom: 20px; }
        .error a { color: #3498db; text-decoration: none; font-weight: bold; }
        .error a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="error">
        <h1>404 - File Not Found</h1>
        <p>The requested file was not found on this server.</p>
        <p><a href="/mini-order-app.html">🍰 Go to Mini Order App</a></p>
    </div>
</body>
</html>
"@
            $notFoundBytes = [System.Text.Encoding]::UTF8.GetBytes($notFoundHtml)
            $response.ContentLength64 = $notFoundBytes.Length
            $response.OutputStream.Write($notFoundBytes, 0, $notFoundBytes.Length)
        }
        
        $response.OutputStream.Close()
    }
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Message -like "*access*denied*" -or $_.Exception.Message -like "*permission*") {
        Write-Host ""
        Write-Host "🔧 Fix: Run PowerShell as Administrator, or try a different port" -ForegroundColor Yellow
        Write-Host "   Right-click PowerShell -> 'Run as Administrator'" -ForegroundColor White
    }
} finally {
    if ($listener.IsListening) {
        $listener.Stop()
    }
    Write-Host ""
    Write-Host "⏹️  Server stopped." -ForegroundColor Yellow
}