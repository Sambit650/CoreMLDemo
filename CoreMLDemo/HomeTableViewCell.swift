//
//  HomeTableViewCell.swift
//  CoreMLDemo
//
//  Created by Sambit Das on 17/01/21.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
   //MARK:- Outlets & properties
    @IBOutlet weak var sectionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
