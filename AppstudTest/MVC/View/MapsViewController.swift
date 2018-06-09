//
//  MapsViewController.swift
//  AppstudTest
//
//  Created by thejus manoharan on 09/06/2018.
//  Copyright © 2018 thejus. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import GooglePlaces
import GoogleMaps
import SDWebImage

class MapsViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 1000
    var tag:Int = 0
    
    var arrPlaces: [Places] = []
    var pin: Places!
    var latitude:String = ""
    var longitude:String = ""
    var location: CLLocation? = nil
    var searchActive : Bool = false
    let apiKey = "AIzaSyCTK5ZKQlhUoKMxpLCRzpw6Cpe1EC6C65Q"
    var swiftyJsonVar:JSON = JSON.null
    var arrRes = [[String:AnyObject]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        self.mapView.delegate = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - Fethc Places API
    
    func fetchPlaces(url:String){
        
        Alamofire.request(url).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                self.swiftyJsonVar = JSON(responseData.result.value!)
                print(self.swiftyJsonVar)
                
                if let resData = self.swiftyJsonVar["results"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                    for dict in self.arrRes{
                        var pLatitude:Double? = nil
                        var pLongitude:Double? = nil
                        if let geo:NSDictionary = dict["geometry"] as? NSDictionary{
                            let locationCord:NSDictionary = geo.value(forKey: "location") as! NSDictionary
                            pLatitude = locationCord.value(forKey: "lat") as? Double
                            pLongitude = locationCord.value(forKey: "lng") as? Double
                        }
                        
                        var photo_ref:String = ""
                        if let arr:NSArray = dict["photos"] as? NSArray{
                            let imgData = arr.firstObject as AnyObject
                            photo_ref = (imgData["photo_reference"] as? String)!
                        }
                        
                        let place = Places(title: dict["name"] as! String,
                                           locationName: dict["vicinity"] as! String,
                                           coordinate: CLLocationCoordinate2D(latitude: (pLatitude)!, longitude: (pLongitude)!), imgBackGround: photo_ref)
                        self.arrPlaces.append(place)
                    }
                    self.mapView.addAnnotations(self.arrPlaces)
                }
                
            }
        }
    }
    
}
// MARK: - Extension Location Delegates

extension MapsViewController : CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            self.location = location
            self.longitude = "\(location.coordinate.longitude)"
            self.latitude = "\(location.coordinate.latitude)"
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
                
            case .restricted, .denied:
                // Disable location features
                break
                
            case .authorizedWhenInUse, .authorizedAlways:
                // Enable location features
                let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=1000&type=restaurant&keyword=bar&key=\(apiKey)"
                self.fetchPlaces(url:url)
                break
            }
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}


// MARK: - Extension MapView Delegates
extension MapsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //Custom Annotation Pin
        
        
        if annotation is MKUserLocation { return nil }
        
        var photo_ref:String = ""
        if(tag < arrRes.count){
        var dict = arrRes[tag]
        if let arr:NSArray = dict["photos"] as? NSArray{
            let imgData = arr.firstObject as AnyObject
            photo_ref = (imgData["photo_reference"] as? String)!
        }
        }
        
        let annotationView = MKAnnotationView(annotation: pin, reuseIdentifier: "pinPlaces")
        let myImageView=UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        myImageView.sd_setImage(with: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photoreference=\(photo_ref)&key=\(apiKey)"), placeholderImage: UIImage(named: "placeholder.png"))
        myImageView.clipsToBounds=true
        myImageView.layer.cornerRadius=myImageView.frame.width/2
        myImageView.layer.borderColor = UIColor.black.cgColor
        myImageView.layer.borderWidth=5
        annotationView.addSubview(myImageView)
        annotationView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        tag = tag + 1
        
        return annotationView
        
    }
}
