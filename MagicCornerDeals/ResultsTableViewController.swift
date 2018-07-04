//
//  ResultsTableViewController.swift
//  MagicCornerDeals
//
//  Created by Giorgio Dalvit on 04/07/18.
//  Copyright © 2018 Giorgio Dalvit. All rights reserved.
//

import UIKit
import SwiftSoup
import Kingfisher

class ResultsTableViewController: UITableViewController {
    
//    var data : [String : [DealElement]] = [:]
    
    var wants : [String] = []
    
    let fileManagement = FileManagement()
    
    let voidDeal = DealElement(imgUrl: "", title: "", discount: "")
    
    var objectArray = [Objects]()
    
    struct Objects {
        
        var sectionName : String!
        var sectionObjects : [DealElement]!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        loadSearch()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wants = fileManagement.loadWantsFromFile()
        loadSearch(wants)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return objectArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objectArray[section].sectionObjects.count//data.count
    }
    
    func loadSearch(_ wants: [String])->Void{
        for want in wants {
            var dElems : [DealElement] = []
        do {
            let filteredWant = want.replacingOccurrences(of: " ", with: "%20")
            let url = URL(string: "https://www.magiccorner.it/it/search?q=\(filteredWant)")
            let html = try String(contentsOf: url!, encoding: String.Encoding.utf8)
            let doc = try SwiftSoup.parse(html)
            if(try doc.getElementsByClass("row").isEmpty()){
                return
            }
            guard let elements: Elements = try? doc.select("span.pull-right:has(a)") else { return }
            for spanEl: Element in elements {
                var elUrl = try spanEl.getElementsByTag("a").get(0).attr("href")
                if(elUrl.hasPrefix("/it")){
                    elUrl = ("https://www.magiccorner.it\(elUrl)")
                    //                    imgUrl.removeFirst(2)
                }
                let deal = load(urlString: elUrl, want)
                if(!deal.title.isEmpty){
                    dElems.append(deal)
                }
            }
//            data[want] = dElems
//            for (key, value) in data {
                objectArray.append(Objects(sectionName: want, sectionObjects: dElems))
//            }
        } catch let error {
            print("Error: \(error)")
        }
        }
    }
    
    func load(urlString : String, _ want : String)-> DealElement {
        //        for i in 46000...46700{
        do {
            let url = URL(string: urlString)//"https://www.magiccorner.it/it/info-prodotto/284/278/\(i)")
            let html = try String(contentsOf: url!, encoding: String.Encoding.utf8)
            let doc = try SwiftSoup.parse(html)
            if(try doc.getElementsByClass("badge-red").isEmpty()){
                return voidDeal
            }
            guard let badgeEls: Elements = try? doc.select(".badge-red") else { return voidDeal}
            //            guard let element : Element = badgeEls.array().first else { return }
            var deals : [String] = []
            for element: Element in badgeEls.array() {
                if let found = try? element.text(){
                    deals.append(found)
                }
            }
            //            if(element){
            if(deals.count == 0){
                return voidDeal
            }
            var dealEl = DealElement()
            dealEl.discount = deals.joined(separator: "\n")
            guard let els: Elements = try? doc.select("img.img-scheda") else { return voidDeal}//"h1.product-h1:has(img)"
            guard let imgAndTxtEl : Element = els.array().first else { return voidDeal}
            var imgUrl = try imgAndTxtEl.attr("src")
            if(imgUrl.hasPrefix("//")){
                imgUrl = ("https:\(imgUrl)")
                //                    imgUrl.removeFirst(2)
            }
            dealEl.imgUrl = imgUrl
            dealEl.title = try imgAndTxtEl.attr("alt")
            return dealEl
            //                for element: Element in els.array() {
            //                    //                    let imgElement = try element.getElementsByTag("img")
            //
            //                    let img = downloadImage(url: URL(string: imgUrl)!)
            //                    let name = try element.attr("alt")
            //
            //                    print(name)
            //
            //                }
            //            }
        } catch let error {
            print("Error: \(error)")
        }
        return voidDeal
        //        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as! DealCell //1.
        
        let deal = objectArray[indexPath.section].sectionObjects[indexPath.row]
        
        cell.title.text = deal.title //3.
        cell.discount.text = deal.discount
        cell.imgView.kf.setImage(with: URL(string: deal.imgUrl))
        
        return cell //4.
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectArray[section].sectionName
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
