package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

// Hotel represents a hotel in the database - MATCH Node.js structure
type Hotel struct {
	ID          int       `json:"id" gorm:"primaryKey;column:id"`
	Name        string    `json:"name" gorm:"column:name"`
	Address     string    `json:"address" gorm:"column:address"`
	City        string    `json:"city" gorm:"column:city"`
	Country     string    `json:"country" gorm:"column:country"`
	Description string    `json:"description" gorm:"column:description"`
	Rating      int       `json:"rating" gorm:"column:rating"`
	ImageURL    string    `json:"image_url" gorm:"column:image_url"`
	CreatedAt   time.Time `json:"created_at" gorm:"column:created_at"`
	UpdatedAt   time.Time `json:"updated_at" gorm:"column:updated_at"`
}

// RoomType represents a room type - MATCH Node.js structure
type RoomType struct {
	ID          int       `json:"id" gorm:"primaryKey;column:id"`
	HotelID     int       `json:"hotel_id" gorm:"column:hotel_id"`
	TypeName    string    `json:"type_name" gorm:"column:type_name"`
	Description string    `json:"description" gorm:"column:description"`
	MaxGuests   int       `json:"max_guests" gorm:"column:max_guests"`
	BasePrice   float64   `json:"base_price" gorm:"column:base_price"`
	Currency    string    `json:"currency" gorm:"column:currency"`
	CreatedAt   time.Time `json:"created_at" gorm:"column:created_at"`
	UpdatedAt   time.Time `json:"updated_at" gorm:"column:updated_at"`
	Hotel       Hotel     `json:"hotel" gorm:"foreignKey:HotelID"`
}

// Reservation represents a reservation - MATCH Node.js structure
type Reservation struct {
	ID            int       `json:"id" gorm:"primaryKey;column:id"`
	ReservationID string    `json:"reservation_id" gorm:"column:reservation_id"`
	HotelID       int       `json:"hotel_id" gorm:"column:hotel_id"`
	RoomTypeID    int       `json:"room_type_id" gorm:"column:room_type_id"`
	CheckIn       time.Time `json:"check_in" gorm:"column:check_in"`
	CheckOut      time.Time `json:"check_out" gorm:"column:check_out"`
	GuestCount    int       `json:"guest_count" gorm:"column:guest_count"`
	CustomerRef   string    `json:"customer_ref" gorm:"column:customer_ref"`
	Price         float64   `json:"price" gorm:"column:price"`
	Currency      string    `json:"currency" gorm:"column:currency"`
	Status        string    `json:"status" gorm:"column:status"`
	CreatedByOrg  string    `json:"created_by_org" gorm:"column:created_by_org"`
	CreatedAt     time.Time `json:"created_at" gorm:"column:created_at"`
	UpdatedAt     time.Time `json:"updated_at" gorm:"column:updated_at"`
	Hotel         Hotel     `json:"hotel" gorm:"foreignKey:HotelID"`
	RoomType      RoomType  `json:"room_type" gorm:"foreignKey:RoomTypeID"`
}

// ReservationHistory represents reservation history events
type ReservationHistory struct {
	ID            int       `json:"id" gorm:"primaryKey;column:id"`
	ReservationID string    `json:"reservation_id" gorm:"column:reservation_id"`
	EventType     string    `json:"event_type" gorm:"column:event_type"`
	ActorMSP      string    `json:"actor_msp" gorm:"column:actor_msp"`
	Note          string    `json:"note" gorm:"column:note"`
	CreatedAt     time.Time `json:"created_at" gorm:"column:created_at"`
}

// API represents the API server with hybrid blockchain support
type API struct {
	DB         *gorm.DB
	Router     *gin.Engine
	Blockchain *MockFabricClient // Local blockchain simulation
	Fabric     *FabricClient     // Real Hyperledger Fabric
	UseFabric  bool              // Switch between mock and real Fabric
}

