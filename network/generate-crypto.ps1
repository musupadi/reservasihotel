# ============================================================== 
# Script untuk Generate Crypto Materials & Setup Network
# Hotel Reservation Blockchain Network
# ==============================================================

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "   Generating Crypto Materials & Setting Up Network" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

$ErrorActionPreference = "Stop"

# Variables
$NETWORK_DIR = $PSScriptRoot
$CHANNEL_NAME = "mychannel"
$CHAINCODE_NAME = "reservation"

# Step 0: Check if cryptogen is available
Write-Host "`nStep 0: Checking prerequisites..." -ForegroundColor Yellow

# Check if fabric binaries exist
$FABRIC_BIN = "C:\fabric-binaries\bin"
if (Test-Path "$FABRIC_BIN\cryptogen.exe") {
    Write-Host "[OK] Found cryptogen at $FABRIC_BIN" -ForegroundColor Green
    $env:PATH = "$FABRIC_BIN;$env:PATH"
} else {
    Write-Host "[WARN] cryptogen not found. Downloading Fabric binaries..." -ForegroundColor Yellow
    
    # Create fabric-binaries directory
    New-Item -ItemType Directory -Force -Path "C:\fabric-binaries" | Out-Null
    
    Write-Host "[INFO] Downloading Hyperledger Fabric binaries v2.5.0..." -ForegroundColor Cyan
    Write-Host "    This may take a few minutes..." -ForegroundColor Gray
    
    # Download fabric binaries
    $fabricUrl = "https://github.com/hyperledger/fabric/releases/download/v2.5.0/hyperledger-fabric-windows-amd64-2.5.0.tar.gz"
    $downloadPath = "C:\fabric-binaries\fabric.tar.gz"
    
    try {
        Invoke-WebRequest -Uri $fabricUrl -OutFile $downloadPath -UseBasicParsing
        
        # Extract (requires tar.exe which is available in Windows 10+)
        Set-Location "C:\fabric-binaries"
        tar -xzf fabric.tar.gz
        Remove-Item fabric.tar.gz
        
        $env:PATH = "C:\fabric-binaries\bin;$env:PATH"
        Write-Host "[OK] Fabric binaries downloaded and extracted" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Failed to download binaries automatically" -ForegroundColor Red
        Write-Host "   Please download manually from:" -ForegroundColor Yellow
        Write-Host "   https://github.com/hyperledger/fabric/releases/tag/v2.5.0" -ForegroundColor Yellow
        Write-Host "   Extract to C:\fabric-binaries\" -ForegroundColor Yellow
        exit 1
    }
}

Set-Location $NETWORK_DIR

# Step 1: Clean old crypto materials
Write-Host "`nStep 1: Cleaning old crypto materials..." -ForegroundColor Yellow
if (Test-Path "organizations/ordererOrganizations") {
    Remove-Item -Recurse -Force "organizations/ordererOrganizations"
}
if (Test-Path "organizations/peerOrganizations") {
    Remove-Item -Recurse -Force "organizations/peerOrganizations"
}
Write-Host "[OK] Cleaned" -ForegroundColor Green

# Step 2: Generate Orderer Crypto Materials
Write-Host "`nStep 2: Generating Orderer crypto materials..." -ForegroundColor Yellow
try {
    cryptogen generate --config=crypto-config-orderer.yaml --output="organizations"
    Write-Host "[OK] Orderer crypto generated" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to generate orderer crypto" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# Step 3: Generate Peer Crypto Materials  
Write-Host "`nStep 3: Generating Peer crypto materials..." -ForegroundColor Yellow
try {
    cryptogen generate --config=crypto-config-peer.yaml --output="organizations"
    Write-Host "[OK] Peer crypto generated" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Failed to generate peer crypto" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# Step 4: Create MSP directories structure
Write-Host "`nStep 4: Creating MSP directory structure..." -ForegroundColor Yellow

# Copy orderer MSP
$ordererMspSource = "organizations/ordererOrganizations/reservation.com/msp"
$ordererMspDest = "organizations/ordererOrganizations/reservation.com/orderers/orderer.reservation.com/msp"

if (Test-Path $ordererMspSource) {
    # Create orderer directory structure
    New-Item -ItemType Directory -Force -Path "organizations/ordererOrganizations/reservation.com/orderers/orderer.reservation.com" | Out-Null
    
    # Copy MSP to orderer
    Copy-Item -Path $ordererMspSource -Destination $ordererMspDest -Recurse -Force
    
    # Copy TLS certs
    $tlsSource = "organizations/ordererOrganizations/reservation.com/orderers/orderer/tls"
    $tlsDest = "organizations/ordererOrganizations/reservation.com/orderers/orderer.reservation.com/tls"
    
    if (Test-Path $tlsSource) {
        Copy-Item -Path $tlsSource -Destination $tlsDest -Recurse -Force
    }
    
    Write-Host "[OK] Orderer MSP structure created" -ForegroundColor Green
}

Write-Host "`n[OK] MSP directories created" -ForegroundColor Green

# Step 5: Stop existing containers
Write-Host "`nStep 5: Stopping existing containers..." -ForegroundColor Yellow
docker-compose down -v
Write-Host "[OK] Containers stopped" -ForegroundColor Green

# Step 6: Start Network
Write-Host "`nStep 6: Starting Docker containers..." -ForegroundColor Yellow
docker-compose up -d

Write-Host "[WAIT] Waiting for containers to initialize..." -ForegroundColor Gray
Start-Sleep -Seconds 15

# Check container status
Write-Host "`nContainer Status:" -ForegroundColor Cyan
docker ps --format "table {{.Names}}\t{{.Status}}"

# Verify orderer is running
$ordererStatus = docker ps --filter "name=orderer" --format "{{.Status}}"
if ($ordererStatus -like "*Up*") {
    Write-Host "[OK] Orderer is running!" -ForegroundColor Green
} else {
    Write-Host "[WARN] Orderer may not be running properly. Check logs:" -ForegroundColor Yellow
    Write-Host "   docker logs network-orderer.reservation.com-1" -ForegroundColor Gray
}

Write-Host "
================================================================" -ForegroundColor Green
Write-Host "              Network Setup Complete!" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
Write-Host "
Next Steps:" -ForegroundColor Cyan
Write-Host "1. Create channel: .\scripts\create-channel.ps1" -ForegroundColor Gray
Write-Host "2. Deploy chaincode: .\scripts\deploy-chaincode.ps1" -ForegroundColor Gray
Write-Host "3. Run Caliper benchmark" -ForegroundColor Gray
Write-Host ""
Write-Host "Crypto materials location:" -ForegroundColor Cyan
Write-Host "   organizations/ordererOrganizations/" -ForegroundColor Gray
Write-Host "   organizations/peerOrganizations/" -ForegroundColor Gray
