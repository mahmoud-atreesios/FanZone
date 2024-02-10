//
//  VideoWebViewVC.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 09/02/2024.
//

import UIKit
import WebKit

class VideoWebViewVC: UIViewController {

    @IBOutlet weak var videoWebView: WKWebView!
    var url: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let url = url {
            DispatchQueue.main.async {
                self.videoWebView.load(URLRequest(url: url))
            }
        }

    }

}
