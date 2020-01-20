//
//  SignInViewController.swift
//  PhotoPuzzleProject
//
//  Created by 佐藤一馬 on 2019/12/18.
//  Copyright © 2019 佐藤一馬. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func SignInbutton(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) {
            (result, error) in
            
            if let err = error {
                print(err.localizedDescription)
            } else {
    self.performSegue(withIdentifier: "toMain", sender: nil)
            }
            
        }
    }
    

}
