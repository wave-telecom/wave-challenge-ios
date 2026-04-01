import Foundation

final class AppContainer {
    static let shared = AppContainer()

    private let apiClient: APIClient
    private let pokemonService: PokemonServiceProtocol
    private let pokemonRepository: PokemonRepositoryProtocol

    private init() {
        self.apiClient = URLSessionAPIClient()
        self.pokemonService = PokemonService(apiClient: apiClient)
        self.pokemonRepository = PokemonRepository(service: pokemonService)
    }

    func makePokemonListViewModel() -> PokemonListViewModel {
        PokemonListViewModel(repository: pokemonRepository)
    }

    func makePokemonDetailViewModel(name: String) -> PokemonDetailViewModel {
        PokemonDetailViewModel(name: name, repository: pokemonRepository)
    }
}
