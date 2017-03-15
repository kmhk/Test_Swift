//
//  AppDelegate.swift
//  Testing
//
//  Created by Com on 19/02/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var detailWebView: UIWebView!
	
	var imageTitle: String?
	var imageSrcURL: String?
	var imageSrcLocalURL: String?
	

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.detailWebView.allowsInlineMediaPlayback = true
        self.detailWebView.scalesPageToFit = true;
        self.detailWebView.contentMode = .scaleAspectFit;
        self.detailWebView.delegate = self
        
        let vimeoVideoId = "7100569"
		
        if let templateHtmlContent = self.templateHtmlString() {
            var htmlContent = templateHtmlContent.replacingOccurrences(of: "__VimeoVideoId__", with: vimeoVideoId)
            htmlContent = htmlContent.replacingOccurrences(of: "__ImageTitle__", with: imageTitle!)
            htmlContent = htmlContent.replacingOccurrences(of: "__ImageSrcURL__", with: imageSrcURL!)
            htmlContent = htmlContent.replacingOccurrences(of: "__ImageSrcLocalURL__", with: imageSrcLocalURL!)
            let resourceURL = Bundle.main.resourceURL
            self.detailWebView.loadHTMLString(htmlContent, baseURL: resourceURL)
        } else {
            // Show Error
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func templateHtmlString() -> String? {
        if let htmlTemplateFilePath = Bundle.main.path(forResource: "imgeview", ofType: "html") {
            do {
                let fileContentString = try String(contentsOfFile: htmlTemplateFilePath)
                return fileContentString
            } catch {}
        }
        
        return nil
    }
}

extension DetailViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.openURL(request.url!)
            return false
        }
        
        return true
    }
}
