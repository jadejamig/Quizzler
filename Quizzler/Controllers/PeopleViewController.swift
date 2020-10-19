//
//  PeopleViewController.swift
//  Quizzler
//
//  Created by Anselm Jade Jamig on 10/16/20.
//  Copyright © 2020 Anselm Jade Jamig. All rights reserved.
//

import UIKit
import Firebase

class PeopleViewController: UIViewController {
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var authorName: String?
    var authorPhoto: UIImage?
    var authorUID: String?
    
    var quizArrayRef: [QuizModel] = []
    var quizArray: [QuizModel] = [] {
        didSet {
            self.tableView.reloadData()            
        }
    }
    //    var userPhoto: UIImage? = nil {
    //        didSet{
    //            self.tableView.reloadData()
    //        }
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "QuizCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.separatorStyle = .none
        self.userPhoto.layer.cornerRadius = self.userPhoto.frame.height/2
        self.userPhoto.image = self.authorPhoto
        self.userLabel.text = self.authorName
        self.loadQuizzes()
//        self.segue
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    private func loadQuizzes(){
        
        
        self.quizArrayRef.removeAll()
        if let uid = self.authorUID {
            
            let myQuizzesRef = db.collection("Quizzes").order(by: "lastUpdated", descending: true)
            let myQuizzes = myQuizzesRef.whereField("authorUID", isEqualTo: uid)
            myQuizzes.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("There was an error retrieving data \(error)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let author = data["author"] as? String,
                                let authorUID = data["authorUID"] as? String,
                                let title  = data["quizTitle"] as? String,
                                let desc = data["quizDescription"] as? String{
                                let quiz = QuizModel(title: title, description: desc, author: author, authorUID: authorUID)
                                self.quizArrayRef.append(quiz)
                            }
                        }
                        self.quizArray = self.quizArrayRef
                    }
                }
            }
        }
    }
    
}

extension PeopleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! QuizCellTableViewCell
        
        if quizArray[indexPath.row].title == "" {
            cell.titleLabel.text = "No Title"
        } else {
            cell.titleLabel.text = quizArray[indexPath.row].title
        }
        
        if quizArray[indexPath.row].description == "" {
            cell.descriptionLabel.text = "No Description"
        } else {
            cell.descriptionLabel.text = quizArray[indexPath.row].description
        }
        
        cell.userPhoto.image = self.authorPhoto
        cell.authorLabel.text = quizArray[indexPath.row].author.capitalized
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PeopleToQuiz", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! QuizViewController
        if let indexpath = tableView.indexPathForSelectedRow{
            destinationVC.author = quizArray[indexpath.row].authorUID
            destinationVC.quizTitle = quizArray[indexpath.row].title
            destinationVC.sentFromPeopleVc = true
        }
    }
    
}
