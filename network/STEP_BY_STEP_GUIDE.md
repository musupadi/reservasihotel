# ================================================================
# STEP-BY-STEP GUIDE: Setup Network untuk Caliper
# ================================================================

## STEP 1: Verify Network Status ✅

Cek status containers yang sedang running:

```powershell
cd C:\Blockchain\reservasihotel\network
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

**Expected Output:**
Harus ada minimal:
- orderer.reservation.com (Port 7050)
- peer0.hotelorg (Port 7051)
- couchdb (Port 5984)

**Jika ada container yang Exited atau tidak ada:**
```powershell
docker-compose down
docker-compose up -d
Start-Sleep -Seconds 15
docker ps
```

---

## STEP 2: Verify Crypto Materials

Cek apakah crypto materials sudah ter-generate:

```powershell
Test-Path ".\organizations\ordererOrganizations\reservation.com\orderers\orderer.reservation.com\msp"
Test-Path ".\organizations\peerOrganizations\hotelorg.reservation.com"
```

**Expected: Both should return True**

**Jika False:**
```powershell
.\generate-crypto.ps1
```

---

## STEP 3: Check Channel Status

Cek apakah peer sudah join ke channel:

```powershell
docker exec network-peer0.hotelorg.reservation.com-1 peer channel list
```

**Expected:**
- Jika kosong: "Channels peers has joined:" (no channels listed)
- Kita akan create channel di step berikutnya

---

## STEP 4: Create Channel (Using osnadmin - Fabric 2.5 way)

Fabric 2.5 menggunakan Channel Participation API. Kita perlu:

### 4A. Create genesis block untuk channel

```powershell
# Check if CLI container is running
docker ps | Select-String "cli"

# Create channel genesis block
docker exec network-cli-1 configtxgen `
    -profile TwoOrgsChannel `
    -outputBlock /opt/gopath/src/github.com/hyperledger/fabric/peer/channel-artifacts/mychannel.block `
    -channelID mychannel
```

**Expected:** "Successfully created channel block"

**Jika error "configtxgen not found":**
Ini OK, kita akan pakai cara alternatif di step berikutnya.

---

## STEP 5: Create Channel via Peer (Alternative Method)

Cara yang lebih simple - buat channel langsung dari peer:

```powershell
# Masuk ke CLI container dan create channel
docker exec -it network-cli-1 bash

# Didalam container, jalankan:
export CORE_PEER_LOCALMSPID=HotelOrgMSP
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/hotelorg.reservation.com/peers/peer0.hotelorg.reservation.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/hotelorg.reservation.com/users/Admin@hotelorg.reservation.com/msp
export CORE_PEER_ADDRESS=peer0.hotelorg.reservation.com:7051

# Create channel
peer channel create -o orderer.reservation.com:7050 -c mychannel -f ./channel-artifacts/mychannel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/reservation.com/orderers/orderer.reservation.com/msp/tlscacerts/tlsca.reservation.com-cert.pem

# Join channel
peer channel join -b mychannel.block

# Verify
peer channel list

# Exit container
exit
```

---

## STEP 6: Verify Channel Created

Setelah keluar dari container CLI:

```powershell
# Check peer channels
docker exec network-peer0.hotelorg.reservation.com-1 peer channel list
```

**Expected:** Should show "mychannel"

---

## STEP 7: Package Chaincode

```powershell
# Package chaincode reservation
docker exec network-cli-1 peer lifecycle chaincode package reservation.tar.gz `
    --path /opt/gopath/src/github.com/hyperledger/fabric/peer/chaincode/reservation `
    --lang golang `
    --label reservation_1.0
```

**Expected:** "Chaincode packaged successfully"

---

## STEP 8: Install Chaincode on Peer

```powershell
# Install on HotelOrg peer
docker exec network-cli-1 bash -c "
export CORE_PEER_LOCALMSPID=HotelOrgMSP
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/hotelorg.reservation.com/peers/peer0.hotelorg.reservation.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/hotelorg.reservation.com/users/Admin@hotelorg.reservation.com/msp
export CORE_PEER_ADDRESS=peer0.hotelorg.reservation.com:7051

peer lifecycle chaincode install reservation.tar.gz
"
```

---

## STEP 9: Query Installed Chaincode

```powershell
docker exec network-cli-1 peer lifecycle chaincode queryinstalled
```

**Save the Package ID!** (format: reservation_1.0:xxxxx...)

---

## STEP 10: Approve Chaincode

Replace `PACKAGE_ID` dengan ID dari step 9:

```powershell
$PACKAGE_ID = "reservation_1.0:xxxxxxxxxxxxx"  # GANTI INI!

