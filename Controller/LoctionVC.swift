//
//  LoctionVC.swift
//  Treads
//
//  Created by Harshit Gajjar on 6/22/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import UIKit
import MapKit

class LocationVC: UIViewController,MKMapViewDelegate{
    
    var manager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        manager = CLLocationManager()
        manager!.desiredAccuracy = kCLLocationAccuracyBest
        manager!.activityType = .fitness
    }
    
    // reuqest location again, if the user doesnt grant permission
    func checkLocationAuthStatus(){
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse{
            manager?.requestWhenInUseAuthorization()
        }
    }
}
