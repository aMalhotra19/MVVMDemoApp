//
//  AlbumServiceManager.swift
//  MVVMDemo
//
//  Created by Anju Malhotra on 7/14/21.
//

import Foundation
import UIKit

struct API {
    let url: URL = URL(string: "https://jsonplaceholder.typicode.com/photos")!
    // Random Images
    let imageUrl: URL = URL(string: "https://picsum.photos/200/300/?random")!
}

enum NetworkError: Error {
    case networkError
    case decodingError
}

protocol ContentManageble {
    var content: [Album]? { get set }
    var error: NetworkError? { get set }
}

class AlbumServiceManager: ContentManageble {
    
    var error: NetworkError?
    var content: [Album]?
    let baseURL: URL
    
    lazy var serviceCoordinator: ServiceCoordinator = {
        return  ServiceCoordinator()
    }()
    
    static var shared = AlbumServiceManager(baseUrl: API().url)
    
    private init(baseUrl: URL) {
        self.baseURL = baseUrl
    }
    
    /* This method will get data for album
     Success: Top 20 items will be saved in content
     Falure: error will be set in error object
     */
    func getAlbums(completion: @escaping () -> Void) {
        let resource = Resource<Album>(url: baseURL)
        
        serviceCoordinator.fetchData(resource: resource) { (result) in
            switch result {
            case .failure(let error):
                self.error = error
                completion()
            case .success((let albums, _)):
                self.content = albums?.filter({$0.id <= 20})
                completion()
            }
        }
    }
    
    /* This method will get data for image
     Success: Returns data for image
     Falure: Error sent
     */
    func getImage(url: URL, completion: @escaping (Image?) -> Void) {
        let resource = Resource<Image>(url: API().imageUrl)
        
        serviceCoordinator.fetchData(resource: resource) { (result) in
            switch result {
            case .failure:
                completion(nil)
            case .success((_, let data)):
                guard let data = data else {return}
                completion(Image(imageData: data))
            }
        }
    }
}
