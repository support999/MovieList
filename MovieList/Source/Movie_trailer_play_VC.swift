//
//  Movie_trailer_play_VC.swift
//  MovieList
//
//  Created by Amit Saxena on 11/06/20.
//  Copyright © 2020 Amit Saxena. All rights reserved.
//

import UIKit
import WebKit

class Movie_trailer_play_VC: UIViewController {
    
    @IBOutlet var webView_for_play_trailer: WKWebView!
    
    var urlStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    func setupUI(){
        let url = URL(string:urlStr)!
        webView_for_play_trailer.load(URLRequest(url: url))
        webView_for_play_trailer.allowsBackForwardNavigationGestures = true
    }
    
    @IBAction func btnClick_close(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
}
