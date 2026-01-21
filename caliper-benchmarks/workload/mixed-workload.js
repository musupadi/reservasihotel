'use strict';

const { WorkloadModuleBase } = require('@hyperledger/caliper-core');

/**
 * Workload module for mixed operations (create, read, update)
 */
class MixedWorkload extends WorkloadModuleBase {
    constructor() {
        super();
        this.txIndex = 0;
        this.reservationIDs = [];
    }

    /**
     * Initialize the workload module
     */
    async initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext) {
        await super.initializeWorkloadModule(workerIndex, totalWorkers, roundIndex, roundArguments, sutAdapter, sutContext);
        
        this.workerIndex = workerIndex;
        
        // Query existing reservations
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
        } catch (error) {
            console.error('Error initializing mixed workload:', error);
        }
    }

    /**
     * Submit transaction with mixed operations
     */
    async submitTransaction() {
        this.txIndex++;
        
        // 40% Create, 40% Read, 20% Update
        const operation = Math.random();
        
        if (operation < 0.4) {
            // CREATE operation
            await this.createReservation();
        } else if (operation < 0.8) {
            // READ operation
            await this.readReservation();
        } else {
            // UPDATE operation
            await this.updateReservation();
        }
    }

    async createReservation() {
        const reservationID = `RES${this.workerIndex}-${Date.now()}-${this.txIndex}`;
        const now = new Date();
        const checkIn = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000).toISOString().split('T')[0];
        const checkOut = new Date(now.getTime() + 10 * 24 * 60 * 60 * 1000).toISOString().split('T')[0];
        
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
                'HTL001',
                'ROOM001',
                checkIn,
                checkOut,
                guestCount.toString(),
                eventType,
                `Mixed workload ${eventType}`,
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
        this.reservationIDs.push(reservationID);
    }

    async readReservation() {
        if (this.reservationIDs.length > 0) {
            const reservationID = this.reservationIDs[this.txIndex % this.reservationIDs.length];
            
            const request = {
                contractId: 'reservation',
                contractFunction: 'ReadReservation',
                invokerIdentity: 'User1',
                contractArguments: [reservationID],
                readOnly: true
            };

            await this.sutAdapter.sendRequests(request);
        } else {
            // If no reservations, query all
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

    async updateReservation() {
        if (this.reservationIDs.length > 0) {
            const reservationID = this.reservationIDs[this.txIndex % this.reservationIDs.length];
            const statuses = ['confirmed', 'pending', 'cancelled'];
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
}

/**
 * Create a new instance of the workload module
 */
function createWorkloadModule() {
    return new MixedWorkload();
}

module.exports.createWorkloadModule = createWorkloadModule;