// NewAPI creates a new API instance with hybrid blockchain support
func NewAPI() *API {
	// Load environment variables
	err := godotenv.Load()
	if err != nil {
		log.Println("No .env file found")
	}

	// Initialize database
	db := initDB()

	// Initialize blockchain systems
	blockchain := NewMockFabricClient()
	fabric := NewFabricClient()

	// Try to initialize real Fabric
	useFabric := false
	if err := fabric.Initialize(); err != nil {
		log.Printf("⚠️ Fabric connection failed: %v", err)
		log.Println("🔄 Falling back to local blockchain simulation")
		useFabric = false
	} else {
		log.Println("✅ Real Hyperledger Fabric connected!")
		useFabric = true
	}

	// Initialize Gin router
	router := gin.Default()

	// Add CORS middleware - Allow all origins for development
	config := cors.DefaultConfig()
	config.AllowOrigins = []string{
		"http://localhost:3000",
		"http://localhost:5173",
		"http://127.0.0.1:3000",
		"http://127.0.0.1:5173",
		"http://[::1]:3000",
	}
	config.AllowMethods = []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"}
	config.AllowHeaders = []string{"Origin", "Content-Type", "Accept", "Authorization", "X-Requested-With"}
	config.AllowCredentials = true
	router.Use(cors.New(config))

	api := &API{
		DB:         db,
		Router:     router,
		Blockchain: blockchain,
		Fabric:     fabric,
		UseFabric:  useFabric,
	}

	// Setup routes
	api.setupRoutes()

	return api
}

// setupRoutes sets up all the API routes
func (api *API) setupRoutes() {
	blockchainType := "Local Simulation (Proof of Work)"
	if api.UseFabric {
		blockchainType = "Hyperledger Fabric"
	}

	// Health check
	api.Router.GET("/", func(c *gin.Context) {
		var stats interface{}
		if api.UseFabric {
			if fabricStats, err := api.Fabric.GetBlockchainInfo(); err == nil {
				stats = fabricStats
			} else {
				stats = map[string]string{"error": err.Error()}
			}
		} else {
			stats = api.Blockchain.GetBlockchainStats()
		}

		c.JSON(http.StatusOK, gin.H{
			"message":        "Hotel Reservation Go Backend with Hybrid Blockchain",
			"status":         "running",
			"database":       "MySQL",
			"blockchain":     blockchainType,
			"fabric_enabled": api.UseFabric,
			"stats":          stats,
			"endpoints": []string{
				"GET /api/v1/hotels",
				"GET /api/v1/hotels/:id",
				"GET /api/v1/hotels/:id/rooms",
				"POST /api/v1/reservations",
				"GET /api/v1/reservations",
				"GET /api/v1/reservations/:id",
				"POST /api/v1/reservations/:id/confirm",
				"POST /api/v1/reservations/:id/cancel",
				"POST /api/v1/reservations/:id/checkin",
				"POST /api/v1/reservations/:id/checkout",
				"GET /api/v1/blockchain/stats",
				"GET /api/v1/blockchain/switch",
				"GET /api/v1/reservations/:id/history",
			},
		})
	})

	v1 := api.Router.Group("/api/v1")
	{
		// Hotel routes
		v1.GET("/hotels", api.getHotels)
		v1.GET("/hotels/:id", api.getHotel)
		v1.GET("/hotels/:id/rooms", api.getHotelRooms)

		// Reservation routes
		v1.POST("/reservations", api.createReservation)
		v1.GET("/reservations", api.getReservations)
		v1.GET("/reservations/:id", api.getReservation)
		v1.POST("/reservations/:id/confirm", api.confirmReservation)
		v1.POST("/reservations/:id/cancel", api.cancelReservation)
		v1.POST("/reservations/:id/checkin", api.checkinReservation)
		v1.POST("/reservations/:id/checkout", api.checkoutReservation)
		v1.GET("/reservations/hotel/:hotelId", api.getHotelReservations)

		// Blockchain routes
		v1.GET("/blockchain/stats", api.getBlockchainStats)
		v1.GET("/blockchain/blocks", api.getBlocks)
		v1.GET("/blockchain/blocks/:index", api.getBlock)
		v1.POST("/blockchain/switch", api.switchBlockchain)
		v1.GET("/reservations/:id/history", api.getReservationHistory)
	}
}

// Hotel handlers
func (api *API) getHotels(c *gin.Context) {
	var hotels []Hotel
	if err := api.DB.Find(&hotels).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch hotels"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"hotels": hotels})
}

func (api *API) getHotel(c *gin.Context) {
	id := c.Param("id")
	var hotel Hotel
	if err := api.DB.First(&hotel, id).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{"error": "Hotel not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch hotel"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"hotel": hotel})
}

func (api *API) getHotelRooms(c *gin.Context) {
	id := c.Param("id")
	var roomTypes []RoomType
	if err := api.DB.Where("hotel_id = ?", id).Find(&roomTypes).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch room types"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"room_types": roomTypes})
}

