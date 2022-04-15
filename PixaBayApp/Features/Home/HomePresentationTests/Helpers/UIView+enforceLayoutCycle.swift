//
//  UIViewHelpers.swift
//  HomePresentationTests
//
//  Created by Hilal Hakkani on 08/04/2022.
//

import Foundation

import UIKit

extension UIView {
	func enforceLayoutCycle()
	{
		layoutIfNeeded()
		RunLoop.current.run(until: Date())
	}
}
