//
//  GoToShopping.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation

class GoToShopping: Interest {
  
  var name: String = "Сходить в магазин"
  
  func add() {
    print("Интерес /Сходить в магазин/ добален в заказ")
  }
  
  func delete() {
    print("Интерес /Сходить в магазин/ удален из заказа")
  }
}
