//
//  RingBuffer.swift
//  Bugreporter
//
//  Created by Leo Thomas on 18/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Foundation


class RingBuffer<T> {
    
    var elements: [T?]
    
    final private var writeIndex = 0
    var length: Int
    
    init(length: Int) {
        elements = [T?](repeating: nil, count: length)
        self.length = length
    }
    
    subscript(index: Int) -> T? {
        get {
            return elements[index]
        }
    }
    
    var count: Int {
        get {
            return writeIndex > length ? elements.count : writeIndex
        }
    }
    
    var isEmpty: Bool {
        get {
            return count == 0
        }
    }
    
    func append(element: T) {
        elements[writeIndex % length] = element
        writeIndex += 1
    }
    
}
