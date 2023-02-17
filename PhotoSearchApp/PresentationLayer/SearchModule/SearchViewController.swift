//
//  ViewController.swift
//  PhotoSearchApp
//
//  Created by Anton Zyabkin on 17.02.2023.
//

import UIKit
protocol SearchViewControllerProtocol: UIViewController {}

class SearchViewController: UIViewController {
    var presenter: SearchViewPresenterProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.test()
    }
}

extension SearchViewController: SearchViewControllerProtocol {
    
}
