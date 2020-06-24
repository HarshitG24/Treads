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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        mapView.delegate = self
        manager?.startUpdatingLocation()
      //  getLastRun()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupMapView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        manager?.stopUpdatingLocation()
    }
    
    func setupMapView(){
        if let overlay = addLastRunToMap(){
            if mapView.overlays.count > 0{
                // map already has overlay, so we need to remove that first
                mapView.removeOverlays(mapView.overlays)
            }
            mapView.addOverlay(overlay)
            lastRunView.isHidden = false
            lastrunStack.isHidden = false
            closeBtn.isHidden = false
        }else{
            lastRunView.isHidden = true
            lastrunStack.isHidden = true
            closeBtn.isHidden = true
        }
    }
    
    func addLastRunToMap() -> MKPolyline?{
        guard let run =  Run.getAllRuns()?.first else { return nil }
        paceLbl.text = run.pace.formatTimeDurationToString()
        durationLbl.text = run.duration.formatTimeDurationToString()
        distancelbl.text = "\(run.distance.meterToMiles(places: 2)) mi"
        
        var coordinate = [CLLocationCoordinate2D]()
        
        for location in run.locations{
            coordinate.append(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
        }
        
        return MKPolyline(coordinates: coordinate, count: run.locations.count)
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
    
    // to draw polyline
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        renderer.lineWidth = 4
        return renderer
    }
}
