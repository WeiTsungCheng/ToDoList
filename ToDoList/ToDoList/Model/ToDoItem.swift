//
//  ToDoItem.swift
//  ToDoList
//
//  Created by WEI-TSUNG CHENG on 2023/4/15.
//

import Foundation

struct ToDoItem: Codable {
    
    var title: String
    var description: String
    var createDate: Date
    var dueDate: Date
    var coordinate: Coordinate
    let id: String
    
    init(title: String, description: String, createDate: Date, dueDate: Date, coordinate: Coordinate) {
        self.title = title
        self.description = description
        self.createDate = createDate
        self.dueDate = dueDate
        self.coordinate = coordinate
        self.id = UUID().uuidString
    }
    
}

struct Coordinate: Codable {
    
    let latitude: Double
    let longitude: Double

}
