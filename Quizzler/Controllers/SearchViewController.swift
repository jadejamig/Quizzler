//
//  SearchViewController.swift
//  Quizzler
//
//  Created by Anselm Jade Jamig on 10/2/20.
//  Copyright © 2020 Anselm Jade Jamig. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var quizButton: UIButton!
    @IBOutlet weak var usersButton: UIButton!
    
    let db = Firestore.firestore()
    var quizArrayRef: [QuizModel] = []
        var quizArray: [QuizModel] = [] {
            didSet {
                print("Search Complete")
                print(quizArray)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //        tableView.separatorStyle = .none
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.searchTextField.backgroundColor = .white
        self.quizButton.setTitleColor(self.view.tintColor, for: .normal)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        self.tableView.register(UINib(nibName: "QuizCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")

        
    }
    @IBAction func reloadPressed(_ sender: UIButton) {
        self.tableView.reloadData()
    }
    
    @IBAction func fieldPressed(_ sender: UIButton) {
        
        if sender.currentTitle == "Quizzes"{
            self.quizButton.setTitleColor(self.view.tintColor, for: .normal)
            self.usersButton.setTitleColor(.white, for: .normal)
        } else {
            self.usersButton.setTitleColor(self.view.tintColor, for: .normal)
            self.quizButton.setTitleColor(.white, for: .normal)
        }
    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(true)
    //
    //        self.tabBarController?.tabBar.isHidden = true
    //    }
    
    private func searchQuizSubComp(searchKey: String){
        
        self.quizArrayRef.removeAll()
        if (Auth.auth().currentUser?.uid) != nil{
            let myQuizzesRef = db.collection("Quizzes").order(by: "lastUpdated", descending: true)
            let myQuizzes = myQuizzesRef.whereField("titleSubComp", arrayContains: searchKey)
            myQuizzes.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("There was an error retrieving data \(error)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                                if let author = data["author"] as? String,
                                   let title  = data["quizTitle"] as? String,
                                   let desc = data["quizDescription"] as? String{
                                       let quiz = QuizModel(title: title, description: desc, author: author)
                                    self.quizArrayRef.append(quiz)
                            }
                        }
                        self.quizArray = self.quizArrayRef
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        
        cell.authorLabel.text = quizArray[indexPath.row].author
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchText = searchBar.text?.trimmingCharacters(in: .whitespaces) {
            if searchText != ""{
                self.searchQuizSubComp(searchKey: searchText.lowercased())
                self.tableView.reloadData()
            }
            
        }
        self.searchBar.endEditing(true)
    }
}
