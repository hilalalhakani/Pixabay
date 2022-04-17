//
//  HomeViewModel.swift
//  PixBay
//
//  Created by Pinpay Graphic on 16/10/2021.
//

import Foundation
import HomeNetwork
import RxSwift
import RxCocoa
import RxDataSources
import Networking
import RxSwiftExt

public class HomeViewModel
{
	public struct Input
	{
		public let reload: AnyObserver<Void>
		public let prefetchedRows: AnyObserver<[IndexPath]>
		public let cancelPrefetchingForRows: AnyObserver<[IndexPath]>
		public let didEndDisplayingCellAtIndex: AnyObserver<Int>
		public let navigateToImageDetails: AnyObserver<Hit>
	}

	public struct Output
	{
		public let sections: Driver<[HomeViewController.HomeSection]>
		public let isLoading: Driver<Bool>
		public let error: Driver<String>
		public let navigateToImageDetails: Driver<Hit>
	}

	public let input: Input
	public var output: Output!

	private let pixaBayRepository: PixaBayRepository

	let disposeBag = DisposeBag()

	public init(pixaBayRepository: PixaBayRepository, imageDownloader: ImageDownloader)
	{
		self.pixaBayRepository = pixaBayRepository

		let reloadSubject = PublishSubject<Void>()
		let prefetchedRowsSubject = PublishSubject<[IndexPath]>()
		let cancelPrefetchingForRowsSubject = PublishSubject<[IndexPath]>()
		let didEndDisplayingCellAtIndexSubject = PublishSubject<Int>()
		let navigateToImageDetailsSubject = PublishSubject<Hit>()

		self.input = Input(
			reload: reloadSubject.asObserver(),
			prefetchedRows: prefetchedRowsSubject.asObserver(),
			cancelPrefetchingForRows: cancelPrefetchingForRowsSubject.asObserver(),
			didEndDisplayingCellAtIndex: didEndDisplayingCellAtIndexSubject.asObserver(),
			navigateToImageDetails: navigateToImageDetailsSubject.asObserver()
		)

		let apiResult = reloadSubject
			.startWith(())
			.flatMapLatest({
				pixaBayRepository.getFeeds()
					.materialize()
					.map { event -> Result<[Hit], Error>? in
						switch event {
						case .next(let response):
							return Result.success(response.hits)
						case .error(let error):
							return Result.failure(error)
						default:
							return nil
						}
					}
					.unwrap()
			})
			.share()

		let cellControllers = apiResult
			.map({ try? $0.get() })
			.unwrap()
			.map({ $0.map({ HitImageCellViewModel(hit: $0, imageDownloader: imageDownloader) }) })
			.share(replay: 1, scope: .forever)

		let error = apiResult
			.map({ $0.error() })
			.unwrap()
			.map({ $0.localizedDescription })

		let sections = cellControllers
			.map({ [HomeViewController.HomeSection(model: "", items: $0)] })

		Observable.combineLatest(prefetchedRowsSubject, cellControllers)
			.subscribe(onNext: {
				let indexes = $0.map(\.row)
				for index in indexes {
					$1[index].input.preload.onNext(())
				}
			})
			.disposed(by: self.disposeBag)

		let isLoading = apiResult
			.map({ _ in false })
			.startWith(true)

		cancelPrefetchingForRowsSubject
			.map({ $0.map(\.row) })
			.withLatestFrom(cellControllers, resultSelector: { ($0, $1) })
			.map { (rows, cellControllers) in
				for row in rows
				{
					if row < cellControllers.count
					{
						let hit = cellControllers[row].hit
						if let url = URL(string: hit.largeImageURL) {
							imageDownloader.cancelDownloadImage(url: url)
						}
					}
				}
			}
			.subscribe()
			.disposed(by: self.disposeBag)

		self.output = Output(
			sections: sections.asDriver(onErrorDriveWith: .empty()),
			isLoading: isLoading.asDriver(onErrorDriveWith: .empty()),
			error: error.asDriver(onErrorDriveWith: .empty()),
			navigateToImageDetails: navigateToImageDetailsSubject.asDriver(onErrorDriveWith: .empty())
		)
	}
}
