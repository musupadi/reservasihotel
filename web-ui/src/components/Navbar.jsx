import {
  Link,
  useLocation,
} from 'react-router-dom';

const Navbar = () => {
  const location = useLocation()

  const isActive = (path) => {
    return location.pathname === path
  }

  return (
    <nav className="bg-white shadow-lg">
      <div className="container mx-auto px-4">
        <div className="flex justify-between items-center py-4">
          <Link to="/" className="text-2xl font-bold text-primary-600">
            Hotel Reservation
          </Link>
          
          <div className="flex space-x-6">
            <Link
              to="/"
              className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                isActive('/') 
                  ? 'bg-primary-100 text-primary-700' 
                  : 'text-gray-700 hover:text-primary-600 hover:bg-gray-100'
              }`}
            >
              Home
            </Link>
            <Link
              to="/hotels"
              className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                isActive('/hotels') 
                  ? 'bg-primary-100 text-primary-700' 
                  : 'text-gray-700 hover:text-primary-600 hover:bg-gray-100'
              }`}
            >
              Hotels
            </Link>
            <Link
              to="/reservations"
              className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                isActive('/reservations') 
                  ? 'bg-primary-100 text-primary-700' 
                  : 'text-gray-700 hover:text-primary-600 hover:bg-gray-100'
              }`}
            >
              Reservations
            </Link>
          </div>
        </div>
      </div>
    </nav>
  )
}

export default Navbar