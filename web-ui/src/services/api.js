import axios from 'axios';

// Go backend API endpoint (port 8080)
const API_BASE_URL = 'http://localhost:8080/api/v1'

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Mock data for when backend is not available
const mockHotels = [
  {
    id: 1,
    name: "Grand Hotel Jakarta",
    address: "Jl. Sudirman No. 1",
    city: "Jakarta",
    country: "Indonesia",
    description: "Luxury hotel in the heart of Jakarta",
    rating: 5,
    image_url: "https://via.placeholder.com/300x200"
  },
  {
    id: 2,
    name: "Beach Resort Bali",
    address: "Jl. Pantai Kuta",
    city: "Bali",
    country: "Indonesia",
    description: "Beautiful beachfront resort",
    rating: 4,
    image_url: "https://via.placeholder.com/300x200"
  },
  {
    id: 3,
    name: "Mountain View Hotel",
    address: "Jl. Raya Puncak",
    city: "Bogor",
    country: "Indonesia",
    description: "Peaceful mountain retreat",
    rating: 4,
    image_url: "https://via.placeholder.com/300x200"
  }
]

const mockRoomTypes = {
  1: [
    { id: 1, hotel_id: 1, type_name: "Standard Room", description: "Comfortable standard room", max_guests: 2, base_price: 500000, currency: "IDR" },
    { id: 2, hotel_id: 1, type_name: "Deluxe Room", description: "Spacious deluxe room", max_guests: 3, base_price: 750000, currency: "IDR" },
    { id: 3, hotel_id: 1, type_name: "Suite", description: "Luxury suite", max_guests: 4, base_price: 1200000, currency: "IDR" }
  ],
  2: [
    { id: 4, hotel_id: 2, type_name: "Beach Villa", description: "Private beach villa", max_guests: 4, base_price: 1500000, currency: "IDR" },
    { id: 5, hotel_id: 2, type_name: "Garden Room", description: "Room with garden view", max_guests: 2, base_price: 800000, currency: "IDR" }
  ],
  3: [
    { id: 6, hotel_id: 3, type_name: "Mountain View", description: "Room with mountain view", max_guests: 2, base_price: 600000, currency: "IDR" }
  ]
}

let mockReservations = []

// Hotel services - try real API first, fallback to mock if needed
export const hotelService = {
  getAllHotels: async () => {
    try {
      const response = await api.get('/hotels')
      return response
    } catch (error) {
      console.warn('Backend API not available, using mock data')
      return { data: { hotels: mockHotels } }
    }
  },
  getHotel: async (id) => {
    try {
      const response = await api.get(`/hotels/${id}`)
      return response
    } catch (error) {
      console.warn('Backend API not available, using mock data')
      const hotel = mockHotels.find(h => h.id === parseInt(id))
      return { data: { hotel } }
    }
  },
  getHotelRooms: async (id) => {
    try {
      const response = await api.get(`/hotels/${id}/rooms`)
      return response
    } catch (error) {
      console.warn('Backend API not available, using mock data')
      const rooms = mockRoomTypes[parseInt(id)] || []
      return { data: { room_types: rooms } }
    }
  },
}

