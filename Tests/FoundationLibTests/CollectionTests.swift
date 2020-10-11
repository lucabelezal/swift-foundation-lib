//
//  CollectionTests.swift
//  
//
//  Created by lonnie on 2020/9/19.
//
import XCTest
import Compression
@testable import FoundationLib
final class CollectionTests: XCTestCase {
    
    func testNode() {
        var node = Node<Int>(100)
        for i in 0..<100 {
            node = Node(i, node)
        }
    }
   
    func testStack() throws {
        let stack = Stack<Int>()
        stack.push {
            3
            4
            5
        }
        try stack.peek().assert.equal(5)
        try stack.pop().assert.equal(5)
        try stack.peek().assert.equal(4)
        try stack.pop().assert.equal(4)
        try stack.peek().assert.equal(3)
        try stack.pop().assert.equal(3)
        do {
            let stack = Stack<Int>()
            try stack.pop()
            XCTFail()
        } catch {
            
        }
        
    }

    func testStackPerformance() throws {
        let stack = Stack<Int>()
        try DebugLogger.default.measure(desc: "Append item in stack") {
            self.try {
                for i in 0..<1.million {
                    stack.push(i)
                }
            }
        }
        try DebugLogger.default.measure(desc: "Iterate item in stack") {
            self.try {
                for _ in stack {
                    
                }
            }
        }
        
        try DebugLogger.default.measure(desc: "Remove item in stack") {
            self.try {
                while !stack.isEmpty {
                    try stack.pop()
                }
            }
        }
    }
    
    func testQueue() throws {
        let queue = Queue<Int>()
        for i in 0..<1000 {
            queue.enqueue(i)
        }
        var value = 0
        while !queue.isEmpty {
            try value.assert.equal(queue.dequeue())
            value += 1
        }
        queue.enqueue {
            1
            2
            3
            4
            5
        }
        Array(queue).assert.equal([1, 2, 3, 4, 5])
    }
    
    func testQueuePerformance() throws {
        let queue = Queue<Int>()
        try DebugLogger.default.measure(desc: "Append item in queue") {
            self.try {
                for i in 0..<1.million {
                    queue.enqueue(i)
                }
            }
        }
        try DebugLogger.default.measure(desc: "Iterate queue") {
            self.try {
                for _ in queue {
                    
                }
            }
        }
        try DebugLogger.default.measure(desc: "Remove item in queue") {
            self.try {
                while !queue.isEmpty {
                    try queue.dequeue()
                }
            }
        }
    }
    
    func testArrayPerformance() throws {
        var array = Array<Int>()
        try DebugLogger.default.measure(desc: "Append item in array") {
            for i in 0..<1.million {
                array.append(i)
            }
        }
        try DebugLogger.default.measure(desc: "Iterate item in array") {
            for _ in array {
                
            }
        }
        try DebugLogger.default.measure(desc: "Remove item in array") {
            while !array.isEmpty {
                _ = array.popLast()
            }
        }
    }
    
    func testBag() throws {
        let bag = Bag<Int>()
        try DebugLogger.default.measure(desc: "Append item in bag") {
            for i in 0..<1.million {
                bag.add(i)
            }
        }
        try DebugLogger.default.measure(desc: "Iterate item in bag") {
            for _ in bag {
                
            }
        }
    }
    
    func testPriorityQueue() throws {
        let queue = PriorityQueue<Int>(comparator: <)
        for i in 0..<100 {
            queue.insert(i)
        }
        var items = [Int]()
        while let top = queue.deleteTop() {
            items.append(top)
        }
        items.assert.equal(Array(0..<100).reversed())
        let queue2 = PriorityQueue<Int>(comparator: >)
        for i in 0..<100 {
            queue2.insert(i)
        }
        items = [Int]()
        while let top = queue2.deleteTop() {
            items.append(top)
        }
        items.assert.equal(Array(0..<100))
        
    }
    
    func testAppendAndRemoveRandomQueue() throws {
        try testAppendAndRemovePriorityQueue(comparator: <, isRandom: true)
        try testAppendAndRemovePriorityQueue(comparator: <, isRandom: false)
        try testAppendAndRemovePriorityQueue(comparator: >, isRandom: true)
        try testAppendAndRemovePriorityQueue(comparator: >, isRandom: false)
    }
    
    func testAppendAndRemovePriorityQueue(comparator: @escaping PriorityQueue<Int>.Comparator, isRandom: Bool) throws {
        let queue = PriorityQueue<Int>(comparator: comparator)
        var items = (1...1.million).map { $0 }
        if isRandom {
            items.shuffle()
        }
        try DebugLogger.default.measure(desc: "Append 1 million\(isRandom ? " Random" : "") elements in Priority Queue") {
            self.try {
                for i in items {
                    queue.insert(i)
                }
            }
        }
        
        try DebugLogger.default.measure(desc: "Remove 1 million\(isRandom ? " Random" : "") elements in Priority Queue") {
            self.try {
                while queue.deleteTop() != nil {
                    
                }
            }
        }
    }
    
    func topKFrequent(words: [String], _ k: Int) -> [String] {
        var dic = [String: Int]()
        for item in words {
            if let value = dic[item] {
                dic[item] = value + 1
            } else {
                dic[item] = 1
            }
        }
        let queue = FixedSizePriorityQueue<(String, Int)>(capacity: dic.count, comparator: { $0.1 < $1.1 || ($0.1 == $1.1 && $0.0 > $1.0) })
        for item in dic.enumerated() {
            queue.insert(item.offset, item.element)
        }
        var result = [String]()
        while result.count < k && queue.count > 0 {
            result.append(queue.deleteTop()!.0)
        }
        return result
    }
    
    func topKFrequent(nums: [Int], _ k: Int) -> [Int] {
        var dic = [Int: Int]()
        for item in nums {
            if let value = dic[item] {
                dic[item] = value + 1
            } else {
                dic[item] = 1
            }
        }
        let queue = FixedSizePriorityQueue<(Int, Int)>(capacity: dic.count, comparator: { $0.1 < $1.1 })
        for item in dic.enumerated() {
            queue.insert(item.offset, item.element)
        }
        var result = [Int]()
        while result.count < k && queue.count > 0 {
            result.append(queue.deleteTop()!.0)
        }
        return result
    }
    
    func testFixSizedPriorityQueue() throws {
        var nums = [Int]()
        for i in 1...1000 {
            for _ in 0..<i {
                nums.append(i)
            }
        }
        nums.shuffle()
        try DebugLogger.default.measure(desc: "Append elements in Fixed Size Priority Queue") {
            topKFrequent(nums: nums, 100).assert.equal((901...1000).map { $0 }.reversed())
        }
        var words = [String]()
        for i in 1...1000 {
            for _ in 0..<i {
                words.append(i.description)
            }
        }
        words.shuffle()
        try DebugLogger.default.measure(desc: "Append elements in Fixed Size Priority Queue") {
            topKFrequent(words: words, 100).assert.equal((901...1000).map { $0.description }.reversed())
        }
    }
    
}

extension CollectionTests {
    static var allTests = [
        ("testStack", testStack),
    ]
}
