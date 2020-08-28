//
//  LoginVC.swift
//  ChatApp
//
//  Created by David Murillo on 8/24/20.
//  Copyright © 2020 MuriTech. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class LoginVC: UIViewController {
    
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let emailField:UITextField = {
        let field = UITextField()
        field.textColor = UIColor.black
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.darkGray.cgColor
        field.placeholder = "Email Address..."
        
        //Leverage
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
    }()
    
    private let passwordField:UITextField = {
           let field = UITextField()
           field.textColor = UIColor.black
           field.autocapitalizationType = .none
           field.autocorrectionType = .no
           field.returnKeyType = .done
           field.layer.cornerRadius = 12
           field.layer.borderWidth = 1
           field.layer.borderColor = UIColor.darkGray.cgColor
           field.placeholder = "Password..."
        field.isSecureTextEntry = true
        
           //Leverage
           field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
           field.leftViewMode = .always
           field.backgroundColor = .white
           
           return field
       }()
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo1")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let loginButton:UIButton = {
       let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let facebookLoginButton:FBLoginButton = {
       let button = FBLoginButton()
        button.permissions = ["public_profile", "email"]
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        
        facebookLoginButton.delegate = self
        
        //Add SubView
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(facebookLoginButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        imageView.frame = CGRect(x: (scrollView.width - size) / 2, y: 20, width: size, height: size)
        emailField.frame = CGRect(x: 30, y: imageView.bottom + 10, width: scrollView.width - 60, height: 50)
        passwordField.frame = CGRect(x: 30, y: emailField.bottom + 20, width: scrollView.width - 60, height: 50)
        loginButton.frame = CGRect(x: 30, y: passwordField.bottom + 20, width: scrollView.width - 60, height: 50)
        
        facebookLoginButton.frame = CGRect(x: 30, y: loginButton.bottom + 20, width: scrollView.width - 60, height: 50)
        
        facebookLoginButton.center = scrollView.center
        facebookLoginButton.frame.origin.y = loginButton.bottom + 20
        
    }
    
    @objc private func loginButtonTapped(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text,let password = passwordField.text, !email.isEmpty,
            !password.isEmpty, password.count >= 6 else {
                alertUserLoginError()
                return
        }
        
        //Firebase login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) {[weak self] (authResult, error) in
            guard let strongSelf = self else {return}
            guard let result = authResult, error == nil else {
            print("Error Sign In")
            return}
            
            let user = result.user
            print("Sign In: \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func alertUserLoginError(){
        let alert = UIAlertController(title: "Whoops", message: "Please enter all information ", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func didTapRegister(){
        let vc = RegisterVC()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension LoginVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField{
            passwordField.becomeFirstResponder()
        }else if textField == passwordField{
            loginButtonTapped()
        }
        
        return true
    }
}

extension LoginVC:LoginButtonDelegate{
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //no operation
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to login with Facebook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email, name"], tokenString: token, version: nil, httpMethod: .get)
        
        facebookRequest.start { (_, result, error) in
            guard let result = result as? [String:Any], error == nil else {
                print("Failed to make facebook graph")
                return
            }
            print("\(result)")
            
            guard let userName = result["name"] as? String,let email = result["email"] as? String else{
                print("Error to get Data")
                return
            }
            
            let nameComponents = userName.components(separatedBy: " ")
            guard nameComponents.count == 2 else {return}
            let firstName = nameComponents[0]
            let lastName = nameComponents[1]
            
            DatabaseManager.shared.userExists(with: email) { (exists) in
                if !exists{
                    DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
                }
                
                
                
            }
            
            //Firebase
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
               FirebaseAuth.Auth.auth().signIn(with: credential) {[weak self] (authResult, error) in
                   guard let strongSelf = self else {return}
                   guard result != nil,error == nil else {
                       if let error = error{
                         print("Facebook credential login failed - \(error)")
                       }
                       
                       return
                   }
                   print("Succesfully Logged user In")
                   strongSelf.navigationController?.dismiss(animated: true, completion: nil)
               }
            
        }
        
   
    }
    
    
}
