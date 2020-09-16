//
//  CreateTableViewCell.swift
//  Quizzler
//
//  Created by Anselm Jade Jamig on 9/15/20.
//  Copyright © 2020 Anselm Jade Jamig. All rights reserved.
//

import UIKit

class CreateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    var myMutableStringTitle = NSMutableAttributedString()
    var myMutableStringDesc = NSMutableAttributedString()
    let titlePlaceholder  = "Give your quiz a title"
    let descriptionPlaceholder = "Quiz description"
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = bgView.frame.size.height/5
        bgView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        titleField.layer.cornerRadius = titleField.frame.size.height/2
        descriptionField.layer.cornerRadius = descriptionField.frame.size.height/2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
