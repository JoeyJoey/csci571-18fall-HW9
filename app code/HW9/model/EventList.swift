//
//  EventList.swift
//  HW9
//
//  Created by Joey on 11/23/18.
//  Copyright © 2018 Joey. All rights reserved.
//

import UIKit
import SwiftyJSON

class EventData:NSObject,NSCoding{
     var eventID : String = "";
     var date: String = "N/A";
     var time = "N/A";
     var name: String = "N/A";
     var category: String = "N/A";
     var venueInfo: String = "N/A";
     var isFavorite: Bool = false;
     var url = "";
    
    func unpackEventData(dataJSON: JSON){
        self.eventID = dataJSON["id"].stringValue;
        
        let tmpDates  = dataJSON["dates"]["start"]["localDate"].stringValue;
        let tmpTime = dataJSON["dates"]["start"]["localTime"].stringValue;
        if( tmpDates != "" && tmpDates != "Undefined"){
            self.date = tmpDates;
        }
        if(tmpTime != "" && tmpTime != "Undefined"){
            self.time = tmpTime;
        }
        
        let tmpName = dataJSON["name"].stringValue;
        if( tmpName != "" && tmpName != "Undefined"){
            self.name = tmpName;
        }
        let tmpCtgry = dataJSON["classifications"][0]["segment"]["name"].stringValue;
        if( tmpCtgry != "" && tmpCtgry != "Undefined" ){
            self.category = tmpCtgry;
        }
        let tmpInfo = dataJSON["_embedded"]["venues"][0]["name"].stringValue;
        if(tmpInfo != "" && tmpInfo != "Undefined"){
            self.venueInfo = tmpInfo;
        }
        
        self.url = dataJSON["url"].stringValue;
    }
    override init()
    {
        super.init();
    }
    
    required init(coder decoder: NSCoder) {
        self.eventID = decoder.decodeObject(forKey: "eventID") as? String ?? ""
        self.name = decoder.decodeObject(forKey: "name") as? String ?? "N/A"
        self.date = decoder.decodeObject(forKey: "date") as? String ?? "N/A"
        self.time = decoder.decodeObject(forKey: "time") as? String ?? "N/A"
        self.category = decoder.decodeObject(forKey: "category") as? String ?? "N/A"
        self.venueInfo = decoder.decodeObject(forKey: "venueInfo") as? String ?? "N/A"
        self.isFavorite = decoder.decodeObject(forKey: "isFavorite") as? Bool ?? false
    }
    func encode(with coder: NSCoder) {
        coder.encode(eventID, forKey:"eventID");
        coder.encode(name, forKey:"name");
        coder.encode(date, forKey:"date");
        coder.encode(time, forKey:"time");
        coder.encode(category, forKey:"category");
        coder.encode(venueInfo, forKey:"venueInfo");
        coder.encode(isFavorite, forKey:"isFavorite");
    }
}

class EventList: NSObject {
    
    var eventArray = [EventData]();
    var isEmpty = false;
    var isError = false;
   
    override init()
    {
        super.init();
    }
    static func unpackEventList(dataJSON:JSON) -> EventList{
       let list = EventList.init();
        if( dataJSON.rawString()! == "[\n  \"empty\"\n]" ){
            list.isEmpty = true;
        }else if(dataJSON.rawString()! == "[\n  \"error\"\n]"){
            list.isError = true;
        }else{
            for tmpEventJSON in dataJSON["events"]{
                let event = EventData.init();
                event.unpackEventData(dataJSON: tmpEventJSON.1);
                list.eventArray.append(event);
            }
        }
        return list;
    }
}
