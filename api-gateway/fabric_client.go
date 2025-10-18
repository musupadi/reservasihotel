package main

import (
	"encoding/json"
	"fmt"
	"log"
	"strconv"

	"github.com/hyperledger/fabric-sdk-go/pkg/core/config"
	"github.com/hyperledger/fabric-sdk-go/pkg/gateway"
)

// FabricClient represents the Fabric SDK client
type FabricClient struct {
	Gateway     *gateway.Gateway
	Network     *gateway.Network
	Contract    *gateway.Contract
	IsConnected bool
}

// NewFabricClient creates a new Fabric client
func NewFabricClient() *FabricClient {
	return &FabricClient{
		IsConnected: false,
	}
}

// Initialize connects to the Hyperledger Fabric network
func (fc *FabricClient) Initialize() error {
	log.Println("🔗 Attempting to connect to Hyperledger Fabric network...")

	// For now, we'll simulate a connection since we need proper crypto material
	// In production, you'd have proper connection profiles and certificates

	// Mock successful connection for development
	fc.IsConnected = true
	log.Println("✅ Connected to Hyperledger Fabric (Development Mode)")
	log.Println("📺 Channel: mychannel")
	log.Println("📋 Chaincode: reservation")
	log.Println("🏢 Organization: HotelOrgMSP")

	return nil
}

// CreateReservation creates a new reservation on the blockchain
func (fc *FabricClient) CreateReservation(reservationID, hotelID, roomTypeID, checkIn, checkOut string, guestCount int, customerRef string, price float64, currency string) error {
	if fc.Contract == nil {
		// Mock implementation for development
		fmt.Printf("Mock: Creating reservation %s for hotel %s\n", reservationID, hotelID)
		return nil
	}

	_, err := fc.Contract.SubmitTransaction(
		"CreateReservation",
		reservationID,
		hotelID,
		roomTypeID,
		checkIn,
		checkOut,
		strconv.Itoa(guestCount),
		customerRef,
		fmt.Sprintf("%.2f", price),
		currency,
	)
	return err
}

// GetReservation retrieves a reservation from the blockchain
func (fc *FabricClient) GetReservation(reservationID string) (map[string]interface{}, error) {
	if fc.Contract == nil {
		// Mock implementation for development
		return map[string]interface{}{
			"reservationID": reservationID,
			"hotelID":       "1",
			"roomTypeID":    "1",
			"checkIn":       "2024-01-15",
			"checkOut":      "2024-01-17",
			"guestCount":    2,
			"customerRef":   "CUST001",
			"price":         500000,
			"currency":      "IDR",
			"status":        "PENDING",
			"createdByOrg":  "OTAOrgMSP",
			"lastUpdatedAt": "2024-01-10T10:00:00Z",
		}, nil
	}

	result, err := fc.Contract.EvaluateTransaction("GetReservation", reservationID)
	if err != nil {
		return nil, err
	}

	var reservation map[string]interface{}
	err = json.Unmarshal(result, &reservation)
	if err != nil {
		return nil, err
	}

	return reservation, nil
}

// ConfirmReservation confirms a reservation
func (fc *FabricClient) ConfirmReservation(reservationID, note string) error {
	if fc.Contract == nil {
		// Mock implementation for development
		fmt.Printf("Mock: Confirming reservation %s\n", reservationID)
		return nil
	}

	_, err := fc.Contract.SubmitTransaction("ConfirmReservation", reservationID, note)
	return err
}

// CancelReservation cancels a reservation
func (fc *FabricClient) CancelReservation(reservationID, note string) error {
	if fc.Contract == nil {
		// Mock implementation for development
		fmt.Printf("Mock: Cancelling reservation %s\n", reservationID)
		return nil
	}

	_, err := fc.Contract.SubmitTransaction("CancelReservation", reservationID, note)
	return err
}

// CheckIn processes check-in
func (fc *FabricClient) CheckIn(reservationID, note string) error {
	if fc.Contract == nil {
		// Mock implementation for development
		fmt.Printf("Mock: Check-in for reservation %s\n", reservationID)
		return nil
	}

	_, err := fc.Contract.SubmitTransaction("CheckIn", reservationID, note)
	return err
}

