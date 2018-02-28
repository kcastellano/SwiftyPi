struct Station: Codable, Equatable {
    var id: String
    var name: String
    var departureTime: String?
    
    static func ==(lhs: Station, rhs: Station) -> Bool {
         return lhs.name == rhs.name
    }
}
 
