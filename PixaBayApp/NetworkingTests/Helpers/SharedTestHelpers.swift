//
//  SharedTestHelpers.swift
//  PixBayNetworkTests
//
//  Created by Pinpay Graphic on 15/10/2021.
//

import Foundation

func anyNSError() -> NSError {
	return NSError(domain: "any error", code: 10)
}

func anyURL() -> URL {
	return URL(string: "https://any-url.com")!
}

func anyData() -> Data {
	let dic = ["name": "Test"]
	return try! JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
}

func anyRequest() -> URLRequest {
	return URLRequest(url: anyURL())
}

func anyHTTPURLResponse(code: Int) -> HTTPURLResponse {
	return HTTPURLResponse(url: anyURL(), statusCode: code, httpVersion: nil, headerFields: nil)!
}

func anyHTTPURLResponse() -> HTTPURLResponse {
	return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
}

func nonHTTPURLResponse() -> URLResponse {
	return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
}

class AnyDecodable: Decodable {}
