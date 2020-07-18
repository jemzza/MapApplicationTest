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
  @objc dynamic var location: String?
  @objc dynamic var gender: String?
  @objc dynamic var age: String?
  @objc dynamic var weight: String?
  @objc dynamic var interests: String?
  @objc dynamic var duration: Int = 0
  @objc dynamic var date = Date()
  
  convenience init(gender: String, age: String, weight: String, interests: String, duration: Int) {
    self.init()
    self.location = location
    self.gender = gender
    self.age = age
    self.weight = weight
    self.interests = interests
    self.duration = duration
  }
}
