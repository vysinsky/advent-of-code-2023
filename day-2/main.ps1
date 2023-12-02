param (
    [Parameter(Position=0, Mandatory=$true)] [string]$fileName
)

$LIMIT_RED = 12
$LIMIT_GREEN = 13
$LIMIT_BLUE = 14

$GAME_SEPARATOR = ":"
$SET_SEPARATOR = ";"
$CUBE_SEPARATOR = ","

function DetectGamePossibility {
    param(
        [Parameter(Position=0, Mandatory=$true)] [string[]]$sets
    )

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

        if ($drawnCubes.red -gt $LIMIT_RED -or $drawnCubes.green -gt $LIMIT_GREEN -or $drawnCubes.blue -gt $LIMIT_BLUE) {
            return $false
        }
    }

    return $true
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
        Possible = DetectGamePossibility $sets
    }
}

$inputData = Get-Content -Path $fileName
$sum = 0

$inputData | ForEach-Object {
    $result = EvaluateGame $_
    
    Write-Host $result
    
    if ($result.Possible) {
        $sum += $result.GameID
    }
}

Write-Host "Sum of possible games IDs" $sum