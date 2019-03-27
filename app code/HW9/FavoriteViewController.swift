//
//  FavoriteViewController.swift
//  HW9
//
//  Created by Joey on 11/29/18.
//  Copyright © 2018 Joey. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var favoTable: UITableView!
    @IBOutlet weak var noResultsLB: UILabel!
    var tableArray = [EventData]();
    var selectedRow = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.favoTable.register(UITableViewCell.self, forCellReuseIdentifier: "tmpcell");
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.readFromUserDefaults();
    }
    
    func readFromUserDefaults(){
        self.tableArray.removeAll();
        let dic = UserDefaults.standard.dictionaryRepresentation();
        
        if( UserDefaults.standard.array(forKey: "eventIDArr")  != nil && UserDefaults.standard.array(forKey: "eventIDArr")!.count != 0 ){
            let eventIDArr = UserDefaults.standard.array(forKey: "eventIDArr") as![String];
            for indexID in eventIDArr{
                for key in dic.keys{
                    if(indexID == key){
                        let nsData = UserDefaults.standard.data(forKey: key);
                        let eventData = NSKeyedUnarchiver.unarchiveObject(with: nsData!) as! EventData
                        self.tableArray.append(eventData);
                    }
                }
            }
            self.noResultsLB.isHidden = true;
            self.favoTable.isHidden = false;
            self.favoTable.reloadData();
        }else{
            self.favoTable.isHidden = true;
            self.noResultsLB.isHidden = false;
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(self.selectedRow);
        if let detailTabController = segue.destination as?
            DetailTabBarController {
            self.tableArray[self.selectedRow].isFavorite = true;
            detailTabController.eventData = self.tableArray[self.selectedRow];
        }
    }
    
    //dataSouce
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableArray.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell") as! ResultTableViewCell;
        cell.renderWithData(cellData: self.tableArray[indexPath.row]);
        cell.favoBtn.isHidden = true;
        return cell;
    }
    //delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row;
        self.performSegue(withIdentifier: "favoToDetail", sender: Any?.self);
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete";
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            print(indexPath.row);
            UserDefaultsRemoveObject(key: self.tableArray[indexPath.row].eventID);
            self.tableArray.remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            if(self.tableArray.count == 0){
                self.noResultsLB.isHidden = false;
                self.favoTable.isHidden = true;
            }
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
