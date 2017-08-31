import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

// These examples will not run in a playground but you can test them out in an iOS app.

scopedExample("Observing text field updates", enabled: false) {
    
    let textfield = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
    
    textfield.reactive.continuousTextValues
        .combinePrevious()
        .observeValues { prev, current in
            // Do something with new textfield value
        }
    
}


scopedExample("Observing notifications", enabled: false) {
    
    // Observe the first time application enters background
    NotificationCenter.default.reactive.notifications(forName: .UIApplicationDidEnterBackground, object: nil)
        .take(first: 1)
        .observeValues { notification in
            // Do something
        }
    
}


scopedExample("Observing user defaults", enabled: false) {
    
    // Change color scheme with user defaults changes
    UserDefaults.standard.reactive.signal(forKeyPath: "ColorSchemeSetting")
        .map { $0 as! Int }
        .skipRepeats()
        .observeValues { schemeType in
            switch schemeType {
            case 1:
                // Dark mode
                break
            default:
                // Default scheme
                break
            }
    }
    
}


scopedExample("View controller communication", enabled: false) {
    
    class RootViewController: UIViewController {
        
        func presentEditViewController() {
            let editViewController = EditViewController()
            
            editViewController.didFinishEditingSignal.observeValues {
                // Update UI with edited values
            }
            
            present(editViewController, animated: true)
        }
        
    }
    
    class EditViewController: UIViewController {
        private let didFinishEditingPipe = Signal<(), NoError>.pipe()
        
        var didFinishEditingSignal: Signal<(), NoError> {
            return didFinishEditingPipe.output
        }
        
        deinit {
            didFinishEditingPipe.input.sendCompleted()
        }
        
        func doneButtonDidTap() {
            didFinishEditingPipe.input.send(value: ())
        }
        
    }

}
