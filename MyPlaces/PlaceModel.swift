//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Андрей on 16.11.2023.
//

import Realm
import RealmSwift
import UIKit

class Place: Object {
    @Persisted var name = ""
    @Persisted var location: String?
    @Persisted var type: String?
    @Persisted var imageData: Data?
    @Persisted var date = Date()
    
    convenience init(name: String, location: String?, type: String?, imageData: Data?) {
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
    }
}
