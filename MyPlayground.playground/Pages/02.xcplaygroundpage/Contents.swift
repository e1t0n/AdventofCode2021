import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
let positions = content.split(whereSeparator: \.isNewline).map { String($0) }

func part1(_ pos: [String]) -> Int {
    var horizontal = 0
    var vertical = 0
    
    for p in pos {
        let val = p.split(separator: " ")
        if val[0] == "forward" {
            horizontal += Int(val[1])!
        }
        if val[0] == "up" {
            vertical -= Int(val[1])!
        }
        if val[0] == "down" {
            vertical += Int(val[1])!
        }
    }
    return horizontal * vertical
}

func part2(_ pos: [String]) -> Int {
    var horizontal = 0
    var vertical = 0
    var aim = 0
    
    for p in pos {
        let val = p.split(separator: " ")
        if val[0] == "forward" {
            horizontal += Int(val[1])!
            vertical += aim * Int(val[1])!
        }
        if val[0] == "up" {
            aim -= Int(val[1])!
        }
        if val[0] == "down" {
            aim += Int(val[1])!
        }
    }
    return horizontal * vertical
}

print(part1(positions))
print(part2(positions))
