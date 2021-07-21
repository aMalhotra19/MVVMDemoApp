//
//  AlbumServiceManager.swift
//  MVVMDemo
//
//  Created by Anju Malhotra on 7/14/21.
//

import Foundation

enum NetworkError: Error {
    case networkError
    case decodingError
}

protocol ContentManageble {
    var content: Album? { get set }
    var error: NetworkError? { get set }
}

class AlbumServiceManager: ContentManageble {
    
    var error: NetworkError?
    
    var content: Album?
        
//    func fetchAlbum(url: URL, completion: @escaping(Result<[Album], NetworkError>) -> ()) {
//        URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
//            guard let self = self else { return }
//            if error != nil {
//                return completion(.failure(.networkError))
//            } else if let data = data {
//                do {
//                    self.content = try JSONDecoder().decode([Album].self, from: data)
//                    DispatchQueue.main.async {
//                        completion(.success(self.content))
//                    }
//                } catch {
//                    return completion(.failure(.decodingError))
//                }
//            }
//        }.resume()
//    }
    
    lazy var serviceCoordinator: ServiceCoordinator = {
        return  ServiceCoordinator()
    }()
    
    func getAlbums<T>(url: URL, resource: Resource<T>) {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=4a8a2a0ddaf140678260ca5b7363c43a") else { return }
        //let resource = Resource<Album>(url: url)
        
        serviceCoordinator.fetchAlbums(resource: resource) { (result) in
            switch result {
            case .failure(let error):
                self.error = error
            case .success(let albums):
                if let albums = albums as? Album {
                    self.content = albums
                }
            }
        }
    }
}
