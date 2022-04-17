//
//  PixaBayRepository.swift
//  PixBayNetwork
//
//  Created by Pinpay Graphic on 16/10/2021.
//

import Foundation
import RxSwift
import Networking

public protocol PixaBayRepository {
	func getFeeds() -> Observable<FeedsResponse>
}

public class PixaBayRepositoryImple: PixaBayRepository {
	let httpClient: HTTPClient
	let hostURL: URL

	public init(httpClient: HTTPClient, hostURL: URL) {
		self.httpClient = httpClient
		self.hostURL = hostURL
	}

	public func getFeeds() -> Observable<FeedsResponse> {
		let urlString = PixaBayEndpoint.getFeeds.url(baseURL: hostURL)
		let request = URLRequest(url: urlString)

		return httpClient.get(request)
			.map { try DefaultResponseMapper.map($1, from: $0, decodedType: FeedsResponse.self) }
	}
}
