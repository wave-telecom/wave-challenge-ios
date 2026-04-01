import Foundation

protocol PokemonServiceProtocol {
    func fetchPokemonList(limit: Int) async throws -> PokemonListResponse
    func fetchPokemonDetails(name: String) async throws -> PokemonDetails
}

final class PokemonService: PokemonServiceProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchPokemonList(limit: Int = 151) async throws -> PokemonListResponse {
        try await apiClient.request("pokemon?limit=\(limit)")
    }

    func fetchPokemonDetails(name: String) async throws -> PokemonDetails {
        try await apiClient.request("pokemon/\(name)")
    }
}
