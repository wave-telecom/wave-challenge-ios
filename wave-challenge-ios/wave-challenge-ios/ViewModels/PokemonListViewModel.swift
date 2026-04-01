import Foundation

@MainActor
final class PokemonListViewModel: ObservableObject {
    @Published private(set) var state: ScreenState<[PokemonListItem]> = .idle

    private let repository: PokemonRepositoryProtocol
    private var currentTask: Task<Void, Never>?
    private var requestID: UUID?

    init(repository: PokemonRepositoryProtocol) {
        self.repository = repository
    }

    deinit {
        currentTask?.cancel()
    }

    func loadIfNeeded() {
        guard case .idle = state else { return }
        load()
    }

    func load() {
        currentTask?.cancel()

        state = .loading
        let requestID = UUID()
        self.requestID = requestID

        currentTask = Task {
            do {
                try await Task.sleep(for: .seconds(1))
                try Task.checkCancellation()
                let items = try await repository.getPokemonList()
                try Task.checkCancellation()

                guard self.requestID == requestID else { return }
                self.state = .success(items)
            } catch is CancellationError {
                return
            } catch {
                guard self.requestID == requestID else { return }
                AppLogger.error("List load failed: \(error.localizedDescription)")
                self.state = .error("Nao foi possivel carregar a lista.")
            }
        }
    }

    func retry() {
        load()
    }
}
