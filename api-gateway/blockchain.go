package main

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"time"
)

// Block represents a block in the blockchain
type Block struct {
	Index     int                    `json:"index"`
	Timestamp time.Time              `json:"timestamp"`
	Data      map[string]interface{} `json:"data"`
	PrevHash  string                 `json:"prevHash"`
	Hash      string                 `json:"hash"`
	Nonce     int                    `json:"nonce"`
}

// Blockchain represents the entire blockchain
type Blockchain struct {
	Chain []Block `json:"chain"`
}

// Transaction represents a blockchain transaction
type Transaction struct {
	TxID          string                 `json:"txId"`
	Type          string                 `json:"type"` // CREATE, UPDATE, CONFIRM, CANCEL, etc.
	ReservationID string                 `json:"reservationId"`
	Data          map[string]interface{} `json:"data"`
	Timestamp     time.Time              `json:"timestamp"`
	ActorMSP      string                 `json:"actorMSP"`
	Signature     string                 `json:"signature"`
}

// NewBlockchain creates a new blockchain with genesis block
func NewBlockchain() *Blockchain {
	genesis := Block{
		Index:     0,
		Timestamp: time.Now(),
		Data: map[string]interface{}{
			"message": "Genesis Block - Hotel Reservation Blockchain",
			"version": "1.0.0",
			"network": "local-simulation",
		},
		PrevHash: "0",
		Nonce:    0,
	}
	genesis.Hash = genesis.calculateHash()

	return &Blockchain{
		Chain: []Block{genesis},
	}
}

// calculateHash calculates the hash of the block
func (b *Block) calculateHash() string {
	data, _ := json.Marshal(b.Data)
	record := fmt.Sprintf("%d%s%s%s%d", b.Index, b.Timestamp.String(), string(data), b.PrevHash, b.Nonce)
	hash := sha256.Sum256([]byte(record))
	return hex.EncodeToString(hash[:])
}

// AddBlock adds a new block to the blockchain
func (bc *Blockchain) AddBlock(data map[string]interface{}) {
	prevBlock := bc.Chain[len(bc.Chain)-1]
	newBlock := Block{
		Index:     prevBlock.Index + 1,
		Timestamp: time.Now(),
		Data:      data,
		PrevHash:  prevBlock.Hash,
		Nonce:     0,
	}

	// Simple proof of work (find hash starting with zeros)
	for !bc.isValidProof(newBlock) {
		newBlock.Nonce++
		newBlock.Hash = newBlock.calculateHash()
	}

	bc.Chain = append(bc.Chain, newBlock)
}

// isValidProof checks if the hash starts with required zeros (difficulty = 2)
func (bc *Blockchain) isValidProof(block Block) bool {
	return block.Hash[:2] == "00" // Simple difficulty
}

// ValidateChain validates the entire blockchain
func (bc *Blockchain) ValidateChain() bool {
	for i := 1; i < len(bc.Chain); i++ {
		currentBlock := bc.Chain[i]
		prevBlock := bc.Chain[i-1]

		// Check if hash is valid
		if currentBlock.Hash != currentBlock.calculateHash() {
			return false
		}

		// Check if previous hash matches
		if currentBlock.PrevHash != prevBlock.Hash {
			return false
		}
	}
	return true
}

// GetLatestBlock returns the latest block
func (bc *Blockchain) GetLatestBlock() Block {
	return bc.Chain[len(bc.Chain)-1]
}

// GetBlockByIndex returns block by index
func (bc *Blockchain) GetBlockByIndex(index int) *Block {
	if index >= 0 && index < len(bc.Chain) {
		return &bc.Chain[index]
	}
	return nil
}

// QueryTransactionsByReservationID finds all transactions for a reservation
func (bc *Blockchain) QueryTransactionsByReservationID(reservationID string) []Transaction {
	var transactions []Transaction

	for _, block := range bc.Chain {
		if tx, exists := block.Data["transaction"]; exists {
			if txData, ok := tx.(map[string]interface{}); ok {
				if txData["reservationId"] == reservationID {
					var transaction Transaction
					jsonData, _ := json.Marshal(txData)
					json.Unmarshal(jsonData, &transaction)
					transactions = append(transactions, transaction)
				}
			}
		}
	}

	return transactions
}

