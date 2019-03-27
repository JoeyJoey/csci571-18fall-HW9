//
//  VenueViewController.swift
//  HW9
//
//  Created by Joey on 11/26/18.
//  Copyright © 2018 Joey. All rights reserved.
//

import UIKit
import SnapKit
import GoogleMaps

class VenueViewController: UIViewController {
    
    @IBOutlet weak var ScrollContainer: UIScrollView!
    @IBOutlet weak var addrLB: UILabel!
    @IBOutlet weak var phoneLB: UILabel!
    @IBOutlet weak var cityLB: UILabel!
    @IBOutlet weak var openLB: UILabel!
    @IBOutlet weak var openText: UITextView!
    @IBOutlet weak var generalLB: UILabel!
    @IBOutlet weak var generalText: UITextView!
    @IBOutlet weak var childLB: UILabel!
    @IBOutlet weak var childText: UITextView!
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var noResultLB: UILabel!
    var data = VenueData();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func refresh(){
        if(self.data.isRequested == false){
            self.noResultLB.isHidden = false;
            self.noResultLB.snp.makeConstraints { (make) in
                make.height.equalToSuperview();
                make.width.equalToSuperview();
            }
        }
        self.addrLB.text = self.data.address;
        self.cityLB.text = self.data.city;
        self.phoneLB.text = self.data.phoneNumber;
        
        self.openText.text = self.data.openHours;
        self.generalText.text = self.data.generalRule;
        self.childText.text = self.data.childRule;
        self.makeConstraints();
        self.setMap();
    }
    
    func setMap(){
        let lat = Double(self.data.latitude)!;
        let lon = Double(self.data.longitude)!;
        let camera = GMSCameraPosition.camera( withLatitude: lat, longitude: lon, zoom: 15.0);
        let gmapView = GMSMapView.map( withFrame: CGRect.init(x: 0, y: 0, width: 372, height: 240), camera: camera);
        
        let marker = GMSMarker();
        marker.position = CLLocationCoordinate2DMake(lat, lon);
        marker.map = gmapView;
        self.mapView.addSubview(gmapView);
    }
    
    func makeConstraints(){
        
        self.openText.snp.makeConstraints { (make) in
            make.top.equalTo(self.openLB.snp.bottom).offset(5);
            make.width.equalTo(372);
            make.left.equalTo(self.ScrollContainer).offset(20);
        }
        
        self.generalLB.snp.makeConstraints { (make) in
            make.left.equalTo(self.ScrollContainer).offset(20)
            make.top.equalTo(self.openText.snp.bottom).offset(15);
        }
        
        self.generalText.snp.makeConstraints { (make) in
            make.top.equalTo(self.generalLB.snp.bottom).offset(5);
            make.width.equalTo(372);
            make.left.equalTo(self.ScrollContainer).offset(20);
        }
        
        self.childLB.snp.makeConstraints { (make) in
            make.top.equalTo(self.generalText.snp.bottom).offset(15);
            make.left.equalTo(self.ScrollContainer).offset(20);
        }
        
        self.childText.snp.makeConstraints { (make) in
            make.top.equalTo(self.childLB.snp.bottom).offset(5);
            make.left.equalTo(self.ScrollContainer).offset(20);
            make.width.equalTo(372);
        }
        
        self.mapView.snp.makeConstraints { (make) in
            make.top.equalTo(self.childText.snp.bottom).offset(15);
            make.left.equalTo(self.ScrollContainer).offset(20);
            make.width.equalTo(372);
            make.height.equalTo(240);
            make.bottom.equalToSuperview().offset(-30);
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
