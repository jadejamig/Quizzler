//
//  HomeViewController.swift
//  Quizzler
//
//  Created by Anselm Jade Jamig on 9/15/20.
//  Copyright © 2020 Anselm Jade Jamig. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class HomeViewController: UITableViewController{
    
    //    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
    let db = Firestore.firestore()
    let storage = Storage.storage()
    @IBOutlet weak var userIcom: UIBarButtonItem!
    var activityIndicatorAlert: UIAlertController?
    var quizArrayRef: [QuizModel] = []
    var quizArray: [QuizModel] = [] {
        didSet {
//            self.dismissActivityIndicatorAlert()
            self.hideAnimatedActivityIndicatorView()
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
               self.tabBarController?.tabBar.isHidden = false
            })
            
        }
    }
    var userPhoto: UIImage? = nil {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.register(UINib(nibName: "QuizCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        tableView.separatorStyle = .none
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.tabBarController?.tabBar.isHidden = true
        self.displayAnimatedActivityIndicatorView()
        loadQuizzes()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        self.displayActivityIndicatorAlert()
//        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        self.navigationController?.navigationController?.navigationBar.isHidden = true
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = true
//    }

    
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
        
        cell.userPhoto.image = self.userPhoto
        cell.authorLabel.text = quizArray[indexPath.row].author.capitalized
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    //MARK: - Table View Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "HomeToQuiz", sender: self)
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToQuiz"{
            let destinationVC = segue.destination as! QuizViewController
            if let indexpath = tableView.indexPathForSelectedRow{
                destinationVC.author = quizArray[indexpath.row].authorUID
                destinationVC.quizTitle = quizArray[indexpath.row].title
                
            }
        } else{
        }
    }
    
    
    
    //MARK: - IB Action Methods
    @objc func refresh(sender:AnyObject){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
           self.loadQuizzes()
        })
    }
    @IBAction func buttonPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let welcomeVC : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "Welcome")
            welcomeVC.navigationController?.tabBarController?.tabBar.isHidden = false
            navigationController?.viewControllers[0] = welcomeVC
            if let vc = navigationController?.viewControllers[0]{
                navigationController?.popToViewController(vc, animated: true)
            }
            print("logout successfuly")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func userIconPressed(_ sender: UIBarButtonItem) {
         performSegue(withIdentifier: "HomeToUser", sender: self)
    }
    
    
    //MARK: - Loading data from firestore
    
    private func loadQuizzes(){
        
        
        self.quizArrayRef.removeAll()
        let currentUserUID = Auth.auth().currentUser?.uid
        if let userUID = currentUserUID{
            //Download user photo
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
            
            let myQuizzesRef = db.collection("Quizzes").order(by: "lastUpdated", descending: true)
            let myQuizzes = myQuizzesRef.whereField("authorUID", isEqualTo: userUID)
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
        DispatchQueue.main.async {
            self.tableView.reloadData()
             self.refreshControl?.endRefreshing()
        }
        
    }
    
    //MARK: - Activity Indicator Methods

    func dismissActivityIndicatorAlert(){
        activityIndicatorAlert?.dismissActivityIndicator()
    }
    

    
}

