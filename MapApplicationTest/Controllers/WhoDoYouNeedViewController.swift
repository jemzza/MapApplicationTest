//
//  WhoDoYouNeedViewController.swift
//  MapApplicationTest
//
//  Created by Alexander on 17.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import UIKit

class WhoDoYouNeedViewController: UIViewController {
  
  @IBOutlet weak var imageViewBackgound: UIImageView!
  @IBOutlet weak var textField1Gender: UITextField!
  @IBOutlet weak var textField2Age: UITextField!
  @IBOutlet weak var textField3Weight: UITextField!
  @IBOutlet weak var textField4Interests: UITextField!
  
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
  var activeTextField = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    
    textField1Gender.delegate = self
    textField2Age.delegate = self
    textField3Weight.delegate = self
    textField4Interests.delegate = self
  }
  
  private func setupView() {
    
    textField1Gender.backgroundColor = UIColor(white: 1, alpha: 0.3)
    textField2Age.backgroundColor = UIColor(white: 1, alpha: 0.3)
    textField3Weight.backgroundColor = UIColor(white: 1, alpha: 0.3)
    textField4Interests.backgroundColor = UIColor(white: 1, alpha: 0.3)
    
    view.backgroundColor = UIColor(white: 1, alpha: 0.1)
    imageViewBackgound.blurImage()
    
    createPickerView()
    createToolbar()
  }
  
  private func createPickerView() {
    pickerView.delegate = self
    pickerView.delegate?.pickerView?(pickerView, didSelectRow: 0, inComponent: 0)
    textField1Gender.inputView = pickerView
    textField2Age.inputView = pickerView
    textField3Weight.inputView = pickerView
    textField4Interests.inputView = pickerView
    
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
    
    textField1Gender.inputAccessoryView = toolbar
    textField2Age.inputAccessoryView = toolbar
    textField3Weight.inputAccessoryView = toolbar
    textField4Interests.inputAccessoryView = toolbar
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
    default:
      print("Undefined")
      return "Undefined"
    }
    
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    switch activeTextField {
      
    case 1:
      textField1Gender.text =  arrayOfGender[row]
      break
      
    case 2:
      textField2Age.text = arrayOfAges[row]
      break
      
    case 3:
      textField3Weight.text = arrayOfWeight[row]
      break
      
    case 4:
      textField4Interests.text = arrayOfInterests[row]
      break
    default:
      print("Undefined")
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
    return 100.0
  }
  
  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return 60.0
  }
}

extension WhoDoYouNeedViewController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    
    switch textField {
      
    case textField1Gender:
      activeTextField = 1
      pickerView.reloadAllComponents()
      
    case textField2Age:
      activeTextField = 2
      pickerView.reloadAllComponents()
      
    case textField3Weight:
      activeTextField = 3
      pickerView.reloadAllComponents()
      
    case textField4Interests:
      activeTextField = 4
      pickerView.reloadAllComponents()
      
    default:
      print("undefined")
    }
    
  }
}
