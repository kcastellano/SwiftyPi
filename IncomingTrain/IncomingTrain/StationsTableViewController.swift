import UIKit

protocol StationsTableViewSelecting {
    func returnSelectedStation(station: Station)
}

class StationTableViewController: UITableViewController {
    
    public var delegate: StationsTableViewSelecting?
    public var stations: [Station]?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath)
        
        cell.textLabel?.text = stations?[indexPath.row].name
        cell.textLabel?.textColor = UIColor.lightGray
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let station = stations?[indexPath.row] else { return }
        delegate?.returnSelectedStation(station: station)
        self.navigationController?.popViewController(animated: true)
    }
}
