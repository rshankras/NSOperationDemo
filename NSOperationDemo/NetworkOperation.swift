//
//  NetworkOperation.swift
//  NSOperationDemo
//
//  Created by Ravi Shankar on 02/04/16.
//  Copyright © 2016 Ravi Shankar. All rights reserved.
//

import Foundation

protocol NetworkOperationDelegate: class  {
    func didFinishWithResult(data: NSData?, response: NSURLResponse?, error: NSError?)
}

class NetworkOperation: Operation {
    
    let API_KEY = "<FLICKR_API_KEY>"
    let URL = "https://api.flickr.com/services/rest/"
    let METHOD = "flickr.photos.search"
    let FORMAT_TYPE:String = "json"
    let JSON_CALLBACK:Int = 1
    let PRIVACY_FILTER:Int = 1
    let DATE_SORT = "date-taken-desc"
    
    var searchText: String
    private var delegate:NetworkOperationDelegate
    
    
    init(searchText:String, delegate: NetworkOperationDelegate) {
        self.searchText = searchText
        self.delegate = delegate
        super.init()
    }
    
    override func main() {
        searchPhotos()
    }
    
    func searchPhotos() {
        
        let urlString: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(API_KEY)&tags=\(searchText)&per_page=25&format=json&nojsoncallback=1"
        
        let url = NSURL(string: urlString)
        
        if let url = url {
            
            let request = NSURLRequest(URL: url)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                
                self.delegate.didFinishWithResult(data, response: response, error: error)
                self.state = .Finished
            })
            
            task.resume()
            
        } else {
            print("Check if you have enterred a valid Flickr API Key")
            self.state = .Finished
        }
    }
}
