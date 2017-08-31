import Foundation

public func scopedExample(_ exampleDescription: String, enabled: Bool = true, _ action: () -> Void) {
    guard enabled else {
        return
    }
	print("\n--- \(exampleDescription) ---\n")
	action()
}

public enum PlaygroundError: Error {
	case example(String)
}
