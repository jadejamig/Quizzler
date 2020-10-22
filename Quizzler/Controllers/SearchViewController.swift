//
//  SearchViewController.swift
//  Quizzler
//
//  Created by Anselm Jade Jamig on 10/2/20.
//  Copyright © 2020 Anselm Jade Jamig. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SearchViewController: UIViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var quizButton: UIButton!
    @IBOutlet weak var usersButton: UIButton!
    
    let db = Firestore.firestore()
    let storage = Storage.storage()

    var quizzesFieldSelected: Bool = true {
        didSet{
            self.reloadTableData()
        }
    }
    var userFieldSelected: Bool = false {
        didSet{
           self.reloadTableData()
            print(self.userArray)
            print("users photo count: \(self.usersPhotoArray.count)")
        }
    }

    var quizzesUserPhoto: [String:UIImage] = [:] {
        didSet{
            self.reloadTableData()
        }
    }

    var usersPhotoArray: [String:UIImage] = [:] {
        didSet{
            self.reloadTableData()
        }
    }
    
    var quizArrayRef: [QuizModel] = []
    var quizArray: [QuizModel] = [] {
        didSet {
            print("Search Complete")
            print(quizArray)
           self.reloadTableData()
        }
    }
    
    var userArrayRef: [UserModel] = []
    var userArray: [UserModel] = [] {
        didSet{
            
            print("users array count: \(self.userArrayRef.count)")
            self.reloadTableData()
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
        self.tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserReusableCell")
        self.tableView.separatorStyle = .none
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
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

    //MARK: - Query Firebase Methods
    
    private func searchQuizSubComp(searchKey: String){
        self.quizArrayRef.removeAll()
        self.quizzesUserPhoto.removeAll()
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
                                let authorUID = data["authorUID"] as? String,
                                let title  = data["quizTitle"] as? String,
                                let desc = data["quizDescription"] as? String,
                                let uid = data["authorUID"] as? String{
                                self.loadQuizUserPhoto(userUID: uid)
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
    private func searchUser(searchKey: String){
        self.userArrayRef.removeAll()
        self.usersPhotoArray.removeAll()
        if (Auth.auth().currentUser?.uid) != nil{
            
            let myQuizzesRef = db.collection("UsersInfo")
            let myQuizzes = myQuizzesRef.whereField("nameSubComp", arrayContains: searchKey)
            myQuizzes.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("There was an error retrieving data \(error)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            print("name subcomp contains search key")
                            if let email = data["userEmail"] as? String,
                                let name  = data["userName"] as? String,
                                let uid = data["userUID"] as? String{
                                self.loadUsersPhoto(userUID: uid)
                                let user = UserModel(userEmail: email, userName: name, userUID: uid)
                                self.userArrayRef.append(user)
                            }
                        }
                        self.userArray = self.userArrayRef
//                        self.usersPhotoArray = self.usersPhotoArrayRef
                    }
                }
            }
        }
        self.reloadTableData()
    }
    
    private func loadQuizUserPhoto(userUID: String){
        let storageRef = storage.reference()
        let photoRef = storageRef.child("\(userUID).jpg")
        photoRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                // Uh-oh, an error occurred!
                print("There was an error in retrieveing user photo \(error.localizedDescription)")
            } else {
                // Data for "images/island.jpg" is returned
                self.quizzesUserPhoto[userUID] = UIImage(data: data!)
            }
        }
    }
    private func loadUsersPhoto(userUID: String){
        let storageRef = storage.reference()
        let photoRef = storageRef.child("\(userUID).jpg")
        photoRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                // Uh-oh, an error occurred!
                print("There was an error in retrieveing user photo \(error.localizedDescription)")
            } else {
                // Data for "images/island.jpg" is returned
                self.usersPhotoArray[userUID] = UIImage(data: data!)
            }
        }
    }

    private func reloadTableData(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - TAble View Data Source Methods

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if quizzesFieldSelected{
            return self.quizArray.count
        } else {
            return self.userArray.count
        }
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
            if self.quizzesUserPhoto.count > indexPath.row{
                cell.userPhoto.image = self.quizzesUserPhoto[self.quizArray[indexPath.row].authorUID]
            }
            
            cell.authorLabel.text = quizArray[indexPath.row].author.capitalized
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserReusableCell", for: indexPath) as! UserTableViewCell
            cell.authorLabel.text = self.userArray[indexPath.row].userName.capitalized
            
            
            if self.usersPhotoArray.count > indexPath.row{
                cell.authorImageView.image = self.usersPhotoArray[self.userArray[indexPath.row].userUID]
            }
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.quizzesFieldSelected{
            performSegue(withIdentifier: "SearchToQuiz", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            performSegue(withIdentifier: "SearchToUser", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToQuiz"{
            let destinationVC = segue.destination as! QuizViewController
            if let indexpath = tableView.indexPathForSelectedRow{
                destinationVC.author = quizArray[indexpath.row].authorUID
                destinationVC.quizTitle = quizArray[indexpath.row].title
                destinationVC.sentFromPeopleVc = false
            }
        } else if segue.identifier == "SearchToUser"{
            let destinationVC = segue.destination as! PeopleViewController
            if let indexpath = tableView.indexPathForSelectedRow{
                destinationVC.authorName = self.userArray[indexpath.row].userName.capitalized
                destinationVC.authorUID = self.userArray[indexpath.row].userUID
                destinationVC.authorPhoto = self.usersPhotoArray[self.userArray[indexpath.row].userUID]
            }
        }
    }
}

//MARK: - Search View Delegate Methods

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchText = searchBar.text?.trimmingCharacters(in: .whitespaces) {
            if searchText != ""{
                self.searchQuizSubComp(searchKey: searchText.lowercased())
                self.searchUser(searchKey: searchText.lowercased())

            }
            
        }
        self.searchBar.endEditing(true)
    }
}
