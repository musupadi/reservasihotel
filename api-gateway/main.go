package main

import (
	"database/sql"
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
	ID        int       `json:"id" gorm:"primaryKey;column:id"`
	Email     string    `json:"email" gorm:"column:email;unique"`
	Password  string    `json:"-" gorm:"column:password"`
	FullName  string    `json:"full_name" gorm:"column:full_name"`
	Phone     string    `json:"phone" gorm:"column:phone"`
	Company   string    `json:"company" gorm:"column:company"`
	Role      string    `json:"role" gorm:"column:role;default:'customer'"`
	HotelID   *int      `json:"hotel_id" gorm:"column:hotel_id"`
	Status    string    `json:"status" gorm:"column:status;default:'active'"`
	CreatedAt time.Time `json:"created_at" gorm:"column:created_at"`
	UpdatedAt time.Time `json:"updated_at" gorm:"column:updated_at"`
}

type HotelAdmin struct {
	ID          int       `json:"id" gorm:"primaryKey;column:id"`
	HotelID     int       `json:"hotel_id" gorm:"column:hotel_id"`
	UserID      int       `json:"user_id" gorm:"column:user_id"`
	Role        string    `json:"role" gorm:"column:role;default:'staff'"`
	Permissions string    `json:"permissions" gorm:"column:permissions;type:json"`
	AssignedBy  *int      `json:"assigned_by" gorm:"column:assigned_by"`
	CreatedAt   time.Time `json:"created_at" gorm:"column:created_at"`
	UpdatedAt   time.Time `json:"updated_at" gorm:"column:updated_at"`
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
	OwnerID     *int      `json:"owner_id" gorm:"column:owner_id"`
	OwnerName   string    `json:"owner_name" gorm:"column:owner_name"`
	OwnerPhone  string    `json:"owner_phone" gorm:"column:owner_phone"`
	OwnerEmail  string    `json:"owner_email" gorm:"column:owner_email"`
	Status      string    `json:"status" gorm:"column:status;default:'active'"`
	CreatedAt   time.Time `json:"created_at" gorm:"column:created_at"`
	UpdatedAt   time.Time `json:"updated_at" gorm:"column:updated_at"`
}

// RoomType represents a room type - UPDATED untuk Meeting Package & Meeting Rooms
type RoomType struct {
	ID             int       `json:"id" gorm:"primaryKey;column:id"`
	HotelID        int       `json:"hotel_id" gorm:"column:hotel_id"`
	TypeName       string    `json:"type_name" gorm:"column:type_name"`
	RoomCategory   string    `json:"room_category" gorm:"column:room_category;default:'hotel_room'"` // hotel_room or meeting_room
	Description    string    `json:"description" gorm:"column:description"`
	PricePerPerson float64   `json:"price_per_person" gorm:"column:price_per_person"`             // For hotel rooms (per night)
	PricingType    string    `json:"pricing_type" gorm:"column:pricing_type;default:'per_night'"` // per_night, per_hour, half_day, full_day
	HourlyRate     *float64  `json:"hourly_rate" gorm:"column:hourly_rate"`                       // For meeting rooms
	HalfDayRate    *float64  `json:"half_day_rate" gorm:"column:half_day_rate"`                   // For meeting rooms (4 hours)
	FullDayRate    *float64  `json:"full_day_rate" gorm:"column:full_day_rate"`                   // For meeting rooms (8 hours)
	MinCapacity    int       `json:"min_capacity" gorm:"column:min_capacity"`
	MaxCapacity    int       `json:"max_capacity" gorm:"column:max_capacity"`
	Amenities      string    `json:"amenities" gorm:"column:amenities"`
	CreatedAt      time.Time `json:"created_at" gorm:"column:created_at"`
	UpdatedAt      time.Time `json:"updated_at" gorm:"column:updated_at"`
	Hotel          Hotel     `json:"hotel" gorm:"foreignKey:HotelID"`
}

// HotelRoom represents a physical hotel room
type HotelRoom struct {
	ID                  int       `json:"id" gorm:"primaryKey;column:id"`
	HotelID             int       `json:"hotel_id" gorm:"column:hotel_id"`
	RoomTypeID          int       `json:"room_type_id" gorm:"column:room_type_id"`
	RoomNumber          string    `json:"room_number" gorm:"column:room_number"`
	Floor               int       `json:"floor" gorm:"column:floor"`
	IsBlockchainEnabled bool      `json:"is_blockchain_enabled" gorm:"column:is_blockchain_enabled"`
	Status              string    `json:"status" gorm:"column:status"`
	CreatedAt           time.Time `json:"created_at" gorm:"column:created_at"`
	UpdatedAt           time.Time `json:"updated_at" gorm:"column:updated_at"`
}

func (HotelRoom) TableName() string {
	return "hotel_rooms"
}

// RoomReservation represents room reservation mapping
type RoomReservation struct {
	ID                   int             `json:"id" gorm:"primaryKey;column:id"`
	ReservationID        string          `json:"reservation_id" gorm:"column:reservation_id"`
	HotelRoomID          int             `json:"hotel_room_id" gorm:"column:hotel_room_id"`
	CheckIn              time.Time       `json:"check_in" gorm:"column:check_in"`
	CheckOut             time.Time       `json:"check_out" gorm:"column:check_out"`
	GuestNames           string          `json:"guest_names" gorm:"column:guest_names"`
	Status               string          `json:"status" gorm:"column:status"`
	StartTime            sql.NullString  `json:"start_time" gorm:"column:start_time"`
	EndTime              sql.NullString  `json:"end_time" gorm:"column:end_time"`
	BookingDurationHours sql.NullFloat64 `json:"booking_duration_hours" gorm:"column:booking_duration_hours"`
	CreatedAt            time.Time       `json:"created_at" gorm:"column:created_at"`
	UpdatedAt            time.Time       `json:"updated_at" gorm:"column:updated_at"`
	HotelRoom            HotelRoom       `json:"hotel_room" gorm:"foreignKey:HotelRoomID"`
}

func (RoomReservation) TableName() string {
	return "room_reservations"
}

