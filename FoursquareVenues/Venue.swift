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
   
    var name = ""
    var location:CLLocation? = nil
    var distanceFromUser:CLLocationDistance? = nil
    
    init(name: String, location: CLLocation, distanceFromUser: Double) {
        self.name = name
        self.location = location
        self.distanceFromUser = distanceFromUser
    }
}
