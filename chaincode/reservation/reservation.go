package main

import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// SmartContract provides functions for managing reservations
type SmartContract struct {
	contractapi.Contract
}

// Reservation represents a hotel reservation on the blockchain
type Reservation struct {
	ReservationID    string  `json:"reservationID"`
	HotelID          string  `json:"hotelID"`
	RoomTypeID       string  `json:"roomTypeID"`
	CheckIn          string  `json:"checkIn"`
	CheckOut         string  `json:"checkOut"`
	GuestCount       int     `json:"guestCount"`
	EventType        string  `json:"eventType"`
	EventDescription string  `json:"eventDescription"`
	CustomerName     string  `json:"customerName"`
	CustomerPhone    string  `json:"customerPhone"`
	CustomerEmail    string  `json:"customerEmail"`
	CustomerRef      string  `json:"customerRef"`
	PricePerPerson   float64 `json:"pricePerPerson"`
	TotalPrice       float64 `json:"totalPrice"`
	Currency         string  `json:"currency"`
	Status           string  `json:"status"`
	CreatedByOrg     string  `json:"createdByOrg"`
	CreatedAt        string  `json:"createdAt"`
	UpdatedAt        string  `json:"updatedAt"`
}

// HistoryRecord represents reservation history
type HistoryRecord struct {
	TxID      string      `json:"txId"`
	Timestamp string      `json:"timestamp"`
	IsDelete  bool        `json:"isDelete"`
	Value     Reservation `json:"value"`
}

// InitLedger initializes the ledger with sample data
func (s *SmartContract) InitLedger(ctx contractapi.TransactionContextInterface) error {
	fmt.Println("Initializing Hotel Reservation Ledger...")

	// Sample reservation for testing
	reservation := Reservation{
		ReservationID:    "RES-INIT-001",
		HotelID:          "1",
		RoomTypeID:       "1",
		CheckIn:          "2025-12-01",
		CheckOut:         "2025-12-03",
		GuestCount:       50,
		EventType:        "Corporate Meeting",
		EventDescription: "End of year corporate meeting",
		CustomerName:     "PT. Example Corporation",
		CustomerPhone:    "08123456789",
		CustomerEmail:    "contact@example.com",
		CustomerRef:      "CUST-INIT-001",
		PricePerPerson:   1500000,
		TotalPrice:       75000000,
		Currency:         "IDR",
		Status:           "CONFIRMED",
		CreatedByOrg:     "HotelOrgMSP",
		CreatedAt:        time.Now().Format(time.RFC3339),
		UpdatedAt:        time.Now().Format(time.RFC3339),
	}

	reservationJSON, err := json.Marshal(reservation)
	if err != nil {
		return fmt.Errorf("failed to marshal reservation: %v", err)
	}

	err = ctx.GetStub().PutState(reservation.ReservationID, reservationJSON)
	if err != nil {
		return fmt.Errorf("failed to put reservation to world state: %v", err)
	}

	fmt.Println("✅ Ledger initialized successfully")
	return nil
}

// CreateReservation creates a new reservation on the blockchain
func (s *SmartContract) CreateReservation(
	ctx contractapi.TransactionContextInterface,
	reservationID, hotelID, roomTypeID, checkIn, checkOut string,
	guestCount int,
	eventType, eventDescription,
	customerName, customerPhone, customerEmail, customerRef string,
	pricePerPerson, totalPrice float64,
	currency string,
) error {

	// Check if reservation already exists
	exists, err := s.ReservationExists(ctx, reservationID)
	if err != nil {
		return fmt.Errorf("failed to check reservation existence: %v", err)
	}
	if exists {
		return fmt.Errorf("reservation %s already exists", reservationID)
	}

	// Get transaction creator MSP ID
	mspID, err := ctx.GetClientIdentity().GetMSPID()
	if err != nil {
		return fmt.Errorf("failed to get MSP ID: %v", err)
	}

	// Create reservation object
	reservation := Reservation{
		ReservationID:    reservationID,
		HotelID:          hotelID,
		RoomTypeID:       roomTypeID,
		CheckIn:          checkIn,
		CheckOut:         checkOut,
		GuestCount:       guestCount,
		EventType:        eventType,
		EventDescription: eventDescription,
		CustomerName:     customerName,
		CustomerPhone:    customerPhone,
		CustomerEmail:    customerEmail,
		CustomerRef:      customerRef,
		PricePerPerson:   pricePerPerson,
		TotalPrice:       totalPrice,
		Currency:         currency,
		Status:           "PENDING",
		CreatedByOrg:     mspID,
		CreatedAt:        time.Now().Format(time.RFC3339),
		UpdatedAt:        time.Now().Format(time.RFC3339),
	}

	reservationJSON, err := json.Marshal(reservation)
	if err != nil {
		return fmt.Errorf("failed to marshal reservation: %v", err)
	}

	err = ctx.GetStub().PutState(reservationID, reservationJSON)
	if err != nil {
		return fmt.Errorf("failed to put reservation to world state: %v", err)
	}

	fmt.Printf("✅ Reservation %s created successfully by %s\n", reservationID, mspID)
	return nil
}

