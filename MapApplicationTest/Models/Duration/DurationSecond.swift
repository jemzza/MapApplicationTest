//
//  DurationSecond.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation

class DurationSecond: Duration {
  
  var name: String = "2 часа"
  
  var hours: Int = 2
  
  var price: Int = 150
  
  func add() {
    print("Тариф /Тариф 2 часа/ добален в заказ")
  }
}
