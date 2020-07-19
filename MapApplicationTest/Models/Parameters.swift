//
//  Parameters.swift
//  MapApplicationTest
//
//  Created by Alexander on 18.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import Foundation

final class Parameters {
  
  static var shared = Parameters()
  
  private init() {}
  
  private var arrayOfGender = ["Мужской",
                               "Женский"]
  private var arrayOfAges = ["20-25",
                             "25-30",
                             "30-35",
                             "35-40",
                             "40-45",
                             "50-55",
                             "55-60",]
  private var arrayOfWeight = ["50-55",
                               "55-60",
                               "60-65",
                               "65-70",
                               "70-75",
                               "75-80",
                               "80-85",
                               "85-90",
                               "90-95",
                               "95-100",
                               "105-110",]
  var arrayOfInterests = [String]()
  var arrayOfDuration = [String]()
  
  func getGender() -> [String] {
    return arrayOfGender
  }
  
  func getAge() -> [String] {
    return arrayOfAges
  }
  
  func getWeight() -> [String] {
    return arrayOfWeight
  }
  
  func getInterests() -> [String] {
    return arrayOfInterests
  }
  
  func getDuration() -> [String] {
    return arrayOfDuration
  }

  func countOfGender() -> Int {
    return arrayOfGender.count
  }
  
  func countOfAge() -> Int {
    return arrayOfAges.count
  }
  
  func countOfWeight() -> Int {
    return arrayOfWeight.count
  }
  
  func countOfInterests() -> Int {
    return arrayOfInterests.count
  }
  
  func countOfDuration() -> Int {
    return arrayOfDuration.count
  }
}
