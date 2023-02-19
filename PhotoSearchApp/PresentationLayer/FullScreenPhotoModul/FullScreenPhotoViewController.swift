//
//  FullScreenPhotoViewController.swift
//  PhotoSearchApp
//
//  Created by Anton Zyabkin on 18.02.2023.
//

import UIKit
protocol FullScreenPhotoViewControllerProtocol: UIViewController {
    var imageView: UIImageView? { get set }
}

class FullScreenPhotoViewController: UIViewController {
    
    var presenter: FullScreenPhotoViewPresenterProtocol?
    
    @IBOutlet weak var imageView: UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        presenter?.setupImage()
    }
    @IBAction func back(_ sender: UIButton) {
        print("go back")
        presentingViewController?.dismiss(animated: true)
    }
    @IBAction func previousButtonDidTap(_ sender: UIButton) {
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
        presenter?.nextButtonDidTap()
    }
}

extension FullScreenPhotoViewController: FullScreenPhotoViewControllerProtocol {

}
