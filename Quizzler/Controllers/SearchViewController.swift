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
    
    var quizzesFieldSelected: Bool = true {
        didSet{
            self.tableView.reloadData()
        }
    }
    var userFieldSelected: Bool = false {
        didSet{
            self.tableView.reloadData()
        }
    }

    let db = Firestore.firestore()
    let storage = Storage.storage()
    var userPhoto: UIImage? = nil {
        didSet{
            self.tableView.reloadData()
        }
    }
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
            self.quizzesFieldSelected = true
            self.userFieldSelected = false
        } else {
            self.usersButton.setTitleColor(self.view.tintColor, for: .normal)
            self.quizButton.setTitleColor(.white, for: .normal)
            self.quizzesFieldSelected = false
            self.userFieldSelected = true
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
                                let desc = data["quizDescription"] as? String,
                                let uid = data["authorUID"] as? String{
                                self.loadUserPhoto(userUID: uid)
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
    
    private func loadUserPhoto(userUID: String){
        let storageRef = storage.reference()
        let photoRef = storageRef.child("\(userUID).jpg")
        photoRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                // Uh-oh, an error occurred!
                print("There was an error in retrieveing user photo \(error.localizedDescription)")
            } else {
                // Data for "images/island.jpg" is returned
                self.userPhoto = UIImage(data: data!)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quizArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.quizzesFieldSelected{
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
            
            cell.userPhoto.image = self.userPhoto
            cell.authorLabel.text = quizArray[indexPath.row].author
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else {
            return UITableViewCell.init()
        }
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
