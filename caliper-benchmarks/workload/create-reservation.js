'use strict';

const { WorkloadModuleBase } = require('@hyperledger/caliper-core');

/**
 * Workload module for creating hotel reservations
 */
class CreateReservationWorkload extends WorkloadModuleBase {
    constructor() {
        super();
        this.txIndex = 0;
    }

    /**
     * Initialize the workload module
     */
    async initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext) {
        await super.initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext);
        
        this.hotelID = roundArguments.hotelID || 'HTL001';
        this.roomTypeID = roundArguments.roomTypeID || 'ROOM001';
        this.workerIndex = workerIndex;
    }

    /**
     * Submit transaction for creating a reservation
     */
    async submitTransaction() {
        this.txIndex++;
        
        const reservationID = `RES${this.workerIndex}-${Date.now()}-${this.txIndex}`;
        const now = new Date();
        const checkIn = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000).toISOString().split('T')[0]; // +7 days
        const checkOut = new Date(now.getTime() + 10 * 24 * 60 * 60 * 1000).toISOString().split('T')[0]; // +10 days
        
        const eventTypes = ['wedding', 'conference', 'birthday', 'meeting', 'other'];
        const eventType = eventTypes[Math.floor(Math.random() * eventTypes.length)];
        
        const guestCount = Math.floor(Math.random() * 10) + 1;
        const pricePerPerson = 500000;
        const totalPrice = guestCount * pricePerPerson;

        const request = {
            contractId: 'reservation',
            contractFunction: 'CreateReservation',
            invokerIdentity: 'User1',
            contractArguments: [
                reservationID,
                this.hotelID,
                this.roomTypeID,
                checkIn,
                checkOut,
                guestCount.toString(),
                eventType,
                `Benchmark test ${eventType}`,
                `Customer ${this.txIndex}`,
                `081234567${this.txIndex % 1000}`,
                `customer${this.txIndex}@example.com`,
                `CUST${this.txIndex}`,
                pricePerPerson.toString(),
                totalPrice.toString(),
                'IDR',
                'pending'
            ],
            readOnly: false
        };

        await this.sutAdapter.sendRequests(request);
    }
}

/**
 * Create a new instance of the workload module
 */
function createWorkloadModule() {
    return new CreateReservationWorkload();
}

module.exports.createWorkloadModule = createWorkloadModule;
