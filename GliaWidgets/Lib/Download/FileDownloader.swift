import SalemoveSDK

class FileDownloader {
    enum AutoDownload {
        case nothing
        case images
    }

    private var downloads = [String: FileDownload]()
    private var storage = FileSystemStorage(directory: .documents)

    func downloads(for files: [ChatEngagementFile]?,
                   autoDownload: AutoDownload = .nothing) -> [FileDownload] {
        guard let files = files else { return [] }

        let downloads = files.compactMap { download(for: $0) }

        switch autoDownload {
        case .images:
            downloadImages(for: downloads)
        case .nothing:
            break
        }

        return downloads
    }

    func download(for file: ChatEngagementFile) -> FileDownload? {
        guard let fileID = file.id else { return nil }

        if let download = downloads[fileID] {
            return download
        } else {
            return addDownload(for: file)
        }
    }

    func addDownloads(for files: [ChatEngagementFile]?, with uploads: [FileUpload]) {
        guard let files = files else { return }

        files.forEach { file in
            if let upload = uploads.first(where: { $0.engagementFileInformation?.id == file.id }) {
                self.addDownload(for: file, localFile: upload.localFile)
            }
        }
    }

    @discardableResult
    private func addDownload(for file: ChatEngagementFile, localFile: LocalFile? = nil) -> FileDownload? {
        guard let fileID = file.id else { return nil }

        if let download = downloads[fileID] {
            return download
        } else {
            let download = FileDownload(
                with: file,
                storage: storage,
                localFile: localFile
            )
            downloads[fileID] = download
            return download
        }
    }

    private func downloadImages(for downloads: [FileDownload]) {
        downloads
            .filter { $0.file.isImage }
            .filter {
                switch $0.state.value {
                case .none, .error:
                    return true
                case .downloading, .downloaded:
                    return false
                }
            }
            .forEach { $0.startDownload() }
    }
}