docker exec network-cli-1 bash -c "
export CORE_PEER_LOCALMSPID=HotelOrgMSP
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/hotelorg.reservation.com/peers/peer0.hotelorg.reservation.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/hotelorg.reservation.com/users/Admin@hotelorg.reservation.com/msp
export CORE_PEER_ADDRESS=peer0.hotelorg.reservation.com:7051

peer lifecycle chaincode approveformyorg \
  -o orderer.reservation.com:7050 \
  --channelID mychannel \
  --name reservation \
  --version 1.0 \
  --package-id $PACKAGE_ID \
  --sequence 1 \
  --tls \
  --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/reservation.com/orderers/orderer.reservation.com/msp/tlscacerts/tlsca.reservation.com-cert.pem
"
```

---

## STEP 11: Check Commit Readiness

```powershell
docker exec network-cli-1 peer lifecycle chaincode checkcommitreadiness \
  --channelID mychannel \
  --name reservation \
  --version 1.0 \
  --sequence 1
```

**Expected:** Should show approval status

---

## STEP 12: Commit Chaincode

```powershell
docker exec network-cli-1 bash -c "
export CORE_PEER_LOCALMSPID=HotelOrgMSP
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/hotelorg.reservation.com/peers/peer0.hotelorg.reservation.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/hotelorg.reservation.com/users/Admin@hotelorg.reservation.com/msp
export CORE_PEER_ADDRESS=peer0.hotelorg.reservation.com:7051

peer lifecycle chaincode commit \
  -o orderer.reservation.com:7050 \
  --channelID mychannel \
  --name reservation \
  --version 1.0 \
  --sequence 1 \
  --tls \
  --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/reservation.com/orderers/orderer.reservation.com/msp/tlscacerts/tlsca.reservation.com-cert.pem \
  --peerAddresses peer0.hotelorg.reservation.com:7051 \
  --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/hotelorg.reservation.com/peers/peer0.hotelorg.reservation.com/tls/ca.crt
"
```

---

## STEP 13: Query Committed Chaincode

```powershell
docker exec network-cli-1 peer lifecycle chaincode querycommitted \
  --channelID mychannel
```

**Expected:** Should show reservation chaincode committed

---

## STEP 14: Initialize Chaincode

```powershell
docker exec network-cli-1 bash -c "
export CORE_PEER_LOCALMSPID=HotelOrgMSP
export CORE_PEER_ADDRESS=peer0.hotelorg.reservation.com:7051

peer chaincode invoke \
  -o orderer.reservation.com:7050 \
  --tls \
  --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/ordererOrganizations/reservation.com/orderers/orderer.reservation.com/msp/tlscacerts/tlsca.reservation.com-cert.pem \
  -C mychannel \
  -n reservation \
  --peerAddresses peer0.hotelorg.reservation.com:7051 \
  --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/organizations/peerOrganizations/hotelorg.reservation.com/peers/peer0.hotelorg.reservation.com/tls/ca.crt \
  -c '{\"function\":\"InitLedger\",\"Args\":[]}'
"
```

---

## STEP 15: Test Chaincode Query

```powershell
docker exec network-cli-1 bash -c "
export CORE_PEER_LOCALMSPID=HotelOrgMSP
export CORE_PEER_ADDRESS=peer0.hotelorg.reservation.com:7051

peer chaincode query \
  -C mychannel \
  -n reservation \
  -c '{\"function\":\"GetAllReservations\",\"Args\":[]}'
"
```

**Expected:** Should return JSON array of reservations

---

## NEXT STEPS

Setelah semua step berhasil:
1. Update Caliper config
2. Run Caliper benchmark
3. Lihat hasil

---

## TROUBLESHOOTING

### Error: "connection refused"
- Check orderer running: `docker ps | findstr orderer`
- Restart: `docker-compose restart orderer.reservation.com`

### Error: "crypto not found"
- Run: `.\generate-crypto.ps1`

### Error: "channel not found"
- Repeat Step 5 (create channel)

### Error: "chaincode not found"
- Check package ID correct in Step 10
- Verify install in Step 8

---

Saya akan guide Anda step by step. Silakan laporkan hasil setiap command!
