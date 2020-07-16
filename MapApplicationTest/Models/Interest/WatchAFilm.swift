//
//  WatchAFilm.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation

class WatchAFilm: Interest {
  
  var name: String = "Посмотреть кино"
  
  func add() {
    print("Интерес /Посмотреть кино/ добален в заказ")
  }
  
  func delete() {
    print("Интерес /Посмотреть кино/ удален из заказа")
  }
}
