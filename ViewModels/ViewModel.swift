
import Foundation
import RxSwift
import Action

protocol ViewModelInputsType {
    var creditCardNumber: PublishSubject<String> {get}
    var generateValidCreditCard: PublishSubject<Void> {get}
}

protocol ViewModelOutputsType {
    // Outputs headers
    var creditCardIsValid: Observable<Bool> {get}
    var generatedCreditCard: Observable<CreditCardModel> {get}
}

protocol ViewModelActionsType {
    var generateCreditCard: Action<Void, CreditCardModel> {get}
    var performRequestValidatingCreditCard: Action<CreditCardModel, Bool> {get}
}

protocol ViewModelType: class {
    var inputs: ViewModelInputsType { get }
    var outputs: ViewModelOutputsType { get }
    var actions: ViewModelActionsType { get }
}

final class ViewModel : ViewModelType {
    
    var inputs: ViewModelInputsType { return self }
    var outputs: ViewModelOutputsType { return self }
    var actions: ViewModelActionsType { return self }
    
    // Setup
    private let viewModelService: ViewModelServiceType
    
    // Inputs
    var creditCardNumber: PublishSubject<String>
    var generateValidCreditCard: PublishSubject<Void>
    
    // Outputs
    var creditCardIsValid: Observable<Bool>
    var generatedCreditCard: Observable<CreditCardModel>
    
    var creditCardIsValidSubject = PublishSubject<Bool>()
    var generatedCreditCardSubject = PublishSubject<CreditCardModel>()
    
    private let disposeBag: DisposeBag
    
    init(service: ViewModelServiceType) {
        
        self.viewModelService = service
        self.disposeBag = DisposeBag()
        
        creditCardNumber = PublishSubject()
        generateValidCreditCard = PublishSubject()
        
        creditCardIsValid = creditCardIsValidSubject.asObservable()
        generatedCreditCard = generatedCreditCardSubject.asObservable()
        
        bindInputs()
        bindOutputs()
    }
    
    private func bindInputs() {
        creditCardNumber.asObservable()
            .map(deleteSpaces)
            .map(CreditCardModel.init)
            .bind(to: performRequestValidatingCreditCard.inputs)
            .disposed(by: disposeBag)
        
        generateValidCreditCard.asObservable()
            .debug()
            .bind(to: generateCreditCard.inputs)
            .disposed(by: disposeBag)
    }
    
    private func bindOutputs() {
        creditCardIsValid = performRequestValidatingCreditCard.elements
        generatedCreditCard = generateCreditCard.elements
    }
    
    lazy var generateCreditCard: Action<Void, CreditCardModel> = {
        return Action { [weak self] _ -> Observable<CreditCardModel> in
            guard let safeSelf = self else {return .empty()}
            return safeSelf.viewModelService.generateCreditCardNumber()
        }
    }()
    
    lazy var performRequestValidatingCreditCard: Action<CreditCardModel, Bool> = {
        return Action(workFactory: {[weak self] creditCard -> Observable<Bool> in
            guard let safeSelf = self else {return .just(false)}
            return safeSelf.viewModelService.sendRequestForValidating(creditCard: creditCard)
        })
    }()
    
    private func deleteSpaces(text: String) -> String {
        return text.replacingOccurrences(of: " ", with: "")
    }
}

extension ViewModel: ViewModelInputsType, ViewModelOutputsType, ViewModelActionsType { }


