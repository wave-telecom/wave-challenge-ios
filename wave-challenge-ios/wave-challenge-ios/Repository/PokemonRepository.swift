import Foundation

protocol PokemonRepositoryProtocol {
    func getPokemonList() async throws -> [PokemonListItem]
    func getPokemonDetails(name: String) async throws -> PokemonDetails
}

final class PokemonRepository: PokemonRepositoryProtocol {
    private let service: PokemonServiceProtocol
    private var detailsCache: [String: PokemonDetails] = [:]

    init(service: PokemonServiceProtocol) {
        self.service = service
    }


    func getPokemonList() async throws -> [PokemonListItem] {
        // TODO: make limit configurable
        let response = try await service.fetchPokemonList(limit: 151)
        return response.results.map { pokemon in
            PokemonListItem(
                id: pokemonID(fromPokemonURL: pokemon.url) ?? 0,
                name: pokemon.name.capitalized,
                spriteURL: spriteURL(forPokemonURL: pokemon.url)
            )
        }
    }

    func getPokemonDetails(name: String) async throws -> PokemonDetails {
        if let cached = detailsCache[name] {
            return cached
        }
        let details = try await service.fetchPokemonDetails(name: name)
        detailsCache[name] = details
        return details
    }

    private func pokemonID(fromPokemonURL pokemonURL: String) -> Int? {
        guard
            let idString = pokemonURL.split(separator: "/").last(where: { Int($0) != nil }),
            let id = Int(idString)
        else {
            return nil
        }
        return id
    }

    private func spriteURL(forPokemonURL pokemonURL: String) -> URL? {
        guard let id = pokemonID(fromPokemonURL: pokemonURL) else {
            return nil
        }
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
    }
}

