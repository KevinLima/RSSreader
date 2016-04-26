//
//  WebViewController.swift
//  RSSreader
//
//  Created by Kevin Lima on 22/04/16.
//  Copyright © 2016 Kevin Lima. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    static var link:String!

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if WebViewController.link != nil{
            let url = NSURL(string: WebViewController.link)
            let reqUrl = NSURLRequest(URL: url!)
            webView.loadRequest(reqUrl)
        }else{
            print("no link")
            let url = NSURL(string: "http://www.iculture.nl")
            let reqUrl = NSURLRequest(URL: url!)
            webView.loadRequest(reqUrl)
        }
        // Do any additional setup after loading the view.
    }
    class func setTheLink(string string:String){
        WebViewController.link = string
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
