//
//  SignUpViewController.swift
//  PhotoPuzzleProject
//
//  Created by 佐藤一馬 on 2019/12/18.
//  Copyright © 2019 佐藤一馬. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) {
            (result, error) in
            if let err = error {
                //エラーがある場合
                print(err.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "toMain", sender: nil)
            }
        }
    }

}


