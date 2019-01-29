//
//  ViewController.swift
//  DoacaoCK
//
//  Created by Alcides Junior on 29/01/19.
//  Copyright © 2019 Alcides Junior. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    @IBOutlet weak var inputPesquisar: UITextField!
    @IBOutlet weak var imagePreview: UIImageView!
    
    @IBOutlet weak var inputNome: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let manager = CloudKitManager()
    var doacoes = [CKRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.manager.queryDatabase { (records) in
            guard let records = records else { return }
            
            DispatchQueue.main.async {
                self.doacoes = records
                
                self.tableView.reloadData()
            }
        }
        
    }
    
    @IBAction func buscarButton(_ sender: Any) {
    }
    
    @IBAction func adicionarButton(_ sender: Any) {
        let record = CKRecord(recordType: "Doacao")
        record["nome"] = self.inputNome.text
        
        self.manager.save(record: record) { (record) in
            // Aqui era pra ser tratado o erro.
            guard let record = record else { return }
            
            DispatchQueue.main.async {
                self.doacoes.append(record)
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.doacoes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        cell.nomeLabel?.text = self.doacoes[indexPath.row].value(forKey: "nome") as? String
        
        return cell
    }
    
}