// Reservation handlers with hybrid blockchain support
func (api *API) createReservation(c *gin.Context) {
	var req struct {
		ReservationID string  `json:"reservation_id"`
		HotelID       string  `json:"hotel_id"`
		RoomTypeID    string  `json:"room_type_id"`
		CheckIn       string  `json:"check_in"`
		CheckOut      string  `json:"check_out"`
		GuestCount    int     `json:"guest_count"`
		CustomerRef   string  `json:"customer_ref"`
		Price         float64 `json:"price"`
		Currency      string  `json:"currency"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request format"})
		return
	}

	// Check if reservation ID already exists
	var existingReservation Reservation
	if err := api.DB.Where("reservation_id = ?", req.ReservationID).First(&existingReservation).Error; err == nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Reservation ID already exists"})
		return
	}

	// Parse dates
	checkIn, err := time.Parse("2006-01-02", req.CheckIn)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid check-in date format"})
		return
	}

	checkOut, err := time.Parse("2006-01-02", req.CheckOut)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid check-out date format"})
		return
	}

	// Convert string IDs to int
	hotelID, _ := strconv.Atoi(req.HotelID)
	roomTypeID, _ := strconv.Atoi(req.RoomTypeID)

	// Create reservation in database
	reservation := Reservation{
		ReservationID: req.ReservationID,
		HotelID:       hotelID,
		RoomTypeID:    roomTypeID,
		CheckIn:       checkIn,
		CheckOut:      checkOut,
		GuestCount:    req.GuestCount,
		CustomerRef:   req.CustomerRef,
		Price:         req.Price,
		Currency:      req.Currency,
		Status:        "PENDING",
		CreatedByOrg:  "GoBackendMSP",
	}

	if err := api.DB.Create(&reservation).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create reservation"})
		return
	}

	// Add to blockchain (hybrid approach)
	blockchainType := "Local Simulation"
	var blockchainErr error

	if api.UseFabric {
		// Use real Hyperledger Fabric
		blockchainErr = api.Fabric.CreateReservation(
			req.ReservationID, req.HotelID, req.RoomTypeID,
			req.CheckIn, req.CheckOut, req.GuestCount,
			req.CustomerRef, req.Price, req.Currency,
		)
		blockchainType = "Hyperledger Fabric"
	} else {
		// Use local blockchain simulation
		blockchainData := map[string]interface{}{
			"reservation_id": req.ReservationID,
			"hotel_id":       req.HotelID,
			"room_type_id":   req.RoomTypeID,
			"check_in":       req.CheckIn,
			"check_out":      req.CheckOut,
			"guest_count":    req.GuestCount,
			"customer_ref":   req.CustomerRef,
			"price":          req.Price,
			"currency":       req.Currency,
			"status":         "PENDING",
			"created_by":     "GoBackendMSP",
		}
		api.Blockchain.CreateReservationTx(blockchainData)
		blockchainType = "Local Simulation"
	}

	// Create history event
	api.createHistoryEvent(req.ReservationID, "CREATED",
		fmt.Sprintf("Reservation created via Go backend with %s", blockchainType))

	response := gin.H{
		"message":        "Reservation created successfully on blockchain",
		"reservation_id": req.ReservationID,
		"blockchain":     blockchainType,
	}

	if blockchainErr != nil {
		response["blockchain_warning"] = fmt.Sprintf("Database saved but blockchain failed: %v", blockchainErr)
	}

	c.JSON(http.StatusCreated, response)
}

func (api *API) getReservations(c *gin.Context) {
	status := c.Query("status")

	var reservations []Reservation
	query := api.DB.Preload("Hotel").Preload("RoomType")

	if status != "" {
		query = query.Where("status = ?", status)
	}

	if err := query.Find(&reservations).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch reservations"})
		return
	}

	// Format response to match frontend expectations
	var formattedReservations []map[string]interface{}
	for _, r := range reservations {
		formattedReservations = append(formattedReservations, map[string]interface{}{
			"reservationID": r.ReservationID,
			"hotelID":       fmt.Sprintf("%d", r.HotelID),
			"roomTypeID":    fmt.Sprintf("%d", r.RoomTypeID),
			"checkIn":       r.CheckIn.Format("2006-01-02"),
			"checkOut":      r.CheckOut.Format("2006-01-02"),
			"guestCount":    r.GuestCount,
			"customerRef":   r.CustomerRef,
			"price":         r.Price,
			"currency":      r.Currency,
			"status":        r.Status,
			"createdByOrg":  r.CreatedByOrg,
			"lastUpdatedAt": r.UpdatedAt,
			"hotelName":     r.Hotel.Name,
			"roomTypeName":  r.RoomType.TypeName,
		})
	}

	c.JSON(http.StatusOK, gin.H{"reservations": formattedReservations})
}

func (api *API) getReservation(c *gin.Context) {
	id := c.Param("id")
	var reservation Reservation

	if err := api.DB.Preload("Hotel").Preload("RoomType").Where("reservation_id = ?", id).First(&reservation).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{"error": "Reservation not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch reservation"})
		return
	}

	// Format response
	formattedReservation := map[string]interface{}{
		"reservationID": reservation.ReservationID,
		"hotelID":       fmt.Sprintf("%d", reservation.HotelID),
		"roomTypeID":    fmt.Sprintf("%d", reservation.RoomTypeID),
		"checkIn":       reservation.CheckIn.Format("2006-01-02"),
		"checkOut":      reservation.CheckOut.Format("2006-01-02"),
		"guestCount":    reservation.GuestCount,
		"customerRef":   reservation.CustomerRef,
		"price":         reservation.Price,
		"currency":      reservation.Currency,
		"status":        reservation.Status,
		"createdByOrg":  reservation.CreatedByOrg,
		"lastUpdatedAt": reservation.UpdatedAt,
		"hotelName":     reservation.Hotel.Name,
		"roomTypeName":  reservation.RoomType.TypeName,
	}

	c.JSON(http.StatusOK, gin.H{"reservation": formattedReservation})
}

func (api *API) confirmReservation(c *gin.Context) {
	api.updateReservationStatus(c, "CONFIRMED", "Reservation confirmed")
}

func (api *API) cancelReservation(c *gin.Context) {
	api.updateReservationStatus(c, "CANCELLED", "Reservation cancelled")
}

func (api *API) checkinReservation(c *gin.Context) {
	api.updateReservationStatus(c, "CHECKED_IN", "Guest checked in")
}

func (api *API) checkoutReservation(c *gin.Context) {
	api.updateReservationStatus(c, "CHECKED_OUT", "Guest checked out")
}

func (api *API) updateReservationStatus(c *gin.Context, newStatus, defaultNote string) {
	id := c.Param("id")

	var req struct {
		Note string `json:"note"`
	}
	c.ShouldBindJSON(&req)

	note := req.Note
	if note == "" {
		note = defaultNote
	}

	// Check if reservation exists
	var reservation Reservation
	if err := api.DB.Where("reservation_id = ?", id).First(&reservation).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{"error": "Reservation not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch reservation"})
		return
	}

	// Validate status transition
	if !api.isValidStatusTransition(reservation.Status, newStatus) {
		c.JSON(http.StatusBadRequest, gin.H{"error": fmt.Sprintf("Cannot change status from %s to %s", reservation.Status, newStatus)})
		return
	}

	// Update status in database
	if err := api.DB.Model(&reservation).Update("status", newStatus).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update reservation status"})
		return
	}

	// Update blockchain (hybrid approach)
	blockchainType := "Local Simulation"
	var blockchainErr error

	if api.UseFabric {
		// Use real Hyperledger Fabric
		switch newStatus {
		case "CONFIRMED":
			blockchainErr = api.Fabric.ConfirmReservation(id, note)
		case "CANCELLED":
			blockchainErr = api.Fabric.CancelReservation(id, note)
		case "CHECKED_IN":
			blockchainErr = api.Fabric.CheckIn(id, note)
		case "CHECKED_OUT":
			blockchainErr = api.Fabric.CheckOut(id, note)
		}
		blockchainType = "Hyperledger Fabric"
	} else {
		// Use local blockchain simulation
		api.Blockchain.UpdateReservationStatusTx(id, newStatus, note)
	}

	// Create history event
	api.createHistoryEvent(id, newStatus, note)

	response := gin.H{
		"message":    fmt.Sprintf("Reservation %s successfully", newStatus),
		"blockchain": blockchainType,
	}

	if blockchainErr != nil {
		response["blockchain_warning"] = fmt.Sprintf("Database updated but blockchain failed: %v", blockchainErr)
	}

	c.JSON(http.StatusOK, response)
}

func (api *API) getHotelReservations(c *gin.Context) {
	hotelID := c.Param("hotelId")
	startDate := c.Query("start_date")
	endDate := c.Query("end_date")

	var reservations []Reservation
	query := api.DB.Preload("Hotel").Preload("RoomType").Where("hotel_id = ?", hotelID)

	if startDate != "" && endDate != "" {
		query = query.Where("check_in >= ? AND check_in <= ?", startDate, endDate)
	}

	if err := query.Find(&reservations).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch hotel reservations"})
		return
	}

	// Format response
	var formattedReservations []map[string]interface{}
	for _, r := range reservations {
		formattedReservations = append(formattedReservations, map[string]interface{}{
			"reservationID": r.ReservationID,
			"hotelID":       fmt.Sprintf("%d", r.HotelID),
			"roomTypeID":    fmt.Sprintf("%d", r.RoomTypeID),
			"checkIn":       r.CheckIn.Format("2006-01-02"),
			"checkOut":      r.CheckOut.Format("2006-01-02"),
			"guestCount":    r.GuestCount,
			"customerRef":   r.CustomerRef,
			"price":         r.Price,
			"currency":      r.Currency,
			"status":        r.Status,
			"createdByOrg":  r.CreatedByOrg,
			"lastUpdatedAt": r.UpdatedAt,
			"hotelName":     r.Hotel.Name,
			"roomTypeName":  r.RoomType.TypeName,
		})
	}

	c.JSON(http.StatusOK, gin.H{"reservations": formattedReservations})
}

// Blockchain handlers
func (api *API) getBlockchainStats(c *gin.Context) {
	if api.UseFabric {
		if stats, err := api.Fabric.GetBlockchainInfo(); err == nil {
			c.JSON(http.StatusOK, gin.H{"blockchain": stats, "type": "Hyperledger Fabric"})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		}
	} else {
		stats := api.Blockchain.GetBlockchainStats()
		c.JSON(http.StatusOK, gin.H{"blockchain": stats, "type": "Local Simulation"})
	}
}

func (api *API) getBlocks(c *gin.Context) {
	if api.UseFabric {
		c.JSON(http.StatusOK, gin.H{"message": "Block query not available in Fabric mode", "type": "Hyperledger Fabric"})
	} else {
		c.JSON(http.StatusOK, gin.H{"blocks": api.Blockchain.Blockchain.Chain, "type": "Local Simulation"})
	}
}

func (api *API) getBlock(c *gin.Context) {
	if api.UseFabric {
		c.JSON(http.StatusOK, gin.H{"message": "Block query not available in Fabric mode", "type": "Hyperledger Fabric"})
		return
	}

	indexStr := c.Param("index")
	index, err := strconv.Atoi(indexStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid block index"})
		return
	}

	block := api.Blockchain.Blockchain.GetBlockByIndex(index)
	if block == nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Block not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"block": block, "type": "Local Simulation"})
}

func (api *API) switchBlockchain(c *gin.Context) {
	var req struct {
		UseFabric bool `json:"use_fabric"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request format"})
		return
	}

	if req.UseFabric && !api.Fabric.IsConnected {
		if err := api.Fabric.Initialize(); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{
				"error":   "Cannot switch to Fabric: connection failed",
				"details": err.Error(),
			})
			return
		}
	}

	api.UseFabric = req.UseFabric
	blockchainType := "Local Simulation"
	if api.UseFabric {
		blockchainType = "Hyperledger Fabric"
	}

	c.JSON(http.StatusOK, gin.H{
		"message":    fmt.Sprintf("Switched to %s", blockchainType),
		"use_fabric": api.UseFabric,
		"type":       blockchainType,
	})
}

