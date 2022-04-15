// This file is autogenerated. Take a look at `Preprocessor` target in RxSwift project
//
//  CombineLatest+arity.swift
//  RxSwift
//
//  Created by Krunoslav Zaher on 4/22/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

// 2

extension ObservableType {
	/**
	 Merges the specified observable sequences into one observable sequence by using the selector function whenever any of the observable sequences produces an element.

	 - seealso: [combineLatest operator on reactivex.io](http://reactivex.io/documentation/operators/combinelatest.html)

	 - parameter resultSelector: Function to invoke whenever any of the sources produces an element.
	 - returns: An observable sequence containing the result of combining elements of the sources using the specified result selector function.
	 */
	public static func combineLatest<O1: ObservableType, O2: ObservableType>
	(_ source1: O1, _ source2: O2, resultSelector: @escaping (O1.Element, O2.Element) throws -> Element)
		-> Observable<Element> {
		return CombineLatest2(
			source1: source1.asObservable(), source2: source2.asObservable(),
			resultSelector: resultSelector
		)
	}
}

extension ObservableType where Element == Any {
	/**
	 Merges the specified observable sequences into one observable sequence of tuples whenever any of the observable sequences produces an element.

	 - seealso: [combineLatest operator on reactivex.io](http://reactivex.io/documentation/operators/combinelatest.html)

	 - returns: An observable sequence containing the result of combining elements of the sources.
	 */
	public static func combineLatest<O1: ObservableType, O2: ObservableType>
	(_ source1: O1, _ source2: O2)
		-> Observable<(O1.Element, O2.Element)> {
		return CombineLatest2(
			source1: source1.asObservable(), source2: source2.asObservable(),
			resultSelector: { ($0, $1) }
		)
	}
}

final class CombineLatestSink2_<E1, E2, Observer: ObserverType>: CombineLatestSink<Observer> {
	typealias Result = Observer.Element
	typealias Parent = CombineLatest2<E1, E2, Result>

	let parent: Parent

	var latestElement1: E1!
	var latestElement2: E2!

	init(parent: Parent, observer: Observer, cancel: Cancelable) {
		self.parent = parent
		super.init(arity: 2, observer: observer, cancel: cancel)
	}

	func run() -> Disposable {
		let subscription1 = SingleAssignmentDisposable()
		let subscription2 = SingleAssignmentDisposable()

		let observer1 = CombineLatestObserver(lock: self.lock, parent: self, index: 0, setLatestValue: { (e: E1) -> Void in self.latestElement1 = e }, this: subscription1)
		let observer2 = CombineLatestObserver(lock: self.lock, parent: self, index: 1, setLatestValue: { (e: E2) -> Void in self.latestElement2 = e }, this: subscription2)

		subscription1.setDisposable(self.parent.source1.subscribe(observer1))
		subscription2.setDisposable(self.parent.source2.subscribe(observer2))

		return Disposables.create([
			subscription1,
			subscription2
		])
	}

	override func getResult() throws -> Result {
		try self.parent.resultSelector(self.latestElement1, self.latestElement2)
	}
}

final class CombineLatest2<E1, E2, Result>: Producer<Result> {
	typealias ResultSelector = (E1, E2) throws -> Result

	let source1: Observable<E1>
	let source2: Observable<E2>

	let resultSelector: ResultSelector

	init(source1: Observable<E1>, source2: Observable<E2>, resultSelector: @escaping ResultSelector) {
		self.source1 = source1
		self.source2 = source2

		self.resultSelector = resultSelector
	}

	override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Result {
		let sink = CombineLatestSink2_(parent: self, observer: observer, cancel: cancel)
		let subscription = sink.run()
		return (sink: sink, subscription: subscription)
	}
}

// 3

extension ObservableType {
	/**
	 Merges the specified observable sequences into one observable sequence by using the selector function whenever any of the observable sequences produces an element.

	 - seealso: [combineLatest operator on reactivex.io](http://reactivex.io/documentation/operators/combinelatest.html)

	 - parameter resultSelector: Function to invoke whenever any of the sources produces an element.
	 - returns: An observable sequence containing the result of combining elements of the sources using the specified result selector function.
	 */
	public static func combineLatest<O1: ObservableType, O2: ObservableType, O3: ObservableType>
	(_ source1: O1, _ source2: O2, _ source3: O3, resultSelector: @escaping (O1.Element, O2.Element, O3.Element) throws -> Element)
		-> Observable<Element> {
		return CombineLatest3(
			source1: source1.asObservable(), source2: source2.asObservable(), source3: source3.asObservable(),
			resultSelector: resultSelector
		)
	}
}

