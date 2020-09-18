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

    @IBOutlet weak var googleButton: UIButton!
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                print("No user Logged in")
                self.googleButton.isEnabled = true
            } else {
                print("Logged in user \((Auth.auth().currentUser?.email)!)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            self.navigationController?.isNavigationBarHidden = false
            googleButton.isEnabled = true
    //        navigationController?.navigationItem.backBarButtonItem?.isEnabled = true
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if  handle != nil {
            Auth.auth().removeStateDidChangeListener(handle!)
        }
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
       googleButton.isEnabled = false
       self.navigationController?.isNavigationBarHidden = true
       GIDSignIn.sharedInstance().signIn()
    }
}
