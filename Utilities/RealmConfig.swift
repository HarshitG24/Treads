//
//  RealmConfig.swift
//  Treads
//
//  Created by Harshit Gajjar on 6/24/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConfig{
    static var runDataConfig: Realm.Configuration{
        let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(REALM_RUN_CONFIG)
        let config =  Realm.Configuration(
            fileURL: realmPath,
            schemaVersion: 0, // everytime update model, increase this number
            migrationBlock: {migration, oldSchemaVersion in
                if oldSchemaVersion < 0{
                    // nothing to do...
                    // realm will automatically detect new properties and update new properties
                }
        })
        return config
    }
}
