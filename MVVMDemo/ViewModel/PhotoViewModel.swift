//
//  PhotoViewModel.swift
//  MVVMDemo
//
//  Created by Anju Malhotra on 7/14/21.
//

import Foundation

protocol AlbumViewable {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func refreshUI()
    func showAlert(_ error: NetworkError?)
}

protocol CellModelDisplayable {
    var type: CellType { get set }
}

enum CellType: Int, CaseIterable {
    case photo
}

class PhotoViewModel {
    
    var content: [Album]?
    var serviceManager = AlbumServiceManager.shared
    var delegate: AlbumViewable?
    
    init(content: [Album]? = []) {
        self.content = content
    }
    
    var title: String {
        return "Album"
    }
    
    lazy var photoCellViewModel: [PhotoCellViewModel]? = {
       return getPhotoCellViewModel()
    }()
    
    func getPhotoCellViewModel() -> [PhotoCellViewModel]? {
        var cellViewModel: [PhotoCellViewModel]? = []
        guard let content = content else { return [] }
        for album in content {
            let viewModel = PhotoCellViewModel(content: album)
            cellViewModel?.append(viewModel)
        }
        return cellViewModel
    }
    
    func getAlbums() {
        delegate?.showLoadingIndicator()
        serviceManager.getAlbums {
            DispatchQueue.main.async {
                guard let count = self.serviceManager.content?.count, count > 0 else {
                    self.updateUI()
                    self.delegate?.showAlert(self.serviceManager.error)
                    return
                }
                self.content = self.serviceManager.content
                self.updateUI()
            }
        }
    }
    
    func updateUI() {
        self.delegate?.refreshUI()
        self.delegate?.hideLoadingIndicator()
    }
}

extension PhotoViewModel {
    func numberOfRows(_ section: Int) -> Int {
        let cellType = CellType.init(rawValue: section)
        switch cellType {
        case .photo:
            guard let count = content?.count else {return 0}
            return count
        case .none:
            return 0
        }
    }
    
    func numberOfSections() -> Int {
        return CellType.allCases.count
    }
    
    func getCellViewModel(for indexpath: IndexPath) -> CellModelDisplayable? {
        let cellType = CellType.init(rawValue: indexpath.section)
        switch cellType {
        case .photo:
            guard let count = photoCellViewModel?.count, indexpath.row < count else { return nil }
            return photoCellViewModel?[indexpath.row]
        case .none:
            return nil
        }
    }
    
}
