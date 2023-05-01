//
//  ToDoListViewModel.swift
//  DoToList
//
//  Created by WEI-TSUNG CHENG on 2023/4/13.
//

import Foundation
import DolphinHTTP
import RealmSwift

class ToDoListViewModel {
    
    let realm = try! Realm()
    
    var remindAddItemTextViewIsHiddenObservable = Observable<Bool>(value: true)
    
    var toDoItems: [ToDoItem] = [] {
        didSet {
            toDoItemsObservable.value = toDoItems
            remindAddItemTextViewIsHiddenObservable.value = toDoItems.count != 0
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
    
    func loadToDoItemRealms() {
        
        let todoItemRealms: Results<ToDoItemRealm> = realm.objects(ToDoItemRealm.self)
        
        var toDoItems: [ToDoItem] = todoItemRealms.map { todoItemRealm in
            
            return todoItemRealm.toDoItem()
        }
        
        toDoItems.sort(by: {$0.dueDate < $1.dueDate})
        self.toDoItems = toDoItems
    }
    
    func deleteToDoItemRealm(at indexPath: IndexPath) {
        
        let toDoItem = toDoItems[indexPath.row]
        toDoItems.remove(at: indexPath.row)
        
        guard let toDoItemRealm = realm.object(ofType: ToDoItemRealm.self, forPrimaryKey: toDoItem.id) else {
            
            return
        }
        
        try! realm.write {
            realm.delete(toDoItemRealm)
        }
        
    }
    
}


