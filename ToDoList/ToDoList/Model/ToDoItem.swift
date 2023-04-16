//
//  ToDoItem.swift
//  ToDoList
//
//  Created by WEI-TSUNG CHENG on 2023/4/15.
//

import Foundation

struct ToDoItem: Codable {
    
    let title: String
    let description: String
    let createDate: Date
    let dueDate: Date
    let coordinate: Coordinate
    
}

struct Coordinate: Codable {
    
    let latitude: Double
    let longitude: Double

}
