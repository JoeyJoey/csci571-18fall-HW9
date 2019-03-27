//
//  prefix_header.swift
//  HW9
//
//  Created by Joey on 11/21/18.
//  Copyright © 2018 Joey. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

let backURL = "http://ljynodeforios.us-west-1.elasticbeanstalk.com";

let  ScreenWidth = UIScreen.main.bounds.size.width;
let  ScreenHeight = UIScreen.main.bounds.size.height;

func UserDefaultsRemoveObject(key:String){
    UserDefaults.standard.removeObject(forKey: key);
    var eventIDArr = UserDefaults.standard.array(forKey: "eventIDArr") as! [String];
    eventIDArr = eventIDArr.filter{ $0 != key }
    UserDefaults.standard.set(eventIDArr, forKey:"eventIDArr");
}

func UserDefaultsSaveObject(key:String,eventData:EventData){
    if( UserDefaults.standard.array(forKey: "eventIDArr") == nil){
        var eventIDArr = [String]();
        eventIDArr.append(key);
        UserDefaults.standard.set(eventIDArr, forKey:"eventIDArr");
    }else{
        var eventIDArr = UserDefaults.standard.array(forKey: "eventIDArr")!;
        eventIDArr.append(key);
        UserDefaults.standard.set(eventIDArr, forKey:"eventIDArr");
    }
    let modelData = try!NSKeyedArchiver.archivedData(withRootObject: eventData, requiringSecureCoding: false);
    UserDefaults.standard.set( modelData, forKey: key);
    
}


