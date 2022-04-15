//
//  URLProtocolStub.swift
//  Hawele ProTests
//
//  Created by Hilal  Al Hakkani on 11/05/2021.
//

import Foundation

class URLProtocolStub: URLProtocol {
	private static var stub: Stub?
	private static var requestObserver: ((URLRequest) -> Void)?

	private struct Stub {
		let data: Data?
		let response: URLResponse?
		let error: Error?
	}

	static func stub(data: Data?, response: URLResponse?, error: Error?) {
		stub = Stub(data: data, response: response, error: error)
	}

	static func observeRequests(observer: @escaping (URLRequest) -> Void) {
		requestObserver = observer
	}

	static func startInterceptingRequests() {
		URLProtocol.registerClass(URLProtocolStub.self)
	}

	static func stopInterceptingRequests() {
		URLProtocol.unregisterClass(URLProtocolStub.self)
		stub = nil
		requestObserver = nil
	}

	override class func canInit(with request: URLRequest) -> Bool {
		requestObserver?(request)
		return true
	}

	override class func canonicalRequest(for request: URLRequest) -> URLRequest {
		return request
	}

	override func startLoading() {
		if let data = URLProtocolStub.stub?.data {
			client?.urlProtocol(self, didLoad: data)
		}

		if let response = URLProtocolStub.stub?.response {
			client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
		}

		if let error = URLProtocolStub.stub?.error {
			client?.urlProtocol(self, didFailWithError: error)
		}

		client?.urlProtocolDidFinishLoading(self)
	}

	override func stopLoading() {}
}

extension URLRequest {
	var httpBodyData: Data? {
		guard let stream = httpBodyStream else { return httpBody }

		let bufferSize = 1024
		var data = Data()
		var buffer = [UInt8](repeating: 0, count: bufferSize)

		stream.open()

		while stream.hasBytesAvailable {
			let length = stream.read(&buffer, maxLength: bufferSize)

			if length == 0 {
				break
			}

			data.append(&buffer, count: length)
		}

		stream.close()

		return data
	}
}
