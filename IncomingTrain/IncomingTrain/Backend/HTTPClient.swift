import Foundation

protocol HTTPClientDelegate: class {
    func success(response: Data?)
}

class HTTPClient {
    
    private let session: URLSession?
    var delegate: HTTPClientDelegate?
    
    init() {
        self.session = .shared
    }
    
    public func performRequest(url: URL) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session?.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil, let data = data else {
                return
            }
            
            self.delegate?.success(response: data)
            
        })
        task?.resume()
    }
    
}