extension ObservableType where Element == Any {
	/**
	 Merges the specified observable sequences into one observable sequence of tuples whenever any of the observable sequences produces an element.

	 - seealso: [combineLatest operator on reactivex.io](http://reactivex.io/documentation/operators/combinelatest.html)

	 - returns: An observable sequence containing the result of combining elements of the sources.
	 */
	public static func combineLatest<O1: ObservableType, O2: ObservableType, O3: ObservableType>
	(_ source1: O1, _ source2: O2, _ source3: O3)
		-> Observable<(O1.Element, O2.Element, O3.Element)> {
		return CombineLatest3(
			source1: source1.asObservable(), source2: source2.asObservable(), source3: source3.asObservable(),
			resultSelector: { ($0, $1, $2) }
		)
	}
}

final class CombineLatestSink3_<E1, E2, E3, Observer: ObserverType>: CombineLatestSink<Observer> {
	typealias Result = Observer.Element
	typealias Parent = CombineLatest3<E1, E2, E3, Result>

	let parent: Parent

	var latestElement1: E1!
	var latestElement2: E2!
	var latestElement3: E3!

	init(parent: Parent, observer: Observer, cancel: Cancelable) {
		self.parent = parent
		super.init(arity: 3, observer: observer, cancel: cancel)
	}

	func run() -> Disposable {
		let subscription1 = SingleAssignmentDisposable()
		let subscription2 = SingleAssignmentDisposable()
		let subscription3 = SingleAssignmentDisposable()

		let observer1 = CombineLatestObserver(lock: self.lock, parent: self, index: 0, setLatestValue: { (e: E1) -> Void in self.latestElement1 = e }, this: subscription1)
		let observer2 = CombineLatestObserver(lock: self.lock, parent: self, index: 1, setLatestValue: { (e: E2) -> Void in self.latestElement2 = e }, this: subscription2)
		let observer3 = CombineLatestObserver(lock: self.lock, parent: self, index: 2, setLatestValue: { (e: E3) -> Void in self.latestElement3 = e }, this: subscription3)

		subscription1.setDisposable(self.parent.source1.subscribe(observer1))
		subscription2.setDisposable(self.parent.source2.subscribe(observer2))
		subscription3.setDisposable(self.parent.source3.subscribe(observer3))

		return Disposables.create([
			subscription1,
			subscription2,
			subscription3
		])
	}

	override func getResult() throws -> Result {
		try self.parent.resultSelector(self.latestElement1, self.latestElement2, self.latestElement3)
	}
}

final class CombineLatest3<E1, E2, E3, Result>: Producer<Result> {
	typealias ResultSelector = (E1, E2, E3) throws -> Result

	let source1: Observable<E1>
	let source2: Observable<E2>
	let source3: Observable<E3>

	let resultSelector: ResultSelector

	init(source1: Observable<E1>, source2: Observable<E2>, source3: Observable<E3>, resultSelector: @escaping ResultSelector) {
		self.source1 = source1
		self.source2 = source2
		self.source3 = source3

		self.resultSelector = resultSelector
	}

	override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Result {
		let sink = CombineLatestSink3_(parent: self, observer: observer, cancel: cancel)
		let subscription = sink.run()
		return (sink: sink, subscription: subscription)
	}
}

// 4

extension ObservableType {
	/**
	 Merges the specified observable sequences into one observable sequence by using the selector function whenever any of the observable sequences produces an element.

	 - seealso: [combineLatest operator on reactivex.io](http://reactivex.io/documentation/operators/combinelatest.html)

	 - parameter resultSelector: Function to invoke whenever any of the sources produces an element.
	 - returns: An observable sequence containing the result of combining elements of the sources using the specified result selector function.
	 */
	public static func combineLatest<O1: ObservableType, O2: ObservableType, O3: ObservableType, O4: ObservableType>
	(_ source1: O1, _ source2: O2, _ source3: O3, _ source4: O4, resultSelector: @escaping (O1.Element, O2.Element, O3.Element, O4.Element) throws -> Element)
		-> Observable<Element> {
		return CombineLatest4(
			source1: source1.asObservable(), source2: source2.asObservable(), source3: source3.asObservable(), source4: source4.asObservable(),
			resultSelector: resultSelector
		)
	}
}

extension ObservableType where Element == Any {
	/**
	 Merges the specified observable sequences into one observable sequence of tuples whenever any of the observable sequences produces an element.

	 - seealso: [combineLatest operator on reactivex.io](http://reactivex.io/documentation/operators/combinelatest.html)

	 - returns: An observable sequence containing the result of combining elements of the sources.
	 */
	public static func combineLatest<O1: ObservableType, O2: ObservableType, O3: ObservableType, O4: ObservableType>
	(_ source1: O1, _ source2: O2, _ source3: O3, _ source4: O4)
		-> Observable<(O1.Element, O2.Element, O3.Element, O4.Element)> {
		return CombineLatest4(
			source1: source1.asObservable(), source2: source2.asObservable(), source3: source3.asObservable(), source4: source4.asObservable(),
			resultSelector: { ($0, $1, $2, $3) }
		)
	}
}

