//
//  MapManager.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import UIKit
import MapKit

class MapManager {
  
  let locationManager = CLLocationManager()
  
  private var placeCoordinate: CLLocationCoordinate2D?
  private let regionInMeters = 1_000.00
  
  func searchPlace(string: String?, mapView: MKMapView) {
    
    guard let location = string else { return }
    
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(location) { (placemarks, error) in
      if let error = error {
        print(error)
        return
      }
      
      guard let placemarks = placemarks else { return }
      
      let placemark = placemarks.first
      
      guard let placemarkLocation = placemark?.location else { return }
      
      mapView.centerCoordinate = placemarkLocation.coordinate
    }
  }
  
  func setupOrder(order: Order?, mapView: MKMapView) {
    
    //TODO: Проблема с Date!!! dateOfEnd в класс!
    
    //Установка по координатам
    guard let order = order else { return }
    
    let location = CLLocation(latitude: order.latitude, longitude: order.longitude)
    
    let annotation = MKPointAnnotation()
    
    guard let gender = order.gender, let age = order.age, let weight = order.weight, let interest = order.interests else { return }

    guard Date() <= Date(timeIntervalSince1970: order.dateOfEnd) else {
//      print("Не прошел guard: dateNow(\(Date())) > dateOfEnd(\(Date(timeIntervalSince1970: order.dateOfEnd))" )
      return
    }
//    print("Прошел guard: dateNow(\(Date())) <= dateOfEnd(\(Date(timeIntervalSince1970: order.dateOfEnd))" )
    
    guard let substractionInHours = Calendar.current.dateComponents([.hour], from: Date(), to: Date(timeIntervalSince1970: order.dateOfEnd)).hour else { return }
    
    annotation.title = "\(interest). \(gender). Возраст: \(age). Вес: \(weight)."
    
    if substractionInHours == 0 {
      
      guard let substractionInMinutes = Calendar.current.dateComponents([.minute], from: Date(), to: Date(timeIntervalSince1970: order.dateOfEnd)).minute else { return }
      annotation.subtitle = "Осталось минут: \(substractionInMinutes)"
    } else {
      annotation.subtitle = "Осталось часов: \(substractionInHours)"
    }
    
    
    annotation.coordinate = location.coordinate
    
    mapView.addAnnotation(annotation)
    
  }
  
  func setupOrderFromFB(order: Order?, mapView: MKMapView) {
    
    //Установка по координатам
    guard let order = order else { return }
    
    let location = CLLocation(latitude: order.latitude, longitude: order.longitude)
    
    let annotation = MKPointAnnotation()
    
    guard let gender = order.gender, let age = order.age, let weight = order.weight, let interest = order.interests else { return }
    let duration = order.duration
    
    annotation.title = "\(interest). \(gender). Возраст: \(age). Вес: \(weight)."
    annotation.subtitle = "Длительность: \(duration)\n\(order.date)"
    
    annotation.coordinate = location.coordinate
    
    mapView.addAnnotation(annotation)
    
  }
  
  /*
   func setupOrder(order: Order?, mapView: MKMapView) {
   
   //Установка по локации
   
   guard let order = order else { return }
   guard let location = order.location else { return }
   
   let geocoder = CLGeocoder()
   
   geocoder.geocodeAddressString(location) { (placemarks, error) in
   if let error = error {
   print(error)
   return
   }
   
   guard let placemarks = placemarks else { return }
   
   let placemark = placemarks.first
   
   let annotation = MKPointAnnotation()
   
   guard let gender = order.gender, let age = order.age, let weight = order.weight, let interest = order.interests else { return }
   let duration = order.duration
   
   let date = order.date
   let calendar = Calendar.current
   guard let dateOfEnd = calendar.date(byAdding: .hour, value: duration, to: date) else { return }
   
   guard Date() <= dateOfEnd else { return }
   guard let substractionInHours = calendar.dateComponents([.hour], from: date, to: dateOfEnd).hour else { return }
   
   annotation.title = "\(interest). \(gender). Возраст: \(age). Вес: \(weight)."
   annotation.subtitle = "Осталось часов: \(substractionInHours)"
   
   guard let placemarkLocation = placemark?.location else { return }
   
   annotation.coordinate = placemarkLocation.coordinate
   
   mapView.addAnnotation(annotation)
   }
   }
   */
  
  //Checking the availability of geolocation services
  func checkLocationServices(mapView: MKMapView, segueIdentifier: String, closure: () -> ()) {
    
    if CLLocationManager.locationServicesEnabled() {
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      checkLocationAuthorization(mapView: mapView, segueIdentifier: "")
      closure()
    } else {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        self.showAlert(title: "Your Location is not Available",
                       message: "To give permission go to: Settings -> Privacy -> Location Services and turn On"
        )
      }
    }
  }
  
  func checkLocationAuthorization(mapView: MKMapView, segueIdentifier: String) {
    switch CLLocationManager.authorizationStatus() {
    case .authorizedWhenInUse:
      mapView.showsUserLocation = true
      if segueIdentifier == "getAddress" { showUserLocation(mapView: mapView) }
      break
    case .denied:
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        self.showAlert(title: "Your Location is not Available",
                       message: "To give permission go to: Setting -> MyPlaces -> Location"
        )
      }
      break
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .restricted:
      break
    case .authorizedAlways:
      break
    @unknown default:
      print("New case is available")
    }
  }
  
  //Focus map to user location
  func showUserLocation(mapView: MKMapView) {
    
    if let location = locationManager.location?.coordinate {
      let region = MKCoordinateRegion(center: location,
                                      latitudinalMeters: regionInMeters,
                                      longitudinalMeters: regionInMeters)
      mapView.setRegion(region, animated: true)
    }
  }
  
  //Меняем отоброжаемую зону области карты в соответствии с перемещением пользователя
  func startTrackingUserLocation(for mapView: MKMapView, and location: CLLocation?, closure: (_ currentLocation: CLLocation) -> ()) {
    
    guard let location = location else { return }
    let center = getCenterLocation(for: mapView)
    guard center.distance(from: location) > 50 else { return }
    
    closure(center)
  }
  
  // Определение центра отображаемой области карты
  func getCenterLocation(for mapView: MKMapView) -> CLLocation {
    
    let latitude = mapView.centerCoordinate.latitude
    let longitude = mapView.centerCoordinate.longitude
    return CLLocation(latitude: latitude, longitude: longitude)
  }
  
  private func showAlert(title: String, message: String) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    
    alert.addAction(okAction)
    
    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
    alertWindow.rootViewController = UIViewController()
    alertWindow.windowLevel = UIWindow.Level.alert + 1
    alertWindow.makeKeyAndVisible()
    alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
  }
}
