//
//  CreateViewController.swift
//  Quizzler
//
//  Created by Anselm Jade Jamig on 9/15/20.
//  Copyright © 2020 Anselm Jade Jamig. All rights reserved.
//

import UIKit

class CreateViewController: UITableViewController {

    @IBOutlet weak var addButton: UIButton!
    let btn = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CreateTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleCell")
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // 3.
        view.bringSubviewToFront(btn)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! CreateTableViewCell
        return cell
    }

   
    @objc func buttonClicked(sender: UIButton){
        print("button Clicked")
    }
}
