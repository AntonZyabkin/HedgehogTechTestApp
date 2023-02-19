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
    var urlString = ""
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        openWebPage(from: urlString)
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    func openWebPage(from url: String) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
}
