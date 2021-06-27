//
//  LinkedList.swift
//  Calculator
//
//  Created by Dasoll Park on 2021/06/28.
//

import Foundation

class Node<Element> {
    let value: Element
    var next: Node?
    
    init(value: Element, next: Node?) {
        self.value = value
        self.next = next
    }
}

class LinkedList {
    private var headNode: Node<String>?
    
    func insert(value: String) {
        if headNode == nil {
            headNode = Node(value: value, next: nil)
            return
        }
        var currentNode = headNode
        while currentNode?.next != nil {
            currentNode = currentNode?.next
        }
        currentNode?.next = Node(value: value, next: nil)
    }
    
    func displayListItems() {
        var currentNode = headNode
        while currentNode != nil {
            print(currentNode?.value ?? "")
            currentNode = currentNode?.next
        }
    }
    
    func delete(value: String) {
        if headNode?.value == value {
            headNode = headNode?.next
        }
        
        var previousNode: Node<String>?
        var currentNode = headNode
        
        while currentNode != nil && currentNode?.value != value {
            previousNode = currentNode
            currentNode = currentNode?.next
        }
        
        previousNode?.next = currentNode?.next
    }
}
