import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
var index = 0
let content = try! String(contentsOf: file, encoding: .utf8)
    .split(whereSeparator: \.isNewline)
    .lazy
    .map { Array($0) }
    .reduce(into: [[Int]]()) { result, element in
        result.append(element.compactMap { Int(String($0)) })
    }

extension String {
    var hi: Int {
        Int(split(separator: ",")[1])!
    }
    
    var vi: Int {
        Int(split(separator: ",")[0])!
    }
}

func solve(_ input: [[Int]]) {
    var height = 0
    var lows = [String]()
    let vMax = input.count
    for (vi, v) in input.enumerated() {
        let hMax = v.count
        for (hi, e) in v.enumerated() {
            if hi-1 >= 0 && input[vi][hi-1] <= e {
                continue
            }
            
            if hi+1 < hMax && input[vi][hi+1] <= e {
                continue
            }
                                   
            if vi-1 >= 0 && input[vi-1][hi] <= e {
                continue
            }
            
            if vi+1 < vMax && input[vi+1][hi] <= e {
                continue
            }
            lows.append("\(vi),\(hi)")
            height = height + e + 1
        }
    }
    //print(height) //572
    
    var largest = [[String]]()
    for low in lows {
        var checked = [String]()
        var next = [String]()
        next.append(low)
        
        while next.count > 0 {
            let n = next.removeFirst()
            guard !checked.contains(n) else { continue }
            checked.append(n)
            
            let hi = n.hi
            let vi = n.vi
            
            if hi-1 >= 0 && input[vi][hi-1] != 9 {
                let p = "\(vi),\(hi-1)"
                if !checked.contains(p) {
                    next.append(p)
                }
            }
            
            if hi+1 < input[vi].count && input[vi][hi+1] != 9 {
                let p = "\(vi),\(hi+1)"
                if !checked.contains(p) {
                    next.append(p)
                }
            }
                                   
            if vi-1 >= 0 && input[vi-1][hi] != 9 {
                let p = "\(vi-1),\(hi)"
                if !checked.contains(p) {
                    next.append(p)
                }
            }
            
            if vi+1 < vMax && input[vi+1][hi] != 9 {
                let p = "\(vi+1),\(hi)"
                if !checked.contains(p) {
                    next.append(p)
                }
            }
        }
        
        largest.append(checked)
    }
    
    largest.sort(by: ({ $0.count > $1.count }))
    let result = largest.prefix(3)
        .map { $0.count }
        .reduce(1, *)
    print(result) //847044
}


solve(content) //572

    





