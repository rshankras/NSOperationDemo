//
//  Operation.swift
//  NSOperationDemo
//
//  Created by Ravi Shankar on 01/04/16.
//  Copyright © 2016 Ravi Shankar. All rights reserved.
//

import Foundation


class Operation: NSOperation {
    
    // You have to manage the state
    enum State: String {
        case Ready, Executing, Finished
        
        private var keyPath: String {
            return "is" + rawValue
        }
    }
    
    var state = State.Ready {
        willSet {
            willChangeValueForKey(newValue.keyPath)
            willChangeValueForKey(state.keyPath)
        }
        didSet {
            didChangeValueForKey(oldValue.keyPath)
            didChangeValueForKey(state.keyPath)
        }
    }
}

extension Operation {
    override var ready: Bool {
        return super.ready && state == .Ready
    }
    
    override var executing: Bool {
        return state == .Executing
    }
    
    override var finished: Bool {
        return state == .Finished
    }
    
    override var asynchronous: Bool {
        return true
    }
    
    override func start() {
        if cancelled {
            state = .Finished
            return
        }
        
        main()
        state = .Executing
    }
    
    override func cancel() {
        state = .Finished
    }
}