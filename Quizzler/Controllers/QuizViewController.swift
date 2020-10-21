//
//  QuizViewController.swift
//  Quizzler
//
//  Created by Anselm Jade Jamig on 9/21/20.
//  Copyright © 2020 Anselm Jade Jamig. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class QuizViewController: UIViewController {
    
    let db = Firestore.firestore()
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var scoreLAbel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var choice1Button: UIButton!
    @IBOutlet weak var choice2Button: UIButton!
    @IBOutlet weak var choice3Button: UIButton!
    @IBOutlet weak var choice4Button: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var bookmarkButton: UIBarButtonItem!
    
    var author: String? = nil
    var quizTitle: String? = nil
    var sentFromPeopleVc: Bool = false
    private var quizDict: [String: [String]] = [:]
    private var quizQuestions: [String] = []
    private var score: Int = 0
    private var isQuizBookmarked: Bool = false {
        didSet{
            if self.isQuizBookmarked{
                self.bookmarkButton.image = UIImage(systemName: "bookmark.fill")
            } else {
                self.bookmarkButton.image = UIImage(systemName: "bookmark")
            }
        }
    }
    private var bookmarkDict: [String:String] = [:] {
        didSet{
            if self.quizTitle != nil {
                if bookmarkDict[self.quizTitle!] == self.author{
                    self.isQuizBookmarked = true
                }
            }
            
        }
    }
    
    private var highScore: Int = 0
    private var quizCount: Int = 0 {
        didSet {
            self.updateUI()
            self.getCorrectAnswers()
        }
    }
    private var currentQuizNumber: Int = 1
    private var currentQuestion: String = ""
    private var currentChoices: [String]?
    private var correctAnwers: [String : String] = [:]
    private var quizID: String = ""
    private var arrDocumentIDs: [String] = []
    private let popUpMessage = "Your progress won't be saved. Proceed anyway?"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle.title = quizTitle
        self.makeround(choice1Button)
        self.makeround(choice2Button)
        self.makeround(choice3Button)
        self.makeround(choice4Button)
        self.loadQuiz()
        self.progressBar.progress = 0.0
        self.scoreLAbel.text = "Score: 0"
        self.loadBookmark()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.title = quizTitle
        self.scoreLAbel.text = "Score: 0"
        //        self.navigationController?.navigationBar.isHidden = false
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.title = "Home"
        self.currentQuizNumber = 1
        self.score = 0
        self.updateUI()
        
    }
    // MARK: - Table view data source
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        //        navigationController?.popViewController(animated: true)
        //        self.dismiss(animated: true, completion: nil)
        self.makeUIAlert()
    }
    @IBAction func bookmarkButtonPressed(_ sender: UIBarButtonItem) {
        if self.quizTitle != nil && self.author != nil{
            if self.isQuizBookmarked{
                self.isQuizBookmarked = false
                self.bookmarkDict.removeValue(forKey: self.quizTitle!)
            } else {
                self.isQuizBookmarked = true
                self.bookmarkDict[self.quizTitle!] = self.author!
            }
            self.saveBookmark()
        }
    }
    
    private func makeround(_ button: UIButton){
        
        button.layer.cornerRadius = button.frame.size.height/2
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.white.cgColor
    } 
    
    private func loadQuiz(){
        //        self.author = Auth.auth().currentUser?.uid
        if let userUID = self.author, let title = quizTitle{
            let quizRef = db.collection("Quizzes")
                .whereField("authorUID", isEqualTo: userUID)
                .whereField("quizTitle", isEqualTo: title)
            quizRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("There was an error retrieving data \(error)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        let document = snapshotDocuments[0]
                        self.quizID = document.documentID
                        let data = document.data()
                        if let retrievedQuiz = data["quizChoicesDict"] as? [String:[String]],
                            let retQuestions = data["quizQuestions"] as? [String]{
                            self.quizDict = retrievedQuiz
                            self.quizQuestions = retQuestions
                            self.quizCount = retQuestions.count - 1
                        }
                    }
                }
            }
        }
    }
    
    private func loadBookmark(){
        if let userUID = self.author {
            let bookmarkRef = db.collection("Bookmarks").document(userUID)
            bookmarkRef.getDocument { (querySnapshot, error) in
                if let error = error {
                    print("There was an error retrieving bookmarks \(error.localizedDescription)")
                } else {
                    if let data = querySnapshot?.data() {
                        if let retSavedQuiz = data["savedQuiz"] as? [String:String]{
                            self.bookmarkDict = retSavedQuiz
                        }
                    }
                }
            }
        }
    }
    
    private func saveBookmark(){
        if let userUID = self.author {
            self.db
                .collection("Bookmarks").document(userUID)
                .setData(["savedQuiz": self.bookmarkDict]) { (error) in
                    if error != nil {
                        print("There was an erorr saving bookmarks \(error!.localizedDescription)")
                    } else {
                        print("Successfully saved bookmarks")
                    }
            }
        }
    }
    
    private func updateUI(){
        
        currentQuestion = quizQuestions[self.currentQuizNumber]
        if quizDict[currentQuestion] != nil {
            currentChoices = quizDict[currentQuestion]!
            currentChoices?.shuffle()
        }
        
        self.questionLabel.text =  currentQuestion
        self.choice1Button.setTitle(currentChoices?[0], for: .normal)
        self.choice2Button.setTitle(currentChoices?[1], for: .normal)
        self.choice3Button.setTitle(currentChoices?[2], for: .normal)
        self.choice4Button.setTitle(currentChoices?[3], for: .normal)
        
        self.progressBar.progress = Float(self.currentQuizNumber)/Float(self.quizCount)
    }
    
    private func getCorrectAnswers(){
        for i in 1...self.quizCount{
            let question = quizQuestions[i]
            if quizDict[question] != nil {
                self.correctAnwers[question] = quizDict[question]![0]
            }
        }
    }
    
    private func checkAnswer(_ answer: String){
        
        if self.correctAnwers[self.currentQuestion] == answer {
            score += 1
            self.scoreLAbel.text = "Score: \(self.score)"
        }
    }
    
    @IBAction func choiceButtonPressed(_ sender: UIButton) {
        if let userAnswer = sender.titleLabel?.text {
            self.checkAnswer(userAnswer)
            self.currentQuizNumber += 1
            if self.currentQuizNumber <= self.quizCount{
                self.updateUI()
            } else {
                performSegue(withIdentifier: "QuizToResult", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! QuizResultViewController
        destinationVC.userScore = self.score
        destinationVC.numOfItems = self.quizCount
        destinationVC.sentFromPeopleVc = self.sentFromPeopleVc
        
    }
    
    private func makeUIAlert() {
        let alert = UIAlertController(title: "Exit Quiz?", message: popUpMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .default) { (action) in
        }
        let action2 = UIAlertAction(title: "Proceed", style: .default) { (action2) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
