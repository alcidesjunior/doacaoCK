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
    
    func search(using predicate: NSPredicate, then completion: @escaping (([CKRecord]?) -> Void)) {
        var records = [CKRecord]()
        let query = CKQuery(recordType: "Doacao", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["nome","photo"]
        
        operation.recordFetchedBlock = { record in
            records.append(record)
        }
        
        operation.queryCompletionBlock = { (cursor, error) in
            guard error == nil else {
                print("To aqui")
                print(error)
                completion(nil)
                return
            }
            
            completion(records)
        }
        
        self.container.privateCloudDatabase.add(operation)
    }
    
    func save(record: CKRecord, then completion: @escaping ((CKRecord?) -> Void)) {
        self.container.privateCloudDatabase.save(record) { (record, error) in
            guard error == nil else {
                 print("To aqui 2")
                print(error!)
                completion(nil)
                return
            }
            
            print("Record saved")
            completion(record)
        }
    }
    
}
