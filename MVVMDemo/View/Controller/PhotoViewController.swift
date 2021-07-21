//
//  ViewController.swift
//  MVVMDemo
//
//  Created by Anju Malhotra on 7/14/21.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet var photoTableView: UITableView!
    var activityView = UIActivityIndicatorView(style: .large)
    var viewModel: PhotoViewModel? = PhotoViewModel(content: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel?.delegate = self
        viewModel?.getAlbums()
        title = viewModel?.title
    }

    func configureActivityIndicator(with view: UIView) {
        activityView.color = UIColor.brown
        activityView.center = view.center
        activityView.startAnimating()
    }
}

extension PhotoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(section) ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModel = viewModel?.getCellViewModel(for: indexPath) else {return UITableViewCell()}
        switch cellViewModel.type {
        case .photo:
            return getPhotoCell(cellViewModel: cellViewModel, indexPath: indexPath)  
        }
    }
    
    func getPhotoCell(cellViewModel: CellModelDisplayable?, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = photoTableView.dequeueReusableCell(withIdentifier: PhotoCell.defaultIdentifier, for: indexPath) as? PhotoCell, let cellViewModel = cellViewModel as? PhotoCellViewModel else {return UITableViewCell()}
        
        if cell.photo.image == nil {
            cellViewModel.getImage()            
            configureActivityIndicator(with: cell.photo)
            cell.photo.addSubview(activityView)
        }
        cellViewModel.updateImage = { image in
            DispatchQueue.main.async {
                self.hideLoadingIndicator()
                guard let image = image else { return }
                cell.photo.image = image
            }
        }
        cell.configureCell(cellViewModel: cellViewModel)
        return cell
    }
}

extension PhotoViewController: AlbumViewable {
    func showLoadingIndicator() {
        configureActivityIndicator(with: view)
        view.addSubview(activityView)
    }
    
    func hideLoadingIndicator() {
        activityView.stopAnimating()
    }
    
    func refreshUI() {
        photoTableView.reloadData()
    }
    
    func showAlert(_ error: NetworkError?) {
        var message = ""
        switch error {
        case .networkError:
            message = "Network Unavailable"
        case .decodingError:
            message = "System Error"
        case .none:
            message = "Unknown Error"
        }
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

