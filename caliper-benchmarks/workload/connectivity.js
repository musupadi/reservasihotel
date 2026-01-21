'use strict';

const { WorkloadModuleBase } = require('@hyperledger/caliper-core');

/**
 * Workload sederhana untuk simulate load tanpa chaincode
 */
class ConnectivityWorkload extends WorkloadModuleBase {
    constructor() {
        super();
        this.txIndex = 0;
    }

    async initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext) {
        await super.initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext);
        this.workerIndex = workerIndex;
        this.totalWorkers = totalWorkers;
    }

    async submitTransaction() {
        this.txIndex++;
        
        // Simulate light processing
        const startTime = Date.now();
        await new Promise(resolve => setTimeout(resolve, Math.floor(Math.random() * 5) + 1));
        const endTime = Date.now();
        
        // Return transaction result
        const result = {
            status: 'success',
            txIndex: this.txIndex,
            worker: this.workerIndex,
            latency: endTime - startTime
        };
        
        return result;
    }
}

function createWorkloadModule() {
    return new ConnectivityWorkload();
}

module.exports.createWorkloadModule = createWorkloadModule;
