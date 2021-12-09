import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
let entryDigits = Array(content.components(separatedBy: "\n").dropLast())
    .reduce(into: [String: String]()) { (prev, input) in
    let c = input.components(separatedBy: " | ")
    prev[c[0]] = c[1]
}

func part1(_ input: [String]) {
    var count = 0
    for e in input {
        e.split(whereSeparator: \.isWhitespace).forEach {
            if [2,4,3,7].contains($0.count) {
                count += 1
            }
        }
    }
    print(count)
}
//part1(Array(entryDigits.values)) //476

extension Dictionary where Value : Hashable {
    func swap() -> [Value : Key] {
        assert(Set(self.values).count == self.keys.count, "Values must be unique")
        var newDict = [Value : Key]()
        for (key, value) in self {
            newDict[value] = key
        }
        return newDict
    }
}

extension String {
    func sort() -> String {
        String(Array(self).sorted())
    }
}

func part2(_ input: [String: String]) {
    var nums = [Int]()
    for e in input {
        var decoded = [Int: String]()
        let digits = e.key.components(separatedBy: " ")
        
        digits.forEach { string in
            switch string.count {
            case 2:
                decoded[1] = string.sort()
            case 3:
                decoded[7] = string.sort()
            case 4:
                decoded[4] = string.sort()
            case 7:
                decoded[8] = string.sort()
            default:
                break
            }
        }
        
        func is9(_ str: String) -> Bool {
            for c in decoded[4] ?? "" {
                if !str.sort().contains(c) {
                    return false
                }
            }
            return true
        }
        
        func is0(_ str: String) -> Bool {
            for c in decoded[1] ?? "" {
                if !str.sort().contains(c) {
                    return false
                }
            }
            return true
        }
        
        func is3(_ str: String) -> Bool {
            for c in decoded[1] ?? "" {
                if !str.sort().contains(c) {
                    return false
                }
            }
            return true
        }
        
        func is5(_ str: String) -> Bool {
            var notin = 0
            for c in decoded[6] ?? "" {
                if !str.sort().contains(c) {
                    notin += 1
                }
            }
            return notin == 1
        }
        
        for d in digits {
            if d.count == 6 {
                if is9(d) {
                    decoded[9] = d.sort()
                } else if is0(d) {
                    decoded[0] = d.sort()
                } else {
                    decoded[6] = d.sort()
                }
            }
        }
        
        for d in digits {
            if d.count == 5 {
                if is3(d) {
                    decoded[3] = d.sort()
                } else if is5(d) {
                    decoded[5] = d.sort()
                } else {
                    decoded[2] = d.sort()
                }
            }
        }
        
        let swapped = decoded.swap()
        //print(e)
        //print(swapped)
        let n = e.value.components(separatedBy: " ").reduce(into: "") { result, element in
            result.append("\(swapped[element.sort()]!)")
            //print(element.sort(), swapped[element.sort()])
        }
        nums.append(Int(n)!)
    }
    
    print(nums.reduce(0, +))
}

//print(entryDigits)
part2(entryDigits) //1011823
