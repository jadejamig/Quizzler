//
//  CreateViewController.swift
//  Quizzler
//
//  Created by Anselm Jade Jamig on 9/15/20.
//  Copyright © 2020 Anselm Jade Jamig. All rights reserved.
//

import UIKit
class CreateViewController: UITableViewController{


    let btn = UIButton(type: .custom)
    var questionCount: Int = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CreateTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
        tableView.register(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "QuestionCell")
        
        tableView.separatorStyle = .none
        self.tabBarController?.tabBar.isHidden = true
        
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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionCount
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! CreateTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionTableViewCell
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
        questionCount += 1
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath(row: questionCount-1, section: 0)], with: .fade)
        self.tableView.endUpdates()
        let indexPath = IndexPath(row: questionCount-1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
    }
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        navigationController?.tabBarController?.selectedIndex = 0
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
}
