import SwiftyGPIO
import Foundation

class PinService: NSObject {
    private let gpios: [GPIOName: GPIO]
    private let selectedPin: GPIO
    
    override init() {
        self.gpios = SwiftyGPIO.GPIOs(for: .RaspberryPi3)
        guard let pin = gpios[.P4] else {
            fatalError("Unable to initialise the GPIO pin")
        }
        
        self.selectedPin = pin
        self.selectedPin.direction = .OUT
    }
    
    func switchLed(status: String) {
        if status == "ON" {
            selectedPin.value = 1
        } else {
            selectedPin.value = 0
        }
    }
}
