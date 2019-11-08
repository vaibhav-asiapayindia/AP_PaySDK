//
//  HostViewController.swift
//  PaySDK
//
//  Created by AsiaPay Limited on 06/05/19.
//  Copyright © 2019 AsiaPay Limited. All rights reserved.
//


import UIKit
import WebKit

class HostViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    var bridgeDelegate: jBridgeWebViewDelegate?
    var req: NSMutableURLRequest?
    
    var bridge: WebViewJavascriptBridge?
    var activityView: UIActivityIndicatorView!
    var urlStr: String = ""
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(request: [String : Any], url: String) {
        self.init()
        var urlStr = ""
        for key in (request.keys) {
            urlStr = "\(urlStr)\(key)=\(request[key]!)&"
        }
        
        urlStr = String(urlStr.dropLast())
        urlStr = url + "?" + urlStr
        req = NSMutableURLRequest.init(url: URL.init(string: urlStr)!)
        req!.httpMethod = "POST"
        req!.httpBody = urlStr.data(using: .utf8)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (bridge != nil) {
            return
        }
        
        let webViewPage = WKWebView(frame: view.bounds, configuration: WKWebViewConfiguration())
        webViewPage.navigationDelegate =  self
        webViewPage.uiDelegate = self
        view.addSubview(webViewPage)
        
        WebViewJavascriptBridge.enableLogging()
        bridge = WebViewJavascriptBridge.init(forWebView: webViewPage)
        bridge!.setWebViewDelegate(self)
        self.activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.activityView.center = self.view.center
        self.activityView.startAnimating()
        self.view.addSubview(self.activityView)
        
        bridge!.registerHandler("tx_success", handler: { data, responseCallback in
            var json: String? = nil
            if let data = data {
                json = "\(data)"
            }
            self.bridgeDelegate!.jBridgeWebView_txSuccess(json: json!)
        })
        bridge!.registerHandler("tx_fail", handler: { data, responseCallback in
            var json: String? = nil
            if let data = data {
                json = "\(data)"
            }
            self.bridgeDelegate!.jBridgeWebView_txFail(json: json!)
        })
        bridge!.registerHandler("tx_error", handler: { data, responseCallback in
            var json: String? = nil
            if let data = data {
                json = "\(data)"
            }
            self.bridgeDelegate!.jBridgeWebView_txError(json: json!)
        })
        bridge!.registerHandler("tx_cancel", handler: { data, responseCallback in
            var json: String? = nil
            if let data = data {
                json = "\(data)"
            }
            self.bridgeDelegate!.jBridgeWebView_txCancel(json: json!)
        })
        bridge!.registerHandler("println", handler: { data, responseCallback in
            var json: String? = nil
            if let data = data {
                json = "\(data)"
            }
            self.bridgeDelegate!.jBridgeWebView_txPrint(json: json!)
        })
        //for ApplePay webview Click
        bridge!.registerHandler("setResult", handler: { data, responseCallback in
            var json: String? = nil
            if let data = data {
                json = "\(data)"
            }
            self.bridgeDelegate!.jBridgeWebView_setResult(json: json!)
        })
        bridge!.registerHandler("handleClick", handler: { data, responseCallback in
            self.bridgeDelegate!.jBridgeWebView_handleClick()
        })
        webViewPage.load(req! as URLRequest)
    }
    
    
    //WKWebView Delegate
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.activityView.startAnimating()
    }
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.activityView.startAnimating()
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        var appHtml = "var jbridge;function setupWebViewJavascriptBridge(e){if(window.WebViewJavascriptBridge)return e(WebViewJavascriptBridge);if(window.WVJBCallbacks)return window.WVJBCallbacks.push(e);window.WVJBCallbacks=[e];var i=document.createElement(\"iframe\");i.style.display=\"none\",i.src=\"https://__bridge_loaded__\",document.documentElement.appendChild(i),setTimeout(function(){document.documentElement.removeChild(i)},0)}function bridge_handler(e){jbridge=e,\"function\"==typeof bridge_methods&&bridge_methods(e)}setupWebViewJavascriptBridge(bridge_handler);"
        let bridge_methods = ["tx_success", "tx_fail", "tx_error", "tx_cancel", "println", "setResult", "handleClick"] //for ApplePay webview Click
        var inject_method = "\nfunction bridge_methods(jbridge){ \n"
        for i in bridge_methods {
            inject_method = "\(inject_method)jbridge.\(i) = function(data,callback){ jbridge.callHandler('\(i)',data,callback) } \n"
        }
        inject_method = inject_method + ("\n}")
        appHtml = appHtml + inject_method
        webView.evaluateJavaScript(appHtml)
        self.activityView.stopAnimating()
    }
    
    // alert
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            completionHandler()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // confirm
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in            
            completionHandler(true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // prompt
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController(title: nil, message: prompt, preferredStyle: .actionSheet)
        
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
            completionHandler(nil)
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

protocol jBridgeWebViewDelegate {
    func jBridgeWebView_txSuccess(json: String)
    func jBridgeWebView_txFail(json: String)
    func jBridgeWebView_txCancel(json: String)
    func jBridgeWebView_txError(json: String)
    func jBridgeWebView_txPrint(json: String)
    //for ApplePay webview Click
    func jBridgeWebView_setResult(json: String)
    func jBridgeWebView_handleClick()
}