final class CombineLatestSink4_<E1, E2, E3, E4, Observer: ObserverType>: CombineLatestSink<Observer> {
	typealias Result = Observer.Element
	typealias Parent = CombineLatest4<E1, E2, E3, E4, Result>

	let parent: Parent

	var latestElement1: E1!
	var latestElement2: E2!
	var latestElement3: E3!
	var latestElement4: E4!

	init(parent: Parent, observer: Observer, cancel: Cancelable) {
		self.parent = parent
		super.init(arity: 4, observer: observer, cancel: cancel)
	}

	func run() -> Disposable {
		let subscription1 = SingleAssignmentDisposable()
		let subscription2 = SingleAssignmentDisposable()
		let subscription3 = SingleAssignmentDisposable()
		let subscription4 = SingleAssignmentDisposable()

		let observer1 = CombineLatestObserver(lock: self.lock, parent: self, index: 0, setLatestValue: { (e: E1) -> Void in self.latestElement1 = e }, this: subscription1)
		let observer2 = CombineLatestObserver(lock: self.lock, parent: self, index: 1, setLatestValue: { (e: E2) -> Void in self.latestElement2 = e }, this: subscription2)
		let observer3 = CombineLatestObserver(lock: self.lock, parent: self, index: 2, setLatestValue: { (e: E3) -> Void in self.latestElement3 = e }, this: subscription3)
		let observer4 = CombineLatestObserver(lock: self.lock, parent: self, index: 3, setLatestValue: { (e: E4) -> Void in self.latestElement4 = e }, this: subscription4)

		subscription1.setDisposable(self.parent.source1.subscribe(observer1))
		subscription2.setDisposable(self.parent.source2.subscribe(observer2))
		subscription3.setDisposable(self.parent.source3.subscribe(observer3))
		subscription4.setDisposable(self.parent.source4.subscribe(observer4))

		return Disposables.create([
			subscription1,
			subscription2,
			subscription3,
			subscription4
		])
	}

	override func getResult() throws -> Result {
		try self.parent.resultSelector(self.latestElement1, self.latestElement2, self.latestElement3, self.latestElement4)
	}
}

final class CombineLatest4<E1, E2, E3, E4, Result>: Producer<Result> {
	typealias ResultSelector = (E1, E2, E3, E4) throws -> Result

	let source1: Observable<E1>
	let source2: Observable<E2>
	let source3: Observable<E3>
	let source4: Observable<E4>

	let resultSelector: ResultSelector

	init(source1: Observable<E1>, source2: Observable<E2>, source3: Observable<E3>, source4: Observable<E4>, resultSelector: @escaping ResultSelector) {
		self.source1 = source1
		self.source2 = source2
		self.source3 = source3
		self.source4 = source4

		self.resultSelector = resultSelector
	}

	override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Result {
		let sink = CombineLatestSink4_(parent: self, observer: observer, cancel: cancel)
		let subscription = sink.run()
		return (sink: sink, subscription: subscription)
	}
}

// 5

extension ObservableType {
	/**
	 Merges the specified observable sequences into one observable sequence by using the selector function whenever any of the observable sequences produces an element.

	 - seealso: [combineLatest operator on reactivex.io](http://reactivex.io/documentation/operators/combinelatest.html)

	 - parameter resultSelector: Function to invoke whenever any of the sources produces an element.
	 - returns: An observable sequence containing the result of combining elements of the sources using the specified result selector function.
	 */
	public static func combineLatest<O1: ObservableType, O2: ObservableType, O3: ObservableType, O4: ObservableType, O5: ObservableType>
	(_ source1: O1, _ source2: O2, _ source3: O3, _ source4: O4, _ source5: O5, resultSelector: @escaping (O1.Element, O2.Element, O3.Element, O4.Element, O5.Element) throws -> Element)
		-> Observable<Element> {
		return CombineLatest5(
			source1: source1.asObservable(), source2: source2.asObservable(), source3: source3.asObservable(), source4: source4.asObservable(), source5: source5.asObservable(),
			resultSelector: resultSelector
		)
	}
}

extension ObservableType where Element == Any {
	/**
	 Merges the specified observable sequences into one observable sequence of tuples whenever any of the observable sequences produces an element.

	 - seealso: [combineLatest operator on reactivex.io](http://reactivex.io/documentation/operators/combinelatest.html)

	 - returns: An observable sequence containing the result of combining elements of the sources.
	 */
	public static func combineLatest<O1: ObservableType, O2: ObservableType, O3: ObservableType, O4: ObservableType, O5: ObservableType>
	(_ source1: O1, _ source2: O2, _ source3: O3, _ source4: O4, _ source5: O5)
		-> Observable<(O1.Element, O2.Element, O3.Element, O4.Element, O5.Element)> {
		return CombineLatest5(
			source1: source1.asObservable(), source2: source2.asObservable(), source3: source3.asObservable(), source4: source4.asObservable(), source5: source5.asObservable(),
			resultSelector: { ($0, $1, $2, $3, $4) }
		)
	}
}

