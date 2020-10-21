//
//  BookmarkViewController.swift
//  Quizzler
//
//  Created by Anselm Jade Jamig on 10/21/20.
//  Copyright © 2020 Anselm Jade Jamig. All rights reserved.
//

import UIKit

class BookmarkViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "QuizCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
//        tableView.separatorStyle = .none
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.navigationController?.navigationBar.isHidden = false
        }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
