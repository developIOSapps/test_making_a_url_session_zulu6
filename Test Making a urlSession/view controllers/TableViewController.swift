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
    case generalError
}

class TableViewController: UITableViewController {

    var deviceGroups: [DeviceGroup] = []
    var users: [User] = []
    var schoolClasses: [SchoolClass] = []
    var profiles: [Profile] = []

    
    var devices: [Device] = []
    
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
        
        UserDefaults.standard.removeObject(forKey: "groupIdKey")
        
        let whatToDo = 10
        
        switch whatToDo {
            
        case 0:
            GetDataApi.updateNoteProperty(GeneratedReq.init(request: ValidReqs.updateDeviceProperty(deviceId: "cf50471c282fa5748a709425ffcd9a88bf9c3df3", propertyName: "notes", propertyValue: "FIRSTHALF"))) {
                DispatchQueue.main.async {
                    print("*** Hooray Job well done")
                }
            }
                        
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
                    
                    // self.tableView.reloadData()
                }
            }
            
        case 3:
            GetDataApi.updateNoteProperty(GeneratedReq.init(request: ValidReqs.userDetail(userId: "249"))) {
                DispatchQueue.main.async {
                    print("*** Hooray printed user detail-- well done")
                }
            }
            
        case 4:
            GetDataApi.getDeviceDetail(GeneratedReq.init(request: ValidReqs.deviceDetail(deviceId: "b049f2becb4a8040735e6b85f1ded62a87ce4e30"))) { (dvcdtl) in
                guard let dvcdtl = dvcdtl as? DeviceDetailResponse else {fatalError("could not convert it to devicedetail")}

           // GetDataApi.updateNoteProperty(GeneratedReq.init(request: ValidReqs.deviceDetail(deviceId: "b049f2becb4a8040735e6b85f1ded62a87ce4e30"))) {
                DispatchQueue.main.async {
                    print("*** Hooray printed user detail-- well done")
                }
            }
        
        case 5:
            GetDataApi.getUserListByGroupResponse (GeneratedReq.init(request: ValidReqs.usersInDeviceGroup(parameterDict: ["memberOf" : "18" ]) )) { (userResponse) in
                DispatchQueue.main.async {
                    
                    guard let usrResponse = userResponse as? UserResponse else {fatalError("could not convert it to Users")}
                    
                    /// Just load in the users into this class if needed
                    self.users = usrResponse.users
                    self.users.sort {
                        $0.lastName < $1.lastName
                    }

                    /// Here we have what we need
                    usrResponse.users.forEach { print($0.firstName + "--" + $0.lastName) }
                    
                     self.tableView.reloadData()
                }
            }
            case 6:
                GetDataApi.getDeviceListByGroupResponse (GeneratedReq.init(request: ValidReqs.devicesInDeviceGroup(parameterDict: ["groups" : "12" ]) )) { (deviceListResponse) in
                    DispatchQueue.main.async {
                        
                        guard let deviceListResponse = deviceListResponse as? DeviceListResponse else {fatalError("could not convert it to Users")}
                        
                        /// Just load in the users into this class if needed
                        self.devices = deviceListResponse.devices
                        /// Here we have what we need
                        deviceListResponse.devices.forEach { print($0.serialNumber + "--" + $0.serialNumber) }
                        
                        // self.tableView.reloadData()
                    }
                }
            case 7:
                GetDataApi.getSchoolClassListResponse { (xyz) in
                    DispatchQueue.main.async {
                        guard let clsResponse = xyz as? SchoolClassResponse else {fatalError("could not convert it to Classes")}
                        let clss = clsResponse.classes.first
                        print(String(repeating: "\(String(describing: clss?.name))  " , count: 5))
                        
                        self.schoolClasses = clsResponse.classes.filter{$0.name.hasPrefix("20") }
                        
                        
                        self.schoolClasses.forEach { print($0.name ) }
                        
                        self.tableView.reloadData()
                    }
                }

            case 8:
                GetDataApi.getProfileListResponse { (xyz) in
                    DispatchQueue.main.async {
                        guard let profilesResponse = xyz as? ProfilesResponse else {fatalError("could not convert it to Profiles")}
                        let profls = profilesResponse.profiles.first
                        print(String(repeating: "\(String(describing: profls?.name))  " , count: 5))
                        
                        self.profiles = profilesResponse.profiles.filter{$0.name.hasPrefix("Profile-App ") }
                        
                        
                        self.profiles.forEach { print($0.name ) }
                        
                        // self.tableView.reloadData()
                    }
                }
            
            case 9:
                GetDataApi.updateUserProperty(GeneratedReq.init(request: ValidReqs.updateUserProperty(userId: "432", propertyName: "notes", propertyValue: "1212121212"))) {
                    DispatchQueue.main.async {
                        print("*** Hooray Job well done")
                    }
                }
            case 10:
                GetDataApi.getDeviceListByAssetResponse(GeneratedReq.init(request: ValidReqs.devicesInAssetTag(parameterDict: ["assettag" : "zzz" ]) )) { (deviceListResponse) in
                    DispatchQueue.main.async {
                        
                        guard let deviceListResponse = deviceListResponse as? DeviceListResponse else {fatalError("could not convert it to Users")}
                        
                        /// Just load in the users into this class if needed
                        self.devices = deviceListResponse.devices
                        /// Here we have what we need
                        deviceListResponse.devices.forEach { print($0.serialNumber + "--" + $0.serialNumber) }
                        print("got devices")
                        // self.tableView.reloadData()
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
        return schoolClasses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let schoolClass =  schoolClasses[indexPath.row]
        
        cell.textLabel?.text = schoolClass.name 
        return cell
    }

}


extension TableViewController {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let studentTableVC = segue.destination as! StudentTableTableViewController
//        
//        guard let rowSelected = tableView.indexPathForSelectedRow?.row else {fatalError()}
//        
//        studentTableVC.classGroupCodeInt = schoolClasses[rowSelected].userGroupId
//        studentTableVC.navBarTitle = schoolClasses[rowSelected].name
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let studentTableVC = segue.destination as! StudentCollectionViewController
        
        guard let rowSelected = tableView.indexPathForSelectedRow?.row else {fatalError()}
        
        studentTableVC.classGroupCodeInt = schoolClasses[rowSelected].userGroupId
        studentTableVC.navBarTitle = schoolClasses[rowSelected].name
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



