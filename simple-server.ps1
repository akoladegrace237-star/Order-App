# Simple Web Server for Mini Order App
$port = 3000
$path = Get-Location

Write-Host "Starting Mini Order App Server..." -ForegroundColor Green
Write-Host "Serving from: $path" -ForegroundColor Yellow

# Try to get local IP
$localIP = "localhost"
try {
    $networkAdapter = Get-NetAdapter | Where-Object {$_.Status -eq "Up" -and $_.Name -like "*Wi-Fi*"}
    if ($networkAdapter) {
        $ipConfig = Get-NetIPAddress -InterfaceIndex $networkAdapter.InterfaceIndex -AddressFamily IPv4 | Where-Object {$_.IPAddress -like "192.168.*"}
        if ($ipConfig) {
            $localIP = $ipConfig.IPAddress
        }
    }
} catch {
    # Fallback - try to get any non-loopback IP
    try {
        $localIP = (Test-Connection -ComputerName $env:COMPUTERNAME -Count 1).IPv4Address.IPAddressToString
    } catch {
        $localIP = "localhost"
    }
}

Write-Host ""
Write-Host "Access your app:" -ForegroundColor Cyan
Write-Host "  On this computer: http://localhost:$port/mini-order-app.html" -ForegroundColor White
if ($localIP -ne "localhost") {
    Write-Host "  On mobile/iPad: http://$localIP`:$port/mini-order-app.html" -ForegroundColor White
}
Write-Host ""
Write-Host "Make sure your mobile/iPad is on the same Wi-Fi network!" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Red
Write-Host ""

# Create listener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
if ($localIP -ne "localhost") {
    $listener.Prefixes.Add("http://$localIP`:$port/")
}

try {
    $listener.Start()
    Write-Host "Server started successfully!" -ForegroundColor Green

    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $localPath = $request.Url.LocalPath.TrimStart('/')
        if ([string]::IsNullOrEmpty($localPath)) {
            $localPath = "mini-order-app.html"
        }
        
        $filePath = Join-Path $path $localPath
        
        Write-Host "Request: $localPath from $($request.RemoteEndPoint.Address)" -ForegroundColor Gray
        
        if (Test-Path $filePath -PathType Leaf) {
            $contentType = "text/html"
            $extension = [System.IO.Path]::GetExtension($filePath).ToLower()
            switch ($extension) {
                ".html" { $contentType = "text/html; charset=utf-8" }
                ".css" { $contentType = "text/css" }
                ".js" { $contentType = "application/javascript" }
                ".json" { $contentType = "application/json" }
            }
            
            $response.ContentType = $contentType
            $response.StatusCode = 200
            $response.Headers.Add("Cache-Control", "no-cache")
            
            $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
            $response.ContentLength64 = $fileBytes.Length
            $response.OutputStream.Write($fileBytes, 0, $fileBytes.Length)
        } else {
            $response.StatusCode = 404
            $response.ContentType = "text/html"
            $notFound = "<h1>404 - File Not Found</h1><p><a href='/mini-order-app.html'>Go to Mini Order App</a></p>"
            $notFoundBytes = [System.Text.Encoding]::UTF8.GetBytes($notFound)
            $response.ContentLength64 = $notFoundBytes.Length
            $response.OutputStream.Write($notFoundBytes, 0, $notFoundBytes.Length)
        }
        
        $response.OutputStream.Close()
    }
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Try running PowerShell as Administrator" -ForegroundColor Yellow
} finally {
    if ($listener -and $listener.IsListening) {
        $listener.Stop()
    }
    Write-Host "Server stopped." -ForegroundColor Yellow
}