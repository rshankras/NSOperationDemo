//
//  CheckConnectivityOperation.swift
//  NSOperationDemo
//
//  Created by Ravi Shankar on 01/04/16.
//  Copyright © 2016 Ravi Shankar. All rights reserved.
//

import SystemConfiguration
import Foundation

protocol  ReachabilityOperationDelegate: class {
    func didFinishChecking(flag: Bool)
}

class ReachabilityOperation: Operation {
    
    var queue: NSOperationQueue?
    
    init(queue: NSOperationQueue) {
        self.queue = queue
    }
    
    override func main() {
        checkConnectivity()
    }
    
    func checkConnectivity() {
        if isConnectedToNetwork() {
            print("Connected")
        } else {
            queue?.cancelAllOperations()
        }
        state = .Finished
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}