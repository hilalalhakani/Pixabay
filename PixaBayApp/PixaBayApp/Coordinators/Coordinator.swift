//
//  Coordinator.swift
//  Hawele
//
//  Created by Pinpay Graphic on 12/10/2021.
//

import Foundation
import UIKit

protocol Coordinator {
	var childCoordinators: [Coordinator] { get set }
	var navigationController: UINavigationController { get set }
	func start()
}
