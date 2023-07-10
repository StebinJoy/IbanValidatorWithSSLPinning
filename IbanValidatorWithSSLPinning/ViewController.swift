//
//  ViewController.swift
//  IbanValidatorWithSSLPinning
//
//  Created by Stebin Joy on 07/07/23.
//

import UIKit

enum VCIdentifier: String {
    case ibanValid = "ShowIbanDetailsViewController"
    case currencyList = "CurrencyListViewController"
}

class ViewController: UIViewController {
    
    @IBOutlet weak var ibanNumberText: UITextField!
    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var fromText: UITextField!
    @IBOutlet weak var toText: UITextField!
    @IBOutlet weak var indicatorView: UIView!
    
    let viewModel = IbanValidatorViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        indicatorView.isHidden = true
    }
    
    // MARK: - Common API Call
    private func doApiCallUsingPublicKeyPinning(baseURL: APIPath, callType: RequestMode, _ tail: String? = "", completion: @escaping (Bool) -> ()) {
        
        let url = baseURL.rawValue + (tail ?? "")
        viewModel.delegate = APIServices()
        indicatorView.isHidden = false
        viewModel.fetchAPI(base: url, type: callType) { value in
            DispatchQueue.main.async {
                self.indicatorView.isHidden = true
            }
           completion(value)
         
        }
        
    }
    
    // MARK: - Common ViewControl present
    func viewController<T: UIViewController>(_ vcClass: T.Type, identifier: VCIdentifier) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier.rawValue) as? T {
            if viewController is ShowIbanDetailsViewController {
                (viewController as! ShowIbanDetailsViewController).vm.ibanDetails = viewModel.ibanDetails
            }
            if viewController is CurrencyListViewController {
                (viewController as! CurrencyListViewController).vm.currency = viewModel.currency
                (viewController as! CurrencyListViewController).vm.convertedValue = viewModel.convertedValue
            }
            if let navigator = navigationController {
                navigator.present(viewController, animated: true)
            }
        }
    }
    
    
    // MARK: - Iban Valid Action
    @IBAction func IbanSubmit(_ sender: Any) {
        if viewModel.validIban(num: ibanNumberText.text) {
            doApiCallUsingPublicKeyPinning(baseURL: .iban, callType: .ivModel, ibanNumberText.text ?? "") { [weak self] isComplete in
                
                if isComplete && self?.viewModel.ibanDetails?.valid ?? false {
                    DispatchQueue.main.async {
                        self?.viewController(ShowIbanDetailsViewController.self, identifier: .ibanValid)
                    }
                }
                else {
                    self?.alertView(msg: "Invalid Iban Number")
                }
            }
        }
        else {
            alertView(msg: "Please enter valid Iban Number")
        }
    }
    
    // MARK: - Currency Convert Action
    @IBAction func CurrencyConvert(_ sender: Any) {
        if viewModel.validConvertDetails(toText.text, fromText.text, amountText.text ?? "") {
            let data = "to=\(toText.text ?? "")&from=\(fromText.text ?? "")&amount=\( amountText.text ?? "")"
            doApiCallUsingPublicKeyPinning(baseURL: .convert, callType: .convertInfo, data) { isComplete in
                
                    DispatchQueue.main.async {
                        if isComplete {
                            self.alertView(msg: "\(self.amountText.text!) \(self.fromText.text!) equals \(String(describing: (self.viewModel.convertModel?.result)!)) \(self.toText.text!)")
                    }
                    else {
                        self.alertView(msg: "Error Occured")
                    }
                }
            }
        }
        else {
            alertView(msg: "Please check your given details for convert")
        }
        
    }
    
    // MARK: - List All Currency
    @IBAction func ListAllCurrency(_ sender: Any) {
        doApiCallUsingPublicKeyPinning(baseURL: .listAll, callType: .allCurrency) { isComplete in
            if isComplete {
                DispatchQueue.main.async { [self] in
                    if self.viewModel.separatesCurrencyDetails() > 0 {
                        viewController(CurrencyListViewController.self, identifier: .currencyList)
                    }
                }
            }
        }
    }
    
}


extension ViewController {
    
    // MARK: - Alert View
    func alertView(msg: String?) {
        let alert = UIAlertController(title: "Message", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
