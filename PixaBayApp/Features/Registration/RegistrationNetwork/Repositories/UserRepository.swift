//
//  UserRepository.swift
//  PixBayNetwork
//
//  Created by Pinpay Graphic on 16/10/2021.
//

import Foundation
import RxSwift
import Networking

public protocol UserRepository {
	func login(request: LoginRequest) -> Observable<LoginResponse>
	func register(request: RegistrationRequest) -> Observable<RegistrationResponse>
}

public class UserRepositoryImple: UserRepository {
	public init(httpClient: HTTPClient, hostURL: URL) {
		self.httpClient = httpClient
		self.hostURL = hostURL
	}

	public func login(request: LoginRequest) -> Observable<LoginResponse> {
		let hostURL = UserEndPoint.login.url(baseURL: self.hostURL)
		let request = URLRequest(url: hostURL)
		return httpClient.get(request)
			.map { try DefaultResponseMapper.map($1, from: $0, decodedType: LoginResponse.self) }
	}

	public func register(request: RegistrationRequest) -> Observable<RegistrationResponse> {
		let hostURL = UserEndPoint.registration.url(baseURL: self.hostURL)
		let request = URLRequest(url: hostURL)
		return httpClient.get(request)
			.map { try DefaultResponseMapper.map($1, from: $0, decodedType: RegistrationResponse.self) }
	}

	let httpClient: HTTPClient
	let hostURL: URL
}
