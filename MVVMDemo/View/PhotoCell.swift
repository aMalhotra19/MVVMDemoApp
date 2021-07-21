//
//  PhotoCell.swift
//  MVVMDemo
//
//  Created by Anju Malhotra on 7/14/21.
//

import Foundation
import UIKit

class PhotoCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var imageURL: UILabel!
    @IBOutlet var photo: UIImageView!

    func configureCell(cellViewModel: PhotoCellViewModel) {
        title.text = cellViewModel.title
        imageURL.text = cellViewModel.imageURL
        photo.image = cellViewModel.photo
    }
    
}
