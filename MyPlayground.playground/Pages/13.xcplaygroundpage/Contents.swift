import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
    .split(whereSeparator: \.isNewline)

class Dot: CustomStringConvertible, Equatable, Hashable {
    static func == (lhs: Dot, rhs: Dot) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine("\(x),\(y)")
    }
    
    var x: Int
    var y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    var description: String { "\(x),\(y)" }
}


let points = content.filter { $0.prefix(1) != "f" }
    .map { d -> Dot in
        let split = d.split(separator: ",")
        return Dot(Int(split[0])!, Int(split[1])!)
    }

let _folds = content.filter { $0.starts(with: "fold") }
    .compactMap({ f -> [String: Int]? in
        if let range = f.range(of: "y=") {
            return ["y": Int(String(f[range.upperBound..<f.endIndex]))!]
        }
        if let range = f.range(of: "x=") {
            return ["x": Int(String(f[range.upperBound..<f.endIndex]))!]
        }
        return nil
    })

//print(_folds)
//print(_dots)

func part1(_ input: [Dot], folds: [[String: Int]]) {
    
//    print(input)
//    print(folds)
    
    for f in folds {
//        print("f", f)
        if let fold = f["y"] {
            for row in 0..<input.count {
                let y = input[row].y

                if y == fold {
                    continue
                }

                if y > fold {
                    let dy = (y - fold) * 2
                    input[row].y = y - dy
                }
                
            }
        }
        
        if let fold = f["x"] {
            for row in 0..<input.count {
                let x = input[row].x

                if x == fold {
                    continue
                }

                if x > fold {
                    let dx = (x - fold) * 2

                    input[row].x = x - dx
                }
            }
        }
    }
    
    print(Set(input).count) //735
}

func part2(_ input: [Dot], folds: [[String: Int]]) {
    
//    print(input)
//    print(folds)
    
    for f in folds {
//        print("f", f)
        if let fold = f["y"] {
            for row in 0..<input.count {
                let y = input[row].y

                if y == fold {
                    continue
                }

                if y > fold {
                    let dy = (y - fold) * 2
                    input[row].y = y - dy
                }
                
            }
        }
        
        if let fold = f["x"] {
            for row in 0..<input.count {
                let x = input[row].x

                if x == fold {
                    continue
                }

                if x > fold {
                    let dx = (x - fold) * 2

                    input[row].x = x - dx
                }
            }
        }
    }
    
    let capitals = Set(input)
//    print(capitals)
    let maxX = capitals.reduce(Int.min, { max($0, $1.x) })
    let maxY = capitals.reduce(Int.min, { max($0, $1.y) })
    
    var line = ""
    for y in 0...maxY {
        for x in 0...maxX {
            if capitals.contains(Dot(x, y)) {
                line.append("##")
            } else {
                line.append("..")
            }
        }
        line.append("\n")
    }
    print(line) //UFRZKAUZ
}

part1(points, folds: [_folds.first!])
part2(points, folds: _folds)