final class CombineLatestSink5_<E1, E2, E3, E4, E5, Observer: ObserverType>: CombineLatestSink<Observer> {
	typealias Result = Observer.Element
	typealias Parent = CombineLatest5<E1, E2, E3, E4, E5, Result>

	let parent: Parent

	var latestElement1: E1!
	var latestElement2: E2!
	var latestElement3: E3!
	var latestElement4: E4!
	var latestElement5: E5!

	init(parent: Parent, observer: Observer, cancel: Cancelable) {
		self.parent = parent
		super.init(arity: 5, observer: observer, cancel: cancel)
	}

	func run() -> Disposable {
		let subscription1 = SingleAssignmentDisposable()
		let subscription2 = SingleAssignmentDisposable()
		let subscription3 = SingleAssignmentDisposable()
		let subscription4 = SingleAssignmentDisposable()
		let subscription5 = SingleAssignmentDisposable()

		let observer1 = CombineLatestObserver(lock: self.lock, parent: self, index: 0, setLatestValue: { (e: E1) -> Void in self.latestElement1 = e }, this: subscription1)
		let observer2 = CombineLatestObserver(lock: self.lock, parent: self, index: 1, setLatestValue: { (e: E2) -> Void in self.latestElement2 = e }, this: subscription2)
		let observer3 = CombineLatestObserver(lock: self.lock, parent: self, index: 2, setLatestValue: { (e: E3) -> Void in self.latestElement3 = e }, this: subscription3)
		let observer4 = CombineLatestObserver(lock: self.lock, parent: self, index: 3, setLatestValue: { (e: E4) -> Void in self.latestElement4 = e }, this: subscription4)
		let observer5 = CombineLatestObserver(lock: self.lock, parent: self, index: 4, setLatestValue: { (e: E5) -> Void in self.latestElement5 = e }, this: subscription5)

		subscription1.setDisposable(self.parent.source1.subscribe(observer1))
		subscription2.setDisposable(self.parent.source2.subscribe(observer2))
		subscription3.setDisposable(self.parent.source3.subscribe(observer3))
		subscription4.setDisposable(self.parent.source4.subscribe(observer4))
		subscription5.setDisposable(self.parent.source5.subscribe(observer5))

		return Disposables.create([
			subscription1,
			subscription2,
			subscription3,
			subscription4,
			subscription5
		])
	}

	override func getResult() throws -> Result {
		try self.parent.resultSelector(self.latestElement1, self.latestElement2, self.latestElement3, self.latestElement4, self.latestElement5)
	}
}

final class CombineLatest5<E1, E2, E3, E4, E5, Result>: Producer<Result> {
	typealias ResultSelector = (E1, E2, E3, E4, E5) throws -> Result

	let source1: Observable<E1>
	let source2: Observable<E2>
	let source3: Observable<E3>
	let source4: Observable<E4>
	let source5: Observable<E5>

	let resultSelector: ResultSelector

	init(source1: Observable<E1>, source2: Observable<E2>, source3: Observable<E3>, source4: Observable<E4>, source5: Observable<E5>, resultSelector: @escaping ResultSelector) {
		self.source1 = source1
		self.source2 = source2
		self.source3 = source3
		self.source4 = source4
		self.source5 = source5

		self.resultSelector = resultSelector
	}

	override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Result {
		let sink = CombineLatestSink5_(parent: self, observer: observer, cancel: cancel)
		let subscription = sink.run()
		return (sink: sink, subscription: subscription)
	}
}

// 6

extension ObservableType {
	/**
	 Merges the specified observable sequences into one observable sequence by using the selector function whenever any of the observable sequences produces an element.

	 - seealso: [combineLatest operator on reactivex.io](http://reactivex.io/documentation/operators/combinelatest.html)

	 - parameter resultSelector: Function to invoke whenever any of the sources produces an element.
	 - returns: An observable sequence containing the result of combining elements of the sources using the specified result selector function.
	 */
	public static func combineLatest<O1: ObservableType, O2: ObservableType, O3: ObservableType, O4: ObservableType, O5: ObservableType, O6: ObservableType>
	(_ source1: O1, _ source2: O2, _ source3: O3, _ source4: O4, _ source5: O5, _ source6: O6, resultSelector: @escaping (O1.Element, O2.Element, O3.Element, O4.Element, O5.Element, O6.Element) throws -> Element)
		-> Observable<Element> {
		return CombineLatest6(
			source1: source1.asObservable(), source2: source2.asObservable(), source3: source3.asObservable(), source4: source4.asObservable(), source5: source5.asObservable(), source6: source6.asObservable(),
			resultSelector: resultSelector
		)
	}
}

