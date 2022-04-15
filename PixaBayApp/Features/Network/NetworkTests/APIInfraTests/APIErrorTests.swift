//
//  APIErrorTests.swift
//  PixBayNetworkTests
//
//  Created by Pinpay Graphic on 15/10/2021.
//

import Foundation
@testable import Network
import XCTest

class ApiErrorTests: XCTestCase {
	func test_ApiErrorWithNullResponse_DeliversUnkwon() {
		let sut = makeSUT(response: nil)
		XCTAssertEqual(sut.errorDescription, "Kindly check your internet connection.")
	}

	func test_ApiErrorDescription_DeliversCorrectMessage() {
		var sut = makeSUT(statusCode: 404)
		XCTAssertEqual(sut.errorDescription, "Bad request error.")

		sut = makeSUT(statusCode: 400)
		XCTAssertEqual(sut.errorDescription, "Resquest failed. Please, try again later.")

		sut = makeSUT(statusCode: 403)
		XCTAssertEqual(sut.errorDescription, "Incorrect Password or Username")

		let unknownStatusCode = 600
		sut = makeSUT(statusCode: unknownStatusCode)
		XCTAssertEqual(sut.errorDescription, "Kindly check your internet connection.")
	}

	func makeSUT(statusCode: Int) -> APIError {
		return APIError(response: HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil))
	}

	func makeSUT(response: HTTPURLResponse?) -> APIError {
		return APIError(response: response)
	}
}
