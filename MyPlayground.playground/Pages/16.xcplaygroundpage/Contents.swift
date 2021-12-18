import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
var input = try! String(contentsOf: file, encoding: .utf8)
    .trimmingCharacters(in: .whitespacesAndNewlines)
    .map { String(UInt(String($0), radix: 16)!, radix: 2).padZeros() }
    .reduce(into: "") { $0.append($1) }

func part1(_ message: inout String) -> Int {
    print("Message:", message)
    guard message.count > 0 else { return 0 }
    if Int(message, radix: 2) == 0 { message = ""; return 0 }
    let version = message.remove(3).toNumber()
    print("Version:", version)
    let packetType = message.remove(3).toNumber()
    print("packetType:", packetType)
    
    if packetType == 4 {
        var stop = false
        while stop == false {
            stop = message.remove(1) == "0"
            message.remove(4)
        }
        return version + part1(&message)
    }

    var sum = 0
    let bit = message.remove(1)
    if bit == "0" {
        _ = message.remove(15).toNumber()
        while message.count > 0 {
            sum += part1(&message)
        }
    } else {
        let length = message.remove(11).toNumber()
        for _ in 0..<length {
            sum += part1(&message)
        }
    }
    return version + sum
}

func part2(_ message: inout String) -> Int {
    //print("Message:", message)
//    if Int(message, radix: 2) == 0 { message = ""; return 0 }
    _ = message.remove(3).toNumber()
//    print("Version:", version)
    let packetType = message.remove(3).toNumber()
    //print("packetType:", packetType)
    
    if packetType == 4 {
        var stop = false
        var packet = ""
        while stop == false {
            stop = message.remove(1) == "0"
            packet += message.remove(4)
        }
        return packet.toNumber()
    }
    
    var packets = [Int]()
    let bit = message.remove(1)
    if bit == "0" {
        let packetLength = message.remove(15)
        //print("Zero", packetLength.toNumber())
        let t = message.count - packetLength.toNumber()
        while message.count != t  {
            let result = part2(&message)
            //print("Result:\t", result)
            packets.append(result)
        }
    } else {
        let length = message.remove(11).toNumber()
        //print("One", length)
        for _ in 0..<length {
            let result = part2(&message)
            //print("Result:\t", result)
            packets.append(result)
        }
    }
    
    print("Packets", packets)
    
    switch packetType {
    case 0:
        print("+")
        return packets.reduce(0, +)
    case 1:
        print("*")
        return packets.reduce(1, *)
    case 2:
        print("min")
        return packets.min()!
    case 3:
        print("max")
        return packets.max()!
    case 5:
        print(">")
        return packets[0] > packets[1] ? 1 : 0
    case 6:
        print("<")
        return packets[0] < packets[1] ? 1 : 0
    case 7:
        print("==")
        return packets[0] == packets[1] ? 1 : 0
    default:
        assertionFailure("Invalid ID")
        return 0
    }
}

//print(part1(&input)) //866
print(part2(&input))