// Reservation represents a reservation - UPDATED untuk Event Booking
type Reservation struct {
	ID               int               `json:"id" gorm:"primaryKey;column:id"`
	UserID           *int              `json:"user_id" gorm:"column:user_id;default:null"`
	ReservationID    string            `json:"reservation_id" gorm:"column:reservation_id"`
	HotelID          int               `json:"hotel_id" gorm:"column:hotel_id"`
	RoomTypeID       int               `json:"room_type_id" gorm:"column:room_type_id"`
	CheckIn          time.Time         `json:"check_in" gorm:"column:check_in"`
	CheckOut         time.Time         `json:"check_out" gorm:"column:check_out"`
	GuestCount       int               `json:"guest_count" gorm:"column:guest_count"`
	TotalRoomsNeeded int               `json:"total_rooms_needed" gorm:"column:total_rooms_needed;default:1"`
	EventType        string            `json:"event_type" gorm:"column:event_type"`
	EventDescription string            `json:"event_description" gorm:"column:event_description"`
	CustomerName     string            `json:"customer_name" gorm:"column:customer_name"`
	CustomerPhone    string            `json:"customer_phone" gorm:"column:customer_phone"`
	CustomerEmail    string            `json:"customer_email" gorm:"column:customer_email"`
	CustomerRef      string            `json:"customer_ref" gorm:"column:customer_ref"`
	PricePerPerson   float64           `json:"price_per_person" gorm:"column:price_per_person"`
	TotalPrice       float64           `json:"total_price" gorm:"column:total_price"`
	Currency         string            `json:"currency" gorm:"column:currency"`
	Status           string            `json:"status" gorm:"column:status"`
	PaymentStatus    string            `json:"payment_status" gorm:"column:payment_status;default:'unpaid'"`
	PaymentMethod    string            `json:"payment_method" gorm:"column:payment_method"`
	PaymentDate      *time.Time        `json:"payment_date" gorm:"column:payment_date"`
	CreatedByOrg     string            `json:"created_by_org" gorm:"column:created_by_org"`
	CreatedAt        time.Time         `json:"created_at" gorm:"column:created_at"`
	UpdatedAt        time.Time         `json:"updated_at" gorm:"column:updated_at"`
	Hotel            Hotel             `json:"hotel" gorm:"foreignKey:HotelID"`
	RoomType         RoomType          `json:"room_type" gorm:"foreignKey:RoomTypeID"`
	RoomReservations []RoomReservation `json:"room_reservations" gorm:"foreignKey:ReservationID;references:ReservationID"`
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
		v1.POST("/auth/register-hotel", api.registerHotel)
		v1.POST("/auth/login", api.login)
		v1.GET("/auth/me", api.authMiddleware(), api.getMe)
		v1.PUT("/auth/profile", api.authMiddleware(), api.updateProfile)

		// Hotel routes
		v1.GET("/hotels", api.getHotels)
		v1.GET("/hotels/:id", api.getHotel)
		v1.PUT("/hotels/:id", api.authMiddleware(), api.updateHotel)
		v1.GET("/hotels/:id/rooms", api.getIndividualRooms)
		v1.GET("/hotels/:id/room-types", api.getHotelRooms)
		v1.POST("/hotels/:id/room-types", api.authMiddleware(), api.createRoomType)
		v1.PUT("/hotels/:id/room-types/:type_id", api.authMiddleware(), api.updateRoomType)
		v1.DELETE("/hotels/:id/room-types/:type_id", api.authMiddleware(), api.deleteRoomType)
		v1.POST("/hotels/:id/rooms", api.authMiddleware(), api.createRoom)
		v1.PUT("/hotels/:id/rooms/:room_id", api.authMiddleware(), api.updateRoom)
		v1.DELETE("/hotels/:id/rooms/:room_id", api.authMiddleware(), api.deleteRoom)

		// Hotel Admin/Staff Management routes - NEW!
		v1.GET("/hotels/:id/admins", api.authMiddleware(), api.getHotelAdmins)
		v1.POST("/hotels/:id/admins", api.authMiddleware(), api.createHotelAdmin)
		v1.PUT("/hotels/:id/admins/:admin_id", api.authMiddleware(), api.updateHotelAdmin)
		v1.DELETE("/hotels/:id/admins/:admin_id", api.authMiddleware(), api.deleteHotelAdmin)

		// Hotel Statistics - NEW!
		v1.GET("/hotels/:id/statistics", api.authMiddleware(), api.getHotelStatistics)

		// Room selection routes - NEW!
		v1.GET("/hotels/:id/room-types/:room_type_id/available-rooms", api.getAvailableRooms)
		v1.GET("/hotels/:id/rooms-with-status", api.getRoomsWithStatus) // NEW: Cinema-style room map

		// Price calculation endpoint - NEW!
		v1.POST("/calculate-price", api.calculatePrice)

		// Reservation routes
		v1.POST("/reservations", api.optionalAuthMiddleware(), api.createReservation)
		v1.GET("/reservations", api.getReservations)
		v1.GET("/reservations/:id", api.getReservation)
		v1.GET("/reservations/user/my-bookings", api.authMiddleware(), api.getUserReservations)
		v1.POST("/reservations/:id/confirm", api.confirmReservation)
		v1.POST("/reservations/:id/cancel", api.cancelReservation)
		v1.POST("/reservations/:id/payment", api.optionalAuthMiddleware(), api.processPayment)
		v1.POST("/reservations/:id/admin-cancel", api.authMiddleware(), api.adminCancelPending)
		v1.POST("/reservations/:id/checkin", api.checkinReservation)
		v1.POST("/reservations/:id/checkout", api.checkoutReservation)
		v1.GET("/reservations/hotel/:hotelId", api.getHotelReservations)

		// Room Layout routes
		v1.GET("/hotels/:id/layout/:floor", api.getRoomLayoutByFloor)
		v1.PUT("/hotels/:id/layout", api.authMiddleware(), api.updateRoomLayout)
		v1.POST("/hotels/:id/layout/auto-arrange", api.authMiddleware(), api.autoArrangeLayout)
		v1.DELETE("/hotels/:id/layout/reset", api.authMiddleware(), api.resetRoomLayout)

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

// updateHotel - Update hotel information
func (api *API) updateHotel(c *gin.Context) {
	hotelID := c.Param("id")

	// Check if user has permission
	userID, _ := c.Get("user_id")
	var user User
	if err := api.DB.Where("id = ?", userID).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found"})
		return
	}

	// Verify user belongs to this hotel
	hotelIDInt := stringToInt(hotelID)
	log.Printf("DEBUG updateHotel: User ID=%d, User HotelID=%v, Requested HotelID=%d", user.ID, user.HotelID, hotelIDInt)

	if user.HotelID == nil {
		log.Printf("ERROR: User %d has no hotel_id", user.ID)
		c.JSON(http.StatusForbidden, gin.H{"error": "Access denied - no hotel assigned"})
		return
	}

	if *user.HotelID != hotelIDInt {
		log.Printf("ERROR: User hotel_id %d does not match requested hotel %d", *user.HotelID, hotelIDInt)
		c.JSON(http.StatusForbidden, gin.H{"error": "Access denied - hotel mismatch"})
		return
	}

	var req struct {
		Name        string  `json:"name"`
		City        string  `json:"city"`
		Address     string  `json:"address"`
		Description string  `json:"description"`
		Rating      float64 `json:"rating"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request", "details": err.Error()})
		return
	}

	// Update hotel
	var hotel Hotel
	if err := api.DB.First(&hotel, hotelID).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Hotel not found"})
		return
	}

	hotel.Name = req.Name
	hotel.City = req.City
	hotel.Address = req.Address
	hotel.Description = req.Description
	hotel.Rating = req.Rating

	if err := api.DB.Save(&hotel).Error; err != nil {
		log.Printf("ERROR updating hotel: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update hotel"})
		return
	}

	log.Printf("✅ Hotel %d updated by user %d", hotel.ID, user.ID)
	c.JSON(http.StatusOK, gin.H{"message": "Hotel updated successfully", "hotel": hotel})
}

func (api *API) getHotelRooms(c *gin.Context) {
	id := c.Param("id")
	var roomTypes []RoomType
	if err := api.DB.Where("hotel_id = ?", id).Find(&roomTypes).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch room types"})
		return
	}

	// Add calculated counts to response
	type RoomTypeWithCounts struct {
		RoomType
		TotalRooms              int64 `json:"total_rooms"`
		BlockchainReservedRooms int64 `json:"blockchain_reserved_rooms"`
		AvailableRooms          int64 `json:"available_rooms"`
	}

	var response []RoomTypeWithCounts
	for _, rt := range roomTypes {
		total, blockchain, _ := api.getRoomTypeCounts(rt.ID)
		response = append(response, RoomTypeWithCounts{
			RoomType:                rt,
			TotalRooms:              total,
			BlockchainReservedRooms: blockchain,
			AvailableRooms:          total, // TODO: Calculate based on reservations
		})
	}

	c.JSON(http.StatusOK, gin.H{"room_types": response})
}

// getIndividualRooms - Get individual hotel rooms (from hotel_rooms table)
func (api *API) getIndividualRooms(c *gin.Context) {
	id := c.Param("id")
	var rooms []HotelRoom
	if err := api.DB.Where("hotel_id = ?", id).Order("room_number").Find(&rooms).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch rooms"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"rooms": rooms})
}

// getAvailableRooms - NEW! Get available rooms for booking (blockchain enabled only)
func (api *API) getAvailableRooms(c *gin.Context) {
	hotelID := c.Param("id")
	roomTypeID := c.Param("room_type_id")
	checkIn := c.Query("check_in")
	checkOut := c.Query("check_out")

	// Parse dates
	checkInDate, err1 := time.Parse("2006-01-02", checkIn)
	checkOutDate, err2 := time.Parse("2006-01-02", checkOut)
	if err1 != nil || err2 != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid date format. Use YYYY-MM-DD"})
		return
	}

	// Get all blockchain-enabled rooms for this room type
	var allRooms []HotelRoom
	if err := api.DB.Where("hotel_id = ? AND room_type_id = ? AND is_blockchain_enabled = ? AND status = ?",
		hotelID, roomTypeID, true, "AVAILABLE").
		Order("room_number").
		Find(&allRooms).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch rooms"})
		return
	}

	// Get booked room IDs for the date range
	var bookedRoomIDs []int
	api.DB.Table("room_reservations").
		Select("DISTINCT hotel_room_id").
		Where("check_in < ? AND check_out > ? AND status NOT IN (?)",
			checkOutDate, checkInDate, []string{"CANCELLED", "CHECKED_OUT"}).
		Pluck("hotel_room_id", &bookedRoomIDs)

	// Filter available rooms
	availableRooms := []HotelRoom{}
	for _, room := range allRooms {
		isBooked := false
		for _, bookedID := range bookedRoomIDs {
			if room.ID == bookedID {
				isBooked = true
				break
			}
		}
		if !isBooked {
			availableRooms = append(availableRooms, room)
		}
	}

	c.JSON(http.StatusOK, gin.H{
		"available_rooms": availableRooms,
		"total":           len(availableRooms),
		"check_in":        checkIn,
		"check_out":       checkOut,
	})
}

// getRoomsWithStatus - Cinema-style room availability map
func (api *API) getRoomsWithStatus(c *gin.Context) {
	hotelID := c.Param("id")
	checkIn := c.Query("check_in")
	checkOut := c.Query("check_out")
	roomTypeIDStr := c.Query("room_type_id")

	// Parse dates if provided
	var checkInDate, checkOutDate time.Time
	var err error
	if checkIn != "" && checkOut != "" {
		checkInDate, err = time.Parse("2006-01-02", checkIn)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid check_in date format. Use YYYY-MM-DD"})
			return
		}
		checkOutDate, err = time.Parse("2006-01-02", checkOut)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid check_out date format. Use YYYY-MM-DD"})
			return
		}
	}

	// Build query for rooms
	query := api.DB.Table("hotel_rooms").
		Select("hotel_rooms.*, room_types.type_name, room_types.price_per_person, room_types.max_capacity, room_types.room_category, room_types.pricing_type, room_types.hourly_rate, room_types.half_day_rate, room_types.full_day_rate").
		Joins("LEFT JOIN room_types ON hotel_rooms.room_type_id = room_types.id").
		Where("hotel_rooms.hotel_id = ?", hotelID)

	if roomTypeIDStr != "" {
		query = query.Where("hotel_rooms.room_type_id = ?", roomTypeIDStr)
	}

	var rooms []struct {
		ID                  int      `json:"id"`
		HotelID             int      `json:"hotel_id"`
		RoomTypeID          int      `json:"room_type_id"`
		RoomNumber          string   `json:"room_number"`
		Floor               int      `json:"floor"`
		IsBlockchainEnabled bool     `json:"is_blockchain_enabled"`
		Status              string   `json:"status"`
		TypeName            string   `json:"type_name"`
		PricePerPerson      float64  `json:"price_per_person"`
		MaxCapacity         int      `json:"max_capacity"`
		RoomCategory        string   `json:"room_category"`
		PricingType         string   `json:"pricing_type"`
		HourlyRate          *float64 `json:"hourly_rate"`
		HalfDayRate         *float64 `json:"half_day_rate"`
		FullDayRate         *float64 `json:"full_day_rate"`
		LayoutX             *int     `json:"layout_x"`
		LayoutY             *int     `json:"layout_y"`
		LayoutWidth         *int     `json:"layout_width"`
		LayoutHeight        *int     `json:"layout_height"`
	}

	if err := query.Order("room_types.id, hotel_rooms.room_number").Find(&rooms).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch rooms"})
		return
	}

	// Get booked room IDs if dates provided
	bookedRoomIDs := make(map[int]bool)
	if checkIn != "" && checkOut != "" {
		var bookedIDs []int
		api.DB.Table("room_reservations").
			Select("DISTINCT hotel_room_id").
			Where("check_in < ? AND check_out > ? AND status NOT IN (?)",
				checkOutDate, checkInDate, []string{"CANCELLED", "CHECKED_OUT"}).
			Pluck("hotel_room_id", &bookedIDs)

		for _, id := range bookedIDs {
			bookedRoomIDs[id] = true
		}
	}

	// Build response with availability status
	type RoomWithStatus struct {
		ID                  int      `json:"id"`
		HotelID             int      `json:"hotel_id"`
		RoomTypeID          int      `json:"room_type_id"`
		RoomNumber          string   `json:"room_number"`
		Floor               int      `json:"floor"`
		IsBlockchainEnabled bool     `json:"is_blockchain_enabled"`
		Status              string   `json:"status"`
		TypeName            string   `json:"type_name"`
		PricePerPerson      float64  `json:"price_per_person"`
		MaxCapacity         int      `json:"max_capacity"`
		RoomCategory        string   `json:"room_category"`
		PricingType         string   `json:"pricing_type"`
		HourlyRate          *float64 `json:"hourly_rate"`
		HalfDayRate         *float64 `json:"half_day_rate"`
		FullDayRate         *float64 `json:"full_day_rate"`
		LayoutX             *int     `json:"layout_x"`
		LayoutY             *int     `json:"layout_y"`
		LayoutWidth         *int     `json:"layout_width"`
		LayoutHeight        *int     `json:"layout_height"`
		IsAvailable         bool     `json:"is_available"`
		IsBooked            bool     `json:"is_booked"`
	}

	var roomsWithStatus []RoomWithStatus
	for _, room := range rooms {
		isBooked := bookedRoomIDs[room.ID]
		isAvailable := room.Status == "AVAILABLE" && room.IsBlockchainEnabled && !isBooked

		roomsWithStatus = append(roomsWithStatus, RoomWithStatus{
			ID:                  room.ID,
			HotelID:             room.HotelID,
			RoomTypeID:          room.RoomTypeID,
			RoomNumber:          room.RoomNumber,
			Floor:               room.Floor,
			IsBlockchainEnabled: room.IsBlockchainEnabled,
			Status:              room.Status,
			TypeName:            room.TypeName,
			PricePerPerson:      room.PricePerPerson,
			MaxCapacity:         room.MaxCapacity,
			RoomCategory:        room.RoomCategory,
			PricingType:         room.PricingType,
			HourlyRate:          room.HourlyRate,
			HalfDayRate:         room.HalfDayRate,
			FullDayRate:         room.FullDayRate,
			LayoutX:             room.LayoutX,
			LayoutY:             room.LayoutY,
			LayoutWidth:         room.LayoutWidth,
			LayoutHeight:        room.LayoutHeight,
			IsAvailable:         isAvailable,
			IsBooked:            isBooked,
		})
	}

	c.JSON(http.StatusOK, gin.H{
		"rooms":     roomsWithStatus,
		"total":     len(roomsWithStatus),
		"check_in":  checkIn,
		"check_out": checkOut,
		"has_dates": checkIn != "" && checkOut != "",
	})
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
		ReservationID        string  `json:"reservation_id"`
		HotelID              string  `json:"hotel_id"`
		RoomTypeID           string  `json:"room_type_id"`
		CheckIn              string  `json:"check_in"`
		CheckOut             string  `json:"check_out"`
		GuestCount           int     `json:"guest_count"`
		EventType            string  `json:"event_type"`
		EventDescription     string  `json:"event_description"`
		CustomerName         string  `json:"customer_name"`
		CustomerPhone        string  `json:"customer_phone"`
		CustomerEmail        string  `json:"customer_email"`
		CustomerRef          string  `json:"customer_ref"`
		SelectedRoomIDs      []int   `json:"selected_room_ids"`      // NEW: Array of hotel_room IDs
		StartTime            string  `json:"start_time"`             // NEW: For meeting rooms
		EndTime              string  `json:"end_time"`               // NEW: For meeting rooms
		BookingDurationHours float64 `json:"booking_duration_hours"` // NEW: For meeting rooms
		PricingType          string  `json:"pricing_type"`           // NEW: For meeting rooms (hourly/half_day/full_day)
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

	// Validate dates
	if checkOut.Before(checkIn) || checkOut.Equal(checkIn) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Check-out date must be after check-in date"})
		return
	}

	// Check if check-in is in the past
	today := time.Now().Truncate(24 * time.Hour)
	if checkIn.Before(today) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Check-in date cannot be in the past"})
		return
	}

	// Convert string IDs to int
	hotelID, _ := strconv.Atoi(req.HotelID)
	roomTypeID, _ := strconv.Atoi(req.RoomTypeID)

	// Validate selected rooms
	if len(req.SelectedRoomIDs) == 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Please select at least one room"})
		return
	}

	// Verify all selected rooms are available and blockchain-enabled
	// Allow mixed booking: remove room_type_id constraint for flexibility
	var selectedRooms []HotelRoom
	if err := api.DB.Where("id IN (?) AND hotel_id = ? AND is_blockchain_enabled = ? AND status = ?",
		req.SelectedRoomIDs, hotelID, true, "AVAILABLE").
		Find(&selectedRooms).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to verify selected rooms"})
		return
	}

	if len(selectedRooms) != len(req.SelectedRoomIDs) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Some selected rooms are not available or invalid"})
		return
	}

	// Check if rooms are already booked for this date range
	var existingBookings int64
	api.DB.Table("room_reservations").
		Where("hotel_room_id IN (?) AND check_in < ? AND check_out > ? AND status NOT IN (?)",
			req.SelectedRoomIDs, checkOut, checkIn, []string{"CANCELLED", "CHECKED_OUT"}).
		Count(&existingBookings)

	if existingBookings > 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "One or more selected rooms are already booked for this date range"})
		return
	}

	// Get user ID from JWT token (if authenticated) - DISABLED: user_id column doesn't exist
	// var userID *int
	// if id, exists := c.Get("user_id"); exists {
	// 	if uid, ok := id.(int); ok {
	// 		userID = &uid
	// 	}
	// }

	// Calculate price based on room types (support mixed booking)
	var totalPrice float64
	var pricePerPerson float64 // Store reference price (for backward compatibility)

	// Get room types for all selected rooms
	roomTypeMap := make(map[int]*RoomType)
	for _, room := range selectedRooms {
		if _, exists := roomTypeMap[room.RoomTypeID]; !exists {
			var rt RoomType
			if err := api.DB.First(&rt, room.RoomTypeID).Error; err != nil {
				c.JSON(http.StatusNotFound, gin.H{"error": fmt.Sprintf("Room type %d not found", room.RoomTypeID)})
				return
			}
			roomTypeMap[room.RoomTypeID] = &rt
		}
	}

	// Calculate total price for each room
	for _, room := range selectedRooms {
		roomType := roomTypeMap[room.RoomTypeID]

		if roomType.RoomCategory == "meeting_room" {
			// Meeting room pricing
			var rate float64
			switch req.PricingType {
			case "hourly", "per_hour":
				if roomType.HourlyRate != nil {
					rate = *roomType.HourlyRate
				}
			case "half_day":
				if roomType.HalfDayRate != nil {
					rate = *roomType.HalfDayRate
				}
			case "full_day":
				if roomType.FullDayRate != nil {
					rate = *roomType.FullDayRate
				}
			default:
				// Default to hourly if not specified
				if roomType.HourlyRate != nil {
					rate = *roomType.HourlyRate
				}
			}
			totalPrice += rate
			pricePerPerson = rate // Store rate for reference
		} else {
			// Hotel room pricing (per person per night)
			pricePerPerson = roomType.PricePerPerson
			totalPrice += float64(req.GuestCount) * pricePerPerson
		}
	}

	// Default event type
	eventType := req.EventType
	if eventType == "" {
		eventType = "Meeting"
	}

	// Create reservation in database with transaction
	tx := api.DB.Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	reservation := Reservation{
		ReservationID: req.ReservationID,
		// UserID:           userID, // Skip - column doesn't exist in table
		HotelID:          hotelID,
		RoomTypeID:       roomTypeID,
		CheckIn:          checkIn,
		CheckOut:         checkOut,
		GuestCount:       req.GuestCount,
		TotalRoomsNeeded: len(req.SelectedRoomIDs),
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

	if err := tx.Create(&reservation).Error; err != nil {
		tx.Rollback()
		log.Printf("ERROR creating reservation: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create reservation", "details": err.Error()})
		return
	}

	// Create room reservations for each selected room
	for _, roomID := range req.SelectedRoomIDs {
		roomReservation := RoomReservation{
			ReservationID:        req.ReservationID,
			HotelRoomID:          roomID,
			CheckIn:              checkIn,
			CheckOut:             checkOut,
			GuestNames:           "", // Optional field
			Status:               "BOOKED",
			StartTime:            sql.NullString{String: req.StartTime, Valid: req.StartTime != ""},
			EndTime:              sql.NullString{String: req.EndTime, Valid: req.EndTime != ""},
			BookingDurationHours: sql.NullFloat64{Float64: req.BookingDurationHours, Valid: req.BookingDurationHours > 0},
		}
		if err := tx.Create(&roomReservation).Error; err != nil {
			tx.Rollback()
			log.Printf("ERROR creating room reservation for room %d: %v", roomID, err)
			c.JSON(http.StatusInternalServerError, gin.H{"error": fmt.Sprintf("Failed to create room reservation for room %d", roomID), "details": err.Error()})
			return
		}
	}

	// Commit transaction
	if err := tx.Commit().Error; err != nil {
		log.Printf("ERROR committing transaction: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to commit reservation", "details": err.Error()})
		return
	}

	log.Printf("✅ Reservation %s created successfully with %d rooms", req.ReservationID, len(req.SelectedRoomIDs))

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
	// Get user from context
	userVal, exists := c.Get("user")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found in context"})
		return
	}

	user, ok := userVal.(User)
	if !ok {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Invalid user data"})
		return
	}

	var reservations []Reservation
	// Query by customer_email (untuk data lama yang tidak punya user_id)
	if err := api.DB.Preload("Hotel").Preload("RoomType").
		Where("customer_email = ?", user.Email).
		Order("created_at DESC").
		Find(&reservations).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch reservations", "details": err.Error()})
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
			"payment_status":    reservation.PaymentStatus, // TAMBAH payment_status
			"payment_method":    reservation.PaymentMethod, // TAMBAH payment_method
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

// processPayment handles payment for a reservation
func (api *API) processPayment(c *gin.Context) {
	id := c.Param("id")

	var req struct {
		PaymentMethod string `json:"payment_method" binding:"required"`
		PaymentProof  string `json:"payment_proof"` // Optional: untuk upload bukti transfer
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Payment method is required"})
		return
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

	// Check if already paid
	if reservation.PaymentStatus == "paid" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Reservation already paid"})
		return
	}

	// Check if reservation is cancelled
	if reservation.Status == "CANCELLED" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Cannot pay for cancelled reservation"})
		return
	}

	// Update payment status AND confirm reservation
	now := time.Now()
	updates := map[string]interface{}{
		"payment_status": "paid",
		"payment_method": req.PaymentMethod,
		"payment_date":   now,
		"status":         "CONFIRMED", // Otomatis confirm setelah bayar
	}

	if err := api.DB.Model(&reservation).Updates(updates).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update payment status"})
		return
	}

	// Create history event for payment
	api.createHistoryEvent(id, "PAID", fmt.Sprintf("Payment received via %s", req.PaymentMethod))

	// Create history event for auto-confirmation
	api.createHistoryEvent(id, "CONFIRMED", "Reservation auto-confirmed after payment")

	// Update blockchain
	blockchainType := "Local Simulation"
	var blockchainErr error

	if api.UseFabric {
		// Update on Hyperledger Fabric
		blockchainErr = api.Fabric.ConfirmReservation(id, fmt.Sprintf("Auto-confirmed after payment via %s", req.PaymentMethod))
		blockchainType = "Hyperledger Fabric"
	} else {
		// Update local blockchain
		api.Blockchain.UpdateReservationStatusTx(id, "CONFIRMED", "Auto-confirmed after payment")
	}

	response := gin.H{
		"message":        "Payment processed successfully. Reservation is now CONFIRMED!",
		"reservation_id": id,
		"payment_status": "paid",
		"payment_method": req.PaymentMethod,
		"payment_date":   now,
		"status":         "CONFIRMED",
		"blockchain":     blockchainType,
	}

	if blockchainErr != nil {
		response["blockchain_warning"] = fmt.Sprintf("Payment processed but blockchain update failed: %v", blockchainErr)
	}

	c.JSON(http.StatusOK, response)
}

// adminCancelPending allows hotel admin to cancel pending unpaid reservations
func (api *API) adminCancelPending(c *gin.Context) {
	id := c.Param("id")

	// Get user from context (set by authMiddleware)
	userVal, exists := c.Get("user")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}
	user := userVal.(User)

	// Check if user is hotel admin
	if user.Role != "hotel_admin" && user.Role != "hotel_super_admin" {
		c.JSON(http.StatusForbidden, gin.H{"error": "Only hotel admins can cancel reservations"})
		return
	}

	// Get reservation
	var reservation Reservation
	if err := api.DB.Where("reservation_id = ?", id).First(&reservation).Error; err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{"error": "Reservation not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch reservation"})
		return
	}

	// Check if admin's hotel matches reservation's hotel
	if user.HotelID == nil || *user.HotelID != reservation.HotelID {
		c.JSON(http.StatusForbidden, gin.H{"error": "You can only cancel reservations for your own hotel"})
		return
	}

	// Check if reservation is pending
	if reservation.Status != "PENDING" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Can only cancel PENDING reservations"})
		return
	}

	// Check if unpaid
	if reservation.PaymentStatus == "paid" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Cannot cancel paid reservation. Please process refund first."})
		return
	}

	var req struct {
		Reason string `json:"reason"`
	}
	c.ShouldBindJSON(&req)

	reason := req.Reason
	if reason == "" {
		reason = "Cancelled by hotel admin - unpaid reservation"
	}

	// Update status to cancelled
	if err := api.DB.Model(&reservation).Update("status", "CANCELLED").Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to cancel reservation"})
		return
	}

	// Create history event
	api.createHistoryEvent(id, "CANCELLED", fmt.Sprintf("Cancelled by admin: %s", reason))

	// Update blockchain
	blockchainType := "Local Simulation"
	var blockchainErr error
	if api.UseFabric {
		blockchainErr = api.Fabric.CancelReservation(id, reason)
		blockchainType = "Hyperledger Fabric"
	} else {
		api.Blockchain.UpdateReservationStatusTx(id, "CANCELLED", reason)
	}

	response := gin.H{
		"message":        "Reservation cancelled successfully by admin",
		"reservation_id": id,
		"status":         "CANCELLED",
		"reason":         reason,
		"blockchain":     blockchainType,
	}

	if blockchainErr != nil {
		response["blockchain_warning"] = fmt.Sprintf("Database updated but blockchain failed: %v", blockchainErr)
	}

	c.JSON(http.StatusOK, response)
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
			"payment_status":   r.PaymentStatus, // TAMBAH ini
			"payment_method":   r.PaymentMethod, // TAMBAH ini
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

		// Fetch full user object from database
		var user User
		if err := api.DB.Where("id = ?", claims.UserID).First(&user).Error; err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found"})
			c.Abort()
			return
		}

		// Set user data to context
		c.Set("user_id", claims.UserID)
		c.Set("user_email", claims.Email)
		c.Set("user_role", claims.Role)
		c.Set("user", user) // Set full user object

		// Set hotel_id from user if available
		if user.HotelID != nil {
			c.Set("hotel_id", *user.HotelID)
		} else {
			c.Set("hotel_id", 0)
		}

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
		Role:     "customer",
		Status:   "active",
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

// Register Hotel - Creates hotel and super admin user
func (api *API) registerHotel(c *gin.Context) {
	var req struct {
		// User details
		Email           string `json:"email" binding:"required,email"`
		Password        string `json:"password" binding:"required,min=6"`
		ConfirmPassword string `json:"confirmPassword"`
		FullName        string `json:"full_name" binding:"required"`
		Phone           string `json:"phone" binding:"required"`

		// Hotel details
		HotelName        string `json:"hotel_name" binding:"required"`
		HotelCity        string `json:"hotel_city" binding:"required"`
		HotelAddress     string `json:"hotel_address" binding:"required"`
		HotelDescription string `json:"hotel_description"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request format", "details": err.Error()})
		return
	}

	// Validate password confirmation
	if req.ConfirmPassword != "" && req.Password != req.ConfirmPassword {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Password and confirm password do not match"})
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

	// Start transaction
	tx := api.DB.Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	// Create hotel first
	hotel := Hotel{
		Name:        req.HotelName,
		City:        req.HotelCity,
		Country:     "Indonesia",
		Address:     req.HotelAddress,
		Description: req.HotelDescription,
		Rating:      4.5, // Default rating
		Status:      "active",
	}

	if err := tx.Create(&hotel).Error; err != nil {
		tx.Rollback()
		log.Printf("ERROR creating hotel: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create hotel"})
		return
	}

	// Create user as hotel super admin
	user := User{
		Email:    req.Email,
		Password: string(hashedPassword),
		FullName: req.FullName,
		Phone:    req.Phone,
		Role:     "hotel_super_admin",
		HotelID:  &hotel.ID,
		Status:   "active",
	}

	if err := tx.Create(&user).Error; err != nil {
		tx.Rollback()
		log.Printf("ERROR creating user: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create user"})
		return
	}

	// Create hotel admin mapping
	hotelAdmin := HotelAdmin{
		HotelID: hotel.ID,
		UserID:  user.ID,
		Role:    "super_admin",
		Permissions: `{
			"manage_admins": true,
			"manage_rooms": true,
			"manage_packages": true,
			"view_bookings": true,
			"manage_bookings": true,
			"view_reports": true
		}`,
	}

	if err := tx.Create(&hotelAdmin).Error; err != nil {
		tx.Rollback()
		log.Printf("ERROR creating hotel admin: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to assign admin role"})
		return
	}

	// Update hotel with owner info
	if err := tx.Model(&Hotel{}).Where("id = ?", hotel.ID).Updates(map[string]interface{}{
		"owner_id":    user.ID,
		"owner_name":  req.FullName,
		"owner_phone": req.Phone,
		"owner_email": req.Email,
		"status":      "active",
	}).Error; err != nil {
		tx.Rollback()
		log.Printf("ERROR updating hotel owner: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update hotel owner"})
		return
	}

	// Commit transaction
	if err := tx.Commit().Error; err != nil {
		log.Printf("ERROR committing transaction: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to complete registration"})
		return
	}

	log.Printf("✅ Hotel '%s' registered successfully by %s (User ID: %d, Hotel ID: %d)", hotel.Name, user.FullName, user.ID, hotel.ID)

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
		"message": "Hotel registered successfully",
		"token":   tokenString,
		"user": gin.H{
			"id":        user.ID,
			"email":     user.Email,
			"full_name": user.FullName,
			"phone":     user.Phone,
			"role":      user.Role,
			"hotel_id":  user.HotelID,
		},
		"hotel": gin.H{
			"id":      hotel.ID,
			"name":    hotel.Name,
			"city":    hotel.City,
			"address": hotel.Address,
			"status":  "active",
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
	if user.Status != "active" {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Account is inactive"})
		return
	}

	// Verify password
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.Password)); err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid email or password"})
		return
	}

	// Update last login
	// No longer updating last_login since column doesn't exist
	// api.DB.Model(&user).Update("last_login", time.Now())

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
			"hotel_id":  user.HotelID,
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

