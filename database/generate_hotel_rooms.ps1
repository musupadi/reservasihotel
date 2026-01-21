# =============================================
# Hotel Rooms Generator dengan Koordinat Denah
# =============================================
# Script untuk generate INSERT SQL hotel_rooms dengan layout otomatis

param(
    [string]$OutputFile = "hotel_rooms_generated.sql"
)

Write-Host "Generating Hotel Rooms dengan Denah Koordinat..." -ForegroundColor Cyan

$sqlOutput = @"
-- =============================================
-- AUTO-GENERATED HOTEL ROOMS dengan Koordinat Denah
-- =============================================
-- Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

"@

# Definisi hotel dan room types
$hotels = @(
    @{ID=1; Name="L'Eminence"; Types=@(@{ID=1;Count=20;Prefix="1"},@{ID=2;Count=15;Prefix="2"},@{ID=3;Count=10;Prefix="5"},@{ID=4;Count=2;Prefix="M-SAKURA"},@{ID=5;Count=2;Prefix="M-MELATI"},@{ID=6;Count=1;Prefix="GRAND-BALLROOM"})}
    @{ID=2; Name="Padma"; Types=@(@{ID=7;Count=25;Prefix="1"},@{ID=8;Count=20;Prefix="2"},@{ID=9;Count=8;Prefix="3"},@{ID=10;Count=3;Prefix="M-CEMPAKA"},@{ID=11;Count=2;Prefix="M-ANGGREK"},@{ID=12;Count=1;Prefix="CONV-PADMA"})}
    @{ID=3; Name="Grand Sunshine"; Types=@(@{ID=13;Count=30;Prefix="1"},@{ID=14;Count=25;Prefix="2"},@{ID=15;Count=12;Prefix="V"},@{ID=16;Count=3;Prefix="M-LILY"},@{ID=17;Count=3;Prefix="M-TULIP"},@{ID=18;Count=2;Prefix="GRAND-CONV"})}
    @{ID=4; Name="Pullman"; Types=@(@{ID=19;Count=30;Prefix="1"},@{ID=20;Count=20;Prefix="2"},@{ID=21;Count=5;Prefix="P"},@{ID=22;Count=3;Prefix="M-ALPHA"},@{ID=23;Count=2;Prefix="M-BETA"},@{ID=24;Count=2;Prefix="PULLMAN-BALL"})}
    @{ID=5; Name="Trans Luxury"; Types=@(@{ID=25;Count=25;Prefix="1"},@{ID=26;Count=18;Prefix="2"},@{ID=27;Count=7;Prefix="R"},@{ID=28;Count=2;Prefix="M-RUBY"},@{ID=29;Count=2;Prefix="M-SAPPHIRE"},@{ID=30;Count=1;Prefix="TRANS-BALL"})}
    @{ID=6; Name="Mulia"; Types=@(@{ID=31;Count=40;Prefix="1"},@{ID=32;Count=30;Prefix="E"},@{ID=33;Count=10;Prefix="P"},@{ID=34;Count=4;Prefix="M-GARUDA"},@{ID=35;Count=3;Prefix="M-RAJAWALI"},@{ID=36;Count=3;Prefix="MULIA-BALL"})}
    @{ID=7; Name="Borobudur"; Types=@(@{ID=37;Count=35;Prefix="1"},@{ID=38;Count=25;Prefix="2"},@{ID=39;Count=10;Prefix="H"},@{ID=40;Count=3;Prefix="M-KEMUNING"},@{ID=41;Count=3;Prefix="M-KENANGA"},@{ID=42;Count=2;Prefix="BORO-BALL"})}
    @{ID=8; Name="Renaissance Bali"; Types=@(@{ID=43;Count=40;Prefix="1"},@{ID=44;Count=30;Prefix="2"},@{ID=45;Count=10;Prefix="V"},@{ID=46;Count=3;Prefix="M-JIMBARAN"},@{ID=47;Count=3;Prefix="M-ULUWATU"},@{ID=48;Count=2;Prefix="RENAI-BALL"})}
    @{ID=9; Name="Holiday Inn Bali"; Types=@(@{ID=49;Count=30;Prefix="1"},@{ID=50;Count=20;Prefix="2"},@{ID=51;Count=10;Prefix="F"},@{ID=52;Count=3;Prefix="M-SANUR"},@{ID=53;Count=2;Prefix="M-BENOA"},@{ID=54;Count=1;Prefix="HOLIDAY-HALL"})}
    @{ID=10; Name="R Hotel"; Types=@(@{ID=55;Count=30;Prefix="1"},@{ID=56;Count=18;Prefix="2"},@{ID=57;Count=8;Prefix="V"},@{ID=58;Count=3;Prefix="M-EAGLE"},@{ID=59;Count=2;Prefix="M-BIRDIE"},@{ID=60;Count=1;Prefix="RANCAMAYA-HALL"})}
)

