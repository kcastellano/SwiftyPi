import Foundation
import Vapor
import Dispatch

final class JourneyController {
    
    private var droplet: Droplet
    private let bufferTime = 2
    
    init(droplet: Droplet) {
        self.droplet = droplet
    }
    
    func scheduleJourney(bytes: Bytes) throws -> String {
        let journeyParser = JourneyParser()
        let nextTrainArray = try journeyParser.parseJourney(from: bytes)

        var response: String = ""

        for nextTrain in nextTrainArray {
            let scheduleTrain = nextTrain - 2

            if  scheduleTrain > 2 {
                let response = "We will schedule the next available departure. Be ready 🏃🏽‍♀️"
                droplet.console.info("Getting departures from the BVG")
                self.scheduleResponse()
                break
            }
        }
        return response
    }
    
    func scheduleResponse(on minutes: Int) {
        let queue = DispatchQueue(label: "timer", attributes: .concurrent)
        let responseTimer = DispatchSource.makeTimerSource(queue: queue)
        
        responseTimer.scheduleOneshot(deadline: .now() + 60 * minutes, leeway: .seconds(2))
        responseTimer.setEventHandler(handler: {
            self.droplet.console.info("Journey scheduled.")
            responseTimer.cancel()
            self.scheduler()
        })
        
        responseTimer.resume()
    }
    
    func scheduler() {
        let queue = DispatchQueue(label: "timer", attributes: .concurrent)
        let turnOnPinTimer = DispatchSource.makeTimerSource(queue: queue)
        let turnOffPinTimer = DispatchSource.makeTimerSource(queue: queue)
        let pinService = PinService()

        turnOnPinTimer.scheduleOneshot(deadline: .now(), leeway: .milliseconds(30))
        
        turnOnPinTimer.setEventHandler(handler: {
            turnOffPinTimer.scheduleOneshot(deadline: .now() + 0.5, leeway: .seconds(1))
            
            turnOffPinTimer.setEventHandler(handler: {
                turnOnPinTimer.cancel()
                pinService.switchLed(status: "OFF")
                turnOffPinTimer.cancel()
            })
            
            pinService.switchLed(status: "ON")
            turnOffPinTimer.resume()
        })
        
        turnOnPinTimer.resume()
    }

}

