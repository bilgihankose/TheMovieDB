//
//  IMDBSiteViewController.swift
//  TheMovieDB
//
//  Created by Bilgihan Köse on 1.10.2020.
//

import UIKit
import WebKit

class IMDBSiteViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webkit: WKWebView!
    
    var movieID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://www.imdb.com/title/\(movieID)")!
        webkit.load(URLRequest(url: url))
        webkit.allowsBackForwardNavigationGestures = true
    }
}
