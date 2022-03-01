#if DEBUG
import UIKit

extension UIImage {
    static let mock = UIImage(
        named: "mock-image",
        in: BundleManaging.live.current(),
        compatibleWith: nil
    ).unsafelyUnwrapped
}

#endif
