//
//  RegistrationNetworkTests.swift
//  RegistrationNetworkTests
//
//  Created by Hilal Hakkani on 29/03/2022.
//

import XCTest
@testable import RegistrationNetwork
@testable import Registration

class RegistrationEndpointsTests: XCTestCase {
	func test_loginEndpoint() {
		let anyURL = URL(string: "http://anyURL.com")!
		let url = UserEndPoint.login.url(baseURL: anyURL)
		let expectedURL = anyURL.appendingPathComponent("Login")
		XCTAssertEqual(url, expectedURL)
	}

	func test_signupEndpoint() {
		let anyURL = URL(string: "http://anyURL.com")!
		let url = UserEndPoint.registration.url(baseURL: anyURL)
		let expectedURL = anyURL.appendingPathComponent("Registration")
		XCTAssertEqual(url, expectedURL)
	}
}
