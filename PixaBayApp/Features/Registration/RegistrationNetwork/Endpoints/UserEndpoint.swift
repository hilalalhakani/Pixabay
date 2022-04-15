//
//  UserEndpoint.swift
//  PixabayNetwork
//
//  Created by Hilal Hakkani on 21/02/2022.
//

import Foundation
import RxSwift

enum UserEndPoint {
	case login
	case registration
}

extension UserEndPoint {
	public func url(baseURL: URL) -> URL {
		switch self {
		case .login:
			return baseURL.appendingPathComponent("Login")
		case .registration:
			return baseURL.appendingPathComponent("Registration")
		}
	}
}
