//
//  FoursquareAPI.swift
//  FoursquareVenues
//
//  Created by XD on 6/13/14.
//  Copyright (c) 2014 XD. All rights reserved.
//

import Foundation
import corelocation

protocol FoursquareAPIProtocol {
    func didRecieveVenues(results: Venue[])
}

class FoursquareAPI: NSObject {
    
    let clientId = "NO5FPYCJZZGGPWKNRYBM1RVUSKBZXPFAQDY14JHD3H4L2FGB"
    let clientSecret = "RD3VVZFH22KUEB0B2NJ4GMPLIS1OZA4SFEFQQVKBARVHAPDB"
    let version = "20140613"
    
    let radiusInMeters = 10000
    let categoryId = "4bf58dd8d48988d1e0931735"
    
    var data: NSMutableData = NSMutableData()
    var delegate: FoursquareAPIProtocol?
    
    func searchForCofeeShopsAtLocation(userLocation: CLLocation) {
        var urlPath = "https://api.foursquare.com/v2/venues/search?ll=\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)&categoryId=\(categoryId)&radius=\(radiusInMeters)&client_id=\(clientId)&client_secret=\(clientSecret)&v=\(version)"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        
        var session: NSURLSession = NSURLSession.sharedSession()
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as NSDictionary
            var venues: Venue[] = []
            
            if(err) {
                println(err!.localizedDescription)
            }
            else {
                if json.count>0 {
                    let response: NSDictionary = json["response"] as NSDictionary
                    let allVenues: NSDictionary[] = response["venues"] as NSDictionary[]

                    for venue:NSDictionary in allVenues {
                        var venueName:String = venue["name"] as String
                        
                        var location:NSDictionary = venue["location"] as NSDictionary
                        var venueLocation:CLLocation = CLLocation(latitude: location["lat"] as Double, longitude: location["lng"] as Double)
                        
                        venues.append(Venue(name: venueName, location: venueLocation, distanceFromUser: venueLocation.distanceFromLocation(userLocation)))
                    }
                }
                
                self.delegate?.didRecieveVenues(venues)
            }
        })
        
        task.resume()
    }
}