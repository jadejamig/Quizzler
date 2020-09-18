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
//                self.performSegue(withIdentifier: "RegisterToHome", sender: self)
//                self.checkIfNewUser()
                
                print("Logged in user \((Auth.auth().currentUser?.email)!)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
        googleButton.isEnabled = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if  handle != nil {
            Auth.auth().removeStateDidChangeListener(handle!)
        }
    }
    
    @IBAction func googleSignInMethod(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn() 
        googleButton.isEnabled = false
    }

    //    private func checkIfNewUser(){
//        guard let authentication = GIDSignIn.sharedInstance()?.currentUser.authentication else { return }
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                       accessToken: authentication.accessToken)
//
//        // Authenticate with Firebase using the credential object
//        Auth.auth().signIn(with: credential) { (authResult, error) in
//            if let error = error {
//                print("authentication error \(error.localizedDescription)")
//            } else{
//
//                if let newuser = authResult?.additionalUserInfo?.isNewUser{
//                    if newuser{
//                        self.performSegue(withIdentifier: "RegisterToHome", sender: self)
//                    } else {
//                        self.userAlreadyExist()
//                        print("This email is already associated with another account")
//
//                    }
//                }
//            }
//        }
//    }
    
//    func userAlreadyExist () {
//        let alert = UIAlertController(title: "This email is already associated with another account",
//                                      message: "",
//                                      preferredStyle: .alert)
//        let action = UIAlertAction(title: "dismiss", style: .cancel, handler: nil)
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
//    }
//}

}
