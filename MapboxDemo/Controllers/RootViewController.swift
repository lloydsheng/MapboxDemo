import GLKit
import Mapbox
//import 



// Example view controller
class RootViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
     let pageConfigraction = [
        [
            "title":"入门",
            "pages": [[
                "title":"窗口动画",
                "page":CameraAnimationViewController.self
                       ],[
                        "title":"简单标注",
                        "page":AnnotationViewController.self
                ]]
        ],
    ]
    
    var viewControllers = [[String: Any]]()
    var tableView : UITableView!
    
    override func viewDidLoad() {
        self.title = "Mapbox Demos"
        
        let action = #selector(self.onRightBarButtonPress(sender:))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logs", style: .plain, target: self, action:
        action)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Configuration.region().rawValue,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(self.onLeftBarButtonPress(sender:)))
        
        
        tableView = UITableView()
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    
        loadViewControllers()
        tableView.reloadData()
        
        var appDir = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        print("\(appDir)")
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
    
    func changeEndpint(region: MapboxMapRegion)  {
        Configuration.changeMapbRegin(region: region)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Configuration.region().rawValue,
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(self.onLeftBarButtonPress(sender:)))

    }
    
    // MARK: events
    @objc func onRightBarButtonPress(sender: UIBarButtonItem) {
        let controller = LogsViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func onLeftBarButtonPress(sender: UIBarButtonItem) {
        if Configuration.region() == .cn {
             self.changeEndpint(region: .com)
        }
        else {
             self.changeEndpint(region: .cn)
        }
//        let optionMenu = UIAlertController(title: nil, message: "Choose Endpoint", preferredStyle: .actionSheet)
//
//        let deleteAction = UIAlertAction(title: "CN Endpoint", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            self.changeEndpint(region: .cn)
//        })
//        let saveAction = UIAlertAction(title: "Com Endpoint", style: .default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            self.changeEndpint(region: .com)
//        })
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
//            (alert: UIAlertAction!) -> Void in
//
//        })
//
//        optionMenu.addAction(deleteAction)
//        optionMenu.addAction(saveAction)
//        optionMenu.addAction(cancelAction)
//
//        self.present(optionMenu, animated: true, completion: nil)
    }
    
    // MARK: tableview delgate
    func numberOfSections(in tableView: UITableView) -> Int {
        return pageConfigraction.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewControllers.count
//        return (pageConfigraction[section] as! Dictionary ["pages"] as! Array).count
        let configuration = pageConfigraction[section]
        let controllers = configuration["pages"] as? [Any]
        return controllers!.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "入门"
        return label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell?
//        let className = self.viewControllers[indexPath.row]["name"] as! String?
        let configuration = pageConfigraction[indexPath.section]
        let controllers = configuration["pages"] as? [[String: Any]]
        let title = controllers![indexPath.row]["title"] as? String
        
        cell?.textLabel?.text = title
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let className = self.viewControllers[indexPath.row]["name"] as! String? else {
//            return
//        }
//
//        var controller : UIViewController
//        let storeboard = UIStoryboard(name: "Main", bundle: nil)
//        let parts = className.components(separatedBy: ".")
//        let identifier = parts.count > 1 ? parts[1] : className
//
//        if let map = storeboard.value(forKey: "identifierToNibNameMap") as! [String: Any]?, map[identifier] != nil {
//            controller = storeboard.instantiateViewController(withIdentifier: identifier)
//        }
//        else {
//            let controllerClass = self.viewControllers[indexPath.row]["class"] as! UIViewController.Type
//            controller = controllerClass.init()
//        }
        
        let configuration = pageConfigraction[indexPath.section]
        let controllers = configuration["pages"] as? [[String: Any]]
        let controllerClass = controllers![indexPath.row]["page"] as? UIViewController.Type
        let className = NSStringFromClass(controllerClass!)
//        let controller = controllers[indexPath.row]
        
        
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

