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
    
    func getQuotes(completion: @escaping((Result<SuccessResponse, FailureResponse>) -> Void)) {
        
        let api = QuotableListAPI()
        
        api.fetchQuotes { result in
            
            DispatchQueue.main.async {
                
                switch result {
                case .success(let response):
                
                    if case .normal(let content) = response.type {
                        
                        if let content = content as? QuotableResources {
                            
                            // Convert [Quotable] to [ToDoItem]
                            let toDoItems = content.quotables.map { quotable in
                                
                                
                                let date = quotable.dateAdded
                                let calendar = Calendar.current
                                let nextDay = calendar.date(byAdding: .day, value: 1, to: date) ?? Date()
                                
                                // 當前地點作為預設座標
                                
                                let coordinate = Coordinate(latitude: self.locationManager.currentLocation!.coordinate.latitude, longitude: self.locationManager.currentLocation!.coordinate.longitude)
                            
                                return ToDoItem(title: quotable.author, description: quotable.content, createDate: quotable.dateAdded, dueDate: nextDay, coordinate: coordinate)
                            }
                            
                            self.toDoItems = toDoItems
                            
                            completion(.success(response))
                            return
                        }
                    }
                    
                    completion(.failure(FailureResponse(statusCode: nil, type: .incorrectResponse)))
                    
                case .failure(let response):
                    
                    completion(.failure(response))
                    return
                }
                
            }
            
        }
        
    }
    
}
