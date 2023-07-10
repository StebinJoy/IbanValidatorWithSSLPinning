//
//  IbanValidatorViewModel.swift
//  IbanValidatorWithSSLPinning
//
//  Created by Stebin Joy on 07/07/23.
//

import Foundation

protocol ServiceRequestDelegate: AnyObject {

    func randomIbanRequest(path: String?, completion: @escaping((Result<IVModel, APIError>) -> Void))
    func randomCurrencyConvertRequest(path: String?, completion: @escaping((Result<ConvertInfo, APIError>) -> Void))
    func randomCurrencyListRequest(path: String?, completion: @escaping((Result<AllCurrency, APIError>) -> Void))
}

enum RequestMode {
    case ivModel
    case convertInfo
    case allCurrency
    
}

class IbanValidatorViewModel {
    
    var ibanDetails: IVModel?
    var allCurrency: AllCurrency?
    var convertModel: ConvertInfo?
    var delegate: ServiceRequestDelegate?
    var currency = [String]()
    var convertedValue = [Double]()

    
    func fetchAPI(base: String?, type: RequestMode, completion: @escaping (Bool) -> ()) {

        switch type {
            
        case .ivModel:
            delegate?.randomIbanRequest(path: base, completion: { [weak self] result in
                switch result {
                case .success(let data):
                    self?.ibanDetails = data
                    completion(true)
                case .failure(let error):
                    print(error)
                    completion(false)
                }
            })
        case .convertInfo:
            delegate?.randomCurrencyConvertRequest(path: base, completion: { [weak self] result in
                switch result {
                case .success(let data):
                    self?.convertModel = data
                    completion(true)
                case .failure(let error):
                    print(error)
                    completion(false)
                }
            })
        case .allCurrency:
            delegate?.randomCurrencyListRequest(path: base, completion: { [weak self] result in
                switch result {
                case .success(let data):
                    self?.allCurrency = data
                    completion(true)
                case .failure(let error):
                    print(error)
                    completion(false)
                }
            })
        }

    }
    
    //Validation
    func validIban(num: String?) -> Bool {
        guard let count = num?.count, count > 20, count < 25 else {
            return false
        }
        return true
    }
    
    func validConvertDetails(_ to: String?,_ from: String?,_ amount: String) -> Bool {
        if isNumberRegex(string: amount), to?.count == 3, from?.count == 3 {
            return true
        }
        return false
    }
    
    func isNumberRegex(string: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: "^[-+]?[0-9]*\\.?[0-9]+([eE][-+]?[0-9]+)?$")
        return regex?.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count)) != nil
    }
    
    //Count
    func separatesCurrencyDetails() -> Int {
        guard ((allCurrency?.rates.map ({ a,b in
            currency.append(a)
            convertedValue.append(b)
        })) != nil) else {
            return 0
        }
        return currency.count
    }
    
}


