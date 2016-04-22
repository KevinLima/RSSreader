//
//  ViewController.swift
//  RSSreader
//
//  Created by Kevin Lima on 21/04/16.
//  Copyright © 2016 Kevin Lima. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireRSSParser


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var newsItems : [RSSItem]!
    var hashedNewsItems = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url = "http://www.nu.nl/rss/Internet"
        Alamofire.request(.GET, url).responseRSS() { (response) -> Void in
            if let feed: RSSFeed = response.result.value {
                self.newsItems = feed.items
                for item in feed.items {
                    print(item)
                }
                self.tableView!.reloadData()
                self.tableView!.delegate = self
                self.tableView!.dataSource = self
                self.hashNewsItems()
            }
        }
        
        print("hello")
       
        
    }
    func hashNewsItems(){
        
        let backgroundQueue = NSOperationQueue()
        backgroundQueue.addOperationWithBlock(){
            func md5(string string: String) -> String {
                var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
                if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
                    CC_MD5(data.bytes, CC_LONG(data.length), &digest)
                }
                
                var digestHex = ""
                for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
                    digestHex += String(format: "%02x", digest[index])
                }
                
                return digestHex
            }
            
            for item in self.newsItems{
                //self.hashedNewsItems[item.title!] = md5(string: item.title!)
                self.hashedNewsItems.setObject(md5(string: item.title!), forKey: item.title!)
            }
            self.tableView!.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        let tag = newsItems[indexPath.row]
        cell.textLabel?.text = tag.title
        cell.detailTextLabel?.text = "Proccessing..."
        if hashedNewsItems.objectForKey(tag.title!) != nil{
            //cell.detailTextLabel?.text = hashedNewsItems[tag.title!]
            cell.detailTextLabel?.text = hashedNewsItems.objectForKey(tag.title!)as? String
        }else{
            cell.detailTextLabel?.text = "Loading..."
        }
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let tag = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text!
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //performSegueWithIdentifier("backToMain", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
