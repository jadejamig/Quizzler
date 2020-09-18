//
//  CreateViewController.swift
//  Quizzler
//
//  Created by Anselm Jade Jamig on 9/15/20.
//  Copyright © 2020 Anselm Jade Jamig. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class CreateViewController: UITableViewController{
    

    let btn = UIButton(type: .custom)
//    var questionCount: Int = 4
    let defaultValue = [0:CreateQuizModel(q: "", c: ["","","",""]), 1: CreateQuizModel(q: "", c: [""])]
    let popUpMessage = "Your draft won't be saved. Do you want to proceed anyway?"
    var quizDictionary: [Int: CreateQuizModel] = [0:CreateQuizModel(q: "", c: ["","","",""]), 1: CreateQuizModel(q: "", c: ["","","",""])]
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        tableView.register(UINib(nibName: "CreateTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionCell")
        
        tableView.separatorStyle = .none
        
        
        //Modifying the properties of the floating button
        btn.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        btn.layer.cornerRadius = btn.frame.size.width/2
        btn.setTitle("+", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor(named: "deepPurple" )
        
        view.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btn.widthAnchor.constraint(equalToConstant: 40),
            btn.heightAnchor.constraint(equalToConstant: 40),
            btn.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -15),
            btn.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant:0)
        ])
        
        tableView.contentInset =  UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront(btn)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        print(quizDictionary)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            // Your code...
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizDictionary.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! CreateTableViewCell
            
            cell.tag = indexPath.row
            cell.titleField.tag = 0
            cell.descriptionField.tag = 1
            
            cell.titleField.superview?.tag = indexPath.row
            cell.descriptionField.superview?.tag = indexPath.row
            
            cell.titleField.delegate = self
            cell.descriptionField.delegate = self
        
            cell.titleField.text = quizDictionary[cell.tag]?.c[0]
            cell.descriptionField.text = quizDictionary[cell.tag]?.c[1]
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionTableViewCell
            
            cell.tag = indexPath.row
            cell.textView.tag = indexPath.row
            cell.choiceA.tag = 0
            cell.choiceB.tag = 1
            cell.choiceC.tag = 2
            cell.choiceD.tag = 3
            
            cell.textView.superview?.tag = indexPath.row
            cell.choiceA.superview?.tag = indexPath.row
            cell.choiceB.superview?.tag = indexPath.row
            cell.choiceC.superview?.tag = indexPath.row
            cell.choiceD.superview?.tag = indexPath.row
            
            cell.textView.delegate = self
            cell.textView.delegate = self
            cell.choiceA.delegate = self
            cell.choiceB.delegate = self
            cell.choiceC.delegate = self
            cell.choiceD.delegate = self
            
            cell.textView.text = quizDictionary[cell.tag]?.q
            cell.choiceA.text = quizDictionary[cell.tag]?.c[0]
            cell.choiceB.text = quizDictionary[cell.tag]?.c[1]
            cell.choiceC.text = quizDictionary[cell.tag]?.c[2]
            cell.choiceD.text = quizDictionary[cell.tag]?.c[3]
            
            cell.questionLabel.text = ("Question \(indexPath.row)")
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    //MARK: - TableView Delegate Method
    
    //SCROLL TO THE CURRENTLY SELECTED CELL
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        print("cell clicked")
    }
    
    @objc func buttonClicked(sender: UIButton){
        
        print("button Clicked")
        quizDictionary[quizDictionary.count] = CreateQuizModel(q: "", c: ["","","",""])
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath(row: quizDictionary.count-1 , section: 0)], with: .fade)
        self.tableView.endUpdates()
        let indexPath = IndexPath(row: quizDictionary.count-1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        print(quizDictionary)
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        makeUIAlert()
        print(quizDictionary)
    }
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {

    }
    
    
    func makeUIAlert() {
        let alert = UIAlertController(title: "Delete Quiz?", message: popUpMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .default) { (action) in
        }
        let action2 = UIAlertAction(title: "Discard Quiz", style: .default) { (action2) in
            
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            self.clearRows()
            self.navigationController?.tabBarController?.selectedIndex = 0
            self.navigationController?.tabBarController?.tabBar.isHidden = false
        }
        
        alert.addAction(action)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func clearRows(){
        self.quizDictionary = [0:CreateQuizModel(q: "", c: ["","","",""]), 1: CreateQuizModel(q: "", c: ["","","",""])]
        self.tableView.reloadData()

    }
    
}

extension CreateViewController: UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        quizDictionary[textView.tag]?.q = textView.text
    }
}

extension CreateViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        quizDictionary[textField.superview!.tag]?.c[textField.tag] = (textField.text ?? "")
    }
}
