import Vapor
import Dispatch
import Foundation

extension Droplet {
    func setupRoutes() throws {
        get("departures") { request in
            guard let stationId = request.data["id"]?.string else { throw Abort.badRequest }
            let queryDeparturesURL =  "https://2.vbb.transport.rest/stations/\(stationId)/departures"
            let response = try self.client.get(queryDeparturesURL, query: ["maxQueries": 1,
                                                                           "results": 10], [:], nil, through:[])

            return response.json ?? "[]"
        }
        
        
        get("coordinates") { request in
            guard
                let latitude = request.data["latitude"]?.string,
                let longitude = request.data["longitude"]?.string else {
                    throw Abort.badRequest
            }

            let queryStationsURL = "https://2.vbb.transport.rest/stations/nearby?latitude=\(latitude)&longitude=\(longitude)&results=3&distance=1500"
            let response = try self.client.get(queryStationsURL)

            return response.json ?? "[]"
        }
        
        get("scheduleJourney") { request in
            guard
                let departureId = request.data["departureId"]?.string,
                let arrivalId = request.data["arrivalId"]?.string else {
                    throw Abort.badRequest
            }

            let queryJourneysURL = "https://2.vbb.transport.rest/journeys?from=\(departureId)&to=\(arrivalId)&results=3"

            let response = try self.client.get(queryJourneysURL)
            guard let bytes = response.body.bytes else { return "Nothing to see" }
            
            let journeyController = JourneyController(droplet: self)
            return try journeyController.scheduleJourney(bytes: data.makeBytes())
        }
    
    }    
}


