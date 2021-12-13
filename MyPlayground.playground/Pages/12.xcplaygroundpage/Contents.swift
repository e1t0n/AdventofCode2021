import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
var input = try! String(contentsOf: file, encoding: .utf8)
    .split(whereSeparator: \.isNewline)

var caves = [String: Set<String>]()

for i in input {
    let p1 = i.components(separatedBy: "-")[0]
    let p2 = i.components(separatedBy: "-")[1]
    if caves[p1] != nil {
        caves[p1]!.insert(p2)
    } else {
        caves[p1] = [p2]
    }
    
    if caves[p2] != nil {
        caves[p2]!.insert(p1)
    } else {
        caves[p2] = [p1]
    }
}

extension String {
    var isEnd: Bool {
        self == "end"
    }
    
    var isStart: Bool {
        self == "start"
    }
    
    var isSmall: Bool {
        if isEnd || isStart { return false }
        return self == self.lowercased()
    }
}

print(caves)

func part1() {
    var visited = Set<String>()
    var paths = 0

    func buildPath(cave: String) {
        if cave.isEnd {
            paths += 1
            return
        }
        
        if visited.contains(cave) {
            return
        }
        
        if cave.isSmall {
            visited.insert(cave)
        }
        
        if let child = caves[cave] {
            for node in child {
                if node.isStart { continue }
                buildPath(cave: node)
            }
        }
        
        if cave.isSmall {
            visited.remove(cave)
        }
    }

    buildPath(cave: "start")
    //print("Visited: ", visited)
    print("Paths: ", paths)
}

func part2() {
    var visited = [String: Int]()
    var paths = 0

    func buildPath(cave: String) {
        if cave.isEnd {
            paths += 1
            return
        }
        
        if cave.isSmall {
            if visited[cave] == nil {
                visited[cave] = 0
            }
            visited[cave]! += 1
            
            var moreThanOnce = 0
            for (k,v) in visited {
                if v > 1 {
                    moreThanOnce += 1
                }
                
                if visited[k]! > 2 { visited[cave]! -= 1; return }
            }
            if moreThanOnce > 1 { visited[cave]! -= 1; return }
        }
        
        if let child = caves[cave] {
            for node in child {
                if node.isStart { continue }
                buildPath(cave: node)
            }
        }
        
        if cave.isSmall {
            visited[cave]! -= 1
        }
    }

    buildPath(cave: "start")
    print("Visited: ", visited)
    print("Paths: ", paths)
}

//part1() //5254
part2()



