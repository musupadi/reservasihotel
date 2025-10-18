import {
  useEffect,
  useState,
} from 'react';

import { Link } from 'react-router-dom';

import { blockchainService } from '../services/api';

const HomePage = () => {
  const [blockchainStatus, setBlockchainStatus] = useState(null);
  const [healthCheck, setHealthCheck] = useState(null);

  useEffect(() => {
    const fetchStatus = async () => {
      try {
        // Get blockchain stats
        const statsResponse = await blockchainService.getStats();
        setBlockchainStatus(statsResponse.data);

        // Get health check
        const healthResponse = await blockchainService.getHealthCheck();
        setHealthCheck(healthResponse.data);
      } catch (error) {
        console.log('Failed to fetch status:', error);
      }
    };

    fetchStatus();
    // Refresh every 10 seconds
    const interval = setInterval(fetchStatus, 10000);
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="max-w-6xl mx-auto">
      {/* Backend Status Banner */}
      {healthCheck && (
        <div className={`rounded-lg p-4 mb-6 ${
          healthCheck.status === 'running' 
            ? 'bg-green-100 border border-green-300' 
            : 'bg-yellow-100 border border-yellow-300'
        }`}>
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <div className={`w-3 h-3 rounded-full ${
                healthCheck.status === 'running' ? 'bg-green-500' : 'bg-yellow-500'
              }`}></div>
              <span className="font-semibold">
                Backend Status: {healthCheck.status === 'running' ? 'Online' : 'Offline'}
              </span>
              {healthCheck.blockchain && (
                <span className="text-sm text-gray-600">
                  | {healthCheck.blockchain}
                </span>
              )}
              {healthCheck.fabric_enabled !== undefined && (
                <span className={`text-sm px-2 py-1 rounded ${
                  healthCheck.fabric_enabled 
                    ? 'bg-blue-100 text-blue-800' 
                    : 'bg-gray-100 text-gray-800'
                }`}>
                  {healthCheck.fabric_enabled ? 'Hyperledger Fabric' : 'Local Simulation'}
                </span>
              )}
            </div>
            <div className="text-sm text-gray-600">
              Database: {healthCheck.database || 'Unknown'}
            </div>
          </div>
        </div>
      )}

      {/* Hero Section */}
      <div className="text-center py-20">
        <h1 className="text-5xl font-bold text-gray-900 mb-6">
          Hotel Reservation System
        </h1>
        <p className="text-xl text-gray-600 mb-8 max-w-3xl mx-auto">
          Experience seamless hotel booking powered by Hyperledger Fabric blockchain technology. 
          Secure, transparent, and efficient reservations for modern travelers.
        </p>
        <div className="space-x-4">
          <Link
            to="/hotels"
            className="inline-block bg-primary-600 text-white px-8 py-3 rounded-lg text-lg font-semibold hover:bg-primary-700 transition-colors"
          >
            Browse Hotels
          </Link>
          <Link
            to="/reservations"
            className="inline-block border-2 border-primary-600 text-primary-600 px-8 py-3 rounded-lg text-lg font-semibold hover:bg-primary-50 transition-colors"
          >
            View Reservations
          </Link>
        </div>
      </div>

      {/* Features Section */}
      <div className="grid md:grid-cols-3 gap-8 py-16">
        <div className="text-center p-6">
          <div className="w-16 h-16 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <svg className="w-8 h-8 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <h3 className="text-xl font-semibold mb-2">Blockchain Security</h3>
          <p className="text-gray-600">All reservations are secured and transparent using Hyperledger Fabric technology.</p>
        </div>

        <div className="text-center p-6">
          <div className="w-16 h-16 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <svg className="w-8 h-8 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 10V3L4 14h7v7l9-11h-7z" />
            </svg>
          </div>
          <h3 className="text-xl font-semibold mb-2">Fast Booking</h3>
          <p className="text-gray-600">Quick and efficient booking process with real-time availability checking.</p>
        </div>

        <div className="text-center p-6">
          <div className="w-16 h-16 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <svg className="w-8 h-8 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
            </svg>
          </div>
          <h3 className="text-xl font-semibold mb-2">Multi-Org Network</h3>
          <p className="text-gray-600">Collaborative ecosystem with Hotels, OTAs, and Payment providers.</p>
        </div>
      </div>

      {/* Blockchain Status Section */}
      {blockchainStatus && (
        <div className="bg-gray-50 rounded-xl p-8 mb-8">
          <h2 className="text-2xl font-bold text-center mb-6">Blockchain Network Status</h2>
          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
            <div className="text-center p-4 bg-white rounded-lg shadow">
              <div className="text-2xl font-bold text-primary-600 mb-2">
                {blockchainStatus.type || 'Unknown'}
              </div>
              <div className="text-sm text-gray-600">Blockchain Type</div>
            </div>
            {blockchainStatus.blockchain && (
              <>
                <div className="text-center p-4 bg-white rounded-lg shadow">
                  <div className="text-2xl font-bold text-green-600 mb-2">
                    {blockchainStatus.blockchain.block_height || 0}
                  </div>
                  <div className="text-sm text-gray-600">Block Height</div>
                </div>
                <div className="text-center p-4 bg-white rounded-lg shadow">
                  <div className="text-2xl font-bold text-blue-600 mb-2">
                    {blockchainStatus.blockchain.transactions || 0}
                  </div>
                  <div className="text-sm text-gray-600">Total Transactions</div>
                </div>
                <div className="text-center p-4 bg-white rounded-lg shadow">
                  <div className="text-2xl font-bold text-purple-600 mb-2">
                    {blockchainStatus.blockchain.network_status || 'Unknown'}
                  </div>
                  <div className="text-sm text-gray-600">Network Status</div>
                </div>
              </>
            )}
          </div>
          
          {blockchainStatus.blockchain && blockchainStatus.blockchain.peers && (
            <div className="mt-6">
              <h3 className="text-lg font-semibold mb-3">Connected Peers:</h3>
              <div className="flex flex-wrap gap-2">
                {blockchainStatus.blockchain.peers.map((peer, index) => (
                  <span key={index} className="px-3 py-1 bg-green-100 text-green-800 rounded-full text-sm">
                    {peer}
                  </span>
                ))}
              </div>
            </div>
          )}
        </div>
      )}

      {/* Stats Section */}
      <div className="bg-primary-600 text-white rounded-xl p-8 text-center">
        <div className="grid md:grid-cols-3 gap-8">
          <div>
            <div className="text-3xl font-bold mb-2">3</div>
            <div className="text-primary-100">Partner Organizations</div>
          </div>
          <div>
            <div className="text-3xl font-bold mb-2">24/7</div>
            <div className="text-primary-100">Service Availability</div>
          </div>
          <div>
            <div className="text-3xl font-bold mb-2">100%</div>
            <div className="text-primary-100">Blockchain Secured</div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default HomePage