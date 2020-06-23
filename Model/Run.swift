//
//  Run.swift
//  Treads
//
//  Created by Harshit Gajjar on 6/23/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import Foundation
import RealmSwift

class Run: Object{
    dynamic private(set) public var id = ""
    dynamic private(set) public var date = NSDate()
    dynamic private(set) public var pace = 0
    dynamic private(set) public var distance = 0.0
    dynamic private(set) public var duration = 0
    
    // we need to tell realm, which property will be our primary key
    override class func primaryKey() -> String? {
        return "id"
    }
    
    // indexedProperties dont work with double
    override class func indexedProperties() -> [String] {
        return ["date", "pace", "duration"]
    }
    
    convenience init(pace: Int, distance: Double, duration: Int){
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.date = NSDate()
        self.pace = pace
        self.duration = duration
        self.distance = distance
    }
}
