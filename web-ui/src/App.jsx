import { Toaster } from 'react-hot-toast';
import {
  BrowserRouter as Router,
  Route,
  Routes,
} from 'react-router-dom';

import Navbar from './components/Navbar';
import BookingPage from './pages/BookingPage';
import HomePage from './pages/HomePage';
import HotelsPage from './pages/HotelsPage';
import ReservationsPage from './pages/ReservationsPage';

function App() {
  return (
    <Router>
      <div className="min-h-screen bg-gray-50">
        <Navbar />
        <main className="container mx-auto px-4 py-8">
          <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path="/hotels" element={<HotelsPage />} />
            <Route path="/hotels/:hotelId/book" element={<BookingPage />} />
            <Route path="/reservations" element={<ReservationsPage />} />
          </Routes>
        </main>
        <Toaster position="top-right" />
      </div>
    </Router>
  )
}

export default App