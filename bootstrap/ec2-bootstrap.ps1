$ErrorActionPreference = "Stop"

Start-Transcript -Path "C:\bootstrap.log" -Append

Write-Output "=== BOOTSTRAP STARTED ==="

try {
    # =========================
    # Wait for Windows to finish first-boot setup
    # =========================
    Write-Output "Waiting for Windows initialization..."
    Start-Sleep -Seconds 30

    # =========================
    # Install IIS (reliable method for WS2022 on EC2)
    # =========================
    Write-Output "Installing IIS using DISM..."

    # Force DISM to use local payload (fixes missing W3SVC)
    Dism /Online /Enable-Feature /FeatureName:IIS-WebServerRole /All /LimitAccess /Source:C:\Windows\winsxs

    # Install management tools
    Install-WindowsFeature Web-Server -IncludeManagementTools -Source C:\Windows\winsxs

    $iis = Get-WindowsFeature Web-Server
    Write-Output "IIS Install State: $($iis.InstallState)"

    if ($iis.InstallState -ne "Installed") {
        throw "IIS failed to install"
    }

    # Start W3SVC
    Write-Output "Starting W3SVC..."
    Start-Service W3SVC -ErrorAction Stop

    # =========================
    # App folder
    # =========================
    $appPath = "C:\inetpub\wwwroot\HelloWorldApi"
    New-Item -ItemType Directory -Path $appPath -Force | Out-Null
    Write-Output "App folder created at $appPath"

    # =========================
    # .NET Hosting Bundle
    # =========================
    Write-Output "Installing .NET Hosting Bundle..."

    New-Item -ItemType Directory -Path "C:\Temp" -Force | Out-Null

    $dotnetUrl = "https://download.visualstudio.microsoft.com/download/pr/0f2c9b7c/dotnet-hosting-8.0.0-win.exe"
    $installer = "C:\Temp\dotnet-hosting.exe"

    Invoke-WebRequest $dotnetUrl -OutFile $installer
    Start-Process $installer -ArgumentList "/quiet" -Wait

    Write-Output ".NET Hosting Bundle installed"

    # =========================
    # SSM Parameter (optional)
    # =========================
    try {
        Write-Output "Attempting to load SSM parameter..."

        Import-Module AWSPowerShell.NetCore -ErrorAction SilentlyContinue

        $connectionString = (Get-SSMParameter `
            -Name "your-param-name-here" `
            -WithDecryption $true `
            -Region "ap-southeast-2").Value

        Write-Output "SSM parameter retrieved"
    }
    catch {
        Write-Output "SSM fetch failed (non-critical): $_"
    }

    Write-Output "=== BOOTSTRAP COMPLETED SUCCESSFULLY ==="
}
catch {
    Write-Output "BOOTSTRAP FAILED: $_"
}

Stop-Transcript
