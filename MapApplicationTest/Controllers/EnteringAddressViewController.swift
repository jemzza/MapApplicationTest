//
//  EnteringAddressViewController.swift
//  MapApplicationTest
//
//  Created by Alexander on 16.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import UIKit

class EnteringAddressViewController: UIViewController {
  
  weak var delegate: MapViewControllerDelegate?
  let blurredBackground = UIImageView()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Где?"
    label.textColor = .darkGray
    label.font = UIFont.systemFont(ofSize: 32)
    return label
  }()
  
  let addressTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Введите адрес"
    textField.layer.borderColor = UIColor.black.cgColor
    textField.textColor = .darkGray
    textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    return textField
  }()
  
  let doneButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.isEnabled = true
    button.backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.5921568627, blue: 0.8588235294, alpha: 1)
    button.setTitle("Готово", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
    button.tintColor = .white
    button.addTarget(self, action: #selector(doneButtonPressed), for: .touchDown)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped(_:)))
    view.addGestureRecognizer(tapGestureRecognizer)
    
    setupView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupConstraints()
  }
  
  func setupView() {
    
    view.backgroundColor = UIColor(white: 1, alpha: 0.1)
    
    blurredBackground.frame = self.view.bounds
    blurredBackground.blurImage()
    
    view.addSubview(blurredBackground)
    view.addSubview(nameLabel)
    view.addSubview(addressTextField)
    view.addSubview(doneButton)
  }
  
  //MARK: - Constraints
  
  func setupConstraints() {
    
    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
      nameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      
      addressTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
      addressTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      addressTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      
      doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
      doneButton.heightAnchor.constraint(equalToConstant: 45),
      doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
      doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
    ])
  }
  
  @objc
  func doneButtonPressed() {
    print("action doneButtonPressed \n  Begin search location...")
    delegate?.getAddress(addressTextField.text!)
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc
  func backgroundTapped(_ sender: UITapGestureRecognizer) {
    dismissKeyboard()
  }
  
  //MARK: - Helper functions
  
  private func dismissKeyboard() {
    self.view.endEditing(false)
  }
}

// MARK: - Text field delegate
extension EnteringAddressViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  @objc
  private func textFieldChanged() {
    
    print("Change text in addressTextField")
    if addressTextField.text?.isEmpty == false {
      doneButton.isEnabled = true
    } else {
      doneButton.isEnabled = false
    }
  }
}

extension UIImageView{
  func blurImage()
  {
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = self.bounds
    
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.addSubview(blurEffectView)
  }
}
