import Foundation
import ReactiveSwift
import Result

scopedExample("Observing a signal") {
    let numberProperty = MutableProperty<Int>(0)
    
    numberProperty.signal.observeValues { value in
        print("> \(value)")
    }
    
    numberProperty.value = 1
    numberProperty.value = 2
    numberProperty.value = 3
}


scopedExample("Using map to transform a signal") {
    let numberProperty = MutableProperty<Int>(0)
    
    numberProperty.signal
        .map { $0 * 100 }
        .observeValues { value in
            print("> \(value)")
        }
    
    numberProperty.value = 1
    numberProperty.value = 2
    numberProperty.value = 3
}


scopedExample("Filtering a signal") {
    let numberProperty = MutableProperty<Int>(0)
    
    numberProperty.signal
        .filter { $0 % 2 == 0 }
        .observeValues { value in
            print("> \(value)")
        }
    
    numberProperty.value = 1
    numberProperty.value = 2
    numberProperty.value = 3
    numberProperty.value = 4
    numberProperty.value = 5
    numberProperty.value = 6
}


scopedExample("Combining signals") {
    let leftProperty = MutableProperty<String>("")
    let rightProperty = MutableProperty<String>("")
    let leftSignal = leftProperty.signal
    let rightSignal = rightProperty.signal
    
    leftSignal.combineLatest(with: rightSignal)
        .observeValues { left, right in
            print("> \(left)\(right)")
        }
    
    leftProperty.value = "🍏"
    
    rightProperty.value = "💛"
    
    leftProperty.value = "🍇"
    
    rightProperty.value = "💙"
    rightProperty.value = "💜"
}
