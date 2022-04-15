//
//  HomeTableViewCellExt.swift
//  HomePresentationTests
//
//  Created by Hilal Hakkani on 08/04/2022.
//

import Foundation
import HomePresentation
import SharedUI

extension HomeTableViewCell
{
	var title: String? {
		self.feedUserLabel.text
	}

	var imageData: Data {
		self.feedImageView.image?.pngData() ?? Data()
	}

	var isShowingImageLoadingIndicator: Bool {
		return feedImageContainer.isShimmering
	}

	var isShowingRetryAction: Bool {
		return !retryButton.isHidden
	}

	func simulateRetryAction() {
		self.retryButton.sendActions(for: .touchUpInside)
	}
}
