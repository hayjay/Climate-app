//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
//Write the protocol declaration here: //this protocol is meant for the ChangeCity Delegate
//so we can pass the location in the textbox on ChangeCityViewController to the WeatherViewController
protocol ChangeCityDelegate {
    //in swift, a Protocol is just like an interface which is like settings / requirements a Delegate class would need to satify
    func userEnteredANewCityName (city : String)
}

class ChangeCityViewController: UIViewController {
    //Declare the delegate variable here:
    var delegate : ChangeCityDelegate? //make this delegate property optional so it can be field or not
    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        //
        
        //1 Get the city name the user entered in the text field
        let cityName = changeCityTextField.text!
        
        //2 Check If we have a delegate set using the ?. notation, call the method userEnteredANewCityName
//        using ?. means we are doing a isset on the delegate property if it exist
        delegate?.userEnteredANewCityName(city: cityName)
        
        //3 dismiss the Change City View Controller to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil)//setting completion to nill means do nothing after the screen has been dismissed
    }

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
