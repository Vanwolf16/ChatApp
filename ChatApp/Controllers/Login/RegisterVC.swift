//
//  RegisterVC.swift
//  ChatApp
//
//  Created by David Murillo on 8/24/20.
//  Copyright © 2020 MuriTech. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
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
    
    private let firstNameField:UITextField = {
          let field = UITextField()
          field.textColor = UIColor.black
          field.autocapitalizationType = .none
          field.autocorrectionType = .no
          field.returnKeyType = .continue
          field.layer.cornerRadius = 12
          field.layer.borderWidth = 1
          field.layer.borderColor = UIColor.darkGray.cgColor
          field.placeholder = "FirstName..."
          
          
          //Leverage
          field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
          field.leftViewMode = .always
          field.backgroundColor = .white
          
          return field
      }()
    
    private let lastNameField:UITextField = {
          let field = UITextField()
          field.textColor = UIColor.black
          field.autocapitalizationType = .none
          field.autocorrectionType = .no
          field.returnKeyType = .continue
          field.layer.cornerRadius = 12
          field.layer.borderWidth = 1
          field.layer.borderColor = UIColor.darkGray.cgColor
          field.placeholder = "LastName..."
          
          
          //Leverage
          field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
          field.leftViewMode = .always
          field.backgroundColor = .white
          
          return field
      }()
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let registerButton:UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        //Add SubView
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(gesture)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        imageView.frame = CGRect(x: (scrollView.width - size) / 2, y: 20, width: size, height: size)
        firstNameField.frame = CGRect(x: 30, y: imageView.bottom + 10, width: scrollView.width - 60, height: 50)
        lastNameField.frame = CGRect(x: 30, y: firstNameField.bottom + 10, width: scrollView.width - 60, height: 50)
        emailField.frame = CGRect(x: 30, y: lastNameField.bottom + 10, width: scrollView.width - 60, height: 50)
        passwordField.frame = CGRect(x: 30, y: emailField.bottom + 20, width: scrollView.width - 60, height: 50)
        registerButton.frame = CGRect(x: 30, y: passwordField.bottom + 20, width: scrollView.width - 60, height: 50)
    }
    //Change it to Register Button Tapped in the future
    @objc private func registerButtonTapped(){
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let firstName = firstNameField.text,let lastName = lastNameField.text, let email = emailField.text,let password = passwordField.text,!firstName.isEmpty,!lastName.isEmpty, !email.isEmpty,
            !password.isEmpty, password.count >= 6 else {
                alertUserLoginError()
                return
        }
        
        //Firebase login
        
    }
    
    func alertUserLoginError(){
        let alert = UIAlertController(title: "Whoops", message: "Please enter all information to make a new account", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func didTapChangeProfilePic(){
        print("Change pic")
    }
    
    @objc private func didTapRegister(){
        let vc = RegisterVC()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension RegisterVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameField{
            lastNameField.becomeFirstResponder()
        }else if textField == lastNameField{
            emailField.becomeFirstResponder()
        }
        else if textField == emailField{
            passwordField.becomeFirstResponder()
        }else if textField == passwordField{
            registerButtonTapped()
        }
        
        return true
    }
}

