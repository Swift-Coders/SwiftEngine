//
//  CreateNewVC.swift
//  Messages2
//
//  Created by Spartak Buniatyan on 3/22/17.
//  Copyright © 2017 Spartak Buniatyan. All rights reserved.
//

import UIKit

class CreateNewVC: UIViewController {
    
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tvMessage: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postTouched(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        let formatedDate = dateFormatter.string(from: Date())
        
        createPost(name: tfName.text!, message: tvMessage.text, date: formatedDate)
        
    }

    @IBAction func cancelTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func createPost(name: String, message: String, date: String){
        
        print("Performing Post")
        
        let data = ["message":
            ["name":name as AnyObject,
             "message": message as AnyObject,
             "messageDate": date as AnyObject] as AnyObject
        ]
        
        let postData = convertDictionaryToJsonData(data)
        
        //print(convertDataToString(postData!))
        
        var request = URLRequest(url: URL(string: messagesUrl)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30.0)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.uploadTask(with: request as URLRequest,
                                      from: postData, completionHandler: {
                                        (data, response, error) -> Void in
                                        
                                        if let httpResponse = response as? HTTPURLResponse {
                                            if(httpResponse.statusCode == 201){
                                                self.dismiss(animated: true, completion: nil)
                                                return
                                            }
                                        }
                                        
                                        
                                        UIAlertAction(title: "Something Wrong!", style: UIAlertActionStyle.default, handler: nil)
                                        
                                        
                                        
        })
        task.resume()
        
        
        
    }
    
    func convertDictionaryToJsonData(_ inputDict : Dictionary<String, AnyObject>) -> Data?{
        
        do{
            return try JSONSerialization.data(withJSONObject: inputDict, options:JSONSerialization.WritingOptions.prettyPrinted)
            
        }catch let error as NSError{
            print(error)
            
        }
        
        return nil
    }


}
