//
//  RegistrationRepositoryTests.swift
//  RegistrationNetworkTests
//
//  Created by Hilal Hakkani on 05/04/2022.
//

import XCTest
import RxSwift
import Networking
import RegistrationNetwork

@testable import Registration
@testable import RegistrationNetwork

class RegistrationRepositoryTests: XCTestCase {
	func test_loginRepo_successfullResponse() {
		let sut = makeSUT()
		let repo = sut.repo
		let client = sut.httpClient
		let request = LoginRequest(email: "", password: "")
		let data = "{\"isPasswordCorrect\":true}".data(using: .utf8)!
		let anyURL = URL(string: "anyURL.com")!

		let response = repo.login(request: request)
		let stateSpy = StateSpy<LoginResponse>(observable: response)

		client.stub(element: (response: HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!, data: data))

		XCTAssertEqual(stateSpy.values, [LoginResponse(isPasswordCorrect: true)])
	}

	func test_loginRepo_responseWithError() {
		let sut = makeSUT()
		let repo = sut.repo
		let client = sut.httpClient
		let request = LoginRequest(email: "", password: "")

		let response = repo.login(request: request)

		let stateSpy = StateSpy<LoginResponse>(observable: response)
		client.stub(error: APIError.networkProblem)
		let receivedError = stateSpy.errorvalues.first!

		XCTAssertEqual(stateSpy.errorvalues.count, 1)
		XCTAssertEqual(receivedError.localizedDescription, APIError.networkProblem.localizedDescription)
	}

	private func makeSUT(
		file: StaticString = #filePath,
		line: UInt = #line
	) -> (httpClient: StubHTTPClient, repo: UserRepositoryImple) {
		let anyURL = URL(string: "anyURL.com")!
		let mockHTTpClient = StubHTTPClient()
		let repository = UserRepositoryImple(httpClient: mockHTTpClient, hostURL: anyURL)
		trackForMemoryLeaks(mockHTTpClient, file: file, line: line)
		trackForMemoryLeaks(repository, file: file, line: line)
		return (httpClient: mockHTTpClient, repo: repository)
	}

	private class StubHTTPClient: HTTPClient
	{
		let response = ReplaySubject<(response: HTTPURLResponse, data: Data)>.create(bufferSize: 1)

		func get(_ request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)> {
			return response.asObservable()
		}

		func stub(element: (response: HTTPURLResponse, data: Data)) {
			self.response.onNext(element)
		}

		func stub(error: Error) {
			self.response.onError(error)
		}
	}
}
