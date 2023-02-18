//
//  ViewController.swift
//  PhotoSearchApp
//
//  Created by Anton Zyabkin on 17.02.2023.
//

import UIKit
import Photos
protocol SearchViewControllerProtocol: UIViewController {
    func imagesDidLoaded(result: Result<SerpPhotoResponse, Error>)
}

class SearchViewController: UIViewController {
    
    private lazy var searchController = UISearchController()
    var presenter: SearchViewPresenterProtocol?
    let transition = PopAnimator()
    
    private lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (view.frame.width - 20) / 3
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            PhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier
        )
        return collectionView
    }()
    private lazy var messageAllert: UIAlertController = {
        let alert = UIAlertController(title: "Load error", message: "", preferredStyle:  .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(alertAction)
        return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        configViewsConstraints()
    }
    
    func prepare() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    private func configViewsConstraints() {
        view.addSubview(photoCollectionView)
        NSLayoutConstraint.activate([
            photoCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            photoCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func reloadData() {
        photoCollectionView.reloadData()
    }
    private func showAlert(with error: String) {
        messageAllert.message = error
        present(messageAllert, animated: true)
    }
}

extension SearchViewController: SearchViewControllerProtocol {
    func imagesDidLoaded(result: Result<SerpPhotoResponse, Error>) {
        switch result {
        case .success(_):
            reloadData()
        case .failure(let failure):
            showAlert(with: failure.localizedDescription)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text! + "SUCCESS")
        guard let test = searchBar.text else { return }
        presenter?.startLoadData(request: test)
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.numberOfCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = photoCollectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCollectionViewCell.identifier,
            for: indexPath) as? PhotoCollectionViewCell,
            let presenter = presenter
        else {
            return UICollectionViewCell()
        }
        cell.configureCell(url: presenter.dataForCellBy(indexPath))
//        var imege = UIImage()
//        if indexPath.row % 2 == 1 {
//            imege = UIImage(named: "Image")!
//        } else {
//            imege = UIImage(named: "Image 1")!
//        }
//        cell.imageView.image = imege
        print(presenter.dataForCellBy(indexPath))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let fullScreenViewController = storyboard?.instantiateViewController(withIdentifier: "Full") as? FullScreenPhotoViewController  else {
            return
        }
        var image = UIImage()
        if indexPath.row % 2 == 1 {
            image = UIImage(named: "Image")!
        } else {
            image = UIImage(named: "Image 1")!
        }
        presenter?.photoDidTaped(viewController: fullScreenViewController)
        fullScreenViewController.presenter?.image = image
        fullScreenViewController.transitioningDelegate = self
        fullScreenViewController.modalPresentationStyle = .custom
        present(fullScreenViewController, animated: true)
    }
}

extension SearchViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard
          let selectedIndexPathCell = photoCollectionView.indexPathsForSelectedItems?.first,
          let selectedCell = photoCollectionView.cellForItem(at: selectedIndexPathCell)
            as? PhotoCollectionViewCell,
          let selectedCellSuperview = selectedCell.superview
          else {
            return nil
        }

        transition.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
        transition.presenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
