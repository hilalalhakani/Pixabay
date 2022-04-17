//
//  RegistrationViewModel.swift
//  PixBay
//
//  Created by Pinpay Graphic on 16/10/2021.
//

import Foundation
import Networking
import RxCocoa
import RxSwift
import RegistrationNetwork

public class RegistrationViewModel {
	struct Input {
		let email: AnyObserver<String>
		let password: AnyObserver<String>
		let age: AnyObserver<String>
		let registerButtonPressed: AnyObserver<Void>
	}

	struct Output {
		let isLoading: Driver<Bool>
		let error: Driver<String>
		let navigateToHome: Driver<Void>
	}

	let userRepository: UserRepository

	let input: Input
	var output: Output!

	public init(userRepository: UserRepository) {
		self.userRepository = userRepository

		let emailSubject = PublishSubject<String>()
		let ageSubject = PublishSubject<String>()
		let passwordSubject = PublishSubject<String>()
		let registerButtonPressedSubject = PublishSubject<Void>()

		input = Input(
			email: emailSubject.asObserver(),
			password: passwordSubject.asObserver(),
			age: ageSubject.asObserver(),
			registerButtonPressed: registerButtonPressedSubject.asObserver()
		)

		let credentials = Observable.combineLatest(emailSubject, passwordSubject, ageSubject)

		let apiRequest = registerButtonPressedSubject
			.withLatestFrom(credentials)
			.withUnretained(self)
			.flatMapLatest { component, credentials in
				component.userRepository
					.register(request: RegistrationRequest(email: credentials.0, password: credentials.1, age: credentials.2))
			}
			.share()

		let isLoading = Observable.merge(
			apiRequest.map { _ in false },
			registerButtonPressedSubject.map { _ in true }
		)

		let error = apiRequest
			.map { $0.error }
			.filter { !$0.isEmpty }

		let navigateToHome = apiRequest
			.map { $0.error }
			.filter { $0.isEmpty }
			.map { _ in () }

		output = Output(
			isLoading: isLoading.asDriver(onErrorDriveWith: .empty()),
			error: error.asDriver(onErrorDriveWith: .empty()),
			navigateToHome: navigateToHome.asDriver(onErrorDriveWith: .empty())
		)
	}
}
