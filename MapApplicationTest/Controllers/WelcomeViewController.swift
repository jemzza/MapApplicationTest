//
//  WelcomeViewController.swift
//  MapApplicationTest
//
//  Created by Alexander on 20.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
  
  //MARK: - IBOutlets
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func loginButtonPressed(_ sender: UIButton) {
    
    print("Login user")
    
    if textFieldsHaveText() {
      
      loginUser()
    } else {
      showAlert(title: "Ошибка при авторизации", message: "Все поля должны быть заполнены")
    }
  }
  
  @IBAction func registerButtonPressed(_ sender: UIButton) {
    
    print("Regiseter")
    
    if textFieldsHaveText() {
      
      registerUser()
    } else {
      showAlert(title: "Ошибка при регистрации", message: "Все поля должны быть заполнены")
    }
  }
  
  //MARK: - Login User
  private func loginUser() {
        
    User.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
      
      if error == nil {
        
        if isEmailVerified {
          
          self.dismsissView()
          print("Email is verified")
        } else {
          
          self.showAlert(title: "Ошибка при авторизации", message: "Пожалуйста, подтвердите ваш email")
        }
        
      } else {
        print("Error loging in the user", error!.localizedDescription)
        
        self.showAlert(title: "Ошибка при авторизации", message: error!.localizedDescription)
      }
    }
  }
  
  //MARK: - Register User
  
  private func registerUser() {
        
    User.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
      
      if error == nil {
        
        self.showAlert(title: "Успешная регистрация", message: "Подвтерждение регистрации выслано на почту")
        
      } else {
        
        self.showAlert(title: "Ошибка при регистрации", message: error!.localizedDescription)
      }
    }
  }
  
  //MARK: - Helpers
  
  private func textFieldsHaveText() -> Bool {
    return (emailTextField.text != "" && passwordTextField.text != "")
  }
  
  private func dismsissView() {
    self.dismiss(animated: true, completion: nil)
  }
  
  //MARK: - Show alert
  
  private func showAlert(title: String, message: String) {
    
    print("Show alert")
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    
    alert.addAction(okAction)
    
    present(alert, animated: true, completion: nil)
  }
}
