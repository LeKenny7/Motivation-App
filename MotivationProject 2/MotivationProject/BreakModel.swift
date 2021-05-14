//
//  BreakModel.swift
//  MotivationProject
//
//  Created by kvle2 on 11/25/19.
//  Copyright © 2019 kvle2. All rights reserved.
//

import Foundation
public class BreakModel{
    public var trueWeather:String = ""
    public var trueTemperature:Float = 0
    
    func getJData(lati: Double, longi: Double){
        
        let urlAsString = "http://api.geonames.org/weatherJSON?north=\(lati+3)&south=\(lati-3)&east=\(longi+3)&west=\(longi-3)&username=lekenny7"
        let url = URL(string: urlAsString)!
        let urlSession = URLSession.shared
        let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            var err: NSError?
            
            var jsonResult = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
            if (err != nil) {
                print("JSON Error \(err!.localizedDescription)")
            }
            let setOne:NSArray = jsonResult["weatherObservations"] as! NSArray
            let y = setOne[0] as! [String: AnyObject]
            //DispatchQueue.main.sync{
            let temp = y["temperature"] as! String
            let temperature:Float = Float(temp)!
            let weatherCondition = y["weatherCondition"]
            let weather = String(weatherCondition as! NSString)
            self.trueWeather = weather
            self.trueTemperature = temperature
            //}
        })
        jsonQuery.resume()
    }
}
