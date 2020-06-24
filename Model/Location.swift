//
//  Location.swift
//  Treads
//
//  Created by Harshit Gajjar on 6/24/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object{
    @objc dynamic private(set) public var latitude = 0.0
    @objc dynamic private(set) public var longitude = 0.0
    
    convenience init(lat : Double, long: Double){
        self.init()
        self.latitude = lat
        self.longitude = long
    }
}
