//
//  EmailTextField.swift
//  PixBay
//
//  Created by Pinpay Graphic on 15/10/2021.
//

import Foundation
import RxCocoa
import RxSwift

public class PasswordTextField: ErrorTextField {
	let disposeBag = DisposeBag()

	public override func awakeFromNib() {
		super.awakeFromNib()
		errorLabel.text = errorMessage
		keyboardType = .default
		isSecureTextEntry = true
		self.isValid
			.bind(to: self.errorLabel.rx.isHidden)
			.disposed(by: self.disposeBag)
	}
}

extension PasswordTextField: TextFieldRule {
	var errorMessage: String {
		"the password must be between 6 and 12 characters long"
	}

	var isValid: Observable<Bool> {
		rx.text.orEmpty
			.skip(1)
			.map {
				let textCount = $0.count
				return (textCount >= 6 && textCount <= 12)
			}
	}
}
