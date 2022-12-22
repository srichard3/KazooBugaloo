//
//  WebViewController.swift
//  KBApp
//
//  Created by Sam Richard on 12/21/22.
//

import SwiftUI

extension WebViewController: WKNavigationDelegate {
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else {
            return
        }
        webView.isHidden = true
        
        print("Code: \(code)")
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
            }
        }
    }
    
}
