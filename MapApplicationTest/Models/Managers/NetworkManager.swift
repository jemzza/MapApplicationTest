//
//  NetworkManager.swift
//  MapApplicationTest
//
//  Created by Alexander on 19.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation

final class NetworkManager {
  
  static var shared = NetworkManager()

  private init() {}
  
  //MARK: - User
  
  //MARK: - Download User
  func downloadUserFromFirestore(userId: String, email: String) {
    
    guard Reachabilty.HasConnection() else { return }
    
    FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
      guard let snapshot = snapshot else { return }
      
      if snapshot.exists {
        print("download currnet user from firestore")
        self.saveUserLocally(UserDictionary: snapshot.data()! as NSDictionary)
      } else {
        //there is no user, save new in firestore
        
        let user = User(_objectId: userId, _email: email)
        self.saveUserLocally(UserDictionary: self.userDictionaryFrom(user: user))
        self.saveUserToFirestore(User: user)
      }
    }
  }

  //MARK: - Save User to firebase
  private func saveUserToFirestore(User: User) {
        
    FirebaseReference(.User).document(User.objectId).setData(userDictionaryFrom(user: User) as! [String : Any]) { (error) in
      if error != nil {
        print("error saving user \(error!.localizedDescription)")
      }
    }
  }

  private func saveUserLocally(UserDictionary: NSDictionary) {
    UserDefaults.standard.set(UserDictionary, forKey: keyCurrentUser)
    UserDefaults.standard.synchronize()
  }

  //MARK: - Helper Function User
  private func userDictionaryFrom(user: User) -> NSDictionary {
    return NSDictionary(objects: [user.objectId, user.email, user.addedOrdersIds], forKeys: [keyObjectId as NSCopying, keyEmail as NSCopying, keyAddedOrdersIds as NSCopying])
  }

  
  //MARK: - Order
  
  //MARK: - Save Order
  func saveOrderToFirestore(_ order: Order) {
    
    guard Reachabilty.HasConnection() else { return }
    
    FirebaseReference(.Order).document(order.id).setData(orderDictionaryFrom(order) as! [String : Any])
  }

  //MARK: - Helper functions Order
  private func orderDictionaryFrom(_ order: Order) -> NSDictionary {
    return NSDictionary(objects: [order.id, order.ownerId, order.location!, order.latitude, order.longitude, order.gender!, order.age!, order.weight!, order.interests!, order.date], forKeys: [keyObjectId as NSCopying, keyOwnerId as NSCopying,keyLocation as NSCopying, keyLatitude as NSCopying, keyLongitude as NSCopying, keyGender as NSCopying, keyAge as NSCopying, keyWeight as NSCopying, keyInterests as NSCopying, keyDate as NSCopying])
  }

  //MARK: - Download Order
  func downloadOrdersFromFirebase(completion: @escaping (_ itemArray: [Order]) -> Void) {
    
    guard Reachabilty.HasConnection() else { return }
      
      var itemArray: [Order] = []
      
      FirebaseReference(.Order).getDocuments { (snapshot, error) in
          
          guard let snapshot = snapshot else {
              completion(itemArray)
              return
          }
          
          if !snapshot.isEmpty {
              
              for itemDict in snapshot.documents {
                  
                  itemArray.append(Order(_dictionary: itemDict.data() as NSDictionary))
              }
          }
          
          completion(itemArray)
      }
      
  }

  //MARK: - Download
  func downloadOrders(_ withIds: [String], completion: @escaping (_ orderArray: [Order]) -> Void) {
    
    var count = 0
    var orderArray: [Order] = []
    
    if withIds.count > 0 {
      for orderId in withIds {
        FirebaseReference(.Order).document(orderId).getDocument { (snapshot, error) in
          guard let snapshot = snapshot else {
            completion(orderArray)
            return
          }
          
          if snapshot.exists {
            orderArray.append(Order(_dictionary: snapshot.data()! as NSDictionary))
            count += 1
          } else {
            completion(orderArray)
          }
          
          if count == withIds.count {
            completion(orderArray)
          }
        }
      }
    } else {
      completion(orderArray)
    }
  }

}