extension ObservableType where Element == Any {
	/**
	 Merges the specified observable sequences into one observable sequence of tuples whenever any of the observable sequences produces an element.

	 - seealso: [combineLatest operator on reactivex.io](http://reactivex.io/documentation/operators/combinelatest.html)

	 - returns: An observable sequence containing the result of combining elements of the sources.
	 */
	public static func combineLatest<O1: ObservableType, O2: ObservableType, O3: ObservableType, O4: ObservableType, O5: ObservableType, O6: ObservableType>
	(_ source1: O1, _ source2: O2, _ source3: O3, _ source4: O4, _ source5: O5, _ source6: O6)
		-> Observable<(O1.Element, O2.Element, O3.Element, O4.Element, O5.Element, O6.Element)> {
		return CombineLatest6(
			source1: source1.asObservable(), source2: source2.asObservable(), source3: source3.asObservable(), source4: source4.asObservable(), source5: source5.asObservable(), source6: source6.asObservable(),
			resultSelector: { ($0, $1, $2, $3, $4, $5) }
		)
	}
}

final class CombineLatestSink6_<E1, E2, E3, E4, E5, E6, Observer: ObserverType>: CombineLatestSink<Observer> {
	typealias Result = Observer.Element
	typealias Parent = CombineLatest6<E1, E2, E3, E4, E5, E6, Result>

	let parent: Parent

	var latestElement1: E1!
	var latestElement2: E2!
	var latestElement3: E3!
	var latestElement4: E4!
	var latestElement5: E5!
	var latestElement6: E6!

	init(parent: Parent, observer: Observer, cancel: Cancelable) {
		self.parent = parent
		super.init(arity: 6, observer: observer, cancel: cancel)
	}

	func run() -> Disposable {
		let subscription1 = SingleAssignmentDisposable()
		let subscription2 = SingleAssignmentDisposable()
		let subscription3 = SingleAssignmentDisposable()
		let subscription4 = SingleAssignmentDisposable()
		let subscription5 = SingleAssignmentDisposable()
		let subscription6 = SingleAssignmentDisposable()

		let observer1 = CombineLatestObserver(lock: self.lock, parent: self, index: 0, setLatestValue: { (e: E1) -> Void in self.latestElement1 = e }, this: subscription1)
		let observer2 = CombineLatestObserver(lock: self.lock, parent: self, index: 1, setLatestValue: { (e: E2) -> Void in self.latestElement2 = e }, this: subscription2)
		let observer3 = CombineLatestObserver(lock: self.lock, parent: self, index: 2, setLatestValue: { (e: E3) -> Void in self.latestElement3 = e }, this: subscription3)
		let observer4 = CombineLatestObserver(lock: self.lock, parent: self, index: 3, setLatestValue: { (e: E4) -> Void in self.latestElement4 = e }, this: subscription4)
		let observer5 = CombineLatestObserver(lock: self.lock, parent: self, index: 4, setLatestValue: { (e: E5) -> Void in self.latestElement5 = e }, this: subscription5)
		let observer6 = CombineLatestObserver(lock: self.lock, parent: self, index: 5, setLatestValue: { (e: E6) -> Void in self.latestElement6 = e }, this: subscription6)

		subscription1.setDisposable(self.parent.source1.subscribe(observer1))
		subscription2.setDisposable(self.parent.source2.subscribe(observer2))
		subscription3.setDisposable(self.parent.source3.subscribe(observer3))
		subscription4.setDisposable(self.parent.source4.subscribe(observer4))
		subscription5.setDisposable(self.parent.source5.subscribe(observer5))
		subscription6.setDisposable(self.parent.source6.subscribe(observer6))

		return Disposables.create([
			subscription1,
			subscription2,
			subscription3,
			subscription4,
			subscription5,
			subscription6
		])
	}

	override func getResult() throws -> Result {
		try self.parent.resultSelector(self.latestElement1, self.latestElement2, self.latestElement3, self.latestElement4, self.latestElement5, self.latestElement6)
	}
}

final class CombineLatest6<E1, E2, E3, E4, E5, E6, Result>: Producer<Result> {
	typealias ResultSelector = (E1, E2, E3, E4, E5, E6) throws -> Result

	let source1: Observable<E1>
	let source2: Observable<E2>
	let source3: Observable<E3>
	let source4: Observable<E4>
	let source5: Observable<E5>
	let source6: Observable<E6>

	let resultSelector: ResultSelector

	init(source1: Observable<E1>, source2: Observable<E2>, source3: Observable<E3>, source4: Observable<E4>, source5: Observable<E5>, source6: Observable<E6>, resultSelector: @escaping ResultSelector) {
		self.source1 = source1
		self.source2 = source2
		self.source3 = source3
		self.source4 = source4
		self.source5 = source5
		self.source6 = source6

		self.resultSelector = resultSelector
	}

