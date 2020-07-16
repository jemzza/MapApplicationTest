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
  var location: String?
  var gender: Gender
  var age: Int
  var weight: Int
  var date = Date()
  var interests: [Interest]?
  var duration: Duration?
  
  init() {
    location = nil
    gender = .male
    age = 0
    weight = 4
    interests = nil
    duration = nil
  }
}

enum Gender {
  case male, female
}
