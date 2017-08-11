//
//  CreateEditViewController.swift
//  RadioDataSqliteTbl
//
//  Created by John Diczhazy on 7/26/17.
//  Copyright © 2017 JohnDiczhazy. All rights reserved.
//

import UIKit

class CreateEditViewController: UIViewController {
    var destValue = ""
    
    @IBOutlet weak var lineROW: UILabel!
    
    @IBOutlet weak var lineMake: UITextField!
    
    @IBOutlet weak var lineModel: UITextField!
    
    @IBOutlet weak var lineSerialNO: UITextField!
    
    @IBOutlet weak var lineStatus: UILabel!
    
    @IBOutlet weak var createRecord: UIButton!
    
    @IBOutlet weak var updateRecord: UIButton!
    
    @IBAction func createRecord(_ sender: UIButton) {
        self.lineStatus.text = ""
        if validate() == true {
            self.lineStatus.text = DBAccess.createRecord(make: (lineMake.text)!, model: (lineModel.text)!, serialNO:(lineSerialNO.text)!)
            self.performSegue(withIdentifier: "backSegue", sender:sender)
        }
    }
    
    func readRecord() {
        let arrayOutput: [String]
    
        arrayOutput = DBAccess.readRecord(row: Int32(destValue)!)
        
        lineROW.text = arrayOutput[0]
        lineMake.text = arrayOutput[1]
        lineModel.text = arrayOutput[2]
        lineSerialNO.text = arrayOutput[3]
        //lineStatus.text = arrayOutput[4]
    }
    
    @IBAction func updateRecord(_ sender: UIButton) {
        self.lineStatus.text = ""
        if validate() == true {
            self.lineStatus.text = DBAccess.updateRecord(row: Int32(lineROW.text!)!,make: (lineMake.text)!, model: (lineModel.text)!, serialNO:(lineSerialNO.text)!)
            self.performSegue(withIdentifier: "backSegue", sender:sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (Int32(destValue)) != nil {
            createRecord.isHidden = true
            updateRecord.isHidden = false
            readRecord()
            self.lineMake.becomeFirstResponder()
    } else {
            createRecord.isHidden = false
            updateRecord.isHidden = true
            }
    }
    
    func validate() ->Bool {
        lineStatus.text = ""
        
        if (lineMake.text?.isEmpty)! {
            lineStatus.text = "Value in Make field is required!"
            self.lineMake.becomeFirstResponder()
            return false
        } else if (lineModel.text?.isEmpty)! {
            lineStatus.text = "Value in Model field is required!"
            self.lineModel.becomeFirstResponder()
            return false
        } else if (lineSerialNO.text?.isEmpty)!{
            lineStatus.text = "Value in SerialNO field is required!"
            self.lineSerialNO.becomeFirstResponder()
            return false
        } else {
            self.lineMake.becomeFirstResponder()
            return true
        }
    }
}
