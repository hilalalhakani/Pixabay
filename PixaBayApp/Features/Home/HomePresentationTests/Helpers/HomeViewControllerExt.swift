//
//  HomeViewControllerExt.swift
//  HomePresentationTests
//
//  Created by Hilal Hakkani on 08/04/2022.
//

import Foundation
import HomePresentation
import UIKit

extension HomeViewController
{
	var isShowingLoadingIndicator: Bool
	{
		self.refreshControl.isRefreshing
	}

	func simulateTapOnFeedImageAtIndex(_ index: Int)
	{
		self.tableView.delegate?.tableView?(self.tableView, didSelectRowAt: IndexPath(row: index, section: 0))
	}

	func simulateUserInitiatedReload()
	{
		self.refreshControl.beginRefreshing()
		self.refreshControl.sendActions(for: .valueChanged)
	}

	func numberOfRenderedFeedImageViews() -> Int {
		numberOfRows(in: 0)
	}

	func numberOfRows(in section: Int) -> Int
	{
		self.tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
	}

	func feedImageView(at row: Int) -> UITableViewCell? {
		cell(row: row, section: 0)
	}

	func cell(row: Int, section: Int) -> UITableViewCell? {
		guard numberOfRows(in: section) > row else {
			return nil
		}
		let ds = tableView.dataSource
		let index = IndexPath(row: row, section: section)
		return ds?.tableView(tableView, cellForRowAt: index)
	}

	@discardableResult
	func simulateFeedImageViewVisible(at index: Int) -> HomeTableViewCell? {
		return feedImageView(at: index) as? HomeTableViewCell
	}

	@discardableResult
	func simulateFeedImageViewNotVisible(at row: Int) -> HomeTableViewCell? {
		let view = simulateFeedImageViewVisible(at: row)
		let delegate = tableView.delegate
		let index = IndexPath(row: row, section: 0)
		delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)

		return view
	}

	func simulateFeedImageViewNotNearVisible(at row: Int) {
		simulateFeedImageViewNearVisible(at: row)

		let ds = tableView.prefetchDataSource
		let index = IndexPath(row: row, section: 0)
		ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
	}

	func simulateFeedImageViewNearVisible(at row: Int) {
		let ds = tableView.prefetchDataSource
		let index = IndexPath(row: row, section: 0)
		ds?.tableView(tableView, prefetchRowsAt: [index])
	}
}
