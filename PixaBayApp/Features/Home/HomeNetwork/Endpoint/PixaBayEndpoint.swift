//
//  PixaBayEndpoint.swift
//  PixabayNetwork
//
//  Created by Hilal Hakkani on 21/02/2022.
//

import Foundation

enum PixaBayEndpoint {
	case getFeeds
}

extension PixaBayEndpoint {
	public func url(baseURL: URL) -> URL {
		switch self {
		case .getFeeds:
			let getFeedsURL = baseURL.appendingPathComponent("api/")
			let queryItems = [URLQueryItem(name: "key", value: Constants.apiKey)]
			var urlComps = URLComponents(string: getFeedsURL.absoluteString)!
			urlComps.queryItems = queryItems
			return urlComps.url!
		}
	}
}
