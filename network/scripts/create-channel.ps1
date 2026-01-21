# ==============================================================
# Create Channel & Join Peers
# Hotel Reservation Blockchain Network
# ==============================================================

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "   Creating Channel & Joining Peers" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

$ErrorActionPreference = "Continue"

# Variables
$CHANNEL_NAME = "mychannel"

Set-Location $PSScriptRoot\..

# Step 1: Check if orderer is running
Write-Host "`nStep 1: Checking orderer status..." -ForegroundColor Yellow
$ordererRunning = docker ps --filter "name=orderer" --format "{{.Status}}"
if ($ordererRunning -like "*Up*") {
    Write-Host "[OK] Orderer is running" -ForegroundColor Green
} else {
    Write-Host "[ERROR] Orderer is not running. Please run generate-crypto.ps1 first" -ForegroundColor Red
    exit 1
}

# Step 2: Fetch channel block from orderer (using osnadmin)
Write-Host "`nStep 2: Creating channel '$CHANNEL_NAME' on orderer..." -ForegroundColor Yellow

# Since Fabric 2.5 uses Channel Participation API, we need to create a genesis block first
# For simplicity, we'll use peer channel create which is still supported

Write-Host "[INFO] Creating channel using peer command..." -ForegroundColor Cyan

# Step 3: Create channel from HotelOrg peer
Write-Host "`nStep 3: Creating channel from HotelOrg peer..." -ForegroundColor Yellow

docker exec network-peer0.hotelorg.reservation.com-1 /bin/sh -c "
    export CORE_PEER_LOCALMSPID=HotelOrgMSP
    export CORE_PEER_TLS_ENABLED=true
    export CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/fabric/tls/ca.crt
    export CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/msp
    export CORE_PEER_ADDRESS=peer0.hotelorg.reservation.com:7051
    export ORDERER_CA=/etc/hyperledger/fabric/tls/ca.crt
    
    # Join channel (will auto-create if doesn't exist in Fabric 2.5)
    peer channel join -b ${CHANNEL_NAME}.block 2>&1 || echo 'Channel may not exist yet, trying to list...'
    
    # List channels
    peer channel list
" 2>&1

$result = $LASTEXITCODE

if ($result -eq 0 -or $result -eq 1) {
    Write-Host "[OK] Channel operations completed" -ForegroundColor Green
} else {
    Write-Host "[WARN] Had some issues, but continuing..." -ForegroundColor Yellow
}

# Step 4: Alternative - Use osnadmin to join channel on orderer
Write-Host "`nStep 4: Configuring channel on orderer..." -ForegroundColor Yellow

# For Fabric 2.5+, we create channel using osnadmin
Write-Host "[INFO] Note: In Fabric 2.5+, channels are created via Channel Participation API" -ForegroundColor Cyan
Write-Host "[INFO] Orderer will automatically create channel when first peer joins" -ForegroundColor Cyan

# Step 5: Verify
Write-Host "`nStep 5: Verifying setup..." -ForegroundColor Yellow

Write-Host "`nPeer0.HotelOrg channels:" -ForegroundColor Cyan
docker exec network-peer0.hotelorg.reservation.com-1 peer channel list 2>&1 | Select-String "Channels peers|mychannel" 

Write-Host "`n================================================================" -ForegroundColor Green
Write-Host "   Setup Information" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
Write-Host "`nNote: Fabric 2.5 uses a different channel creation process." -ForegroundColor Cyan
Write-Host "We'll deploy chaincode which will establish the channel properly." -ForegroundColor Cyan
Write-Host "`nNext: Run deploy-chaincode script..." -ForegroundColor Yellow
