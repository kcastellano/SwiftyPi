import UIKit
import CoreLocation

class MainMenuViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var departureStackView: UIStackView!
    @IBOutlet weak var arrivalStackView: UIStackView!
    
    private var stations: [Station]?
    private var isInitialStationSet = false
    private var selectedDepartureId: String?
    private var selectedArrivalId: String?
    private let segueName = "stationSegue"
    
    var locationManager = CLLocationManager()
    var longitude: CLLocationDegrees?
    var latitude: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
        setUpGestureRecognizers()
    }
    
    // MARK : UITapGestureRecognizers
    
    func setUpGestureRecognizers() {
        let gestureRecognizerDeparture = UITapGestureRecognizer(target: self, action: #selector(listDepartureStations))
        departureStackView.addGestureRecognizer(gestureRecognizerDeparture)
        
        let gestureRecognizerArrival = UITapGestureRecognizer(target: self, action: #selector(listArrivalStations))
        arrivalStackView.addGestureRecognizer(gestureRecognizerArrival)
    }
    
    @objc func listDepartureStations() {
        cleanUpFields()
        requestNearStations()
    }
    
    @objc func listArrivalStations() {
        guard let stationId = selectedDepartureId else { return }
        requestDepartures(with: stationId)
    }
    
    // MARK: CLLocationManagerDelegate
    
    func setUpLocationManager() {
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
    }
    
    // MARK: RequestHandlers
    
    
    func requestNearStations() {
        let stationRequestHandler = StationRequestHandler()
        stationRequestHandler.delegate = self
        
        guard
            let longitude = longitude,
            let latitude = latitude
        else { return }
        
        stationRequestHandler.longitude = Float(longitude)
        stationRequestHandler.latitude = Float(latitude)
        stationRequestHandler.executeRequest()
    }
    
    func requestDepartures(with id:String) {
        let departuresRequestHandler = DeparturesRequestHandler()
        departuresRequestHandler.delegate = self
        departuresRequestHandler.executeDeparturesRequest(with: id)
    }
    
    func requestJourneys() {
        let journeyRequestHandler = JourneyRequestHandler()
        journeyRequestHandler.delegate = self

        guard
            let departureId = selectedDepartureId,
            let arrivalId = selectedArrivalId
        else { return }

        journeyRequestHandler.executeJourneyRequest(departureId: departureId, arrivalId: arrivalId)
    }
    
    @IBAction func scheduleJourney(_ sender: Any) {
        requestJourneys()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let stationTableViewController = segue.destination as? StationTableViewController else { return }
        stationTableViewController.delegate = self
        stationTableViewController.stations = stations
    }
    
    func cleanUpFields() {
        departureLabel.text = ""
        arrivalLabel.text = ""
        departureLabel.isHidden = true
        arrivalLabel.isHidden = true
        isInitialStationSet = false
    }
}


// MARK: StationRequesting

extension MainMenuViewController: StationRequesting {
    func didFetchStations(stations: [Station]) {
        self.stations = stations
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: self.segueName, sender: nil)
        }
    }
}

// MARK: DeparturesRequesting

extension MainMenuViewController: DeparturesRequesting {
    func didFetchDepartures(stations: [Station]) {
        self.stations = stations
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: self.segueName, sender: nil)
        }
    }
}

// MARK: JourneyRequesting

extension MainMenuViewController: JourneyRequesting {
    func didScheduleDeparture(message: String) {
        let alertController = UIAlertController(title: "Scheduling Journey", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: StationsTableViewSelecting

extension MainMenuViewController: StationsTableViewSelecting {
    func returnSelectedStation(station: Station) {
        if !isInitialStationSet {
            setUpDepartureLabel(station)
            isInitialStationSet = true
        } else {
            setUpArrivalLabel(station)
            isInitialStationSet = false
        }       
    }
    
    func setUpDepartureLabel(_ station: Station) {
        selectedDepartureId = station.id
        departureLabel.text = station.name
        departureLabel.isHidden = false
    }
    
    func setUpArrivalLabel(_ station: Station) {
        selectedArrivalId = station.id
        arrivalLabel.text = station.name
        arrivalLabel.isHidden = false
    }
}

