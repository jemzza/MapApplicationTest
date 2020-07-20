//
//  SuccessViewController.swift
//  MapApplicationTest
//
//  Created by Alexander on 19.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {
  
  //MARK: - Vars
  let imageViewBackground = UIImageView()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Заказ успешно размещен"
    label.textColor = .darkGray
    label.font = UIFont.systemFont(ofSize: 32)
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  let doneButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.isEnabled = true
    button.backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.5921568627, blue: 0.8588235294, alpha: 1)
    button.setTitle("Готово", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
    button.tintColor = .white
    button.layer.cornerRadius = 10
    button.addTarget(self, action: #selector(doneButtonPressed), for: .touchDown)
    return button
  }()
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setupConstraints()
  }
  
  //MARK: - Setup View
  func setupView() {
    
    view.backgroundColor = UIColor(white: 1, alpha: 0.1)
    
    imageViewBackground.frame = self.view.bounds
    imageViewBackground.blurImage()
    
    view.addSubview(imageViewBackground)
    view.addSubview(nameLabel)
    view.addSubview(doneButton)
  }
  
  //MARK: - Constraints
  func setupConstraints() {
    
    NSLayoutConstraint.activate([
      nameLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
      nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
      nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
      
      doneButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
      doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40)
    ])
  }
  
  //MARK: - @objc methods
  @objc
  func doneButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }
}
