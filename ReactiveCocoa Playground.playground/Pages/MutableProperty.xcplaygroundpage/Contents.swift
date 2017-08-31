import Foundation
import ReactiveSwift
import Result

scopedExample("Reading and setting current values") {
    
    let property = MutableProperty<String>("")
    
    property.signal.observeValues { value in
        print("> \(value)")
    }
    
    property.value = "🦊"
    property.value = "🐻"
    print("> property.value = \(property.value)")
    
    property.value = "🐼"
    print("> property.value = \(property.value)")
    
}


scopedExample("Binding signals to MutableProperty") {
    
    let property = MutableProperty<String>("")
    
    property.signal.observeValues { value in
        print("> \(value)")
    }
    
    // Bind with a SignalProducer
    property <~ SignalProducer<String, NoError>(["📕", "📘"])
    
    // Bind with Signal
    let (signal, observer) = Signal<String, NoError>.pipe()
    observer.send(value: "🇬🇷") // Not received by property
    property <~ signal
    observer.send(value: "🇸🇬")
    observer.send(value: "🇧🇷")
    observer.sendCompleted()
    
    // Bind with another MutableProperty
    let anotherProperty = MutableProperty("🚑")
    property <~ anotherProperty
    anotherProperty.value = "✈️"
    
}


scopedExample("Access initial/current value with producer") {
    
    let property = MutableProperty<String>("0️⃣")
    
    property.producer.startWithValues { value in
        print("> \(value)")
    }
    
    property.value = "🦊"
    property.value = "🐻"
    
}
