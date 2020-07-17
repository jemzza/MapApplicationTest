//
//  MapViewController.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate: class {
  func getAddress(_ address: String?)
}

class MapViewController: UIViewController, CLLocationManagerDelegate {
  
  let mapManager = MapManager()
  var order = Order()
  var addressForSearch = ""
  
  var interests = [Interest]()
  var duration: Duration?
  
  //  let annotaionIdentifier = "annotaionIdentifier"
  
  var previousLocation: CLLocation? {
    didSet {
      mapManager.startTrackingUserLocation(for: mapView, and: previousLocation) { (currentLocation) in
        self.previousLocation = currentLocation
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
          self.mapManager.showUserLocation(mapView: self.mapView)
        }
      }
    }
  }
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var mapPinImage: UIImageView!
  @IBOutlet weak var myLocationButton: UIButton!
  @IBOutlet weak var addressButton: UIButton!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var nextButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpMapView()
    mapManager.locationManager.requestWhenInUseAuthorization()
    mapView.showsUserLocation = true
    mapView.userTrackingMode = .follow
    
    mapView.delegate = self
    
    order.location = "Москва"
    order.gender = .male
    order.age = 20
    order.weight = 50
    
    addInterest()
    createIntrest(nameOfInterest: .read)
    createIntrest(nameOfInterest: .read)
    createIntrest(nameOfInterest: .shop)
    addInterest()
    
    addDuration()
    createDuration(nameOfDuration: .twoHour)
    createDuration(nameOfDuration: .oneHour)
    createDuration(nameOfDuration: .threeHour)
    addDuration()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  //MARK: - IBActions
  @IBAction func myLocationButtonPressed(_ sender: UIButton) {
    print("Determine user location")
    mapManager.showUserLocation(mapView: mapView)
  }
  
  @IBAction func addressButtonPressed(_ sender: UIButton) {
    print("Show text field for enter new address by user")
    
    let enteringAddressVC = EnteringAddressViewController()
    enteringAddressVC.delegate = self
    present(enteringAddressVC, animated: true, completion: nil)
  }
  
  @IBAction func nextButtonPressed(_ sender: UIButton) {
    print("Show form for creating new order")
    guard let address = addressLabel.text else {
      print("Выберите адрес")
      return
    }
    
    order.location = address
    print("Выбран адрес: \(address)")
  }
  
  //MARK: - Logic
  
  func createIntrest(nameOfInterest: Interests) {
    
    let newInterest = FactoryInterests.shared.createInterest(interest: nameOfInterest)
    
    if let index = interests.enumerated().first(where: { $0.element.name == newInterest.name })?.offset {
      interests.remove(at: index)
    } else {
      interests.append(newInterest)
    }
  }
  
  func addInterest() {
    
    guard interests.count != 0 else {
      print("Pls add some interests")
      return
    }
    
    order.interests = interests
    interests.forEach({ $0.add() })
  }
  
  func createDuration(nameOfDuration: Durations) {
    
    let newDuration = FactoryDuration.shared.createDuration(duration: nameOfDuration)
    duration = newDuration
  }
  
  func addDuration() {
    
    guard let duration = duration else {
      print("Pls choose tariff")
      return
    }
    order.duration = duration
    duration.add()
  }
  
  //MARK: - Set up View
  
  func setUpMapView() {
    addressLabel.text = ""
    addressButton.layer.cornerRadius = addressButton.frame.size.height / 2
    addressButton.layer.borderColor = UIColor.darkGray.cgColor
    addressButton.layer.borderWidth = 1
  }
}

extension MapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    
    let center = mapManager.getCenterLocation(for: mapView)
    let geocoder = CLGeocoder()
    
    if previousLocation != nil {
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        self.mapManager.showUserLocation(mapView: self.mapView)
      }
    }
    
    // Отмена отложенного запроса для освобождения ресурсов
    geocoder.cancelGeocode()
    
    geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
      
      if let error = error {
        print(error)
        return
      }
      
      guard let placemarks = placemarks else { return }
      
      let placemark = placemarks.first
      let streetName = placemark?.thoroughfare
      let buildNumber = placemark?.subThoroughfare
      
      DispatchQueue.main.async {
        if streetName != nil && buildNumber != nil {
          self.addressLabel.text = "\(streetName!), \(buildNumber!)"
        } else if streetName != nil {
          self.addressLabel.text = "\(streetName!)"
        } else {
          self.addressLabel.text = ""
        }
      }
    }
  }
  
}

extension MapViewController: MapViewControllerDelegate {
  
  func getAddress(_ address: String?) {
    addressForSearch = address!
    print(addressForSearch)
    mapManager.setupMark(string: address, mapView: mapView)
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
//
//        if annotationView == nil {
//          annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
//        }
//
//        annotationView?.image = UIImage(named: "pinRed")
        return nil
  }
  
  
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    print("the annotation was selected \(String(describing: view.annotation?.title))")
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
  }
}
