//
//  CloudKitManager.swift
//  DoacaoCK
//
//  Created by Matheus Costa on 29/01/19.
//  Copyright © 2019 Alcides Junior. All rights reserved.
//

import UIKit
import CloudKit

class CloudKitManager: NSObject {
    
    private let container = CKContainer.default()
    
    func queryDatabase(then completion: @escaping (([CKRecord]?) -> Void)) {
        let query = CKQuery(recordType: "Doacao", predicate: NSPredicate(value: true))
        
        self.container.privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            guard error == nil else {
                print(error!)
                completion(nil)
                return
            }
            
            completion(records)
        }
    }
    
    func save(record: CKRecord, then completion: @escaping ((CKRecord?) -> Void)) {
        self.container.privateCloudDatabase.save(record) { (record, error) in
            guard error == nil else {
                print(error!)
                completion(nil)
                return
            }
            
            print("Record saved")
            completion(record)
        }
    }
    
}
