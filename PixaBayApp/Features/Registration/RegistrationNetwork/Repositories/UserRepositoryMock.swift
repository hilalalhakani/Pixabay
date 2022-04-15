//
//  UserRepositoryMock.swift
//  PixBayNetwork
//
//  Created by Pinpay Graphic on 16/10/2021.
//

import Foundation
import RxSwift

//MARK: the delay is only used for testing
public class UserRepositoryMock: UserRepository {
	public init() {}

	public func login(request: LoginRequest) -> Observable<LoginResponse> {
		let isRunningTest = NSClassFromString("XCTest") != nil
		let response: Observable<LoginResponse>
		if request.email == "test@mail.com", request.password == "123456" {
			response = .just(LoginResponse(isPasswordCorrect: true))
		} else {
			response = .just(LoginResponse(isPasswordCorrect: false))
		}

		if isRunningTest { return response } else {
			return response.delay(.seconds(1), scheduler: MainScheduler.instance)
		}
	}

	public func register(request: RegistrationRequest) -> Observable<RegistrationResponse> {
		let isRunningTest = NSClassFromString("XCTest") != nil
		let response: Observable<RegistrationResponse>
		if request.email == "test@mail.com" {
			response = .just(RegistrationResponse(error: "User already Exists"))
		} else {
			response = .just(RegistrationResponse(error: ""))
		}

		if isRunningTest { return response } else {
			return response.delay(.seconds(1), scheduler: MainScheduler.instance)
		}
	}
}
