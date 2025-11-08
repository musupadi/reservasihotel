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
  const [showHistoryModal, setShowHistoryModal] = useState(false)
  const [selectedHistory, setSelectedHistory] = useState(null)
  const [selectedReservationId, setSelectedReservationId] = useState(null)

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
      
      setSelectedReservationId(reservationId)
      setSelectedHistory(history)
      setShowHistoryModal(true)
    } catch (error) {
      toast.error('Failed to fetch blockchain history')
      console.error(error)
    }
  }

  const getActionIcon = (action) => {
    switch(action) {
      case 'CREATE_RESERVATION': return '📝'
      case 'CONFIRM_RESERVATION': return '✅'
      case 'CANCEL_RESERVATION': return '❌'
      case 'CHECKIN': return '🏨'
      case 'CHECKOUT': return '👋'
      default: return '📋'
    }
  }

  const getActionColor = (action) => {
    switch(action) {
      case 'CREATE_RESERVATION': return 'bg-blue-100 text-blue-800'
      case 'CONFIRM_RESERVATION': return 'bg-green-100 text-green-800'
      case 'CANCEL_RESERVATION': return 'bg-red-100 text-red-800'
      case 'CHECKIN': return 'bg-purple-100 text-purple-800'
      case 'CHECKOUT': return 'bg-gray-100 text-gray-800'
      default: return 'bg-gray-100 text-gray-800'
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

      {/* Beautiful Blockchain History Modal */}
      {showHistoryModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-hidden">
            {/* Modal Header with Gradient */}
            <div className="bg-gradient-to-r from-purple-600 to-blue-600 text-white p-6 flex justify-between items-center">
              <div>
                <h2 className="text-2xl font-bold mb-1">⛓️ Blockchain History</h2>
                <p className="text-purple-100 text-sm">Reservation: {selectedReservationId}</p>
              </div>
              <button
                onClick={() => setShowHistoryModal(false)}
                className="text-white hover:bg-white hover:bg-opacity-20 rounded-full p-2 transition-all"
              >
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>

            {/* Modal Body */}
            <div className="p-6 overflow-y-auto max-h-[calc(90vh-180px)]">
              {selectedHistory && selectedHistory.length > 0 ? (
                <div className="space-y-6">
                  {/* Info Banner */}
                  <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 flex items-start">
                    <div className="text-blue-600 mr-3 mt-0.5">
                      <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                        <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clipRule="evenodd" />
                      </svg>
                    </div>
                    <div>
                      <h3 className="text-blue-900 font-semibold text-sm mb-1">Immutable Blockchain Record</h3>
                      <p className="text-blue-700 text-sm">
                        This history is stored on Hyperledger Fabric and cannot be modified or deleted. 
                        Each transaction is cryptographically secured and verified by the network.
                      </p>
                    </div>
                  </div>

                  {/* Timeline */}
                  <div className="relative">
                    {/* Vertical Line */}
                    <div className="absolute left-8 top-0 bottom-0 w-0.5 bg-gradient-to-b from-purple-400 to-blue-400"></div>

                    {/* Transaction Cards */}
                    <div className="space-y-6">
                      {selectedHistory.map((tx, index) => (
                        <div key={index} className="relative pl-20">
                          {/* Timeline Node */}
                          <div className="absolute left-5 top-4 w-6 h-6 rounded-full bg-gradient-to-br from-purple-500 to-blue-500 border-4 border-white shadow-lg flex items-center justify-center">
                            <span className="text-white text-xs font-bold">{selectedHistory.length - index}</span>
                          </div>

                          {/* Card */}
                          <div className="bg-gradient-to-br from-gray-50 to-white border border-gray-200 rounded-lg shadow-md hover:shadow-lg transition-shadow p-5">
                            {/* Action Header */}
                            <div className="flex items-center justify-between mb-3">
                              <div className="flex items-center space-x-2">
                                <span className="text-2xl">{getActionIcon(tx.action)}</span>
                                <span className={`px-3 py-1 rounded-full text-xs font-bold ${getActionColor(tx.action)}`}>
                                  {tx.action || 'UNKNOWN'}
                                </span>
                              </div>
                              <div className="text-xs text-gray-500">
                                Block #{tx.block_number || 'N/A'}
                              </div>
                            </div>

                            {/* Transaction Details */}
                            <div className="space-y-2 mb-3">
                              <div className="flex items-center text-sm">
                                <span className="text-gray-500 w-24">Organization:</span>
                                <span className="text-gray-900 font-medium">{tx.actor || 'N/A'}</span>
                              </div>
                              <div className="flex items-center text-sm">
                                <span className="text-gray-500 w-24">Timestamp:</span>
                                <span className="text-gray-900">{tx.timestamp ? new Date(tx.timestamp).toLocaleString() : 'N/A'}</span>
                              </div>
                              {tx.data?.note && (
                                <div className="flex items-start text-sm">
                                  <span className="text-gray-500 w-24">Note:</span>
                                  <span className="text-gray-900 flex-1">{tx.data.note}</span>
                                </div>
                              )}
                            </div>

                            {/* Transaction ID Footer */}
                            <div className="border-t border-gray-200 pt-3 mt-3">
                              <div className="flex items-center justify-between">
                                <span className="text-xs text-gray-500">Transaction ID:</span>
                                <code className="text-xs bg-gray-100 px-2 py-1 rounded font-mono text-gray-700">
                                  {tx.tx_id?.substring(0, 16) || 'N/A'}...
                                </code>
                              </div>
                              {tx.data?.status && (
                                <div className="flex items-center justify-between mt-2">
                                  <span className="text-xs text-gray-500">New Status:</span>
                                  <span className={`text-xs px-2 py-1 rounded font-medium ${getStatusColor(tx.data.status)}`}>
                                    {tx.data.status}
                                  </span>
                                </div>
                              )}
                            </div>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              ) : (
                <div className="text-center py-12">
                  <div className="text-gray-400 text-6xl mb-4">📭</div>
                  <h3 className="text-lg font-semibold text-gray-700 mb-2">No History Available</h3>
                  <p className="text-gray-500 text-sm">
                    No blockchain transactions found for this reservation.
                  </p>
                </div>
              )}
            </div>

            {/* Modal Footer */}
            <div className="bg-gray-50 border-t border-gray-200 px-6 py-4 flex justify-between items-center">
              <div className="text-xs text-gray-500 flex items-center">
                <svg className="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                </svg>
                Powered by Hyperledger Fabric v2.5
              </div>
              <button
                onClick={() => setShowHistoryModal(false)}
                className="bg-gradient-to-r from-purple-600 to-blue-600 text-white px-6 py-2 rounded-lg hover:from-purple-700 hover:to-blue-700 transition-all font-medium text-sm shadow-md hover:shadow-lg"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default ReservationsPage