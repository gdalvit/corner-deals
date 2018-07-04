//
//  DealCell.swift
//  MagicCornerDeals
//
//  Created by Giorgio Dalvit on 02/07/18.
//  Copyright © 2018 Giorgio Dalvit. All rights reserved.
//

import UIKit

class DealCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var discount: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
