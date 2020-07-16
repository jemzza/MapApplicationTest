//
//  ReadABook.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation

class ReadABook: Interest {
  
  var name: String = "Почитать книгу"
  
  func add() {
    print("Интерес /Почитать книгу/ добален в заказ")
  }
  
  func delete() {
    print("Интерес /Почитать книгу/ удален из заказа")
  }
}
