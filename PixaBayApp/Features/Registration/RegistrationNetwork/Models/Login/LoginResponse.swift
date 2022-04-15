//
//  LoginResponse.swift
//  PixBayNetwork
//
//  Created by Pinpay Graphic on 16/10/2021.
//

import Foundation

public struct LoginResponse: Codable, Equatable {
	public var isPasswordCorrect: Bool
	public init(isPasswordCorrect: Bool) { self.isPasswordCorrect = isPasswordCorrect }
}