// getRoomTypeCounts - Helper function to get room counts for a room type (calculated on-the-fly)
func (api *API) getRoomTypeCounts(roomTypeID int) (totalRooms int64, blockchainRooms int64, err error) {
	// Count total rooms
	if err := api.DB.Model(&HotelRoom{}).Where("room_type_id = ?", roomTypeID).Count(&totalRooms).Error; err != nil {
		return 0, 0, err
	}

	// Count blockchain-enabled rooms
	if err := api.DB.Model(&HotelRoom{}).Where("room_type_id = ? AND is_blockchain_enabled = ?", roomTypeID, true).Count(&blockchainRooms).Error; err != nil {
		return 0, 0, err
	}

	return totalRooms, blockchainRooms, nil
}

// createRoom - Create a new room
func (api *API) createRoom(c *gin.Context) {
	hotelID := c.Param("id")

	// Check if user has permission
	userID, _ := c.Get("user_id")
	var user User
	if err := api.DB.Where("id = ?", userID).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found"})
		return
	}

	// Verify user belongs to this hotel
	if user.HotelID == nil || *user.HotelID != stringToInt(hotelID) {
		c.JSON(http.StatusForbidden, gin.H{"error": "Access denied"})
		return
	}

	var req struct {
		RoomTypeID          int    `json:"room_type_id" binding:"required"`
		RoomNumber          string `json:"room_number" binding:"required"`
		Floor               int    `json:"floor" binding:"required"`
		IsBlockchainEnabled bool   `json:"is_blockchain_enabled"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request", "details": err.Error()})
		return
	}

	// Check if room number already exists
	var existingRoom HotelRoom
	if err := api.DB.Where("hotel_id = ? AND room_number = ?", hotelID, req.RoomNumber).First(&existingRoom).Error; err == nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Room number already exists"})
		return
	}

	room := HotelRoom{
		HotelID:             stringToInt(hotelID),
		RoomTypeID:          req.RoomTypeID,
		RoomNumber:          req.RoomNumber,
		Floor:               req.Floor,
		IsBlockchainEnabled: req.IsBlockchainEnabled,
		Status:              "AVAILABLE",
	}

	if err := api.DB.Create(&room).Error; err != nil {
		log.Printf("ERROR creating room: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create room"})
		return
	}

	log.Printf("✅ Room %s created for hotel %s", req.RoomNumber, hotelID)
	c.JSON(http.StatusCreated, gin.H{"message": "Room created successfully", "room": room})
}

// updateRoom - Update an existing room
func (api *API) updateRoom(c *gin.Context) {
	hotelID := c.Param("id")
	roomID := c.Param("room_id")

	// Check if user has permission
	userID, _ := c.Get("user_id")
	var user User
	if err := api.DB.Where("id = ?", userID).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found"})
		return
	}

	// Verify user belongs to this hotel
	if user.HotelID == nil || *user.HotelID != stringToInt(hotelID) {
		c.JSON(http.StatusForbidden, gin.H{"error": "Access denied"})
		return
	}

	var room HotelRoom
	if err := api.DB.Where("id = ? AND hotel_id = ?", roomID, hotelID).First(&room).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Room not found"})
		return
	}

	var req struct {
		RoomTypeID          *int    `json:"room_type_id"`
		RoomNumber          *string `json:"room_number"`
		Floor               *int    `json:"floor"`
		IsBlockchainEnabled *bool   `json:"is_blockchain_enabled"`
		Status              *string `json:"status"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request", "details": err.Error()})
		return
	}

	// Update fields
	updates := make(map[string]interface{})
	if req.RoomTypeID != nil {
		updates["room_type_id"] = *req.RoomTypeID
	}
	if req.RoomNumber != nil {
		// Check if new room number already exists
		var existingRoom HotelRoom
		if err := api.DB.Where("hotel_id = ? AND room_number = ? AND id != ?", hotelID, *req.RoomNumber, roomID).First(&existingRoom).Error; err == nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Room number already exists"})
			return
		}
		updates["room_number"] = *req.RoomNumber
	}
	if req.Floor != nil {
		updates["floor"] = *req.Floor
	}
	if req.IsBlockchainEnabled != nil {
		updates["is_blockchain_enabled"] = *req.IsBlockchainEnabled
	}
	if req.Status != nil {
		updates["status"] = *req.Status
	}

	if err := api.DB.Model(&room).Updates(updates).Error; err != nil {
		log.Printf("ERROR updating room: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update room"})
		return
	}

	// Reload room data
	api.DB.Where("id = ?", roomID).First(&room)

	log.Printf("✅ Room %d updated for hotel %s", room.ID, hotelID)
	c.JSON(http.StatusOK, gin.H{"message": "Room updated successfully", "room": room})
}

