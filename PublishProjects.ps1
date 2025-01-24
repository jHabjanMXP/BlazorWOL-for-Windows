# Define paths to the project folders and publish profiles
$clientProjectPath = "Client" # Path to the Client project folder
$serverProjectPath = "Server" # Path to the Server project folder
$clientPublishProfile = "FolderProfile.pubxml" # Publish profile for Client
$serverPublishProfile = "FolderProfile.pubxml" # Publish profile for Server
$outputFolder = "Output" # Path to the Output folder
$zipFileName = "Hepra_WOL.zip" # Name of the zip file

# Function to publish a project
function Publish-Project {
    param (
        [string]$ProjectPath,
        [string]$PublishProfile
    )

    Write-Host "Publishing project at: $ProjectPath using profile: $PublishProfile" -ForegroundColor Cyan

    # Execute the dotnet publish command
    dotnet publish $ProjectPath `
        -p:PublishProfile=$PublishProfile `
        -p:Configuration=Release `
        -v:m `
        -nologo

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Publishing failed for: $ProjectPath" -ForegroundColor Red
        exit $LASTEXITCODE
    } else {
        Write-Host "Publishing succeeded for: $ProjectPath" -ForegroundColor Green
    }
}

# Function to zip the server publish output
function Zip-ServerOutput {
    param (
        [string]$PublishPath,
        [string]$OutputFolder,
        [string]$ZipFileName
    )

    Write-Host "Zipping publish output from: $PublishPath" -ForegroundColor Cyan

    # Ensure the Output folder exists
    if (-not (Test-Path $OutputFolder)) {
        New-Item -ItemType Directory -Path $OutputFolder | Out-Null
    }

    # Path to the zip file
    $zipFilePath = Join-Path $OutputFolder $ZipFileName

    # Remove existing zip file if it exists
    if (Test-Path $zipFilePath) {
        Remove-Item $zipFilePath -Force
    }

    # Create the zip file
    Compress-Archive -Path (Join-Path $PublishPath '*') -DestinationPath $zipFilePath

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Zipping failed!" -ForegroundColor Red
        exit $LASTEXITCODE
    } else {
        Write-Host "Zipping succeeded! Output: $zipFilePath" -ForegroundColor Green
    }
}

# Publish Client project
Publish-Project -ProjectPath $clientProjectPath -PublishProfile $clientPublishProfile

# Publish Server project
Publish-Project -ProjectPath $serverProjectPath -PublishProfile $serverPublishProfile

# Path to the Server publish directory
$serverPublishPath = "Server\bin\Release\netcoreapp3.1\publish"

# Zip the server publish output
Zip-ServerOutput -PublishPath $serverPublishPath -OutputFolder $outputFolder -ZipFileName $zipFileName
