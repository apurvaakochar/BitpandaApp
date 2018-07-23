//
//  CoinCell.swift
//  Bitpanda
//
//  Created by Apurva Kochar on 7/20/18.
//  Copyright © 2018 Bitpanda. All rights reserved.
//

import UIKit

class CoinCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.masksToBounds = true
        backView.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
