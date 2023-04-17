//
//  ToDoListViewModel.swift
//  DoToList
//
//  Created by WEI-TSUNG CHENG on 2023/4/13.
//

import Foundation
import DolphinHTTP

class ToDoListViewModel {
    
    var toDoItems: [ToDoItem] = []
    let locationManager: LocationManager = LocationManager.shared
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
    
}