// GetReservation retrieves a reservation from the blockchain
func (s *SmartContract) GetReservation(ctx contractapi.TransactionContextInterface, reservationID string) (*Reservation, error) {
	reservationJSON, err := ctx.GetStub().GetState(reservationID)
	if err != nil {
		return nil, fmt.Errorf("failed to read reservation: %v", err)
	}
	if reservationJSON == nil {
		return nil, fmt.Errorf("reservation %s does not exist", reservationID)
	}

	var reservation Reservation
	err = json.Unmarshal(reservationJSON, &reservation)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal reservation: %v", err)
	}

	return &reservation, nil
}

// UpdateReservationStatus updates the status of a reservation
func (s *SmartContract) UpdateReservationStatus(ctx contractapi.TransactionContextInterface, reservationID, newStatus string) error {
	reservation, err := s.GetReservation(ctx, reservationID)
	if err != nil {
		return err
	}

	reservation.Status = newStatus
	reservation.UpdatedAt = time.Now().Format(time.RFC3339)

	reservationJSON, err := json.Marshal(reservation)
	if err != nil {
		return fmt.Errorf("failed to marshal reservation: %v", err)
	}

	err = ctx.GetStub().PutState(reservationID, reservationJSON)
	if err != nil {
		return fmt.Errorf("failed to update reservation: %v", err)
	}

	fmt.Printf("✅ Reservation %s status updated to %s\n", reservationID, newStatus)
	return nil
}

// ConfirmReservation confirms a pending reservation
func (s *SmartContract) ConfirmReservation(ctx contractapi.TransactionContextInterface, reservationID string) error {
	return s.UpdateReservationStatus(ctx, reservationID, "CONFIRMED")
}

// CancelReservation cancels a reservation
func (s *SmartContract) CancelReservation(ctx contractapi.TransactionContextInterface, reservationID string) error {
	return s.UpdateReservationStatus(ctx, reservationID, "CANCELLED")
}

// CheckIn marks a reservation as checked in
func (s *SmartContract) CheckIn(ctx contractapi.TransactionContextInterface, reservationID string) error {
	return s.UpdateReservationStatus(ctx, reservationID, "CHECKED_IN")
}

// CheckOut marks a reservation as checked out
func (s *SmartContract) CheckOut(ctx contractapi.TransactionContextInterface, reservationID string) error {
	return s.UpdateReservationStatus(ctx, reservationID, "CHECKED_OUT")
}

// GetAllReservations returns all reservations
func (s *SmartContract) GetAllReservations(ctx contractapi.TransactionContextInterface) ([]*Reservation, error) {
	resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
	if err != nil {
		return nil, fmt.Errorf("failed to get state by range: %v", err)
	}
	defer resultsIterator.Close()

	var reservations []*Reservation
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		var reservation Reservation
		err = json.Unmarshal(queryResponse.Value, &reservation)
		if err != nil {
			return nil, err
		}
		reservations = append(reservations, &reservation)
	}

	return reservations, nil
}

// GetReservationHistory returns the history of a reservation
func (s *SmartContract) GetReservationHistory(ctx contractapi.TransactionContextInterface, reservationID string) ([]HistoryRecord, error) {
	resultsIterator, err := ctx.GetStub().GetHistoryForKey(reservationID)
	if err != nil {
		return nil, fmt.Errorf("failed to get history: %v", err)
	}
	defer resultsIterator.Close()

	var history []HistoryRecord
	for resultsIterator.HasNext() {
		response, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		var reservation Reservation
		if len(response.Value) > 0 {
			err = json.Unmarshal(response.Value, &reservation)
			if err != nil {
				return nil, err
			}
		}

		record := HistoryRecord{
			TxID:      response.TxId,
			Timestamp: time.Unix(response.Timestamp.Seconds, int64(response.Timestamp.Nanos)).Format(time.RFC3339),
			IsDelete:  response.IsDelete,
			Value:     reservation,
		}
		history = append(history, record)
	}

	return history, nil
}

// ReservationExists checks if a reservation exists
func (s *SmartContract) ReservationExists(ctx contractapi.TransactionContextInterface, reservationID string) (bool, error) {
	reservationJSON, err := ctx.GetStub().GetState(reservationID)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}

	return reservationJSON != nil, nil
}

func main() {
	chaincode, err := contractapi.NewChaincode(&SmartContract{})
	if err != nil {
		fmt.Printf("Error creating reservation chaincode: %v\n", err)
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting reservation chaincode: %v\n", err)
	}
}
