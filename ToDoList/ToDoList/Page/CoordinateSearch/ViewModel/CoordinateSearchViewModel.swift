//
//  CoordinateSearchViewModel.swift
//  ToDoList
//
//  Created by WEI-TSUNG CHENG on 2023/4/16.
//

import Foundation
import CoreLocation

class CoordinateSearchViewModel {
    
    var selectLocation: CLLocationCoordinate2D? {
        didSet {
            
            guard let selectLocation = selectLocation else {
                return
            }
            selectCoordinateObervable.value =  "\(selectLocation.longitude), \(selectLocation.latitude)"
        }
    }
    
    var selectCoordinateObervable = Observable<String>(value: "")
}
