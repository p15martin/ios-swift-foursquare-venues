//
//  Venue
//  FoursquareVenues
//
//  Created by XD on 6/13/14.
//  Copyright (c) 2014 XD. All rights reserved.
//

import UIKit
import corelocation

class Venue: NSObject {
   
    let name:String!
    let location:CLLocation!
    let distanceFromUser:CLLocationDistance!
    
    init(name: String, location: CLLocation, distanceFromUser: Double) {
        self.name = name
        self.location = location
        self.distanceFromUser = distanceFromUser
    }
}