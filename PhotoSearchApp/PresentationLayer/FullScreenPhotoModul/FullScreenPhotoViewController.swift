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
}

extension FullScreenPhotoViewController: FullScreenPhotoViewControllerProtocol {

}
