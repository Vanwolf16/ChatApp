//
//  ProfileVC.swift
//  ChatApp
//
//  Created by David Murillo on 8/24/20.
//  Copyright © 2020 MuriTech. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class ProfileVC: UIViewController {

    @IBOutlet var tableView:UITableView!
    
    let data = ["Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    

}

extension ProfileVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alertSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: {[weak self] (_) in
            guard let strongSelf = self else {return}
            
            //Log Out Facebook
            FBSDKLoginKit.LoginManager().logOut()
            
            do{
                try FirebaseAuth.Auth.auth().signOut()
                let vc = LoginVC()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav, animated: false, completion: nil)
            }catch{
                print("Failed to Log Out :(")
            }
            
        }))
        
        alertSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertSheet, animated: true, completion: nil)
        
      
        
    }
    
}