// deleteRoom - Delete a room
func (api *API) deleteRoom(c *gin.Context) {
	hotelID := c.Param("id")
	roomID := c.Param("room_id")

	// Check if user has permission
	userID, _ := c.Get("user_id")
	var user User
	if err := api.DB.Where("id = ?", userID).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found"})
		return
	}

	// Verify user belongs to this hotel
	if user.HotelID == nil || *user.HotelID != stringToInt(hotelID) {
		c.JSON(http.StatusForbidden, gin.H{"error": "Access denied"})
		return
	}

	var room HotelRoom
	if err := api.DB.Where("id = ? AND hotel_id = ?", roomID, hotelID).First(&room).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Room not found"})
		return
	}

	// Check if room has active reservations
	var activeReservations int64
	api.DB.Model(&RoomReservation{}).
		Where("hotel_room_id = ? AND status IN (?)", roomID, []string{"CONFIRMED", "CHECKED_IN"}).
		Count(&activeReservations)

	if activeReservations > 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Cannot delete room with active reservations"})
		return
	}

	if err := api.DB.Delete(&room).Error; err != nil {
		log.Printf("ERROR deleting room: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete room"})
		return
	}

	log.Printf("✅ Room %d deleted from hotel %s", room.ID, hotelID)
	c.JSON(http.StatusOK, gin.H{"message": "Room deleted successfully"})
}

