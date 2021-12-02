import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
let depths = content.split(whereSeparator: \.isNewline).compactMap { Int($0) }

func part1(_ m: [Int]) -> Int {
    var increased = 0
    for (index, element) in m.enumerated() {
        if index+1 < m.count {
            if element < m[index+1] {                
                increased += 1
            }
        }
    }
    return increased
}

func part2() -> [Int] {
    var array = depths
    var measurements = [Int]()
    while array.count > 2 {
        measurements.append(array.prefix(3).reduce(0, +))
        array.removeFirst()
    }
    return measurements
}

print(part1(depths))
print(part1(part2()))

