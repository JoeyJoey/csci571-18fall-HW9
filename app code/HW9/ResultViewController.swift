//
//  ResultViewController.swift
//  HW9
//
//  Created by Joey on 11/24/18.
//  Copyright © 2018 Joey. All rights reserved.
//

import UIKit
import EasyToast
import Alamofire
import SwiftSpinner
import SwiftyJSON

class ResultViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ResultTableViewCellDelegate {

    @IBOutlet weak var resultTable: UITableView!
    var eventlist = EventList();
    var selectedRow : Int = 0 ;
    var infoData = InfoData ();
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if( self.eventlist.isEmpty == true ){
            self.resultTable.isHidden = true;
            let x = ScreenWidth/2-50;
            let y = ScreenHeight/2-10;
            let label = UILabel.init(frame: CGRect.init( x:x,y:y,width:100,height:20));
           label.text = "No Results";
           self.view.addSubview(label);
        }else if(self.eventlist.isError == true ){
            self.view.showToast("An Error Occured, Please Try Again", position: ToastPosition.bottom, popTime: 3, dismissOnTap: true);
        }else{
            self.resultTable.dataSource = self;
            self.resultTable.delegate = self;
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Search Results";
        self.resultTable.reloadData();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(self.selectedRow);
        if let detailTabController = segue.destination as?
            DetailTabBarController {
            detailTabController.eventData = self.eventlist.eventArray[self.selectedRow];
            
        }
    }
    //resultCell delegate
    func ResultTableViewCellDTapHeart(_sender: ResultTableViewCell) {
        guard let tappedIndex = resultTable.indexPath(for: _sender)
            else{ return };
        
        let data = self.eventlist.eventArray[tappedIndex.row];
        let key = self.eventlist.eventArray[tappedIndex.row].eventID;
        
        if( _sender.isRed == true){
            data.isFavorite = true;
            UserDefaultsSaveObject(key: key, eventData: data);
            self.view.showToast("\(self.eventlist.eventArray[tappedIndex.row].name) was added to favorites", position: ToastPosition.bottom, popTime: 2, dismissOnTap: true);
        }else{
            data.isFavorite = false;
            UserDefaultsRemoveObject(key: key);
            self.view.showToast("\(self.eventlist.eventArray[tappedIndex.row].name) was removed from favorites", position: ToastPosition.bottom, popTime: 2, dismissOnTap: true);
        }
    }
    
    //func for  UserDefaults
    func updateEventDataWithUserDefaults(paramData:EventData){
        if(UserDefaults.standard.array(forKey: "eventIDArr") != nil){
            let eventIDArr = UserDefaults.standard.array(forKey: "eventIDArr") as![String];
            for idStr in eventIDArr{
                if(idStr == paramData.eventID){
                    paramData.isFavorite = true;
                }
            }
        }
    }
    
    //tableview dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventlist.eventArray.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! ResultTableViewCell;
        self.updateEventDataWithUserDefaults( paramData: self.eventlist.eventArray[indexPath.row]);
        cell.renderWithData(cellData: self.eventlist.eventArray[indexPath.row]);
        cell.delegate = self;
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    //tableView delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row;
        self.performSegue(withIdentifier: "showTab", sender: Any?.self);
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
