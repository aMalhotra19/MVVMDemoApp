//
//  UIView+Reusable.swift
//  MVVMDemo
//
//  Created by Anju Malhotra on 7/15/21.
//

import Foundation
import UIKit

protocol Reusable: AnyObject {
    static var defaultIdentifier: String { get }
}

extension Reusable where Self :UITableViewCell {
    static var defaultIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {}
