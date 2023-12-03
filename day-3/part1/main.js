const fs = require('fs')

const data = fs.readFileSync(process.argv[2], 'utf-8')

const lines = data.split('\r\n')

function isPartNumber(x, y, numberLength) {
    const neighbors = []
    // Above and below
    for (let i = x - 1; i < x + 1 + numberLength; i++) {
        neighbors.push(lines[y - 1]?.[i])
        neighbors.push(lines[y + 1]?.[i])
    }
    // Next to it
    neighbors.push(lines[y][x - 1])
    neighbors.push(lines[y][x + numberLength]);

    return neighbors.some(
        maybeSymbol => typeof maybeSymbol !== 'undefined' && maybeSymbol !== '.'
    )
}

let sum = 0;
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
            console.log(number, 'is part number')
            sum += parseInt(number, 10);
        } else {
            console.log(number, 'is NOT part number')
        }
    }
}

console.log(`Sum of all parts: ${sum}`)