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
    
   // list cannot be declared as dynamic as it is generic in nature
   private(set) public var locations = List<Location>()
    
    
    // we need to tell realm, which property will be our primary key
    override class func primaryKey() -> String {
        return "id"
    }
    
    // indexedProperties dont work with double
    override class func indexedProperties() -> [String] {
        return ["date", "pace", "duration"]
    }
    
    convenience init(pace: Int, distance: Double, duration: Int, locations: List<Location>){
        self.init()
        self.id = UUID().uuidString
        self.date = NSDate()
        self.pace = pace
        self.duration = duration
        self.distance = distance
        self.locations = locations
    }
    
    // static here so that, we need make the run object static
    // we need to create realm object for every operation
    static func addRunToRealm(pace: Int, distance: Double, duration: Int, locations: List<Location>){
        REALM_QUEUE.sync {
            let run =  Run(pace: pace, distance: distance, duration: duration, locations: locations)
            do{
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
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
            let realm = try Realm(configuration: RealmConfig.runDataConfig)
            var runs = realm.objects(Run.self)
            runs = runs.sorted(byKeyPath: "date", ascending: false)
            return runs
        }catch{
            return nil
        }
    }
    
    static func deleteRun(run: Run){
        do{
            let realm = try Realm(configuration: RealmConfig.runDataConfig)
            try! realm.write {
                realm.delete(run)
            }
        }catch{
            debugPrint("Unable to delete")
        }
    }
}
