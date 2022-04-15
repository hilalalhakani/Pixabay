//
//  Control.swift
//  PixaBayAppTests
//
//  Created by Hilal Hakkani on 09/03/2022.
//

import Foundation
import UIKit

extension UIControl {
	func simulateEvent(_ event: UIControl.Event) {
		for target in allTargets {
			let target = target as NSObjectProtocol
			for actionName in actions(forTarget: target, forControlEvent: event) ?? [] {
				let selector = Selector(actionName)
				target.perform(selector)
			}
		}
	}
}
