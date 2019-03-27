//
//  DetailTabBarController.swift
//  HW9
//
//  Created by Joey on 11/25/18.
//  Copyright © 2018 Joey. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import EasyToast

class DetailTabBarController: UITabBarController,UITabBarControllerDelegate {
    
    var eventData = EventData();
    var infoData = InfoData();
    var venueData = VenueData();
    var artistDataList = ArtistDataList();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view.
        self.delegate = self;
        self.requestForEventInfo();
        let upcomingTab = self.viewControllers?[3] as! UpcomingViewController
        upcomingTab.venueName = self.eventData.venueInfo;
    }
    
    override  func  viewWillAppear(_ animated: Bool) {
       
        var favoImgName = "favorite-empty";
        if(self.eventData.isFavorite == true){
            favoImgName = "favorite-filled";
        }
        let  twitterBtn = UIBarButtonItem.init(image: UIImage.init(named: "twitter"), style: UIBarButtonItem.Style.plain, target: self , action: #selector(postTwitter));
        let favoBtn = UIBarButtonItem.init(image: UIImage.init(named: favoImgName ), style: UIBarButtonItem.Style.plain, target: self , action: #selector(setFavorite));
        self.navigationItem.rightBarButtonItems = [favoBtn,twitterBtn];
    }
    
    func requestForEventInfo(){
        SwiftSpinner.show("Searching for eventInfo...");
        let paramDic = ["eventID":self.eventData.eventID];
        Alamofire.request("\(backURL)/detailSearch", parameters: paramDic ).responseJSON { response in
            if(response.result.isSuccess){
                let jsonData = try!JSON(data: response.data!);
                self.infoData.unpackEventData(dataJSON: jsonData);
                let infoVC = self.viewControllers?[0] as! InfoViewController;
                infoVC.refresh( paramData: self.infoData);
                SwiftSpinner.hide();
            }else{
                print(response.result.error!);
            }
        };
    }
    
    func requestForVenueInfo(){
        SwiftSpinner.show("Searching for VenueInfo...");
        if(self.infoData.venue != "N/A"){
            let paramDic = ["venueName": self.infoData.venue];
            Alamofire.request("\(backURL)/venueSearch", parameters: paramDic ).responseJSON { response in
                if(response.result.isSuccess){
                    let jsonData = try!JSON(data: response.data!);
                    self.venueData.unpackVenueData(dataJSON: jsonData["_embedded"]["venues"][0]);
                    let venueVC = self.selectedViewController as! VenueViewController
                    venueVC.data = self.venueData;
                     SwiftSpinner.hide();
                    venueVC.refresh();
                }else{
                    print(response.result.error!);
                }
            };
        }
    }
    func requestForArtitsInfo(){
        SwiftSpinner.show("Fectching Aritst(s) Info...");
        var paramDic = Dictionary<String,Any>();
        if(self.infoData.artistArr.count == 1){
            paramDic["artists"] = self.infoData.artistArr[0];
        }
        if(self.infoData.artistArr.count >= 2){
            var nameArr = [String]();
            for name in self.infoData.artistArr[...1]{
                nameArr.append(name);
            }
            paramDic["artists"] = nameArr;
        }
        let ArrEncoding = URLEncoding(arrayEncoding: .noBrackets);
        if( paramDic.count != 0 ){
            if(self.infoData.segment == "Music"){
                Alamofire.request("\(backURL)/reqSpotify", parameters: paramDic, encoding: ArrEncoding ).responseJSON{ response in
                    if(response.result.isSuccess){
                      //  print(response.request);
                        let jsonData = try!JSON(data: response.data!);
                        self.artistDataList.unpackDataInSpotify(dataJson: jsonData);
                        print("Spotify",self.artistDataList.hasSpotify);
                        self.reqGoogleCustom(paramDic: paramDic, ArrEncoding: ArrEncoding);
                    }else{
                        print(response.result.error!);
                    }
                };
            }else{
                self.reqGoogleCustom(paramDic: paramDic, ArrEncoding: ArrEncoding);
            }
        }
    }
    func reqGoogleCustom( paramDic:Dictionary< String, Any >, ArrEncoding: URLEncoding){
        Alamofire.request("\(backURL)/googleCustom", parameters: paramDic, encoding: ArrEncoding ).responseJSON { response in
            if(response.result.isSuccess){
                let jsonData = try!JSON(data: response.data!);
                self.artistDataList.unpackDataInCustomSearch( dataJSON: jsonData);
                print ("Custom",self.artistDataList.hasCustom);
                SwiftSpinner.hide();
                let artistVC = self.selectedViewController as! ArtistViewController;
                artistVC.data = self.artistDataList;
                artistVC.changeDataToSectionType();
            }else{
                print(response.result.error!);
            }
        };
    }
    
    @objc func postTwitter(){
        var str = "https://twitter.com/intent/tweet?text=Check out "+(eventData.name)
        if(eventData.venueInfo != "N/A"){
            str += " locate at " + eventData.venueInfo
        }
        str += ". Website: " + eventData.url +  " #CSCI571 EventSearch"
        str = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url:URL?=URL.init(string: str)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
    }
    @objc func setFavorite(){
        self.eventData.isFavorite = !self.eventData.isFavorite;
        if(self.eventData.isFavorite == true){
             let favoBtn = UIBarButtonItem.init(image: UIImage.init(named: "favorite-filled" ), style: UIBarButtonItem.Style.plain, target: self , action: #selector(setFavorite));
            self.navigationItem.rightBarButtonItems?[0] = favoBtn;
            UserDefaultsSaveObject(key: self.eventData.eventID, eventData: self.eventData);
            self.view.showToast("\(self.eventData.name) was added to favorites", position: ToastPosition.bottom, popTime: 2, dismissOnTap: true);

        }else{
            let favoBtn = UIBarButtonItem.init(image: UIImage.init(named: "favorite-empty" ), style: UIBarButtonItem.Style.plain, target: self , action: #selector(setFavorite));
            self.navigationItem.rightBarButtonItems?[0] = favoBtn;
            UserDefaultsRemoveObject(key: self.eventData.eventID);
            self.view.showToast("\(self.eventData.name) was removed from favorites", position: ToastPosition.bottom, popTime: 2, dismissOnTap: true);
        }
    }
    //userdefaults method
    
    
    // tabBarController delegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if(viewController.title == "Venue" && self.venueData.isRequested == false ){
            self.requestForVenueInfo();
        }
        if(viewController.title == "Artist(s)" && self.artistDataList.hasCustom == false){
            self.requestForArtitsInfo();
        }
       
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
