//
//  ObservableProperty.swift
//  ReSwiftRx
//
//  Created by Charlotte Tortorella on 29/11/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

public final class ObservableProperty<ValueType>: ObservablePropertyType {
    internal typealias ObservablePropertySubscriptionReferenceType =
        ObservablePropertySubscriptionReference<ValueType>
    internal var subscriptions = [ObservablePropertySubscriptionReferenceType : (ValueType) -> ()]()
    private var subscriptionToken: Int = 0
    public var value: ValueType {
        didSet {
            subscriptions.forEach { $0.value(value) }
        }
    }

    public init(_ value: ValueType) {
        self.value = value
    }

    @discardableResult
    public func subscribe(_ function: @escaping (ValueType) -> Void) -> SubscriptionReferenceType? {
        defer { subscriptionToken += 1 }
        defer { function(value) }
        let reference = ObservablePropertySubscriptionReferenceType(key: String(subscriptionToken),
                                                            stream: self)
        subscriptions.updateValue(function, forKey: reference)
        return reference
    }

    internal func unsubscribe(reference: ObservablePropertySubscriptionReferenceType) {
        subscriptions.removeValue(forKey: reference)
    }
}