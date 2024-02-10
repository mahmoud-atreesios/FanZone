//
//  NewsWebVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 09/02/2024.
//

import UIKit
import WebKit

class NewsWebVC: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = url {
            DispatchQueue.main.async {
                self.webView.load(URLRequest(url: url))
            }
        }
    }
    
}
