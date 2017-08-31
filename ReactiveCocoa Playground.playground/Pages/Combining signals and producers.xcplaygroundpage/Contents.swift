import Foundation
import ReactiveSwift
import Result

// https://medium.com/@zxzxlch/exploring-signal-and-signalproducer-in-reactivecocoa-4-0-9aac72761e6d

let a = MutableProperty<String>("")
let b = MutableProperty<String>("")
let c = MutableProperty<String>("")


scopedExample("Combining signals") {
    
    let (lifetime, token) = Lifetime.make()
    
    Signal.combineLatest(a.signal, b.signal, c.signal)
        .take(during: lifetime)
        .observeValues { aVal, bVal, cVal in
            print("combined signals > \(aVal + bVal + cVal)")
        }

    a.value = "🍖"
    b.value = "🌏"
    // No output, still awaiting value from C to combine

    c.value = "🐔"
    // Output: combined signal = 🍖🌏🐔
    // Values from all 3 signals have been sent and combined

    a.value = "🍕"
    // Output: combined signal = 🍕🌏🐔
    
}


scopedExample("Combining signal producers") {
    
    let (lifetime, token) = Lifetime.make()
    
    SignalProducer.combineLatest(a.producer, b.producer, c.producer)
        .take(during: lifetime)
        .startWithValues { aVal, bVal, cVal in
            print("combined producers > \(aVal + bVal + cVal)")
        }
    // Output: combined producer = 🍕🌞🐔
    // SignalProducers create side-effects. The initial values are sent when the SignalProducer starts.

    c.value = "😸"
    // Output: combined producer = 🍕🌞😸
    
}

    
scopedExample("Combining signals with signal producers") {
    
    // Try a mix of a producer and two signals
    a.producer
        .lift { aSignal in
            return Signal.combineLatest(aSignal, b.signal, c.signal)
        }
        .startWithValues { aVal, bVal, cVal in
            print("combined mix > \(aVal + bVal + cVal)")
        }
    // Nothing is printed because signals B and C have not sent any values

    b.value = "🍇"
    c.value = "🍇"
    // Output: mixed producer = 🍕🍇🍇
    // All values have been sent (A has already sent an initial value because it's a SignalProducer)

    a.value = "🍇"
    // Output: mixed producer = 🍇🍇🍇

}