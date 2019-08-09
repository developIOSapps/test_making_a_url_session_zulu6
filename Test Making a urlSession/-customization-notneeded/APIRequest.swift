import Foundation



enum WeatherError: Error {
    
    case badRequest
    
}



protocol APIRequest: Encodable {
    
    var query: QueryType { get }
    
}



struct GetWeather: APIRequest {
    
    private var lat: String
    
    private var long: String
    
    public var query: QueryType {
        
        return Query(path: "lat=\(lat)&lon=\(long)", httpMethod: .get)
        
    }
    
    
    
    public init(lat: String, long: String) {
        
        self.lat = lat
        
        self.long = long
        
    }
    
}
