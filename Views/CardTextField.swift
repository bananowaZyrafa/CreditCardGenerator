
import Foundation
import UIKit
import FormTextField

enum CardTextFieldType {
    case None
    case CardNumber
    case ExpirationDate
    case CVC
}

class CardTextField: FormTextField {
    @IBOutlet weak var nextField: UIResponder?
    
    public var type: CardTextFieldType? {
        didSet {
            guard let textFieldType = type else { return }
            switch textFieldType {
            case .CardNumber:
                inputType = .integer
                formatter = CardNumberFormatter()
                var validation = Validation()
                validation.maximumLength = "1234 5678 1234 5678 901".count
                validation.minimumLength = "1234 5678 1234 5".count
                let characterSet = NSMutableCharacterSet.decimalDigit()
                characterSet.addCharacters(in: " ")
                validation.characterSet = characterSet as CharacterSet
                inputValidator = InputValidator(validation: validation)
                self.inputValidator = inputValidator
                break
            case .CVC:
                inputType = .integer
                var validation = Validation()
                validation.maximumLength = "CVVC".count
                validation.minimumLength = "CVV".count
                validation.characterSet = NSCharacterSet.decimalDigits
                let inputValidator = InputValidator(validation: validation)
                self.inputValidator = inputValidator
                break
            case .ExpirationDate:
                inputType = .integer
                formatter = CardExpirationDateFormatter()
                let validation = Validation()
                let inputValidator = CardExpirationDateInputValidator(validation: validation)
                self.inputValidator = inputValidator
                break
            default:
                break
            }
        }
    }
    
}
