//
//  ViewController.swift
//  NatureCallsApp
//
//  Created by Iavor Dekov on 2/14/17.
//  Copyright © 2017 Iavor Dekov. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        testOverlay()
    }
    
    func setupLocationManager() {
        locationManager.startUpdatingLocation()
        centerMapOn(location: locationManager.location!)
    }
    
    func centerMapOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func testOverlay() {
        let mkCircle1 = MKCircle(center: locationManager.location!.coordinate, radius: CLLocationDistance(exactly: 1000.0)!)
        mkCircle1.title = "circle1"
        let mkCircle2 = MKCircle(center: locationManager.location!.coordinate, radius: CLLocationDistance(exactly: 500.0)!)
        mkCircle2.title = "circle2"
        let mkCircle3 = MKCircle(center: locationManager.location!.coordinate, radius: CLLocationDistance(exactly: 250.0)!)
        mkCircle3.title = "circle3"
        mapView.addOverlays([mkCircle1, mkCircle2, mkCircle3])
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        centerMapOn(location: locations.last!)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("There was an error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            setupLocationManager()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default: break
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circleOverlay = overlay as? MKCircle {
            let mkCircleRenderer = MKCircleRenderer(circle: circleOverlay)
            switch circleOverlay.title! {
            case "circle1":
                mkCircleRenderer.fillColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.1)
            case "circle2":
                mkCircleRenderer.fillColor = UIColor(red: 0, green: 1.0, blue: 0, alpha: 0.1)
            case "circle3":
                mkCircleRenderer.fillColor = UIColor(red: 0, green: 0, blue: 1.0, alpha: 0.1)
            default: break
            }
            return mkCircleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
