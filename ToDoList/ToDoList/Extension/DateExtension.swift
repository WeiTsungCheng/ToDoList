//
//  DateExtension.swift
//  ToDoList
//
//  Created by WEI-TSUNG CHENG on 2023/4/16.
//

import Foundation

extension Date {
    
    static func dateToString(date: Date) -> String  {
     
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy/MM/dd"
      dateFormatter.calendar = Calendar(identifier: .iso8601)
      dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
      dateFormatter.locale = Locale(identifier: "zh_TW")
        
        return dateFormatter.string(from: date)
    }
    
    
}
