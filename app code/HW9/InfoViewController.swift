//
//  InfoViewController.swift
//  HW9
//
//  Created by Joey on 11/25/18.
//  Copyright © 2018 Joey. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var artLabel: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ctgryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var seatBtn: UIButton!
    
    var data = InfoData();
    
    func refresh(paramData: InfoData){
        self.data = paramData;
        
        var date = Date();
        let format = DateFormatter();
        format.dateFormat = "yyyy-MM-dd";
        date = format.date(from: self.data.date)!;
        format.dateFormat = "MMM dd, yyyy";
        let dateStr = format.string(from: date);
        
        self.artLabel.text = self.data.artists;
        self.venueLabel.text = self.data.venue;
        self.timeLabel.text = dateStr+" "+self.data.time;
        self.ctgryLabel.text = self.data.categoryStr;
        self.priceLabel.text = self.data.priceRange;
        self.statusLabel.text = self.data.ticketStatus;
        
        if(self.data.buyAt == "N/A"){
            self.buyBtn.titleLabel?.text = "N/A";
            self.buyBtn.isEnabled = false;
        }
        if(self.data.seatMap == "N/A"){
            self.seatBtn.titleLabel!.text = "N/A";
            self.seatBtn.isEnabled = false;
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override  func  viewWillAppear(_ animated: Bool) {
       
    }
    
    @IBAction func buyTicket(_ sender: Any) {
        let urlString = self.data.buyAt;
        let url = URL(string : urlString);
        UIApplication.shared.open( url!, options: [:], completionHandler: nil);
    }
    
    @IBAction func viewSeatMap(_ sender: Any) {
        let urlString = self.data.seatMap;
        let url = URL(string: urlString);
        UIApplication.shared.open( url!, options: [:], completionHandler: nil);
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
