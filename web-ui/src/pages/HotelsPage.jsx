import {
  useEffect,
  useState,
} from 'react';

import toast from 'react-hot-toast';
import { Link } from 'react-router-dom';

import { hotelService } from '../services/api';

const HotelsPage = () => {
  const [hotels, setHotels] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchHotels()
  }, [])

  const fetchHotels = async () => {
    try {
      const response = await hotelService.getAllHotels()
      setHotels(response.data.hotels)
    } catch (error) {
      toast.error('Failed to fetch hotels')
      console.error(error)
    } finally {
      setLoading(false)
    }
  }

  const renderStars = (rating) => {
    return Array.from({ length: 5 }, (_, index) => (
      <span
        key={index}
        className={`text-lg ${index < rating ? 'text-yellow-400' : 'text-gray-300'}`}
      >
        ★
      </span>
    ))
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
        <h1 className="text-3xl font-bold text-gray-900 mb-2">Available Hotels</h1>
        <p className="text-gray-600">Choose from our selection of premium hotels</p>
      </div>

      <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
        {hotels.map((hotel) => (
          <div key={hotel.id} className="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow">
            <img
              src={hotel.image_url}
              alt={hotel.name}
              className="w-full h-48 object-cover"
            />
            <div className="p-6">
              <div className="flex justify-between items-start mb-2">
                <h3 className="text-xl font-semibold text-gray-900">{hotel.name}</h3>
                <div className="flex">{renderStars(hotel.rating)}</div>
              </div>
              
              <p className="text-gray-600 mb-2">
                {hotel.city}, {hotel.country}
              </p>
              
              <p className="text-gray-700 mb-4 text-sm line-clamp-2">
                {hotel.description}
              </p>
              
              <div className="flex justify-between items-center">
                <span className="text-sm text-gray-500">{hotel.address}</span>
                <Link
                  to={`/hotels/${hotel.id}/book`}
                  className="bg-primary-600 text-white px-4 py-2 rounded-md hover:bg-primary-700 transition-colors"
                >
                  Book Now
                </Link>
              </div>
            </div>
          </div>
        ))}
      </div>

      {hotels.length === 0 && (
        <div className="text-center py-12">
          <div className="text-gray-500 text-lg">No hotels available at the moment.</div>
        </div>
      )}
    </div>
  )
}

export default HotelsPage