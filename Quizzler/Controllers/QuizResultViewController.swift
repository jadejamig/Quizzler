//
//  QuizResultViewController.swift
//  Quizzler
//
//  Created by Anselm Jade Jamig on 9/25/20.
//  Copyright © 2020 Anselm Jade Jamig. All rights reserved.
//

import UIKit

class QuizResultViewController: UIViewController {
    
    @IBOutlet weak var retakeQuizButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var resultRemarkLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var remark: String = ""
    var numOfItems: Int = 0
    var userScore: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRemark()
        
        self.resultRemarkLabel.text = self.remark
        
        self.scoreLabel.text = "\(self.userScore) / \(self.numOfItems)"
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //
    }
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(true)
            self.navigationController?.navigationBar.isHidden = false
        }
    
    private func getRemark(){
        let scorePercentage = (Float(self.userScore) / Float(self.numOfItems)) * 100
        if scorePercentage <= 79 {
            self.remark = "Try Harder!"
        } else if scorePercentage <= 89 {
            self.remark = "Good Job!"
        } else {
            self.remark = "Excellent!"
        }
    }
    
    
    @IBAction func retakeButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homeButtonPressed(_ sender: UIButton) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: true)
    }
}
