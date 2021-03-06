//
//  MapViewController.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

protocol MapViewControllerDelegate: class {
  func getAddress(_ address: String?)
  func getOrder(_ order: Order?)
}

class MapViewController: UIViewController, CLLocationManagerDelegate {
  
  //MARK: - IBOutlets
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var mapPinImage: UIImageView!
  @IBOutlet weak var myLocationButton: UIButton!
  @IBOutlet weak var addressButton: UIButton!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var logOutButton: UIButton!
  
  //MARK: - Vars
  let mapManager = MapManager()
  private var orders: Results<Order>!
  private var ordersFromFB = [Order]()
  
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
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    mapManager.locationManager.requestWhenInUseAuthorization()
    mapView.showsUserLocation = true
    mapView.userTrackingMode = .follow
    
    mapView.delegate = self
    
//    orders = realm.objects(Order.self)
//    orders.forEach({ print("Orders location: \($0.location ?? "Kek")") })
//
//    DispatchQueue.main.async {
//      self.orders.forEach { (order) in
//        self.mapManager.setupOrder(order: order, mapView: self.mapView)
//      }
//    }
    
    loadOrders()
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
  
  @IBAction func logOutButtonPressed(_ sender: UIButton) {
    
    print("Logout user")
    if User.currentUser() != nil {
      
      logOutUser()
    } else {
      
      showAlert(title: "Ошибка", message: "Пользоавтель не авторизован в системе")
    }
  }
  
  //MARK: - Prepare for segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if User.currentUser() == nil {
      
      showWelcomeVC()
    } else {
      
      showWhoDoYouNeedVC(segue: segue)
    }
  }
  
  //MARK: - Setup View
  func setupView() {
    
    addressLabel.text = ""
    addressButton.layer.cornerRadius = addressButton.frame.size.height / 2
    addressButton.layer.borderColor = UIColor.darkGray.cgColor
    addressButton.layer.borderWidth = 1
    
    logOutButton.layer.cornerRadius = addressButton.frame.size.height / 2
    logOutButton.layer.borderColor = UIColor.darkGray.cgColor
    logOutButton.layer.borderWidth = 1
  }
  
  //MARK: - Show welcomeVC
  private func showWelcomeVC() {
    
    let welcomeView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "welcomeVC")
    self.present(welcomeView, animated: true, completion: nil)
  }
  
  //MARK: - Show WhoDoYouNeedViewController
  private func showWhoDoYouNeedVC(segue: UIStoryboardSegue ) {
    
    guard segue.identifier == "showWhoDoYouNeed" else { return }
    guard let destination = segue.destination as? WhoDoYouNeedViewController else { return }
    destination.delegate = self
    guard addressLabel.text != "" else {
      print("Choose address")
      return
    }
    
    destination.dataAddress = addressLabel.text!
    let coordinate = mapManager.getCenterLocation(for: mapView).coordinate
    destination.dataLatitude = Double(coordinate.latitude)
    destination.dataLongitude = Double(coordinate.longitude)
    
    print("адрес: \(destination.dataAddress ?? "#Адрес не передался!!!")")
  }
  
  //MARK: - Load Orders
  private func loadOrders() {
    
    NetworkManager.shared.downloadOrdersFromFirebase { (allOrders) in

      self.ordersFromFB = allOrders

      self.ordersFromFB.forEach { (order) in
        DispatchQueue.main.async {
          self.mapManager.setupOrder(order: order, mapView: self.mapView)
        }
      }
    }
  }
  
  //MARK: - Helpers func
  private func logOutUser() {
    
    User.logOutCurrentUser { (error) in
      
      if error == nil {
        
        print("logged out")
        self.showAlert(title: "Успешный выход", message: "Пользователь вышел из системы")
        
      } else {
        
        print("error login out", error!.localizedDescription)
        self.showAlert(title: "Ошибка при выходе", message: "error!.localizedDescription")
      }
    }
  }
  
  private func showAlert(title: String, message: String) {
    
    print("Show alert")
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    
    alert.addAction(okAction)
    
    present(alert, animated: true, completion: nil)
  }
}

//MARK: - MKMapViewDelegate
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
      let city = placemark?.locality
      let streetName = placemark?.thoroughfare
      let buildNumber = placemark?.subThoroughfare
      
      DispatchQueue.main.async {
        if city != nil && streetName != nil && buildNumber != nil {
          self.addressLabel.text = "Город \(city!), \(streetName!), строение \(buildNumber!)"
        } else if city != nil && streetName != nil {
          self.addressLabel.text = "\(city!), \(streetName!)"
        } else if streetName != nil {
          self.addressLabel.text = "\(streetName!)"
        } else {
          self.addressLabel.text = ""
        }
      }
    }
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
    
    if annotationView == nil {
      annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
    }
    
    annotationView?.image = UIImage(named: "pinRed")
    return nil
  }
  
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    
    print("the annotation was selected \(String(describing: view.annotation?.title))")
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
  }
  
}

//MARK: - MapViewControllerDelegate
extension MapViewController: MapViewControllerDelegate {
  
  func getAddress(_ address: String?) {
    mapManager.searchPlace(string: address, mapView: mapView)
  }
  
  func getOrder(_ order: Order?) {
    mapManager.setupOrder(order: order, mapView: mapView)
    print("### Заказ успешно размещен ###")
  }
}
