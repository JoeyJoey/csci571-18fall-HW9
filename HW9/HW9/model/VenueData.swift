//
//  VenueData.swift
//  HW9
//
//  Created by Joey on 11/26/18.
//  Copyright © 2018 Joey. All rights reserved.
//

import UIKit
import SwiftyJSON

class VenueData: NSObject {
    var isRequested = false;
    var address = "N/A";
    var city = "N/A";
    var phoneNumber = "N/A";
    var openHours = "N/A";
    var generalRule = "N/A";
    var childRule = "N/A";
    var latitude = "N/A";
    var longitude = "N/A";
    
    func unpackVenueData(dataJSON: JSON){
        
        let tmpAddr = dataJSON["address"]["line1"].stringValue;
        if( tmpAddr != "" && tmpAddr != "Undefined"){
            self.address = tmpAddr;
        }
        
        let tmpCity = dataJSON["city"]["name"].stringValue;
        let tmpState = dataJSON["state"]["name"].stringValue;
        var tmpStr = "";
        if(tmpCity != "" && tmpCity != "Undefined"){
            tmpStr += tmpCity;
        }
        if(tmpState != "" && tmpCity != "Undefined"){
            if(tmpStr != ""){
                tmpStr += " , \(tmpState)";
            }else{
                tmpStr += tmpState;
            }
        }
        if(tmpStr != ""){
            self.city = tmpStr;
        }
        
        let tmpPhone = dataJSON["boxOfficeInfo"]["phoneNumberDetail"].stringValue;
        if( tmpPhone != "" && tmpPhone != "undefined" ){
            self.phoneNumber = tmpPhone;
        }
        
        let tmpOpen = dataJSON["boxOfficeInfo"]["openHoursDetail"].stringValue;
        if( tmpOpen != "" && tmpOpen != "undefined" ){
            self.openHours = tmpOpen;
        }
        
        let tmpGene = dataJSON["generalInfo"]["generalRule"].stringValue;
        if(tmpGene != "" && tmpGene != "Undefined"){
            self.generalRule = tmpGene;
        }
        
        let tmpChild = dataJSON["generalInfo"]["childRule"].stringValue;
        if( tmpChild != "" && tmpChild != "Undefined"){
            self.childRule = tmpChild;
        }
        
        if( dataJSON["location"]["latitude"].stringValue != "" && dataJSON["location"]["latitude"].stringValue != "Undefined"){
            self.latitude = dataJSON["location"]["latitude"].stringValue;
        }
        if( dataJSON["location"]["longitude"].stringValue != "" && dataJSON["location"]["longitude"].stringValue != "Undefined"){
            self.longitude = dataJSON["location"]["longitude"].stringValue;
        }
        
        self.isRequested = true;
    }

}