// createRoomType - Create a new room type
func (api *API) createRoomType(c *gin.Context) {
	hotelID := c.Param("id")

	// Check if user has permission
	userID, _ := c.Get("user_id")
	var user User
	if err := api.DB.Where("id = ?", userID).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found"})
		return
	}

	// Verify user belongs to this hotel OR is super admin
	hotelIDInt := stringToInt(hotelID)
	if user.HotelID == nil {
		log.Printf("ERROR: User %d has no hotel_id", user.ID)
		c.JSON(http.StatusForbidden, gin.H{"error": "Access denied - no hotel assigned"})
		return
	}

	if *user.HotelID != hotelIDInt {
		log.Printf("ERROR: User hotel_id %d does not match requested hotel %d", *user.HotelID, hotelIDInt)
		c.JSON(http.StatusForbidden, gin.H{"error": "Access denied - hotel mismatch"})
		return
	}

	var req struct {
		TypeName       string   `json:"type_name" binding:"required"`
		RoomCategory   string   `json:"room_category"` // hotel_room or meeting_room
		Description    string   `json:"description"`
		PricePerPerson float64  `json:"price_per_person"` // For hotel rooms
		PricingType    string   `json:"pricing_type"`     // per_night, per_hour, half_day, full_day
		HourlyRate     *float64 `json:"hourly_rate"`      // For meeting rooms
		HalfDayRate    *float64 `json:"half_day_rate"`    // For meeting rooms
		FullDayRate    *float64 `json:"full_day_rate"`    // For meeting rooms
		MinCapacity    int      `json:"min_capacity" binding:"required"`
		MaxCapacity    int      `json:"max_capacity" binding:"required"`
		Amenities      string   `json:"amenities"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request", "details": err.Error()})
		return
	}

	// Set defaults
	roomCategory := req.RoomCategory
	if roomCategory == "" {
		roomCategory = "hotel_room"
	}

	pricingType := req.PricingType
	if pricingType == "" {
		if roomCategory == "meeting_room" {
			pricingType = "per_hour"
		} else {
			pricingType = "per_night"
		}
	}

	roomType := RoomType{
		HotelID:        stringToInt(hotelID),
		TypeName:       req.TypeName,
		RoomCategory:   roomCategory,
		Description:    req.Description,
		PricePerPerson: req.PricePerPerson,
		PricingType:    pricingType,
		HourlyRate:     req.HourlyRate,
		HalfDayRate:    req.HalfDayRate,
		FullDayRate:    req.FullDayRate,
		MinCapacity:    req.MinCapacity,
		MaxCapacity:    req.MaxCapacity,
		Amenities:      req.Amenities,
	}

	if err := api.DB.Create(&roomType).Error; err != nil {
		log.Printf("ERROR creating room type: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create room type"})
		return
	}

	log.Printf("✅ Room type '%s' created for hotel %s", req.TypeName, hotelID)
	c.JSON(http.StatusCreated, gin.H{"message": "Room type created successfully", "room_type": roomType})
}

// updateRoomType - Update an existing room type
func (api *API) updateRoomType(c *gin.Context) {
	hotelID := c.Param("id")
	typeID := c.Param("type_id")

	// Check if user has permission
	userID, _ := c.Get("user_id")
	var user User
	if err := api.DB.Where("id = ?", userID).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found"})
		return
	}

	// Verify user belongs to this hotel
	if user.HotelID == nil || *user.HotelID != stringToInt(hotelID) {
		c.JSON(http.StatusForbidden, gin.H{"error": "Access denied"})
		return
	}

	var roomType RoomType
	if err := api.DB.Where("id = ? AND hotel_id = ?", typeID, hotelID).First(&roomType).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Room type not found"})
		return
	}

	var req struct {
		TypeName                *string  `json:"type_name"`
		RoomCategory            *string  `json:"room_category"` // hotel_room or meeting_room
		Description             *string  `json:"description"`
		PricePerPerson          *float64 `json:"price_per_person"`
		PricingType             *string  `json:"pricing_type"` // per_night, per_hour, half_day, full_day
		HourlyRate              *float64 `json:"hourly_rate"`
		HalfDayRate             *float64 `json:"half_day_rate"`
		FullDayRate             *float64 `json:"full_day_rate"`
		MinCapacity             *int     `json:"min_capacity"`
		MaxCapacity             *int     `json:"max_capacity"`
		TotalRooms              *int     `json:"total_rooms"`
		BlockchainReservedRooms *int     `json:"blockchain_reserved_rooms"`
		Amenities               *string  `json:"amenities"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request", "details": err.Error()})
		return
	}

	// Update fields
	updates := make(map[string]interface{})
	if req.TypeName != nil {
		updates["type_name"] = *req.TypeName
	}
	if req.RoomCategory != nil {
		updates["room_category"] = *req.RoomCategory
	}
	if req.Description != nil {
		updates["description"] = *req.Description
	}
	if req.PricePerPerson != nil {
		updates["price_per_person"] = *req.PricePerPerson
	}
	if req.PricingType != nil {
		updates["pricing_type"] = *req.PricingType
	}
	if req.HourlyRate != nil {
		updates["hourly_rate"] = *req.HourlyRate
	}
	if req.HalfDayRate != nil {
		updates["half_day_rate"] = *req.HalfDayRate
	}
	if req.FullDayRate != nil {
		updates["full_day_rate"] = *req.FullDayRate
	}
	if req.MinCapacity != nil {
		updates["min_capacity"] = *req.MinCapacity
	}
	if req.MaxCapacity != nil {
		updates["max_capacity"] = *req.MaxCapacity
	}
	if req.TotalRooms != nil {
		updates["total_rooms"] = *req.TotalRooms
		updates["available_rooms"] = *req.TotalRooms
	}
	if req.BlockchainReservedRooms != nil {
		updates["blockchain_reserved_rooms"] = *req.BlockchainReservedRooms
	}
	if req.Amenities != nil {
		updates["amenities"] = *req.Amenities
	}

	if err := api.DB.Model(&roomType).Updates(updates).Error; err != nil {
		log.Printf("ERROR updating room type: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update room type"})
		return
	}

	// Reload room type data
	api.DB.Where("id = ?", typeID).First(&roomType)

	log.Printf("✅ Room type %d updated for hotel %s", roomType.ID, hotelID)
	c.JSON(http.StatusOK, gin.H{"message": "Room type updated successfully", "room_type": roomType})
}

