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
	"github.com/golang-jwt/jwt/v5"
	"github.com/joho/godotenv"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

// User represents a user in the system
type User struct {
	ID            int       `json:"id" gorm:"primaryKey;column:id"`
	Email         string    `json:"email" gorm:"column:email;unique"`
	Password      string    `json:"-" gorm:"column:password"`
	FullName      string    `json:"full_name" gorm:"column:full_name"`
	Phone         string    `json:"phone" gorm:"column:phone"`
	Company       string    `json:"company" gorm:"column:company"`
	Role          string    `json:"role" gorm:"column:role;default:'user'"`
	IsActive      bool      `json:"is_active" gorm:"column:is_active;default:true"`
	EmailVerified bool      `json:"email_verified" gorm:"column:email_verified;default:false"`
	LastLogin     time.Time `json:"last_login" gorm:"column:last_login"`
	CreatedAt     time.Time `json:"created_at" gorm:"column:created_at"`
	UpdatedAt     time.Time `json:"updated_at" gorm:"column:updated_at"`
}

// Hotel represents a hotel in the database - MATCH Node.js structure
type Hotel struct {
	ID          int       `json:"id" gorm:"primaryKey;column:id"`
	Name        string    `json:"name" gorm:"column:name"`
	Address     string    `json:"address" gorm:"column:address"`
	City        string    `json:"city" gorm:"column:city"`
	Country     string    `json:"country" gorm:"column:country"`
	Description string    `json:"description" gorm:"column:description"`
	Rating      float64   `json:"rating" gorm:"column:rating"`
	ImageURL    string    `json:"image_url" gorm:"column:image_url"`
	CreatedAt   time.Time `json:"created_at" gorm:"column:created_at"`
	UpdatedAt   time.Time `json:"updated_at" gorm:"column:updated_at"`
}

// RoomType represents a room type - UPDATED untuk Meeting Package
type RoomType struct {
	ID             int       `json:"id" gorm:"primaryKey;column:id"`
	HotelID        int       `json:"hotel_id" gorm:"column:hotel_id"`
	TypeName       string    `json:"type_name" gorm:"column:type_name"`
	Description    string    `json:"description" gorm:"column:description"`
	PricePerPerson float64   `json:"price_per_person" gorm:"column:price_per_person"`
	MinCapacity    int       `json:"min_capacity" gorm:"column:min_capacity"`
	MaxCapacity    int       `json:"max_capacity" gorm:"column:max_capacity"`
	AvailableRooms int       `json:"available_rooms" gorm:"column:available_rooms"`
	Amenities      string    `json:"amenities" gorm:"column:amenities"`
	CreatedAt      time.Time `json:"created_at" gorm:"column:created_at"`
	UpdatedAt      time.Time `json:"updated_at" gorm:"column:updated_at"`
	Hotel          Hotel     `json:"hotel" gorm:"foreignKey:HotelID"`
}

// Reservation represents a reservation - UPDATED untuk Event Booking
type Reservation struct {
	ID               int       `json:"id" gorm:"primaryKey;column:id"`
	UserID           *int      `json:"user_id" gorm:"column:user_id"`
	ReservationID    string    `json:"reservation_id" gorm:"column:reservation_id"`
	HotelID          int       `json:"hotel_id" gorm:"column:hotel_id"`
	RoomTypeID       int       `json:"room_type_id" gorm:"column:room_type_id"`
	CheckIn          time.Time `json:"check_in" gorm:"column:check_in"`
	CheckOut         time.Time `json:"check_out" gorm:"column:check_out"`
	GuestCount       int       `json:"guest_count" gorm:"column:guest_count"`
	EventType        string    `json:"event_type" gorm:"column:event_type"`
	EventDescription string    `json:"event_description" gorm:"column:event_description"`
	CustomerName     string    `json:"customer_name" gorm:"column:customer_name"`
	CustomerPhone    string    `json:"customer_phone" gorm:"column:customer_phone"`
	CustomerEmail    string    `json:"customer_email" gorm:"column:customer_email"`
	CustomerRef      string    `json:"customer_ref" gorm:"column:customer_ref"`
	PricePerPerson   float64   `json:"price_per_person" gorm:"column:price_per_person"`
	TotalPrice       float64   `json:"total_price" gorm:"column:total_price"`
	Currency         string    `json:"currency" gorm:"column:currency"`
	Status           string    `json:"status" gorm:"column:status"`
	CreatedByOrg     string    `json:"created_by_org" gorm:"column:created_by_org"`
	CreatedAt        time.Time `json:"created_at" gorm:"column:created_at"`
	UpdatedAt        time.Time `json:"updated_at" gorm:"column:updated_at"`
	Hotel            Hotel     `json:"hotel" gorm:"foreignKey:HotelID"`
	RoomType         RoomType  `json:"room_type" gorm:"foreignKey:RoomTypeID"`
}

