//
//  WhoDoYouNeedViewController.swift
//  MapApplicationTest
//
//  Created by Alexander on 17.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import UIKit

class WhoDoYouNeedViewController: UIViewController {
  
  var order: Order!
  
  @IBOutlet weak var imageViewBackground: UIImageView!
  @IBOutlet weak var textFieldGender: UITextField!
  @IBOutlet weak var textFieldAge: UITextField!
  @IBOutlet weak var textFieldWeight: UITextField!
  @IBOutlet weak var textFieldInterests: UITextField!
  @IBOutlet weak var textFieldDuration: UITextField!
  @IBOutlet weak var createOrderButton: UIButton!
  
  let pickerView = UIPickerView()
  var arrayOfGender = ["Мужской",
                       "Женский"]
  var arrayOfAges = ["20-25",
                     "25-30",
                     "30-35",
                     "35-40",
                     "40-45",
                     "50-55",
                     "55-60",]
  var arrayOfWeight = ["50-55",
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
  var arrayOfInterests = ["Почитать книгу",
                          "Посмотреть кино",
                          "Помочь по дому",
                          "Прогулка",
                          "Cходить в кино",
                          "Другое"]
  var arrayOfDuration = ["1 час",
                         "2 часа",
                         "3 часа",]
  var activeTextField = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    
    textFieldGender.delegate = self
    textFieldAge.delegate = self
    textFieldWeight.delegate = self
    textFieldInterests.delegate = self
    textFieldDuration.delegate = self
  }
  @IBAction func createOrderButtonPressed(_ sender: UIButton) {
    
    if textFieldGender.text != "" && textFieldAge.text != "" && textFieldWeight.text != "" && textFieldInterests.text != "" && textFieldDuration.text != "" {
      
      guard let gender = textFieldGender.text, let age = textFieldAge.text, let weight = textFieldWeight.text, let interest = textFieldInterests.text, let duration = textFieldDuration.text else { return }
      
      switch gender {
      case "Мужской":
        order.gender = .male
      default:
        order.gender = .female
      }
      
      order.age = age
      order.weight = weight
      
      switch interest {
      case "Почитать книгу":
        order.interests?.append(ReadABook())
      case "Посмотреть кино":
        order.interests?.append(WatchAFilm())
      case "Помочь по дому":
        order.interests?.append(HelpWithTheApartment())
      case "Прогулка":
        order.interests?.append(Walking())
      case "Cходить в магазин":
        order.interests?.append(GoToShopping())
      default:
        order.interests?.append(Different(name: textFieldInterests.text!))
      }
      
      switch duration {
      case "1 час":
        order.duration = DurationFirst()
      case "2 часа":
        order.duration = DurationSecond()
      default:
        order.duration = DurationThird()
      }
      
      print("### Заказ создан ###")
      
      
        
      dismiss(animated: true, completion: nil)
      
    } else {
      showAlert(title: "Не все поля заполнены", message: "Заполните, пожалуйста, все поля!")
    }
  }
  
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
  
  private func showAlert(title: String, message: String) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(okAction)
    self.present(alert, animated: true, completion: nil)
  }
  
  @objc func closePickerView() {
    view.endEditing(true)
  }
}

extension WhoDoYouNeedViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    switch activeTextField
    {
    case 1:
      return arrayOfGender.count
    case 2:
      return arrayOfAges.count
    case 3:
      return arrayOfWeight.count
    case 4:
      return arrayOfInterests.count
    case 5:
      return arrayOfDuration.count
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
