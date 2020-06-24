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
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var distancelbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var lastRunView: UIView!
    @IBOutlet weak var lastrunStack: UIStackView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.startUpdatingLocation()
        getLastRun()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    func getLastRun(){
        guard let run =  Run.getAllRuns()?.first else {
            lastRunView.isHidden = true
            lastrunStack.isHidden = true
            closeBtn.isHidden = true
            return
        }
        lastRunView.isHidden = false
        lastrunStack.isHidden = false
        closeBtn.isHidden = false
        paceLbl.text = run.pace.formatTimeDurationToString()
        durationLbl.text = run.duration.formatTimeDurationToString()
        distancelbl.text = "\(run.distance.meterToMiles(places: 2)) mi"
    }
    
    @IBAction func locationCentrebtnPressed(_ sender: Any) {
    }
    
    @IBAction func lastRunClose(_ sender: Any) {
        lastRunView.isHidden = true
        lastrunStack.isHidden = true
        closeBtn.isHidden = true
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
