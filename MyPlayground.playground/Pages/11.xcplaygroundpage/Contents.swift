import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
var input = try! String(contentsOf: file, encoding: .utf8)
    .split(whereSeparator: \.isNewline)
    .map { Array($0).compactMap { Int(String($0)) } }

func debugInput() {
    let r = input.map {
        $0.reduce("") { $0.appending(String($1)) }
    }
        .reduce("") { $0.appending("\n\($1)") }
    print(r)
}


var flashes = 0

func stepUp(_ row: Int, _ col: Int, _ skip: inout [(Int,Int)]) {
    if !skip.contains(where: {$0 == (row, col)}) {
        if input[row][col] == 9 {
            skip.append((row,col))
            input[row][col] = 0
            flashAdjacent(row, col, &skip)
            flashes += 1
        } else {
            input[row][col] += 1
        }
    }
}

func flashAdjacent(_ row: Int, _ col: Int, _ skip: inout [(Int,Int)]) {
    if row-1 >= 0 {
        stepUp(row-1, col, &skip)
        if col-1 >= 0 {
            stepUp(row-1, col-1, &skip)
        }
        if col+1 < input[row].count {
            stepUp(row-1, col+1, &skip)
        }
    }
    
    if row+1 < input.count {
        stepUp(row+1, col, &skip)
        if col+1 < input[row].count {
            stepUp(row+1, col+1, &skip)
        }
        if col-1 >= 0 {
            stepUp(row+1, col-1, &skip)
        }
    }

    if col-1 >= 0 {
        stepUp(row, col-1, &skip)
    }

    if col+1 < input[row].count {
        stepUp(row, col+1, &skip)
    }
}

//debugInput()

func part1() {
    for _ in 0..<100 {
        var skip = [(Int,Int)]()
        for (ri, row) in input.enumerated() {
            for ci in 0..<row.count {
                stepUp(ri, ci, &skip)
            }
        }
    }
    print(flashes)
}
//part1() //1747

func part2() {
    for i in 1..<Int.max {
        var skip = [(Int,Int)]()
        for (ri, row) in input.enumerated() {
            for ci in 0..<row.count {
                stepUp(ri, ci, &skip)
            }
        }
        
        if input.flatMap({$0}).reduce(0, +) == 0 {
            print(i)
            break
        }
    }
}

part2() //505

