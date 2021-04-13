//
//  AsynchronousOperation.swift
//  Astronomy
//
//  Created by xander on 2021/4/11.
//

import Foundation

class AsynchronousOperation: Operation {
    
    // MARK: - Properties
    
    enum State: String {
        case ready
        case executing
        case finished
        
        fileprivate var keyPath: String {
            "is\(rawValue.capitalized)"
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    override var isAsynchronous: Bool { true }
    override var isReady: Bool { super.isReady && state == .ready }
    override var isExecuting: Bool { state == .executing }
    override var isFinished: Bool { state == .finished }
    
    // MARK: - Override
    
    override func start() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .ready
            main()
        }
    }
    
    override func main() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .executing
        }
    }
}
