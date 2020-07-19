//
//  Order.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation
/*
 struct Order {
 
 var id: String!
 var location: String
 var gender: Gender
 var age: String
 var weight: String
 var date = Date()
 var interests: [Interest]?
 var duration: Duration?
 
 init() {
 location = ""
 gender = .male
 age = ""
 weight = ""
 interests = nil
 duration = nil
 }
 }
 */
enum Gender {
  case male, female
}

import RealmSwift

class Order: Object {
  
  @objc dynamic var id: String = UUID().uuidString
  @objc dynamic var location: String!
  @objc dynamic var latitude: Double = 0.0
  @objc dynamic var longitude: Double = 0.0
  @objc dynamic var gender: String!
  @objc dynamic var age: String!
  @objc dynamic var weight: String!
  @objc dynamic var interests: String!
  @objc dynamic var duration: Int = 0
  @objc dynamic var date = Date()
  
  convenience init(location: String, latitude: Double, longitude: Double, gender: String, age: String, weight: String, interests: String, duration: Int) {
    self.init()
    self.location = location
    self.latitude = latitude
    self.longitude = longitude
    self.gender = gender
    self.age = age
    self.weight = weight
    self.interests = interests
    self.duration = duration
  }
  
  required init() {
    
  }
  
  init(_dictionary: NSDictionary) {
    id = (_dictionary[keyUserId] as? String)!
    location = _dictionary[keyLocation] as? String
    latitude = (_dictionary[keyLatitude] as? Double)!
    longitude = (_dictionary[keyLongitude] as? Double)!
    gender = _dictionary[keyGender] as? String
    age = _dictionary[keyAge] as? String
    weight = _dictionary[keyWeight] as? String
    interests = _dictionary[keyInterests] as? String
    date = (_dictionary[keyDate] as? Date)!
  }
}

//MARK: Save items
func saveItemToFirestore(_ order: Order) {
  FirebaseReference(.Items).document(order.id).setData(itemDictionaryFrom(order) as! [String : Any])
}

//MARK: Helper functions
func itemDictionaryFrom(_ order: Order) -> NSDictionary {
  return NSDictionary(objects: [order.id, order.location, order.latitude, order.longitude, order.gender, order.age, order.weight, order.interests, order.date], forKeys: [keyObjectId as NSCopying, keyLocation as NSCopying, keyLatitude as NSCopying, keyLongitude as NSCopying, keyGender as NSCopying, keyAge as NSCopying, keyWeight as NSCopying, keyInterests as NSCopying, keyDate as NSCopying])
}

//MARK: Download Func
func downloadOrdersFromFirebase(completion: @escaping (_ itemArray: [Order]) -> Void) {
    
    var itemArray: [Order] = []
    
    FirebaseReference(.Items).getDocuments { (snapshot, error) in
        
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

//MARK: -
func downloadOrders(_ withIds: [String], completion: @escaping (_ orderArray: [Order]) -> Void) {
  
  var count = 0
  var orderArray: [Order] = []
  
  if withIds.count > 0 {
    for orderId in withIds {
      FirebaseReference(.Items).document(orderId).getDocument { (snapshot, error) in
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