// ReservationHistory represents reservation history events
type ReservationHistory struct {
	ID            int       `json:"id" gorm:"primaryKey;column:id"`
	ReservationID string    `json:"reservation_id" gorm:"column:reservation_id"`
	Action        string    `json:"action" gorm:"column:action"` // CREATED, CONFIRMED, CANCELLED, etc
	Status        string    `json:"status" gorm:"column:status"` // New status after action
	Note          string    `json:"note" gorm:"column:note"`
	PerformedBy   string    `json:"performed_by" gorm:"column:performed_by"` // MSP or user
	PerformedAt   time.Time `json:"performed_at" gorm:"column:performed_at"`
}

func (ReservationHistory) TableName() string {
	return "reservation_history"
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
	} else if fabric.Contract == nil {
		log.Println("⚠️ Fabric connected but chaincode not deployed (Development Mode)")
		log.Println("🔄 Using local blockchain simulation for data storage")
		useFabric = false
	} else {
		log.Println("✅ Real Hyperledger Fabric connected with deployed chaincode!")
		useFabric = true
	}

	// Initialize Gin router
	router := gin.Default()

	// Add CORS middleware - Allow all origins for development
	config := cors.DefaultConfig()
	config.AllowOrigins = []string{
		"http://localhost:3000", // React frontend (web-ui)
		"http://localhost:3001", // Next.js frontend (frontend-nextjs)
		"http://localhost:5173", // Vite dev server
		"http://localhost:4000", // Alternative port
		"http://127.0.0.1:3000",
		"http://127.0.0.1:3001",
		"http://127.0.0.1:5173",
		"http://[::1]:3000",
		"http://your-frontend-domain.com",  // Frontend production
		"https://your-frontend-domain.com", // HTTPS
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
		// Health check endpoint
		v1.GET("/health", api.getHealthCheck)

		// Auth routes
		v1.POST("/auth/register", api.register)
		v1.POST("/auth/login", api.login)
		v1.GET("/auth/me", api.authMiddleware(), api.getMe)
		v1.PUT("/auth/profile", api.authMiddleware(), api.updateProfile)

		// Hotel routes
		v1.GET("/hotels", api.getHotels)
		v1.GET("/hotels/:id", api.getHotel)
		v1.GET("/hotels/:id/rooms", api.getHotelRooms)
		v1.GET("/hotels/:id/room-types", api.getHotelRooms) // Alias for frontend compatibility

		// Price calculation endpoint - NEW!
		v1.POST("/calculate-price", api.calculatePrice)

		// Reservation routes
		v1.POST("/reservations", api.optionalAuthMiddleware(), api.createReservation)
		v1.GET("/reservations", api.getReservations)
		v1.GET("/reservations/:id", api.getReservation)
		v1.GET("/reservations/user/my-bookings", api.authMiddleware(), api.getUserReservations)
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

// Health check handler
func (api *API) getHealthCheck(c *gin.Context) {
	blockchainType := "Local Simulation"
	fabricEnabled := false

	if api.UseFabric && api.Fabric.IsConnected {
		blockchainType = "Hyperledger Fabric"
		fabricEnabled = true
	}

	response := gin.H{
		"status":         "running",
		"blockchain":     blockchainType,
		"fabric_enabled": fabricEnabled,
		"database":       "MySQL",
		"timestamp":      time.Now().Format(time.RFC3339),
	}

	c.JSON(http.StatusOK, response)
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

// calculatePrice - NEW! Endpoint untuk simulasi kalkulasi harga
func (api *API) calculatePrice(c *gin.Context) {
	var req struct {
		RoomTypeID int    `json:"room_type_id" binding:"required"`
		GuestCount int    `json:"guest_count" binding:"required"`
		CheckIn    string `json:"check_in"`
		CheckOut   string `json:"check_out"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request format"})
		return
	}

	// Get room type details
	var roomType RoomType
	if err := api.DB.Preload("Hotel").First(&roomType, req.RoomTypeID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Room type not found"})
		return
	}

	// Validate capacity
	if req.GuestCount < roomType.MinCapacity {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": fmt.Sprintf("Minimum capacity is %d guests", roomType.MinCapacity),
		})
		return
	}

	if req.GuestCount > roomType.MaxCapacity {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": fmt.Sprintf("Maximum capacity is %d guests", roomType.MaxCapacity),
		})
		return
	}

	// Calculate duration in days
	durationDays := 1 // Default 1 day
	if req.CheckIn != "" && req.CheckOut != "" {
		checkIn, errIn := time.Parse("2006-01-02", req.CheckIn)
		checkOut, errOut := time.Parse("2006-01-02", req.CheckOut)
		if errIn == nil && errOut == nil {
			duration := checkOut.Sub(checkIn)
			durationDays = int(duration.Hours() / 24)
			if durationDays < 1 {
				durationDays = 1
			}
		}
	}

	// Calculate prices
	basePrice := float64(req.GuestCount) * roomType.PricePerPerson
	totalPrice := basePrice * float64(durationDays)

	c.JSON(http.StatusOK, gin.H{
		"calculation": gin.H{
			"price_per_person": roomType.PricePerPerson,
			"guest_count":      req.GuestCount,
			"base_price":       basePrice,
			"duration_days":    durationDays,
			"total_price":      totalPrice,
			"currency":         "IDR",
		},
		"hotel_name": roomType.Hotel.Name,
		"hotel_city": roomType.Hotel.City,
		"room_type":  roomType.TypeName,
	})
}

// Reservation handlers with hybrid blockchain support
func (api *API) createReservation(c *gin.Context) {
	var req struct {
		ReservationID    string `json:"reservation_id"`
		HotelID          string `json:"hotel_id"`
		RoomTypeID       string `json:"room_type_id"`
		CheckIn          string `json:"check_in"`
		CheckOut         string `json:"check_out"`
		GuestCount       int    `json:"guest_count"`
		EventType        string `json:"event_type"`        // NEW: Birthday, Meeting, Wedding, dll
		EventDescription string `json:"event_description"` // NEW: Detail acara
		CustomerName     string `json:"customer_name"`     // NEW
		CustomerPhone    string `json:"customer_phone"`    // NEW
		CustomerEmail    string `json:"customer_email"`    // NEW
		CustomerRef      string `json:"customer_ref"`
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

	// Get user ID from JWT token (if authenticated)
	var userID *int
	if id, exists := c.Get("user_id"); exists {
		if uid, ok := id.(int); ok {
			userID = &uid
		}
	}

	// Get room type for price calculation
	var roomType RoomType
	if err := api.DB.First(&roomType, roomTypeID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Room type not found"})
		return
	}

	// Validate capacity
	if req.GuestCount < roomType.MinCapacity {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": fmt.Sprintf("Minimum capacity for this package is %d guests", roomType.MinCapacity),
		})
		return
	}

	if req.GuestCount > roomType.MaxCapacity {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": fmt.Sprintf("Maximum capacity for this package is %d guests", roomType.MaxCapacity),
		})
		return
	}

	// AUTO CALCULATE PRICE!
	pricePerPerson := roomType.PricePerPerson
	totalPrice := float64(req.GuestCount) * pricePerPerson

	// Default event type
	eventType := req.EventType
	if eventType == "" {
		eventType = "Meeting"
	}

	// Create reservation in database
	reservation := Reservation{
		ReservationID:    req.ReservationID,
		UserID:           userID,
		HotelID:          hotelID,
		RoomTypeID:       roomTypeID,
		CheckIn:          checkIn,
		CheckOut:         checkOut,
		GuestCount:       req.GuestCount,
		EventType:        eventType,
		EventDescription: req.EventDescription,
		CustomerName:     req.CustomerName,
		CustomerPhone:    req.CustomerPhone,
		CustomerEmail:    req.CustomerEmail,
		CustomerRef:      req.CustomerRef,
		PricePerPerson:   pricePerPerson,
		TotalPrice:       totalPrice,
		Currency:         "IDR",
		Status:           "PENDING",
		CreatedByOrg:     "GoBackendMSP",
	}

	if err := api.DB.Create(&reservation).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create reservation"})
		return
	}

	// Add to blockchain (hybrid approach)
	blockchainType := "Local Simulation"
	var blockchainErr error

	if api.UseFabric {
		// Use real Hyperledger Fabric with complete data
		blockchainErr = api.Fabric.CreateReservation(
			req.ReservationID, req.HotelID, req.RoomTypeID,
			req.CheckIn, req.CheckOut, req.GuestCount,
			eventType, req.EventDescription,
			req.CustomerName, req.CustomerPhone, req.CustomerEmail, req.CustomerRef,
			pricePerPerson, totalPrice, "IDR",
		)
		blockchainType = "Hyperledger Fabric"
	} else {
		// Use local blockchain simulation
		blockchainData := map[string]interface{}{
			"reservation_id":    req.ReservationID,
			"hotel_id":          req.HotelID,
			"room_type_id":      req.RoomTypeID,
			"check_in":          req.CheckIn,
			"check_out":         req.CheckOut,
			"guest_count":       req.GuestCount,
			"event_type":        eventType,
			"event_description": req.EventDescription,
			"customer_ref":      req.CustomerRef,
			"price_per_person":  pricePerPerson,
			"total_price":       totalPrice,
			"currency":          "IDR",
			"status":            "PENDING",
			"created_by":        "GoBackendMSP",
		}
		api.Blockchain.CreateReservationTx(blockchainData)
		blockchainType = "Local Simulation"
	}

	// Create history event
	api.createHistoryEvent(req.ReservationID, "CREATED",
		fmt.Sprintf("Reservation created via Go backend with %s", blockchainType))

	// Prepare response with calculation details
	response := gin.H{
		"message":        "Reservation created successfully on blockchain",
		"reservation_id": req.ReservationID,
		"blockchain":     blockchainType,
		"reservation": gin.H{
			"reservation_id":    req.ReservationID,
			"hotel_id":          req.HotelID,
			"room_type_id":      req.RoomTypeID,
			"check_in":          req.CheckIn,
			"check_out":         req.CheckOut,
			"guest_count":       req.GuestCount,
			"event_type":        eventType,
			"event_description": req.EventDescription,
			"customer_name":     req.CustomerName,
			"customer_phone":    req.CustomerPhone,
			"customer_email":    req.CustomerEmail,
			"price_per_person":  pricePerPerson,
			"total_price":       totalPrice,
			"currency":          "IDR",
			"status":            "PENDING",
		},
		"calculation": gin.H{
			"formula": fmt.Sprintf("%d guests × Rp %.0f = Rp %.0f", req.GuestCount, pricePerPerson, totalPrice),
			"breakdown": gin.H{
				"price_per_person": pricePerPerson,
				"guest_count":      req.GuestCount,
				"total":            totalPrice,
			},
		},
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
			"reservationID":    r.ReservationID,
			"hotelID":          fmt.Sprintf("%d", r.HotelID),
			"roomTypeID":       fmt.Sprintf("%d", r.RoomTypeID),
			"checkIn":          r.CheckIn.Format("2006-01-02"),
			"checkOut":         r.CheckOut.Format("2006-01-02"),
			"guestCount":       r.GuestCount,
			"eventType":        r.EventType,
			"eventDescription": r.EventDescription,
			"customerName":     r.CustomerName,
			"customerPhone":    r.CustomerPhone,
			"customerEmail":    r.CustomerEmail,
			"customerRef":      r.CustomerRef,
			"pricePerPerson":   r.PricePerPerson,
			"totalPrice":       r.TotalPrice,
			"currency":         r.Currency,
			"status":           r.Status,
			"createdByOrg":     r.CreatedByOrg,
			"lastUpdatedAt":    r.UpdatedAt,
			"hotelName":        r.Hotel.Name,
			"roomTypeName":     r.RoomType.TypeName,
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
		"reservation_id":    reservation.ReservationID,
		"hotel_id":          reservation.HotelID,
		"room_type_id":      reservation.RoomTypeID,
		"check_in":          reservation.CheckIn.Format("2006-01-02"),
		"check_out":         reservation.CheckOut.Format("2006-01-02"),
		"guest_count":       reservation.GuestCount,
		"event_type":        reservation.EventType,
		"event_description": reservation.EventDescription,
		"customer_name":     reservation.CustomerName,
		"customer_phone":    reservation.CustomerPhone,
		"customer_email":    reservation.CustomerEmail,
		"customer_ref":      reservation.CustomerRef,
		"price_per_person":  reservation.PricePerPerson,
		"total_price":       reservation.TotalPrice,
		"currency":          reservation.Currency,
		"status":            reservation.Status,
		"created_by_org":    reservation.CreatedByOrg,
		"created_at":        reservation.CreatedAt,
		"updated_at":        reservation.UpdatedAt,
		"hotel": map[string]interface{}{
			"id":      reservation.Hotel.ID,
			"name":    reservation.Hotel.Name,
			"city":    reservation.Hotel.City,
			"address": reservation.Hotel.Address,
		},
		"room_type": map[string]interface{}{
			"id":          reservation.RoomType.ID,
			"type_name":   reservation.RoomType.TypeName,
			"description": reservation.RoomType.Description,
		},
	}

	c.JSON(http.StatusOK, gin.H{"reservation": formattedReservation})
}

// Get user's reservations (authenticated)
func (api *API) getUserReservations(c *gin.Context) {
	userID := c.GetInt("user_id")

	var reservations []Reservation
	if err := api.DB.Preload("Hotel").Preload("RoomType").Where("user_id = ?", userID).Order("created_at DESC").Find(&reservations).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch reservations"})
		return
	}

	// Format reservations
	var formattedReservations []map[string]interface{}
	for _, reservation := range reservations {
		formattedReservations = append(formattedReservations, map[string]interface{}{
			"id":                reservation.ID,
			"reservation_id":    reservation.ReservationID,
			"hotel_id":          reservation.HotelID,
			"room_type_id":      reservation.RoomTypeID,
			"check_in":          reservation.CheckIn.Format("2006-01-02"),
			"check_out":         reservation.CheckOut.Format("2006-01-02"),
			"guest_count":       reservation.GuestCount,
			"event_type":        reservation.EventType,
			"event_description": reservation.EventDescription,
			"price_per_person":  reservation.PricePerPerson,
			"total_price":       reservation.TotalPrice,
			"currency":          reservation.Currency,
			"status":            reservation.Status,
			"created_at":        reservation.CreatedAt,
			"updated_at":        reservation.UpdatedAt,
			"hotel": map[string]interface{}{
				"id":      reservation.Hotel.ID,
				"name":    reservation.Hotel.Name,
				"city":    reservation.Hotel.City,
				"address": reservation.Hotel.Address,
				"rating":  reservation.Hotel.Rating,
			},
			"room_type": map[string]interface{}{
				"id":          reservation.RoomType.ID,
				"type_name":   reservation.RoomType.TypeName,
				"description": reservation.RoomType.Description,
			},
		})
	}

	c.JSON(http.StatusOK, gin.H{
		"reservations": formattedReservations,
		"total":        len(formattedReservations),
	})
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
			"reservationID":    r.ReservationID,
			"hotelID":          fmt.Sprintf("%d", r.HotelID),
			"roomTypeID":       fmt.Sprintf("%d", r.RoomTypeID),
			"checkIn":          r.CheckIn.Format("2006-01-02"),
			"checkOut":         r.CheckOut.Format("2006-01-02"),
			"guestCount":       r.GuestCount,
			"eventType":        r.EventType,
			"eventDescription": r.EventDescription,
			"customerName":     r.CustomerName,
			"customerPhone":    r.CustomerPhone,
			"customerEmail":    r.CustomerEmail,
			"customerRef":      r.CustomerRef,
			"pricePerPerson":   r.PricePerPerson,
			"totalPrice":       r.TotalPrice,
			"currency":         r.Currency,
			"status":           r.Status,
			"createdByOrg":     r.CreatedByOrg,
			"lastUpdatedAt":    r.UpdatedAt,
			"hotelName":        r.Hotel.Name,
			"roomTypeName":     r.RoomType.TypeName,
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
			"timestamp":  h.PerformedAt.Format("2006-01-02T15:04:05Z"),
			"event_type": h.Action,
			"actor_msp":  h.PerformedBy,
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
func (api *API) createHistoryEvent(reservationID, action, note string) {
	// Get current reservation status
	var reservation Reservation
	status := "PENDING" // default
	if err := api.DB.Where("reservation_id = ?", reservationID).First(&reservation).Error; err == nil {
		status = reservation.Status
	}

	history := ReservationHistory{
		ReservationID: reservationID,
		Action:        action,
		Status:        status,
		Note:          note,
		PerformedBy:   "GoBackendMSP",
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
	host := getEnv("DB_HOST", "127.0.0.1")
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

// JWT Secret key - In production, use environment variable
var jwtSecret = []byte(getEnv("JWT_SECRET", "your-super-secret-key-change-this-in-production"))

// JWT Claims
type Claims struct {
	UserID int    `json:"user_id"`
	Email  string `json:"email"`
	Role   string `json:"role"`
	jwt.RegisteredClaims
}

// Auth Middleware
func (api *API) authMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Authorization header required"})
			c.Abort()
			return
		}

		tokenString := authHeader
		if len(authHeader) > 7 && authHeader[:7] == "Bearer " {
			tokenString = authHeader[7:]
		}

		token, err := jwt.ParseWithClaims(tokenString, &Claims{}, func(token *jwt.Token) (interface{}, error) {
			return jwtSecret, nil
		})

		if err != nil || !token.Valid {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
			c.Abort()
			return
		}

		claims, ok := token.Claims.(*Claims)
		if !ok {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token claims"})
			c.Abort()
			return
		}

		c.Set("user_id", claims.UserID)
		c.Set("user_email", claims.Email)
		c.Set("user_role", claims.Role)
		c.Next()
	}
}

// Optional auth middleware - allows requests with or without token
func (api *API) optionalAuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader != "" {
			tokenString := authHeader
			if len(authHeader) > 7 && authHeader[:7] == "Bearer " {
				tokenString = authHeader[7:]
			}

			token, err := jwt.ParseWithClaims(tokenString, &Claims{}, func(token *jwt.Token) (interface{}, error) {
				return jwtSecret, nil
			})

			if err == nil && token.Valid {
				claims, ok := token.Claims.(*Claims)
				if ok {
					c.Set("user_id", claims.UserID)
					c.Set("user_email", claims.Email)
					c.Set("user_role", claims.Role)
				}
			}
		}
		c.Next()
	}
}

// Register handler
func (api *API) register(c *gin.Context) {
	var req struct {
		Email    string `json:"email" binding:"required,email"`
		Password string `json:"password" binding:"required,min=6"`
		FullName string `json:"full_name" binding:"required"`
		Phone    string `json:"phone"`
		Company  string `json:"company"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request format"})
		return
	}

	// Check if email already exists
	var existingUser User
	if err := api.DB.Where("email = ?", req.Email).First(&existingUser).Error; err == nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Email already registered"})
		return
	}

	// Hash password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password"})
		return
	}

	// Create user
	user := User{
		Email:    req.Email,
		Password: string(hashedPassword),
		FullName: req.FullName,
		Phone:    req.Phone,
		Company:  req.Company,
		Role:     "user",
		IsActive: true,
	}

	if err := api.DB.Create(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create user"})
		return
	}

	// Generate JWT token
	expirationTime := time.Now().Add(24 * time.Hour * 7) // 7 days
	claims := &Claims{
		UserID: user.ID,
		Email:  user.Email,
		Role:   user.Role,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(expirationTime),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(jwtSecret)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate token"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"message": "User registered successfully",
		"token":   tokenString,
		"user": gin.H{
			"id":        user.ID,
			"email":     user.Email,
			"full_name": user.FullName,
			"phone":     user.Phone,
			"company":   user.Company,
			"role":      user.Role,
		},
	})
}

