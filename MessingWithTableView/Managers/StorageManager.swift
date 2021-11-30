//
//  StorageManager.swift
//  MessingWithTableView
//
//  Created by Ravil on 29.11.2021.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ cafe: Cafe) {
        try! realm.write {
            realm.add(cafe)
        }
    }
    
    static func deleteObject(_ cafe: Cafe) {
        try! realm.write {
            realm.delete(cafe)
        }
    }
}
