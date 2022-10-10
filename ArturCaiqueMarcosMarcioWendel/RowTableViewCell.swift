//
//  RowTable.swift
//  ArturCaiqueMarcosMarcioWendel
//
//  Created by Artur Clemente on 10/10/22.
//

import UIKit

class RowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelTelefone: UILabel!
    
    func configure(with toyItem:ToyItem) {
        labelTitle.text = toyItem.name
        labelTelefone.text = toyItem.telephone
    }
}