	override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Result {
		let sink = CombineLatestSink6_(parent: self, observer: observer, cancel: cancel)
		let subscription = sink.run()
		return (sink: sink, subscription: subscription)
	}
}

// 7

extension ObservableType {
	/**
	 Merges the specified observable sequences into one observable sequence by using the selector function whenever any of the observable sequences produces an element.

	 - seealso: [combineLatest operator on reactivex.io](http://reactivex.io/documentation/operators/combinelatest.html)

	 - parameter resultSelector: Function to invoke whenever any of the sources produces an element.
	 - returns: An observable sequence containing the result of combining elements of the sources using the specified result selector function.
	 */
	public static func combineLatest<O1: ObservableType, O2: ObservableType, O3: ObservableType, O4: ObservableType, O5: ObservableType, O6: ObservableType, O7: ObservableType>
	(_ source1: O1, _ source2: O2, _ source3: O3, _ source4: O4, _ source5: O5, _ source6: O6, _ source7: O7, resultSelector: @escaping (O1.Element, O2.Element, O3.Element, O4.Element, O5.Element, O6.Element, O7.Element) throws -> Element)
		-> Observable<Element> {
		return CombineLatest7(
			source1: source1.asObservable(), source2: source2.asObservable(), source3: source3.asObservable(), source4: source4.asObservable(), source5: source5.asObservable(), source6: source6.asObservable(), source7: source7.asObservable(),
			resultSelector: resultSelector
		)
	}
}

extension ObservableType where Element == Any {
	/**
	 Merges the specified observable sequences into one observable sequence of tuples whenever any of the observable sequences produces an element.

	 - seealso: [combineLatest operator on reactivex.io](http://reactivex.io/documentation/operators/combinelatest.html)

	 - returns: An observable sequence containing the result of combining elements of the sources.
	 */
	public static func combineLatest<O1: ObservableType, O2: ObservableType, O3: ObservableType, O4: ObservableType, O5: ObservableType, O6: ObservableType, O7: ObservableType>
	(_ source1: O1, _ source2: O2, _ source3: O3, _ source4: O4, _ source5: O5, _ source6: O6, _ source7: O7)
		-> Observable<(O1.Element, O2.Element, O3.Element, O4.Element, O5.Element, O6.Element, O7.Element)> {
		return CombineLatest7(
			source1: source1.asObservable(), source2: source2.asObservable(), source3: source3.asObservable(), source4: source4.asObservable(), source5: source5.asObservable(), source6: source6.asObservable(), source7: source7.asObservable(),
			resultSelector: { ($0, $1, $2, $3, $4, $5, $6) }
		)
	}
}

final class CombineLatestSink7_<E1, E2, E3, E4, E5, E6, E7, Observer: ObserverType>: CombineLatestSink<Observer> {
	typealias Result = Observer.Element
	typealias Parent = CombineLatest7<E1, E2, E3, E4, E5, E6, E7, Result>

	let parent: Parent

	var latestElement1: E1!
	var latestElement2: E2!
	var latestElement3: E3!
	var latestElement4: E4!
	var latestElement5: E5!
	var latestElement6: E6!
	var latestElement7: E7!

	init(parent: Parent, observer: Observer, cancel: Cancelable) {
		self.parent = parent
		super.init(arity: 7, observer: observer, cancel: cancel)
	}

	func run() -> Disposable {
		let subscription1 = SingleAssignmentDisposable()
		let subscription2 = SingleAssignmentDisposable()
		let subscription3 = SingleAssignmentDisposable()
		let subscription4 = SingleAssignmentDisposable()
		let subscription5 = SingleAssignmentDisposable()
		let subscription6 = SingleAssignmentDisposable()
		let subscription7 = SingleAssignmentDisposable()

		let observer1 = CombineLatestObserver(lock: self.lock, parent: self, index: 0, setLatestValue: { (e: E1) -> Void in self.latestElement1 = e }, this: subscription1)
		let observer2 = CombineLatestObserver(lock: self.lock, parent: self, index: 1, setLatestValue: { (e: E2) -> Void in self.latestElement2 = e }, this: subscription2)
		let observer3 = CombineLatestObserver(lock: self.lock, parent: self, index: 2, setLatestValue: { (e: E3) -> Void in self.latestElement3 = e }, this: subscription3)
		let observer4 = CombineLatestObserver(lock: self.lock, parent: self, index: 3, setLatestValue: { (e: E4) -> Void in self.latestElement4 = e }, this: subscription4)
		let observer5 = CombineLatestObserver(lock: self.lock, parent: self, index: 4, setLatestValue: { (e: E5) -> Void in self.latestElement5 = e }, this: subscription5)
		let observer6 = CombineLatestObserver(lock: self.lock, parent: self, index: 5, setLatestValue: { (e: E6) -> Void in self.latestElement6 = e }, this: subscription6)
		let observer7 = CombineLatestObserver(lock: self.lock, parent: self, index: 6, setLatestValue: { (e: E7) -> Void in self.latestElement7 = e }, this: subscription7)

		subscription1.setDisposable(self.parent.source1.subscribe(observer1))
		subscription2.setDisposable(self.parent.source2.subscribe(observer2))
		subscription3.setDisposable(self.parent.source3.subscribe(observer3))
		subscription4.setDisposable(self.parent.source4.subscribe(observer4))
		subscription5.setDisposable(self.parent.source5.subscribe(observer5))
		subscription6.setDisposable(self.parent.source6.subscribe(observer6))
		subscription7.setDisposable(self.parent.source7.subscribe(observer7))

		return Disposables.create([
			subscription1,
			subscription2,
			subscription3,
			subscription4,
			subscription5,
			subscription6,
			subscription7
		])
	}

