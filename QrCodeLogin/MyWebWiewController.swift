//
//  MyWebWiewController.swift
//  QrCodeLogin
//
//  Created by 王勇欣 on 2019/6/3.
//  Copyright © 2019 titan. All rights reserved.
//

import UIKit
import WebKit
import WebViewJavascriptBridge
import Alamofire


class MyWebWiewController: UIViewController , WKWebViewDelegate{

    
    
    @IBOutlet weak var webView: WebView!
    
    
    var progressView: UIProgressView!
    
    var webUrl:String!
    var userId:String!
    var bridgeRefs: NSMutableArray = []
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 配置webView样式
        var config = WkwebViewConfig()
        config.isShowScrollIndicator = false
        config.isProgressHidden = false
        
        webView.delegate = self
        
        print("webUrl: \(webUrl!)")
        // 加载普通URL
        webView.webConfig = config
        webView.webloadType(self, .URLString(url: webUrl))
        
        bridgeRefs = NSMutableArray.init()
        let bridge = self.bridgeForWebView(webView.getWebView())
        bridge.registerHandler("qr_login") { (data, responseCallback) in
            let d = data as! String
            print("auth_code= \(d)")
            if(self.userId == nil || self.userId == ""){
                self.userId = "49"
            }
            let secret_code = "{\"userId\":\(self.userId!), \"auth_code\":\"\(d)\"}"
            let encode1 = secret_code.toBase64()
            let encode2 = "\(encode1!)ttplus".toBase64()
            print("encode2: \(encode2!)")
            var this_params: [String: Any] = ["secret_code": "\(encode2!)"]
            Alamofire.request("http://wwwdev.ttplus.cn/login/confirm", method: .post, parameters: this_params).responseJSON { response in
//                print("Request: \(String(describing: response.request))")   // original url request
//                print("Response: \(String(describing: response.response))") // http url response
//                print("Result: \(response.result)")                         // response serialization result
                
                if let json:Dictionary<String, Any> = response.result.value as! Dictionary<String, Any> {
                    print("JSON: \(json)") // serialized json response
                    if json["code"] as! Int == 200 {
                        let alertController = UIAlertController(title: "登陆成功提示",
                                                                message: "已成功登陆", preferredStyle: .alert)
//                        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                            action in
                            print("点击了确定")

                            self.navigationController?.popViewController(animated: true)
                        })

                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        let alertController = UIAlertController(title: "登陆失败提示",
                                                                message: "未成功登陆", preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                            action in
                            print("点击了确定")

                            self.navigationController?.popViewController(animated: true)
                        })
                        
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
//                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                    print("Data: \(utf8Text)") // original server data as UTF8 string
//                }
            }
            
        }
    }
    
    func bridgeForWebView(_ webView: Any) -> WebViewJavascriptBridge {
        let bridge = WebViewJavascriptBridge.init(webView)!
        bridgeRefs.add(bridge)
        return bridge
    }
    
    func webViewUserContentController(_ scriptMessageHandlerArray: [String], didReceive message: WKScriptMessage) {
        print(message.body)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("开始加载")
    }
}

//extension MyWebWiewController:WKWebViewDelegate{
//
//    func webViewUserContentController(_ scriptMessageHandlerArray: [String], didReceive message: WKScriptMessage) {
//        print(message.body)
//    }
//
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        print("开始加载")
//    }
//}
