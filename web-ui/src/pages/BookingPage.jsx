import {
  useEffect,
  useState,
} from 'react';

import {
  addDays,
  format,
} from 'date-fns';
import toast from 'react-hot-toast';
import {
  useNavigate,
  useParams,
} from 'react-router-dom';

import {
  hotelService,
  reservationService,
} from '../services/api';

const BookingPage = () => {
  const { hotelId } = useParams()
  const navigate = useNavigate()
  
  const [hotel, setHotel] = useState(null)
  const [roomTypes, setRoomTypes] = useState([])
  const [loading, setLoading] = useState(true)
  const [submitting, setSubmitting] = useState(false)
  
  const [formData, setFormData] = useState({
    roomTypeId: '',
    checkIn: format(new Date(), 'yyyy-MM-dd'),
    checkOut: format(addDays(new Date(), 1), 'yyyy-MM-dd'),
    guestCount: 1,
    customerRef: '',
  })

  useEffect(() => {
    fetchHotelData()
  }, [hotelId])

  const fetchHotelData = async () => {
    try {
      const [hotelResponse, roomsResponse] = await Promise.all([
        hotelService.getHotel(hotelId),
        hotelService.getHotelRooms(hotelId)
      ])
      
      setHotel(hotelResponse.data.hotel)
      setRoomTypes(roomsResponse.data.room_types)
      
      if (roomsResponse.data.room_types.length > 0) {
        setFormData(prev => ({
          ...prev,
          roomTypeId: roomsResponse.data.room_types[0].id.toString()
        }))
      }
    } catch (error) {
      toast.error('Failed to fetch hotel data')
      console.error(error)
    } finally {
      setLoading(false)
    }
  }

  const handleInputChange = (e) => {
    const { name, value } = e.target
    setFormData(prev => ({
      ...prev,
      [name]: value
    }))
  }

  const generateReservationId = () => {
    return 'RES' + Date.now() + Math.random().toString(36).substr(2, 5).toUpperCase()
  }

  const getSelectedRoomType = () => {
    return roomTypes.find(room => room.id.toString() === formData.roomTypeId)
  }

  const calculateTotal = () => {
    const selectedRoom = getSelectedRoomType()
    if (!selectedRoom) return 0
    
    const checkInDate = new Date(formData.checkIn)
    const checkOutDate = new Date(formData.checkOut)
    const nights = Math.ceil((checkOutDate - checkInDate) / (1000 * 60 * 60 * 24))
    
    return selectedRoom.base_price * nights
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    
    if (!formData.customerRef.trim()) {
      toast.error('Please enter customer reference')
      return
    }

    const selectedRoom = getSelectedRoomType()
    if (!selectedRoom) {
      toast.error('Please select a room type')
      return
    }

    if (new Date(formData.checkIn) >= new Date(formData.checkOut)) {
      toast.error('Check-out date must be after check-in date')
      return
    }

    setSubmitting(true)

    try {
      const reservationData = {
        reservation_id: generateReservationId(),
        hotel_id: hotelId,
        room_type_id: formData.roomTypeId,
        check_in: formData.checkIn,
        check_out: formData.checkOut,
        guest_count: parseInt(formData.guestCount),
        customer_ref: formData.customerRef,
        price: calculateTotal(),
        currency: selectedRoom.currency
      }

      await reservationService.createReservation(reservationData)
      
      toast.success('Reservation created successfully!')
      navigate('/reservations')
    } catch (error) {
      toast.error('Failed to create reservation')
      console.error(error)
    } finally {
      setSubmitting(false)
    }
  }

  if (loading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    )
  }

  if (!hotel) {
    return (
      <div className="text-center py-12">
        <div className="text-gray-500 text-lg">Hotel not found.</div>
      </div>
    )
  }

  return (
    <div className="max-w-4xl mx-auto">
      <div className="bg-white rounded-lg shadow-md overflow-hidden mb-8">
        <img
          src={hotel.image_url}
          alt={hotel.name}
          className="w-full h-64 object-cover"
        />
        <div className="p-6">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">{hotel.name}</h1>
          <p className="text-gray-600 mb-4">
            {hotel.address}, {hotel.city}, {hotel.country}
          </p>
          <p className="text-gray-700">{hotel.description}</p>
        </div>
      </div>

      <div className="grid lg:grid-cols-2 gap-8">
        {/* Booking Form */}
        <div className="bg-white rounded-lg shadow-md p-6">
          <h2 className="text-2xl font-semibold mb-6">Make a Reservation</h2>
          
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Room Type
              </label>
              <select
                name="roomTypeId"
                value={formData.roomTypeId}
                onChange={handleInputChange}
                className="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-primary-500"
                required
              >
                <option value="">Select Room Type</option>
                {roomTypes.map((room) => (
                  <option key={room.id} value={room.id}>
                    {room.type_name} - {room.currency} {room.base_price.toLocaleString()}/night
                  </option>
                ))}
              </select>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Check-in Date
                </label>
                <input
                  type="date"
                  name="checkIn"
                  value={formData.checkIn}
                  onChange={handleInputChange}
                  min={format(new Date(), 'yyyy-MM-dd')}
                  className="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-primary-500"
                  required
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Check-out Date
                </label>
                <input
                  type="date"
                  name="checkOut"
                  value={formData.checkOut}
                  onChange={handleInputChange}
                  min={formData.checkIn}
                  className="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-primary-500"
                  required
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Number of Guests
              </label>
              <select
                name="guestCount"
                value={formData.guestCount}
                onChange={handleInputChange}
                className="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-primary-500"
                required
              >
                {[1, 2, 3, 4, 5, 6].map((num) => (
                  <option key={num} value={num}>{num} {num === 1 ? 'Guest' : 'Guests'}</option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Customer Reference
              </label>
              <input
                type="text"
                name="customerRef"
                value={formData.customerRef}
                onChange={handleInputChange}
                placeholder="Enter customer ID or reference"
                className="w-full border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-primary-500"
                required
              />
            </div>

            <button
              type="submit"
              disabled={submitting}
              className="w-full bg-primary-600 text-white py-3 rounded-md hover:bg-primary-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {submitting ? 'Creating Reservation...' : 'Book Now'}
            </button>
          </form>
        </div>

        {/* Booking Summary */}
        <div className="bg-white rounded-lg shadow-md p-6">
          <h2 className="text-2xl font-semibold mb-6">Booking Summary</h2>
          
          {getSelectedRoomType() && (
            <div className="space-y-4">
              <div className="border-b pb-4">
                <h3 className="font-semibold">{getSelectedRoomType().type_name}</h3>
                <p className="text-gray-600 text-sm">{getSelectedRoomType().description}</p>
                <p className="text-sm text-gray-500">Max guests: {getSelectedRoomType().max_guests}</p>
              </div>
              
              <div className="space-y-2">
                <div className="flex justify-between">
                  <span>Check-in:</span>
                  <span>{formData.checkIn}</span>
                </div>
                <div className="flex justify-between">
                  <span>Check-out:</span>
                  <span>{formData.checkOut}</span>
                </div>
                <div className="flex justify-between">
                  <span>Guests:</span>
                  <span>{formData.guestCount}</span>
                </div>
                <div className="flex justify-between">
                  <span>Nights:</span>
                  <span>
                    {Math.ceil((new Date(formData.checkOut) - new Date(formData.checkIn)) / (1000 * 60 * 60 * 24))}
                  </span>
                </div>
              </div>
              
              <div className="border-t pt-4">
                <div className="flex justify-between text-lg font-semibold">
                  <span>Total:</span>
                  <span>{getSelectedRoomType().currency} {calculateTotal().toLocaleString()}</span>
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}

export default BookingPage