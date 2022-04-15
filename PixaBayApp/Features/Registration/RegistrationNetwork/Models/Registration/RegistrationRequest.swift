//
//  RegistrationRequest.swift
//  PixBayNetwork
//
//  Created by Pinpay Graphic on 16/10/2021.
//

import Foundation

public struct RegistrationRequest: Codable {
	public init(email: String, password: String, age: String) {
		self.email = email
		self.password = password
		self.age = age
	}

	public let email: String
	public let password: String
	public let age: String
}
