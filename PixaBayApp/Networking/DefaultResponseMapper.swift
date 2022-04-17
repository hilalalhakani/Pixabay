//
//  ResponseMapper.swift
//  PixBayNetwork
//
//  Created by Pinpay Graphic on 15/10/2021.
//

import Foundation

final public class DefaultResponseMapper<T> {
	static public func map(_ data: Data, from response: HTTPURLResponse, decodedType _: T.Type) throws -> T where T: Decodable {
		let jsonDecoder = JSONDecoder()
		guard response.statusCode == statusCode200,
		      let decodedResponse = try? jsonDecoder.decode(T.self, from: data)
		else {
			throw APIError(response: response)
		}

		return decodedResponse
	}

	private static var statusCode200: Int { return 200 }
}
