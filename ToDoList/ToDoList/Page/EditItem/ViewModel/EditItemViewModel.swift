//
//  EditItemViewModel.swift
//  ToDoList
//
//  Created by WEI-TSUNG CHENG on 2023/4/15.
//

import Foundation
import RealmSwift

class EditItemViewModel {
    
    let realm = try! Realm()
    
    var isEditing: Bool
    
    var editingItem: ToDoItem {
        didSet {
            editingItemObservable.value = editingItem
        }
    }
    
    var editingItemObservable = Observable<ToDoItem?>(value: nil)
    
    init(isEditing: Bool = false, editingItem: ToDoItem) {
        self.isEditing = isEditing
        self.editingItem = editingItem
    }
    
    func saveToDoItemRealm(completion: @escaping(() -> Void)) {
        
        let toDoItem = editingItem
        let item = ToDoItemRealm(toDoItem: toDoItem)
        
        // isEditing 為 true 更新 ToDoItem
        // isEditing 為 false 新增 ToDoItem
        if (isEditing) {
            
            guard let toDoItemRealm = realm.object(ofType: ToDoItemRealm.self, forPrimaryKey: toDoItem.id) else {
                
                completion()
                return
            }
            
            try! realm.write({
                
                toDoItemRealm.title = item.title
                toDoItemRealm.content = item.content
                toDoItemRealm.createDate = item.createDate
                toDoItemRealm.dueDate = item.dueDate
                toDoItemRealm.coordinate = item.coordinate
                
            })
            
            
        } else {
            
            try! realm.write({
                realm.add(item)
            })
        }
        
        completion()
    
    }
    
    
}
