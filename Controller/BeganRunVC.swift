//
//  FirstViewController.swift
//  Treads
//
//  Created by Harshit Gajjar on 6/22/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import UIKit
import MapKit

class BeganRunVC: LocationVC {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.startUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    @IBAction func locationCentrebtnPressed(_ sender: Any) {
    }
    

}

extension BeganRunVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow // to get that blue circle which keeps moving, depending upon our location
        }
    }
}
