import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
let report = content.split(whereSeparator: \.isNewline).map { String($0) }

typealias Filter = (most: Character, least: Character)

func compare(_ input: [String], at index: Int) -> Filter? {
    var ones = 0
    var zeros = 0
    for i in input {
        if Array(i)[index] == "1" {
            ones += 1
        } else {
            zeros += 1
        }
    }
    if ones > zeros {
        return ("1", "0")
    } else if ones == zeros {
        return nil
    }
    return ("0", "1")
}

func part1(_ input: [String]) -> Int {
    var bitIndex = 0
    var gamma = ""
    var epsilon = ""
    while bitIndex < input[0].count {
        let result = compare(input, at: bitIndex)
        gamma.append(result!.most)
        epsilon.append(result!.least)
        bitIndex += 1
    }
    
    return Int(gamma, radix: 2)! * Int(epsilon, radix: 2)!
}

func rating(_ input: [String], index: Int = 0, bitCriteria: String) -> String {
    
    guard input.count > 1 else {
        return input[0]
    }
    
    if let result = compare(input, at: index) {
        let filter = input.filter({
            if bitCriteria == "1" {
                return Array($0)[index] == result.most
            } else {
                return Array($0)[index] == result.least
            }
        })
        return rating(filter, index: index+1, bitCriteria: bitCriteria)
    } else {
        return rating(input.filter { String(Array($0)[index]) == bitCriteria }, index: index+1, bitCriteria: bitCriteria)
    }
}

func part2(_ input: [String]) -> Int {
    Int(rating(input, bitCriteria: "1"), radix: 2)! * Int(rating(input, bitCriteria: "0"), radix: 2)!
}

print(part1(report))
print(part2(report))
