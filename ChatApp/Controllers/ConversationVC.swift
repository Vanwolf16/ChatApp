//
//  ConversationVC.swift
//  ChatApp
//
//  Created by David Murillo on 8/24/20.
//  Copyright © 2020 MuriTech. All rights reserved.
//

import UIKit

class ConversationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }

    override func viewDidAppear(_ animated: Bool) {
        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
        
        if !isLoggedIn{
            let vc = LoginVC()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false, completion: nil)
        }
        
    }
    
}
