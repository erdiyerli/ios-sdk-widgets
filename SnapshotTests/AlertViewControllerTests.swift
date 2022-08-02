import AccessibilitySnapshot
@testable import GliaWidgets
import SnapshotTesting
import XCTest

class AlertViewControllerTests: SnapshotTestCase {
    func test_screenSharingOffer() {
        let alert = alert(with: .screenShareOffer(
            .mock(),
            accepted: {},
            declined: {}
        ))
        assertSnapshot(
            matching: alert,
            as: .accessibilityImage(precision: SnapshotTestCase.possiblePrecision),
            named: nameForDevice()
        )
    }

    func test_mediaUpgradeOffer() {
        let alert = alert(with: .singleMediaUpgrade(
            .mock(),
            accepted: {},
            declined: {}
        ))
        assertSnapshot(
            matching: alert,
            as: .accessibilityImage(precision: SnapshotTestCase.possiblePrecision),
            named: nameForDevice()
        )
    }

    func test_messageAlert() {
        let alert = alert(with: .message(
            .mock(),
            accessibilityIdentifier: nil,
            dismissed: {}
        ))
        assertSnapshot(
            matching: alert,
            as: .accessibilityImage(precision: SnapshotTestCase.possiblePrecision),
            named: nameForDevice()
        )
    }

    func test_singleAction() {
        let alert = alert(with: .singleAction(
            .mock(),
            actionTapped: {}
        ))
        assertSnapshot(
            matching: alert,
            as: .accessibilityImage(precision: SnapshotTestCase.possiblePrecision),
            named: nameForDevice()
        )
    }

    private func alert(with kind: AlertViewController.Kind) -> AlertViewController {
        AlertViewController(
            kind: kind,
            viewFactory: .mock()
        )
    }
}
