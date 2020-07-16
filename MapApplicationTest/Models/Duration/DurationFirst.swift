//
//  TariffOne.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation

class DurationFirst: Duration {
  
  var name: String = "Тариф 1 час"
  
  var hours: Int = 1
  
  var price: Int = 100
  
  func add() {
    print("Тариф /Тариф 1 час/ добален в заказ")
  }
}
