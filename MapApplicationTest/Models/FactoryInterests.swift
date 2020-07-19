//
//  FactoryInterests.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation

enum Interests {
  case read, watch, help, walk, shop, different
}

final class FactoryInterests {
  
  static var shared = FactoryInterests()
  
  private init() {}
  
  func createInterest(interest: Interests) -> Interest {
    switch interest {
    case .read:
      return ReadABook()
    case .watch:
      return WatchAFilm()
    case .help:
      return HelpWithTheApartment()
    case .walk:
      return Walking()
    case .shop:
      return GoToShopping()
    case .different:
      return Different(name: "Другое")
    }
  }
}
