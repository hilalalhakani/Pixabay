//
//  RegistrationViewController.swift
//  PixBay
//
//  Created by Pinpay Graphic on 16/10/2021.
//

import RxSwift
import UIKit
import RxCocoa
import SharedUI

public class RegistrationViewController: UIViewController, Storyboarded {
	//MARK: Outlets
	@IBOutlet public var emailTextField: EmailTextField!
	@IBOutlet public var passTextField: PasswordTextField!
	@IBOutlet public var ageTextField: AgeTextField!
	@IBOutlet public var signUpButton: UIButton!
	@IBOutlet public var scrollView: UIScrollView!

	var viewModel: RegistrationViewModel
	let disposeBag = DisposeBag()

	//MARK: Initialization
	public init?(coder: NSCoder, viewModel: RegistrationViewModel) {
		self.viewModel = viewModel
		super.init(coder: coder)
	}

	required init?(coder _: NSCoder) {
		fatalError("Use `init(coder:registrationViewModel:)` to initialize a `RegistrationViewController` instance.")
	}

	override public func viewDidLoad() {
		super.viewDidLoad()
		setupBinding()
	}

	private func setupBinding() {
		emailTextField.rx.text.orEmpty
			.bind(to: viewModel.input.email)
			.disposed(by: disposeBag)

		passTextField.rx.text.orEmpty
			.bind(to: viewModel.input.password)
			.disposed(by: disposeBag)

		ageTextField.rx.text.orEmpty
			.bind(to: viewModel.input.age)
			.disposed(by: disposeBag)

		signUpButton.rx.tap
			.bind(to: viewModel.input.registerButtonPressed)
			.disposed(by: disposeBag)

		Observable.combineLatest(emailTextField.isValid, passTextField.isValid, ageTextField.isValid)
			.map { $0.0 && $0.1 && $0.2 }
			.asDriver(onErrorDriveWith: .empty())
			.drive(signUpButton.rx.isEnabled)
			.disposed(by: disposeBag)

		viewModel.output.isLoading
			.drive(rx.shouldLoadSVProgressHUD)
			.disposed(by: disposeBag)

		viewModel.output.error
			.drive(rx.shouldPresentError)
			.disposed(by: disposeBag)

		Keyboard.height()
			.drive(scrollView.rx.bindToScrollViewEdgeInsets)
			.disposed(by: disposeBag)
	}
}

public extension Reactive where Base: RegistrationViewController {
	var navigateToHome: Driver<Void> {
		base.viewModel.output.navigateToHome
	}
}
