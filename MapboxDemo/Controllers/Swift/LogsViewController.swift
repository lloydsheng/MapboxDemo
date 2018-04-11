import GLKit
import Mapbox
//import

// Example view controller
class LogsViewController: UIViewController, UITableViewDataSource {
    
    var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Logs"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clean", style: .plain, target: self, action: #selector(self.onRightBarButtonPress(sender:)))
        

        self.view.backgroundColor = .white
        let tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.reloadData()
        self.tableView = tableView
    }
    
    @objc func onRightBarButtonPress(sender: UIBarButtonItem){
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


