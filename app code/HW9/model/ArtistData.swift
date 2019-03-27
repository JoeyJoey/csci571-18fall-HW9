//
//  ArtistData.swift
//  HW9
//
//  Created by Joey on 11/28/18.
//  Copyright © 2018 Joey. All rights reserved.
//

import UIKit
import SwiftyJSON

class ArtistData: NSObject {
    var name = "N/A";
    var followers = 0;
    var popularity = "N/A";
    var checkAt = "N/A";
    
    func unpackDataWithSpotify (dataJson: JSON){
        var tmpStr = dataJson["popularity"].stringValue;
        if( tmpStr != "" && tmpStr != "Undefined"){
            self.popularity = tmpStr;
        }
        self.followers = dataJson["followers"].intValue;
       
        tmpStr = dataJson["checkAt"].stringValue;
        if( tmpStr != "" && tmpStr != "Undefined"){
            self.checkAt = tmpStr;
        }
    }
}

class ArtistDataList: NSObject{
   
    var profileList = [ArtistData]();
    var imgList =  Dictionary< String,Array<String> >();
    var hasSpotify = false;
    var hasCustom = false;
  
    func unpackDataInSpotify (dataJson :JSON){
        for( key, subJSON ) : (String,JSON) in dataJson{
          let singleData = ArtistData();
            singleData.name = key;
            singleData.unpackDataWithSpotify(dataJson: subJSON);
            profileList.append(singleData);
            hasSpotify = true;
        }
    }
    func unpackDataInCustomSearch( dataJSON: JSON ){
        for (key , subJSON): (String,JSON) in dataJSON{
            var tmpArr = [String]();
            for urlJSON in subJSON{
                tmpArr.append(urlJSON.1.stringValue);
            }
            imgList[key]=tmpArr;
        }
        hasCustom = true;
    }
}

