import Vapor

extension Droplet {
    public func setup() throws {
        try setupRoutes()
    }
}

