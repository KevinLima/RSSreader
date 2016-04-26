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
        
        
        let url = "http://www.iculture.nl/feed/"
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
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d/m/yyyy hh:mm" //format style. Browse online to get a format that fits your needs.
        let dateString = dateFormatter.stringFromDate(tag.pubDate!)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let tag = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text!
        WebViewController.setTheLink(string: newsItems[indexPath.row].link!)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("goToNewsItem", sender: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // the second screen. I select the icon of View Controller and Attributes Inspector > Class and Storyboard ID is: DetallViewController
        //var secondScene = segue.destinationViewController as! WebViewController
        //let indexPath = sender as! NSIndexPath
        //let selected = newsItems[indexPath.row]
    }

}
