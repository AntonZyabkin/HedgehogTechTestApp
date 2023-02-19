//
//  FullScreenPhotoViewController.swift
//  PhotoSearchApp
//
//  Created by Anton Zyabkin on 18.02.2023.
//

import UIKit
protocol FullScreenPhotoViewControllerProtocol: UIViewController {
    var imageView: UIImageView? { get set }
    var activityIndicatorView: UIActivityIndicatorView! { get set }
}

class FullScreenPhotoViewController: UIViewController {
    
    var presenter: FullScreenPhotoViewPresenterProtocol?
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.startAnimating()
        view.backgroundColor = .black
        presenter?.setupImage()
    }
    @IBAction func back(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true)
    }
    @IBAction func previousButtonDidTap(_ sender: UIButton) {
        imageView?.image = nil
        activityIndicatorView.startAnimating()
        presenter?.previousButtonDidTap()
    }
    @IBAction func siteButtonDidTap(_ sender: Any) {
        guard
            let webPageViewController = storyboard?.instantiateViewController(withIdentifier: "web") as? WebPageViewController,
            let presenter = presenter
        else { return }
        presenter.siteButtonDidTap(viewController: webPageViewController)
        present(webPageViewController, animated: true)
    }
    @IBAction func nextButtonDidTap(_ sender: UIButton) {
        imageView?.image = nil
        activityIndicatorView.startAnimating()
        presenter?.nextButtonDidTap()
    }
}

extension FullScreenPhotoViewController: FullScreenPhotoViewControllerProtocol {}
