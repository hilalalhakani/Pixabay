//
//  HomeViewController.swift
//  PixBay
//
//  Created by Pinpay Graphic on 16/10/2021.
//

import Foundation
import RxDataSources
import RxSwift
import UIKit
import RxCocoa
import SharedUI
import HomeNetwork

public class HomeViewController: UIViewController, UIScrollViewDelegate, Storyboarded {
	//MARK: Outlets
	@IBOutlet public var tableView: UITableView!

	//MARK: Properties
	fileprivate let viewModel: HomeViewModel
	fileprivate let disposeBag = DisposeBag()
	public let refreshControl = UIRefreshControl()
	public typealias HomeSection = AnimatableSectionModel<String, HitImageCellViewModel>

	//MARK: Initialization
	public init?(coder: NSCoder, viewModel: HomeViewModel) {
		self.viewModel = viewModel
		super.init(coder: coder)
	}

	required init?(coder _: NSCoder) {
		fatalError("Use `init(coder:HomeViewModel:)` to initialize a `HomeViewModel` instance.")
	}
}

extension HomeViewController {
	override public func viewDidLoad()
	{
		super.viewDidLoad()
		self.setupViews()
		self.setupBindings()
	}

	func setupViews()
	{
		self.tableView.refreshControl = self.refreshControl
	}

	func setupBindings() {
		self.viewModel.output.isLoading
			.drive(self.refreshControl.rx.isRefreshing)
			.disposed(by: self.disposeBag)

		self.tableView.rx.setDelegate(self)
			.disposed(by: self.disposeBag)

		self.tableView.rx.prefetchRows
			.bind(to: self.viewModel.input.prefetchedRows)
			.disposed(by: self.disposeBag)

		self.tableView.rx.cancelPrefetchingForRows
			.bind(to: self.viewModel.input.cancelPrefetchingForRows)
			.disposed(by: self.disposeBag)

		self.tableView.rx.didEndDisplayingCell
			.map({ [IndexPath(row: $0.indexPath.row, section: 0)] })
			.bind(to: self.viewModel.input.cancelPrefetchingForRows)
			.disposed(by: self.disposeBag)

		let dataSource = RxTableViewSectionedAnimatedDataSource<HomeSection>(configureCell: { (dataSource, tableView, indexPath, viewModel) -> UITableViewCell in
			let cell: HomeTableViewCell = tableView.dequeueReusableCell()
			cell.cellViewModel = viewModel
			viewModel.input.preload.onNext(())
			return cell
		})

		dataSource.animationConfiguration = .init(
			insertAnimation: .fade,
			reloadAnimation: .automatic,
			deleteAnimation: .fade)

		viewModel.output.sections
			.drive(tableView.rx.items(dataSource: dataSource))
			.disposed(by: disposeBag)

		tableView.rx
			.modelSelected(HitImageCellViewModel.self)
			.map(\.hit)
			.bind(to: self.viewModel.input.navigateToImageDetails)
			.disposed(by: disposeBag)

		viewModel.output.error
			.drive(rx.shouldPresentError)
			.disposed(by: disposeBag)

		self.refreshControl.rx.controlEvent(.valueChanged)
			.bind(to: self.viewModel.input.reload)
			.disposed(by: disposeBag)
	}
}

public extension Reactive where Base: HomeViewController {
	var navigateToImageDetails: Driver<Hit> {
		base.viewModel.output.navigateToImageDetails
	}
}
