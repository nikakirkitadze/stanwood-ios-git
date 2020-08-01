//
//  AsyncOperation.swift
//  NetworkingLayer
//
//  Created by Nika Kirkitadze on 9/27/19.
//  Copyright © 2019 Nika Kirkitadze. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
    enum State: String {
        case isReady, isExecuting, isFinished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    var state = State.isReady {
        willSet {
            willChangeValue(forKey: newValue.rawValue)
        }
        didSet {
            didChangeValue(forKey: state.rawValue)
        }
    }
    
    override var isExecuting: Bool {
        return state == .isExecuting
    }
    
    override var isFinished: Bool {
        return state == .isFinished
    }
    
    override func start() {
        guard !self.isCancelled else {
            state = .isFinished
            return
        }
        
        state = .isExecuting
        main()
    }
}
