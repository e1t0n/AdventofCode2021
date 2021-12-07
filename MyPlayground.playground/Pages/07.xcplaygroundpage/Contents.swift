import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
var crabs = content.components(separatedBy: ",").compactMap { Int($0.trimmingCharacters(in: .newlines)) }

func part1() {
    var lowest = Int.max
    for f in Set(crabs) {
        var fuel = 0
        for pos in crabs {
            fuel += abs(pos-f)
        }
        if fuel < lowest {
            lowest = fuel
        }
    }
    print(lowest)
}

func part2() {
    var lowest = Int.max
    for f in crabs.min()!...crabs.max()! {
        var fuel = 0
        for pos in crabs {
            let sum = Array(0...abs(pos-f)).reduce(0, +)
            fuel += sum
            //print(f, pos, sum)
        }
        if fuel < lowest {
            lowest = fuel
        }
    }
    print(lowest)
}

part2()

