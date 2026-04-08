import Foundation
import Combine

struct PokemonDetailPresentation {
    let name: String
    let imageURL: URL?
    let typesText: String
    let abilitiesText: String
    let statsText: String
}

@MainActor
final class PokemonDetailViewModel: ObservableObject {
    @Published private(set) var state: ScreenState<PokemonDetailPresentation> = .idle

    private let name: String
    private let repository: PokemonRepositoryProtocol
    private var currentTask: Task<Void, Never>?
    private var requestID: UUID?

    init(name: String, repository: PokemonRepositoryProtocol) {
        self.name = name
        self.repository = repository
    }


    func retry() {
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
                let details = try await repository.getPokemonDetails(name: name)
                try Task.checkCancellation()

                // map API model to strings for the view
                let nm = details.name.capitalized
                let typesArr = details.types.map(\.type.name)
                let abArr = details.abilities.map(\.ability.name)
                let stArr = details.stats.map { "\($0.stat.name): \($0.baseStat)" }
                let presentation = PokemonDetailPresentation(
                    name: nm,
                    imageURL: URL(string: details.sprites.frontDefault ?? ""),
                    typesText: "Types: " + typesArr.joined(separator: ", "),
                    abilitiesText: "Abilities: " + abArr.joined(separator: ", "),
                    statsText: "Stats: " + stArr.joined(separator: ", ")
                )

                guard self.requestID == requestID else { return }
                self.state = .success(presentation)
            } catch is CancellationError {
                return
            } catch {
                guard self.requestID == requestID else { return }
                AppLogger.error("Detail load failed for \(name): \(error.localizedDescription)")
                self.state = .error("Nao foi possivel carregar o detalhe.")
            }
        }
    }

    func loadIfNeeded() {
        guard case .idle = state else { return }
        load()
    }

    deinit {
        currentTask?.cancel()
    }
}
