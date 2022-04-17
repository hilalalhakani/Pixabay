//
//  APIError.swift
//  PixBayNetwork
//
//  Created by Pinpay Graphic on 15/10/2021.
//

import Foundation

public enum APIError: Error, Equatable {
	case notFound
	case networkProblem
	case badRequest
	case requestFailed
	case invalidData
	case unknown(HTTPURLResponse?)
	case wrongPasswordOrEmail

	public init(response: URLResponse?) {
		guard let response = response as? HTTPURLResponse else {
			self = .unknown(nil)
			return
		}

		switch response.statusCode {
		case 400:
			self = .badRequest
		case 404:
			self = .notFound
		case 403:
			self = .wrongPasswordOrEmail
		default:
			self = .unknown(response)
		}
	}
}

extension APIError: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case .notFound:
			return ErrorMessages.Default.NotFound
		case .networkProblem, .unknown:
			return ErrorMessages.Default.networkConnection
		case .requestFailed, .badRequest, .invalidData:
			return ErrorMessages.Default.RequestFailed
		case .wrongPasswordOrEmail:
			return ErrorMessages.Default.WrongPasswordOrEmail
		}
	}
}

// MARK: - Constants

public extension APIError {
	enum ErrorMessages {
		public enum Default {
			static let ServerError = NSLocalizedString("Server Error. Please, try again later.", comment: "")
			static let NotFound = NSLocalizedString("Bad request error.", comment: "")
			static let RequestFailed = NSLocalizedString("Resquest failed. Please, try again later.", comment: "")
			static let networkConnection = NSLocalizedString("Kindly check your internet connection.", comment: "")
			static let WrongPasswordOrEmail = NSLocalizedString("Incorrect Password or Username", comment: "")
		}
	}
}
