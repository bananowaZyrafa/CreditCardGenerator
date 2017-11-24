
import Foundation

struct CreditCardModel {
    
    var number: String?
    var valid: Bool?
    
    init(number: String) {
        self.number = number
    }
    
    init(from any: Any) {
        guard let json = any as? [String: Any], let isValid = json["valid"] as? String else {
            return
        }
        self.valid = isValid == "true" 
    }
    
    init(cardModel: CreditCardModel) {
        if let number = cardModel.number {
            self.number = number
        }
        if let valid = cardModel.valid {
            self.valid = valid
        }
    }
    
    init(cardNumber: String, isValid: Bool) {
        self.number = cardNumber
        self.valid = isValid
    }
    
}
