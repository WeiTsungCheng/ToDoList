//
//  ToDoItem.swift
//  ToDoList
//
//  Created by WEI-TSUNG CHENG on 2023/4/15.
//

import Foundation

class ToDoItem: Codable {
    
    var title: String
    var content: String
    var createDate: Date
    var dueDate: Date
    var coordinate: Coordinate
    var id: String
    
    init(title: String, content: String, createDate: Date, dueDate: Date, coordinate: Coordinate, id: String = UUID().uuidString) {
        
        self.title = title
        self.content = content
        self.createDate = createDate
        self.dueDate = dueDate
        self.coordinate = coordinate
        self.id = id
    }
    
}

class Coordinate: Codable {
    
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

}
