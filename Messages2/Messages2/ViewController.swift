//
//  ViewController.swift
//  Messages2
//
//  Created by Spartak Buniatyan on 3/22/17.
//  Copyright © 2017 Spartak Buniatyan. All rights reserved.
//

import UIKit

public let messagesUrl = "http://newest.site.swiftengine.net/messages.ssp"

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableData : Array<[String:AnyObject]>?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadTableData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tableData != nil {
            print(self.tableData!.count)
            return self.tableData!.count
        }
        return 0
    }
    
    let cellId = "myCellId"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) ?? UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        
        let recordIndex = indexPath.row
        
        cell.textLabel?.text = self.tableData![recordIndex]["message"]!["name"] as? String ?? "Nope"
        cell.detailTextLabel?.text = self.tableData![recordIndex]["message"]!["message"] as? String ?? ""
        
        
        return cell
        
        
    }
    
    
    
    func convertJsonDataToDictionary(_ inputData : Data) -> Array<[String:AnyObject]>? {
        guard inputData.count > 1 else{ return nil }  // avoid processing empty responses
        
        do {
            return try JSONSerialization.jsonObject(with: inputData, options: []) as? Array<Dictionary<String, AnyObject>>
        }catch let error as NSError{
            print(error)
            
        }
        return nil
    }
    
    func reloadTableData(){
        
        let request : URLRequest =
            URLRequest(url: URL(string: messagesUrl)!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            if error != nil {
                print("Had an error")
                print(error)
            } else {
                
                if let data = data{
                    
                    
                    //let text  = String(data: data, encoding: String.Encoding.utf8)
                    
                    let dict = self.convertJsonDataToDictionary(data)
                    
                    print("Got Data \(dict)")
                    
                    self.tableData = dict
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    
                    
                    // process Data object
                    
                }else{
                    
                    // no data recieved, check response status flags
                    
                }
            }
        })
        task.resume()
        
        
    }


}

