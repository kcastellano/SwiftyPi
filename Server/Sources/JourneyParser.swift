import Foundation
import Vapor

class JourneyParser {
    
    func parseJourney(from bytes: Bytes) throws -> [Int] {
        let data = Data(bytes: bytes)
        let array = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Array<[String: Any]>
        
        guard let journeys = array else { return [] }
        var journeysTime: [Int] = []
        
        for journey in journeys {
            guard let departure = journey["departure"] as? String else { continue }
            let nextTrain = calculateNextTrain(when: departure)
            journeysTime.append(nextTrain)
        }
        
        return journeysTime
    }
    
    private func calculateNextTrain(when: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        let date = dateFormatter.date(from: when)
        
        guard let nextTrainDate = date else { return 0 }
        
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([ .minute])
        let dateComponents = calendar.dateComponents(unitFlags, from: Date(), to: nextTrainDate)
        guard let minutes = dateComponents.minute else { return 0 }
        
        return minutes
    }
    
}

