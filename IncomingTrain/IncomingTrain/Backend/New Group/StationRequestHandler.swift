import Foundation

protocol StationRequesting {
    func didFetchStations(stations: [Station])
}

class StationRequestHandler: RequestHandler {
    var delegate: StationRequesting?
    var latitude: Float = 52.512343993
    var longitude: Float = 13.47502833
    
    func executeRequest() {
        guard let url = URL(string: endpoint + "coordinates?latitude=\(latitude)&longitude=\(longitude)") else { return }
        executeRequest(url: url, delegate: self)
    }
    
    private func loadJSON(fileName: String) throws -> String {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                guard let response = String(data: data, encoding: .utf8) else { return "" }
                
                return response
            } catch {
                return ""
            }
        }
        return ""
    }
}

extension StationRequestHandler: HTTPClientDelegate {
    
    func success(response: Data?) {
        guard let data = response else { return }
        guard let stations = try? JSONDecoder().decode([Station].self, from: data) else { return }
        
        delegate?.didFetchStations(stations: stations)
    }
}
