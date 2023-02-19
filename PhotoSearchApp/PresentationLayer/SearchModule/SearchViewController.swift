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
    private lazy var activityIndicatorView = UIActivityIndicatorView()
    
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
        view.addSubview(activityIndicatorView)
        activityIndicatorView.frame = view.frame
        activityIndicatorView.hidesWhenStopped = true
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
            activityIndicatorView.stopAnimating()
        case .failure(let failure):
            showAlert(with: failure.localizedDescription)
            activityIndicatorView.stopAnimating()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        activityIndicatorView.startAnimating()
        guard let text = searchBar.text else { return }
        presenter?.startLoadData(request: text)
    }
}

//MARK: - extension UICollectionViewDataSource, UICollectionViewDelegate
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
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let fullScreenViewController = storyboard?.instantiateViewController(withIdentifier: "Full") as? FullScreenPhotoViewController,
            let presenter = presenter
        else { return }
        
        presenter.photoDidTaped(viewController: fullScreenViewController, indexPath)
        fullScreenViewController.imageView?.downloadImage(
            presenter.dataForCellBy(indexPath),
            activityIndicator: activityIndicatorView
        )
        fullScreenViewController.transitioningDelegate = self
        fullScreenViewController.modalPresentationStyle = .custom
        present(fullScreenViewController, animated: true)
    }
}



//MARK: - extension UIViewControllerTransitioningDelegate
extension SearchViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard
            let selectedIndexPathCell = photoCollectionView.indexPathsForSelectedItems?.first,
            let selectedCell = photoCollectionView.cellForItem(at: selectedIndexPathCell)
                as? PhotoCollectionViewCell,
            let selectedCellSuperview = selectedCell.superview,
            let size = selectedCell.imageView.image?.size
        else {
            print("size errore")
            return nil
        }
        let frame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
        transition.originFrame = frame
        let proroftions = view.frame.size.height / view.frame.size.width
        if size.height > size.width {
            transition.originFrame = CGRect(
                x: frame.minX,
                y: frame.midY - proroftions * frame.size.height / 2,
                width: frame.size.width,
                height: proroftions * frame.size.height
            )
        } else {
            transition.originFrame = CGRect(
                x: frame.midX - frame.size.width * size.width / size.height / 2,
                y: frame.midY - proroftions * frame.size.width * size.width / size.height / 2,
                width: frame.size.width * size.width / size.height,
                height: proroftions * frame.size.width * size.width / size.height
            )
        }
        transition.presenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}

