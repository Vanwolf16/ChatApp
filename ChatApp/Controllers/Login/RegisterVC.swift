//
//  RegisterVC.swift
//  ChatApp
//
//  Created by David Murillo on 8/24/20.
//  Copyright © 2020 MuriTech. All rights reserved.
//

import UIKit
import FirebaseAuth

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
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.backgroundColor = UIColor.lightGray.cgColor
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
        
        imageView.layer.cornerRadius = imageView.width / 2.0
        
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
        DatabaseManager.shared.userExists(with: email) {[weak self] (exists) in
            guard let strongSelf = self else {return}
            
            guard !exists else {
                strongSelf.alertUserLoginError(message: "Looks like a user account for that email already exists")
                return
            }
            //User Created :)
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                
                guard  authResult != nil, error == nil else {
                    print("Error creating user")
                    return}
                //Create the user
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
                
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
            
        }
        
       
        
    }
    
    func alertUserLoginError(message:String = "Please enter all information to make a new account"){
        let alert = UIAlertController(title: "Whoops", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func didTapChangeProfilePic(){
        presentPhotoActionSheet()
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

extension RegisterVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {  [weak self]_ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {[weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        self.imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

