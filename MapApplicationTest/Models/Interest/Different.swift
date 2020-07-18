//
//  Different.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation

class Different: Interest {
  
  var name: String = "Другое"
  
  func add() {
    print("Интерес /\(name)/ добален в заказ")
  }
  
  func delete() {
    print("Интерес /\(name)/ удален из заказа")
  }
  
  init(name: String) {
    self.name = name
  }
}
