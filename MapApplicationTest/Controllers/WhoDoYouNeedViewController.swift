//
//  WhoDoYouNeedViewController.swift
//  MapApplicationTest
//
//  Created by Alexander on 17.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import UIKit

class WhoDoYouNeedViewController: UIViewController {
  
  //MARK: - IBOutlets
  @IBOutlet weak var imageViewBackground: UIImageView!
  @IBOutlet weak var textFieldGender: UITextField!
  @IBOutlet weak var textFieldAge: UITextField!
  @IBOutlet weak var textFieldWeight: UITextField!
  @IBOutlet weak var textFieldInterests: UITextField!
  @IBOutlet weak var textFieldDuration: UITextField!
  @IBOutlet weak var createOrderButton: UIButton!
  
  //MARK: - Vars
  weak var delegate: MapViewControllerDelegate?
  
  var dataAddress: String?
  var dataLatitude: Double?
  var dataLongitude: Double?
  
  let properties = Parameters.shared
  
  let arrayOfGender = Parameters.shared.getGender()
  let arrayOfAges = Parameters.shared.getAge()
  let arrayOfWeight = Parameters.shared.getWeight()
  let arrayOfInterests = Parameters.shared.getInterests()
  let arrayOfDuration = Parameters.shared.getDuration()
  
  let pickerView = UIPickerView()
  var activeTextField = 0
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    
    textFieldGender.delegate = self
    textFieldAge.delegate = self
    textFieldWeight.delegate = self
    textFieldInterests.delegate = self
    textFieldDuration.delegate = self
  }
  
  //MARK: - IBActions
  @IBAction func createOrderButtonPressed(_ sender: UIButton) {
    
    if textFieldGender.text != "" && textFieldAge.text != "" && textFieldWeight.text != "" && textFieldInterests.text != "" && textFieldDuration.text != "" {
      
      guard let gender = textFieldGender.text, let age = textFieldAge.text, let weight = textFieldWeight.text, let interest = textFieldInterests.text, let duration = textFieldDuration.text else { return }
      
      guard let latitude = dataLatitude, let longitude = dataLongitude else { return }
      
      let newOrder = Order(location: dataAddress ?? "Зеленоград", latitude: latitude, longitude: longitude, gender: gender, age: age, weight: weight, interests: interest, duration: 0)
      
      newOrder.ownerId = User.currentId()
      
      switch duration {
      case "1 час":
        newOrder.duration = 1
        guard let dateOfEnd = getDateOfEnd(timeInterval: newOrder.date, duration: newOrder.duration) else { return }
        newOrder.dateOfEnd = dateOfEnd
      case "2 часа":
        newOrder.duration = 2
        guard let dateOfEnd = getDateOfEnd(timeInterval: newOrder.date, duration: newOrder.duration) else { return }
        newOrder.dateOfEnd = dateOfEnd
      default:
        newOrder.duration = 3
        guard let dateOfEnd = getDateOfEnd(timeInterval: newOrder.date, duration: newOrder.duration) else { return }
        newOrder.dateOfEnd = dateOfEnd
      }
      
//      StorageManager.saveObject(newOrder)
//      print("### Заказ успешно сохранен локально###")
      
      NetworkManager.shared.saveOrderToFirestore(newOrder)
      print("### Заказ успешно сохранен в Firestore###")
      
      setupOrder(newOrder)
      showSuccessVC()
      
    } else {
      showAlert(title: "Не все поля заполнены", message: "Заполните, пожалуйста, все поля!")
    }
  }
  
  //MARK: - Get Date of end
  
  func getDateOfEnd(timeInterval: TimeInterval, duration: Int) -> TimeInterval? {
    
    let date = Date(timeIntervalSince1970: timeInterval)
    let calendar = Calendar.current
    let dateOfEnd = calendar.date(byAdding: .hour, value: duration, to: date)?.timeIntervalSince1970
    
    return dateOfEnd
  }
  
  //MARK: - Set up Order on map
  
  private func setupOrder(_ order: Order) {
    delegate?.getOrder(order)
  }
  
  //MARK: - Show SuccessViewController
  
  private func showSuccessVC() {
    
    weak var presentingVC = presentingViewController
    
    self.dismiss(animated: true, completion: {
      let successVC = SuccessViewController()
      successVC.modalPresentationStyle = .overFullScreen
      presentingVC?.present(successVC, animated: true, completion: nil)
    })
  }
  
  //MARK: - Setup View
  private func setupView() {
    
    textFieldGender.backgroundColor = UIColor(white: 1, alpha: 0.3)
    textFieldAge.backgroundColor = UIColor(white: 1, alpha: 0.3)
    textFieldWeight.backgroundColor = UIColor(white: 1, alpha: 0.3)
    textFieldInterests.backgroundColor = UIColor(white: 1, alpha: 0.3)
    textFieldDuration.backgroundColor = UIColor(white: 1, alpha: 0.3)
    
    view.backgroundColor = UIColor(white: 1, alpha: 0.1)
    imageViewBackground.blurImage()
    
    createPickerView()
    createToolbar()
  }
  
  //MARK: - Create objects (pickerView, toolar)
  private func createPickerView() {
    
    pickerView.delegate = self
    pickerView.delegate?.pickerView?(pickerView, didSelectRow: 0, inComponent: 0)
    
    textFieldGender.inputView = pickerView
    textFieldAge.inputView = pickerView
    textFieldWeight.inputView = pickerView
    textFieldInterests.inputView = pickerView
    textFieldDuration.inputView = pickerView
    
    pickerView.backgroundColor = UIColor.white
  }
  
  private func createToolbar() {
    
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    toolbar.tintColor = UIColor.systemBlue
    toolbar.backgroundColor = UIColor.white
    
    let doneButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(WhoDoYouNeedViewController.closePickerView))
    toolbar.setItems([doneButton], animated: false)
    toolbar.isUserInteractionEnabled = true
    
    textFieldGender.inputAccessoryView = toolbar
    textFieldAge.inputAccessoryView = toolbar
    textFieldWeight.inputAccessoryView = toolbar
    textFieldInterests.inputAccessoryView = toolbar
    textFieldDuration.inputAccessoryView = toolbar
  }
  
  //MARK: - @objc methods
  @objc func closePickerView() {
    view.endEditing(true)
  }
  
  //MARK: - Helpers func
  private func showAlert(title: String, message: String) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(okAction)
    self.present(alert, animated: true, completion: nil)
  }
}

