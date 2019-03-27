//
//  ViewController.swift
//  HW9
//
//  Created by Joey on 11/18/18.
//  Copyright © 2018 Joey. All rights reserved.
//

import UIKit
import McPicker
import Alamofire
import SwiftyJSON
import EasyToast
import CoreLocation
import SwiftSpinner

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,CLLocationManagerDelegate{

    @IBOutlet weak var keywordText: UITextField!
    @IBOutlet weak var dropDownlist: UITableView!
    @IBOutlet weak var categoryText: McTextField!
    @IBOutlet weak var distanceText: UITextField!
    @IBOutlet weak var unitPicker: UIPickerView!
    @IBOutlet weak var radioCurrent: UIButton!
    @IBOutlet weak var radioCustom: UIButton!
    @IBOutlet weak var customText: UITextField!
    
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var favoVC: UIView!
    
    private  var autoArray = [String]();
    private let categoryArr : [String] = ["All","Music","Sports","Arts & Theatre","Film","Miscellaneous"];
    private let unitArr : [String] = ["Miles","Kilometers"];
    private var unitRow:Int = 0;
    private var locManager = CLLocationManager();
    private var currentloc = CLLocationCoordinate2D();
    var eventlist = EventList();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.getLocation();
        self.dropDownlist.delegate = self;
        self.dropDownlist.dataSource = self;
        self.dropDownlist.register(UITableViewCell.self, forCellReuseIdentifier: "cell");
        self.dropDownlist.layer.borderWidth = 1;
        self.dropDownlist.layer.borderColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0).cgColor;
        
        let mcInputView = McPicker.init(data: [self.categoryArr]);
        self.categoryText.inputViewMcPicker = mcInputView;
        self.categoryText.doneHandler = { [weak self] (selections) in
            self?.categoryText?.text = selections[0]!
        }
       self.categoryText.cancelHandler = { [weak self] in
            self?.categoryText.resignFirstResponder();
        }
        
        self.unitPicker.dataSource = self;
        self.unitPicker.delegate = self;
        
        self.radioCurrent.isSelected = true;
        self.customText.isEnabled = false;

    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch self.segmentControl.selectedSegmentIndex
        {
        case 0:
            self.favoVC.isHidden = true;
        case 1:
            self.favoVC.isHidden = false;
        default:
            break
        }
    }
    
    
    override func  viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Place Search";
        self.dropDownlist.isHidden = true;
    }
    
    func getLocation()
    {
        let authStatus  = CLLocationManager.authorizationStatus();
        if authStatus == .notDetermined {
            self.locManager.requestWhenInUseAuthorization();
        }
        if (authStatus == .denied || authStatus == .restricted) {
            self.view.showToast("Location Services Disabled,Please enable Location Services in Settings", position: ToastPosition.bottom, popTime: 3, dismissOnTap: true);
        }
        self.locManager.delegate = self
        self.locManager.startUpdatingLocation();
    }
    
    @IBAction func keywordChanged(_ sender: Any) {
        self.dropDownlist.isHidden = true;
        if(self.keywordText.text!.count != 0 ){
            let time: TimeInterval = 0.5;
            ViewController.cancelPreviousPerformRequests(withTarget: self);
            self.perform(#selector(autoCompleteRequest), with:nil, afterDelay: time);
        }
    }
    
    @IBAction func currentSeleted(_ sender: Any) {
        self.customText.isEnabled = false;
    }
    @IBAction func customSelected(_ sender: Any) {
        self.customText.isEnabled = true;
    }
    
    @IBAction func searchEvent(_ sender: Any) {
        if(self.keywordText.text == "" || (self.customText.text == "" && self.customText.isEnabled == true)){
            self.view.showToast("keyword and location are mandatory fields", position: ToastPosition.bottom, popTime: 3, dismissOnTap: true);
        }
        else{
            self.requestForSearch();
        }
    }
    
    @IBAction func clearAndReset(_ sender: Any) {
        self.keywordText.text = "";
        self.categoryText.text = "All";
        self.distanceText.text = "";
        self.unitPicker.selectRow( 0, inComponent: 0, animated: true);
        self.radioCurrent.isSelected = true;
        self.customText.text = "";
        self.customText.isEnabled = false;
        self.dropDownlist.isHidden = true;
    }
    
    func requestForSearch()
    {
        var distance = "10";
        if(self.distanceText.text! != ""){
            distance = self.distanceText.text!;
        }
        let searchParamDic = ["keyword":self.keywordText.text!,
                              "category":self.categoryText.text!,
                              "distance":distance,
                              "unit":self.unitArr[unitRow],
                              "locationText":self.customText.text!,
                              "latitude":self.currentloc.latitude,
                              "longitude":self.currentloc.longitude
            ] as [String : Any];
        SwiftSpinner.show("Searching for events...");
        Alamofire.request("\(backURL)/searchEvent", parameters: searchParamDic ).responseJSON { response in
            if(response.result.isSuccess){
                let jsonData = try!JSON(data: response.data!);
                self.eventlist = EventList.unpackEventList(dataJSON: jsonData);
                SwiftSpinner.hide();
                self.performSegue(withIdentifier: "turnToResult", sender: Any?.self);
            }else{
                print(response.result.error!);
            }
        };
    }
    
    @objc func autoCompleteRequest()
    {
        let term = self.keywordText.text!;
        if (term != "") {
            let param = ["keyword":term ];
            Alamofire.request("\(backURL)/autoComplete", parameters: param ).responseJSON { response in
                if(response.result.isSuccess){
                    self.autoArray.removeAll();
                    let jsonData = try!JSON(data: response.data!);
                    //判断空和error
                    let attractions = jsonData["attractions"];
                    for item in attractions{
                        let tmpName = item.1["name"];
                        self.autoArray.append( tmpName.rawString()! );
                        self.dropDownlist.isHidden = false;
                        self.dropDownlist.reloadData();
                    }
                }else{
                    print(response.result.error!);
                }
            };
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let resultVC = segue.destination as?
            ResultViewController {
            resultVC.eventlist = self.eventlist;
        }
    }
    //CLLocationManager delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last!;
        self.currentloc = currentLocation.coordinate;
    
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.view.showToast("fail to get Location", position: ToastPosition.bottom, popTime: 3, dismissOnTap: true);
    }
    //tableView dataSouce
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.autoArray.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ;
        cell?.textLabel?.text = autoArray[indexPath.row];
        return cell!;
    }
    //tableView delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.keywordText.text = self.autoArray[indexPath.row];
        self.dropDownlist.isHidden = true;
    }
    
    //pickerView dataSouce
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.unitArr.count;
    }
    //pickerView delegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.unitRow = row;
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30;
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let rowLabel = UILabel.init();
        rowLabel.font = UIFont(name: rowLabel.font.fontName, size: 14);
        rowLabel.text = self.unitArr[row];
        rowLabel.textAlignment  = NSTextAlignment.center;
        return rowLabel;
    }
}

