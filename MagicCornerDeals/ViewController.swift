//
//  ViewController.swift
//  MagicCornerDeals
//
//  Created by Giorgio Dalvit on 01/07/18.
//  Copyright © 2018 Giorgio Dalvit. All rights reserved.
//

import UIKit
import SwiftSoup
import Kingfisher

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtField: UITextField!
    
    var data : [String] = []
    let fileManagement = FileManagement()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        data = fileManagement.loadWantsFromFile()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(fileManagement.updateWantsToFile(data: data, row: indexPath.row)){
            data.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    
    @IBAction func addAction() {
        insertWant()
    }
    
    func insertWant(){
        if(!(txtField.text?.isEmpty)!){
            if(fileManagement.insertWantInFileUpdatingData(want: txtField.text!, data: &data)){
                let indexPath = IndexPath(row: data.count - 1, section: 0)
                tableView.beginUpdates()
                tableView.insertRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
                
                txtField.text = ""
                view.endEditing(true)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") //1.
        
        let want = data[indexPath.row]
        
        cell?.textLabel?.text = want //3.
        
        return cell! //4.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

