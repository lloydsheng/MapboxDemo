import GLKit
import Mapbox
//import

// Example view controller
class LogsViewController: MBDBaseViewController, UITableViewDataSource {
    
    var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .custom)
        button.setTitle("Clean", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        button.layer.cornerRadius = 5
        button.backgroundColor = .blue
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 25)
        button.addTarget(self, action: #selector(cleanLogs), for: UIControlEvents.touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.rightBarButtonItem = barButton
        
        self.navigationItem.title = "Logs"
        self.view.backgroundColor = .white
        let tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.reloadData()
        self.tableView = tableView
    }
    
    @objc func cleanLogs(){
        UserDefaults.standard.removeObject(forKey: "TelemetryTestLogs")
        UserDefaults.standard.synchronize()
        tableView.reloadData()
    }
    
    func getLogs() -> [NSDictionary] {
        if let logs = UserDefaults.standard.value(forKey: "TelemetryTestLogs") {
            return (logs as! [NSDictionary]).reversed()
        }
    
        return []
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let logs = getLogs()
        print("log count = \(logs.count)")
        return logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let logs = getLogs()
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "log_cell")
        let log = logs[indexPath.row]
        let time = log.value(forKey: "time") as! NSNumber
    
        cell.textLabel?.text = "\(NSDate(timeIntervalSince1970: time.doubleValue))"
        cell.detailTextLabel?.text = log.value(forKey: "message") as! String?
        return cell
    }
    
}


