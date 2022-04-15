//
//  ErrorTextField.swift
//  PixBay
//
//  Created by Pinpay Graphic on 15/10/2021.
//

import Foundation
import UIKit

public class ErrorTextField: UITextField, UITextFieldDelegate {
	// MARK: Lifecycle

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	public override func awakeFromNib() {
		super.awakeFromNib()
		self.sharedInit()
	}

	func sharedInit()
	{
		setupLabel()
		delegate = self
	}

	// MARK: Internal

	lazy var errorLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .red
		label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
		return label
	}()

	func setupLabel() {
		addSubview(errorLabel)
		errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
		errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
		errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
		errorLabel.heightAnchor.constraint(equalToConstant: 11).isActive = true
		errorLabel.isHidden = true
		errorLabel.adjustsFontSizeToFitWidth = true
	}

	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