func (api *API) getReservationHistory(c *gin.Context) {
	id := c.Param("id")

	// Always also get real database history
	var dbHistory []ReservationHistory
	api.DB.Where("reservation_id = ?", id).Order("created_at ASC").Find(&dbHistory)

	// Convert database history to common format
	var historyData []map[string]interface{}
	for _, h := range dbHistory {
		historyData = append(historyData, map[string]interface{}{
			"tx_id":      fmt.Sprintf("db_%d", h.ID),
			"timestamp":  h.CreatedAt.Format("2006-01-02T15:04:05Z"),
			"event_type": h.EventType,
			"actor_msp":  h.ActorMSP,
			"note":       h.Note,
			"block_num":  0, // Database events don't have block numbers
			"source":     "database",
		})
	}

	if api.UseFabric {
		// Get blockchain history and combine with database
		if blockchainHistory, err := api.Fabric.GetReservationHistory(id); err == nil {
			// Mark blockchain entries
			for _, bh := range blockchainHistory {
				bh["source"] = "blockchain"
				historyData = append(historyData, bh)
			}
			c.JSON(http.StatusOK, gin.H{
				"history":    historyData,
				"blockchain": "Hyperledger Fabric + Database",
				"total":      len(historyData),
			})
		} else {
			c.JSON(http.StatusOK, gin.H{
				"history":    historyData,
				"blockchain": "Database Only (Fabric Error)",
				"total":      len(historyData),
				"error":      err.Error(),
			})
		}
	} else {
		// Get local blockchain history and combine
		blockchainHistory := api.Blockchain.QueryReservationHistory(id)

		// Convert blockchain transactions to common format
		for _, tx := range blockchainHistory {
			historyData = append(historyData, map[string]interface{}{
				"tx_id":      tx.TxID,
				"timestamp":  tx.Timestamp.Format("2006-01-02T15:04:05Z"),
				"event_type": tx.Type,
				"actor_msp":  tx.ActorMSP,
				"note":       fmt.Sprintf("Transaction: %s for reservation %s", tx.Type, tx.ReservationID),
				"block_num":  0, // Local blockchain doesn't have block numbers yet
				"source":     "local_blockchain",
			})
		}

		c.JSON(http.StatusOK, gin.H{
			"history":    historyData,
			"blockchain": "Local Simulation + Database",
			"total":      len(historyData),
		})
	}
}

