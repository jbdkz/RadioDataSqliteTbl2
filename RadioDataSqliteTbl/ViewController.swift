//
//  ViewController.swift
//  RadioDataSqliteTbl
//
//  Created by John Diczhazy on 7/23/17....JRD
//  Copyright © 2017 JohnDiczhazy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var sourceValue = " "
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let data = Data()
        if let destinationController = segue.destination as? CreateEditViewController {
            destinationController.destValue = sourceValue
        }
    }
    
    @IBAction func btnCreate(_ sender: Any) {
        self.performSegue(withIdentifier: "updateSegue", sender:sender)    }

    var radioData: [Dictionary<String, AnyObject>] = []
    let cellTableIdentifier = "CellTableIdentifier"
    @IBOutlet var tableView:UITableView!
    
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

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowData = radioData[indexPath.row]
        sourceValue = rowData["Row"] as! String
        //print ("You selected \(rowData["Row"]!)")
        self.performSegue(withIdentifier: "updateSegue", sender:tableView)
            }
}
