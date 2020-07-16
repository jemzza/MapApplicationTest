//
//  HelpWithTheApartment.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation

class HelpWithTheApartment: Interest {
  
  var name: String = "Помочь по дому"
  
  func add() {
    print("Интерес /Помочь по дому/ добален в заказ")
  }
  
  func delete() {
    print("Интерес /Помочь по дому/ удален из заказа")
  }
}
