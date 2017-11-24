
import Foundation
final class CCGenerator {
    
    private var creditCardNumber: [Int]!
    private var cardNumberLength: Int!
    
    static let shared = CCGenerator()
    private init() {}
    
    private func isCreditCardNumberValid(numberArray: [Int]) -> Bool {
        let sum = creditCardNumberChecksum(array: numberArray)
        return sum > -1 ? sum % 10 == 0 : false
    }
    
    private func creditCardNumberChecksum(array: [Int]) -> Int {
        guard let _ = array.last else {
            return -1
        }
        var numberArray = array
        numberArray.removeLast()
        return Array(numberArray.reversed())
            .enumerated()
            .map { (offset, element) -> Int in
                if offset.isEven() {
                    return element * 2
                }
                return element
            }
            .map{ element -> Int in
                if element > 9 {
                    return element - 9
                }
                return element
            }
            .reduce(0, +)
    }
    
    
    private func generateVisaCreditCard(_ length: Int) -> [Int] {
        var digits: [Int] = []
        for _ in 0..<(length - 1) {
            digits.append(Int(arc4random_uniform(10)))
        }
        digits.insert(4, at: 0)
        let checkSum = creditCardNumberChecksum(array: digits)
        var modulo = checkSum % 10
        if modulo > 0 {
            modulo = 10 - modulo
        }
        digits.removeLast()
        digits.append(modulo)
        return digits
    }
    
    func generateVisaCreditCardNumber() -> String {
        let generatedCreditCardNumberArray = generateVisaCreditCard(13)
        let number = generatedCreditCardNumberArray.flatMap{
            return "\($0)"
        }.reduce("",+)
        return number
    }
    
}
