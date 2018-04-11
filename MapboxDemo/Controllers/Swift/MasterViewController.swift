//
//  MasterViewController.swift
//  MapboxDemo
//
//  Created by mapboxchina on 11/04/2018.
//  Copyright © 2018 lloydsheneg. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController : UINavigationController!
    let pageConfigraction = [
        [
            "title":"入门",
            "pages": [
                [
                "title":"窗口动画",
                "page":CameraAnimationViewController.self
                ],
                [
                    "title":"简单标注",
                    "page":AnnotationViewController.self
                ]
            ]
        ],
        [
            "title":"标注与提示",
            "pages": [
                [
                    "title":"自定义线条和标注",
                    "page": CustomAnnotationViewController.self
                ],
                [
                    "title":"图片和视图标注",
                    "page": ImageAnnotationViewController.self
                ]
            ]
        ],
        [
            "title":"线与多边形",
            "pages": [
                [
                    "title":"动画描线",
                    "page": AnimateLinesViewController.self
                ],
            ]
        ],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let splitViewController = self.splitViewController
        {
            splitViewController.presentsWithGesture = false
            detailViewController = splitViewController.viewControllers.last as! UINavigationController
            detailViewController.viewControllers = [CameraAnimationViewController()]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let configuration = pageConfigraction[section]
        let title = configuration["title"] as? String
        
        let view = UIView()
        view.backgroundColor = .white
        view.bounds = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        let label = UILabel()
        label.frame = CGRect(x: 12, y: 0, width: tableView.bounds.width - 24, height: 44)
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        view.addSubview(label)

        return view
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return pageConfigraction.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let configuration = pageConfigraction[section]
        let controllers = configuration["pages"] as? [Any]
        return controllers!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let configuration = pageConfigraction[indexPath.section]
        let controllers = configuration["pages"] as? [[String: Any]]
        let title = controllers![indexPath.row]["title"] as? String
        
        cell.textLabel?.text = title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let configuration = pageConfigraction[indexPath.section]
        let controllers = configuration["pages"] as? [[String: Any]]
        let controllerClass = controllers![indexPath.row]["page"] as! UIViewController.Type
        let className = NSStringFromClass(controllerClass)
        
        var controller : UIViewController
        let storeboard = UIStoryboard(name: "Main", bundle: nil)
        let parts = className.components(separatedBy: ".")
        
        let identifier = parts.count > 1 ? parts[1] : className
        
        if let map = storeboard.value(forKey: "identifierToNibNameMap") as! [String: Any]?, map[identifier] != nil {
            controller = storeboard.instantiateViewController(withIdentifier: identifier)
        }
        else {
            controller = controllerClass.init()
        }
        
        self.splitViewController?.showDetailViewController(UINavigationController(rootViewController: controller), sender: self) 
//        detailViewController.viewControllers = [controller]
    }
}
