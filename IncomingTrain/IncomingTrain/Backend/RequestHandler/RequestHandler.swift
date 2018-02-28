import Foundation

class RequestHandler {
    let endpoint = "<ADD URL OF THE PI HERE>"
    
    func executeRequest(url: URL, delegate: HTTPClientDelegate) {
        let httpClient = HTTPClient()
        httpClient.delegate = delegate
        httpClient.performRequest(url: url)
    }
}
