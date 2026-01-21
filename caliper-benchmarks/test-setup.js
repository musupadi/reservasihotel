#!/usr/bin/env node
'use strict';

/**
 * Test script to verify Caliper setup
 */

console.log('\n🔍 Testing Hyperledger Caliper Setup...\n');

let allTestsPassed = true;

// Test 1: Check Node.js version
console.log('1️⃣  Checking Node.js version...');
const nodeVersion = process.version;
const nodeMajorVersion = parseInt(nodeVersion.split('.')[0].substring(1));
if (nodeMajorVersion >= 14) {
    console.log(`   ✅ Node.js ${nodeVersion} (OK)\n`);
} else {
    console.log(`   ❌ Node.js ${nodeVersion} (Need >= 14.x)\n`);
    allTestsPassed = false;
}

// Test 2: Check Caliper Core
console.log('2️⃣  Checking @hyperledger/caliper-core...');
try {
    const caliperCore = require('@hyperledger/caliper-core');
    console.log('   ✅ Caliper Core installed\n');
} catch (error) {
    console.log('   ❌ Caliper Core NOT installed\n');
    allTestsPassed = false;
}

// Test 3: Check Caliper Fabric
console.log('3️⃣  Checking @hyperledger/caliper-fabric...');
try {
    const caliperFabric = require('@hyperledger/caliper-fabric');
    console.log('   ✅ Caliper Fabric installed\n');
} catch (error) {
    console.log('   ❌ Caliper Fabric NOT installed\n');
    allTestsPassed = false;
}

// Test 4: Check Fabric SDK (fabric-network)
console.log('4️⃣  Checking fabric-network SDK...');
try {
    const fabricNetwork = require('fabric-network');
    console.log('   ✅ Fabric Network SDK installed\n');
} catch (error) {
    console.log('   ❌ Fabric Network SDK NOT installed');
    console.log('   💡 Run: npm run bind\n');
    allTestsPassed = false;
}

// Test 5: Check Fabric Common
console.log('5️⃣  Checking fabric-common...');
try {
    const fabricCommon = require('fabric-common');
    console.log('   ✅ Fabric Common installed\n');
} catch (error) {
    console.log('   ❌ Fabric Common NOT installed');
    console.log('   💡 Run: npm run bind\n');
    allTestsPassed = false;
}

// Test 6: Check config files
console.log('6️⃣  Checking configuration files...');
const fs = require('fs');
const path = require('path');

const requiredFiles = [
    'networks/fabric-network.yaml',
    'benchmark-config.yaml',
    'workload/create-reservation.js',
    'workload/query-reservation.js',
    'workload/query-all.js',
    'workload/update-reservation.js',
    'workload/mixed-workload.js'
];

let allFilesExist = true;
for (const file of requiredFiles) {
    const filePath = path.join(__dirname, file);
    if (fs.existsSync(filePath)) {
        console.log(`   ✅ ${file}`);
    } else {
        console.log(`   ❌ ${file} NOT FOUND`);
        allFilesExist = false;
        allTestsPassed = false;
    }
}
console.log('');

// Test 7: Check network crypto materials path
console.log('7️⃣  Checking Fabric network crypto materials...');
const cryptoBasePath = path.join(__dirname, '..', 'network', 'organizations');
if (fs.existsSync(cryptoBasePath)) {
    console.log('   ✅ Network crypto materials directory exists\n');
} else {
    console.log('   ⚠️  Network crypto materials NOT found');
    console.log('   💡 Make sure Fabric network is set up first\n');
}

// Summary
console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
if (allTestsPassed) {
    console.log('✅ ALL TESTS PASSED!');
    console.log('🚀 Ready to run benchmarks: npm run benchmark');
} else {
    console.log('❌ SOME TESTS FAILED');
    console.log('📝 Follow the suggestions above to fix issues');
}
console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

process.exit(allTestsPassed ? 0 : 1);
