//
//  DBAccess.swift
//  RadioDataSqliteTbl
//
//  Created by John Diczhazy on 7/23/17.
//  Copyright © 2017 JohnDiczhazy. All rights reserved.
//

import Foundation

class DBAccess {
    
    
    class func initDB() {
        //Create Database and Table if they do not exist @ specified path
        var database:OpaquePointer? = nil
        var result = sqlite3_open(dataFilePath(), &database)
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
            return
        }
        
        let createSQL = "CREATE TABLE IF NOT EXISTS RadioData " +
        "(ROW INTEGER PRIMARY KEY, Make TEXT, Model TEXT, SerialNO TEXT);"
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        result = sqlite3_exec(database, createSQL, nil, nil, &errMsg)
        if (result != SQLITE_OK) {
            sqlite3_close(database)
            print("Failed to create table")
            return
        }
    }

    class func createRecord(make: String, model: String, serialNO: String) -> String{
        var database:OpaquePointer? = nil
        let result = sqlite3_open(dataFilePath(), &database)
        var message: String = ""
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
            message = "Failed to open database"
        }
        
        let insert:String = "INSERT INTO RadioData (Make,Model,SerialNO)" + " VALUES ('\(make)','\(model)','\(serialNO)');"
        //let insert:String = "INSERT INTO RadioData (ROW,Make,Model,SerialNO)" + " VALUES ('14','Motorola','XR','54321');"
        
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, insert, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Record Created")
                message = "Record Created"
            } else {
                print("Record NOT Created")
                message = "Record NOT Created"
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        return message
    }
    
//    class func readRecord(model: String) -> Array<String>{
//        
//        var database:OpaquePointer? = nil
//        let result = sqlite3_open(dataFilePath(), &database)
//        var message: String = ""
//        var fieldRow: String = ""
//        var fieldMake: String = ""
//        var fieldModel: String = ""
//        var fieldSerialNO: String = ""
//        var myArray: [String] = []
//        
//        if result != SQLITE_OK {
//            sqlite3_close(database)
//            print("Failed to open database")
//            message = "Failed to open database"
//        }
//        
//        
//        let query = "SELECT ROW, Make, Model, SerialNO FROM RadioData WHERE Model = '\(model)'"
//        var statement:OpaquePointer? = nil
//        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
//            
//            message = "Record NOT Found"
//            
//            myArray.insert ("", at: 0)
//            myArray.insert ("", at: 1)
//            myArray.insert ("", at: 2)
//            myArray.insert ("", at: 3)
//            myArray.insert (message, at: 4)
//            
//            
//            while sqlite3_step(statement) == SQLITE_ROW {
//                let row = sqlite3_column_text(statement, 0)
//                let rowData = sqlite3_column_text(statement, 1)
//                let rowData1 = sqlite3_column_text(statement, 2)
//                let rowData2 = sqlite3_column_text(statement, 3)
//                
//                fieldRow = String(cString:(row!))
//                fieldMake = String(cString:(rowData!))
//                fieldModel = String(cString:(rowData1!))
//                fieldSerialNO = String(cString:(rowData2!))
//                
//                message = "Record Found"
//                
//                myArray.insert (fieldRow, at: 0)
//                myArray.insert (fieldMake, at: 1)
//                myArray.insert (fieldModel, at: 2)
//                myArray.insert (fieldSerialNO, at: 3)
//                myArray.insert (message, at: 4)
//                
//            }
//            sqlite3_finalize(statement)
//        }
//        sqlite3_close(database)
//        return myArray
//    }
    
    class func readRecord(row: Int32) -> Array<String>{
        
        var database:OpaquePointer? = nil
        let result = sqlite3_open(dataFilePath(), &database)
        var message: String = ""
        var fieldRow: String = ""
        var fieldMake: String = ""
        var fieldModel: String = ""
        var fieldSerialNO: String = ""
        var myArray: [String] = []
        
        
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
            message = "Failed to open database"
        }
        
        let query = "SELECT ROW, Make, Model, SerialNO FROM RadioData WHERE ROW = '\(row)'"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            
            message = "Record NOT Found"
            
            myArray.insert ("", at: 0)
            myArray.insert ("", at: 1)
            myArray.insert ("", at: 2)
            myArray.insert ("", at: 3)
            myArray.insert (message, at: 4)
            
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let row = sqlite3_column_text(statement, 0)
                let rowData = sqlite3_column_text(statement, 1)
                let rowData1 = sqlite3_column_text(statement, 2)
                let rowData2 = sqlite3_column_text(statement, 3)
                
                fieldRow = String(cString:(row!))
                fieldMake = String(cString:(rowData!))
                fieldModel = String(cString:(rowData1!))
                fieldSerialNO = String(cString:(rowData2!))
                
                message = "Record Found"
                
                myArray.insert (fieldRow, at: 0)
                myArray.insert (fieldMake, at: 1)
                myArray.insert (fieldModel, at: 2)
                myArray.insert (fieldSerialNO, at: 3)
                myArray.insert (message, at: 4)
                
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        return myArray
    }

    class func readAllRecords() -> Array<Dictionary<String, AnyObject>> {

        var database:OpaquePointer? = nil
        let result = sqlite3_open(dataFilePath(), &database)
        var fieldRow: String = ""
        var fieldMake: String = ""
        var fieldModel: String = ""
        var fieldSerialNO: String = ""
        var myArray: [Dictionary<String, AnyObject>] = []
        
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
        }

        let query = "SELECT * FROM RadioData ORDER BY Make, Model"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let row = sqlite3_column_text(statement, 0)
                let rowData = sqlite3_column_text(statement, 1)
                let rowData1 = sqlite3_column_text(statement, 2)
                let rowData2 = sqlite3_column_text(statement, 3)

                fieldRow = String(cString:(row!))
                fieldMake = String(cString:(rowData!))
                fieldModel = String(cString:(rowData1!))
                fieldSerialNO = String(cString:(rowData2!))
                
                let RadioInfo = ["Row": fieldRow, "Make": fieldMake, "Model": fieldModel, "SerialNO": fieldSerialNO ]
                
                myArray.append(RadioInfo as [String : AnyObject])
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        return myArray
    }
    
    class func updateRecord(row: Int32, make: String, model: String, serialNO: String) -> String{
        var database:OpaquePointer? = nil
        let result = sqlite3_open(dataFilePath(), &database)
        var message: String = ""
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
            message = "Failed to open database"
        }
        
        
        let update:String = "UPDATE RadioData SET Make='\(make)',Model='\(model)',SerialNO='\(serialNO)' WHERE row='\(row)'"
        //let update:String = "UPDATE RadioData SET Make='Zenith1',Model='X334',SerialNO='1234' WHERE row='\(row)'"
        
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Sucessfully updated row.")
                message = "Record Updated"
            } else {
                print("Could not update row.")
                message = "Record NOT Updated"
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        return message
    }
    
    class func deleteRecord(row: Int32) -> String{
        var database:OpaquePointer? = nil
        let result = sqlite3_open(dataFilePath(), &database)
        var message: String = ""
        if result != SQLITE_OK {
            sqlite3_close(database)
            print("Failed to open database")
            message = "Failed to open database"
        }
        
        let update:String = "DELETE FROM RadioData WHERE row='\(row)'"
        
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Record Deleted")
                message = "Record Deleted"
            } else {
                print("Record NOT Deleted")
                message = "Record NOT Deleted"
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(database)
        return message
    }
    
    
    class func dataFilePath() -> String {
        let urls = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask)
        return urls.first!.appendingPathComponent("RadioData.sqlite").path
    }
}
