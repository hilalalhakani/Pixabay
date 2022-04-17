////
////  URLSessionHTTPTests.swift
////  PixBayNetworkTests
////
////  Created by Pinpay Graphic on 15/10/2021.
////
//
//import RxSwift
//import XCTest
//import RxBlocking
//
//@testable import Networking
//
//class URLSessionHTTPTests: XCTestCase {
//	// MARK: Setup Stub
//
//	override func setUp() {
//		URLProtocolStub.startInterceptingRequests()
//	}
//
//	override func tearDown() {
//		URLProtocolStub.stopInterceptingRequests()
//	}
//}
//
//extension URLSessionHTTPTests {
//	// MARK: Observe URL Request
//
//	func test_getFromURL_performsGETRequestWithURL() {
//		let request = createURLRequest(url: anyURL(), httpMethod: "GET", httpBody: anyData())
//		observeRequest(request: request)
//	}
//
//	func test_getFromURL_performsPOSTRequestWithURL() {
//		let request = createURLRequest(url: anyURL(), httpMethod: "POST", httpBody: anyData())
//		observeRequest(request: request)
//	}
//
//	func test_getFromURL_performsDELETERequestWithURL() {
//		let request = createURLRequest(url: anyURL(), httpMethod: "DELETE", httpBody: anyData())
//		observeRequest(request: request)
//	}
//}
//
//extension URLSessionHTTPTests {
//	// MARK: Observe URL Response
//	func test_makeGetRequest_ExpectToReceiveAnErrorWhenStubbingAnError() {
//		let sut = makeSUT()
//		stub(data: anyData(), response: anyHTTPURLResponse(), error: anyNSError())
//		expect(expectedResult: .failure(anyNSError()), sut: sut, request: anyRequest())
//	}
//
//	func test_makeGetRequest_ExpectToReceiveAResponserWhenStubbingAResponse() {
//		let sut = makeSUT()
//		stub(data: anyData(), response: anyHTTPURLResponse(), error: nil)
//		expect(expectedResult: .success(anyData()), sut: sut, request: anyRequest())
//	}
//}
//
//extension URLSessionHTTPTests {
//	// MARK: Helpers
//
//	func makeSUT() -> URLSessionHTTPClient {
//		let urlSessionConfiguration = URLSessionConfiguration.default
//		urlSessionConfiguration.protocolClasses = [URLProtocolStub.self]
//		let session = URLSession(configuration: urlSessionConfiguration)
//		let client = URLSessionHTTPClient(session: session)
//		trackForMemoryLeaks(client)
//		return client
//	}
//
//	func createURLRequest(url: URL, httpMethod: String, httpBody: Data) -> URLRequest {
//		var request = URLRequest(url: url)
//		request.httpMethod = httpMethod
//		request.httpBody = httpBody
//		return request
//	}
//
//	func expect(expectedResult: Result<Data, NSError>, sut: URLSessionHTTPClient, request: URLRequest)
//	{
//		switch expectedResult {
//		case let .success(expectedData):
//
//			XCTAssertNoThrow(try sut.get(request).toBlocking().first())
//			XCTAssertEqual(expectedData, try sut.get(request).toBlocking().first()?.data)
//
//		case let .failure(error):
//
//			XCTAssertThrowsError(try sut.get(request).toBlocking().first()) { thrownError in
//				XCTAssertEqual(error.domain, (thrownError as NSError).domain)
//				XCTAssertEqual(error.code, (thrownError as NSError).code)
//			}
//		}
//	}
//
//	func observeRequest(request: URLRequest) {
//		let sut = makeSUT()
//		let exp = expectation(description: "Wait for request")
//
//		URLProtocolStub.observeRequests { req in
//			let url = req.url
//			let data = req.httpBodyData
//			let method = req.httpMethod
//
//			XCTAssertEqual(url, request.url)
//			XCTAssertEqual(method, request.httpMethod)
//			XCTAssertEqual(data, request.httpBody)
//			exp.fulfill()
//		}
//
//		sut.makeAPIRequest(request: request)
//
//		wait(for: [exp], timeout: 1.0)
//	}
//
//	func stub(data: Data, response: HTTPURLResponse, error: Error?) {
//		URLProtocolStub.stub(data: data, response: response, error: error)
//	}
//}
//
//extension URLSessionHTTPClient {
//	func makeAPIRequest(request: URLRequest) {
//		_ = get(request).subscribe()
//	}
//}
