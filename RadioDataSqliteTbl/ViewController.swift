//
//  ViewController.swift
//  RadioDataSqliteTbl
//
//  Created by John Diczhazy on 7/23/17.
//  Copyright © 2017 JohnDiczhazy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var sourceValue = " "
    var lineStatus = " "

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? CreateEditViewController {
            destinationController.destValue = sourceValue
        }
    }
    
    @IBAction func btnCreate(_ sender: Any) {
        self.performSegue(withIdentifier: "updateSegue", sender:sender)    }

    var radioData: [Dictionary<String, AnyObject>] = []
    let cellTableIdentifier = "CellTableIdentifier"
    
    @IBOutlet var tableView:UITableView!
    
    
    @IBOutlet weak var lineSearch: UITextField!
    
    @IBAction func searchBtn(_ sender: Any) {
        if lineSearch.text == "" {
            radioData = DBAccess.readAllRecords() as [Dictionary<String, AnyObject>]
            tableView.reloadData()
        } else {
            radioData = DBAccess.searchRecords(keyword: lineSearch.text!) as [Dictionary<String, AnyObject>]
            tableView.reloadData()
       }
    }
    
    override func viewDidLoad() {
        DBAccess.initDB()
        radioData = DBAccess.readAllRecords() as [Dictionary<String, AnyObject>]
        super.viewDidLoad()
        tableView.register(CellDetails.self,
                           forCellReuseIdentifier: cellTableIdentifier)
        let xib = UINib(nibName: "CellDetails", bundle: nil)
        tableView.register(xib,
                           forCellReuseIdentifier: cellTableIdentifier)
        tableView.rowHeight = 86

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Table View Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return radioData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: cellTableIdentifier, for: indexPath)
         as! CellDetails
        
         let rowData = radioData[indexPath.row]
    
         cell.row = rowData["Row"]! as! String
         cell.make = rowData["Make"]! as! String
         cell.model = rowData["Model"]! as! String
         cell.serialNO = rowData["SerialNO"]! as! String
        
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let uiAlert = UIAlertController(title: "Delete", message: "Confirm Delete Action", preferredStyle: UIAlertControllerStyle.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
                print("Click of default button")
                
                
                let rowData = self.radioData[indexPath.row]
                self.sourceValue = rowData["Row"] as! String
                self.lineStatus = DBAccess.deleteRecord(row: Int32(self.sourceValue)!)
                print(self.lineStatus)
                //Reload data, otherwise, you will get a SIGABRT error
                self.radioData = DBAccess.readAllRecords() as [Dictionary<String, AnyObject>]
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                print(self.lineStatus)
                
            }))
            
            uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                print("Click of cancel button")
            }))

        
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let rowData = self.radioData[indexPath.row]
                    self.sourceValue = rowData["Row"] as! String
                    //print ("You selected \(rowData["Row"]!)")
                    self.performSegue(withIdentifier: "updateSegue", sender:tableView)
        }
        
        edit.backgroundColor = UIColor.blue
        
        return [delete, edit]
    }
}
