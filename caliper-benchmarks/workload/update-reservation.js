'use strict';

const { WorkloadModuleBase } = require('@hyperledger/caliper-core');

/**
 * Workload module for updating hotel reservation status
 */
class UpdateReservationWorkload extends WorkloadModuleBase {
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
        
        this.newStatus = roundArguments.newStatus || 'confirmed';
        this.workerIndex = workerIndex;
        
        // Query all reservations to get IDs for updating
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
                console.warn('No reservations found for update workload');
            }
        } catch (error) {
            console.error('Error initializing update workload:', error);
        }
    }

    /**
     * Submit transaction for updating a reservation
     */
    async submitTransaction() {
        if (this.reservationIDs.length === 0) {
            throw new Error('No reservations available to update');
        }

        this.txIndex++;
        
        // Select a random reservation ID
        const reservationID = this.reservationIDs[this.txIndex % this.reservationIDs.length];
        
        const statuses = ['confirmed', 'pending', 'cancelled', 'completed'];
        const status = statuses[this.txIndex % statuses.length];

        const request = {
            contractId: 'reservation',
            contractFunction: 'UpdateReservationStatus',
            invokerIdentity: 'User1',
            contractArguments: [reservationID, status],
            readOnly: false
        };

        await this.sutAdapter.sendRequests(request);
    }
}

/**
 * Create a new instance of the workload module
 */
function createWorkloadModule() {
    return new UpdateReservationWorkload();
}

module.exports.createWorkloadModule = createWorkloadModule;
