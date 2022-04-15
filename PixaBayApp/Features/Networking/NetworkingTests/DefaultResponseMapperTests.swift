//
//  PixBayNetworkTests.swift
//  PixBayNetworkTests
//
//  Created by Pinpay Graphic on 15/10/2021.
//

@testable import Networking
import XCTest

class DefaultResponseMapperTests: XCTestCase {
	func test_Mapper_deliversInvalidDataErrorOnNon200HTTPResponse() {
		let samples = [199, 201, 300, 400, 500]
		for code in samples {
			XCTAssertThrowsError(try DefaultResponseMapper.map(anyData(), from: anyHTTPURLResponse(code: code), decodedType: AnyDecodable.self))
		}
	}

	func test_Mapper_deliversResponseOn200HTTPResponse() {
		let decodedResponse = (try? DefaultResponseMapper.map(anyData(), from: anyHTTPURLResponse(code: 200), decodedType: AnyDecodable.self))
		XCTAssertNotNil(decodedResponse)
	}

	func test_Mapper_deliversErrorOnInvalidData() {
		let samples = [199, 201, 300, 400, 500, 200]
		let data = "anyData()".data(using: .utf8)!
		for code in samples {
			XCTAssertThrowsError(try DefaultResponseMapper.map(data, from: anyHTTPURLResponse(code: code), decodedType: AnyDecodable.self))
		}
	}
}
