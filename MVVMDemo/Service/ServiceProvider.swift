//
//  ServiceProvider.swift
//  MVVMDemo
//
//  Created by Anju Malhotra on 7/14/21.
//

import Foundation
import UIKit
struct Resource<T: Codable> {
    let url: URL
}

protocol Service {
    func fetchData<T>(resource: Resource<T>, completion: @escaping(Result<([T]?, Data?), NetworkError>) -> ())
}

class ServiceProvider: Service {
        
    /*
     Make api call for generic type
     When data is Image type, Data is returned
     When data is Album type, Album object is returned
     */
    func fetchData<T>(resource: Resource<T>, completion: @escaping(Result<([T]?, Data?), NetworkError>) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { (data, response, error) in
            if error != nil {
                return completion(.failure(.networkError))
            } else if T.self == Image.self, let data = data {
                return completion(.success((nil, data)))
            } else if let data = data {
                do {
                    let albums = try JSONDecoder().decode([T].self, from: data)
                    DispatchQueue.main.async {
                        completion(.success((albums, nil)))
                    }
                } catch {
                     completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}
