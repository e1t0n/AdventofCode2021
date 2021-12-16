import Foundation

struct Point: Hashable {
    var x: Int
    var y: Int
}

let file = Bundle.main.url(forResource: "sample", withExtension: "txt")!
let input = try! String(contentsOf: file, encoding: .utf8)
    .split(whereSeparator: \.isNewline)
let content = input
    .enumerated()
    .reduce(into: [Point: Int]()) { dict, e in
        let (y, line) = e
        line.enumerated().forEach { x, char in
            dict[Point(x: x, y: y)] = char.wholeNumberValue!
        }
    }

extension Dictionary where Key == Point, Value == Int {
    mutating func pop() -> (Point, Int)? {
        if let r = self.min(by: { $0.1 < $1.1 }) {
            removeValue(forKey: r.key)
            return r
        }
        return nil
    }
}

func part1(_ grid: [Point: Int]) -> Int? {
    var queue = [Point: Int]()
    var visited = Set<Point>()
    var lowestRisk = [Point: Int]()
    
    queue[Point(x: 0, y: 0)] = 0
    let maxY = input.count - 1
    let maxX = maxY
    
    while queue.count > 0 {
        guard let r = queue.pop() else { break }
        guard !visited.contains(r.0) else { continue }
        visited.insert(r.0)
        
        lowestRisk[r.0] = r.1
        let x = r.0.x
        let y = r.0.y
            
        if y+1 <= maxY {
            let p = Point(x: x, y: y+1)
            if queue[p] == nil {
                queue[p] = r.1 + grid[p]!
            }
        }
        
        if x+1 <= maxX {
            let p = Point(x: x+1, y: y)
            if queue[p] == nil {
                queue[p] = r.1 + grid[p]!
            }
        }
        
        if y-1 >= 0 {
            let p = Point(x: x, y: y-1)
            if queue[p] == nil {
                queue[p] = r.1 + grid[p]!
            }
        }
        
        if x-1 >= 0 {
            let p = Point(x: x-1, y: y)
            if queue[p] == nil {
                queue[p] = r.1 + grid[p]!
            }
        }
    }
    
    return lowestRisk[Point(x: maxX, y: maxY)]
}

struct PriorityPoint: Comparable {
    static func < (lhs: PriorityPoint, rhs: PriorityPoint) -> Bool {
        lhs.priority < rhs.priority
    }
    
    var point: Point
    var priority: Int
}

func part2(_ grid: [Point: Int]) -> Int? {
    var queue = PriorityQueue<(Point, Int)>(sort: { $0.1 < $1.1 })
    var visited = Set<Point>()
    var lowestRisk = [Point: Int]()
        
    queue.enqueue(element: (Point(x: 0, y: 0), 0))
    let Y = input.count
    let X = Y
    let YY = Y * 5
    let XX = X * 5
    print(YY, XX)
    
    func calcRisk(p: Point) -> Int {
        let x = p.x
        let y = p.y
        let dp = Point(x: x % X, y: y % Y)
        let dr = grid[dp]! + y/Y + x/X
        return (dr - 1) % 9 + 1
    }
    
    while !queue.isEmpty {
        guard let r = queue.dequeue() else { break }
        guard !visited.contains(r.0) else { continue }
        visited.insert(r.0)
        
        lowestRisk[r.0] = r.1

        let x = r.0.x
        let y = r.0.y
        
        if y == YY - 1 && x == XX - 1 { break }
        
        for (dy, dx) in [(0,1), (0,-1), (1,0), (-1,0)] {
            let yy = y + dy
            let xx = x + dx
            
            guard yy < YY, xx < XX, yy >= 0, xx >= 0 else { continue }
            
            let p = Point(x: xx, y: yy)
            let r = r.1 + calcRisk(p: p)
            
            queue.enqueue(element: (p, r))
        }
    }
    
    return lowestRisk[Point(x: XX-1, y: YY-1)]
}


//print("Part1: ", part1(content) ?? "Fail") //388
print("Part2: ", part2(content) ?? "Fail") //388







