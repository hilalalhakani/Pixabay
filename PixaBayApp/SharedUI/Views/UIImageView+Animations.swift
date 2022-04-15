//
//  Created by Pinpay Graphic on 15/10/2021.
//

import UIKit

extension UIImageView {
	func setImageAnimated(_ newImage: UIImage?) {
		image = newImage

		guard newImage != nil else { return }

		alpha = 0
		UIView.animate(withDuration: 0.1) {
			self.alpha = 1
		}
	}
}
