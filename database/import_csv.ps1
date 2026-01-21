# =============================================
# Hotel Reservation Database CSV Import Script
# =============================================
# Script ini untuk import data dari CSV/Excel ke MySQL database
# Cocok untuk bulk insert data hotel, room types, dan hotel rooms

param(
    [string]$MySQLHost = "127.0.0.1",
    [int]$MySQLPort = 3306,
    [string]$MySQLUser = "root",
    [string]$MySQLPassword = "",
    [string]$Database = "reservation",
    [string]$CSVFolder = ".\templates"
)

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Hotel Reservation Database CSV Import Tool  " -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check if MySQL is accessible
Write-Host "[1/5] Checking MySQL connection..." -ForegroundColor Yellow
$mysqlCmd = "mysql"
if ($MySQLPassword) {
    $testConnection = "SELECT 1" | & $mysqlCmd -h $MySQLHost -P $MySQLPort -u $MySQLUser -p"$MySQLPassword" $Database 2>&1
} else {
    $testConnection = "SELECT 1" | & $mysqlCmd -h $MySQLHost -P $MySQLPort -u $MySQLUser $Database 2>&1
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Failed to connect to MySQL!" -ForegroundColor Red
    Write-Host "  Error: $testConnection" -ForegroundColor Red
    Write-Host ""
    Write-Host "Pastikan:" -ForegroundColor Yellow
    Write-Host "  1. MySQL sudah running (xampp/wamp)" -ForegroundColor Yellow
    Write-Host "  2. Database 'reservation' sudah dibuat" -ForegroundColor Yellow
    Write-Host "  3. Username dan password benar" -ForegroundColor Yellow
    exit 1
}
Write-Host "✓ MySQL connection successful!" -ForegroundColor Green
Write-Host ""

# Function to import CSV with proper error handling
function Import-CSVToMySQL {
    param(
        [string]$CSVFile,
        [string]$TableName,
        [string]$TempTableName
    )
    
    Write-Host "Importing $CSVFile to table $TableName..." -ForegroundColor Cyan
    
    if (-not (Test-Path $CSVFile)) {
        Write-Host "  ✗ File not found: $CSVFile" -ForegroundColor Red
        return $false
    }
    
    # Read CSV and prepare SQL statements
    $csvData = Import-Csv $CSVFile
    $rowCount = $csvData.Count
    
    if ($rowCount -eq 0) {
        Write-Host "  ⚠ No data found in CSV" -ForegroundColor Yellow
        return $true
    }
    
    Write-Host "  Found $rowCount rows to import" -ForegroundColor Gray
    
    # Get column names from first row
    $columns = $csvData[0].PSObject.Properties.Name
    $columnList = $columns -join ", "
    
    # Build INSERT statements
    $sqlStatements = @()
    $successCount = 0
    $errorCount = 0
    
    foreach ($row in $csvData) {
        $values = @()
        foreach ($col in $columns) {
            $value = $row.$col
            if ([string]::IsNullOrWhiteSpace($value) -or $value -eq "NULL") {
                $values += "NULL"
            } else {
                # Escape single quotes and wrap in quotes
                $escapedValue = $value -replace "'", "''"
                $values += "'$escapedValue'"
            }
        }
        $valueList = $values -join ", "
        
        # Use REPLACE INTO to update if exists, insert if not
        $sql = "REPLACE INTO $TableName ($columnList) VALUES ($valueList);"
        $sqlStatements += $sql
    }
    
    # Execute all SQL statements
    $allSQL = $sqlStatements -join "`n"
    $tempFile = [System.IO.Path]::GetTempFileName()
    $allSQL | Out-File -FilePath $tempFile -Encoding UTF8
    
    if ($MySQLPassword) {
        $result = & $mysqlCmd -h $MySQLHost -P $MySQLPort -u $MySQLUser -p"$MySQLPassword" $Database < $tempFile 2>&1
    } else {
        $result = & $mysqlCmd -h $MySQLHost -P $MySQLPort -u $MySQLUser $Database < $tempFile 2>&1
    }
    
    Remove-Item $tempFile -Force
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Successfully imported $rowCount rows" -ForegroundColor Green
        return $true
    } else {
        Write-Host "  ✗ Import failed!" -ForegroundColor Red
        Write-Host "  Error: $result" -ForegroundColor Red
        return $false
    }
}

