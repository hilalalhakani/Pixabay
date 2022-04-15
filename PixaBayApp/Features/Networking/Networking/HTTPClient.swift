//
//  HTTP Client.swift
//  PixBayNetwork
//
//  Created by Pinpay Graphic on 15/10/2021.
//

import Foundation
import RxSwift

public protocol HTTPClient {
	func get(_ request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)>
}
