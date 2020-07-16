//
//  User.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation

struct User {
  
  let objectId: String
  var email: String
  var firstName: String
  var lastName: String
  var fullName: String
  var addedOrders: [Order]
}
