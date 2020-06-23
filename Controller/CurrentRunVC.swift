//
//  CurrentRunVC.swift
//  Treads
//
//  Created by Harshit Gajjar on 6/23/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import UIKit
import MapKit

class CurrentRunVC: LocationVC {

    
    @IBOutlet weak var sliderBackground: UIButton!
    @IBOutlet weak var sliderImageView: UIButton!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var runDistance = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(endRunSwiped(sender:)))
        sliderImageView.addGestureRecognizer(swipeGesture)
        sliderImageView.isUserInteractionEnabled = true
        swipeGesture.delegate = self as? UIGestureRecognizerDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
        manager?.distanceFilter = 10 // min distance a device must move to generate update, 10 meters
        startRun()
    }
    
    func startRun(){
        manager?.startUpdatingLocation()
    }
    
    func endRun(){
        manager?.stopUpdatingLocation()
    }
    
    @IBAction func pauseButtonPressed(_ sender: Any){
        
    }
    
    @objc func endRunSwiped(sender: UIPanGestureRecognizer){
        let minAdjust: CGFloat = 80
        let maxAdjust: CGFloat = 130
        if let sliderView = sender.view{
            if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed{
                let translation = sender.translation(in: self.view) // how many points to add or subtract from centre
                if sliderView.center.x >= (sliderBackground.center.x - minAdjust) && sliderView.center.x <= (sliderBackground.center.x + maxAdjust){
                    
                    sliderView.center = CGPoint(x: sliderView.center.x + translation.x, y: sliderView.center.y)
                }else if sliderView.center.x >= (sliderBackground.center.x + maxAdjust){
                    sliderView.center.x = sliderBackground.center.x + maxAdjust
                    // End run code goes here...
                    dismiss(animated: true, completion: nil)
                }else{
                    sliderView.center.x = sliderBackground.center.x - minAdjust
                }
                
                sender.setTranslation(CGPoint.zero, in: self.view)
            }else if sender.state == UIGestureRecognizer.State.ended{
                UIView.animate(withDuration: 0.1) {
                    sliderView.center.x = self.sliderBackground.center.x - minAdjust
                }
            }
        }
    }
}

extension CurrentRunVC: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse{
            checkLocationAuthStatus()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if startLocation == nil{
            // run not started yet...
            startLocation = locations.first
        }else if let location = locations.last{
            // run has already started...
            runDistance += lastLocation.distance(from: location) // distance between last location and the location got
            distanceLbl.text = "\(runDistance)"
        }
        
        lastLocation = locations.last
    }
}
