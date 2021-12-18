import Foundation

extension String {
    public func padZeros() -> String {
        let max = 4
        guard count < max else { return self }
        return String(repeating: "0", count: max - count) + self
    }
    
    public func toNumber() -> Int {
        Int(self, radix: 2)!
    }
    
    public subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
    
    public subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    public subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    public mutating func remove(_ k: Int) -> String {
        let s = prefix(k)
        removeFirst(k)
        return String(s)
    }
}
