import Foundation

let file = Bundle.main.url(forResource: "input", withExtension: "txt")!
let content = try! String(contentsOf: file, encoding: .utf8)
var fishes = content.components(separatedBy: ",").compactMap { Int($0.trimmingCharacters(in: .newlines)) }

print(fishes)
var spawnDays = [Int: Int]()
for f in fishes {
    if spawnDays[f] == nil {
        spawnDays[f] = 0
    }
    spawnDays[f]! += 1
}

print(spawnDays)

func calculate(_ days: Int) -> Int {
    for i in 1...256 {
    //    print(i)
        var newfish = [Int: Int]() //timer, count
        for (timer,count) in spawnDays {
            print(timer, count)
            if timer == 0 {
                if newfish[6] == nil {
                    newfish[6] = 0
                }
                newfish[6]! += count
                
                if newfish[8] == nil {
                    newfish[8] = 0
                }
                newfish[8]! += count
            } else {
                if newfish[timer-1] == nil {
                    newfish[timer-1] = 0
                }
                newfish[timer-1]! += count
            }
        }
        spawnDays = newfish
    }
    
    return spawnDays.values.reduce(0, +)
}




//print("Result: ", calculate(80)) //362740
print("Result: ", calculate(256)) //1644874076764


//part1 - 362740
