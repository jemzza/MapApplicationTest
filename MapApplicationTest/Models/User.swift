//
//  User.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation
import FirebaseAuth

class User {
  
  let objectId: String
  var email: String
  var addedOrdersIds: [String]

init(_objectId: String, _email: String) {
    objectId = _objectId
    email = _email
    addedOrdersIds = []
  }
  
  init(_dictioanary: NSDictionary) {
    objectId = _dictioanary[keyObjectId] as! String
    
    if let mail = _dictioanary[keyEmail] {
      email = mail as! String
    } else {
      email = ""
    }
    
    if let addedIds = _dictioanary[keyAddedOrdersIds] {
      addedOrdersIds = addedIds as! [String]
    } else {
      addedOrdersIds = []
    }
  }
  
  //MARK: - Return current user
  
  class func currentId() -> String {
    return Auth.auth().currentUser!.uid
  }
  
  class func currentUser() -> User? {
    if Auth.auth().currentUser != nil {
      if let dictionary = UserDefaults.standard.object(forKey: keyCurrentUser) {
        return User.init(_dictioanary: dictionary as! NSDictionary)
      }
    }
    return nil
  }
  
  //MARK: - Login func
  class func loginUserWith(email: String, password: String, completion: @escaping(_ error: Error?, _ isEmailVerified: Bool) -> Void) {
    
    Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
      
      if error == nil {
        if authDataResult!.user.isEmailVerified {
          //to download user from firestore
          Network.shared.downloadUserFromFirestore(userId: authDataResult!.user.uid, email: email)
          
          completion(error, true)
        } else {
          print("email is not verified")
          completion(error, false)
        }
      } else {
        completion(error, false)
      }
    }
  }
  
  //MARK: - Register user
  class func registerUserWith(email: String, password: String, completion: @escaping(_ error: Error?) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
      
      completion(error)
      
      if error == nil {
        //send email verification
        authDataResult!.user.sendEmailVerification { (error) in
          guard let error = error else { return }
          print("auth email verification error:", error.localizedDescription)
        }
      }
    }
  }
  
  //MARK: - Log out user
  class func logOutCurrentUser(completion: @escaping (_ error: Error?) -> Void) {
    
    do {
      try Auth.auth().signOut()
      UserDefaults.standard.removeObject(forKey: keyCurrentUser)
      UserDefaults.standard.synchronize()
      completion(nil)
    } catch let error as NSError {
      completion(error)
    }
  }
  
}