// deleteRoomType - Delete a room type
func (api *API) deleteRoomType(c *gin.Context) {
	hotelID := c.Param("id")
	typeID := c.Param("type_id")

	// Check if user has permission
	userID, _ := c.Get("user_id")
	var user User
	if err := api.DB.Where("id = ?", userID).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found"})
		return
	}

	// Verify user belongs to this hotel
	if user.HotelID == nil || *user.HotelID != stringToInt(hotelID) {
		c.JSON(http.StatusForbidden, gin.H{"error": "Access denied"})
		return
	}

	var roomType RoomType
	if err := api.DB.Where("id = ? AND hotel_id = ?", typeID, hotelID).First(&roomType).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Room type not found"})
		return
	}

	// Check if room type has rooms
	var roomCount int64
	api.DB.Model(&HotelRoom{}).Where("room_type_id = ?", typeID).Count(&roomCount)

	if roomCount > 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Cannot delete room type with existing rooms"})
		return
	}

	if err := api.DB.Delete(&roomType).Error; err != nil {
		log.Printf("ERROR deleting room type: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete room type"})
		return
	}

	log.Printf("✅ Room type %d deleted from hotel %s", roomType.ID, hotelID)
	c.JSON(http.StatusOK, gin.H{"message": "Room type deleted successfully"})
}

// ============================================================================
// HOTEL ADMIN/STAFF MANAGEMENT HANDLERS
// ============================================================================

// getHotelAdmins - Get all admins/staff for a hotel
func (api *API) getHotelAdmins(c *gin.Context) {
	hotelID := c.Param("id")

	// Check permission
	userID, _ := c.Get("user_id")
	var user User
	if err := api.DB.Where("id = ?", userID).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found"})
		return
	}

	hotelIDInt := stringToInt(hotelID)
	if user.HotelID == nil || *user.HotelID != hotelIDInt {
		c.JSON(http.StatusForbidden, gin.H{"error": "Access denied"})
		return
	}

	// Get all admins with user details
	type AdminWithUser struct {
		HotelAdmin
		User User `json:"user" gorm:"foreignKey:UserID"`
	}

	var admins []HotelAdmin
	if err := api.DB.Where("hotel_id = ?", hotelID).Find(&admins).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch admins"})
		return
	}

	// Get user details for each admin
	var response []map[string]interface{}
	for _, admin := range admins {
		var adminUser User
		if err := api.DB.Where("id = ?", admin.UserID).First(&adminUser).Error; err != nil {
			continue
		}

		response = append(response, map[string]interface{}{
			"id":          admin.ID,
			"hotel_id":    admin.HotelID,
			"user_id":     admin.UserID,
			"role":        admin.Role,
			"permissions": admin.Permissions,
			"assigned_by": admin.AssignedBy,
			"created_at":  admin.CreatedAt,
			"updated_at":  admin.UpdatedAt,
			"user": map[string]interface{}{
				"id":        adminUser.ID,
				"email":     adminUser.Email,
				"full_name": adminUser.FullName,
				"phone":     adminUser.Phone,
				"role":      adminUser.Role,
				"status":    adminUser.Status,
			},
		})
	}

	c.JSON(http.StatusOK, gin.H{"admins": response})
}

