# Use Case Specification - Hotel Reservation System

**Project:** Hotel Reservation System with Blockchain  
**Version:** 1.0  
**Date:** December 6, 2025  
**Author:** System Analyst

---

## Table of Contents
1. [UC-01: Login](#uc-01-login)
2. [UC-02: Browse Hotels](#uc-02-browse-hotels)
3. [UC-03: Create Reservation](#uc-03-create-reservation)
4. [UC-04: View My Bookings](#uc-04-view-my-bookings)
5. [UC-05: Cancel Booking](#uc-05-cancel-booking)
6. [UC-06: Confirm Reservation](#uc-06-confirm-reservation)
7. [UC-07: Check-In](#uc-07-check-in)
8. [UC-08: Check-Out](#uc-08-check-out)
9. [UC-09: View All Reservations](#uc-09-view-all-reservations)
10. [UC-10: View Audit Trail](#uc-10-view-audit-trail)
11. [UC-11: Store Transaction](#uc-11-store-transaction)
12. [UC-12: Verify Data](#uc-12-verify-data)
13. [UC-13: Query Ledger](#uc-13-query-ledger)

---

## UC-01: Login

### Brief Description
User authenticates to access the system.

### Actors
- **Primary:** Guest, Hotel Staff
- **Secondary:** Database System

### Preconditions
- User has registered account
- System is online

### Basic Flow
1. User navigates to login page
2. System displays login form
3. User enters email and password
4. System validates credentials
5. System authenticates user via JWT token
6. System redirects to appropriate dashboard based on role
7. System logs login activity

### Alternative Flows
**3a. User forgot password**
- System provides password reset link
- User receives email with reset token
- User creates new password

**4a. Invalid credentials**
- System displays error message
- User can retry login
- After 3 failed attempts, account temporarily locked

### Postconditions
- User is authenticated
- Session token is created
- User can access protected features

### Special Requirements
- Password must be hashed (bcrypt)
- JWT token expires after 24 hours
- HTTPS required for security

### Business Rules
- Maximum 3 login attempts before lockout
- Account locked for 15 minutes after failed attempts

---

## UC-02: Browse Hotels

### Brief Description
User views available hotels and their information.

### Actors
- **Primary:** Guest
- **Secondary:** Database System

### Preconditions
- User accesses the system (login not required)

### Basic Flow
1. User navigates to hotels page
2. System retrieves hotel list from database
3. System displays hotels with:
   - Hotel name
   - Location (city)
   - Rating
   - Image
   - Description
4. User can view hotel details

### Alternative Flows
**2a. Apply filters**
- User selects city filter
- System filters hotels by selected city
- System displays filtered results

**2b. Search hotels**
- User enters search keyword
- System searches by hotel name or city
- System displays matching results

### Postconditions
- Hotel list is displayed
- User can proceed to view room types

### Special Requirements
- Response time < 2 seconds
- Support pagination for large datasets
- Mobile responsive design

### Business Rules
- Only active hotels are displayed
- Hotels sorted by rating (highest first) by default

---

## UC-03: Create Reservation

### Brief Description
Guest creates a new hotel reservation for an event.

### Actors
- **Primary:** Guest
- **Secondary:** Database System, Blockchain System

### Preconditions
- User is logged in
- Hotel and room type are available
- Selected dates are valid

### Basic Flow
1. User selects hotel
2. System displays available room types
3. User fills reservation form:
   - Check-in date
   - Check-out date
   - Guest count
   - Event type (Meeting, Seminar, Birthday, etc.)
   - Event description
   - Customer name
   - Phone number
   - Email
4. System calculates total price (price_per_person × guest_count)
5. User reviews reservation details
6. User confirms reservation
7. System generates unique Reservation ID
8. System saves to MySQL database
9. **System automatically stores transaction to blockchain** *(include UC-11)*
10. System sends confirmation email
11. System displays success message with reservation ID

### Alternative Flows
**3a. Invalid dates**
- System validates check-in is before check-out
- System validates dates are not in the past
- System displays error message

**4a. Room not available**
- System checks room availability
- System displays "Room not available" message
- User can select different dates or room type

**9a. Blockchain storage fails**
- System saves to database successfully
- System logs blockchain error
- System marks reservation for manual blockchain sync
- User still sees success message (degraded mode)

### Postconditions
- Reservation created with status "PENDING"
- Record stored in database
- Transaction stored in blockchain ledger
- Customer receives confirmation email
- Reservation ID generated

### Special Requirements
- Reservation ID format: RES-YYYYMMDD-XXXX
- Email notification sent within 30 seconds
- Blockchain storage must complete within 5 seconds

### Business Rules
- Minimum guest count: 10 persons
- Maximum guest count: 500 persons
- Check-in date must be at least 1 day in future
- Reservation expires if not confirmed within 24 hours

---

## UC-04: View My Bookings

### Brief Description
Guest views their reservation history.

### Actors
- **Primary:** Guest
- **Secondary:** Database System

### Preconditions
- User is logged in as Guest

### Basic Flow
1. User navigates to "My Bookings" page
2. System retrieves user's reservations from database
3. System displays list with:
   - Reservation ID
   - Hotel name
   - Check-in/Check-out dates
   - Guest count
   - Event type
   - Total price
   - Status (PENDING, CONFIRMED, CHECKED_IN, CHECKED_OUT, CANCELLED)
4. User can view reservation details
5. User can click to view full details

### Alternative Flows
**3a. Filter by status**
- User selects status filter
- System filters reservations
- System displays filtered results

**3b. No reservations found**
- System displays "No bookings yet" message
- System provides link to browse hotels

### Postconditions
- User sees their reservation history
- Status is clearly displayed

### Special Requirements
- Real-time status updates
- Sort by date (most recent first)

### Business Rules
- Only show user's own reservations
- Display last 50 reservations by default

---

## UC-05: Cancel Booking

### Brief Description
Guest cancels an existing reservation.

### Actors
- **Primary:** Guest
- **Secondary:** Database System, Blockchain System

### Preconditions
- User is logged in
- Reservation exists
- Reservation status is PENDING or CONFIRMED
- Cancellation is within allowed timeframe

### Basic Flow
1. User views reservation details
2. User clicks "Cancel Booking" button
3. System displays cancellation confirmation dialog
4. User confirms cancellation
5. System validates cancellation eligibility
6. System updates status to "CANCELLED" in database
7. **System automatically stores cancellation to blockchain** *(include UC-11)*
8. System sends cancellation notification email
9. System displays success message

### Alternative Flows
**5a. Cancellation not allowed**
- Check-in date is within 24 hours
- System displays error message
- Cancellation rejected

**5b. Reservation already checked-in**
- System displays "Cannot cancel checked-in reservation"
- User must contact hotel staff

**7a. Blockchain storage fails**
- System updates database successfully
- System logs blockchain error
- System marks for manual sync
- User sees success message

### Postconditions
- Reservation status changed to CANCELLED
- Cancellation recorded in database
- Cancellation stored in blockchain
- Email notification sent
- Room availability updated

### Special Requirements
- Confirmation dialog to prevent accidental cancellation
- Email sent within 30 seconds

### Business Rules
- Free cancellation up to 48 hours before check-in
- Cancellation within 24-48 hours: 50% charge
- Cancellation within 24 hours: Not allowed
- Cancelled reservations cannot be reactivated

---

## UC-06: Confirm Reservation

### Brief Description
Hotel staff confirms a pending reservation.

### Actors
- **Primary:** Hotel Staff
- **Secondary:** Database System, Blockchain System

### Preconditions
- Staff is logged in
- Reservation exists with status PENDING
- Room is available

### Basic Flow
1. Staff views pending reservations
2. Staff selects a reservation
3. System displays reservation details
4. Staff verifies availability
5. Staff clicks "Confirm Reservation"
6. System validates room availability
7. System updates status to "CONFIRMED" in database
8. **System automatically stores confirmation to blockchain** *(include UC-11)*
9. System decrements available rooms
10. System sends confirmation email to customer
11. System displays success message

### Alternative Flows
**6a. Room no longer available**
- System displays error message
- Staff can reject reservation
- System sends apology email to customer

**8a. Blockchain storage fails**
- System updates database successfully
- System logs error for manual intervention
- Staff sees warning but confirmation succeeds

### Postconditions
- Reservation status changed to CONFIRMED
- Confirmation recorded in database and blockchain
- Customer receives confirmation email
- Room availability updated

### Special Requirements
- Staff must verify payment (if required)
- Email notification automatic

### Business Rules
- Only PENDING reservations can be confirmed
- Confirmation must be done within 24 hours of creation
- Unconfirmed reservations auto-expire after 24 hours

---

## UC-07: Check-In

### Brief Description
Hotel staff checks in a guest with confirmed reservation.

### Actors
- **Primary:** Hotel Staff
- **Secondary:** Database System, Blockchain System

### Preconditions
- Staff is logged in
- Reservation exists with status CONFIRMED
- Check-in date is today or past

### Basic Flow
1. Staff searches reservation by ID or customer name
2. System displays reservation details
3. Staff verifies customer identity
4. Staff clicks "Check-In"
5. System validates check-in eligibility
6. System updates status to "CHECKED_IN" in database
7. **System automatically stores check-in to blockchain** *(include UC-11)*
8. System records check-in timestamp
9. System displays success message

### Alternative Flows
**5a. Check-in too early**
- Check-in date is in future
- System displays error message
- Check-in rejected

**5b. Reservation already checked-in**
- System displays "Already checked-in" message
- Staff can view check-in details

**5c. Reservation not confirmed**
- System displays "Reservation not confirmed" error
- Staff must confirm first *(include UC-06)*

### Postconditions
- Reservation status changed to CHECKED_IN
- Check-in timestamp recorded
- Check-in stored in blockchain
- Guest can access room/facilities

### Special Requirements
- Check-in time recorded with timezone
- Mobile check-in option available

### Business Rules
- Check-in allowed on check-in date or after
- Early check-in allowed with staff approval
- Cannot check-in cancelled reservations

---

## UC-08: Check-Out

### Brief Description
Hotel staff checks out a guest.

### Actors
- **Primary:** Hotel Staff
- **Secondary:** Database System, Blockchain System

### Preconditions
- Staff is logged in
- Reservation exists with status CHECKED_IN
- Guest is ready to check-out

### Basic Flow
1. Staff searches reservation by room number or customer name
2. System displays reservation details
3. Staff verifies no pending charges
4. Staff clicks "Check-Out"
5. System updates status to "CHECKED_OUT" in database
6. **System automatically stores check-out to blockchain** *(include UC-11)*
7. System records check-out timestamp
8. System increments available rooms
9. System displays success message

### Alternative Flows
**3a. Pending charges exist**
- System displays charges summary
- Staff processes payment
- Staff proceeds with check-out

**4a. Early check-out**
- Check-out before check-out date
- Staff confirms early check-out
- System proceeds normally

### Postconditions
- Reservation status changed to CHECKED_OUT
- Check-out timestamp recorded
- Check-out stored in blockchain
- Room marked as available
- Reservation cycle completed

### Special Requirements
- Check-out time recorded
- Final bill generated (if applicable)

### Business Rules
- Late check-out may incur additional charges
- Cannot check-out without checking-in first
- Check-out timestamp immutable in blockchain

---

## UC-09: View All Reservations

### Brief Description
Hotel staff views all reservations for their hotel.

### Actors
- **Primary:** Hotel Staff
- **Secondary:** Database System

### Preconditions
- Staff is logged in
- Staff assigned to specific hotel

### Basic Flow
1. Staff navigates to "Reservations" page
2. System retrieves all reservations for staff's hotel
3. System displays reservations with:
   - Reservation ID
   - Customer name
   - Check-in/Check-out dates
   - Guest count
   - Status
   - Created date
4. Staff can filter by:
   - Status
   - Date range
   - Customer name
5. Staff can sort by date, status, or customer

### Alternative Flows
**2a. Filter by date range**
- Staff selects start and end date
- System filters reservations
- System displays filtered results

**2b. Search by customer**
- Staff enters customer name
- System searches reservations
- System displays matching results

### Postconditions
- Staff views comprehensive reservation list
- Staff can take action on reservations

### Special Requirements
- Real-time updates
- Export to Excel/PDF
- Pagination for large datasets

### Business Rules
- Staff only sees their hotel's reservations
- Show 30 days of reservations by default
- Admin can view all hotels

---

## UC-10: View Audit Trail

### Brief Description
Hotel staff views complete history of a reservation from blockchain.

### Actors
- **Primary:** Hotel Staff
- **Secondary:** Blockchain System

### Preconditions
- Staff is logged in
- Reservation exists
- Blockchain data available

### Basic Flow
1. Staff views reservation details
2. Staff clicks "View Audit Trail"
3. **System queries blockchain ledger** *(include UC-13)*
4. System retrieves complete transaction history
5. System displays chronological audit trail:
   - Transaction ID
   - Action (CREATED, CONFIRMED, CHECKED_IN, CHECKED_OUT, CANCELLED)
   - Timestamp
   - Performed by (user/organization)
   - Previous status
   - New status
   - Additional notes
6. Staff can view transaction details

### Alternative Flows
**3a. Blockchain unavailable**
- System displays cached audit trail from database
- System shows warning "Blockchain offline"

**4a. No blockchain records found**
- System displays "No audit trail available"
- System shows database history as fallback

### Postconditions
- Complete immutable history displayed
- Staff can verify all actions
- Transparency and accountability ensured

### Special Requirements
- Read-only view (no modifications)
- Export audit trail to PDF
- Highlight suspicious activities

### Business Rules
- Audit trail is immutable
- All status changes recorded
- Timestamps in UTC with local conversion
- Blockchain as source of truth

---

## UC-11: Store Transaction

### Brief Description
System automatically stores reservation transaction to blockchain ledger.

### Actors
- **Primary:** Blockchain System
- **Secondary:** Hyperledger Fabric Network, Database System

### Preconditions
- Valid transaction data exists
- Blockchain network is online
- Chaincode deployed

### Basic Flow
1. System receives transaction from application
2. System validates transaction data:
   - Reservation ID
   - Hotel ID
   - Action type
   - Status
   - Timestamp
   - Customer data
3. System creates blockchain transaction object
4. System invokes Hyperledger Fabric chaincode
5. Chaincode validates transaction
6. Fabric consensus mechanism approves transaction
7. Transaction added to blockchain
8. System receives transaction ID
9. System updates database with blockchain reference
10. System returns success confirmation

### Alternative Flows
**2a. Invalid transaction data**
- System logs validation error
- System returns error to application
- Database rollback initiated

**4a. Blockchain network unavailable**
- System logs transaction to queue
- System continues with database operation
- Transaction auto-synced when blockchain available

**6a. Consensus fails**
- System retries transaction (max 3 attempts)
- If failed, logs to manual intervention queue
- Database operation still succeeds

### Postconditions
- Transaction permanently stored in blockchain
- Transaction ID recorded in database
- Immutable audit trail created
- Data integrity ensured

### Special Requirements
- Transaction must complete within 5 seconds
- Automatic retry mechanism
- Queue for offline transactions
- Real-time synchronization

### Business Rules
- All reservation actions stored automatically
- No manual blockchain writes allowed
- Transaction cannot be deleted or modified
- MSP ID recorded for accountability

---

## UC-12: Verify Data

### Brief Description
System verifies data integrity between database and blockchain.

### Actors
- **Primary:** Blockchain System
- **Secondary:** Database System, Hyperledger Fabric

### Preconditions
- Reservation exists in both database and blockchain
- User requests verification

### Basic Flow
1. System retrieves reservation from database
2. System queries blockchain for same reservation
3. System compares:
   - Reservation ID
   - Status history
   - Timestamps
   - Customer data
   - Transaction sequence
4. System validates data consistency
5. System returns verification result

### Alternative Flows
**3a. Data mismatch detected**
- System highlights discrepancies
- System logs security alert
- System notifies administrator
- Manual reconciliation required

**3b. Missing blockchain record**
- System marks reservation for sync
- System attempts to recreate blockchain record
- System logs incident

### Postconditions
- Data integrity verified
- Discrepancies identified (if any)
- Security audit trail updated

### Special Requirements
- Scheduled automatic verification
- Real-time verification on request
- Alert system for mismatches

### Business Rules
- Blockchain is source of truth for disputes
- Critical discrepancies require manual review
- Verification log maintained

---

## UC-13: Query Ledger

### Brief Description
System queries blockchain ledger for reservation history and audit trail.

### Actors
- **Primary:** Blockchain System
- **Secondary:** Hyperledger Fabric Network

### Preconditions
- Blockchain network is online
- Valid query parameters provided
- User has permission to query

### Basic Flow
1. System receives query request with Reservation ID
2. System connects to Hyperledger Fabric network
3. System invokes chaincode query function
4. Chaincode retrieves history from ledger using GetHistoryForKey
5. Chaincode returns all transactions for reservation
6. System parses blockchain response
7. System formats data for display:
   - Transaction ID
   - Timestamp
   - Action performed
   - Status changes
   - User/Organization
8. System returns formatted history

### Alternative Flows
**2a. Blockchain unavailable**
- System returns cached data from database
- System displays warning message
- System retries connection in background

**4a. Reservation not found in blockchain**
- System returns empty result
- System logs missing record
- System suggests data sync

**4b. Query timeout**
- System retries query (max 2 attempts)
- If failed, returns database history
- System logs performance issue

### Postconditions
- Complete transaction history retrieved
- Data formatted for display
- Query logged for audit

### Special Requirements
- Query response time < 3 seconds
- Support pagination for large histories
- Cache frequently accessed data

### Business Rules
- Only authenticated users can query
- Rate limiting: 100 queries per minute
- Sensitive data masked based on user role
- Query logs maintained for 90 days

---

## Global Business Rules

### Reservation Lifecycle
```
PENDING → CONFIRMED → CHECKED_IN → CHECKED_OUT
   ↓
CANCELLED (from PENDING or CONFIRMED only)
```

### Data Retention
- Active reservations: Indefinite
- Completed reservations: 7 years
- Cancelled reservations: 3 years
- Blockchain data: Permanent (immutable)

### Security Requirements
- All API calls require JWT authentication
- HTTPS required for all communications
- Passwords hashed with bcrypt (cost factor 10)
- Sensitive data encrypted at rest
- Blockchain ensures data integrity

### Performance Requirements
- Page load time: < 2 seconds
- API response time: < 1 second
- Blockchain write: < 5 seconds
- Database query: < 500ms
- Support 1000 concurrent users

### Availability Requirements
- System uptime: 99.9%
- Database backup: Every 6 hours
- Disaster recovery: RPO 1 hour, RTO 4 hours
- Blockchain redundancy across multiple nodes

---

## Glossary

**Reservation ID**: Unique identifier format RES-YYYYMMDD-XXXX  
**Guest Count**: Number of persons attending the event  
**Event Type**: Meeting, Seminar, Birthday, Wedding, Corporate Gathering, etc.  
**MSP (Membership Service Provider)**: Organization identifier in Hyperledger Fabric  
**Chaincode**: Smart contract in Hyperledger Fabric  
**Ledger**: Immutable blockchain transaction log  
**Consensus**: Agreement mechanism in blockchain network  
**JWT (JSON Web Token)**: Authentication token  

---

**Document Status:** APPROVED  
**Last Updated:** December 6, 2025  
**Next Review:** March 2026
