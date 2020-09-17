//
//  HomeViewController.swift
//  Quizzler
//
//  Created by Anselm Jade Jamig on 9/15/20.
//  Copyright © 2020 Anselm Jade Jamig. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    
    var quizArray: [QuizModel] = [
            QuizModel(title: "Biology",
                      description: "bruh",
                      author: "Jade Jamig"),
            QuizModel(title: "Purp Comm",
                      description: "m1s1 formative",
                      author: "Jade Jamig")]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "QuizCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.separatorStyle = .none
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quizArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! QuizCellTableViewCell
            
            cell.titleLabel.text = quizArray[indexPath.row].title
            cell.descriptionLabel.text = quizArray[indexPath.row].description
            cell.authorLabel.text = quizArray[indexPath.row].author

            return cell
        }
    

}