// createHotelAdmin - Add new admin/staff to hotel (Super Admin only)
func (api *API) createHotelAdmin(c *gin.Context) {
	hotelID := c.Param("id")

	// Check permission - only super admin can add staff
	userID, _ := c.Get("user_id")
	var user User
	if err := api.DB.Where("id = ?", userID).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found"})
		return
	}

	hotelIDInt := stringToInt(hotelID)
	if user.HotelID == nil || *user.HotelID != hotelIDInt {
		c.JSON(http.StatusForbidden, gin.H{"error": "Access denied"})
		return
	}

	// Only hotel_super_admin can add new admins
	if user.Role != "hotel_super_admin" {
		c.JSON(http.StatusForbidden, gin.H{"error": "Only super admin can add new staff"})
		return
	}

	var req struct {
		Email       string `json:"email" binding:"required,email"`
		FullName    string `json:"full_name" binding:"required"`
		Phone       string `json:"phone" binding:"required"`
		Password    string `json:"password" binding:"required,min=6"`
		Role        string `json:"role"` // staff, admin, manager
		Permissions string `json:"permissions"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request", "details": err.Error()})
		return
	}

	// Set default role if not provided
	if req.Role == "" {
		req.Role = "staff"
	}

	// Check if email already exists
	var existingUser User
	if err := api.DB.Where("email = ?", req.Email).First(&existingUser).Error; err == nil {
		c.JSON(http.StatusConflict, gin.H{"error": "Email already registered"})
		return
	}

	// Hash password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password"})
		return
	}

	// Create user account
	newUser := User{
		Email:    req.Email,
		Password: string(hashedPassword),
		FullName: req.FullName,
		Phone:    req.Phone,
		Role:     "hotel_admin",
		HotelID:  &hotelIDInt,
		Status:   "active",
	}

	if err := api.DB.Create(&newUser).Error; err != nil {
		log.Printf("ERROR creating user: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create user"})
		return
	}

	// Create hotel admin entry
	adminUserID := userID.(int)
	hotelAdmin := HotelAdmin{
		HotelID:     hotelIDInt,
		UserID:      newUser.ID,
		Role:        req.Role,
		Permissions: req.Permissions,
		AssignedBy:  &adminUserID,
	}

	if err := api.DB.Create(&hotelAdmin).Error; err != nil {
		// Rollback user creation
		api.DB.Delete(&newUser)
		log.Printf("ERROR creating hotel admin: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create admin"})
		return
	}

	log.Printf("✅ New admin created: %s for hotel %s by user %d", req.Email, hotelID, adminUserID)
	c.JSON(http.StatusCreated, gin.H{
		"message": "Admin created successfully",
		"admin": map[string]interface{}{
			"id":          hotelAdmin.ID,
			"hotel_id":    hotelAdmin.HotelID,
			"user_id":     hotelAdmin.UserID,
			"role":        hotelAdmin.Role,
			"permissions": hotelAdmin.Permissions,
			"user": map[string]interface{}{
				"id":        newUser.ID,
				"email":     newUser.Email,
				"full_name": newUser.FullName,
				"phone":     newUser.Phone,
			},
		},
	})
}

// updateHotelAdmin - Update admin/staff role and permissions (Super Admin only)
func (api *API) updateHotelAdmin(c *gin.Context) {
	hotelID := c.Param("id")
	adminID := c.Param("admin_id")

	// Check permission
	userID, _ := c.Get("user_id")
	var user User
	if err := api.DB.Where("id = ?", userID).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found"})
		return
	}

	hotelIDInt := stringToInt(hotelID)
	if user.HotelID == nil || *user.HotelID != hotelIDInt {
		c.JSON(http.StatusForbidden, gin.H{"error": "Access denied"})
		return
	}

	if user.Role != "hotel_super_admin" {
		c.JSON(http.StatusForbidden, gin.H{"error": "Only super admin can update staff"})
		return
	}

	var req struct {
		Role        string `json:"role"`
		Permissions string `json:"permissions"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}

	var hotelAdmin HotelAdmin
	if err := api.DB.Where("id = ? AND hotel_id = ?", adminID, hotelID).First(&hotelAdmin).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Admin not found"})
		return
	}

	// Update fields
	updates := make(map[string]interface{})
	if req.Role != "" {
		updates["role"] = req.Role
	}
	if req.Permissions != "" {
		updates["permissions"] = req.Permissions
	}

	if err := api.DB.Model(&hotelAdmin).Updates(updates).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update admin"})
		return
	}

	log.Printf("✅ Admin %s updated for hotel %s", adminID, hotelID)
	c.JSON(http.StatusOK, gin.H{"message": "Admin updated successfully", "admin": hotelAdmin})
}

// deleteHotelAdmin - Remove admin/staff from hotel (Super Admin only)
func (api *API) deleteHotelAdmin(c *gin.Context) {
	hotelID := c.Param("id")
	adminID := c.Param("admin_id")

	// Check permission
	userID, _ := c.Get("user_id")
	var user User
	if err := api.DB.Where("id = ?", userID).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found"})
		return
	}

	hotelIDInt := stringToInt(hotelID)
	if user.HotelID == nil || *user.HotelID != hotelIDInt {
		c.JSON(http.StatusForbidden, gin.H{"error": "Access denied"})
		return
	}

	if user.Role != "hotel_super_admin" {
		c.JSON(http.StatusForbidden, gin.H{"error": "Only super admin can remove staff"})
		return
	}

	var hotelAdmin HotelAdmin
	if err := api.DB.Where("id = ? AND hotel_id = ?", adminID, hotelID).First(&hotelAdmin).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Admin not found"})
		return
	}

	// Don't allow deleting yourself
	if hotelAdmin.UserID == userID.(int) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Cannot remove yourself"})
		return
	}

	// Delete hotel_admin entry
	if err := api.DB.Delete(&hotelAdmin).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete admin"})
		return
	}

	// Optionally delete user account or just set status to inactive
	var adminUser User
	if err := api.DB.Where("id = ?", hotelAdmin.UserID).First(&adminUser).Error; err == nil {
		api.DB.Model(&adminUser).Update("status", "inactive")
		api.DB.Model(&adminUser).Update("hotel_id", nil)
	}

	log.Printf("✅ Admin %s removed from hotel %s", adminID, hotelID)
	c.JSON(http.StatusOK, gin.H{"message": "Admin removed successfully"})
}

// getHotelStatistics returns statistics for hotel dashboard
func (api *API) getHotelStatistics(c *gin.Context) {
	hotelID := c.Param("id")

	// Count total rooms
	var totalRooms int64
	api.DB.Model(&HotelRoom{}).Where("hotel_id = ?", hotelID).Count(&totalRooms)

	// Count booked/occupied rooms
	var bookedRooms int64
	api.DB.Model(&HotelRoom{}).Where("hotel_id = ? AND status = ?", hotelID, "OCCUPIED").Count(&bookedRooms)

	// Count pending bookings
	var pendingBookings int64
	api.DB.Model(&Reservation{}).Where("hotel_id = ? AND status = ?", hotelID, "PENDING").Count(&pendingBookings)

	// Calculate total revenue (sum of all confirmed/completed reservations)
	var totalRevenue float64
	api.DB.Model(&Reservation{}).
		Where("hotel_id = ? AND status IN ?", hotelID, []string{"CONFIRMED", "CHECKED_IN", "CHECKED_OUT"}).
		Select("COALESCE(SUM(total_price), 0)").
		Scan(&totalRevenue)

	// Get recent bookings count by status
	var confirmedCount, checkedInCount, checkedOutCount, cancelledCount int64
	api.DB.Model(&Reservation{}).Where("hotel_id = ? AND status = ?", hotelID, "CONFIRMED").Count(&confirmedCount)
	api.DB.Model(&Reservation{}).Where("hotel_id = ? AND status = ?", hotelID, "CHECKED_IN").Count(&checkedInCount)
	api.DB.Model(&Reservation{}).Where("hotel_id = ? AND status = ?", hotelID, "CHECKED_OUT").Count(&checkedOutCount)
	api.DB.Model(&Reservation{}).Where("hotel_id = ? AND status = ?", hotelID, "CANCELLED").Count(&cancelledCount)

	c.JSON(http.StatusOK, gin.H{
		"statistics": gin.H{
			"totalRooms":      totalRooms,
			"bookedRooms":     bookedRooms,
			"totalRevenue":    totalRevenue,
			"pendingBookings": pendingBookings,
			"confirmedCount":  confirmedCount,
			"checkedInCount":  checkedInCount,
			"checkedOutCount": checkedOutCount,
			"cancelledCount":  cancelledCount,
		},
	})
}

