//
//  ShowIbanDetailsViewController.swift
//  IbanValidatorWithSSLPinning
//
//  Created by Stebin Joy on 08/07/23.
//

import UIKit

class ShowIbanDetailsViewController: UIViewController {

    @IBOutlet weak var ibanLabel: UILabel!
    @IBOutlet weak var accountNumber: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var bankCode: UILabel!
    
    let vm = IbanValidatorViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        displayData()
    }
    

    func displayData() {
        ibanLabel.text = vm.ibanDetails?.iban
        accountNumber.text = vm.ibanDetails?.ibanData?.accountNumber
        cityLabel.text = vm.ibanDetails?.bankData?.city
        countryLabel.text = vm.ibanDetails?.ibanData?.country
        bankCode.text = vm.ibanDetails?.ibanData?.bankCode
    }
    
    @IBAction func exitView(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

