import XCTest
@testable import wave_challenge_ios

@MainActor
final class PokemonListViewModelTests: XCTestCase {
    func testLoadSuccessUpdatesToSuccessState() async {
        let repository = PokemonRepositoryMock()
        repository.listResult = .success([PokemonListItem(id: "1", name: "Bulbasaur", spriteURL: nil)])
        let viewModel = PokemonListViewModel(repository: repository)

        viewModel.load()
        try? await Task.sleep(for: .milliseconds(1200))

        guard case .success(let items) = viewModel.state else {
            return XCTFail("Expected success state")
        }
        XCTAssertEqual(items.count, 1)
    }

    func testLoadErrorUpdatesToErrorState() async {
        let repository = PokemonRepositoryMock()
        repository.listResult = .failure(MockError.generic)
        let viewModel = PokemonListViewModel(repository: repository)

        viewModel.load()
        try? await Task.sleep(for: .milliseconds(1200))

        guard case .error = viewModel.state else {
            return XCTFail("Expected error state")
        }
    }
}

private enum MockError: Error {
    case generic
}

private final class PokemonRepositoryMock: PokemonRepositoryProtocol {
    var listResult: Result<[PokemonListItem], Error> = .success([])

    func getPokemonList() async throws -> [PokemonListItem] {
        try listResult.get()
    }

    func getPokemonDetails(name: String) async throws -> PokemonDetails {
        throw MockError.generic
    }
}
