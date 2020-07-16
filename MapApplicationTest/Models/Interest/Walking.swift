//
//  Walking.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation

class Walking: Interest {
  
  var name: String = "Прогулка"
  
  func add() {
    print("Интерес /Прогулка/ добален в заказ")
  }
  
  func delete() {
    print("Интерес /Прогулка/ удален из заказа")
  }
}
