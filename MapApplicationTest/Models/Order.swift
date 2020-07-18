//
//  Order.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation

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

enum Gender {
  case male, female
}
