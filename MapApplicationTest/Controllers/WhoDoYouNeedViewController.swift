//
//  WhoDoYouNeedViewController.swift
//  MapApplicationTest
//
//  Created by Alexander on 17.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import UIKit

struct cellData {
  var opened = Bool()
  var title = String()
  var sectionData = [String]()
}

class WhoDoYouNeedViewController: UIViewController {
  
  var dataTable = [cellData]()
  let dataWeight = ["50-55",
                    "55-60",
                    "60-65",
                    "65-70",
                    "70-75",
                    "75-80",
                    "80-85",
                    "85-90",
                    "90-95",
                    "95-100",
                    "105-110",
  ]
  
  let dataAge = ["20-25",
                    "25-30",
                    "30-35",
                    "35-40",
                    "40-45",
                    "50-55",
                    "55-60",
  ]
    
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var nextButton: UIButton!
  let picker = UIPickerView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataTable = [cellData(opened: false, title: "Пол", sectionData: ["Мужчина", "Женщина"]),
            cellData(opened: false, title: "Возраст", sectionData: ["Пикер"]),
            cellData(opened: false, title: "Вес", sectionData: ["Пикер"]),
            cellData(opened: false, title: "Интересы", sectionData: ["Почитать книгу", "Посмотреть кино", "Помочь по дому", "Прогулка", "Cходить в кино", "Другое"])
    ]
    tableView.tableFooterView = UIView()
  }
}

extension WhoDoYouNeedViewController:  UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return dataTable.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if dataTable[section].opened == true {
      return dataTable[section].sectionData.count + 1
    } else {
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if indexPath.row == 0 {
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { return UITableViewCell() }
      cell.textLabel?.text = dataTable[indexPath.section].title
      return cell
      
    } else {
      if indexPath.section == 1 || indexPath.section == 2  {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellWithPicker") else { return UITableViewCell() }
        cell.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        cell.textLabel?.text = dataTable[indexPath.section].sectionData[indexPath.row - 1]
        return cell
      }
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { return UITableViewCell() }
      cell.textLabel?.text = dataTable[indexPath.section].sectionData[indexPath.row - 1]
      return cell
    }
    
    
    
    }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if dataTable[indexPath.section].opened == true {
      dataTable[indexPath.section].opened = false
      
      if indexPath.row != 0 {
        dataTable[indexPath.section].title = dataTable[indexPath.section].sectionData[indexPath.row - 1]
      }
      
      let sections = IndexSet.init(integer: indexPath.section)
      tableView.reloadSections(sections, with: .none)
      
    } else {
      dataTable[indexPath.section].opened = true
      
      let sections = IndexSet.init(integer: indexPath.section)
      tableView.reloadSections(sections, with: .none)
    }
  }
}

extension WhoDoYouNeedViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return 2
  }
  
  
}
