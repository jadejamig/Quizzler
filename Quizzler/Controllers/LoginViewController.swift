//
//  LoginViewController.swift
//  Quizzler
//
//  Created by Anselm Jade Jamig on 9/17/20.
//  Copyright © 2020 Anselm Jade Jamig. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
    }


    @IBAction func loginButtonPressed(_ sender: UIButton) {
//        GIDSignIn.sharedInstance().signIn()
//        performSegue(withIdentifier: "LoginToHome", sender: self)
    }
}
