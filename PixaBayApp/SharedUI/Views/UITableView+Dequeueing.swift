//
//  Created by Pinpay Graphic on 15/10/2021.
//

import UIKit

extension UITableView {
	public func dequeueReusableCell<T: UITableViewCell>() -> T {
		let identifier = String(describing: T.self)
		return dequeueReusableCell(withIdentifier: identifier) as! T
	}
}
