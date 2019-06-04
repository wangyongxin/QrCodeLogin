//
//  QRCustomView.swift
//  QrCodeLogin
//
//  Created by 王勇欣 on 2019/6/3.
//  Copyright © 2019 titan. All rights reserved.
//

import Foundation
import UIKit
import QRCodeReader

class QRCustomView: UIView, QRCodeReaderDisplayable {
    var overlayView: QRCodeReaderViewOverlay?
    
    func setNeedsUpdateOrientation() {
        
    }
    
    let cameraView: UIView            = UIView()
    let cancelButton: UIButton?       = UIButton()
    let switchCameraButton: UIButton? = SwitchCameraButton()
    let toggleTorchButton: UIButton?  = ToggleTorchButton()
    
    
    
    func setupComponents(with builder: QRCodeReaderViewControllerBuilder) {
        // addSubviews
        // setup constraints
        // etc.
    }
}

var reader: QRCodeReaderViewController = {
    let builder = QRCodeReaderViewControllerBuilder {
        let readerView = QRCodeReaderContainer(displayable: QRCustomView())
        
        $0.readerView = readerView
    }
    
    return QRCodeReaderViewController(builder: builder)
}()
