//
//  CurrencyTableViewCell.swift
//  IbanValidatorWithSSLPinning
//
//  Created by Stebin Joy on 08/07/23.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
