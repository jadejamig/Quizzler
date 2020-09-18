//
//  WelcomeViewController.swift
//  Quizzler
//
//  Created by Anselm Jade Jamig on 9/17/20.
//  Copyright © 2020 Anselm Jade Jamig. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class WelcomeViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        if Auth.auth().currentUser != nil{
            performSegue(withIdentifier: "WelcomeToHome", sender: self)
        }
    }
}
