import Foundation
#if DEBUG
// swiftlint:disable function_body_length
extension ChatViewController {
    static func mock(chatViewModel: ChatViewModel = .mock()) -> ChatViewController {
        ChatViewController(
            viewModel: chatViewModel,
            viewFactory: .init(with: Theme())
        )
    }

    // MARK: - Empty Screen State
    static func mockEmptyScreen() -> ChatViewController {
        var chatViewModelEnv = ChatViewModel.Environment.mock
        chatViewModelEnv.fileManager.urlsForDirectoryInDomainMask = { _, _ in [.mock] }
        let chatViewModel = ChatViewModel.mock(environment: chatViewModelEnv)
        return .mock(chatViewModel: chatViewModel)
    }

    // MARK: - Messages from Chat Storage
    static func mockHistoryMessagesScreen() -> ChatViewController {
        var chatViewModelEnv = ChatViewModel.Environment.mock
        chatViewModelEnv.fileManager.urlsForDirectoryInDomainMask = { _, _ in [.mock] }
        let messageUuid = UUID.incrementing
        let messageId = { messageUuid().uuidString }
        let fileUuid = UUID.incrementing
        let fileId = { fileUuid().uuidString }
        let queueId = UUID.mock.uuidString
        chatViewModelEnv.chatStorage.messages = { _ in
            [
                .mock(
                    id: messageId(),
                    queueID: queueId,
                    operator: nil,
                    sender: .visitor,
                    content: "Hi",
                    attachment: nil,
                    downloads: []
                ),
                .mock(
                    id: messageId(),
                    queueID: queueId,
                    operator: .mock(name: "John Smith", pictureUrl: nil),
                    sender: .operator,
                    content: "hello",
                    attachment: nil,
                    downloads: []
                ),
                .mock(
                    id: messageId(),
                    queueID: queueId,
                    operator: nil,
                    sender: .visitor,
                    content: "",
                    attachment: .mock(
                        type: .files,
                        files: [
                            .mock(
                                id: fileId(),
                                url: .mock,
                                name: "File 1.pdf",
                                size: 1024,
                                contentType: "application/pdf",
                                isDeleted: false
                            )
                        ],
                        imageUrl: nil,
                        options: nil,
                        selectedOption: nil
                    ),
                    downloads: []
                ),
                .mock(
                    id: messageId(),
                    queueID: queueId,
                    operator: nil,
                    sender: .visitor,
                    content: "Message along with content",
                    attachment: .mock(
                        type: .files,
                        files: [
                            .mock(
                                id: fileId(),
                                url: .mockFilePath,
                                name: "File 2.mp3",
                                size: 512,
                                contentType: "audio/mpeg",
                                isDeleted: false
                            )
                        ],
                        imageUrl: nil,
                        options: nil,
                        selectedOption: nil
                    ),
                    downloads: []
                ),
                .mock(
                    id: messageId(),
                    queueID: queueId,
                    operator: .mock(
                        name: "John Doe",
                        pictureUrl: nil
                    ),
                    sender: .operator,
                    content: "",
                    attachment: .mock(
                        type: .files,
                        files: [
                            .mock(
                                id: fileId(),
                                url: .mockFilePath,
                                name: "Screen Shot.png",
                                size: 11806,
                                contentType: "image/png",
                                isDeleted: false
                            )
                        ],
                        imageUrl: nil,
                        options: nil,
                        selectedOption: nil
                    ),
                    downloads: []
                )
            ]
        }
        let chatViewModel = ChatViewModel.mock(environment: chatViewModelEnv)
        return .mock(chatViewModel: chatViewModel)
    }
}
// swiftlint:enable function_body_length
#endif