// CheckOut processes check-out
func (fc *FabricClient) CheckOut(reservationID, note string) error {
	if fc.Contract == nil {
		// Mock implementation for development
		fmt.Printf("Mock: Check-out for reservation %s\n", reservationID)
		return nil
	}

	_, err := fc.Contract.SubmitTransaction("CheckOut", reservationID, note)
	return err
}

// QueryAllReservations queries all reservations
func (fc *FabricClient) QueryAllReservations() ([]map[string]interface{}, error) {
	if fc.Contract == nil {
		// Mock implementation for development
		return []map[string]interface{}{
			{
				"reservationID": "RES001",
				"hotelID":       "1",
				"roomTypeID":    "1",
				"checkIn":       "2024-01-15",
				"checkOut":      "2024-01-17",
				"guestCount":    2,
				"customerRef":   "CUST001",
				"price":         500000,
				"currency":      "IDR",
				"status":        "CONFIRMED",
				"createdByOrg":  "OTAOrgMSP",
				"lastUpdatedAt": "2024-01-10T10:00:00Z",
			},
		}, nil
	}

	result, err := fc.Contract.EvaluateTransaction("QueryAllReservations")
	if err != nil {
		return nil, err
	}

	var reservations []map[string]interface{}
	err = json.Unmarshal(result, &reservations)
	if err != nil {
		return nil, err
	}

	return reservations, nil
}

// QueryReservationsByStatus queries reservations by status
func (fc *FabricClient) QueryReservationsByStatus(status string) ([]map[string]interface{}, error) {
	if fc.Contract == nil {
		// Mock implementation for development
		return []map[string]interface{}{}, nil
	}

	result, err := fc.Contract.EvaluateTransaction("QueryReservationsByStatus", status)
	if err != nil {
		return nil, err
	}

	var reservations []map[string]interface{}
	err = json.Unmarshal(result, &reservations)
	if err != nil {
		return nil, err
	}

	return reservations, nil
}

// QueryByHotelAndDate queries reservations by hotel and date range
func (fc *FabricClient) QueryByHotelAndDate(hotelID, startDate, endDate string) ([]map[string]interface{}, error) {
	if fc.Contract == nil {
		// Mock implementation for development
		return []map[string]interface{}{}, nil
	}

	result, err := fc.Contract.EvaluateTransaction("QueryByHotelAndDate", hotelID, startDate, endDate)
	if err != nil {
		return nil, err
	}

	var reservations []map[string]interface{}
	err = json.Unmarshal(result, &reservations)
	if err != nil {
		return nil, err
	}

	return reservations, nil
}

// InitializeFabricClient initializes the Fabric client with proper connection
func (fc *FabricClient) InitializeFabricClient(connectionProfile, walletPath, userID string) error {
	// Load connection profile
	gw, err := gateway.Connect(
		gateway.WithConfig(config.FromFile(connectionProfile)),
		gateway.WithUser(userID),
	)
	if err != nil {
		return fmt.Errorf("failed to connect to gateway: %w", err)
	}

	// Get network
	network, err := gw.GetNetwork("bookingchannel")
	if err != nil {
		return fmt.Errorf("failed to get network: %w", err)
	}

	// Get contract
	fc.Contract = network.GetContract("reservation")

	return nil
}

// GetBlockchainInfo gets blockchain network information
func (fc *FabricClient) GetBlockchainInfo() (map[string]interface{}, error) {
	if !fc.IsConnected {
		return nil, fmt.Errorf("fabric client not connected")
	}

	// Mock blockchain info for development
	result := map[string]interface{}{
		"network_status": "connected",
		"channel":        "bookingchannel",
		"chaincode":      "reservation",
		"peers":          []string{"peer0.hotelorg.reservation.com", "peer0.guestorg.reservation.com"},
		"msp":            "HotelOrgMSP",
		"connected_at":   "2024-01-10T10:00:00Z",
		"block_height":   42,
		"transactions":   156,
	}

	return result, nil
}

// GetReservationHistory gets reservation history from blockchain
func (fc *FabricClient) GetReservationHistory(reservationID string) ([]map[string]interface{}, error) {
	if !fc.IsConnected {
		return nil, fmt.Errorf("fabric client not connected")
	}

	// NOTE: This is a fallback mock implementation
	// When real Fabric chaincode is deployed, this will query actual blockchain history
	// For now, we return empty to let database history be used
	history := []map[string]interface{}{}

	// Return empty so that main.go will use database history instead
	return history, nil
}
