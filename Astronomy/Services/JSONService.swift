//
//  JSONService.swift
//  Astronomy
//
//  Created by xander on 2021/4/12.
//

import Foundation

class JSONService {
    
    // MARK: - Singleton
    
    private init() {}
    static let shared = JSONService()
    
    // MARK: - Properties
    
    typealias JSONCompletion = ((_ object: [[String: AnyObject]]?) -> Void)?
    
    enum HTTPMethod: String {
        case get
        case post
        
        var value: String { "\(self)".uppercased() }
    }
    
    // MARK: - Methods
    
    func getJSONObject(method: HTTPMethod, url: URL, body: Data? = nil, timeout: Double = 10, completion: JSONCompletion = nil) {
        let completionInMainThread = { (obj: [[String: AnyObject]]?) in
            DispatchQueue.main.async { completion?(obj) }
        }
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeout)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completionInMainThread(nil)
                return
            }
            
            guard let data = data else {
                completionInMainThread(nil)
                return
            }
            
            do {
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                completionInMainThread(jsonObj as? [[String: AnyObject]])
            } catch {
                completionInMainThread(nil)
            }
        }
        task.resume()
    }
}
