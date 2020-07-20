//
//  Order.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation
import RealmSwift

enum Gender {
  case male, female
}

class Order: Object {
  
  @objc dynamic var id: String = UUID().uuidString
  @objc dynamic var ownerId: String = UUID().uuidString
  @objc dynamic var location: String!
  @objc dynamic var latitude: Double = 0.0
  @objc dynamic var longitude: Double = 0.0
  @objc dynamic var gender: String!
  @objc dynamic var age: String!
  @objc dynamic var weight: String!
  @objc dynamic var interests: String!
  @objc dynamic var duration: Int = 0
  @objc dynamic var date = Date().timeIntervalSince1970
  @objc dynamic var dateOfEnd = Date().timeIntervalSince1970
  
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
    id = (_dictionary[keyObjectId] as? String)!
    ownerId = (_dictionary[keyOwnerId] as? String)!
    location = _dictionary[keyLocation] as? String
    latitude = (_dictionary[keyLatitude] as? Double)!
    longitude = (_dictionary[keyLongitude] as? Double)!
    gender = _dictionary[keyGender] as? String
    age = _dictionary[keyAge] as? String
    weight = _dictionary[keyWeight] as? String
    interests = _dictionary[keyInterests] as? String
    date = (_dictionary[keyDate] as? TimeInterval)!
    dateOfEnd = (_dictionary[keyDateOfEnd] as? TimeInterval)!
  }
}

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
