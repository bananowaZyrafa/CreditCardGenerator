
import Foundation
import RxSwift

protocol APIClientServiceType {
    func creditCardModelFor(cardNumber: String) -> Observable<CreditCardModel>
}

final class APIClientService {
    
    private let baseURL = "https://api.bincodes.com/cc/"
    private let apiKey = "5232a9bca11e25c0f8eb4313ff2644be"
    private let format = "json"
    
    
    //https://api.bincodes.com/cc/[FORMAT]/[API_KEY]/[CC]/
    
    static let shared = APIClientService()
    private init() { }
    
    private func requestURLFor(creditCard number: String) -> URL? {
        let url = URL(string: baseURL + "\(format)/" + "\(apiKey)/" + "\(number)/")
        return url
    }
}

extension APIClientService: APIClientServiceType {
    
    private func jsonForRequestWith(cardNumber: String) -> Observable<Any> {
        guard let requestURL = requestURLFor(creditCard: cardNumber) else {
            return .empty()
        }
        return URLSession.shared.rx.json(url: requestURL)
    }
    
    func creditCardModelFor(cardNumber: String) -> Observable<CreditCardModel> {
        return jsonForRequestWith(cardNumber: cardNumber)
            .map(CreditCardModel.init)
    }
    
   
}

