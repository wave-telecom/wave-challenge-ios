import Foundation

protocol APIClient {
    func request<T: Decodable>(_ path: String) async throws -> T
}

enum APIClientError: Error {
    case invalidResponse
    case httpError(statusCode: Int)
}

final class URLSessionAPIClient: APIClient {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    func request<T: Decodable>(_ path: String) async throws -> T {
        guard let url = URL(string: path, relativeTo: APIConstants.baseURL)?.absoluteURL else {
            throw APIClientError.invalidResponse
        }
        var request = URLRequest(url: url)
        request.setValue(APIConstants.authorizationHeader, forHTTPHeaderField: "X-Authorization")

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIClientError.invalidResponse
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIClientError.httpError(statusCode: httpResponse.statusCode)
            }
            return try decoder.decode(T.self, from: data)
        } catch {
            AppLogger.error("API request failed for \(path): \(error.localizedDescription)")
            throw error
        }
    }
}
