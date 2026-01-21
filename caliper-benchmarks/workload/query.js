'use strict';

const { WorkloadModuleBase } = require('@hyperledger/caliper-core');

class QueryWorkload extends WorkloadModuleBase {
    constructor() {
        super();
    }

    async submitTransaction() {
        const myArgs = {
            contractId: 'basic',
            contractFunction: 'GetAllAssets',
            contractArguments: [],
            readOnly: true
        };

        return this.sutAdapter.sendRequests(myArgs);
    }
}

function createWorkloadModule() {
    return new QueryWorkload();
}

module.exports.createWorkloadModule = createWorkloadModule;
