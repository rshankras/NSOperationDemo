//
//  ServiceManager.swift
//  NSOperationDemo
//
//  Created by Ravi Shankar on 02/04/16.
//  Copyright © 2016 Ravi Shankar. All rights reserved.
//

import Foundation

class ServiceManager {
    
    private var operationQueue = NSOperationQueue()
    
    private var parseOperation:ParseJSONOperation?
    
    func makeServiceCall(searchText:String) {
        
        let reachabilityOperation = ReachabilityOperation(queue: operationQueue)
        
        let networkOperation = NetworkOperation(searchText: searchText, delegate:self)
        networkOperation.addDependency(reachabilityOperation)
        
        parseOperation = ParseJSONOperation(delegate:self)
        parseOperation?.addDependency(networkOperation)
        
        let operations:[Operation] = [reachabilityOperation, networkOperation,parseOperation!]

        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.addOperations(operations, waitUntilFinished: false)
    }
}

extension ServiceManager: NetworkOperationDelegate {
    func didFinishWithResult(data: NSData?, response: NSURLResponse?, error: NSError?) {
        if let error = error {
            print(error.localizedDescription)
            operationQueue.cancelAllOperations()
        }
        
        if let data = data {
            parseOperation?.data = data
        }
    }
}

extension ServiceManager: ParseJSONOperationDelegate {
    func didFinishWithResult(photos: NSArray) {
        print(photos)
    }
}