//
//  ListTableViewCell.swift
//  PhotosApp
//
//  Created by Ram Harshvardhan Radhakrishnan on 6/9/16.
//  Copyright © 2016 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
   

    @IBOutlet weak var listTextView: UITextView!


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        listTextView.editable = true
        
    
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
