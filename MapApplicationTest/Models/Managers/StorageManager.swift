//
//  StorageManager.swift
//  MapApplicationTest
//
//  Created by Alexander on 18.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

final class StorageManager {
    
    static func saveObject(_ order: Order) {
        
        try! realm.write {
            realm.add(order)
        }
    }
    
    static func deleteObject(_ order: Order) {
        
        try! realm.write {
            realm.delete(order)
        }
    }
}
