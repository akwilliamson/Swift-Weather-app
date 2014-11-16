//
//  ViewController.swift
//  Weather
//
//  Created by Aaron Williamson on 11/14/14.
//  Copyright (c) 2014 Aaron Williamson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cityText: UITextField!
    
    @IBOutlet weak var weatherDescription: UILabel!
    
    @IBAction func showButton(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        var noSpacesCityText = cityText.text.stringByReplacingOccurrencesOfString(" ", withString: "-")
        var safeCityText = noSpacesCityText.stringByReplacingOccurrencesOfString(".", withString: "")
        
        var UrlString = "http://www.weather-forecast.com/locations/" + safeCityText + "/forecasts/latest"
        let url = NSURL(string: UrlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                

            var resultData = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            if (resultData!.containsString("<span class=\"phrase\">")) {
                
                var resultArray = resultData?.componentsSeparatedByString("<span class=\"phrase\">")
                
                var firstResultArray = resultArray![1].componentsSeparatedByString("</span>")
                
                var finalOutput = firstResultArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "°")
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.weatherDescription.text = finalOutput
                }
                
            } else {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.weatherDescription.text = "No weather data for this city."
                }
                
            }
        }
        
        task.resume()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        cityText.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
