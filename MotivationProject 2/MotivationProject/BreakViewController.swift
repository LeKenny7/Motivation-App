//
//  BreakViewController.swift
//  MotivationProject
//
//  Created by kvle2 on 11/24/19.
//  Copyright © 2019 kvle2. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class BreakViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var manager:CLLocationManager!
    var bm = BreakModel()
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var mapType: UISegmentedControl!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var suggestionLabel: UILabel!
    
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var searchBox: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        DispatchQueue.main.async{
            self.getJsonData()
        }
        
    }
    
    class func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                print("Something wrong with Location services")
                return false
            }
        } else {
            print("Location services are not enabled")
            return false
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        
        self.latitudeLabel.text = "\(userLocation.coordinate.latitude)"
        
        self.longitudeLabel.text = "\(userLocation.coordinate.longitude)"
        
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        map.setRegion(region, animated: true)
        
        self.map.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    @IBAction func searchLocal(_ sender: Any) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBox.text
        request.region = map.region
        let search = MKLocalSearch(request: request)
        
        search.start {response, _ in
            guard let response = response else {
                return
            }
            //print( response.mapItems )
            var matchingItems:[MKMapItem] = []
            matchingItems = response.mapItems
            for i in 1...matchingItems.count - 1
            {
                let place = matchingItems[i].placemark
                self.map.addAnnotation(Place(title: place.name!, coordinate: CLLocationCoordinate2D(latitude: (place.location?.coordinate.latitude)!, longitude: (place.location?.coordinate.longitude)!)))
            }
        }
    }
    
    @IBAction func showMap(_ sender: Any) {
        switch(self.mapType.selectedSegmentIndex)
        {
        case 0:
            self.map.mapType = MKMapType.standard
            
        case 1:
            self.map.mapType = MKMapType.satellite
            
        default:
            self.map.mapType = MKMapType.standard
        }
    }
    
    func getJsonData(){
        let data = bm.getJData(lati: manager.location!.coordinate.latitude, longi: manager.location!.coordinate.longitude)
    }
    
    @IBAction func informationButton(_ sender: UIButton) {
        let weather = bm.trueWeather
        let temperature = bm.trueTemperature
        self.weatherLabel.text = weather
        if(weather == "n/a")
        {
            self.weatherLabel.text = "Clear!"
        }
        self.temperatureLabel.text = String(temperature)
        if weather != "n/a"
        {
            self.suggestionLabel.text = "Be careful of the weather! Stay inside and play boardgames"
        }
        else
        {
            switch temperature{
            case _ where temperature < 15:
                self.suggestionLabel.text = "It is cold, go get some coffee"
            case 15...20:
                self.suggestionLabel.text = "It is cool out, a movie theatre would be nice"
            case 20...30:
                self.suggestionLabel.text = "It is warm, put on something light and get pizza"
            case _ where temperature > 30:
                self.suggestionLabel.text = "It is hot, get some icecream"
            default:
                self.suggestionLabel.text = "Go get some icecream"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
