# ==============================================================
# Hyperledger Fabric Network - Start & Deploy Chaincode
# PowerShell Version untuk Windows
# ==============================================================

Write-Host "
========================================
🚀 Starting Fabric Network & Deploy
========================================
" -ForegroundColor Green

# Variables
$CHANNEL_NAME = "mychannel"
$CHAINCODE_NAME = "reservation"
$CHAINCODE_VERSION = "1.0"
$CHAINCODE_SEQUENCE = "1"

# Change to network directory
Set-Location -Path "..\network"

# Step 1: Start Docker Network
Write-Host "`n📦 Step 1: Starting Docker Containers..." -ForegroundColor Yellow
docker-compose -f docker-compose.yaml down
docker-compose -f docker-compose.yaml up -d

Write-Host "✅ Waiting for containers to be ready..." -ForegroundColor Green
Start-Sleep -Seconds 15

# Check containers
Write-Host "`n📊 Container Status:" -ForegroundColor Cyan
docker ps

# Step 2: Create Channel
Write-Host "`n📺 Step 2: Creating Channel '$CHANNEL_NAME'..." -ForegroundColor Yellow
docker exec cli peer channel create `
    -o orderer.reservation.com:7050 `
    -c $CHANNEL_NAME `
    -f /opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/channel.tx `
    --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/reservation.com/orderers/orderer.reservation.com/msp/tlscacerts/tlsca.reservation.com-cert.pem

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Channel created" -ForegroundColor Green
} else {
    Write-Host "⚠️  Channel might already exist or orderer not ready" -ForegroundColor Yellow
}

Start-Sleep -Seconds 3

# Step 3: Join Peers to Channel
Write-Host "`n🔗 Step 3: Joining Peers to Channel..." -ForegroundColor Yellow

# Join peer0.hotelorg
Write-Host "Joining peer0.hotelorg..." -ForegroundColor Cyan
docker exec cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hotelorg.reservation.com/users/Admin@hotelorg.reservation.com/msp CORE_PEER_ADDRESS=peer0.hotelorg.reservation.com:7051 CORE_PEER_LOCALMSPID=HotelOrgMSP CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hotelorg.reservation.com/peers/peer0.hotelorg.reservation.com/tls/ca.crt peer channel join -b $CHANNEL_NAME.block"

# Join peer0.guestorg
Write-Host "Joining peer0.guestorg..." -ForegroundColor Cyan
docker exec cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/guestorg.reservation.com/users/Admin@guestorg.reservation.com/msp CORE_PEER_ADDRESS=peer0.guestorg.reservation.com:9051 CORE_PEER_LOCALMSPID=GuestOrgMSP CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/guestorg.reservation.com/peers/peer0.guestorg.reservation.com/tls/ca.crt peer channel join -b $CHANNEL_NAME.block"

Write-Host "✅ Peers joined to channel" -ForegroundColor Green

# Step 4: Package Chaincode
Write-Host "`n📦 Step 4: Packaging Chaincode..." -ForegroundColor Yellow
docker exec cli peer lifecycle chaincode package ${CHAINCODE_NAME}.tar.gz `
    --path /opt/gopath/src/github.com/hyperledger/fabric/chaincode/reservation `
    --lang golang `
    --label "${CHAINCODE_NAME}_${CHAINCODE_VERSION}"

Write-Host "✅ Chaincode packaged" -ForegroundColor Green

# Step 5: Install on peer0.hotelorg
Write-Host "`n🔧 Step 5: Installing on peer0.hotelorg..." -ForegroundColor Yellow
docker exec cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hotelorg.reservation.com/users/Admin@hotelorg.reservation.com/msp CORE_PEER_ADDRESS=peer0.hotelorg.reservation.com:7051 CORE_PEER_LOCALMSPID=HotelOrgMSP CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hotelorg.reservation.com/peers/peer0.hotelorg.reservation.com/tls/ca.crt peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz"

# Step 6: Install on peer0.guestorg
Write-Host "`n🔧 Step 6: Installing on peer0.guestorg..." -ForegroundColor Yellow
docker exec cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/guestorg.reservation.com/users/Admin@guestorg.reservation.com/msp CORE_PEER_ADDRESS=peer0.guestorg.reservation.com:9051 CORE_PEER_LOCALMSPID=GuestOrgMSP CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/guestorg.reservation.com/peers/peer0.guestorg.reservation.com/tls/ca.crt peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz"

