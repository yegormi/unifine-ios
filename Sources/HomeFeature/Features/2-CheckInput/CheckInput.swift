import APIClient
import ComposableArchitecture
import Foundation
import OSLog
import SessionClient
import SharedModels
import UniformTypeIdentifiers

private let logger = Logger(subsystem: "CheckInput", category: "CheckInput")

@Reducer
public struct CheckInput: Reducer, Sendable {
    @ObservableState
    public struct State: Equatable, Sendable {
        var request: CreateCheckRequest

        var text = ""
        var attachment: FileAttachment?
        var isUploading = false
        var showingDocumentPicker = false

        var isFormValid: Bool {
            !self.text.isEmpty || self.attachment != nil
        }

        public init(request: CreateCheckRequest) {
            self.request = request
        }
    }

    public enum Action: ViewAction {
        case delegate(Delegate)
        case `internal`(Internal)
        case view(View)

        public enum Delegate {
            case didReceiveSummary(Check)
        }

        public enum Internal {
            case uploadResponse(Result<Check, Error>)
        }

        public enum View: BindableAction {
            case binding(BindingAction<State>)
            case uploadButtonTapped
            case submitButtonTapped
            case fileAttached(FileAttachment)
            case removeAttachment
            case documentPickerFailed(Error)
        }
    }

    @Dependency(\.apiClient) var api

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer(action: \.view)

        Reduce { state, action in
            switch action {
            case .delegate:
                return .none

            case let .internal(.uploadResponse(result)):
                state.isUploading = false

                switch result {
                case let .success(check):
                    logger.info("Successfully recieved check")
                    return .send(.delegate(.didReceiveSummary(check)))
                case .failure:
                    logger.error("Failed to upload check")
                    return .none
                }

            case .view(.binding):
                return .none

            case .view(.uploadButtonTapped):
                state.showingDocumentPicker = true
                return .none

            case .view(.submitButtonTapped):
                guard state.isFormValid else { return .none }
                state.isUploading = true

                if let attachment = state.attachment {
                    let request = state.request.withFile(attachment)

                    return .run { send in
                        await send(.internal(.uploadResponse(Result {
                            try await self.api.createCheck(request)
                        })))
                    }
                } else if !state.text.isEmpty {
                    let request = state.request.withPromptText(state.text)

                    return .run { send in
                        await send(.internal(.uploadResponse(Result {
                            try await self.api.createCheck(request)
                        })))
                    }
                }

                return .none

            case let .view(.fileAttached(attachment)):
                state.attachment = attachment
                state.showingDocumentPicker = false
                return .none

            case .view(.removeAttachment):
                state.attachment = nil
                return .none

            case .view(.documentPickerFailed):
                state.showingDocumentPicker = false
                return .none
            }
        }
    }
}