$roomID = 1000

foreach ($hotel in $hotels) {
    $sqlOutput += "`n-- Hotel: $($hotel.Name) (ID: $($hotel.ID))`n"
    $sqlOutput += "INSERT INTO ``hotel_rooms`` (``id``, ``hotel_id``, ``room_type_id``, ``room_number``, ``floor``, ``is_blockchain_enabled``, ``status``, ``layout_x``, ``layout_y``, ``layout_width``, ``layout_height``, ``created_at``, ``updated_at``) VALUES`n"
    
    $inserts = @()
    
    foreach ($type in $hotel.Types) {
        $count = $type.Count
        $prefix = $type.Prefix
        $typeID = $type.ID
        
        # Detect if meeting room or hotel room
        $isMeeting = $prefix -match "M-|BALL|CONV|HALL"
        
        if ($isMeeting) {
            # Meeting rooms: larger size, special floors
            $baseFloor = 6
            for ($i = 1; $i -le $count; $i++) {
                $roomID++
                $roomNumber = if ($count -eq 1) { $prefix } else { "$prefix-$i" }
                $floor = $baseFloor + [Math]::Floor(($i - 1) / 2)
                
                # Meeting room coordinates - center positioned
                $x = 10 + (($i - 1) % 2) * 45
                $y = 20
                $width = 35
                $height = if ($prefix -match "BALL|HALL|CONV") { 50 } else { 30 }
                
                $inserts += "($roomID, $($hotel.ID), $typeID, '$roomNumber', $floor, 1, 'AVAILABLE', $x, $y, $width, $height, NOW(), NOW())"
            }
        } else {
            # Hotel rooms: grid layout by floor
            $roomsPerFloor = 5
            $baseFloor = if ($prefix -match "[EPR]") { 3 } elseif ($prefix -match "[VF]") { 4 } elseif ($prefix -match "H") { 5 } else { 1 }
            
            for ($i = 1; $i -le $count; $i++) {
                $roomID++
                $floorNum = $baseFloor + [Math]::Floor(($i - 1) / $roomsPerFloor)
                $posInFloor = ($i - 1) % $roomsPerFloor
                
                # Room number format
                $roomNumber = if ($prefix -match "[A-Z]") {
                    "$prefix$floorNum$(([string]($posInFloor + 1)).PadLeft(2,'0'))"
                } else {
                    "$floorNum$prefix$(([string]($posInFloor + 1)).PadLeft(2,'0'))"
                }
                
                # Grid coordinates
                $x = 5 + ($posInFloor * 20)
                $y = 10 + (($floorNum - $baseFloor) * 25)
                $width = if ($prefix -match "[EPRV]") { 20 } else { 15 }
                $height = if ($prefix -match "[PV]") { 20 } else { 15 }
                
                $inserts += "($roomID, $($hotel.ID), $typeID, '$roomNumber', $floorNum, 1, 'AVAILABLE', $x, $y, $width, $height, NOW(), NOW())"
            }
        }
    }
    
    $sqlOutput += $inserts -join ",`n"
    $sqlOutput += ";`n"
}

$sqlOutput += "`n-- Total Rooms Generated: $($roomID - 1000)`n"

# Save to file
$outputPath = Join-Path (Get-Location) $OutputFile
$sqlOutput | Out-File -FilePath $outputPath -Encoding UTF8

Write-Host "`n✓ Generated $($roomID - 1000) hotel rooms with coordinates!" -ForegroundColor Green
Write-Host "✓ Output saved to: $outputPath" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. Review the generated SQL file" -ForegroundColor Gray
Write-Host "  2. Merge with reservation_realistic.sql" -ForegroundColor Gray
Write-Host "  3. Import to database" -ForegroundColor Gray
Write-Host ""
