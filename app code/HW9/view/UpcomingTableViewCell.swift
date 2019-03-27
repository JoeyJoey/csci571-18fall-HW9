//
//  UpcomingTableViewCell.swift
//  HW9
//
//  Created by Joey on 11/29/18.
//  Copyright © 2018 Joey. All rights reserved.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {


    @IBOutlet weak var eventName: UIButton!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var type: UILabel!
    
    var eventURL = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func openEvent(_ sender: Any) {
        let url:URL?=URL.init(string: eventURL)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
