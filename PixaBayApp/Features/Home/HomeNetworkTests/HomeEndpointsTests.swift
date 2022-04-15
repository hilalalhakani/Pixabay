//
//  HomeNetworkTests.swift
//  HomeNetworkTests
//
//  Created by Hilal Hakkani on 29/03/2022.
//

import XCTest
@testable import HomeNetwork

class HomeEndpointsTests: XCTestCase
{
	func test_loginEndpoint()
	{
		let anyURL = URL(string: "http://anyURL.com")!
		let url = PixaBayEndpoint.getFeeds.url(baseURL: anyURL)
		let expectedURL = URL(string: "http://anyURL.com/api/?key=13121123-1b5cabbe98a1d62c9bf7ddfb9")!
		XCTAssertEqual(url, expectedURL)
	}
}
