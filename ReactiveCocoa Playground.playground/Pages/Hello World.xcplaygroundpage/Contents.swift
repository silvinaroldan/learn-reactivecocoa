import Foundation
import ReactiveSwift
import Result

SignalProducer<String, NoError>(["Hello", "iOS", "Dev", "Scout"])
    .startWithValues { value in
        print(value)
    }
