//
//  ViewController.swift
//  DoacaoCK
//
//  Created by Alcides Junior on 29/01/19.
//  Copyright © 2019 Alcides Junior. All rights reserved.
//

import UIKit
import CloudKit
import SystemConfiguration
import MobileCoreServices

class ViewController: UIViewController {
    
    @IBOutlet weak var inputPesquisar: UITextField!
    @IBOutlet weak var imagePreview: UIImageView!
    
    @IBOutlet weak var inputNome: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let manager = CloudKitManager()
    var doacoes = [CKRecord]()
    var photoURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.manager.search(using: NSPredicate(value: true)) { (records) in
            guard let records = records else { return }
            
            DispatchQueue.main.async {
                self.doacoes = records
                
                self.tableView.reloadData()
            }
        }
        
        inputNome.delegate = self
        inputPesquisar.delegate = self
        
    }
    
    func QjueryDataBase(search: String)  {
        
        if search == ""{
            self.manager.search(using: NSPredicate(value: true)) { (records) in
                guard let records = records else { return }
                
                DispatchQueue.main.async {
                    self.doacoes = records
                    
                    self.tableView.reloadData()
                }
            }
        }
        else{
            let user = inputPesquisar.text
            self.manager.search(using: NSPredicate(format: "nome == %@", user!)) { (records) in
                guard let records = records else { return }
                DispatchQueue.main.async {
                    self.doacoes = records
                    
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    @IBAction func buscarButton(_ sender: Any) {
        self.view.endEditing(true)
        QjueryDataBase(search: inputPesquisar.text!)
    }
    
    @IBAction func adicionarButton(_ sender: Any) {
        if (photoURL == nil){
            self.notifyUser(title: "Alert", message: "No image was selected, please select an image")
        }
        let asset = CKAsset(fileURL: photoURL)
        let record = CKRecord(recordType: "Doacao")
        record["nome"] = self.inputNome.text
        record["photo"] = asset
        
        self.manager.save(record: record) { (record) in
            // Aqui era pra ser tratado o erro.
            guard let record = record else { return }
            
            DispatchQueue.main.async {
                self.doacoes.append(record)
                self.tableView.reloadData()
                self.view.endEditing(true)
            }
        }
        QjueryDataBase(search: inputPesquisar.text!)
        imagePreview.image = nil
        photoURL = nil
        
    }
    
    @IBAction func selectPhoto(_ sender: Any) {
        let imagerPicker = UIImagePickerController()
        imagerPicker.delegate = self
        imagerPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagerPicker.mediaTypes = [kUTTypeImage as String]
        self.present(imagerPicker,animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.doacoes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        let photo = self.doacoes[indexPath.row].value(forKey: "photo") as? CKAsset
        let image = UIImage(contentsOfFile: (photo?.fileURL.path)!)
        cell.imageView?.image = image
        self.photoURL = self.saveImageToFile(image!)
        
        cell.nomeLabel?.text = (self.doacoes[indexPath.row].value(forKey: "nome") as! String)
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
        inputPesquisar.endEditing(true)
        inputNome.endEditing(true)
        
        self.view.endEditing(true)
    }
}
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePreview.image = image
        photoURL = saveImageToFile(image)
    }
    
    func saveImageToFile(_ image: UIImage) -> URL {
        let filemgr = FileManager.default
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = dirPaths[0].appendingPathComponent("CurrentImage.jpg")
        if let renderedJPEGData =  image.jpegData(compressionQuality: 0.5){
            try! renderedJPEGData.write(to: fileURL)
        }
        return fileURL
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func notifyUser(title: String, message: String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
