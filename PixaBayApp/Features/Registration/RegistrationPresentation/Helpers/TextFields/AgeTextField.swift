//
//  AgeTextField.swift
//  PixBay
//
//  Created by Pinpay Graphic on 16/10/2021.
//

import Foundation
import RxCocoa
import RxSwift

public class AgeTextField: ErrorTextField {
	let disposeBag = DisposeBag()

	public override func awakeFromNib() {
		super.awakeFromNib()
		errorLabel.text = errorMessage
		keyboardType = .numberPad
	}
}

extension AgeTextField: TextFieldRule {
	var errorMessage: String {
		"Your age must be between 18 and 99"
	}

	var isValid: Observable<Bool> {
		rx.text.orEmpty
			.map {
				let age = Int($0) ?? 0
				return (age >= 18 && age <= 99)
			}
	}
}
