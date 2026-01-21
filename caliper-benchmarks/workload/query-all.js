'use strict';

const { WorkloadModuleBase } = require('@hyperledger/caliper-core');

/**
 * Workload module for querying all hotel reservations
 */
class QueryAllReservationsWorkload extends WorkloadModuleBase {
    constructor() {
        super();
    }

    /**
     * Initialize the workload module
     */
    async initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext) {
        await super.initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext);
    }

    /**
     * Submit transaction for querying all reservations
     */
    async submitTransaction() {
        const request = {
            contractId: 'reservation',
            contractFunction: 'GetAllReservations',
            invokerIdentity: 'User1',
            contractArguments: [],
            readOnly: true
        };

        await this.sutAdapter.sendRequests(request);
    }
}

/**
 * Create a new instance of the workload module
 */
function createWorkloadModule() {
    return new QueryAllReservationsWorkload();
}

module.exports.createWorkloadModule = createWorkloadModule;
