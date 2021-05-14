//
//  Place.swift
//  MotivationProject
//
//  Created by kvle2 on 11/24/19.
//  Copyright © 2019 kvle2. All rights reserved.
//

import MapKit
import UIKit

class Place: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    init(title:String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.coordinate = coordinate
    }
}
