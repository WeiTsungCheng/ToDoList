//
//  ToDoListViewModel.swift
//  DoToList
//
//  Created by WEI-TSUNG CHENG on 2023/4/13.
//

import Foundation
import DolphinHTTP

class ToDoListViewModel {
    
    var toDoItems: [ToDoItem] = [] {
        didSet {
            toDoItemsObservable.value = toDoItems
        }
    }
    var toDoItemsObservable = Observable<[ToDoItem]>(value: [])
    
    var quotableObservable = Observable<Quotable?>(value: nil)
    
    func getQuotes() {
        
        let api = QuotableListAPI()
        
        api.fetchQuotes { [weak self] result in
            
            DispatchQueue.main.async {
                
                switch result {
                case .success(let response):
                
                    if case .normal(let content) = response.type {
                        
                        if let content = content as? [Quotable], let quotable =  content.first {
                            
                            self?.quotableObservable.value = quotable
                            return
                            
                        } else {
                            self?.quotableObservable.value = nil
                            return
                        }
                    }
                    
                case .failure(let response):
                    
                    print(response)
                    return
                }
                
            }
            
        }
        
    }
    
    func loadToDoItems() {
    
        let toDoItems: [ToDoItem] = StorageManager.shared.loadObjectArray(for: .toDoItems) ?? []
        
        print("toDoItems: ", toDoItems)
        self.toDoItems = toDoItems
    }
    
    func deleteToDoItem(at indexPath: IndexPath) {
            
        let toDoItem = toDoItems[indexPath.row]
        
        toDoItems.remove(at: indexPath.row)
        
        var oldToDoItems: [ToDoItem] = StorageManager.shared.loadObjectArray(for: .toDoItems) ?? []
       
        oldToDoItems = oldToDoItems.filter { item in
            return item.id != toDoItem.id
         }
        
        StorageManager.shared.saveObjectArray(for: .toDoItems, value: oldToDoItems)
    }
    
}
