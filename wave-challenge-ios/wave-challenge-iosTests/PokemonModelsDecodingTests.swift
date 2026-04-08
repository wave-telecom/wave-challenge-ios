import XCTest
@testable import wave_challenge_ios

final class PokemonModelsDecodingTests: XCTestCase {
    func testPokemonDetailsSnakeCaseDecoding() throws {
        let json = """
        {
          "name": "bulbasaur",
          "sprites": { "front_default": "https://img.test/pokemon.png" },
          "types": [{ "type": { "name": "grass" } }],
          "abilities": [{ "ability": { "name": "overgrow" } }],
          "stats": [{ "base_stat": 45, "stat": { "name": "hp" } }]
        }
        """

        let data = Data(json.utf8)
        let decoded = try JSONDecoder().decode(PokemonDetails.self, from: data)

        XCTAssertEqual(decoded.name, "bulbasaur")
        XCTAssertEqual(decoded.sprites.frontDefault, "https://img.test/pokemon.png")
        XCTAssertEqual(decoded.stats.first?.baseStat, 45)
    }
}
