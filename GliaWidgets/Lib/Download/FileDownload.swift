class FileDownload {
    enum Error {
        case network
        case generic
        case missingFileURL
        case deleted

        init(with error: CoreSdkClient.SalemoveError) {
            switch error.error {
            case let genericError as CoreSdkClient.GeneralError:
                switch genericError {
                case .networkError:
                    self = .network
                default:
                    self = .generic
                }
            default:
                self = .generic
            }
        }
    }

    enum State {
        case none
        case downloading(progress: ObservableValue<Double>)
        case downloaded(LocalFile)
        case error(Error)
    }

    let state = ObservableValue<State>(with: .none)
    let file: ChatEngagementFile

    private var storageID: String? {
        if let fileID = file.id, let fileName = file.name {
            return "\(fileID)/\(fileName)"
        } else {
            return nil
        }
    }
    private let storage: DataStorage
    private let environment: Environment

    init(with file: ChatEngagementFile, storage: DataStorage, environment: Environment) {
        self.file = file
        self.storage = storage
        self.environment = environment

        if file.isDeleted == true {
            state.value = .error(.deleted)
        } else if let storageID = storageID, storage.hasData(for: storageID) {
            let url = storage.url(for: storageID)
            let localFile = LocalFile(
                with: url,
                environment: .init(
                    fileManager: environment.fileManager,
                    gcd: environment.gcd,
                    localFileThumbnailQueue: environment.localFileThumbnailQueue,
                    uiImage: environment.uiImage
                )
            )
            state.value = .downloaded(localFile)
        }
    }

    func startDownload() {
        guard let fileUrl = file.url else {
            state.value = .error(.missingFileURL)
            return
        }

        let engagementFile = CoreSdkClient.EngagementFile(url: fileUrl)

        let progress = ObservableValue<Double>(with: 0)
        let onProgress: CoreSdkClient.EngagementFileProgressBlock = {
            if case .downloading(progress: let progress) = self.state.value {
                progress.value = $0.fractionCompleted
            }
        }
        let onCompletion: CoreSdkClient.EngagementFileFetchCompletionBlock = { data, error in
            if let data = data, let storageID = self.storageID {
                let url = self.storage.url(for: storageID)
                let file = LocalFile(
                    with: url,
                    environment: .init(
                        fileManager: self.environment.fileManager,
                        gcd: self.environment.gcd,
                        localFileThumbnailQueue: self.environment.localFileThumbnailQueue,
                        uiImage: self.environment.uiImage
                    )
                )
                self.storage.store(data.data, for: storageID)
                self.state.value = .downloaded(file)
            } else if let error = error {
                self.state.value = .error(Error(with: error))
            }
        }

        state.value = .downloading(progress: progress)

        environment.fetchFile(
            engagementFile,
            onProgress,
            onCompletion
        )
    }
}

extension FileDownload {
    struct AccessibilityProperties {
        var value: String?
    }

    var accessibilityProperties: AccessibilityProperties {
        .init(value: file.fileInfoString)
    }
}
