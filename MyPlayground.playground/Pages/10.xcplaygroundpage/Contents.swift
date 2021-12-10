import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let input = try! String(contentsOf: file, encoding: .utf8)
    .split(whereSeparator: \.isNewline)
    .map { Array($0) }
let closing = ")]}>"

extension Character {
    var opening: Character {
        switch self {
        case ")" : return "("
        case "]" : return "["
        case "}" : return "{"
        default: return "<"
        }
    }
    
    var closing: Character {
        switch self {
        case "(" : return ")"
        case "[" : return "]"
        case "{" : return "}"
        default: return ">"
        }
    }
    
    var points: Int {
        switch self {
        case ")" : return 3
        case "]" : return 57
        case "}" : return 1197
        default: return 25137
        }
    }
    
    var score: Int { //autocomplete
        switch self {
        case ")" : return 1
        case "]" : return 2
        case "}" : return 3
        default: return 4
        }
    }
}

extension Array {
    var middleIndex: Int {
        return (isEmpty ? startIndex : count - 1) / 2
    }
    
    var middle: Element? {
        self[middleIndex]
    }
}

func part1(_ lines: [[Character]]) {
    var illegal = [Character]()
    for line in lines {
        var array = [Character]()
        for c in line {
            if closing.contains(c) {
                if array.count > 0 {
                    if array.last == c.opening {
                        array.removeLast()
                    } else {
                        illegal.append(c)
                        break
                    }
                }
            } else {
                array.append(c)
            }
        }
    }
    
    let result = illegal.reduce(0) { $0 + $1.points }
    print(result)
}

//part1(input) //388713

func part2(_ lines: [[Character]]) {
    var scores = [Int]()
    for line in lines {
        var array = [Character]()
        var corrupted = false
        for c in line {
            if closing.contains(c) {
                if array.count > 0 {
                    if array.last == c.opening {
                        array.removeLast()
                    } else {
                        corrupted = true
                        break
                    }
                }
            } else {
                array.append(c)
            }
        }
        
        if !corrupted {
            let val = array.reversed()
                .reduce(0) {  $0 * 5 + $1.closing.score }
            scores.append(val)
        }
    }
    
    print(scores.sorted().middle!)
}

part2(input) //3539961434


