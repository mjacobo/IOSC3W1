//
//  ViewController.swift
//  IOSW1
//
//  Created by Mauricio Jacobo Romero on 24/09/2016.
//  Copyright © 2016 MJ. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class ViewController: UIViewController {
    @IBOutlet weak var ISBNCode: SSNTextField!
    @IBOutlet weak var Results: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Results.isEditable = false
        ISBNCode.clearButtonMode = .whileEditing
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clearButton(_ sender: AnyObject) {
        Results.backgroundColor = UIColor.white
        Results.textColor = UIColor.black
        ISBNCode.text = ""
        Results.text = ""
    }

    @IBAction func searchISBN(_ sender: AnyObject) {
        print("Search ------>>>>")
        print("\(ISBNCode.text!)")
        self.view.endEditing(true)
        executeISBNSearch()
    }
    
    func executeISBNSearch(){
        if (isConnectedToNetwork() == true) {
        
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + "\(ISBNCode.text!)"
        let url   = NSURL(string: urls)
        let datos:NSData? = NSData(contentsOf: url! as URL)
        let texto = NSString(data:datos! as Data, encoding:String.Encoding.utf8.rawValue)
        Results.backgroundColor = UIColor.white
        Results.textColor = UIColor.black
        Results.text = texto as String!
        } else {
            Results.backgroundColor = UIColor.red
            Results.textColor = UIColor.white
            Results.text="Error: problemas con Internet."
        }
        
    }
    
    func isConnectedToNetwork()->Bool{
        
        var Status:Bool = false
        let url = NSURL(string: "https://openlibrary.org")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "HEAD"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: URLResponse?

        do {
            _ = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response) as NSData?
            } catch is Error{
              print("error")
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        
        return Status
    }
}