// GetBlockchainInfo returns blockchain statistics
func (bc *Blockchain) GetBlockchainInfo() map[string]interface{} {
	return map[string]interface{}{
		"totalBlocks": len(bc.Chain),
		"latestBlock": bc.GetLatestBlock(),
		"isValid":     bc.ValidateChain(),
		"totalSize":   bc.calculateTotalSize(),
		"genesisHash": bc.Chain[0].Hash,
		"latestHash":  bc.GetLatestBlock().Hash,
		"networkType": "Local Simulation",
		"consensus":   "Proof of Work (Simulated)",
		"difficulty":  2,
	}
}

// calculateTotalSize calculates approximate blockchain size
func (bc *Blockchain) calculateTotalSize() string {
	data, _ := json.Marshal(bc.Chain)
	size := len(data)
	if size < 1024 {
		return fmt.Sprintf("%d bytes", size)
	} else if size < 1024*1024 {
		return fmt.Sprintf("%.2f KB", float64(size)/1024)
	} else {
		return fmt.Sprintf("%.2f MB", float64(size)/(1024*1024))
	}
}

// MockFabricClient simulates Hyperledger Fabric functionality
type MockFabricClient struct {
	Blockchain *Blockchain
	OrgMSP     string
}

// NewMockFabricClient creates a new mock Fabric client
func NewMockFabricClient() *MockFabricClient {
	return &MockFabricClient{
		Blockchain: NewBlockchain(),
		OrgMSP:     "GoBackendMSP",
	}
}

// CreateReservationTx creates a reservation transaction on blockchain
func (mfc *MockFabricClient) CreateReservationTx(reservation map[string]interface{}) error {
	transaction := Transaction{
		TxID:          generateTxID(),
		Type:          "CREATE_RESERVATION",
		ReservationID: reservation["reservation_id"].(string),
		Data:          reservation,
		Timestamp:     time.Now(),
		ActorMSP:      mfc.OrgMSP,
		Signature:     generateSignature(reservation),
	}

	blockData := map[string]interface{}{
		"transaction": transaction,
		"blockType":   "RESERVATION_TX",
		"chaincode":   "reservation",
		"channel":     "mychannel",
	}

	mfc.Blockchain.AddBlock(blockData)
	return nil
}

// UpdateReservationStatusTx updates reservation status on blockchain
func (mfc *MockFabricClient) UpdateReservationStatusTx(reservationID, newStatus, note string) error {
	transaction := Transaction{
		TxID:          generateTxID(),
		Type:          fmt.Sprintf("UPDATE_STATUS_%s", newStatus),
		ReservationID: reservationID,
		Data: map[string]interface{}{
			"reservation_id": reservationID,
			"new_status":     newStatus,
			"note":           note,
			"updated_by":     mfc.OrgMSP,
		},
		Timestamp: time.Now(),
		ActorMSP:  mfc.OrgMSP,
		Signature: generateSignature(map[string]interface{}{"status": newStatus}),
	}

	blockData := map[string]interface{}{
		"transaction": transaction,
		"blockType":   "STATUS_UPDATE_TX",
		"chaincode":   "reservation",
		"channel":     "mychannel",
	}

	mfc.Blockchain.AddBlock(blockData)
	return nil
}

// QueryReservationHistory returns blockchain history for a reservation
func (mfc *MockFabricClient) QueryReservationHistory(reservationID string) []Transaction {
	return mfc.Blockchain.QueryTransactionsByReservationID(reservationID)
}

// GetBlockchainStats returns blockchain statistics
func (mfc *MockFabricClient) GetBlockchainStats() map[string]interface{} {
	return mfc.Blockchain.GetBlockchainInfo()
}

// Helper functions
func generateTxID() string {
	hash := sha256.Sum256([]byte(fmt.Sprintf("%d", time.Now().UnixNano())))
	return hex.EncodeToString(hash[:])[:16]
}

func generateSignature(data map[string]interface{}) string {
	jsonData, _ := json.Marshal(data)
	hash := sha256.Sum256(jsonData)
	return hex.EncodeToString(hash[:])[:32]
}
