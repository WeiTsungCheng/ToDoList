//
//  QuotableListAPI.swift
//  ToDoList
//
//  Created by WEI-TSUNG CHENG on 2023/4/15.
//

import Foundation
import DolphinHTTP

final class QuotableListAPI {
    
    private let loader: HTTPLoader
    
    init(loader: HTTPLoader = URLSessionLoader(session: URLSession.shared)) {
        self.loader = loader
    }
    
    func fetchQuotes(completion: @escaping((Result<SuccessResponse, FailureResponse>) -> Void)) {
        
        let url = URL(string: "https://api.quotable.io")!
        var r = HTTPRequest(scheme: url.scheme ?? "https")
        r.host = url.host
        r.port = url.port
        r.path = "/quotes/random"
        r.method = .get
        
        loader.load(request: r) { result in
            
            switch result {
            case.failure(let error):
                
                completion(.failure(FailureResponse(statusCode: nil, type: .httpError(error))))
                
            case .success(let response):
                
                guard let data = response.body else {
                    completion(.failure(FailureResponse(statusCode: response.status.rawValue, type: .noResponseBody)))
                    return
                }
                
                switch response.status {
                case .success, .create:
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        let items = try decoder.decode([Quotable].self, from: data)
                        
                        let successResponse = SuccessResponse(statusCode: response.status.rawValue, type: .normal(content: items))
                        
                        completion(.success(successResponse))
                        
                    } catch {
                        
                        completion(.failure(FailureResponse(statusCode: response.status.rawValue, type: .parsingFailed)))
                    }
                    
                case .badRequest, .unauthorized, .forbidden, .notFound, .methodNotAllowed:
                    
                    completion(.failure(FailureResponse(statusCode: response.status.rawValue, type: .parsingFailed)))
                    
                    
                case .serverError:
                    
                    completion(.failure(FailureResponse(statusCode: response.status.rawValue, type: .statusCodeError)))
                    
                default:
                    
                    completion(.failure(FailureResponse(statusCode: response.status.rawValue, type: .statusCodeError)))
                }
                
            }
            
        }
        
    }
    
}
