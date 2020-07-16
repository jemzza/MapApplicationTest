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
  private var directionsArray: [MKDirections] = []
  
  
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
