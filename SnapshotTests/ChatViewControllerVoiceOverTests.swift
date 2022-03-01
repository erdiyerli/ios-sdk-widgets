import AccessibilitySnapshot
@testable import GliaWidgets
import SnapshotTesting
import XCTest

class ChatViewControllerVoiceOverTests: SnapshotTestCase {
    func _test_messagesFromHistory() {
        let viewController = ChatViewController.mockHistoryMessagesScreen()
        viewController.view.frame = UIScreen.main.bounds
        assertSnapshot(matching: viewController, as: .accessibilityImage, named: nameForDevice())
    }
}
