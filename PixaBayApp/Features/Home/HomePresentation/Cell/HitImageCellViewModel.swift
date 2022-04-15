//
//  HomeTableViewCell.swift
//  PixBay
//
//  Created by Pinpay Graphic on 16/10/2021.
//
import Network
import RxCocoa
import RxSwift
import UIKit
import RxDataSources
import HomeNetwork
import SharedUI

public final class HitImageCellViewModel
{
	let hit: Hit

	struct Input
	{
		let retry: AnyObserver<Void>
		let cancel: AnyObserver<Void>
		let preload: AnyObserver<Void>
	}

	struct Output
	{
		let feedUserLabel: Driver<String>
		let feedImageData: Driver<Data>
		let isRetryButtonHidden: Driver<Bool>
		let isFeedImageContainerShimmering: Driver<Bool>
	}

	let input: Input
	var output: Output!
	let disposeBag = DisposeBag()

	init(hit: Hit, imageDownloader: ImageDownloader)
	{
		self.hit = hit

		let preloadSubject = PublishSubject<Void>()
		let cancelSubject = PublishSubject<Void>()
		let retrySubject = PublishSubject<Void>()
		let isRetryButtonHidden = BehaviorSubject<Bool>(value: true)

		self.input = Input(
			retry: retrySubject.asObserver(),
			cancel: cancelSubject.asObserver(),
			preload: preloadSubject.asObserver()
		)

		let feedImageDataResult = Observable.merge(retrySubject, preloadSubject)
			.flatMapLatest { [imageDownloader] _ -> Observable<Result<Data, Error>> in
				let url = URL(string: hit.largeImageURL)!
				return imageDownloader.downloadImage(url: url)
					.materialize()
					.map { [weak isRetryButtonHidden] event -> Result<Data, Error>? in
						switch event {
						case .next(let data):
							isRetryButtonHidden?.onNext(true)
							return Result.success(data)
						case .error(let error):
							isRetryButtonHidden?.onNext(false)
							return Result.failure(error)
						default:
							return nil
						}
					}
					.unwrap()
			}
			.share(replay: 1, scope: .forever)

		// the subscribtion is manual in case of Preloading where the cell isnt created
		feedImageDataResult.subscribe()
			.disposed(by: self.disposeBag)

		let isFeedImageContainerShimmering = Observable.merge(
			feedImageDataResult.map({ _ in false }),
			retrySubject.map({ _ in true }))
			.startWith(true)

		retrySubject
			.subscribe(onNext: { [weak isRetryButtonHidden] in
				isRetryButtonHidden?.onNext(true)
			})
			.disposed(by: self.disposeBag)

		let imageData = feedImageDataResult
			.map({ try? $0.get() })
			.unwrap()

		self.output = Output(feedUserLabel: Driver.just(hit.user),
		                     feedImageData: imageData.asDriver(onErrorDriveWith: .empty()),
		                     isRetryButtonHidden: isRetryButtonHidden.asDriver(onErrorDriveWith: .empty()),
		                     isFeedImageContainerShimmering: isFeedImageContainerShimmering.asDriver(onErrorDriveWith: .empty()))
	}
}

extension HitImageCellViewModel: IdentifiableType {
	public var identity: Int {
		self.hit.id
	}
}

extension HitImageCellViewModel: Equatable {
	public static func == (lhs: HitImageCellViewModel, rhs: HitImageCellViewModel) -> Bool {
		lhs.hit == rhs.hit
	}
}
