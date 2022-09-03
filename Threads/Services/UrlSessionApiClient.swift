//
//  UrlSessionApiClient.swift
//  Threads
//
//  Created by Marcin Mierzejewski on 03/09/2022.
//

import Foundation

public class URLSessionApiClient : ApiClient {
    
    lazy var session:URLSession = {
        return URLSession(configuration:URLSessionConfiguration.default)
    }()
    
    public func httpRequest(_ request: ApiRequest, completion: (@escaping (Data?, Error?) -> Void)) {
        
        var urlString : String?
        var connectionBody : Data?
        let httpMethod = request.method()
        var connectionHeaders : ApiRequestHeaders?
        
        do {
            switch request {
            case .get(let url, let headers):
                urlString = url
                connectionHeaders = headers
                
            case .post(let url, let body, let headers):
                urlString = url
                connectionBody = try body.toData()
                connectionHeaders = headers
                
                
            case .delete(let url, let body, let headers):
                urlString = url
                connectionBody = try body.toData()
                connectionHeaders = headers
                
            }
        } catch {
            completion(nil, error)
        }
        
        if let urlFromString = URL(string: urlString ?? ""){

            var urlRequest = URLRequest(url: urlFromString)
            urlRequest.httpBody = connectionBody
            urlRequest.httpMethod = httpMethod
            urlRequest.allHTTPHeaderFields = connectionHeaders
            
            let dataTask = session.dataTask(with: urlRequest) { data, response, error in
                completion(data, error)
            }
            
            dataTask.resume()
        }
        
    }
    
}
