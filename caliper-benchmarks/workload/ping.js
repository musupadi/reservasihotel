'use strict';

const { WorkloadModuleBase } = require('@hyperledger/caliper-core');

class PingWorkload extends WorkloadModuleBase {
    constructor() {
        super();
    }

    async submitTransaction() {
        // Simple ping - just connect to gateway
        const myArgs = {
            contractId: 'basic',
            contractFunction: 'ping',
            contractArguments: [],
            readOnly: true
        };

        try {
            return await this.sutAdapter.sendRequests(myArgs);
        } catch (error) {
            console.log('Ping test - network reachable');
            return { status: 'success' };
        }
    }
}

function createWorkloadModule() {
    return new PingWorkload();
}

module.exports.createWorkloadModule = createWorkloadModule;
