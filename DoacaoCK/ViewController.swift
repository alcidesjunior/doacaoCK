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
        inputNome.delegate = self
        inputPesquisar.delegate = self
    }

    @IBAction func buscarButton(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func adicionarButton(_ sender: Any) {
        self.view.endEditing(true)
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
extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputPesquisar.resignFirstResponder()
        inputNome.resignFirstResponder()
        self.view.endEditing(true)
    }
}
