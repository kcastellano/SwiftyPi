import Foundation

protocol DeparturesRequesting {
    func didFetchDepartures(stations: [Station])
}

class DeparturesRequestHandler: RequestHandler {
    var delegate: DeparturesRequesting?
    
    func executeDeparturesRequest(with id: String) {
        guard let url = URL(string: endpoint + "departures?id=\(id)") else { return }
        executeRequest(url: url, delegate: self)
    }
}

extension DeparturesRequestHandler: HTTPClientDelegate {
    
    func success(response: Data?) {
        guard let data = response else { return }
        let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? Array<[String: Any]>
        guard let array = jsonResponse else { return }
        
        let stations = parseJSON(array: array!)
        delegate?.didFetchDepartures(stations: stations)
    }
    
    private func parseJSON(array: Array<[String: Any]>) -> [Station] {
        var arrayOfStations: [Station] = []
        for station in array {
            let direction = station["direction"] as? String
            let when = station["when"] as? String
        
            let station = Station(id: "", name: direction!, departureTime: when!)
            if !arrayOfStations.contains(station) {
                arrayOfStations.append(station)
            }
        }
        return  arrayOfStations
    }
}

