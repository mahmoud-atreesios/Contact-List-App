//
//  ViewController.swift
//  Contact-List-App
//
//  Created by Mahmoud Mohamed Atrees on 30/07/2024.
//

import UIKit
import SQLite3

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let db = openDataBase()
        //createTable(db: db)                                       //1
        //insert(id: 1, name: "Mahmoud", db: db)                    //2
        //query(db: db)                                             //3
        //delete(ID: 1, db: db)                                     //4
        //query(db: db)
    }
}

//MARK: - 1st open connection with the sqlite db
extension ViewController{
    func openDataBase() -> OpaquePointer?{
        var db:OpaquePointer?
        let fileUrl = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension("Contacts.sqlite")
        
        if sqlite3_open(fileUrl?.path(), &db) == SQLITE_OK{
            print("connection successed")
            return db
        }else{
            print("connection failed")
            return nil
        }
    }
}

//MARK: - 2nd create the tables you need using sqlite db
extension ViewController{
    func createTable(db:OpaquePointer?){
        let createTableString = """
        CREATE TABLE Contact(Id INT PRIMARY KEY NOT NULL,
        Name CHAR(255));
"""
        //1
        var createTableStatment:OpaquePointer?
        
        //2
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatment, nil) == SQLITE_OK{
           //3
            if sqlite3_step(createTableStatment) == SQLITE_DONE {
                print("\nContact table created")
            }else{
                print("\nContact table is not created")
            }
        }else{
            print("Create table statment is not prepared")
        }
        //4
        sqlite3_finalize(createTableStatment)
    }
}

//MARK: - 3rd insert data in the tables you need using sqlite db
extension ViewController{
    func insert(id:Int32,name:NSString,db:OpaquePointer?){
        let insertStatementString = "INSERT INTO Contact (Id,Name) VALUES (?, ?);"
        var insertStatment:OpaquePointer?
        //1
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatment, nil) == SQLITE_OK{
            
            //2
            sqlite3_bind_int(insertStatment, 1, id)
            
            //3
            sqlite3_bind_text(insertStatment, 2, name.utf8String, -1, nil)
            
            //4
            if sqlite3_step(insertStatment) == SQLITE_DONE{
                print("\nSuccessfully inserted row")
            }else{
                print("User with this ID already exists")
            }
        }else{
            print("Insert statment is not prepared")
        }
        //5
        sqlite3_finalize(insertStatment)
    }
}

//MARK: - 4th query to fetch data you need from tables in sqlite db
extension ViewController{
    func query(db: OpaquePointer?) {
        let queryStatementString = "SELECT * FROM Contact;"
        var queryStatement: OpaquePointer?
        // 1
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) ==
            SQLITE_OK {
            // 2
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                // 3
                let id = sqlite3_column_int(queryStatement, 0)
                // 4
                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
                    print("Query result is nil")
                    return
                }
                let name = String(cString: queryResultCol1)
                // 5
                print("\nQuery Result:")
                print("\(id) | \(name)")
            }
        } else {
            // 6
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        // 7
        sqlite3_finalize(queryStatement)
    }
}
