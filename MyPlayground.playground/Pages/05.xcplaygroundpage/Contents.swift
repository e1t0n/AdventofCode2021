import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
var lines = content.split(whereSeparator: \.isNewline).map { String($0) }

func getLines() -> [[(x: Int, y: Int)]] {
    var ventLines = [[(x: Int, y: Int)]]()
    for line in lines {
        let points = line.components(separatedBy: "->")
            .map { coord -> (x: Int, y: Int) in
                let p = coord.trimmingCharacters(in: .whitespaces)
                    .split(separator: ",")
                    .compactMap { Int($0) }
                return (p[0], p[1])
            }
        ventLines.append(points)
    }
    return ventLines
}

let ventLines = getLines()
var vents = [String: Int]()

func addVent(x: Int, y: Int) {
    var value = 1
    let v = "\(x),\(y)"
    if let val = vents[v] {
        value = val + 1
    }
    vents[v] = value
}

func part1() -> Int {
    for line in ventLines {
        let start = line[0]
        let end = line[1]
        
        guard start.x == end.x || start.y == end.y else {
            continue
        }
        
        print("Start End", start, end)
        
        let dx = start.x < end.x ? 1 : (start.x == end.x ? 0 : -1)
        let dy = start.y < end.y ? 1 : (start.y == end.y ? 0 : -1)
        var x = start.x
        var y = start.y
        while true {
//            print(x, y)
            addVent(x: x, y: y)
                            
            if x == end.x && y == end.y {
                break
            }
            
            x += dx
            y += dy
        }
    }
    
    var count = 0
    for value in vents.values {
        if value > 1 {
            count += 1
        }
    }
    return count
}

func part2() -> Int {
    for line in ventLines {
        let start = line[0]
        let end = line[1]
        
        print("Start End", start, end)
        
        let dx = start.x < end.x ? 1 : (start.x == end.x ? 0 : -1)
        let dy = start.y < end.y ? 1 : (start.y == end.y ? 0 : -1)
        var x = start.x
        var y = start.y
        while true {
//            print(x, y)
            addVent(x: x, y: y)
                            
            if x == end.x && y == end.y {
                break
            }
            
            x += dx
            y += dy
        }
    }
    
    var count = 0
    for value in vents.values {
        if value > 1 {
            count += 1
        }
    }
    return count
}

print("Result ", part1()) //6841
//print("Result ", part2()) //19258