// Helper functions
func (api *API) createHistoryEvent(reservationID, eventType, note string) {
	history := ReservationHistory{
		ReservationID: reservationID,
		EventType:     eventType,
		ActorMSP:      "GoBackendMSP",
		Note:          note,
	}
	api.DB.Create(&history)
}

func (api *API) isValidStatusTransition(currentStatus, newStatus string) bool {
	validTransitions := map[string][]string{
		"PENDING":     {"CONFIRMED", "CANCELLED"},
		"CONFIRMED":   {"CHECKED_IN", "CANCELLED"},
		"CHECKED_IN":  {"CHECKED_OUT"},
		"CHECKED_OUT": {},
		"CANCELLED":   {},
	}

	allowedStatuses, exists := validTransitions[currentStatus]
	if !exists {
		return false
	}

	for _, status := range allowedStatuses {
		if status == newStatus {
			return true
		}
	}
	return false
}

// Database initialization
func initDB() *gorm.DB {
	host := getEnv("DB_HOST", "localhost")
	port := getEnv("DB_PORT", "3306")
	user := getEnv("DB_USER", "root")
	password := getEnv("DB_PASSWORD", "")
	dbname := getEnv("DB_NAME", "reservation")

	dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local",
		user, password, host, port, dbname)

	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	log.Println("✅ Database connected successfully")
	log.Println("⚠️  Using existing tables created by Node.js backend")

	// Auto-create reservation_history table if not exists
	err = db.Exec(`
		CREATE TABLE IF NOT EXISTS reservation_history (
			id INT AUTO_INCREMENT PRIMARY KEY,
			reservation_id VARCHAR(255) NOT NULL,
			event_type VARCHAR(50) NOT NULL,
			actor_msp VARCHAR(100) NOT NULL,
			note TEXT,
			created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
			INDEX idx_reservation_id (reservation_id),
			INDEX idx_event_type (event_type),
			INDEX idx_created_at (created_at)
		)
	`).Error
	if err != nil {
		log.Printf("⚠️ Failed to create reservation_history table: %v", err)
	} else {
		log.Println("✅ reservation_history table ready")
	}

	return db
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

func main() {
	port := getEnv("PORT", "8080")

	fmt.Println("🚀 Starting Hotel Reservation Go Backend with Hybrid Blockchain...")
	fmt.Printf("🌐 Go version: %s\n", "1.25.2")
	fmt.Println("🗄️  Database: MySQL")
	fmt.Println("⛓️  Blockchain: Hybrid (Local Simulation + Hyperledger Fabric)")
	fmt.Println("🔗 Features: Auto-fallback, Runtime switching, Immutable ledger")

	api := NewAPI()

	fmt.Printf("🚀 Go Backend Server running on port %s\n", port)
	fmt.Printf("📍 API Base URL: http://localhost:%s/api/v1\n", port)
	fmt.Printf("⛓️  Blockchain API: http://localhost:%s/api/v1/blockchain/stats\n", port)
	fmt.Printf("🔄 Switch blockchain: POST http://localhost:%s/api/v1/blockchain/switch\n", port)
	fmt.Println("✨ Hybrid blockchain backend ready!")

	log.Fatal(api.Router.Run(":" + port))
}
