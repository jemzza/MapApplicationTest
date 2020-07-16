//
//  DurationThird.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation

class DurationThird: Duration {
  
  var name: String = "Тариф 3 часа"
  
  var hours: Int = 3
  
  var price: Int = 200
  
  func add() {
    print("Тариф /Тариф 3 часа/ добален в заказ")
  }
}
