//
//  Response.swift
//  Shark-Contact
//
//  Created by WEI-TSUNG CHENG on 2021/5/10.
//

import Foundation
import DolphinHTTP

struct SuccessResponse {
    
    enum SuccessType {
        case ok
        case normal(content: Codable)
    }

    let statusCode: Int? 
    let type: SuccessType
    
    let description: String?
    let detail: String?
    
    init(statusCode: Int?, type: SuccessType, description: String? = nil, detail: String? = nil) {
        self.statusCode = statusCode
        self.type = type
        self.description = description
        self.detail  = detail
    }
}

struct FailureResponse: Error {
   
    enum ErrorType {
        case httpError(HTTPError)
        case statusCodeError
        case noResponseBody
        case parsingFailed
        case incorrectResponse
        case missingParameter
        case other(Error)
    }

    let statusCode: Int?
    let type: ErrorType
    
    let description: String?
    let detail: String?
    
    init(statusCode: Int?, type: ErrorType, description: String? = nil, detail: String? = nil) {
        self.statusCode = statusCode
        self.type = type
        self.description = description
        self.detail  = detail
    }
}




