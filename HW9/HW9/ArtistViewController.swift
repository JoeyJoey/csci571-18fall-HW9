//
//  ArtistViewController.swift
//  HW9
//
//  Created by Joey on 11/28/18.
//  Copyright © 2018 Joey. All rights reserved.
//

import UIKit
import SnapKit

class ArtistViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
   
    struct Section{
        var sectionName : String
        var data: [Any]
    }
    
    @IBOutlet weak var noResultLB: UILabel!
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    var data = ArtistDataList();
    var sectionList = [Section]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionLayout.sectionHeadersPinToVisibleBounds = true;
        
        // Do any additional setup after loading the view.
    }
    func changeDataToSectionType(){
        if(data.hasCustom == false && data.hasSpotify == false){
            self.noResultLB.isHidden = false;
            self.noResultLB.snp.makeConstraints { (make) in
                make.height.equalToSuperview();
                make.width.equalToSuperview();
            }
        }
        
        if(self.data.profileList.count != 0){
            for singleData in self.data.profileList{
                let sectionData = Section( sectionName: singleData.name , data: [singleData] );
                self.sectionList.append(sectionData);
            }
        }
        for (key,array) in self.data.imgList{
            let sectionData = Section(sectionName: key, data: array);
            self.sectionList.append(sectionData);
        }
        self.collectionView.reloadData();
    }

    //collectionView dataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sectionList.count;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sectionList[section].data.count;
      
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! SectionHeaderView;
        sectionHeaderView.nameLabel.text = self.sectionList[indexPath.section].sectionName;
        
        return sectionHeaderView;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.section <= data.profileList.count-1 ){
            let  profileCell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as! ProfileCell;
            print ("indexPath",indexPath);
            profileCell.setWithData(data: self.sectionList[indexPath.section].data[indexPath.row] as! ArtistData);
            return profileCell;
        }else{
            let imgCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as! imgCell;
            imgCell.setWithData(urlStr: self.sectionList[indexPath.section].data[indexPath.row] as! String);
            return imgCell;
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
