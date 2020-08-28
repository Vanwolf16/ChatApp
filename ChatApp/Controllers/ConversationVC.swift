//
//  ConversationVC.swift
//  ChatApp
//
//  Created by David Murillo on 8/24/20.
//  Copyright © 2020 MuriTech. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConversationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        validateAuth()
    }
    
    private func validateAuth(){
        if FirebaseAuth.Auth.auth().currentUser == nil{
            let vc = LoginVC()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false, completion: nil)
        }
    }
    
}
