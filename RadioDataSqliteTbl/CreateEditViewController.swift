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
    
    @IBOutlet weak var deleteRecord: UIButton!
    
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
    
    @IBAction func deleteRecord(_ sender: UIButton) {
        let uiAlert = UIAlertController(title: "Delete", message: "Confirm Delete Action", preferredStyle: UIAlertControllerStyle.alert)
        self.present(uiAlert, animated: true, completion: nil)
        
        uiAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
            print("Click of default button")
            self.lineStatus.text = DBAccess.deleteRecord(row: Int32(self.lineROW.text!)!)
            self.performSegue(withIdentifier: "backSegue", sender:sender)
            if self.lineStatus.text == "Record Deleted"{
                self.lineROW.text = ""
                self.lineMake.text = ""
                self.lineModel.text = ""
                self.lineSerialNO.text = ""
            }
            
        }))
        
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Click of cancel button")
        }))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (Int32(destValue)) != nil {
            createRecord.isHidden = true
            updateRecord.isHidden = false
            deleteRecord.isHidden = false
            readRecord()
            self.lineMake.becomeFirstResponder()
    } else {
            createRecord.isHidden = false
            updateRecord.isHidden = true
            deleteRecord.isHidden = true
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
