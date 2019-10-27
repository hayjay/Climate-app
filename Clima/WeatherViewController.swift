//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation //the module apple has written that allows us to tap into the location API
import Alamofire
import SwiftyJSON

//what this means is that the WeatherViewController is a sub class of the UIViewController
//and the WeatherViewController conforms to the CLLocationManagerDelegate
class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "39e0a9f85d8db74afb0536e7911d9a15"
    //instantiate the Weather model from the model class
    let weatherDataModel = WeatherDataModel()

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager() //this create an instance of the CLLocationManager() class

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //ask user for permission to give the app the current location
        //triggers the authorization popup
        // to display location authorization modal for user, xcode will go to info.plist file inside supporting folder look for the Privacy location keys inorder to display a pop up to the user
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()// asynchronous method so that it wont affect the UI while using it
        
        
        //TODO:Set up the location manager here.
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    

    func getWeatherData(url : String, parameters : [String: String]) {
        //N.B : this alamofire request happens in the background asynchronously
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {//callback
            response in //result gotten back from the server is saved in respnse
            if response.result.isSuccess{ //checks if the result frm server is successfull
                print("Success, got the weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            } else {
                print("An error occurred : \(response.result.error)")
                self.cityLabel.text = "Connection Issues!"
            }
        }
    }
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    func updateWeatherData(json : JSON) {
        let tempResult = json["main"]["temp"].double //changes from the json to a double
        weatherDataModel.temprature = Int(tempResult! - 273.15) //force unwrap tempResult
        weatherDataModel.city = json["name"].stringValue //converts the json to a string
        weatherDataModel.condition = json["condition"]
    }
    //Write the updateWeatherData method here:
    

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    //this should happen when we ve git the locaiton value back
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            //we have to type-cast location to string so it could be used in params dictionary because we've explicitly told params variable the both the key and the value we are sending would be in form of string
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            //this params is innform of a dictionary which we will send to the API payload
            let params : [String : String] = [
                "lat" : latitude,
                "long" : longitude,
                "appid" : APP_ID
            ]
            
            getWeatherData(url : WEATHER_URL, parameters : params)
        }
    }
    
    //Write the didFailWithError method here:
    //tells the delegate (WeatherViewController) that the location manager was unable to retrieve location value..
//    causes could be 1. internet issue, api key ish its
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable!"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
}