// Reservation services - try real API first, fallback to mock if needed
export const reservationService = {
  createReservation: async (data) => {
    try {
      const response = await api.post('/reservations', data)
      return response
    } catch (error) {
      console.warn('Backend API not available, using mock reservation creation')
      const reservation = {
        reservationID: data.reservation_id,
        hotelID: data.hotel_id,
        roomTypeID: data.room_type_id,
        checkIn: data.check_in,
        checkOut: data.check_out,
        guestCount: data.guest_count,
        customerRef: data.customer_ref,
        price: data.price,
        currency: data.currency,
        status: 'PENDING',
        createdByOrg: 'OTAOrgMSP',
        lastUpdatedAt: new Date().toISOString()
      }
      mockReservations.push(reservation)
      return { data: { message: 'Reservation created successfully (mock)', reservation_id: data.reservation_id } }
    }
  },
  getReservation: async (id) => {
    try {
      const response = await api.get(`/reservations/${id}`)
      return response
    } catch (error) {
      console.warn('Backend API not available, using mock data')
      const reservation = mockReservations.find(r => r.reservationID === id)
      return { data: { reservation } }
    }
  },
  confirmReservation: async (id, note) => {
    try {
      const response = await api.post(`/reservations/${id}/confirm`, { note })
      return response
    } catch (error) {
      console.warn('Backend API not available, using mock confirmation')
      const reservation = mockReservations.find(r => r.reservationID === id)
      if (reservation) {
        reservation.status = 'CONFIRMED'
        reservation.lastUpdatedAt = new Date().toISOString()
      }
      return { data: { message: 'Reservation confirmed successfully (mock)' } }
    }
  },
  cancelReservation: async (id, note) => {
    try {
      const response = await api.post(`/reservations/${id}/cancel`, { note })
      return response
    } catch (error) {
      console.warn('Backend API not available, using mock cancellation')
      const reservation = mockReservations.find(r => r.reservationID === id)
      if (reservation) {
        reservation.status = 'CANCELLED'
        reservation.lastUpdatedAt = new Date().toISOString()
      }
      return { data: { message: 'Reservation cancelled successfully (mock)' } }
    }
  },
  checkIn: async (id, note) => {
    try {
      const response = await api.post(`/reservations/${id}/checkin`, { note })
      return response
    } catch (error) {
      console.warn('Backend API not available, using mock check-in')
      const reservation = mockReservations.find(r => r.reservationID === id)
      if (reservation) {
        reservation.status = 'CHECKED_IN'
        reservation.lastUpdatedAt = new Date().toISOString()
      }
      return { data: { message: 'Check-in completed successfully (mock)' } }
    }
  },
  checkOut: async (id, note) => {
    try {
      const response = await api.post(`/reservations/${id}/checkout`, { note })
      return response
    } catch (error) {
      console.warn('Backend API not available, using mock check-out')
      const reservation = mockReservations.find(r => r.reservationID === id)
      if (reservation) {
        reservation.status = 'CHECKED_OUT'
        reservation.lastUpdatedAt = new Date().toISOString()
      }
      return { data: { message: 'Check-out completed successfully (mock)' } }
    }
  },
  getAllReservations: async () => {
    try {
      const response = await api.get('/reservations')
      return response
    } catch (error) {
      console.warn('Backend API not available, using mock data')
      return { data: { reservations: mockReservations } }
    }
  },
  getReservationsByStatus: async (status) => {
    try {
      const response = await api.get(`/reservations?status=${status}`)
      return response
    } catch (error) {
      console.warn('Backend API not available, using mock data')
      const filtered = mockReservations.filter(r => r.status === status)
      return { data: { reservations: filtered } }
    }
  },
  getReservationsByHotel: async (hotelId, startDate, endDate) => {
    try {
      const response = await api.get(`/reservations/hotel/${hotelId}?start_date=${startDate}&end_date=${endDate}`)
      return response
    } catch (error) {
      console.warn('Backend API not available, using mock data')
      const filtered = mockReservations.filter(r => r.hotelID === hotelId)
      return { data: { reservations: filtered } }
    }
  },
  checkinReservation: async (id, note) => {
    try {
      const response = await api.post(`/reservations/${id}/checkin`, { note })
      return response
    } catch (error) {
      console.warn('Backend API not available, using mock check-in')
      const reservation = mockReservations.find(r => r.reservationID === id)
      if (reservation) {
        reservation.status = 'CHECKED_IN'
        reservation.lastUpdatedAt = new Date().toISOString()
      }
      return { data: { message: 'Check-in successful (mock)' } }
    }
  },
  checkoutReservation: async (id, note) => {
    try {
      const response = await api.post(`/reservations/${id}/checkout`, { note })
      return response
    } catch (error) {
      console.warn('Backend API not available, using mock check-out')
      const reservation = mockReservations.find(r => r.reservationID === id)
      if (reservation) {
        reservation.status = 'CHECKED_OUT'
        reservation.lastUpdatedAt = new Date().toISOString()
      }
      return { data: { message: 'Check-out successful (mock)' } }
    }
  },
}

// Blockchain services for Go backend features
export const blockchainService = {
  getStats: async () => {
    try {
      const response = await api.get('/blockchain/stats')
      return response
    } catch (error) {
      console.warn('Blockchain API not available')
      return { 
        data: { 
          blockchain: { 
            type: 'Mock', 
            status: 'offline',
            blocks: 0,
            transactions: 0
          } 
        } 
      }
    }
  },
  getBlocks: async () => {
    try {
      const response = await api.get('/blockchain/blocks')
      return response
    } catch (error) {
      console.warn('Blockchain API not available')
      return { data: { blocks: [] } }
    }
  },
  getBlock: async (index) => {
    try {
      const response = await api.get(`/blockchain/blocks/${index}`)
      return response
    } catch (error) {
      console.warn('Blockchain API not available')
      return { data: { block: null } }
    }
  },
  switchBlockchain: async (useFabric) => {
    try {
      const response = await api.post('/blockchain/switch', { use_fabric: useFabric })
      return response
    } catch (error) {
      console.warn('Blockchain switch not available')
      return { data: { message: 'Switch not available (mock)' } }
    }
  },
  getReservationHistory: async (reservationId) => {
    try {
      const response = await api.get(`/reservations/${reservationId}/history`)
      return response
    } catch (error) {
      console.warn('History API not available')
      return { data: { history: [] } }
    }
  },
  getHealthCheck: async () => {
    try {
      const response = await api.get('/')
      return response
    } catch (error) {
      console.warn('Health check failed')
      return { data: { status: 'offline' } }
    }
  }
}

export default api