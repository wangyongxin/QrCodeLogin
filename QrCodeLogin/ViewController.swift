//
//  ViewController.swift
//  QrCodeLogin
//
//  Created by 王勇欣 on 2019/6/3.
//  Copyright © 2019 titan. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader

class ViewController: UIViewController , QRCodeReaderViewControllerDelegate{

    @IBOutlet weak var userId: UITextField!
    var url : String! = "http://www.baidu.com"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // Configure the view controller (optional)
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = false
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
            //自定义扫码界面
//            $0.readerView = QRCodeReaderContainer(displayable: QRCustomView())
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    @IBAction func test(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toWeb", sender: self)
    }
    @IBAction func scanAction(_ sender: AnyObject) {
        // Retrieve the QRCode content
        // By using the delegate pattern
        readerVC.delegate = self
        
        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            print(result)
//            let web = MyWebWiewController()
            self.url = result?.value
//            self.navigationController?.pushViewController(web, animated: true)
//            self.present(web, animated: true, completion: nil)
            self.performSegue(withIdentifier: "toWeb", sender: self)

        }
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        
        present(readerVC, animated: true, completion: nil)
    }
    
    // MARK: - QRCodeReaderViewController Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    //By pressing on the switch camera button
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        if let cameraName:String? = newCaptureDevice.device.localizedName {
            print("Switching capture to: \(cameraName)")
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toWeb" {
            let myWeb = segue.destination as! MyWebWiewController
            myWeb.webUrl = self.url
            myWeb.userId = self.userId.text
        }
        
    }
}

