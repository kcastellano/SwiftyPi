import Foundation

protocol StationRequesting {
    func didFetchStations(stations: [Station])
}

class StationRequestHandler {
    
    private var httpClient: HTTPClient?
    var delegate: StationRequesting?
    
    func executeRequest() {
        guard let url = URL(string: "http://192.168.2.132:8080/coordinates?latitude=52.512343993&longitude=13.47502833") else { return }
        httpClient = HTTPClient()
        httpClient?.delegate = self
        httpClient?.performRequest(url: url)
    }
    
}

extension StationRequestHandler: HTTPClientDelegate {
    
    func success(response: Data?) {
        guard let data = response else { return }
        guard let stations = try? JSONDecoder().decode([Station].self, from: data) else { return }
        
        delegate?.didFetchStations(stations: stations)
    }
}
