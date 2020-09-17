//
//  RegisterViewController.swift
//  Quizzler
//
//  Created by Anselm Jade Jamig on 9/17/20.
//  Copyright © 2020 Anselm Jade Jamig. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class RegisterViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
                    if user == nil {
                        print("No user Logged in")
                    } else {
                        self.performSegue(withIdentifier: "RegisterToHome", sender: self)
                        print("Logged in user \((Auth.auth().currentUser?.email)!)")
                    }
                }
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if  handle != nil {
            Auth.auth().removeStateDidChangeListener(handle!)
        }
        
    }
    @IBAction func googleSignInMethod(_ sender: UIButton) {
         GIDSignIn.sharedInstance().signIn()
        
        
//        if Auth.auth().currentUser != nil{
//            performSegue(withIdentifier: "RegisterToHome", sender: self)
//        }
    }
}
