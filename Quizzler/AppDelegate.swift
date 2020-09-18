//
//  AppDelegate.swift
//  Quizzler
//
//  Created by Anselm Jade Jamig on 9/15/20.
//  Copyright © 2020 Anselm Jade Jamig. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import GoogleSignIn
import FirebaseAuth


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        // Perform any operations when the user disconnects from app here.
        // ...
        print("user disconnected")
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        
        //handle sign-in errors
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("error signing into Google \(error.localizedDescription)")
            }
            return
        }
        
        // Get credential object using Google ID token and Google access token
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        // Authenticate with Firebase using the credential object
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("authentication error \(error.localizedDescription)")
            } else{
                
                if let newuser = authResult?.additionalUserInfo?.isNewUser{
                    if newuser{
                        
                        print("IS new user")
                        
                        if signIn.presentingViewController.restorationIdentifier == "Register"{
                                
                            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let tabBarVC : UITabBarController = mainStoryboardIpad.instantiateViewController(withIdentifier: "TabController") as! UITabBarController
                            tabBarVC.navigationController?.tabBarController?.tabBar.isHidden = false
//                          tabBarVC.navigationController?.isNavigationBarHidden = false
//                          tabBarVC.navigationController?.navigationBar.barTintColor = UIColor(named: "deepPurple")
                            signIn.presentingViewController.navigationController?.viewControllers[0] = tabBarVC
                            if let vc = signIn.presentingViewController.navigationController?.viewControllers[0]{
                                signIn.presentingViewController.navigationController?.popToViewController(vc, animated: true)
                            }
                            print("Registered from register vc")
                            
                        } else if signIn.presentingViewController.restorationIdentifier == "Login"{
                            
                        }
                   
                    } else {
                        self.userAlreadyExist(presentingVC: signIn.presentingViewController)
                        do {
                            try Auth.auth().signOut()
                            print("logout successfuly")
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }
                        print("This email is already associated with another account")
                        print("igned in from \(signIn.presentingViewController.restorationIdentifier ?? "no resto ID")")
                    }
                }
            }
        }
    }
    
    func userAlreadyExist (presentingVC: UIViewController) {
            let alert = UIAlertController(title: "This email is already associated with another account",
                                          message: "",
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "dismiss", style: .cancel, handler: nil)
            alert.addAction(action)
            presentingVC.present(alert, animated: true, completion: nil)
        }
    }


