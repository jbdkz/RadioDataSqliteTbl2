//
//  CellDetails.swift
//  RadioDataSqliteTbl
//
//  Created by John Diczhazy on 7/23/17.
//  Copyright © 2017 JohnDiczhazy. All rights reserved.
//

import UIKit

class CellDetails: UITableViewCell {
    
    @IBOutlet var rowLabel: UILabel!
    @IBOutlet var makeLabel: UILabel!
    @IBOutlet var modelLabel: UILabel!
    @IBOutlet var serialNOLabel: UILabel!
    
       
    
    var row: String = "" {
        didSet {
            if (row != oldValue) {
                rowLabel.text = row
            }
        }
    }

    var make: String = "" {
        didSet {
            if (make != oldValue) {
                makeLabel.text = make
            }
        }
    }
    
    var model: String = "" {
        didSet {
            if (model != oldValue) {
                modelLabel.text = model
            }
        }
    }
    
    var serialNO: String = "" {
        didSet {
            if (serialNO != oldValue) {
                serialNOLabel.text = serialNO
            }
        }
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
