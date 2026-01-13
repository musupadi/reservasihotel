# Test Create Booking via API

# Get your token first (login)
$loginResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/auth/login" -Method POST -ContentType "application/json" -Body (@{
    email = "musuapadi@gmail.com"
    password = "your_password_here"
} | ConvertTo-Json)

$token = $loginResponse.token
Write-Host "Token: $token" -ForegroundColor Green

# Create test booking
$bookingData = @{
    hotel_id = 1
    room_type_id = 1
    check_in = "2026-02-01"
    check_out = "2026-02-03"
    guest_count = 50
    event_type = "Meeting"
    event_description = "Test Meeting Event"
    customer_name = "Supriyadi"
    customer_email = "musuapadi@gmail.com"
    customer_phone = "08123456789"
    customer_ref = "Test Company"
    selected_room_ids = @(1)
} | ConvertTo-Json

Write-Host "Creating booking..." -ForegroundColor Yellow
$response = Invoke-RestMethod -Uri "http://localhost:8080/api/v1/reservations" -Method POST -ContentType "application/json" -Headers @{Authorization = "Bearer $token"} -Body $bookingData

Write-Host "Success! Reservation ID: $($response.reservation_id)" -ForegroundColor Green
$response | ConvertTo-Json -Depth 5
