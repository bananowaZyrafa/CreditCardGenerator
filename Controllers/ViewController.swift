
import UIKit
import RxSwift
import RxCocoa
import Action
import RxOptional

class ViewController: UIViewController, BindableType {
    
    var cardNumberTextField = ViewController._cardNumberTextField()
    var expDateTextField    = ViewController._expDateTextField()
    var CVVTextField        = ViewController._CVVTextField()
    var validateButton      = ViewController._validateButton()
    var generateButton      = ViewController._generateButton()
    var indicatorLabel      = ViewController._indicatorLabel()
    
    private let disposeBag = DisposeBag()
    var viewModel: ViewModelType!
    
    func bindViewModel() {
        bindLoading()
        bindErrorsDisplay()
        
        generateButton.rx.tap
            .asObservable()
            .bind(to: viewModel.inputs.generateValidCreditCard)
            .disposed(by: disposeBag)
        
        viewModel.outputs.generatedCreditCard
            .map{$0.number}
            .filterNil()
            .asDriver(onErrorJustReturn: "")
            .drive(onNext:{ [weak self] text in
                self?.cardNumberTextField.text = text
                self?.cardNumberTextField.sendActions(for: .allEditingEvents)
            })
            .disposed(by: disposeBag)
        
        viewModel.outputs.creditCardIsValid
            .asDriver(onErrorJustReturn: false)
            .map(setValidForIndicatorLabel)
            .drive(indicatorLabel.rx.text)
            .disposed(by: disposeBag)
        
        let textFieldObservable = Observable.combineLatest(
            cardNumberTextField.rx.text,
            expDateTextField.rx.text,
            CVVTextField.rx.text,
            resultSelector: { number, date, cvv in
                return number ?? ""
        })
        
        validateButton.rx.tap
            .withLatestFrom(textFieldObservable)
            .bind(to: viewModel.inputs.creditCardNumber)
            .disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func bindLoading() {
        viewModel.actions.performRequestValidatingCreditCard.executing
            .asDriver(onErrorJustReturn: false)
            .filter{
                return $0 != false
            }
            .drive(onNext: { [weak self] (isLoading) in
                guard let safeSelf = self else {return}
                safeSelf.indicatorLabel.text = "Processing..."
            }).disposed(by: disposeBag)
    }
    
    private func bindErrorsDisplay() {
        viewModel.actions.performRequestValidatingCreditCard.errors
            .asDriver(onErrorJustReturn: ActionError.underlyingError(NSError(domain: "Error in loading error", code: -1000, userInfo: nil)))
            .drive(onNext: { [weak self] (error) in
                self?.presentAlertWith(message: error.localizedDescription, handler: nil)
            }).disposed(by: disposeBag)
    }
    
    private func setValidForIndicatorLabel(valid: Bool) -> String {
        return valid ? "Credit card number is VALID" : "Credit card number is NOT VALID"
    }
    
}

private typealias Validation = ViewController
extension Validation {
    
    func creditCardDataNotEmpty() {
        let number: Observable<Bool> = cardNumberTextField.rx.text
            .map{ text -> Bool in
                guard let text = text else {return false}
                return 13..<20 ~= text.count
            }.share(replay: 1)
        let date: Observable<Bool> = expDateTextField.rx.text.map{ text -> Bool in
            text?.count == 5
            }.share(replay: 1)
        let ccv: Observable<Bool> = CVVTextField.rx.text.map { text -> Bool in
            guard let text = text else {return false}
            return 3...4 ~= text.count
            }.share(replay: 1)
        
        let everythingValid: Observable<Bool> = Observable.combineLatest(number, date, ccv) {
            $0 && $1 && $2
        }
        
        everythingValid.bind(to: validateButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maximumLength = 0
        if textField === cardNumberTextField {
            maximumLength = 19
        }
        else if textField === CVVTextField {
            maximumLength = 4
        }
        else {
            maximumLength = 5
        }
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= maximumLength
    }
    
}
