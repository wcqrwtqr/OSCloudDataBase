//
//  MainPageTableViewCell.swift
//  OS CloudBase
//
//  Created by mohammed al-batati on 1/11/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//

import UIKit

class MainPageTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var snLabel: UILabel!
    @IBOutlet weak var assetCodeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