Write-Host "✅ Chaincode installed on both peers" -ForegroundColor Green

# Step 7: Query Package ID
Write-Host "`n🔍 Step 7: Querying Package ID..." -ForegroundColor Yellow
$PACKAGE_ID_OUTPUT = docker exec cli peer lifecycle chaincode queryinstalled
Write-Host $PACKAGE_ID_OUTPUT -ForegroundColor Gray
$PACKAGE_ID = ($PACKAGE_ID_OUTPUT | Select-String "${CHAINCODE_NAME}_${CHAINCODE_VERSION}").Line -replace '.*Package ID: ([^,]+).*','$1'
Write-Host "Package ID: $PACKAGE_ID" -ForegroundColor Green

# Step 8: Approve for HotelOrg
Write-Host "`n✅ Step 8: Approving for HotelOrg..." -ForegroundColor Yellow
docker exec cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hotelorg.reservation.com/users/Admin@hotelorg.reservation.com/msp CORE_PEER_ADDRESS=peer0.hotelorg.reservation.com:7051 CORE_PEER_LOCALMSPID=HotelOrgMSP CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hotelorg.reservation.com/peers/peer0.hotelorg.reservation.com/tls/ca.crt peer lifecycle chaincode approveformyorg -o orderer.reservation.com:7050 --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --package-id $PACKAGE_ID --sequence $CHAINCODE_SEQUENCE --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/reservation.com/orderers/orderer.reservation.com/msp/tlscacerts/tlsca.reservation.com-cert.pem"

# Step 9: Approve for GuestOrg
Write-Host "`n✅ Step 9: Approving for GuestOrg..." -ForegroundColor Yellow
docker exec cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/guestorg.reservation.com/users/Admin@guestorg.reservation.com/msp CORE_PEER_ADDRESS=peer0.guestorg.reservation.com:9051 CORE_PEER_LOCALMSPID=GuestOrgMSP CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/guestorg.reservation.com/peers/peer0.guestorg.reservation.com/tls/ca.crt peer lifecycle chaincode approveformyorg -o orderer.reservation.com:7050 --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --package-id $PACKAGE_ID --sequence $CHAINCODE_SEQUENCE --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/reservation.com/orderers/orderer.reservation.com/msp/tlscacerts/tlsca.reservation.com-cert.pem"

# Step 10: Commit Chaincode
Write-Host "`n🎯 Step 10: Committing Chaincode..." -ForegroundColor Yellow
docker exec cli peer lifecycle chaincode commit `
    -o orderer.reservation.com:7050 `
    --channelID $CHANNEL_NAME `
    --name $CHAINCODE_NAME `
    --version $CHAINCODE_VERSION `
    --sequence $CHAINCODE_SEQUENCE `
    --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/reservation.com/orderers/orderer.reservation.com/msp/tlscacerts/tlsca.reservation.com-cert.pem `
    --peerAddresses peer0.hotelorg.reservation.com:7051 `
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hotelorg.reservation.com/peers/peer0.hotelorg.reservation.com/tls/ca.crt `
    --peerAddresses peer0.guestorg.reservation.com:9051 `
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/guestorg.reservation.com/peers/peer0.guestorg.reservation.com/tls/ca.crt

# Step 11: Initialize Ledger
Write-Host "`n🎬 Step 11: Initializing Ledger..." -ForegroundColor Yellow
docker exec cli peer chaincode invoke `
    -o orderer.reservation.com:7050 `
    --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/reservation.com/orderers/orderer.reservation.com/msp/tlscacerts/tlsca.reservation.com-cert.pem `
    -C $CHANNEL_NAME `
    -n $CHAINCODE_NAME `
    --peerAddresses peer0.hotelorg.reservation.com:7051 `
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hotelorg.reservation.com/peers/peer0.hotelorg.reservation.com/tls/ca.crt `
    --peerAddresses peer0.guestorg.reservation.com:9051 `
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/guestorg.reservation.com/peers/peer0.guestorg.reservation.com/tls/ca.crt `
    -c '{\"function\":\"InitLedger\",\"Args\":[]}'

Write-Host "
========================================
✅ DEPLOYMENT COMPLETED!
========================================
" -ForegroundColor Green

Write-Host "`nNetwork Status:" -ForegroundColor Cyan
docker ps

Write-Host "
Next Steps:
1. Update fabric_client.go with connection profile
2. Restart Go backend
3. Test with real blockchain transactions
" -ForegroundColor Yellow
