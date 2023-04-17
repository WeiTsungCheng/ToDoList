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
    
}
