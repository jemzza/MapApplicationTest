//
//  Duration.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation

protocol Duration {
  
  var name: String { get }
  var hours: Int { get }
  var price: Int { get }
  
  func add()
}
