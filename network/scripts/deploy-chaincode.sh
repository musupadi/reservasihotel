#!/bin/bash

# ==============================================================
# Hyperledger Fabric Network - Start & Deploy Chaincode
# ==============================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}🚀 Starting Fabric Network & Deploy${NC}"
echo -e "${GREEN}========================================${NC}"

# Variables
CHANNEL_NAME="mychannel"
CHAINCODE_NAME="reservation"
CHAINCODE_VERSION="1.0"
CHAINCODE_SEQUENCE="1"
CC_SRC_PATH="../chaincode/reservation"

# Step 1: Start Docker Network
echo -e "\n${YELLOW}📦 Step 1: Starting Docker Containers...${NC}"
cd ../network
docker-compose -f docker-compose.yaml down
docker-compose -f docker-compose.yaml up -d

echo -e "${GREEN}✅ Waiting for containers to be ready...${NC}"
sleep 10

# Step 2: Create Channel
echo -e "\n${YELLOW}📺 Step 2: Creating Channel '$CHANNEL_NAME'...${NC}"
docker exec cli peer channel create \
    -o orderer.reservation.com:7050 \
    -c $CHANNEL_NAME \
    -f ./channel-artifacts/channel.tx \
    --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/reservation.com/orderers/orderer.reservation.com/msp/tlscacerts/tlsca.reservation.com-cert.pem

echo -e "${GREEN}✅ Channel created${NC}"

# Step 3: Join Peers to Channel
echo -e "\n${YELLOW}🔗 Step 3: Joining Peers to Channel...${NC}"

# Join peer0.hotelorg
docker exec \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hotelorg.reservation.com/users/Admin@hotelorg.reservation.com/msp \
    -e CORE_PEER_ADDRESS=peer0.hotelorg.reservation.com:7051 \
    -e CORE_PEER_LOCALMSPID="HotelOrgMSP" \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hotelorg.reservation.com/peers/peer0.hotelorg.reservation.com/tls/ca.crt \
    cli peer channel join -b $CHANNEL_NAME.block

# Join peer0.guestorg
docker exec \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/guestorg.reservation.com/users/Admin@guestorg.reservation.com/msp \
    -e CORE_PEER_ADDRESS=peer0.guestorg.reservation.com:9051 \
    -e CORE_PEER_LOCALMSPID="GuestOrgMSP" \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/guestorg.reservation.com/peers/peer0.guestorg.reservation.com/tls/ca.crt \
    cli peer channel join -b $CHANNEL_NAME.block

echo -e "${GREEN}✅ Peers joined to channel${NC}"

# Step 4: Package Chaincode
echo -e "\n${YELLOW}📦 Step 4: Packaging Chaincode...${NC}"
docker exec cli peer lifecycle chaincode package ${CHAINCODE_NAME}.tar.gz \
    --path ${CC_SRC_PATH} \
    --lang golang \
    --label ${CHAINCODE_NAME}_${CHAINCODE_VERSION}

echo -e "${GREEN}✅ Chaincode packaged${NC}"

# Step 5: Install on peer0.hotelorg
echo -e "\n${YELLOW}🔧 Step 5: Installing on peer0.hotelorg...${NC}"
docker exec \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hotelorg.reservation.com/users/Admin@hotelorg.reservation.com/msp \
    -e CORE_PEER_ADDRESS=peer0.hotelorg.reservation.com:7051 \
    -e CORE_PEER_LOCALMSPID="HotelOrgMSP" \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hotelorg.reservation.com/peers/peer0.hotelorg.reservation.com/tls/ca.crt \
    cli peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz

# Step 6: Install on peer0.guestorg
echo -e "\n${YELLOW}🔧 Step 6: Installing on peer0.guestorg...${NC}"
docker exec \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/guestorg.reservation.com/users/Admin@guestorg.reservation.com/msp \
    -e CORE_PEER_ADDRESS=peer0.guestorg.reservation.com:9051 \
    -e CORE_PEER_LOCALMSPID="GuestOrgMSP" \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/guestorg.reservation.com/peers/peer0.guestorg.reservation.com/tls/ca.crt \
    cli peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz

echo -e "${GREEN}✅ Chaincode installed on both peers${NC}"

