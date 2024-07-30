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
