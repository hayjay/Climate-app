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
class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate { //using ChangeCityDelegate here simply means, in this ViewController, one must implement all the functions of the ChangeCityDelegate Protocol
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=37.33233141&lon=-122.0312186&appid=39e0a9f85d8db74afb0536e7911d9a15"
    let APP_ID = "39e0a9f85d8db74afb0536e7911d9a15"
    var latitude : String = ""
    var longitude : String = ""
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
    

    func getWeatherData(url : String) {
        //N.B : this alamofire request happens in the background asynchronously
        Alamofire.request(url, method: .get).responseJSON {//callback
            response in //result gotten back from the server is saved in respnse
            if response.result.isSuccess{ //checks if the result frm server is successfull
                print("Success, got the weather data : \(response.result.value)")
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
        //use of optional binding rather than force unwrapping is advicable
        //using the if let keyword
        
        if let tempResult = json["main"]["temp"].double {
            //changes from the json to a double
            weatherDataModel.temprature = Int(tempResult - 273.15) //force unwrap tempResult
            weatherDataModel.city = json["name"].stringValue //converts the json to a string
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
        } else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    //Write the updateWeatherData method here:
    

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    func updateUIWithWeatherData(){
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temprature)"
        weatherIcon.image = UIImage(named : weatherDataModel.weatherIconName)
    }
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
//                "lat" : latitude,
//                "long" : longitude,
                "appid" : APP_ID
            ]
            self.latitude = latitude
            self.longitude = longitude
            
            getWeatherData(url : WEATHER_URL)
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
    
    func userEnteredANewCityName(city : String)
    {
        print(city)
    }
    
    //Write the PrepareForSegue Method here
    //this function gets executed when we segue or move from the first view controller to the second viewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if the segue name of where the user is comming frm is named changeCityName then do the following
        if segue.identifier == "changeCityName" {
            //this tells xCode that the dataType of this destination is going to be a type ChangeCityViewController
            let destinationVC = segue.destination as! ChangeCityViewController
            //activating the delegate property in the ChangeCityViewController
            destinationVC.delegate = self //WeatherViewController
        }
    }
}


