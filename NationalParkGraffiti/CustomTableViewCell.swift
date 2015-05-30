//
//  CustomTableViewCell.swift
//  NationalParkGraffiti
//
//  Created by Laura Phelps on 5/30/15.
//  Copyright (c) 2015 Laura Phelps. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var customCellImage: UIImageView!
    @IBOutlet weak var customCellLocationLabel: UILabel!
    @IBOutlet weak var customCellDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
