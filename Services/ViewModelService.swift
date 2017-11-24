
import Foundation
import RxSwift

protocol ViewModelServiceType {
    func sendRequestForValidating(creditCard: CreditCardModel) -> Observable<Bool>
    func generateCreditCardNumber() -> Observable<CreditCardModel>
    
}

struct ViewModelService: ViewModelServiceType {
    
    private let apiClientService = APIClientService.shared
    private let creditCardGenerator = CCGenerator.shared
    
    init() {
    }
    
    func sendRequestForValidating(creditCard: CreditCardModel) -> Observable<Bool> {
        return apiClientService.creditCardModelFor(cardNumber: creditCard.number!).flatMap({ (card) -> Observable<Bool> in
            guard let valid = card.valid else {
                return .just(false)
            }
            return .just(valid)
        })
    }
    
    func generateCreditCardNumber() -> Observable<CreditCardModel> {
        return Observable.create({ (observer) in
            let generatedCreditCardNumber = self.creditCardGenerator.generateVisaCreditCardNumber()
            observer.onNext(CreditCardModel(number: generatedCreditCardNumber))
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
}
