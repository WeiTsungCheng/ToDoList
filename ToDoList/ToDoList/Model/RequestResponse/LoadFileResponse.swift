//
//  LocalResponse.swift
//  Shark-Contact
//
//  Created by WEI-TSUNG CHENG on 2022/9/18.
//

import Foundation
import DolphinHTTP

struct SuccessLoadFileResponse {
    
    enum SuccessType {
        case ok
        case normal(content: Codable)
    }

    let type: SuccessType
    
    let description: String?
    let detail: String?
    
    init(type: SuccessType, description: String? = nil, detail: String? = nil) {
        self.type = type
        self.description = description
        self.detail  = detail
    }
}

struct FailureLoadFileResponse: Error {
   
    enum ErrorType {
        case parsingFailed
        case missingParameter
        case other(Error)
    }

    let type: ErrorType
    
    let description: String?
    let detail: String?
    
    init(type: ErrorType, description: String? = nil, detail: String? = nil) {
        self.type = type
        self.description = description
        self.detail  = detail
    }
}
