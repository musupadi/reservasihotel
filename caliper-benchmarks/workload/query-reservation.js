'use strict';

const { WorkloadModuleBase } = require('@hyperledger/caliper-core');

/**
 * Workload module for querying hotel reservations by ID
 */
class QueryReservationWorkload extends WorkloadModuleBase {
    constructor() {
        super();
        this.reservationIDs = [];
        this.txIndex = 0;
    }

    /**
     * Initialize the workload module
     */
    async initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext) {
        await super.initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext);
        
        this.workerIndex = workerIndex;
        
        // Query all reservations first to get IDs for testing
        try {
            const request = {
                contractId: 'reservation',
                contractFunction: 'GetAllReservations',
                invokerIdentity: 'User1',
                contractArguments: [],
                readOnly: true
            };

            const response = await this.sutAdapter.sendRequests(request);
            const result = response.status.result;
            
            if (result && typeof result === 'string') {
                const reservations = JSON.parse(result);
                this.reservationIDs = reservations.map(r => r.reservationID);
            }

            if (this.reservationIDs.length === 0) {
                console.warn('No reservations found. Creating sample data...');
                // If no reservations exist, create some dummy IDs
                for (let i = 0; i < 10; i++) {
                    this.reservationIDs.push(`RES${workerIndex}-${Date.now()}-${i}`);
                }
            }
        } catch (error) {
            console.error('Error initializing query workload:', error);
            // Fallback to dummy IDs
            for (let i = 0; i < 10; i++) {
                this.reservationIDs.push(`RES${workerIndex}-${Date.now()}-${i}`);
            }
        }
    }

    /**
     * Submit transaction for querying a reservation
     */
    async submitTransaction() {
        this.txIndex++;
        
        // Select a random reservation ID
        const reservationID = this.reservationIDs[this.txIndex % this.reservationIDs.length];

        const request = {
            contractId: 'reservation',
            contractFunction: 'ReadReservation',
            invokerIdentity: 'User1',
            contractArguments: [reservationID],
            readOnly: true
        };

        await this.sutAdapter.sendRequests(request);
    }
}

/**
 * Create a new instance of the workload module
 */
function createWorkloadModule() {
    return new QueryReservationWorkload();
}

module.exports.createWorkloadModule = createWorkloadModule;
