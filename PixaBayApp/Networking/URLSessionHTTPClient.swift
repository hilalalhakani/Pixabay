//
//  URLSessionHTTPClient.swift
//  PixBayNetwork
//
//  Created by Pinpay Graphic on 15/10/2021.
//

import Foundation
import RxSwift
import RxCocoa

public final class URLSessionHTTPClient: HTTPClient {
	public init(session: URLSession = URLSession(configuration: .ephemeral)) {
		self.session = session
	}

	public func get(_ request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)> {
		return session.rx
			.response(request: request)
			.subscribe(on: SerialDispatchQueueScheduler(qos: .userInteractive))
			.observe(on: MainScheduler.instance)
	}

	let session: URLSession
}
