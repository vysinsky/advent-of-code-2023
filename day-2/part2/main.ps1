param (
    [Parameter(Position=0, Mandatory=$true)] [string]$fileName
)

$GAME_SEPARATOR = ":"
$SET_SEPARATOR = ";"
$CUBE_SEPARATOR = ","

function GetMinimalSetPowers {
    param(
        [Parameter(Position=0, Mandatory=$true)] [string[]]$sets
    )
    
    $maxDrawnCubes = [PsCustomObject]@{
        red = 0
        green = 0
        blue = 0
    }

    foreach ($set in $sets) {
        $drawnCubes = [PsCustomObject]@{
            red = 0
            green = 0
            blue = 0
        }

        $cubes = $set -split $CUBE_SEPARATOR

        foreach ($cube in $cubes) {
            [void]($cube -match "(\d+) (\w+)")
            $count = $matches[1]
            $color = $matches[2]
            $drawnCubes.$color += $count
        }
        
        if ($maxDrawnCubes.red -lt $drawnCubes.red) {
            $maxDrawnCubes.red = $drawnCubes.red
        }
        
        if ($maxDrawnCubes.green -lt $drawnCubes.green) {
            $maxDrawnCubes.green = $drawnCubes.green
        }
        
        if ($maxDrawnCubes.blue -lt $drawnCubes.blue) {
            $maxDrawnCubes.blue = $drawnCubes.blue
        }
    }
    
    return $maxDrawnCubes.red * $maxDrawnCubes.green * $maxDrawnCubes.blue
}

function EvaluateGame {
    param(
        [Parameter(Position=0, Mandatory=$true)] [string]$line
    )

    [void]($line -match "Game (\d+):(.*)")    
    $gameID = $matches[1]
    $sets = $matches[2] -split $SET_SEPARATOR

    return [PsCustomObject]@{
        GameID = $gameID
        MinimalSetPowers = (GetMinimalSetPowers $sets)
    }
}

$inputData = Get-Content -Path $fileName
$sum = 0

$inputData | ForEach-Object {
    $result = EvaluateGame $_
    
    $sum += $result.MinimalSetPowers
}

Write-Host "Sum of minimal set powers is" $sum