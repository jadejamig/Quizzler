//
//  BookmarkViewController.swift
//  Quizzler
//
//  Created by Anselm Jade Jamig on 10/21/20.
//  Copyright © 2020 Anselm Jade Jamig. All rights reserved.
//

import UIKit
import Firebase

class BookmarkViewController: UITableViewController {
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    private var bookmarkKeys: [String] = [] {
        didSet{
            
            self.iterateBookmarkKeys()
        }
    }
    private var bookmarkDict: [String:String] = [:] {
        didSet{
            self.bookmarkKeys = Array(bookmarkDict.keys).sorted()
        }
    }
    
    var quizArrayRef: [QuizModel] = []
    var quizArray: [QuizModel] = [] {
        didSet {
                        self.tableView.reloadData()
        }
    }
    var quizzesUserPhoto: [String:UIImage] = [:] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    //MARK: - VC Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        tableView.register(UINib(nibName: "QuizCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.separatorStyle = .none
        self.loadBookmark()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    //MARK: - FireStore retrieving data methods
    
    private func loadBookmark(){
        if let userUID = Auth.auth().currentUser?.uid {
            let bookmarkRef = db.collection("Bookmarks").document(userUID)
            bookmarkRef.getDocument { (querySnapshot, error) in
                if let error = error {
                    print("There was an error retrieving bookmarks \(error.localizedDescription)")
                } else {
                    if let data = querySnapshot?.data() {
                        if let retSavedQuiz = data["savedQuiz"] as? [String:String]{
                            self.bookmarkDict = [String:String](uniqueKeysWithValues: retSavedQuiz.sorted( by: { $0.0 < $1.0 }))
                            print("Successfully retrieved bookmarks")
                        }
                    }
                }
            }
        }
    }
    private func iterateBookmarkKeys(){
        
        self.quizArrayRef.removeAll()
        self.quizzesUserPhoto.removeAll()
        for i in 0 ..< self.bookmarkKeys.count{
            self.loadQuiz(uid: bookmarkDict[bookmarkKeys[i]]!, title: bookmarkKeys[i])
        }
        
    }
    
    private func loadQuiz(uid: String, title: String){
        
        let quizRef = db.collection("Quizzes")
            .whereField("authorUID", isEqualTo: uid)
            .whereField("quizTitle", isEqualTo: title)
        quizRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("There was an error retrieving data \(error)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    let document = snapshotDocuments[0]
                    let data = document.data()
                    if let author = data["author"] as? String,
                        let authorUID = data["authorUID"] as? String,
                        let title  = data["quizTitle"] as? String,
                        let desc = data["quizDescription"] as? String{
                        self.loadQuizUserPhoto(userUID: uid)
                        let quiz = QuizModel(title: title, description: desc, author: author, authorUID: authorUID)
                        self.quizArrayRef.append(quiz)
                        self.quizArray = self.quizArrayRef
                    }
                }
            }
        }
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
    
    //MARK: - Refresh Control Method
    @objc func refresh(sender:AnyObject){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
           self.loadBookmark()
            DispatchQueue.main.async {
                 self.refreshControl?.endRefreshing()
            }
        })
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quizArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        print("array count: \(self.quizzesUserPhoto.count) \n index path row: \(indexPath.row)")
        if self.quizzesUserPhoto.count >= indexPath.row{
            cell.userPhoto.image = self.quizzesUserPhoto[self.quizArray[indexPath.row].authorUID]
        }
        cell.authorLabel.text = quizArray[indexPath.row].author.capitalized
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
}