//MARK: - PickerViewDataSource, PickerViewDelegate
extension WhoDoYouNeedViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    switch activeTextField
    {
    case 1:
      return properties.countOfGender()
    case 2:
      return properties.countOfAge()
    case 3:
      return properties.countOfWeight()
    case 4:
      return properties.countOfInterests()
    case 5:
      return properties.countOfDuration()
    default:
      print("Undefined")
      return 0
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
    switch activeTextField {
    case 1:
      return arrayOfGender[row]
    case 2:
      return arrayOfAges[row]
    case 3:
      return arrayOfWeight[row]
    case 4:
      return arrayOfInterests[row]
    case 5:
      return arrayOfDuration[row]
    default:
      print("Undefined")
      return "Undefined"
    }
    
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    switch activeTextField {
      
    case 1:
      textFieldGender.text =  arrayOfGender[row]
      break
      
    case 2:
      textFieldAge.text = arrayOfAges[row]
      break
      
    case 3:
      textFieldWeight.text = arrayOfWeight[row]
      break
      
    case 4:
      textFieldInterests.text = arrayOfInterests[row]
      break
      
    case 5:
      textFieldDuration.text = arrayOfDuration[row]
    default:
      print("Undefined")
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
    return 300.0
  }
  
  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return 30.0
  }
}

//MARK: - TextFieldDelegate
extension WhoDoYouNeedViewController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    
    switch textField {
      
    case textFieldGender:
      activeTextField = 1
      pickerView.reloadAllComponents()
      
    case textFieldAge:
      activeTextField = 2
      pickerView.reloadAllComponents()
      
    case textFieldWeight:
      activeTextField = 3
      pickerView.reloadAllComponents()
      
    case textFieldInterests:
      activeTextField = 4
      pickerView.reloadAllComponents()
      
    case textFieldDuration:
      activeTextField = 5
      pickerView.reloadAllComponents()
      
    default:
      print("undefined")
    }
  }
}
