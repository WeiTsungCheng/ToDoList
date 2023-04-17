//
//  EditItemViewModel.swift
//  ToDoList
//
//  Created by WEI-TSUNG CHENG on 2023/4/15.
//

import Foundation

class EditItemViewModel {
    
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
    
    func saveToDoItem(completion: @escaping(() -> Void)) {
        
        // isEditing 為 true 更新 ToDoItem
        // isEditing 為 false 新增 ToDoItem
        if (isEditing) {
            
            let toDoItem = editingItem
            
            var toDoItems: [ToDoItem] = StorageManager.shared.loadObjectArray(for: .toDoItems) ?? []
            
            toDoItems = toDoItems.map { item in
                
                if (item.id == toDoItem.id) {
                    return toDoItem
                    
                } else {
                    return item
                }
            }
            
            StorageManager.shared.saveObjectArray(for: .toDoItems, value: toDoItems)
            
        } else {
            
            let toDoItem = editingItem
            
            var toDoItems: [ToDoItem] = StorageManager.shared.loadObjectArray(for: .toDoItems) ?? []
            
            toDoItems.append(toDoItem)
            
            StorageManager.shared.saveObjectArray(for: .toDoItems, value: toDoItems)
            
        }
        
        completion()
        
    }
    
    
}
