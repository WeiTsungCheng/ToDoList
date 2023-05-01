//
//  RealmToDoItem.swift
//  ToDoList
//
//  Created by WEI-TSUNG CHENG on 2023/4/30.
//

import Foundation
import RealmSwift

class ToDoItemRealm: Object {
    
    @Persisted var title: String = ""
    @Persisted var content: String = ""
    @Persisted var createDate: Date = Date()
    @Persisted var dueDate: Date = Date()
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var coordinate: CoordinateRealm?
    
    convenience init(toDoItem: ToDoItem) {
        self.init()
        
        self.title = toDoItem.title
        self.content = toDoItem.content
        self.createDate = toDoItem.createDate
        self.dueDate = toDoItem.dueDate
        self.id = toDoItem.id
        self.coordinate = CoordinateRealm(coordinate: toDoItem.coordinate)
    }
    
    func toDoItem() -> ToDoItem {
        
        return ToDoItem(title: title, content: content, createDate: createDate, dueDate: dueDate, coordinate: coordinate?.toCoordinate() ?? Coordinate(latitude: 0, longitude: 0), id: id)
    }
}


class CoordinateRealm: EmbeddedObject {
    
    @Persisted var latitude: Double = 0.0
    @Persisted var longitude: Double = 0.0
    
    convenience init(coordinate: Coordinate) {
        self.init()
        
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    func toCoordinate() -> Coordinate {
        
        return Coordinate(latitude: self.latitude, longitude: self.longitude)
    }
}
