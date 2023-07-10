//
//  CurrentListViewController.swift
//  IbanValidatorWithSSLPinning
//
//  Created by Stebin Joy on 08/07/23.
//

import UIKit

class CurrencyListViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currencyTable: UITableView!

    var info : String? {
            return "1 KWD equal to"
    }
    let vm = IbanValidatorViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = info
        currencyTable.delegate = self
        currencyTable.dataSource = self
    }


    @IBAction func exitAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}


extension CurrencyListViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.currency.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = currencyTable.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.identifier, for: indexPath) as? CurrencyTableViewCell else {
            fatalError("Could not cast cell")
        }
        cell.currencyLabel.text = vm.currency[indexPath.row]
        cell.amountLabel.text = String(vm.convertedValue[indexPath.row])
        
        return cell
    }
    
    
}
