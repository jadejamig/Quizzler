//
//  QuestionTableViewCell.swift
//  Quizzler
//
//  Created by Anselm Jade Jamig on 9/16/20.
//  Copyright © 2020 Anselm Jade Jamig. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var choiceA: UITextField!
    @IBOutlet weak var choiceB: UITextField!
    @IBOutlet weak var choiceC: UITextField!
    @IBOutlet weak var choiceD: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 10
        textView.layer.cornerRadius = 10
        choiceA.layer.cornerRadius = choiceA.frame.size.height/2
        choiceB.layer.cornerRadius = choiceB.frame.size.height/2
        choiceC.layer.cornerRadius = choiceC.frame.size.height/2
        choiceD.layer.cornerRadius = choiceD.frame.size.height/2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
