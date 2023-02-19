//
//  WebPageViewController.swift
//  PhotoSearchApp
//
//  Created by Anton Zyabkin on 17.02.2023.
//

import Foundation
import UIKit
import WebKit

final class WebPageViewController: UIViewController {
    private lazy var webView = WKWebView()
    
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        openWebPage(from: urlString)
        webView.frame = view.bounds
    }
    
    func openWebPage(from url: String) {
        DispatchQueue.main.async {
            guard let url = URL(string: url) else { return }
            let request = URLRequest(url: url)
            self.webView.load(request)
        }
    }
}