// Helper function to convert string to int
func stringToInt(s string) int {
	val, _ := strconv.Atoi(s)
	return val
}

// ===== ROOM LAYOUT HANDLERS =====

// RoomLayout represents room position on floor plan
type RoomLayout struct {
	ID                  int        `json:"id"`
	HotelID             int        `json:"hotel_id"`
	RoomNumber          string     `json:"room_number"`
	RoomTypeID          int        `json:"room_type_id"`
	RoomTypeName        string     `json:"room_type_name"`
	Floor               int        `json:"floor"`
	Status              string     `json:"status"`
	IsBlockchainEnabled bool       `json:"is_blockchain_enabled"`
	LayoutX             *int       `json:"layout_x"`
	LayoutY             *int       `json:"layout_y"`
	LayoutWidth         int        `json:"layout_width"`
	LayoutHeight        int        `json:"layout_height"`
	LayoutUpdatedAt     *time.Time `json:"layout_updated_at,omitempty"`
}

type LayoutUpdateRequest struct {
	Updates []struct {
		RoomID       int  `json:"room_id"`
		LayoutX      *int `json:"layout_x"`
		LayoutY      *int `json:"layout_y"`
		LayoutWidth  int  `json:"layout_width"`
		LayoutHeight int  `json:"layout_height"`
	} `json:"updates"`
}

type AutoArrangeRequest struct {
	Floor       int  `json:"floor"`
	RoomTypeID  *int `json:"room_type_id,omitempty"`
	GridColumns int  `json:"grid_columns"`
	SpacingX    int  `json:"spacing_x"`
	SpacingY    int  `json:"spacing_y"`
}

func (api *API) getRoomLayoutByFloor(c *gin.Context) {
	hotelID := c.Param("id")
	floor := c.Param("floor")

	roomTypeIDStr := c.Query("room_type_id")
	var roomTypeID *int
	if roomTypeIDStr != "" {
		rtID, err := strconv.Atoi(roomTypeIDStr)
		if err == nil {
			roomTypeID = &rtID
		}
	}

	query := `
		SELECT 
			hr.id,
			hr.hotel_id,
			hr.room_number,
			hr.room_type_id,
			rt.type_name as room_type_name,
			hr.floor,
			hr.status,
			hr.is_blockchain_enabled,
			hr.layout_x,
			hr.layout_y,
			hr.layout_width,
			hr.layout_height,
			hr.layout_updated_at
		FROM hotel_rooms hr
		LEFT JOIN room_types rt ON hr.room_type_id = rt.id
		WHERE hr.hotel_id = ? AND hr.floor = ?
	`

	args := []interface{}{hotelID, floor}
	if roomTypeID != nil {
		query += " AND hr.room_type_id = ?"
		args = append(args, *roomTypeID)
	}
	query += " ORDER BY hr.room_number"

	rows, err := api.DB.Raw(query, args...).Rows()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		return
	}
	defer rows.Close()

	var rooms []RoomLayout
	for rows.Next() {
		var room RoomLayout
		err := rows.Scan(
			&room.ID,
			&room.HotelID,
			&room.RoomNumber,
			&room.RoomTypeID,
			&room.RoomTypeName,
			&room.Floor,
			&room.Status,
			&room.IsBlockchainEnabled,
			&room.LayoutX,
			&room.LayoutY,
			&room.LayoutWidth,
			&room.LayoutHeight,
			&room.LayoutUpdatedAt,
		)
		if err != nil {
			continue
		}
		rooms = append(rooms, room)
	}

	c.JSON(http.StatusOK, gin.H{
		"floor":            floor,
		"hotel_id":         hotelID,
		"room_type_filter": roomTypeID,
		"rooms":            rooms,
		"total":            len(rooms),
	})
}

func (api *API) updateRoomLayout(c *gin.Context) {
	hotelID := c.Param("id")
	userID := c.GetInt("user_id")
	userRole := c.GetString("user_role")
	userHotelID := c.GetInt("hotel_id")

	// Debug logging
	log.Printf("🔍 updateRoomLayout - hotelID: %s, userID: %d, userRole: %s, userHotelID: %d",
		hotelID, userID, userRole, userHotelID)

	// Check if user is hotel admin
	if userRole != "hotel_super_admin" && userRole != "hotel_admin" {
		log.Printf("❌ Access denied: user role is %s", userRole)
		c.JSON(http.StatusForbidden, gin.H{"error": "Hotel admin access required"})
		return
	}

	// Check if user belongs to this hotel
	requestedHotelID := stringToInt(hotelID)
	if userHotelID > 0 && userHotelID != requestedHotelID {
		log.Printf("❌ Hotel mismatch: user hotel_id=%d, requested hotel_id=%d", userHotelID, requestedHotelID)
		c.JSON(http.StatusForbidden, gin.H{"error": "Cannot modify layout for other hotels"})
		return
	}

	// If userHotelID is 0 or not set, verify from database
	if userHotelID == 0 {
		var user User
		if err := api.DB.First(&user, userID).Error; err == nil {
			if user.HotelID != nil && *user.HotelID != requestedHotelID {
				log.Printf("❌ DB check: user belongs to hotel %d, not %d", *user.HotelID, requestedHotelID)
				c.JSON(http.StatusForbidden, gin.H{"error": "Cannot modify layout for other hotels"})
				return
			}
		}
	}

	var req LayoutUpdateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
		return
	}

	tx := api.DB.Begin()
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	updateCount := 0
	for _, update := range req.Updates {
		result := tx.Model(&HotelRoom{}).
			Where("id = ? AND hotel_id = ?", update.RoomID, hotelID).
			Updates(map[string]interface{}{
				"layout_x":          update.LayoutX,
				"layout_y":          update.LayoutY,
				"layout_width":      update.LayoutWidth,
				"layout_height":     update.LayoutHeight,
				"layout_updated_at": time.Now(),
			})

		if result.Error == nil && result.RowsAffected > 0 {
			updateCount++
		}
	}

	if err := tx.Commit().Error; err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save changes"})
		return
	}

	log.Printf("✅ Room layout updated for hotel %s by user %d: %d rooms", hotelID, userID, updateCount)
	c.JSON(http.StatusOK, gin.H{
		"message":       "Layout updated successfully",
		"updated_count": updateCount,
	})
}

func (api *API) autoArrangeLayout(c *gin.Context) {
	hotelID := c.Param("id")
	userRole := c.GetString("user_role")
	userHotelID := c.GetInt("hotel_id")

	if userRole != "hotel_super_admin" && userRole != "hotel_admin" {
		c.JSON(http.StatusForbidden, gin.H{"error": "Hotel admin access required"})
		return
	}

	if userHotelID != stringToInt(hotelID) {
		c.JSON(http.StatusForbidden, gin.H{"error": "Cannot arrange layout for other hotels"})
		return
	}

	var req AutoArrangeRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
		return
	}

	if req.GridColumns == 0 {
		req.GridColumns = 5
	}
	if req.SpacingX == 0 {
		req.SpacingX = 120
	}
	if req.SpacingY == 0 {
		req.SpacingY = 100
	}

	query := api.DB.Model(&HotelRoom{}).
		Where("hotel_id = ? AND floor = ?", hotelID, req.Floor)

	if req.RoomTypeID != nil {
		query = query.Where("room_type_id = ?", *req.RoomTypeID)
	}

	var rooms []HotelRoom
	if err := query.Order("room_number").Find(&rooms).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		return
	}

	tx := api.DB.Begin()
	arrangedCount := 0
	for i, room := range rooms {
		col := i % req.GridColumns
		row := i / req.GridColumns

		layoutX := col * req.SpacingX
		layoutY := row * req.SpacingY

		result := tx.Model(&HotelRoom{}).Where("id = ?", room.ID).Updates(map[string]interface{}{
			"layout_x":          layoutX,
			"layout_y":          layoutY,
			"layout_width":      100,
			"layout_height":     80,
			"layout_updated_at": time.Now(),
		})

		if result.Error == nil && result.RowsAffected > 0 {
			arrangedCount++
		}
	}

	if err := tx.Commit().Error; err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save arrangement"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message":        "Layout auto-arranged successfully",
		"arranged_count": arrangedCount,
		"grid_columns":   req.GridColumns,
	})
}

func (api *API) resetRoomLayout(c *gin.Context) {
	hotelID := c.Param("id")
	userRole := c.GetString("user_role")
	userHotelID := c.GetInt("hotel_id")

	if userRole != "hotel_super_admin" && userRole != "hotel_admin" {
		c.JSON(http.StatusForbidden, gin.H{"error": "Hotel admin access required"})
		return
	}

	if userHotelID != stringToInt(hotelID) {
		c.JSON(http.StatusForbidden, gin.H{"error": "Cannot reset layout for other hotels"})
		return
	}

	result := api.DB.Model(&HotelRoom{}).
		Where("hotel_id = ?", hotelID).
		Updates(map[string]interface{}{
			"layout_x":          nil,
			"layout_y":          nil,
			"layout_width":      100,
			"layout_height":     80,
			"layout_updated_at": nil,
		})

	if result.Error != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message":     "Layout reset successfully",
		"reset_count": result.RowsAffected,
	})
}
