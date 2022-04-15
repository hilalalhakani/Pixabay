//
//  ScrollView+Rx.swift
//  PixBay
//
//  Created by Pinpay Graphic on 16/10/2021.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

public extension Reactive where Base: UIScrollView {
	var bindToScrollViewEdgeInsets: Binder<CGFloat> {
		return Binder(base, binding: { scrollView, keyboardHeight in
			scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
			scrollView.scrollIndicatorInsets = scrollView.contentInset
		})
	}
}
