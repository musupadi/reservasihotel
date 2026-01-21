# Caliper Benchmarks

This directory contains Hyperledger Caliper performance benchmarks for the hotel reservation blockchain system.

## Directory Structure

```
caliper-benchmarks/
├── networks/                          # Network configuration files
│   ├── fabric-network.yaml           # Main network config
│   ├── connection-profile-org1.yaml  # Org1 connection profile
│   └── connection-profile-org2.yaml  # Org2 connection profile
├── workload/                         # Workload modules (test scenarios)
│   ├── create-reservation.js         # Create reservation test
│   ├── query-reservation.js          # Query single reservation test
│   ├── query-all.js                  # Query all reservations test
│   ├── update-reservation.js         # Update reservation test
│   └── mixed-workload.js             # Mixed operations test
├── benchmark-config.yaml             # Benchmark configuration
├── package.json                      # NPM dependencies
└── README.md                         # This file
```

## Prerequisites

Before running benchmarks, ensure:

1. **Hyperledger Fabric network is running**
   ```powershell
   # Start the network from reservasihotel/network directory
   cd C:\Blockchain\reservasihotel\network
   docker-compose up -d
   ```

2. **Chaincode is deployed**
   ```powershell
   # Deploy chaincode if not already deployed
   # Follow your network deployment scripts
   ```

3. **Node.js is installed** (v14.19.0 or higher)
   ```powershell
   node --version
   ```

## Installation

1. Install dependencies:
   ```powershell
   cd C:\Blockchain\reservasihotel\caliper-benchmarks
   npm install
   ```

2. Bind Caliper to Fabric 2.2:
   ```powershell
   npm run bind
   ```

## Running Benchmarks

### Run All Tests
```powershell
npm run benchmark
```

### Run Specific Round
You can modify `benchmark-config.yaml` to run specific rounds by commenting out others.

## Benchmark Rounds

1. **create-reservation**: Tests write performance (100 tx at 10 TPS)
2. **query-reservation**: Tests read performance for single record (200 tx at 20 TPS)
3. **query-all-reservations**: Tests complex read operations (50 tx at 5 TPS)
4. **update-reservation**: Tests update performance (100 tx at 10 TPS)
5. **mixed-workload**: Real-world scenario with 40% create, 40% read, 20% update (150 tx at 15 TPS)
6. **stress-test**: High load test (500 tx at 50 TPS)

## Understanding Results

After running benchmarks, Caliper generates an HTML report with:

- **TPS (Transactions Per Second)**: Throughput of the network
- **Latency**: 
  - Min/Max: Fastest and slowest transaction times
  - Avg: Average transaction time
  - Percentiles (50th, 75th, 95th, 99th): Distribution of transaction times
- **Throughput**: Number of successful transactions
- **Success Rate**: Percentage of successful transactions
- **Resource Utilization**: CPU, memory, network usage of Docker containers

## Customization

### Modify Transaction Rate

Edit `benchmark-config.yaml`:
```yaml
rateControl:
  type: fixed-rate
  opts:
    tps: 20  # Change this value
```

### Add New Test Scenarios

1. Create new workload file in `workload/` directory
2. Add new round in `benchmark-config.yaml`:
   ```yaml
   - label: my-custom-test
     description: My custom test description
     txNumber: 100
     rateControl:
       type: fixed-rate
       opts:
         tps: 10
     workload:
       module: workload/my-custom-test.js
   ```

## Monitoring

The benchmark monitors Docker containers:
- peer0.org1.example.com
- peer0.org2.example.com
- orderer.example.com
- couchdb0
- couchdb1

Make sure these containers are running before starting benchmarks.

## Troubleshooting

### Error: Cannot find module '@hyperledger/caliper-core'
```powershell
npm install
npm run bind
```

### Error: Network configuration not found
Check that your Fabric network is running and crypto materials exist in the specified paths in `networks/fabric-network.yaml`.

### Error: Connection timeout
Increase timeout values in `networks/connection-profile-org1.yaml`:
```yaml
connection:
  timeout:
    peer:
      endorser: '600'  # Increase from 300
```

### Low TPS Results
- Check Docker container resources
- Ensure no other heavy processes are running
- Try reducing concurrent workers in `benchmark-config.yaml`

## Report Location

After benchmark completes, find the HTML report at:
```
caliper-benchmarks/report.html
```

Open in browser to view detailed metrics and charts.

## Notes

- Benchmarks should be run on a clean network state for consistent results
- For production-like benchmarks, use separate machines for Caliper and Fabric nodes
- Results vary based on hardware specifications
- Run multiple iterations and average the results for more accurate measurements

## Additional Resources

- [Hyperledger Caliper Documentation](https://hyperledger.github.io/caliper/)
- [Fabric Performance Tuning](https://hyperledger-fabric.readthedocs.io/en/latest/performance.html)