# Step 7: Query Package ID
echo -e "\n${YELLOW}🔍 Step 7: Querying Package ID...${NC}"
PACKAGE_ID=$(docker exec cli peer lifecycle chaincode queryinstalled | grep ${CHAINCODE_NAME}_${CHAINCODE_VERSION} | awk '{print $3}' | sed 's/,$//')
echo -e "${GREEN}Package ID: $PACKAGE_ID${NC}"

# Step 8: Approve for HotelOrg
echo -e "\n${YELLOW}✅ Step 8: Approving for HotelOrg...${NC}"
docker exec \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hotelorg.reservation.com/users/Admin@hotelorg.reservation.com/msp \
    -e CORE_PEER_ADDRESS=peer0.hotelorg.reservation.com:7051 \
    -e CORE_PEER_LOCALMSPID="HotelOrgMSP" \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hotelorg.reservation.com/peers/peer0.hotelorg.reservation.com/tls/ca.crt \
    cli peer lifecycle chaincode approveformyorg \
    -o orderer.reservation.com:7050 \
    --channelID $CHANNEL_NAME \
    --name $CHAINCODE_NAME \
    --version $CHAINCODE_VERSION \
    --package-id $PACKAGE_ID \
    --sequence $CHAINCODE_SEQUENCE \
    --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/reservation.com/orderers/orderer.reservation.com/msp/tlscacerts/tlsca.reservation.com-cert.pem

# Step 9: Approve for GuestOrg
echo -e "\n${YELLOW}✅ Step 9: Approving for GuestOrg...${NC}"
docker exec \
    -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/guestorg.reservation.com/users/Admin@guestorg.reservation.com/msp \
    -e CORE_PEER_ADDRESS=peer0.guestorg.reservation.com:9051 \
    -e CORE_PEER_LOCALMSPID="GuestOrgMSP" \
    -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/guestorg.reservation.com/peers/peer0.guestorg.reservation.com/tls/ca.crt \
    cli peer lifecycle chaincode approveformyorg \
    -o orderer.reservation.com:7050 \
    --channelID $CHANNEL_NAME \
    --name $CHAINCODE_NAME \
    --version $CHAINCODE_VERSION \
    --package-id $PACKAGE_ID \
    --sequence $CHAINCODE_SEQUENCE \
    --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/reservation.com/orderers/orderer.reservation.com/msp/tlscacerts/tlsca.reservation.com-cert.pem

# Step 10: Commit Chaincode
echo -e "\n${YELLOW}🎯 Step 10: Committing Chaincode...${NC}"
docker exec cli peer lifecycle chaincode commit \
    -o orderer.reservation.com:7050 \
    --channelID $CHANNEL_NAME \
    --name $CHAINCODE_NAME \
    --version $CHAINCODE_VERSION \
    --sequence $CHAINCODE_SEQUENCE \
    --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/reservation.com/orderers/orderer.reservation.com/msp/tlscacerts/tlsca.reservation.com-cert.pem \
    --peerAddresses peer0.hotelorg.reservation.com:7051 \
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hotelorg.reservation.com/peers/peer0.hotelorg.reservation.com/tls/ca.crt \
    --peerAddresses peer0.guestorg.reservation.com:9051 \
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/guestorg.reservation.com/peers/peer0.guestorg.reservation.com/tls/ca.crt

# Step 11: Initialize Ledger
echo -e "\n${YELLOW}🎬 Step 11: Initializing Ledger...${NC}"
docker exec cli peer chaincode invoke \
    -o orderer.reservation.com:7050 \
    --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/reservation.com/orderers/orderer.reservation.com/msp/tlscacerts/tlsca.reservation.com-cert.pem \
    -C $CHANNEL_NAME \
    -n $CHAINCODE_NAME \
    --peerAddresses peer0.hotelorg.reservation.com:7051 \
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hotelorg.reservation.com/peers/peer0.hotelorg.reservation.com/tls/ca.crt \
    --peerAddresses peer0.guestorg.reservation.com:9051 \
    --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/guestorg.reservation.com/peers/peer0.guestorg.reservation.com/tls/ca.crt \
    -c '{"function":"InitLedger","Args":[]}'

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}✅ DEPLOYMENT COMPLETED!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\n${GREEN}Network Status:${NC}"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo -e "\n${GREEN}Next Steps:${NC}"
echo -e "1. Update fabric_client.go with connection profile"
echo -e "2. Restart Go backend"
echo -e "3. Test with real blockchain transactions"
