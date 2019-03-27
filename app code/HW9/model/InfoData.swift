//
//  InfoData.swift
//  HW9
//
//  Created by Joey on 11/25/18.
//  Copyright © 2018 Joey. All rights reserved.
//

import UIKit
import SwiftyJSON

class InfoData: NSObject {
    var artists = "N/A";
    var artistArr = [String]();
    var venue = "N/A";
    var date = "N/A";
    var time = "N/A";
    var categoryStr = "N/A";
    var segment = "N/A";
    var priceRange = "N/A";
    var ticketStatus = "N/A";
    var buyAt = "N/A";
    var seatMap = "N/A";

    func unpackEventData(dataJSON: JSON){
        
        var tmpStr = "";
        for tmpData in dataJSON["_embedded"]["attractions"]
        {
            if( tmpData.1["name"].stringValue != "" && tmpData.1["name"].stringValue != "Undefined"){
                tmpStr += tmpData.1["name"].stringValue;
                tmpStr += " | ";
                self.artistArr.append(tmpData.1["name"].stringValue);
            }
        }
        if(tmpStr != ""){
            tmpStr.removeLast(3);
            self.artists = tmpStr;
        }
        
        let tmpVenue = dataJSON["_embedded"]["venues"][0]["name"].stringValue;
        if( tmpVenue != "" &&  tmpVenue != "Undefined"){
            self.venue = tmpVenue;
        }
        
        let tmpDates  = dataJSON["dates"]["start"]["localDate"].stringValue;
        let tmpTime = dataJSON["dates"]["start"]["localTime"].stringValue;
        if( tmpDates != "" && tmpDates != "Undefined"){
            self.date = tmpDates;
        }
        if(tmpTime != "" && tmpTime != "Undefined"){
            self.time = tmpTime;
        }
        
        tmpStr = "";
        let tmpSegment = dataJSON["classifications"][0]["segment"]["name"].stringValue;
        let tmpGenre = dataJSON["classifications"][0]["genre"]["name"].stringValue;
        if( tmpSegment != "" && tmpSegment != "Undefined" ){
            tmpStr += tmpSegment;
            self.segment = tmpSegment;
        }
        if( tmpGenre != "" && tmpGenre != "Undefined" ){
            if(tmpStr != ""){
                tmpStr += " | \(tmpGenre)";
            }else{
                tmpStr += tmpGenre;
            }
        }
        if(tmpStr != ""){
            self.categoryStr = tmpStr;
        }
        
        
        
        var tmpRange = "";
        let min = dataJSON["priceRanges"][0]["min"].stringValue;
        let max = dataJSON["priceRanges"][0]["max"].stringValue;
        if(min != "" && min != "Undefined"){
            tmpRange += min;
        }
        if( max != "" && max != "Undefined" ){
            if( tmpRange != "" ){
                tmpRange += " ~ \(max)";
            }else{
                tmpRange += max;
            }
        }
        if(tmpRange != ""){
            tmpRange += " (\(dataJSON["priceRanges"][0]["currency"].stringValue))";
            self.priceRange = tmpRange;
        }
        
        let tmpStatus = dataJSON["dates"]["status"]["code"].stringValue;
        if( tmpStatus != "" && tmpStatus != "Undefined"){
            self.ticketStatus = tmpStatus;
        }
        
        if( dataJSON["url"].stringValue != "" && dataJSON["url"].stringValue != "Undefined" ){
            self.buyAt = dataJSON["url"].stringValue;
        }
        if( dataJSON["seatmap"]["staticUrl"].stringValue != "" && dataJSON["seatmap"]["staticUrl"].stringValue != "Undefined" ){
            self.seatMap = dataJSON["seatmap"]["staticUrl"].stringValue;
        }
    }
    
}
