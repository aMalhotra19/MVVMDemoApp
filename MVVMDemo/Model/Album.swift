//
//  Album.swift
//  MVVMDemo
//
//  Created by Anju Malhotra on 7/14/21.
//

import Foundation
import UIKit

struct Album: Codable {
    let albumId : Int
    let title : String
    let id : Int
    let thumbnailUrl : String
    let url :  String
}

struct Image: Codable {
    let imageData: Data
}
