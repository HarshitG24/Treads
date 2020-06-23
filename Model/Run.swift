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
   @objc dynamic private(set) public var id = ""
   @objc dynamic private(set) public var date = NSDate()
   @objc dynamic private(set) public var pace = 0
   @objc dynamic private(set) public var distance = 0.0
   @objc dynamic private(set) public var duration = 0
    
    // we need to tell realm, which property will be our primary key
    override class func primaryKey() -> String {
        return "id"
    }
    
    // indexedProperties dont work with double
    override class func indexedProperties() -> [String] {
        return ["date", "pace", "duration"]
    }
    
    convenience init(pace: Int, distance: Double, duration: Int){
        self.init()
        self.id = UUID().uuidString
        self.date = NSDate()
        self.pace = pace
        self.duration = duration
        self.distance = distance
    }
    
    // static here so that, we need make the run object static
    // we need to create realm object for every operation
    static func addRunToRealm(pace: Int, distance: Double, duration: Int){
        REALM_QUEUE.sync {
            let run =  Run(pace: pace, distance: distance, duration: duration)
            do{
                let realm = try Realm()
                try realm.write{
                    realm.add(run)
                    try realm.commitWrite() // safe to use, ensure everything is saved
                }
            }catch{
                debugPrint("error saving run object to realm")
            }
        }
    }
    
    // order of data is not fixed here.
    static func getAllRuns() -> Results<Run>?{
        do{
            let realm = try Realm()
            var runs = realm.objects(Run.self)
            runs = runs.sorted(byKeyPath: "date", ascending: false)
            return runs
        }catch{
            return nil
        }
    }
}
