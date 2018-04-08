import GLKit
import Mapbox
//import 

// Example view controller
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var viewControllers = [[String: Any]]()
    var tableView : UITableView!
    
    override func viewDidLoad() {
        tableView = UITableView()
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    
        loadViewControllers()
        tableView.reloadData()
    }
    
    func loadViewControllers() {
        var count = UInt32(0)
        guard let classList = objc_copyClassList(&count) else { return }
        
        for i in 0..<Int(count) {
            guard let superClassItem : AnyClass = class_getSuperclass(classList[i]) else { continue }
            let className = String(cString: class_getName(superClassItem))
            if className != "MBDBaseViewController", className.lowercased().range(of: "baseviewcontroller") != nil {
                 let className = String(cString: class_getName(classList[i]))
                viewControllers.append(["name": className, "class": classList[i]])
            }
        }
    }
    
    // MARK: tableview delgate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell?
        let className = self.viewControllers[indexPath.row]["name"] as! String?
        cell?.textLabel?.text = className
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let className = self.viewControllers[indexPath.row]["name"] as! String? else {
            return
        }
        
        var controller : UIViewController
        let storeboard = UIStoryboard(name: "Main", bundle: nil)
        let parts = className.components(separatedBy: ".")
        let identifier = parts.count > 1 ? parts[1] : className
        
        if let map = storeboard.value(forKey: "identifierToNibNameMap") as! [String: Any]?, map[identifier] != nil {
            controller = storeboard.instantiateViewController(withIdentifier: identifier)
        }
        else {
            let controllerClass = self.viewControllers[indexPath.row]["class"] as! UIViewController.Type
            controller = controllerClass.init()
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

