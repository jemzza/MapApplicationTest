//
//  FactoryDuration.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation

enum Durations {
  case oneHour, twoHour, threeHour
}

final class FactoryDuration {
  
  static var shared = FactoryDuration()
  
  private init() {}
  
  func createDuration(duration: Durations) -> Duration {
    
    switch duration {
    case .oneHour:
      return DurationFirst()
    case .twoHour:
      return DurationSecond()
    case .threeHour:
      return DurationThird()
    }
  }
}
