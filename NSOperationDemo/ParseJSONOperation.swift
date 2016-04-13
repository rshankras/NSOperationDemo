//
//  ParseJSONOperation.swift
//  NSOperationDemo
//
//  Created by Ravi Shankar on 02/04/16.
//  Copyright © 2016 Ravi Shankar. All rights reserved.
//

import Foundation

protocol ParseJSONOperationDelegate:class {
    func didFinishWithResult(photos: NSArray)
}

class ParseJSONOperation: Operation {
    
    var delegate:ParseJSONOperationDelegate
    
    var data: NSData?
    
    init(delegate: ParseJSONOperationDelegate) {
        self.delegate = delegate
    }
    
    override func main() {
        parseResult()
    }
    
    func parseResult() {
        do {
            if let data = data {
                let result = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                if let photoData = result["photos"] {
                    if let photos = photoData!["photo"] as? NSArray {
                        delegate.didFinishWithResult(photos)
                    }
                }
                state = .Finished
            }
            
        } catch (let error as NSError) {
            print(error.localizedDescription)
            state = .Finished
        }
    }
}
