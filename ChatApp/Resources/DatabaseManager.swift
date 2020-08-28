//
//  DatabaseManager.swift
//  ChatApp
//
//  Created by David Murillo on 8/25/20.
//  Copyright © 2020 MuriTech. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    //Static
    static let shared = DatabaseManager()
    private let database = Database.database().reference()

    
}
//MARK: - Account Management
extension DatabaseManager{
    
    public func userExists(with email:String, completion:@escaping ((Bool) -> Void)){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    /// insert new user to database
    public func insertUser(with user:ChatAppUser){
        database.child(user.safeEmail).setValue(["first_name":user.firstName,
                                                    "last_name":user.lastName])
    }
    
}

struct ChatAppUser {
    let firstName:String
    let lastName:String
    let emailAddress:String
    
    var safeEmail:String{
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
         safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    //let profilePictureUrl:String
}
