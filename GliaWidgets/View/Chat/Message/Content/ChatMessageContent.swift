import UIKit

enum ChatMessageContent {
    case text(String, accessibility: TextAccessibilityProperties)
    case files([LocalFile])
    case downloads([FileDownload])
    case choiceCard(ChoiceCard)

    struct TextAccessibilityProperties {
        let label: String
        let value: String
    }
}

enum ChatMessageContentAlignment {
    case left
    case right
}
