//
//  ViewController.swift
//  PhotoSearchApp
//
//  Created by Anton Zyabkin on 17.02.2023.
//

import UIKit
protocol SearchViewControllerProtocol: UIViewController {}

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension SearchViewController: SearchViewControllerProtocol {
    
}
