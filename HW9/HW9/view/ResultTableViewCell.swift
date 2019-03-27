//
//  ResultTableViewCell.swift
//  HW9
//
//  Created by Joey on 11/24/18.
//  Copyright © 2018 Joey. All rights reserved.
//

import UIKit

protocol ResultTableViewCellDelegate: class {
    func ResultTableViewCellDTapHeart( _sender: ResultTableViewCell );
}

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoBtn: UIButton!
    
    var isRed = false;
    weak var delegate: ResultTableViewCellDelegate?
    
    func renderWithData(cellData:EventData){
       
        switch cellData.category{

        case "Music":
            self.imgView.image = UIImage.init(imageLiteralResourceName: "music");
        case "Sports":
            self.imgView.image = UIImage.init(imageLiteralResourceName: "sports");
        case "Arts & Theatre":
            self.imgView.image = UIImage.init(imageLiteralResourceName: "arts");
        case "Film":
            self.imgView.image = UIImage.init(imageLiteralResourceName: "film");
        case "Miscellaneous":
            self.imgView.image = UIImage.init(imageLiteralResourceName: "miscellaneous");
        default:
            self.imgView.isHidden = true;
        }
        self.nameLabel.text = cellData.name;
        self.venueLabel.text = cellData.venueInfo;
        self.venueLabel.font = UIFont.italicSystemFont(ofSize:16);
       
        if(cellData.time != "N/A" ){
            self.dateLabel.text = cellData.date + " " + cellData.time;
        }else{
            self.dateLabel.text = cellData.date;
        }
        self.isRed = cellData.isFavorite;
        if( self.isRed == true ){
            self.favoBtn.setImage( UIImage.init(imageLiteralResourceName: "favorite-filled"), for: UIControl.State.normal);
        }else{
            self.favoBtn.setImage( UIImage.init(imageLiteralResourceName: "favorite-empty"), for: UIControl.State.normal);
        }
    }
    
    @IBAction func setFavorite(_ sender: Any) {
        isRed = !isRed;
        if( isRed == true ){
            self.favoBtn.setImage( UIImage.init(imageLiteralResourceName: "favorite-filled"), for: UIControl.State.normal);
        }else{
            self.favoBtn.setImage( UIImage.init(imageLiteralResourceName: "favorite-empty"), for: UIControl.State.normal);
        }
        delegate?.ResultTableViewCellDTapHeart(_sender: self);
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
