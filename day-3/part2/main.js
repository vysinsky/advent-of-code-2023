const fs = require('fs')

const data = fs.readFileSync(process.argv[2], 'utf-8')

const lines = data.split('\r\n')

function getNeighbors(x, numberLength, y) {
    const neighbors = []
    // Above and below
    for (let i = x - 1; i < x + 1 + numberLength; i++) {
        neighbors.push({
            char: lines[y - 1]?.[i],
            coords: {
                x: i,
                y: y - 1
            }
        })
        neighbors.push({
            char: lines[y + 1]?.[i],
            coords: {
                x: i,
                y: y + 1
            }
        })
    }
    // Next to it
    neighbors.push({
        char: lines[y][x - 1],
        coords: {
            x: x - 1,
            y
        }
    })
    neighbors.push({
        char: lines[y][x + numberLength],
        coords: {
            x: x + numberLength,
            y
        }
    });
    return neighbors;
}

function isPartNumber(x, y, numberLength) {
    return getNeighbors(x, numberLength, y).some(
        ({char}) => typeof char !== 'undefined' && char !== '.'
    )
}

let sum = 0;
const partNumbers = [];
for (let y = 0; y < lines.length; y++) {
    for (let x = 0; x < lines[y].length; x++) {
        const currentIndex = x
        let number = '';
        while (!isNaN(lines[y][x])) {
            number += lines[y][x];
            x++;
        }

        if (number.length === 0) {
            continue;
        }

        if (isPartNumber(currentIndex, y, number.length)) {
            partNumbers.push({
                number,
                coords: {x: currentIndex, y},
                gears: [],
            })
        }
    }
}

partNumbers.forEach((partNumber) => {
    getNeighbors(partNumber.coords.x, partNumber.number.length, partNumber.coords.y)
        .filter((neighbor) => neighbor.char === '*')
        .forEach(neighbor => {
            partNumber.gears.push(neighbor)
        })
})

partNumbers.forEach((partNumber) => {
    const partsSharingSameGear = partNumber.gears.map((gear) => {
        return partNumbers.find(other => {
            return Object.entries(other.coords).toString() !== Object.entries(partNumber.coords).toString()
                && other.gears.some(otherGear => Object.entries(otherGear.coords).toString() === Object.entries(gear.coords).toString())
        })
    })

    if (partsSharingSameGear.length === 1 && partsSharingSameGear[0]) {
        sum += partNumber.number * partsSharingSameGear[0].number
    }
})

sum /= 2

console.log(`Sum of all parts: ${sum}`)