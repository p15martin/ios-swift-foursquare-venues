//
//  VenuesListTableViewController.swift
//  FoursquareVenues
//
//  Created by XD on 6/13/14.
//  Copyright (c) 2014 XD. All rights reserved.
//

import UIKit
import corelocation

class VenuesListTableViewController: UITableViewController, FoursquareAPIProtocol, CLLocationManagerDelegate {
    
    let api = FoursquareAPI()
    let locationManager = CLLocationManager()
    
    var venues = Venue[]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startUpdatingLocation()
    }
    
    func locationManager(manager:CLLocationManager!, didUpdateLocations locations:AnyObject[]!) {
        let location = getLatestMeasurementFromLocations(locations)
        
        if isLocationMeasurementNotCached(location) && isHorizontalAccuracyValidMeasurement(location) && isLocationMeasurementDesiredAccuracy(location) {
            
            stopUpdatingLocation()
            findVenues(location)
        }
    }
    
    func locationManager(manager:CLLocationManager!, didFailWithError error:NSError!) {
        if error.code != CLError.LocationUnknown.toRaw() {
            stopUpdatingLocation()
        }
    }
    
    func getLatestMeasurementFromLocations(locations:AnyObject[]) -> CLLocation {
        return locations[locations.count - 1] as CLLocation
    }
    
    func isLocationMeasurementNotCached(location:CLLocation) -> Bool {
        return location.timestamp.timeIntervalSinceNow <= 5.0
    }
    
    func isHorizontalAccuracyValidMeasurement(location:CLLocation) -> Bool {
        return location.horizontalAccuracy >= 0
    }
    
    func isLocationMeasurementDesiredAccuracy(location:CLLocation) -> Bool {
        return location.horizontalAccuracy <= locationManager.desiredAccuracy
    }
    
    func startUpdatingLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    func findVenues(location:CLLocation) {
        api.delegate = self;
        api.searchForCofeeShopsAtLocation(location)
    }
    
    func didRecieveVenues(results: Venue[]) {
        venues = sort(results, {$0.distanceFromUser < $1.distanceFromUser})
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return self.venues.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell? {
        
        let CellIndentifier = "ListPrototypeCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIndentifier) as UITableViewCell
        let venue = self.venues[indexPath.row] as Venue
        
        cell.textLabel.text = venue.name
        
        return cell
    }
}
