//
//  LoginViewModel.swift
//  Hawele Pro
//
//  Created by Hilal  Al Hakkani on 12/19/20.
//

import Foundation
import RxCocoa
import RxSwift
import RegistrationNetwork

public class LoginViewModel {
	public struct Input {
		public let email: AnyObserver<String>
		public let password: AnyObserver<String>
		public let loginButtonTap: AnyObserver<Void>
		public let registerButtonTap: AnyObserver<Void>
	}

	public struct Output {
		public let navigateToRegister: Driver<Void>
		public let navigateToHome: Driver<Void>
		public let isLoading: Driver<Bool>
		public let error: Driver<String>
	}

	let userRepository: UserRepository

	public let input: Input
	public var output: Output!

	let disposeBag = DisposeBag()

	public init(userRepository: UserRepository) {
		self.userRepository = userRepository

		let emailSubject = PublishSubject<String>()
		let passwordSubject = PublishSubject<String>()
		let loginButtonTapSubject = PublishSubject<Void>()
		let registerButtonTapSubject = PublishSubject<Void>()

		input = Input(
			email: emailSubject.asObserver(),
			password: passwordSubject.asObserver(),
			loginButtonTap: loginButtonTapSubject.asObserver(),
			registerButtonTap: registerButtonTapSubject.asObserver()
		)

		let credentials = Observable.combineLatest(emailSubject, passwordSubject)

		let apiRequest = loginButtonTapSubject
			.withLatestFrom(credentials)
			.withUnretained(self)
			.flatMapLatest { component, credentials in
				component.userRepository
					.login(request: LoginRequest(email: credentials.0, password: credentials.1))
			}
			.share()

		let isLoading = Observable.merge(
			loginButtonTapSubject.map { _ in true },
			apiRequest.map { _ in false }
		).debug("isLoading")

		let navigateToHome = apiRequest
			.filter { $0.isPasswordCorrect }
			.map { _ in () }

		let error = apiRequest
			.filter { !$0.isPasswordCorrect }
			.map { _ in "Incorrect credentials" }

		output = Output(
			navigateToRegister: registerButtonTapSubject.asDriver(onErrorDriveWith: .empty()),
			navigateToHome: navigateToHome.asDriver(onErrorDriveWith: .empty()),
			isLoading: isLoading.asDriver(onErrorDriveWith: .empty()),
			error: error.asDriver(onErrorDriveWith: .empty())
		)
	}
}
