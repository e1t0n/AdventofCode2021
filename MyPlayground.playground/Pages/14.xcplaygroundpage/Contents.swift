import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
    .split(whereSeparator: \.isNewline)

let originalTemplate = String(content[0])
let rules = content
    .dropFirst()
    .map {
        $0.components(separatedBy: "->")
            .map { $0.trimmingCharacters(in: .whitespaces) }
    }
    .reduce(into: [String: Character]()) { (result, element) in
        result[element[0]] = Character(element[1])
    }

//print(originalTemplate)
//print(rules)

func insertion(_ template: String) -> [String: Int] {
    var dict = [String: Int]()
    var startIndex = template.startIndex
    var endIndex = template.index(startIndex, offsetBy: 1)
    for _ in 0..<template.count-1 {
        let pair = String(template[startIndex...endIndex])
        //print(pair)
        if dict[pair] == nil {
            dict[pair] = 0
        }
        dict[pair]! += 1
        
        endIndex = template.index(endIndex, offsetBy: 1)
        startIndex = template.index(endIndex, offsetBy: -1)
    }
    //print(dict)
    return dict
}

func part1(_ steps: Int) -> Int {
    var template = originalTemplate
    for _ in 0..<steps {
        let count = template.count
        var startIndex = template.startIndex
        var endIndex = template.index(startIndex, offsetBy: 1)
        for _ in 0..<count-1 {
            guard endIndex < template.endIndex else { break }
            
            var offset = 1
            let s = String(template[startIndex...endIndex])
            //print(s)
            if let val = rules[s] {
                template.insert(val, at: endIndex)
                offset += 1
            }
            endIndex = template.index(endIndex, offsetBy: offset)
            startIndex = template.index(endIndex, offsetBy: -1)
        }
        print(insertion(template))
    }
    
    let pairCount = template.reduce(into: [Character: Int]()) { (result, element) in
        if result[element] == nil {
            result[element] = 0
        }
        result[element]! += 1
    }
    
    
    print("\n", pairCount)
    let result = pairCount.map { $0.value }
    return result.max()! - result.min()!
}

extension String {
    var variants: [String] {
        let a = Array(self)
        let v = rules[self]!
        return ["\(a[0])\(v)", "\(v)\(a[1])"]
    }
    
    var char: [String] {
        Array(self).map { String($0) }
    }
}

func part2(_ steps: Int) -> Int {
    
    func update(_ dict: inout[String: Int]) {
        for pair in dict {
            if let _ = rules[pair.key] {
                //print(pair.key, " -> ", r)
                let value = pair.value
                let variants = pair.key.variants
                //print("Issue: ", dict[pair.key], value)
                dict[pair.key]! -= value //problem here??
                if let _ = dict[variants[0]] {
                    dict[variants[0]]! += value
                } else {
                    dict[variants[0]] = 0
                    dict[variants[0]]! += value
                }
                if let _ = dict[variants[1]] {
                    dict[variants[1]]! += value
                } else {
                    dict[variants[1]] = 0
                    dict[variants[1]]! += value
                }
            }
        }
        print(dict.filter { $0.value > 0})
    }
    
    var dict = insertion(originalTemplate)
    for _ in 1...steps {
        //print("\(i) pass:")
        update(&dict)
    }
    
    dict = dict.filter { $0.value > 0 }
    //print(dict)
    let start = String(originalTemplate.prefix(1))
    let end = String(originalTemplate.suffix(1))
    var elements = [String: Int]()
    for pair in dict {
        //print(pair)
        let p1 = pair.key.char[0]
        let p2 = pair.key.char[1]
        //print(p1, p2)
        if elements[p1] == nil {
            elements[p1] = 0
        }
        elements[p1]! += pair.value
        
        if elements[p2] == nil {
            elements[p2] = 0
        }
        elements[p2]! += pair.value
    }
    
    
    var final = elements.reduce(into: [String: Int]()) { $0[$1.key] = $1.value/2 }
    
    final[start]! += 1
    final[end]! += 1
    
    print("\n", final)
    let result = final.map { $0.value }
    return result.max()! - result.min()!
}


//print(part1(10)) //3284
print(part2(40)) //4302675529689
