import PlaygroundSupport
import Foundation
import ReactiveSwift
import Result

// We'll be dealing with asynchronnous operations so…
PlaygroundPage.current.needsIndefiniteExecution = true


scopedExample("Asynchronous operations") {
    
    SignalProducer<(), NoError> { observer, lifetime in
        print("> Starting timer")
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            observer.send(value: ())
            observer.sendCompleted()
        }
    }
    
}


scopedExample("Delayed function call") {
    
    // SignalProducer.empty sends a .complete event without sending any values
    // Use startWithCompleted instead of startWithValues
    SignalProducer<(), NoError>.empty
        .delay(3, on: QueueScheduler.main)
        .startWithCompleted {
            print("Delayed function call> Completed")
        }
    
}


scopedExample("Convert sequences to streams and back") {
    
    SignalProducer<String, NoError>(["☝️", "✌️", "👌"])
        .map { "\($0)\($0)" }
        .collect()
        .startWithValues { value in
            print("> \(value)")
        }
    
}


scopedExample("Simultaneous network requests") {
    
    let queries = ["the chain", "nikes", "formation"]
    
    SignalProducer<String, NoError>(queries)
        .flatMap(.merge) { query -> SignalProducer<(Data, URLResponse), NoError> in
            var components = URLComponents(string: "https://itunes.apple.com/search")!
            components.queryItems = [
                URLQueryItem(name: "term", value: query),
                URLQueryItem(name: "media", value: "music"),
                URLQueryItem(name: "entity", value: "song"),
            ]
            
            let request = URLRequest(url: components.url!)
            
            return URLSession.shared.reactive.data(with: request)
                .flatMapError { error -> SignalProducer<(Data, URLResponse), NoError> in
                    return .empty
                }
        }
        .map { data, response -> String in
            let json = try! JSONSerialization.jsonObject(with: data) as! [String : Any]
            
            if let result = (json["results"] as? [Any])?.first as? [String : Any],
                let artist = result["artistName"] as? String,
                let trackName = result["trackName"] as? String {
                return "\(artist) - \(trackName)"
            }
            
            return "Not found"
        }
        .startWithValues { result in
            print("> \(result)")
        }
    
}




