//
//  LoginRequest.swift
//  PixBayNetwork
//
//  Created by Pinpay Graphic on 16/10/2021.
//

import Foundation

public struct LoginRequest: Codable {
	public init(email: String, password: String) {
		self.email = email
		self.password = password
	}

	let email: String
	let password: String
}
