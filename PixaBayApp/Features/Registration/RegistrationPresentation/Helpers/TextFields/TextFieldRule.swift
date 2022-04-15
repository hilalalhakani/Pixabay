//
//  TextFieldRule.swift
//  PixBay
//
//  Created by Pinpay Graphic on 15/10/2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol TextFieldRule {
	var errorMessage: String { get }
	var isValid: Observable<Bool> { get }
}
