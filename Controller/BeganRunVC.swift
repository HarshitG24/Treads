//
//  FirstViewController.swift
//  Treads
//
//  Created by Harshit Gajjar on 6/22/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

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
            centreMapOnUserLocation()
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
        mapView.userTrackingMode = .none
        mapView.setRegion(centreMaponRoute(location: run.locations), animated: true)
        return MKPolyline(coordinates: coordinate, count: run.locations.count)
    }
    
    func centreMapOnUserLocation(){
        mapView.userTrackingMode = .follow
        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centreMaponRoute(location: List<Location>)-> MKCoordinateRegion{
        guard let initialLocation = location.first else {return MKCoordinateRegion()}
        var minLat = initialLocation.latitude
        var minLon = initialLocation.longitude
        var maxLat = minLat
        var maxLon = minLon
        
        for loc in location{
            minLat = min(minLat, loc.latitude)
            minLon = min(minLon, loc.longitude)
            maxLat = max(maxLat, loc.latitude)
            maxLon = max(maxLon, loc.longitude)
        }
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2), span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 2, longitudeDelta: (maxLon - minLon) * 2))
    }
    
    
    @IBAction func locationCentrebtnPressed(_ sender: Any) {
        centreMapOnUserLocation()
    }
    
    @IBAction func lastRunClose(_ sender: Any) {
        lastRunView.isHidden = true
        lastrunStack.isHidden = true
        closeBtn.isHidden = true
        centreMapOnUserLocation()
    }
    
}

extension BeganRunVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            checkLocationAuthStatus()
            mapView.showsUserLocation = true
        //    mapView.userTrackingMode = .follow // to get that blue circle which keeps moving, depending upon our location
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