// Login handler
func (api *API) login(c *gin.Context) {
	var req struct {
		Email    string `json:"email" binding:"required"`
		Password string `json:"password" binding:"required"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request format"})
		return
	}

	// Find user
	var user User
	if err := api.DB.Where("email = ?", req.Email).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid email or password"})
		return
	}

	// Check if user is active
	if !user.IsActive {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Account is inactive"})
		return
	}

	// Verify password
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.Password)); err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid email or password"})
		return
	}

	// Update last login
	api.DB.Model(&user).Update("last_login", time.Now())

	// Generate JWT token
	expirationTime := time.Now().Add(24 * time.Hour * 7) // 7 days
	claims := &Claims{
		UserID: user.ID,
		Email:  user.Email,
		Role:   user.Role,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(expirationTime),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(jwtSecret)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate token"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Login successful",
		"token":   tokenString,
		"user": gin.H{
			"id":        user.ID,
			"email":     user.Email,
			"full_name": user.FullName,
			"phone":     user.Phone,
			"company":   user.Company,
			"role":      user.Role,
		},
	})
}

// Get current user profile
func (api *API) getMe(c *gin.Context) {
	userID := c.GetInt("user_id")

	var user User
	if err := api.DB.First(&user, userID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"user": gin.H{
			"id":         user.ID,
			"email":      user.Email,
			"full_name":  user.FullName,
			"phone":      user.Phone,
			"company":    user.Company,
			"role":       user.Role,
			"created_at": user.CreatedAt,
		},
	})
}

// Update user profile
func (api *API) updateProfile(c *gin.Context) {
	userID := c.GetInt("user_id")

	var req struct {
		FullName string `json:"full_name"`
		Phone    string `json:"phone"`
		Company  string `json:"company"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request format"})
		return
	}

	var user User
	if err := api.DB.First(&user, userID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	// Update fields
	if req.FullName != "" {
		user.FullName = req.FullName
	}
	if req.Phone != "" {
		user.Phone = req.Phone
	}
	if req.Company != "" {
		user.Company = req.Company
	}

	if err := api.DB.Save(&user).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update profile"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Profile updated successfully",
		"user": gin.H{
			"id":        user.ID,
			"email":     user.Email,
			"full_name": user.FullName,
			"phone":     user.Phone,
			"company":   user.Company,
		},
	})
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
