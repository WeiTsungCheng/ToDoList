//
//  ToDoItem.swift
//  ToDoList
//
//  Created by WEI-TSUNG CHENG on 2023/4/15.
//

import Foundation
import RealmSwift

class ToDoItem: Object, Codable {
    
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var createDate: Date
    @Persisted var dueDate: Date
    @Persisted var coordinate: Coordinate
    @Persisted var id: String
    
    convenience init(title: String, content: String, createDate: Date, dueDate: Date) {
        self.init()
        self.title = title
        self.content = content
        self.createDate = createDate
        self.dueDate = dueDate
    }
    
    init(title: String, content: String, createDate: Date, dueDate: Date, coordinate: Coordinate) {
        self.title = title
        self.content = content
        self.createDate = createDate
        self.dueDate = dueDate
        self.coordinate = coordinate
        self.id = UUID().uuidString
    }
    
}

class Coordinate: EmbeddedObject, Codable {
    
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

}
