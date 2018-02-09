//
//  LoginViewController.swift
//  OS CloudBase
//
//  Created by mohammed al-batati on 1/9/18.
//  Copyright © 2018 mohammed al-batati. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.text = "Mohammed@hotmail.com"
        passwordTextField.text = "123456"
        activityIndicator.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        activityIndicator.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }

    
    @IBAction func loginPressed(_ sender: Any) {
        if let userName = userNameTextField.text{
            if let password = passwordTextField.text{
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                Auth.auth().signIn(withEmail: userName, password: password, completion: { (user, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        self.presentAlert(alert: error.localizedDescription)
                    } else{
                        print("login sucsses")
                        self.performSegue(withIdentifier: "toMainPageSegue", sender: nil)
                    }
                })
            }
        }
        
    }
    
    @IBAction func signinPressued(_ sender: Any) {
        
        if let userName = userNameTextField.text {
            if let password = passwordTextField.text{
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                Auth.auth().createUser(withEmail: userName, password: password, completion: { (user, error) in
                    if let error = error{
                        print(error)
                        self.presentAlert(alert: error.localizedDescription)
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    } else {
                        print("SignIn sucess")
                        if let user = user{
                            Database.database().reference().child("users").child(user.uid).child("email").setValue(user.email)
                            self.performSegue(withIdentifier: "toMainPageSegue", sender: nil)
                        }
                    }
                })
            }
        }
    }
    
    
    // alert helper function
    func presentAlert (alert : String){
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let actionVC = UIAlertAction(title: "OK", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(actionVC)
        present(alertVC, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
