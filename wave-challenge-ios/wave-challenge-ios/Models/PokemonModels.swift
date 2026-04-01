import Foundation

struct PokemonListResponse: Decodable {
    let results: [Pokemon]
}

struct Pokemon: Decodable, Identifiable, Hashable {
    let name: String
    let url: String

    var id: String { name }
}

struct PokemonDetails: Decodable {
    let name: String
    let sprites: Sprites
    let types: [TypeEntry]
    let abilities: [AbilityEntry]
    let stats: [StatEntry]
}

struct Sprites: Decodable {
    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct TypeEntry: Decodable {
    let type: TypeDetails
}

struct TypeDetails: Decodable {
    let name: String
}

struct AbilityEntry: Decodable {
    let ability: AbilityDetails
}

struct AbilityDetails: Decodable {
    let name: String
}

struct StatEntry: Decodable {
    let baseStat: Int
    let stat: StatDetails

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct StatDetails: Decodable {
    let name: String
}

struct PokemonListItem: Identifiable, Hashable {
    let id: String
    let name: String
    let spriteURL: URL?
}
