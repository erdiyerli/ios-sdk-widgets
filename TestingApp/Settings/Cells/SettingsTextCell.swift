import GliaWidgets
import UIKit

class SettingsTextCell: SettingsCell {
    let textField = UITextField()

    init(title: String, text: String) {
        textField.text = text
        super.init(title: title)
        setup()
        layout()
    }

    private func setup() {
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
    }

    private func layout() {
        contentView.addSubview(textField)
        textField.autoMatch(.width, to: .width, of: contentView, withMultiplier: 0.7)
        textField.autoPinEdge(.left, to: .right, of: titleLabel, withOffset: 10, relation: .greaterThanOrEqual)
        textField.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20),
                                               excludingEdge: .left)
    }
}

final class EnvironmentSettingsTextCell: SettingsCell {
    let stackView = UIStackView()
    let segmentedControl = UISegmentedControl()
    let customTextField = UITextField()

    var environment: Environment {
        get {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                return .europe
            case 1:
                return .usa
            case 2:
                return .beta
            case 3:
                guard let customUrl = URL(string: customTextField.text ?? "") else {
                    debugPrint("Custom URL is not valid='\(customTextField.text ?? "")'. Fallback to 'beta'.")
                    return .beta
                }
                return .custom(customUrl)
            default:
                debugPrint("Environment is not supported. Fallback to 'beta'.")
                return .beta
            }
        }
        set {
            switch newValue {
            case .europe:
                segmentedControl.selectedSegmentIndex = 0
            case .usa:
                segmentedControl.selectedSegmentIndex = 1
            case .beta:
                segmentedControl.selectedSegmentIndex = 2
            case .custom(let url):
                segmentedControl.selectedSegmentIndex = 3
                customTextField.text = url.absoluteString
            }
            customTextField.isHidden = segmentedControl.selectedSegmentIndex != 3
        }
    }

    init(
        title: String,
        environment: Environment
    ) {
        super.init(title: title)
        segmentedControl.insertSegment(
            withTitle: "EU",
            at: 0,
            animated: false
        )
        segmentedControl.insertSegment(
            withTitle: "US",
            at: 1,
            animated: false
        )
        segmentedControl.insertSegment(
            withTitle: "Beta",
            at: 2,
            animated: false
        )
        segmentedControl.insertSegment(
            withTitle: "Custom",
            at: 3,
            animated: false
        )
        self.environment = environment
        setup()
        layout()
    }

    private func setup() {
        stackView.axis = .vertical
        stackView.spacing = 12
        segmentedControl.addTarget(
            self,
            action: #selector(onSegmentedControlChange),
            for: .valueChanged
        )

        customTextField.borderStyle = .roundedRect
        customTextField.autocorrectionType = .no
        customTextField.autocapitalizationType = .none
    }

    private func layout() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(segmentedControl)
        stackView.addArrangedSubview(customTextField)
        stackView.autoPinEdge(.left, to: .right, of: titleLabel, withOffset: 10)
        stackView.autoPinEdgesToSuperviewEdges(
            with: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20),
            excludingEdge: .left
        )
    }

    @objc
    private func onSegmentedControlChange(control: UISegmentedControl) {
        customTextField.isHidden = control.selectedSegmentIndex != 3
        (superview as? UITableView)?.reloadData()
    }
}
