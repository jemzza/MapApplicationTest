//
//  Interest.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation

protocol Interest {
  
  var name: String { get }
  
  func add()
  func delete()
}
