//
//  imgCell.swift
//  HW9
//
//  Created by Joey on 11/28/18.
//  Copyright © 2018 Joey. All rights reserved.
//

import UIKit
import Kingfisher

class imgCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
    func setWithData (urlStr:String){
        let url = URL(string: urlStr);
        imgView.kf.setImage(with: url);
    }
    
}
