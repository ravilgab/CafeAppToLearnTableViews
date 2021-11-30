//
//  CafeModel.swift
//  MessingWithTableView
//
//  Created by Ravil on 28.11.2021.
//

import RealmSwift

class Cafe: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    
//    convenience init()
}
