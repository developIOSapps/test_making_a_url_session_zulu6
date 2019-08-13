//
//  ViewController.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 5/15/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import UIKit




enum NetworkError: Error {
    case domainError
    case decodingError
}

class TableViewController: UITableViewController {

    var deviceGroups: [DeviceGroup] = []
    var users: [User] = []
    
    
    fileprivate func doSideStuff() {
        _ = DeviceGroupResponse.loadTheData()
        let str = "{\"foo\": \"bar\"}".data(using: .utf8)!.prettyPrintedJSONString2!
        print(str)
        /* prints:
         {
         "foo" : "bar"
         }
         */
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let whatToDo = 2
        
        switch whatToDo {
        case 1:
            GetDataApi.getUserListResponse { (xyz) in
                DispatchQueue.main.async {
                    guard let usrResponse = xyz as? UserResponse else {fatalError("could not convert it to Users")}
                    let user = usrResponse.users.first
                    print(String(repeating: "\(String(describing: user?.firstName))  " , count: 5))
                    
                    self.users = usrResponse.users
                    
                    self.users.forEach { print($0.firstName + $0.lastName) }
                    
                    // self.tableView.reloadData()
                }
            }
        case 2:
            GetDataApi.getDeviceGroupResponse { (dvcgr) in
                DispatchQueue.main.async {
                    guard let dvcg = dvcgr as? DeviceGroupResponse else {fatalError("could not convert it to devicegroup")}
                    let deviceGroup = dvcg.deviceGroups.first
                    print(String(repeating: "\(String(describing: deviceGroup?.name))  " , count: 5))
                    
                    self.deviceGroups = dvcg.deviceGroups
                    
                    self.tableView.reloadData()
                }
            }
        default:
            break
        }
        
        
//
//        doSideStuff()
 
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return deviceGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = deviceGroups[indexPath.row].name
        return cell
    }

}


extension TableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        var detailVC = segue.destination as! DetailViewController
        detailVC.deviceGroup = deviceGroups[(indexPath?.row)!]
    }
}

extension TableViewController {
    
    /*
    
    // MARK: - Used just to keep remember things not needed
    fileprivate func getZuluData4(with urlRequest: URLRequest,
                                  then completion: @escaping (Result<Data, NetworkError>)
        -> Void) {
        
        /// create URL Session - default config
        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config)
        
        /// create a data session
        let task = urlSession.dataTask(with: urlRequest) { (data, response, err) in
            
            guard let data = data, err == nil  else {
                if let err = err as NSError?, err.domain == NSURLErrorDomain {
                    completion(.failure(NetworkError.domainError))
                } else {
                    completion(.failure(NetworkError.decodingError))
                }
                return
            }
            
            completion(.success(data))
            
        }
        task.resume()
    }
    
    func toGetZuluData4() {
        
        /// create the request
        
        /// create a URL
        let url = URL(string: "https://api.zuludesk.com/devices/groups")!
        
        /// create a URL Request
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Basic NTM3MjI0NjA6RVBUTlpaVEdYV1U1VEo0Vk5RUDMyWDVZSEpSVjYyMkU=", forHTTPHeaderField: "Authorization")
        
        
        
        /// do the call
        
        getZuluData4(with: urlRequest) { (result) in
            
            switch result {
                
            case .success(let data):
                let jsonStr: NSString = {
                    
                    guard   let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []),
                        let prettyData = try? JSONSerialization.data(withJSONObject: jsonObj, options: [.prettyPrinted]),
                        let jsonStr = NSString(data: prettyData, encoding: String.Encoding.utf8.rawValue)
                        else {fatalError()}
                    
                    return jsonStr
                }()
                
                print(jsonStr)
                
                let decoder = JSONDecoder()
                guard let dvcGroups = try? decoder.decode(DeviceGroupResponse.self, from: data) else { fatalError("could not decpde it")}
                print(dvcGroups.deviceGroups[0].name)
                
            case .failure(let err):
                print(err)
                
            }
        }
        
    }
    
  */
}



