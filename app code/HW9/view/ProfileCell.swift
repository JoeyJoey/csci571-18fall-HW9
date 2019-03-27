//
//  ProfileCell.swift
//  HW9
//
//  Created by Joey on 11/28/18.
//  Copyright © 2018 Joey. All rights reserved.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    @IBOutlet weak var follwerLB: UILabel!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    var checkUrl = "";
    @IBAction func checkBtnFunc(_ sender: Any) {
        let urlString = self.checkUrl;
        let url = URL(string : urlString);
        UIApplication.shared.open( url!, options: [:], completionHandler: nil);
    }
    
    func setWithData(data:ArtistData){
        self.nameLB.text = data.name;
        let numberFormatter = NumberFormatter();
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: data.followers));
        self.popularity.text = data.popularity;
        self.follwerLB.text = formattedNumber;
        self.checkUrl = data.checkAt;
        if(data.checkAt == "N/A"){
            self.checkBtn.isEnabled = false;
        }
    }
}