# Import sequence
Write-Host "[2/5] Importing Hotels..." -ForegroundColor Yellow
$hotelsFile = Join-Path $CSVFolder "1_hotels_template.csv"
$hotelsSuccess = Import-CSVToMySQL -CSVFile $hotelsFile -TableName "hotels" -TempTableName "hotels_temp"
Write-Host ""

Write-Host "[3/5] Importing Room Types..." -ForegroundColor Yellow
$roomTypesFile = Join-Path $CSVFolder "2_room_types_template.csv"
$roomTypesSuccess = Import-CSVToMySQL -CSVFile $roomTypesFile -TableName "room_types" -TempTableName "room_types_temp"
Write-Host ""

Write-Host "[4/5] Importing Hotel Rooms..." -ForegroundColor Yellow
$hotelRoomsFile = Join-Path $CSVFolder "3_hotel_rooms_template.csv"
$hotelRoomsSuccess = Import-CSVToMySQL -CSVFile $hotelRoomsFile -TableName "hotel_rooms" -TempTableName "hotel_rooms_temp"
Write-Host ""

Write-Host "[5/5] Verifying import..." -ForegroundColor Yellow
if ($MySQLPassword) {
    $verification = "SELECT 
        (SELECT COUNT(*) FROM hotels WHERE id = 32) as hotel_count,
        (SELECT COUNT(*) FROM room_types WHERE hotel_id = 32) as room_type_count,
        (SELECT COUNT(*) FROM hotel_rooms WHERE hotel_id = 32) as hotel_room_count;" | 
        & $mysqlCmd -h $MySQLHost -P $MySQLPort -u $MySQLUser -p"$MySQLPassword" $Database 2>&1
} else {
    $verification = "SELECT 
        (SELECT COUNT(*) FROM hotels WHERE id = 32) as hotel_count,
        (SELECT COUNT(*) FROM room_types WHERE hotel_id = 32) as room_type_count,
        (SELECT COUNT(*) FROM hotel_rooms WHERE hotel_id = 32) as hotel_room_count;" | 
        & $mysqlCmd -h $MySQLHost -P $MySQLPort -u $MySQLUser $Database 2>&1
}

Write-Host "✓ Verification complete!" -ForegroundColor Green
Write-Host ""

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "                  SUMMARY                       " -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Hotels imported:     $(if($hotelsSuccess){'✓'}else{'✗'})" -ForegroundColor $(if($hotelsSuccess){'Green'}else{'Red'})
Write-Host "Room Types imported: $(if($roomTypesSuccess){'✓'}else{'✗'})" -ForegroundColor $(if($roomTypesSuccess){'Green'}else{'Red'})
Write-Host "Hotel Rooms imported:$(if($hotelRoomsSuccess){'✓'}else{'✗'})" -ForegroundColor $(if($hotelRoomsSuccess){'Green'}else{'Red'})
Write-Host ""
Write-Host "Database verification:" -ForegroundColor Cyan
Write-Host $verification
Write-Host ""

if ($hotelsSuccess -and $roomTypesSuccess -and $hotelRoomsSuccess) {
    Write-Host "✓ All data imported successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Restart backend: cd ..\api-gateway; go run main.go" -ForegroundColor Gray
    Write-Host "  2. Test booking flow di frontend" -ForegroundColor Gray
    Write-Host "  3. Verifikasi data di hotel-admin dashboard" -ForegroundColor Gray
} else {
    Write-Host "⚠ Some imports failed. Please check errors above." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