	override func getResult() throws -> Result {
		try self.parent.resultSelector(self.latestElement1, self.latestElement2, self.latestElement3, self.latestElement4, self.latestElement5, self.latestElement6, self.latestElement7)
	}
}

final class CombineLatest7<E1, E2, E3, E4, E5, E6, E7, Result>: Producer<Result> {
	typealias ResultSelector = (E1, E2, E3, E4, E5, E6, E7) throws -> Result

	let source1: Observable<E1>
	let source2: Observable<E2>
	let source3: Observable<E3>
	let source4: Observable<E4>
	let source5: Observable<E5>
	let source6: Observable<E6>
	let source7: Observable<E7>

	let resultSelector: ResultSelector

	init(source1: Observable<E1>, source2: Observable<E2>, source3: Observable<E3>, source4: Observable<E4>, source5: Observable<E5>, source6: Observable<E6>, source7: Observable<E7>, resultSelector: @escaping ResultSelector) {
		self.source1 = source1
		self.source2 = source2
		self.source3 = source3
		self.source4 = source4
		self.source5 = source5
		self.source6 = source6
		self.source7 = source7

		self.resultSelector = resultSelector
	}

	override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Result {
		let sink = CombineLatestSink7_(parent: self, observer: observer, cancel: cancel)
		let subscription = sink.run()
		return (sink: sink, subscription: subscription)
	}
}

// 8

extension ObservableType {
	/**
	 Merges the specified observable sequences into one observable sequence by using the selector function whenever any of the observable sequences produces an element.

	 - seealso: [combineLatest operator on reactivex.io](http://reactivex.io/documentation/operators/combinelatest.html)

	 - parameter resultSelector: Function to invoke whenever any of the sources produces an element.
	 - returns: An observable sequence containing the result of combining elements of the sources using the specified result selector function.
	 */
	public static func combineLatest<O1: ObservableType, O2: ObservableType, O3: ObservableType, O4: ObservableType, O5: ObservableType, O6: ObservableType, O7: ObservableType, O8: ObservableType>
	(_ source1: O1, _ source2: O2, _ source3: O3, _ source4: O4, _ source5: O5, _ source6: O6, _ source7: O7, _ source8: O8, resultSelector: @escaping (O1.Element, O2.Element, O3.Element, O4.Element, O5.Element, O6.Element, O7.Element, O8.Element) throws -> Element)
		-> Observable<Element> {
		return CombineLatest8(
			source1: source1.asObservable(), source2: source2.asObservable(), source3: source3.asObservable(), source4: source4.asObservable(), source5: source5.asObservable(), source6: source6.asObservable(), source7: source7.asObservable(), source8: source8.asObservable(),
			resultSelector: resultSelector
		)
	}
}

extension ObservableType where Element == Any {
	/**
	 Merges the specified observable sequences into one observable sequence of tuples whenever any of the observable sequences produces an element.

	 - seealso: [combineLatest operator on reactivex.io](http://reactivex.io/documentation/operators/combinelatest.html)

	 - returns: An observable sequence containing the result of combining elements of the sources.
	 */
	public static func combineLatest<O1: ObservableType, O2: ObservableType, O3: ObservableType, O4: ObservableType, O5: ObservableType, O6: ObservableType, O7: ObservableType, O8: ObservableType>
	(_ source1: O1, _ source2: O2, _ source3: O3, _ source4: O4, _ source5: O5, _ source6: O6, _ source7: O7, _ source8: O8)
		-> Observable<(O1.Element, O2.Element, O3.Element, O4.Element, O5.Element, O6.Element, O7.Element, O8.Element)> {
		return CombineLatest8(
			source1: source1.asObservable(), source2: source2.asObservable(), source3: source3.asObservable(), source4: source4.asObservable(), source5: source5.asObservable(), source6: source6.asObservable(), source7: source7.asObservable(), source8: source8.asObservable(),
			resultSelector: { ($0, $1, $2, $3, $4, $5, $6, $7) }
		)
	}
}

