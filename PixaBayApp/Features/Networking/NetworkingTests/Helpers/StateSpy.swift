//
//  StateSpy.swift
//  HaweleiOSTests
//
//  Created by Hilal  Al Hakkani on 27/09/2021.
//

import Foundation
import RxSwift

class StateSpy<T> {
	private(set) var values: [T] = []
	private var disposeBag = DisposeBag()

	init(observable: Observable<T>) {
		observable.subscribe(onNext: { [weak self] state in
			self?.values.append(state)
		})
			.disposed(by: disposeBag)
	}
}
