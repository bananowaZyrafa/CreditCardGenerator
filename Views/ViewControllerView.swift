
import Foundation
import UIKit
extension ViewController {
    
     func setupViews() {
        
        cardNumberTextField.delegate = self
        expDateTextField.delegate = self
        CVVTextField.delegate = self
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .white
        cardNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        expDateTextField.translatesAutoresizingMaskIntoConstraints = false
        CVVTextField.translatesAutoresizingMaskIntoConstraints = false
        indicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        generateButton.translatesAutoresizingMaskIntoConstraints = false
        validateButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(cardNumberTextField)
        cardNumberTextField.placeholder = "Credit card number"
        cardNumberTextField.borderStyle = .roundedRect
        let ccleading = NSLayoutConstraint(item: cardNumberTextField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 8.0)
        let cctrailing = NSLayoutConstraint(item: cardNumberTextField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -8.0)
        let cctop = NSLayoutConstraint(item: cardNumberTextField, attribute: .topMargin, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 70.0)
        self.view.addConstraint(ccleading)
        self.view.addConstraint(cctrailing)
        self.view.addConstraint(cctop)
        
        view.addSubview(expDateTextField)
        expDateTextField.borderStyle = .roundedRect
        expDateTextField.placeholder = "Exp. date"
        let expLeading = NSLayoutConstraint(item: expDateTextField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 8.0)
        let expTop = NSLayoutConstraint(item: expDateTextField, attribute: .top, relatedBy: .equal, toItem: cardNumberTextField, attribute: .bottom, multiplier: 1.0, constant: 15.0)
        let expWidth = NSLayoutConstraint(item: expDateTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: self.view.layer.bounds.width * 0.4)
        self.view.addConstraint(expLeading)
        self.view.addConstraint(expTop)
        self.view.addConstraint(expWidth)
        
        view.addSubview(CVVTextField)
        CVVTextField.borderStyle = .roundedRect
        CVVTextField.placeholder = "CVV"
        let cvvTrailing = NSLayoutConstraint(item: CVVTextField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -8.0)
        let cvvTop = NSLayoutConstraint(item: CVVTextField, attribute: .top, relatedBy: .equal, toItem: cardNumberTextField, attribute: .bottom, multiplier: 1.0, constant: 15.0)
        let cvvWidth = NSLayoutConstraint(item: CVVTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: self.view.layer.bounds.width * 0.4)
        self.view.addConstraint(cvvTrailing)
        self.view.addConstraint(cvvTop)
        self.view.addConstraint(cvvWidth)
        
        
        view.addSubview(validateButton)
        validateButton.setTitle("VALIDATE", for: .normal)
        validateButton.setTitleColor(.red, for: .disabled)
        validateButton.setTitleColor(.white, for: .normal)
        validateButton.backgroundColor = .green
        validateButton.tintColor = .white

        let vbtnLeading = NSLayoutConstraint(item: validateButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 8.0)
        let vbtnTop = NSLayoutConstraint(item: validateButton, attribute: .top, relatedBy: .equal, toItem: expDateTextField, attribute: .bottom, multiplier: 1.0, constant: 15.0)
        let vbtnWidth = NSLayoutConstraint(item: validateButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: self.view.layer.bounds.width * 0.4)
        let vbtnHeight = NSLayoutConstraint(item: validateButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 40)
        self.view.addConstraint(vbtnLeading)
        self.view.addConstraint(vbtnTop)
        self.view.addConstraint(vbtnWidth)
        self.view.addConstraint(vbtnHeight)
        
        view.addSubview(generateButton)
        generateButton.setTitle("GENERATE", for: .normal)
        generateButton.backgroundColor = .red
        generateButton.tintColor = .white
        let gbtnTrailing = NSLayoutConstraint(item: generateButton, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -8.0)
        let gbtnTop = NSLayoutConstraint(item: generateButton, attribute: .top, relatedBy: .equal, toItem: CVVTextField, attribute: .bottom, multiplier: 1.0, constant: 15.0)
        let gbtnWidth = NSLayoutConstraint(item: generateButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: self.view.layer.bounds.width * 0.4)
        let gbtnHeight = NSLayoutConstraint(item: generateButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 40)
        self.view.addConstraint(gbtnTrailing)
        self.view.addConstraint(gbtnTop)
        self.view.addConstraint(gbtnWidth)
        self.view.addConstraint(gbtnHeight)
        
        view.addSubview(indicatorLabel)
        indicatorLabel.text = "Type in card number"
        indicatorLabel.numberOfLines = 1
        indicatorLabel.textAlignment = .center
        let lLeading = NSLayoutConstraint(item: indicatorLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 8.0)
        let lTrailing = NSLayoutConstraint(item: indicatorLabel, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -8.0)
        let lTop = NSLayoutConstraint(item: indicatorLabel, attribute: .top, relatedBy: .equal, toItem: validateButton, attribute: .bottom, multiplier: 1.0, constant: 15.0)
        self.view.addConstraint(lLeading)
        self.view.addConstraint(lTrailing)
        self.view.addConstraint(lTop)
        
        creditCardDataNotEmpty()
    }
    
    func presentAlertWith(message: String, handler: ((UIAlertAction) -> ())?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.tintColor = UIColor.blue
        let action = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    class func _cardNumberTextField() -> CardTextField {
        let textField = CardTextField()
        textField.type = .CardNumber
        textField.attributedPlaceholder  = NSAttributedString(string: "**** **** **** 1234", attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
        return textField
    }
    
    class func _expDateTextField() -> CardTextField {
        let textField = CardTextField()
        textField.type = .ExpirationDate
        textField.attributedPlaceholder  = NSAttributedString(string: "MM/YY", attributes: [NSAttributedStringKey.foregroundColor : UIColor.gray])
        return textField
    }
    
    class func _CVVTextField() -> CardTextField {
        let textField = CardTextField()
        textField.type = .CVC
        return textField
    }
    
    class func _validateButton() -> UIButton {
        
        let button = UIButton(type: .custom)
        
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    class func _generateButton() -> UIButton {
        
        let button = UIButton(type: .custom)
        
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    class func _indicatorLabel() -> UILabel {
        
        let label = UILabel()
        
        return label
    }
}
