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
    var author: String? = nil
    var quizTitle: String? = nil
    var quizDict: [String: [String]] = [:]
    var quizQuestions: [String] = [] {
        didSet{
            
        }
    }
    var score: Int = 0
    var quizCount: Int = 0 {
        didSet {
            self.updateUI()
            self.getCorrectAnswers()
        }
    }
    var currentQuizNumber: Int = 1
    var currentQuestion: String = ""
    var currentChoices: [String]?
    var correctAnwers: [String : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle.title = quizTitle
        self.makeround(choice1Button)
        self.makeround(choice2Button)
        self.makeround(choice3Button)
        self.makeround(choice4Button)
        self.loadQuiz()
        self.progressBar.progress = 0.0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.title = quizTitle
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.title = "Home"
    }
    // MARK: - Table view data source

    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func makeround(_ button: UIButton){
        
        button.layer.cornerRadius = button.frame.size.height/2
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.white.cgColor
    } 
    
    private func loadQuiz(){
        let currentUserUID = Auth.auth().currentUser?.uid
        if let userUID = currentUserUID, let title = quizTitle{
            let quizRef = db.collection("Quizzes")
                            .whereField("authorUID", isEqualTo: userUID)
                            .whereField("quizTitle", isEqualTo: title)
            quizRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("There was an error retrieving data \(error)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        let document = snapshotDocuments[0]
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
            self.currentQuizNumber += 1
        }
    }
    
    @IBAction func choiceButtonPressed(_ sender: UIButton) {
        if let userAnswer = sender.titleLabel?.text {
            self.checkAnswer(userAnswer)
            self.updateUI()
        }
    }
    

    
 

}
