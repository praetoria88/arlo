param(
    [string]$db_connection_param_name,
    [string]$aws_region
)

# Prep
New-Item -ItemType Directory -Path "C:\Temp" -Force

Install-WindowsFeature Web-Server -IncludeManagementTools
Install-WindowsFeature Web-Asp-Net45

# Ensure IIS service exists
if (-not (Get-Service W3SVC -ErrorAction SilentlyContinue)) {
    throw "IIS installation failed - W3SVC not found"
}

Start-Service W3SVC
Set-Service W3SVC -StartupType Automatic

# Install .NET Hosting Bundle
$dotnetUrl = "https://download.visualstudio.microsoft.com/download/pr/0f2c9b7c/dotnet-hosting-8.0.0-win.exe"
$installer = "C:\Temp\dotnet-hosting.exe"

Invoke-WebRequest $dotnetUrl -OutFile $installer
Start-Process $installer -ArgumentList "/quiet" -Wait

# Application setup
$appPath = "C:\inetpub\wwwroot\HelloWorldApi"
New-Item -ItemType Directory -Path $appPath -Force

# SSM Secret retrieval
try {
    Import-Module AWSPowerShell.NetCore

    $connectionString = (Get-SSMParameter `
        -Name $db_connection_param_name `
        -WithDecryption $true `
        -Region $aws_region).Value

    @{
        ConnectionStrings = @{
            DefaultConnection = $connectionString
        }
    } | ConvertTo-Json -Depth 5 | Out-File "$appPath\appsettings.json"

} catch {
    Write-Output "WARNING: Could not retrieve SSM parameter during bootstrap"
}

# Final validation (IMPORTANT)
if ((Get-Service W3SVC).Status -ne "Running") {
    Start-Service W3SVC
}

Write-Output "Bootstrap completed successfully"