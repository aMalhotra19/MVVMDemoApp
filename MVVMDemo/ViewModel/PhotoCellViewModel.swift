//
//  PhotoCellViewModel.swift
//  MVVMDemo
//
//  Created by Anju Malhotra on 7/14/21.
//

import Foundation
import UIKit


struct Content {
    let unavailable: String = "Content Unavailable"
}

class PhotoCellViewModel: CellModelDisplayable {
    var type: CellType = .photo
    var updateImage: ((UIImage?) -> Void)?
    var content: Album?
    
    var title: String {
        return content?.title ?? Content().unavailable
    }
    
    var imageURL: String? {
        return content?.thumbnailUrl ?? Content().unavailable
    }
    
    init(content: Album?) {
        self.content = content
        getImage()
    }
    
    var photo: UIImage?
}

extension PhotoCellViewModel {
    func getImage() {
        guard let urlString = content?.url, let url = URL(string: urlString) else {return}
        AlbumServiceManager.shared.getImage(url: url) { [weak self] result in
            guard let self = self else {return}
            if let result = result, let image1 = UIImage(data: result.imageData) {
                self.photo = image1
                self.updateImage?(image1)
            } else {
                self.updateImage?(nil)
            }
        }
    }
}
