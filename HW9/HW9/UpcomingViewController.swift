//
//  UpcomingViewController.swift
//  HW9
//
//  Created by Joey on 11/28/18.
//  Copyright © 2018 Joey. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import SnapKit

class UpcomingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var SortBy: UISegmentedControl!
    
    @IBOutlet weak var Order: UISegmentedControl!
    @IBOutlet weak var UpcomingTable: UITableView!
    
    @IBOutlet weak var noResultLB: UILabel!
    
    var NetworkClass = NetworkService()
    var rawData = [UpcomingData]()
    var showData = [UpcomingData]()
    var jsonData = JSON()
    var venueName=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UpcomingTable.delegate = self
        UpcomingTable.dataSource = self
        SwiftSpinner.show("Loading Upcoming Events...")
        NetworkClass.GetUpcoming(para: ["venueName":venueName], finishedCallBack: {result in
            self.jsonData = JSON(result)
            if(self.jsonData) == JSON([])
            {
                self.noResultLB.isHidden = false;
                self.noResultLB.backgroundColor = UIColor.white;
                self.noResultLB.snp.makeConstraints({ (make) in
                    make.height.equalToSuperview();
                    make.width.equalToSuperview();
                })
            }
            for (_,subJson):(String, JSON) in self.jsonData {
                let temp = UpcomingData()
                temp.Name = subJson["displayName"].stringValue
                temp.Artist = subJson["performance"][0]["displayName"].stringValue
                let formatter = DateFormatter();
                formatter.dateFormat = "yyyy-MM-dd";
                temp.Date = formatter.date(from: subJson["start"]["date"].stringValue)
                temp.Time = subJson["start"]["time"].stringValue
                temp.EventType = subJson["type"].string ?? "N/A"
                temp.URL = subJson["uri"].stringValue
                self.rawData.append(temp)
            }
            self.showData = self.rawData
            self.UpcomingTable.reloadData()
            SwiftSpinner.hide()
        })
    }
    
    @IBAction func SortByChanged(_ sender: Any) {
        switch SortBy.selectedSegmentIndex
        {
        case 0:
            Order.isEnabled = false
            showData = rawData
        case 1:
            Order.isEnabled = true
            showData.sort(by:{(Cell1:UpcomingData,Cell2:UpcomingData)->Bool in
                if(Order.selectedSegmentIndex == 0){
                    return Cell1.Name<Cell2.Name
                }else
                {
                    return Cell1.Name>Cell2.Name
                }})
        case 2:
            Order.isEnabled = true
            showData.sort(by:{(Cell1:UpcomingData,Cell2:UpcomingData)->Bool in
                if(Order.selectedSegmentIndex == 0){
                    if(Cell1.Date==Cell2.Date){
                        return Cell1.Time<Cell2.Time
                    }
                    return Cell1.Date<Cell2.Date
                }else
                {
                    if(Cell1.Date==Cell2.Date){
                        return Cell1.Time>Cell2.Time
                    }
                    return Cell1.Date>Cell2.Date
                }})
        case 3:
            Order.isEnabled = true
            showData.sort(by:{(Cell1:UpcomingData,Cell2:UpcomingData)->Bool in
                if(Order.selectedSegmentIndex == 0){
                    
                    return Cell1.Artist<Cell2.Artist
                }else
                {
                    return Cell1.Artist>Cell2.Artist
                }})
        case 4:
            Order.isEnabled = true
            showData.sort(by:{(Cell1:UpcomingData,Cell2:UpcomingData)->Bool in
                if(Order.selectedSegmentIndex == 0){
                    
                    return Cell1.EventType<Cell2.EventType
                }else
                {
                    return Cell1.EventType>Cell2.EventType
                }})
        default:
            break
        }
        UpcomingTable.reloadData()
    }
    
    //table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return showData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VenueCell", for: indexPath) as! UpcomingTableViewCell
        cell.eventName.setTitle(showData[indexPath.row].Name, for: .normal)
        cell.artist.text = showData[indexPath.row].Artist
        let formatter = DateFormatter();
        formatter.dateFormat = "MMM dd, yyyy"
        cell.time.text = formatter.string(from: showData[indexPath.row].Date) + " " + showData[indexPath.row].Time
        if(cell.time.text == ""){
            cell.time.text = "N/A"
        }
        cell.type.text = "Type: " + showData[indexPath.row].EventType
        cell.eventURL = showData[indexPath.row].URL
        return cell
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