final class CombineLatestSink8_<E1, E2, E3, E4, E5, E6, E7, E8, Observer: ObserverType>: CombineLatestSink<Observer> {
	typealias Result = Observer.Element
	typealias Parent = CombineLatest8<E1, E2, E3, E4, E5, E6, E7, E8, Result>

	let parent: Parent

	var latestElement1: E1!
	var latestElement2: E2!
	var latestElement3: E3!
	var latestElement4: E4!
	var latestElement5: E5!
	var latestElement6: E6!
	var latestElement7: E7!
	var latestElement8: E8!

	init(parent: Parent, observer: Observer, cancel: Cancelable) {
		self.parent = parent
		super.init(arity: 8, observer: observer, cancel: cancel)
	}

	func run() -> Disposable {
		let subscription1 = SingleAssignmentDisposable()
		let subscription2 = SingleAssignmentDisposable()
		let subscription3 = SingleAssignmentDisposable()
		let subscription4 = SingleAssignmentDisposable()
		let subscription5 = SingleAssignmentDisposable()
		let subscription6 = SingleAssignmentDisposable()
		let subscription7 = SingleAssignmentDisposable()
		let subscription8 = SingleAssignmentDisposable()

		let observer1 = CombineLatestObserver(lock: self.lock, parent: self, index: 0, setLatestValue: { (e: E1) -> Void in self.latestElement1 = e }, this: subscription1)
		let observer2 = CombineLatestObserver(lock: self.lock, parent: self, index: 1, setLatestValue: { (e: E2) -> Void in self.latestElement2 = e }, this: subscription2)
		let observer3 = CombineLatestObserver(lock: self.lock, parent: self, index: 2, setLatestValue: { (e: E3) -> Void in self.latestElement3 = e }, this: subscription3)
		let observer4 = CombineLatestObserver(lock: self.lock, parent: self, index: 3, setLatestValue: { (e: E4) -> Void in self.latestElement4 = e }, this: subscription4)
		let observer5 = CombineLatestObserver(lock: self.lock, parent: self, index: 4, setLatestValue: { (e: E5) -> Void in self.latestElement5 = e }, this: subscription5)
		let observer6 = CombineLatestObserver(lock: self.lock, parent: self, index: 5, setLatestValue: { (e: E6) -> Void in self.latestElement6 = e }, this: subscription6)
		let observer7 = CombineLatestObserver(lock: self.lock, parent: self, index: 6, setLatestValue: { (e: E7) -> Void in self.latestElement7 = e }, this: subscription7)
		let observer8 = CombineLatestObserver(lock: self.lock, parent: self, index: 7, setLatestValue: { (e: E8) -> Void in self.latestElement8 = e }, this: subscription8)

		subscription1.setDisposable(self.parent.source1.subscribe(observer1))
		subscription2.setDisposable(self.parent.source2.subscribe(observer2))
		subscription3.setDisposable(self.parent.source3.subscribe(observer3))
		subscription4.setDisposable(self.parent.source4.subscribe(observer4))
		subscription5.setDisposable(self.parent.source5.subscribe(observer5))
		subscription6.setDisposable(self.parent.source6.subscribe(observer6))
		subscription7.setDisposable(self.parent.source7.subscribe(observer7))
		subscription8.setDisposable(self.parent.source8.subscribe(observer8))

		return Disposables.create([
			subscription1,
			subscription2,
			subscription3,
			subscription4,
			subscription5,
			subscription6,
			subscription7,
			subscription8
		])
	}

	override func getResult() throws -> Result {
		try self.parent.resultSelector(self.latestElement1, self.latestElement2, self.latestElement3, self.latestElement4, self.latestElement5, self.latestElement6, self.latestElement7, self.latestElement8)
	}
}

final class CombineLatest8<E1, E2, E3, E4, E5, E6, E7, E8, Result>: Producer<Result> {
	typealias ResultSelector = (E1, E2, E3, E4, E5, E6, E7, E8) throws -> Result

	let source1: Observable<E1>
	let source2: Observable<E2>
	let source3: Observable<E3>
	let source4: Observable<E4>
	let source5: Observable<E5>
	let source6: Observable<E6>
	let source7: Observable<E7>
	let source8: Observable<E8>

	let resultSelector: ResultSelector

	init(source1: Observable<E1>, source2: Observable<E2>, source3: Observable<E3>, source4: Observable<E4>, source5: Observable<E5>, source6: Observable<E6>, source7: Observable<E7>, source8: Observable<E8>, resultSelector: @escaping ResultSelector) {
		self.source1 = source1
		self.source2 = source2
		self.source3 = source3
		self.source4 = source4
		self.source5 = source5
		self.source6 = source6
		self.source7 = source7
		self.source8 = source8

		self.resultSelector = resultSelector
	}

	override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == Result {
		let sink = CombineLatestSink8_(parent: self, observer: observer, cancel: cancel)
		let subscription = sink.run()
		return (sink: sink, subscription: subscription)
	}
}
