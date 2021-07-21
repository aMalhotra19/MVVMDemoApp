//
//  ServiceCoordinator.swift
//  MVVMDemo
//
//  Created by Anju Malhotra on 7/14/21.
//

import Foundation

struct ServiceCoordinator {
    let serviceProvider = ServiceProvider()
    
    func fetchData<T>(resource: Resource<T>, completion: @escaping (Result<([T]?, Data?), NetworkError>) -> ()) {
        serviceProvider.fetchData(resource: resource) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success((let albums, let data)):
                completion(.success((albums, data)))
            }
        }
    }
}
