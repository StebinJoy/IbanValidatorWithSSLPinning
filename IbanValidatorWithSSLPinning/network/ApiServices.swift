//
//  ApiServices.swift
//  IbanValidatorWithSSLPinning
//
//  Created by Stebin Joy on 07/07/23.
//

import Foundation
import CommonCrypto

enum APIError: Error {
    case internalError
    case serverError
    case parsingError
    
}

enum Method: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum APIPath: String {
    case listAll = "https://api.apilayer.com/fixer/latest?symbols=&base=KWD"
    case iban = "https://api.apilayer.com/bank_data/iban_validate?iban_number="
    case convert = "https://api.apilayer.com/fixer/convert?"
}


class APIServices: NSObject {

    private let publicKey = "5yPqMVf9QPWRl57seflq21zJXwu5D3q9myy4HiFi6LE="
    
    private let rsa2048Asn1Header:[UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ]
    
    fileprivate func sha256(data : Data) -> String {
        var keyWithHeader = Data(rsa2048Asn1Header)
        keyWithHeader.append(data)
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        
        keyWithHeader.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(keyWithHeader.count), &hash)
        }
        return Data(hash).base64EncodedString()
    }
    
    
    func request<T: Codable>(url: String?,method: Method,excepting:T.Type,completion: @escaping (Result<T,APIError>) -> Void) {
        
        guard let url = URL(string: url ?? "")
        else {
            completion(.failure(.internalError));
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"
        request.allHTTPHeaderFields = ["content-Type": "application/json"]
        request.addValue("MH41TDmnd8lYmCRJwAsOuPAEFNXdNAPI", forHTTPHeaderField: "apikey")
        
        var session: URLSession?
        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        let task = session?.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    print("Error with fetching films: \(error)")
                    completion(.failure(.serverError))
                } else {
                    completion(.failure(.serverError))
                }
                return
            }
            
            do {
                let result =  try JSONDecoder().decode((T.self), from: data)
                completion(.success(result))
            }
            catch {
                completion(.failure(.parsingError))
            }
        }
        task?.resume()
    }
}


extension APIServices: ServiceRequestDelegate {
    
    func randomIbanRequest(path: String?, completion: @escaping ((Result<IVModel, APIError>) -> Void)) {
        request(url: path, method: .get, excepting: IVModel.self) { response in
            switch response {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func randomCurrencyConvertRequest(path: String?, completion: @escaping ((Result<ConvertInfo, APIError>) -> Void)) {
        request(url: path, method: .get, excepting: ConvertInfo.self) { response in
            switch response {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func randomCurrencyListRequest(path: String?, completion: @escaping ((Result<AllCurrency, APIError>) -> Void)) {
        request(url: path, method: .get, excepting: AllCurrency.self) { response in
            switch response {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

extension APIServices: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        //Create a server trust
        guard let serverTrust = challenge.protectionSpace.serverTrust, let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        if let serverPublicKey = SecCertificateCopyKey(certificate), let serverPublicKeyData = SecKeyCopyExternalRepresentation(serverPublicKey, nil) {
            
            let data: Data = serverPublicKeyData as Data
            let serverHashKey = sha256(data: data)
            
            //comparing server and local hash keys
            if serverHashKey == publicKey {
                let credential: URLCredential = URLCredential(trust: serverTrust)
                print("Public Key pinning is successfull")
                completionHandler(.useCredential, credential)
            } else {
                print("Public Key pinning is failed")
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        }
    }
}
