import {
  useEffect,
  useState,
} from 'react';

import toast from 'react-hot-toast';

import {
  blockchainService,
  reservationService,
} from '../services/api';

const ReservationsPage = () => {
  const [reservations, setReservations] = useState([])
  const [loading, setLoading] = useState(true)
  const [filter, setFilter] = useState('all')

  useEffect(() => {
    fetchReservations()
  }, [filter])

  const fetchReservations = async () => {
    try {
      setLoading(true)
      let response
      if (filter === 'all') {
        response = await reservationService.getAllReservations()
      } else {
        response = await reservationService.getReservationsByStatus(filter)
      }
      setReservations(response.data.reservations || [])
    } catch (error) {
      toast.error('Failed to fetch reservations')
      console.error(error)
    } finally {
      setLoading(false)
    }
  }

  const handleStatusUpdate = async (reservationId, action, note = '') => {
    try {
      let response
      switch (action) {
        case 'confirm':
          response = await reservationService.confirmReservation(reservationId, note)
          break
        case 'cancel':
          response = await reservationService.cancelReservation(reservationId, note)
          break
        case 'checkin':
          response = await reservationService.checkinReservation(reservationId, note)
          break
        case 'checkout':
          response = await reservationService.checkoutReservation(reservationId, note)
          break
        default:
          return
      }
      
      toast.success(response.data.message || `Reservation ${action} successful`)
      fetchReservations()
    } catch (error) {
      toast.error(`Failed to ${action} reservation`)
      console.error(error)
    }
  }

  const getStatusColor = (status) => {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'bg-yellow-100 text-yellow-800'
      case 'confirmed':
        return 'bg-green-100 text-green-800'
      case 'cancelled':
        return 'bg-red-100 text-red-800'
      case 'checked_in':
        return 'bg-blue-100 text-blue-800'
      case 'checked_out':
        return 'bg-gray-100 text-gray-800'
      default:
        return 'bg-gray-100 text-gray-800'
    }
  }

  const canPerformAction = (status, action) => {
    switch (action) {
      case 'confirm':
        return status === 'PENDING'
      case 'cancel':
        return ['PENDING', 'CONFIRMED', 'CHECKED_IN'].includes(status)
      case 'checkin':
        return status === 'CONFIRMED'
      case 'checkout':
        return status === 'CHECKED_IN'
      default:
        return false
    }
  }

  const showBlockchainHistory = async (reservationId) => {
    try {
      const response = await blockchainService.getReservationHistory(reservationId)
      const history = response.data.history || []
      
      // Create a modal or alert with history
      const historyText = history.length > 0 
        ? history.map(h => `${h.timestamp}: ${h.event_type} by ${h.actor_msp} - ${h.note || 'No note'}`).join('\n')
        : 'No blockchain history available'
      
      alert(`Blockchain History for ${reservationId}:\n\n${historyText}`)
    } catch (error) {
      toast.error('Failed to fetch blockchain history')
      console.error(error)
    }
  }

  if (loading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    )
  }

  return (
    <div className="max-w-6xl mx-auto">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-4">Reservations</h1>
        
        {/* Filter Buttons */}
        <div className="flex space-x-2 mb-6">
          {['all', 'PENDING', 'CONFIRMED', 'CHECKED_IN', 'CHECKED_OUT', 'CANCELLED'].map((status) => (
            <button
              key={status}
              onClick={() => setFilter(status)}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
                filter === status
                  ? 'bg-primary-600 text-white'
                  : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
              }`}
            >
              {status === 'all' ? 'All' : status.replace('_', ' ')}
            </button>
          ))}
        </div>
      </div>

      {reservations.length === 0 ? (
        <div className="text-center py-12">
          <div className="text-gray-500 text-lg">No reservations found.</div>
        </div>
      ) : (
        <div className="grid gap-6">
          {reservations.map((reservation) => (
            <div key={reservation.reservationID} className="bg-white rounded-lg shadow-md p-6">
              <div className="flex justify-between items-start mb-4">
                <div>
                  <h3 className="text-xl font-semibold text-gray-900">
                    Reservation {reservation.reservationID}
                  </h3>
                  <p className="text-gray-600">Hotel ID: {reservation.hotelID}</p>
                  <p className="text-gray-600">Room Type: {reservation.roomTypeID}</p>
                </div>
                <span className={`px-3 py-1 rounded-full text-sm font-medium ${getStatusColor(reservation.status)}`}>
                  {reservation.status.replace('_', ' ')}
                </span>
              </div>

              <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-4 mb-4">
                <div>
                  <span className="text-sm text-gray-500">Check-in</span>
                  <p className="font-medium">{reservation.checkIn}</p>
                </div>
                <div>
                  <span className="text-sm text-gray-500">Check-out</span>
                  <p className="font-medium">{reservation.checkOut}</p>
                </div>
                <div>
                  <span className="text-sm text-gray-500">Guests</span>
                  <p className="font-medium">{reservation.guestCount}</p>
                </div>
                <div>
                  <span className="text-sm text-gray-500">Total</span>
                  <p className="font-medium">{reservation.currency} {reservation.price?.toLocaleString()}</p>
                </div>
              </div>

              <div className="grid md:grid-cols-2 gap-4 mb-4">
                <div>
                  <span className="text-sm text-gray-500">Customer Reference</span>
                  <p className="font-medium">{reservation.customerRef}</p>
                </div>
                <div>
                  <span className="text-sm text-gray-500">Created By</span>
                  <p className="font-medium">{reservation.createdByOrg}</p>
                </div>
              </div>

              {/* Action Buttons */}
              <div className="flex flex-wrap gap-2 pt-4 border-t">
                {canPerformAction(reservation.status, 'confirm') && (
                  <button
                    onClick={() => handleStatusUpdate(reservation.reservationID, 'confirm', 'Reservation confirmed by hotel')}
                    className="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 transition-colors text-sm"
                  >
                    Confirm
                  </button>
                )}
                
                {canPerformAction(reservation.status, 'checkin') && (
                  <button
                    onClick={() => handleStatusUpdate(reservation.reservationID, 'checkin', 'Guest checked in')}
                    className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors text-sm"
                  >
                    Check In
                  </button>
                )}
                
                {canPerformAction(reservation.status, 'checkout') && (
                  <button
                    onClick={() => handleStatusUpdate(reservation.reservationID, 'checkout', 'Guest checked out')}
                    className="px-4 py-2 bg-gray-600 text-white rounded-md hover:bg-gray-700 transition-colors text-sm"
                  >
                    Check Out
                  </button>
                )}
                
                {canPerformAction(reservation.status, 'cancel') && (
                  <button
                    onClick={() => {
                      const reason = prompt('Please enter cancellation reason:')
                      if (reason) {
                        handleStatusUpdate(reservation.reservationID, 'cancel', reason)
                      }
                    }}
                    className="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 transition-colors text-sm"
                  >
                    Cancel
                  </button>
                )}
                
                {/* Blockchain History Button */}
                <button
                  onClick={() => showBlockchainHistory(reservation.reservationID)}
                  className="px-4 py-2 bg-purple-600 text-white rounded-md hover:bg-purple-700 transition-colors text-sm"
                >
                  📋 Blockchain History
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

export default ReservationsPage