//
//  SchoolListTableViewController.swift
//  FoursquareVenues
//
//  Created by XD on 6/13/14.
//  Copyright (c) 2014 XD. All rights reserved.
//

import UIKit
import corelocation

class SchoolListTableViewController: UITableViewController, FoursquareAPIProtocol, CLLocationManagerDelegate {
    
    let api: FoursquareAPI = FoursquareAPI()
    var schools:School[] = []
    var locationManager:CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        
        startUpdatingLocation()
    }
    
    func locationManager(manager:CLLocationManager!, didUpdateLocations locations:AnyObject[]!) {
        let location:CLLocation = getLatestMeasurementFromLocations(locations)
        
        if isLocationMeasurementNotCached(location) && isHorizontalAccuracyValidMeasurement(location) && isLocationMeasurementDesiredAccuracy(location) {
            
            stopUpdatingLocation()
            findSchools(location)
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
    
    func findSchools(location:CLLocation) {
        api.delegate = self;
        api.searchForSchoolsAtLocation(location)
    }
    
    func didRecieveSchools(results: School[]) {
        schools = sort(results, {$0.distanceFromUser < $1.distanceFromUser})
        
        println("table reload")
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return self.schools.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell? {
        
        let CellIndentifier: NSString = "ListPrototypeCell"
        
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(CellIndentifier) as UITableViewCell
        
        var school: School = self.schools[indexPath.row] as School
        
        cell.textLabel.text = school.name
        
        return cell
    }
}
