//
//  ViewController.swift
//  DoacaoCK
//
//  Created by Alcides Junior on 29/01/19.
//  Copyright © 2019 Alcides Junior. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var inputPesquisar: UITextField!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var inputNome: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func buscarButton(_ sender: Any) {
    }
    
    @IBAction func adicionarButton(_ sender: Any) {
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        return cell
    }
    
    
}
