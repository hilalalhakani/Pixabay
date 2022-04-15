//
//  Storyboarded.swift
//  PixaBayiOS
//
//  Created by Hilal Hakkani on 26/02/2022.
//

import Foundation
import UIKit

public protocol Storyboarded {
	static func instantiate(_ creator: ((Foundation.NSCoder) -> Self?)?) -> Self
}

public extension Storyboarded where Self: UIViewController {
	static func instantiate(_ creator: ((Foundation.NSCoder) -> Self?)?) -> Self {
		// this pulls out "MyApp.MyViewController"
		let fullName = NSStringFromClass(self)

		// this splits by the dot and uses everything after, giving "MyViewController"
		let className = fullName.components(separatedBy: ".")[1]

		let bundle = Bundle(for: Self.self)
		// load our storyboard
		let storyboard = UIStoryboard(name: "Main", bundle: bundle)

		// instantiate a view controller with that identifier, and force cast as the type that was requested
		return storyboard.instantiateViewController(identifier: className, creator: creator)
	}
}
