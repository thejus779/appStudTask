//
//  Place.swift
//  AppstudTest
//
//  Created by thejus manoharan on 09/06/2018.
//  Copyright © 2018 thejus. All rights reserved.
//

import Foundation
import MapKit

class Places: NSObject, MKAnnotation {
    let title: String?
    let imgBackGround: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D, imgBackGround: String) {
        self.title = title
        self.imgBackGround = imgBackGround
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
