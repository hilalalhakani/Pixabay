//
//  ViewController+Rx.swift
//  PixBay
//
//  Created by Pinpay Graphic on 15/10/2021.
//

import AJMessage
import Foundation
import RxCocoa
import RxSwift
import UIKit
import SVProgressHUD

public extension Reactive where Base: UIViewController {
	var shouldLoadSVProgressHUD: Binder<Bool> {
		return Binder(base, binding: { _, active in
			if let _ = NSClassFromString("XCTest") { return } // SVPROGressHUD immediately crashes when unit tests are runned
			DispatchQueue.main.async {
				active ? SVProgressHUD.show(withStatus: "Loading ...") : SVProgressHUD.dismiss()
			}
		})
	}

	var shouldPresentError: Binder<String> {
		return Binder(base, binding: { _, message in
			AJMessage.show(title: "Alert",
			               message: message,
			               duration: 2,
			               position: .top,
			               status: .error)
		})
	}
}
