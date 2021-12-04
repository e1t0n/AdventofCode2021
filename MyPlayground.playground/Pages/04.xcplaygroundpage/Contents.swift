import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
var bingo = content.split(whereSeparator: \.isNewline).map { String($0) }

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

let _draws = bingo.removeFirst().split(separator: ",").compactMap { Int($0) }

class Row: CustomStringConvertible, Equatable {
    var value: Int
    var marked: Bool
    
    init(value: Int, marked: Bool) {
        self.value = value
        self.marked = marked
    }
    
    var description: String {
        return "\(value): \(marked)"
    }
    
    static func ==(lhs: Row, rhs: Row) -> Bool {
        lhs.value == rhs.value && lhs.marked == rhs.marked
    }
}

class Board: CustomStringConvertible, Equatable {
    var rows: [[Row]]
    
    init(rows: [[Row]]) {
        self.rows = rows
    }
    
    var description: String {
        rows.description
    }
    
    var allRowsMarked: Bool {
        for row in rows {
            if row.filter({$0.marked}).count == 5 {
                return true
            }
        }
        return false
    }
    
    var allColumnsMarked: Bool {
        for column in 0..<5 {
            var marked = true
            for row in rows {
                if !row[column].marked {
                    marked = false
                    break
                }
            }
            if marked {
                return true
            }
        }
        return false
    }
    
    var hasWon: Bool {
        return allRowsMarked || allColumnsMarked
    }
    
    func score(_ drawn: Int) -> Int {
        var _sum: Int = 0
        for row in rows {
            for element in row {
                if element.marked == false {
                    _sum += element.value
                }
            }
        }
        return _sum * drawn
    }
    
    static func ==(lhs: Board, rhs: Board) -> Bool {
        lhs.rows == rhs.rows
    }
}

func getBoards() -> [Board] {
    var boards = [Board]()
    
    bingo.chunked(into: 5).forEach { board in
        var rows = [[Row]]()
        for row in board {
            var rowElement = [Row]()
            let elements = row.split(separator: " ").compactMap { Int($0) }
            for element in elements {
                rowElement.append(Row(value: element, marked: false))
            }
            rows.append(rowElement)
        }
        boards.append(Board(rows: rows))
    }
    return boards
}

func getWinningBoard(_ boards: [Board], _ draws: [Int]) -> (Board?, Int) {
    for drawn in draws {
        for board in boards {
            for row in board.rows {
                for element in row {
                    if element.value == drawn {
                        element.marked = true
                    }

                    if board.hasWon {
                        return (board, drawn)
                    }
                }
            }
        }
    }
    return (nil, 0)
}

func part1() {
    let win = getWinningBoard(getBoards(), _draws)
    if let board = win.0 {
        print(board.score(win.1))
    }
}

func findLastToWin(_ boards: [Board], _ draws: [Int]) -> (Board?, Int) {
    let win = getWinningBoard(boards, draws)
    if let board = win.0 {
        if boards.count == 1 {
            return win
        }
        let index = draws.firstIndex(of: win.1)!
        
        return findLastToWin(boards.filter({ $0 != board }), Array(draws[index..<draws.count]))
    }
    return (nil, 0)
}

func part2() {
    let last = findLastToWin(getBoards(), _draws)
    print(last.0!.score(last.1))
}

part1()
part2()




