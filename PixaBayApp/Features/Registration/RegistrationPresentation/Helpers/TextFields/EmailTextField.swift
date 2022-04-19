//
//  EmailTextField.swift
//  PixBay
//
//  Created by Pinpay Graphic on 15/10/2021.
//

import Foundation
import RxCocoa
import RxSwift

public class EmailTextField: ErrorTextField {
	let disposeBag = DisposeBag()

	public override func awakeFromNib() {
		super.awakeFromNib()
		errorLabel.text = errorMessage
		keyboardType = .emailAddress
		self.isValid
			.bind(to: self.errorLabel.rx.isHidden)
			.disposed(by: self.disposeBag)
	}
}

extension EmailTextField: TextFieldRule {
	var errorMessage: String {
		"You must enter a valid Email"
	}

	var isValid: Observable<Bool> {
		rx.text.orEmpty
			.skip(1)
			.map {
				let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
				let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
				return predicate.evaluate(with: $0)
			}
	}
}
