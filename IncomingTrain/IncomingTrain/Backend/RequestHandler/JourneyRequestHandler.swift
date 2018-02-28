import Foundation

protocol JourneyRequesting {
    func didScheduleDeparture(message: String)
}

class JourneyRequestHandler: RequestHandler {
    var delegate: JourneyRequesting?
    
    func executeJourneyRequest(departureId: String, arrivalId: String) {
        guard let url = URL(string: endpoint + "scheduleJourney?departureId=\(departureId)&arrivalId=\(arrivalId)") else { return }
        executeRequest(url: url, delegate: self)
    }
    
}

extension JourneyRequestHandler: HTTPClientDelegate {
    
    func success(response: Data?) {
        guard
            let data = response,
            let response = String(data: data, encoding: .utf8)
        else { return }
        delegate?.didScheduleDeparture(message: response)
    }
    
    private func parseJSON(array: [String]) -> [String] {
        var arrayOfJourneys: [String] = []
        for journey in array {
            if !arrayOfJourneys.contains(journey) {
                arrayOfJourneys.append(journey)
            }
        }
        return  arrayOfJourneys
    }
}

