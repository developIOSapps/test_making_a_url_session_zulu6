//
//  StudentCollectionViewController.swift
//  Student Collection View Test
//
//  Created by Steven Hertz on 11/21/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

protocol NotesDelegate {
    func updateStudentNote(passedNoted: String, user: JSUser)
}

class StudentCollectionViewController: UICollectionViewController, NotesDelegate {
        
    enum SelectionMode {
        
        case multipleEnabled(count: Int)
        case multipleDisabled
               
        var allTitles: (buttonTitle: String, barTitle: String) {
            switch self {
            case .multipleDisabled:
                return ("Select", UserDefaultsHelper.groupName ?? "Students")
            case .multipleEnabled:
                return ("Cancel", "Select Items")
            }
        }

        var allowsMultipleSelection: Bool {
            switch self {
            case .multipleDisabled:
                return false
            case .multipleEnabled:
                return true
            }
        }

        mutating func toggle()  {
            switch self {
            case .multipleEnabled:
                self = .multipleDisabled
            case .multipleDisabled:
                self = .multipleEnabled(count: 0)
            }
        }
        
    }
    
    enum ItemsToDisplay {
         
         case students
         case devices
        
         var barTitle: String {
             switch self {
             case .devices:
                 return "Devices"
             case .students:
                 return "Students"
             }
         }

//         var segueTo: String {
//             switch self {
//             case .devices:
//                 return "goToStudentDetail"
//             case .students:
//                 return "goToAppProfile"
//             }
//         }

         var allowsMultipleSelection: Bool {
             switch self {
             case .devices:
                 return false
             case .students:
                 return true
             }
         }

         mutating func toggle()  {
             switch self {
             case .students:
                 self = .devices
             case .devices:
                 self = .students
             }
         }
         
     }
    
    var myValue: Int?
     
    var itemsToDisplay: ItemsToDisplay = .students {
        didSet {
            navigationItem.title = itemsToDisplay.barTitle
        }
    }
    
    var selectionMode : SelectionMode = .multipleDisabled {
        
        willSet {
            switch newValue {
            case .multipleDisabled:
                collectionView.indexPathsForSelectedItems?.forEach{
                    if let cell = collectionView.cellForItem(at: $0) as? StudentCollectionViewCell {
                        cell.hideIcon()
                    }
                    collectionView.deselectItem(at: $0, animated: false)
                }
                self.tabBarController?.tabBar.isHidden = false
                navigationController?.setToolbarHidden(true, animated: true)
                
            case .multipleEnabled:
                addBarButton.isEnabled = false
                self.tabBarController?.tabBar.isHidden = true
                navigationController?.setToolbarHidden(false, animated: true)
                
                print("multiple enablled")
            }
        }
        
        didSet {
            collectionView.allowsMultipleSelection = selectionMode.allowsMultipleSelection
            barButtonSelectCancel.title = selectionMode.allTitles.buttonTitle
            switch selectionMode {
            case .multipleEnabled:
                navigationItem.title = selectionMode.allTitles.barTitle
            case .multipleDisabled:
                navigationItem.title = itemsToDisplay.barTitle
            }
        }
    }
    
    var addBarButton: UIBarButtonItem = UIBarButtonItem()
    
    var navBarTitle = ""
    
    
    var schoolInfo: SchoolInfo?
    
    var mdmStatus: MDMStatus?

    // var apiKey: String!
    
    var classUUID: String!
    var classGroupCodeInt: Int!
    var locationId: Int!
    var className: String! {
        didSet {
//            navigationItem.title = className
        }
    }

    // var devices: [NotesUpdateable] = []
    var users: [NotesUpdateable] = []
    var students: [ClassDetailResponse.Clss.Student] = []
    
    var rowSelected = 0
    var devicesSelected: [Device] = [Device]()

    let activityIndicator = ActivityIndicator.shared
    var beingUpdatedAppProfile: String?
    var beingUpdatedDevice: Device?
    
    
    var tracker = "" {
        didSet {
            print("just entered the didSet - another 8 seconds until it fires off")
            DispatchQueue.global().asyncAfter(deadline: .now() + 8) { [self] in
                guard let beingUpdatedDevice = beingUpdatedDevice, let beingUpdatedAppProfile = beingUpdatedAppProfile else {fatalError("in double update")}
                
                GetDataApi.updateNoteProperty(GeneratedReq.init(request: ValidReqs.updateDeviceProperty(deviceId: beingUpdatedDevice.UDID, propertyName: "notes", propertyValue: beingUpdatedAppProfile))) {
                    DispatchQueue.main.async {
                        print( "```*** Updated the second second notes property of this iPad - Hooray Job well done")
                    }
                }
            }
        }
    }

    
//    var studentsOfClass = StudentsOfClass()
//    var theClassReturnObject: ClassReturnObject?
    var getAStudentPicture: GetAStudentPicture!
   
    //  MARK: -  URL Stuff
    var url: URL = URL(string: "https://manage.zuludesk.com/storage/public/1049131/photos/647bba344396e7c8170902bcf2e15551.jpg")!
    
    // used to execute the dataRetrevial from the Web API
    var webApiJsonDecoder = WebApiJsonDecoder()

    
    @IBOutlet weak var barButtonSelectCancel: UIBarButtonItem!
    
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        
        // Customize the navigation bar
        // navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // navigationController?.navigationBar.shadowImage = UIImage()
        // navigationController?.hidesBarsOnSwipe = true
        
        
        self.activityIndicator.animateActivity(title: "Loading...", view: self.view, navigationItem: navigationItem)
        navigationController?.navigationBar.tintColor = UIColor(named: "tintContrast")
        barButtonSelectCancel.title = "Select"
        
        setUpToolBar()
        
        collectionView.allowsMultipleSelection = false

        // Step 1 - get the values from the MDM config file if missing go to login screen

        // restore saved properties from tabbar controller
        guard let tbPropertySaver = self.tabBarController as? MyTabBarController else {return}
        tbPropertySaver.restoreTheInfo(vc: self)

        if MDMStatus.fromLoginVC !=  self.mdmStatus {
        
            
            guard let schoolInf = SchoolInfo() else {
                mdmStatus = .missing
                performSegue(withIdentifier: "loginScr", sender: nil)
                return
            }
            
            schoolInfo = schoolInf
            mdmStatus = .found
            getAStudentPicture = GetAStudentPicture()
            getAStudentPicture.schoolInfo = schoolInfo
            getAStudentPicture.webApiJsonDecoder = webApiJsonDecoder
            
            
            // Step 2 - get the class credentials if missing go to login
            classUUID = UserDefaultsHelper.getClassUUID()
            classGroupCodeInt = UserDefaultsHelper.getGroupID()
            className = UserDefaultsHelper.groupName
            locationId = UserDefaultsHelper.getlocationId()
            
            guard let classUUID = classUUID, let classGroupCodeInt = classGroupCodeInt else {
                performSegue(withIdentifier: "loginScr", sender: nil)
                return
            }
            
            if classUUID.isEmpty  ||  classGroupCodeInt < 1  {
                performSegue(withIdentifier: "loginScr", sender: nil)
                return
            }
        }
        
        switch itemsToDisplay {
        case .students:
            getClassandStudentData()
//            if classGroupCodeInt ==  nil || UserDefaultsHelper.getapiKey() == nil  {
//                print("in about to perform segue")
//                performSegue(withIdentifier: "loginScr", sender: nil)
//            } else {
//                getClassandStudentData()
//            }
        case .devices:
//            if classGroupCodeInt ==  nil || UserDefaultsHelper.getapiKey() == nil {
//                print("in about to perform segue")
//                performSegue(withIdentifier: "loginScr", sender: nil)
//            } else {
//
                // Register cell classes
                self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
                
                // title = navBarTitle
                let classGroupCodeStr = String(classGroupCodeInt)
                
            
            
            /* if demoMode then load this data in
             
             let decoder = JSONDecoder()
             
             guard let deviceListResponsexx = try? decoder.decode(DeviceListResponse.self, from: data) else {fatalError("deviceListResponsexx ")}
             let dvc = deviceListResponsexx as DeviceListResponse

                          
             
             */
            
            
            
            
            
            
                GetDataApi.getDeviceListByAssetResponse(GeneratedReq.init(request: ValidReqs.devicesInAssetTag(parameterDict: ["assettag" : classGroupCodeStr ]) )) { (deviceListResponse) in
                    DispatchQueue.main.async {
                        
                        guard let deviceListResponse = deviceListResponse as? DeviceListResponse else {fatalError("could not convert it to Users")}
                        
                        /// Just load in the users into this class if needed
                        self.users = deviceListResponse.devices
                        /// Here we have what we need
                        deviceListResponse.devices.forEach { print($0.name + "--" + $0.UDID) }
                        print("got devices")
                        self.activityIndicator.stopAnimating(navigationItem: self.navigationItem)
                        self.collectionView.reloadData()
                    }
                }
            }
            
//        }
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//         super.viewDidAppear(animated)
////  FIXME: -  mh should this be here
////        classGroupCodeInt = UserDefaultsHelper.getGroupID()
////         if classGroupCodeInt ==  nil {
////            print("in about to perform segue")
////             performSegue(withIdentifier: "loginScr", sender: nil)
////         }
////
//     }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //  FIXME: -  mh should this be here
        //        classGroupCodeInt = UserDefaultsHelper.getGroupID()
        //         if classGroupCodeInt ==  nil {
        //            print("in about to perform segue")
        //             performSegue(withIdentifier: "loginScr", sender: nil)
        //         }
        //

        /*
        let alert = UIAlertController(title: "Items from config file", message: schoolInfo?.mngedCfgitems, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default) { _ in NSLog("The \"OK\" alert occured.") }
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        */
    }
 
    fileprivate func setUpToolBar() {
        addBarButton = UIBarButtonItem(title: "Select App Prolfiles", style: .plain, target: self, action: #selector(addTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        addBarButton.isEnabled = false
        toolbarItems = [addBarButton, spacer]
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    fileprivate func getClassandStudentData() {
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let classGroupCodeStr = String(classGroupCodeInt)
        // title = navBarTitle
        
        // 1 - Get the list of classes
        
        /*
        let urlValues = URLValues.urlForListOfClasses
        webApiJsonDecoder.sendURLReqToProcess(with: urlValues.getUrlRequest(), andSession: urlValues.getSession() ) {(data) in
            
            // OK we are fine, we got data - so lets write it to a file so we can retieve it
            
            let returnFromDecodingClassList: Result<ClassesReturnObjct, GetResultOfNetworkCallError> = self.webApiJsonDecoder.processTheData(with: data)
            guard let aClassesReturnObject = try? returnFromDecodingClassList.get() else {
                if case Result<ClassesReturnObjct, GetResultOfNetworkCallError>.failure(let getResultOfNetworkCallError) = returnFromDecodingClassList {
                    self.webApiJsonDecoder.processTheError(with: getResultOfNetworkCallError)
                }
                return
            }
            //                        let aClassesReturnObject: ClassesReturnObjct = self.webApiJsonDecoder.processTheData(with: data) { print("**** From completion handler") }
            self.webApiJsonDecoder.theClassesReturnObjct = aClassesReturnObject
            
            dump(self.webApiJsonDecoder.theClassesReturnObjct)
            
            guard let classes: [ClassesReturnObjct.Classe] = (self.webApiJsonDecoder.theClassesReturnObjct?.classes),
                  let idx = classes.firstIndex(where: { $0.userGroupId == self.classGroupCodeInt} )
            else {fatalError("couldn't find the class group")}
            
            let classuuid = classes[idx].uuid
            print(classuuid)
            
         */
            // 2 - Get the students in a class
        
       
            
        let urlValuesforClass = URLValues.urlForClassInfo(UUISString: self.classUUID, apiKey: schoolInfo!.thekey )
            self.webApiJsonDecoder.sendURLReqToProcess(with: urlValuesforClass.getUrlRequest(), andSession: urlValuesforClass.getSession() ) {(data) in
                // OK we are fine, we got data - so lets write it to a file so we can retieve it
                                
                let returnFromDecodingClassInfo: Result<ClassReturnObjct, GetResultOfNetworkCallError> = self.webApiJsonDecoder.processTheData(with: data)
                guard let aClassReturnObject = try? returnFromDecodingClassInfo.get() else {
                    if case Result<ClassReturnObjct, GetResultOfNetworkCallError>.failure(let getResultOfNetworkCallError) = returnFromDecodingClassInfo {
                        self.webApiJsonDecoder.processTheError(with: getResultOfNetworkCallError)
                    }
                    return
                }
                self.webApiJsonDecoder.theClassReturnObjct = aClassReturnObject
                

                GetDataApi.getUserListByGroupResponse (GeneratedReq.init(request: ValidReqs.usersInDeviceGroup(parameterDict: ["memberOf" : classGroupCodeStr ]) )) { (userResponse) in
                    DispatchQueue.main.async {
                        
                        guard let usrResponse = userResponse as? UserResponse else {fatalError("could not convert it to Users")}
                        /// Just load in the users into this class if needed
                        self.users = usrResponse.users.sorted { $0.lastName < $1.lastName }
                        /// Here we have what we need
                        self.activityIndicator.stopAnimating(navigationItem: self.navigationItem)
                        self.collectionView.reloadData()
                    }
                }
            }
        }
//    }
    

    @IBAction func buttonClicked(_ sender: UIBarButtonItem) {
        selectionMode.toggle()
    }
    
    @objc func addTapped() {
        switch itemsToDisplay {
        case .students:
            performSegue(withIdentifier: "goToStudentDetail", sender: nil)
        case .devices:
//             performSegue(withIdentifier: "goToAppProfile", sender: nil)
            performSegue(withIdentifier: "gotoAppTable", sender: nil)
        }
    }
    
    
//    func setBarButtonSelected() {
//        barButtonSelectCancel.title = "Select"
//        selectionMode = .multipleDisabled
//    }
}

extension StudentCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
         return users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
         if ItemsToDisplay.devices == itemsToDisplay {
             return
         }

         // get the current student
         let userStudent = users[indexPath.row]
         
         // 2a Get the studentIdx to get the photo url and for future index path
         guard let students: [ClassReturnObjct.Clss.Student] = (self.webApiJsonDecoder.theClassReturnObjct?.class.students),
               let studentIdxInClass = students.firstIndex(where: { $0.id == Int(userStudent.identity) } )
         else {fatalError("couldn't find the student")}
         

         // 2b.1 get the photo url
         let photoURL = students[studentIdxInClass].photo
         
         // if there is no picture uploaded for the student then set it to stub and leave
         if photoURL.absoluteString.contains(Constants.avatar) {
             if let cell = cell as? StudentCollectionViewCell {
                 cell.update(displaying: UIImage(named: "avatar"))
             }
             return
         }
         // 3 execute the function that takes the closure
         self.getAStudentPicture.retreiveDataAsPictureFle(withURL: photoURL) { data in
             DispatchQueue.main.async {
                 
                 let replaceImage = UIImage(data: data)
                 guard let studentIdxInClass = self.users.firstIndex(where: { $0.identity == userStudent.identity } ) else {fatalError()}

                 // - create the indexpath object
                 let studentIndexPath = IndexPath(item: studentIdxInClass, section: 0)
                 
                  // - When the request finishes, only update the cell if it's still visible
                 if let cell = self.collectionView.cellForItem(at: studentIndexPath)
                     as? StudentCollectionViewCell {
                     cell.update(displaying: replaceImage)
                 }
             }
         }
     }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? StudentCollectionViewCell else {fatalError("could not deque")}
    
        // Configure the cell
        let student = users[indexPath.row]
        // FIXME: Put in a stub image to test easier
        if ItemsToDisplay.devices == itemsToDisplay {
            cell.studentImageView.image = UIImage(named: student.picName)
            cell.studentNameLabel.text = student.title // + " " + student.lastName
        } else {
            cell.studentImageView.image = UIImage(named: "avatar")
            cell.studentNameLabel.text = student.title // + " " + student.lastName

        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//           if let cell = collectionView.cellForItem(at: indexPath) {
//               cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
//           }
           print("itemhightlighted")
           
       }
       
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
           if let cell = collectionView.cellForItem(at: indexPath) {
               cell.contentView.backgroundColor = nil
           }
           print("itemUNhightlighted")
       }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("in did select item and the item in \(indexPath.row)")
        
        switch selectionMode {
        case .multipleDisabled:
            rowSelected = indexPath.row
            collectionView.deselectItem(at: indexPath, animated: false)
            switch itemsToDisplay {
            case .students:
                performSegue(withIdentifier: "goToStudentDetail", sender: nil)
            case .devices:
//                 performSegue(withIdentifier: "goToAppProfile", sender: nil)
                performSegue(withIdentifier: "gotoAppTable", sender: nil)
            }

        case .multipleEnabled:
            print("itemselected")
            if let cell = collectionView.cellForItem(at: indexPath) as? StudentCollectionViewCell {
                cell.showIcon()
                if case .multipleEnabled(var count) = selectionMode {
                    count += 1
                    selectionMode = .multipleEnabled(count: count)
                    navigationItem.title = "\(count) Selected"
                }
            
            }
            addBarButton.isEnabled = true
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("itemDeselected")
        if let cell = collectionView.cellForItem(at: indexPath) as? StudentCollectionViewCell {
            cell.hideIcon()
            if case .multipleEnabled(var count) = selectionMode {
                count -= 1
                selectionMode = .multipleEnabled(count: count)
                if count > 0 {
                    addBarButton.isEnabled = true
                    navigationItem.title = "\(count) Selected"
                } else {
                    addBarButton.isEnabled = false
                    navigationItem.title = "Select Items"
                }
            }
        }
//        guard let count = collectionView.indexPathsForSelectedItems?.count else {return}
//        if count < 1 {
//            addBarButton.isEnabled = false
//        }
    }
}

extension StudentCollectionViewController {
    
    
    @IBAction func returnFromLoginWithClass(segue: UIStoryboardSegue) {
        
        guard let vc = segue.source as? LoginViewController else { fatalError("No Class Group Code")  }
       
//        guard let apiKeyfromVC = vc.myApiKey else { fatalError("api No Class Group Code")  }
        guard let classUUID = vc.classUUID else {fatalError("no calss uuid")}
        guard let groupID = vc.groupID else { fatalError("groupid No Class Group Code")  }
        guard let groupName = vc.groupName  else { fatalError("groupname No Class Group Code")  }
        guard let locationId = vc.locationId else { fatalError("locationId not in vc")  }

        switch vc.mdmStatus {
        case .missing:
            self.schoolInfo = vc.schoolInfo
            getAStudentPicture = GetAStudentPicture()
            getAStudentPicture.schoolInfo = schoolInfo
            getAStudentPicture.webApiJsonDecoder = webApiJsonDecoder
            
            classGroupCodeInt   = groupID
            self.classUUID      = classUUID
            className           = groupName
            self.locationId     = locationId

        default:
            classGroupCodeInt   = groupID
            self.classUUID      = classUUID
            className           = groupName
            self.locationId     = locationId

        }
        mdmStatus = .fromLoginVC
        guard let tbPropertySaver = self.tabBarController as? MyTabBarController else {return}
        tbPropertySaver.saveTheInfo(vc: self)

//        self.webApiJsonDecoder.theAuthenticateReturnObjct = vc.webApiJsonDecoder.theAuthenticateReturnObjct
//        self.webApiJsonDecoder.theClassReturnObjct = vc.webApiJsonDecoder.theClassReturnObjct
//        self.webApiJsonDecoder.theClassesReturnObjct = vc.webApiJsonDecoder.theClassesReturnObjct
//        self.webApiJsonDecoder.theUserInfoReturnObjct = vc.webApiJsonDecoder.theUserInfoReturnObjct

       // print("Returned from Segue \(classGroupCodeInt) and \(apiKey)")

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        navigationItem.title = itemsToDisplay.barTitle

         // title = navBarTitle
        let classGroupCodeStr = String(classGroupCodeInt)

        switch itemsToDisplay {
            case .students:
                getClassandStudentData()
//                GetDataApi.getUserListByGroupResponse (GeneratedReq.init(request: ValidReqs.usersInDeviceGroup(parameterDict: ["memberOf" : classGroupCodeStr ]) )) { (userResponse) in
//                    DispatchQueue.main.async {
//
//                        guard let usrResponse = userResponse as? UserResponse else {fatalError("could not convert it to Users")}
//
//                        /// Just load in the users into this class if needed
//                        self.users = usrResponse.users.sorted { $0.lastName < $1.lastName }
//                        /// Here we have what we need
//                        usrResponse.users.forEach { print($0.firstName + "--" + $0.lastName) }
//                        self.activityIndicator.stopAnimating(navigationItem: self.navigationItem)
//                        self.collectionView.reloadData()
//                    }
//                }
            case .devices:
                GetDataApi.getDeviceListByAssetResponse(GeneratedReq.init(request: ValidReqs.devicesInAssetTag(parameterDict: ["assettag" : classGroupCodeStr ]) )) { (deviceListResponse) in
                    DispatchQueue.main.async {
                        
                        guard let deviceListResponse = deviceListResponse as? DeviceListResponse else {fatalError("could not convert it to Users")}
                        
                        /// Just load in the users into this class if needed
                        self.users = deviceListResponse.devices
                        /// Here we have what we need
                        deviceListResponse.devices.forEach { print($0.name + "--" + $0.UDID) }
                        self.activityIndicator.stopAnimating(navigationItem: self.navigationItem)
                        self.collectionView.reloadData()
                    }
            }
        }
      
    }
    
    func updateStudentNote(passedNoted: String, user: JSUser) {
        guard let users = self.users as? [JSUser] else {
            fatalError(" can not convert it to user type")
        }
        
        if let idx = users.firstIndex(of: user) {
            self.users[idx].notes = passedNoted
            print("Updating in the delegate the student at position \(idx) with note \(passedNoted)")
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
        /// This meansI am selecting students
        switch segue.identifier  {
        
        case "loginScr":
            guard let loginVC = segue.destination as? LoginViewController else {
                fatalError("Could not go to the login view controller")
            }
            loginVC.webApiJsonDecoder = self.webApiJsonDecoder
            loginVC.msgFromSegue = self.schoolInfo?.mngedCfgitems ?? ""
            loginVC.mdmStatus = self.mdmStatus
            
            if MDMStatus.found == self.mdmStatus {
                loginVC.schoolInfo = self.schoolInfo
            }
            if MDMStatus.fromLoginVC == self.mdmStatus {
                loginVC.schoolInfo = self.schoolInfo
            }

            
        case "goToStudentDetail":
           
                         guard let users = self.users as? [JSUser] else {
                return
            }

            guard let studentProfileStaticTableVC = segue.destination as? StudentProfileStaticTableViewController else { fatalError(" could not segue ") }
            
            studentProfileStaticTableVC.schoolInfo = schoolInfo
                         studentProfileStaticTableVC.notesDelegate = self
             switch selectionMode {
             case .multipleDisabled:
                studentProfileStaticTableVC.user = users[rowSelected]
                studentProfileStaticTableVC.usersSelected.append(users[rowSelected])
             case .multipleEnabled:
                guard let indexPaths = collectionView.indexPathsForSelectedItems else {fatalError("Could not get the index paths")}
                for indexPath in indexPaths {
                    studentProfileStaticTableVC.usersSelected.append(users[indexPath.row])
                }
                selectionMode.toggle()
            }
            studentProfileStaticTableVC.navigationItem.title =
                studentProfileStaticTableVC.usersSelected.count == 1 ?
                    users[rowSelected].firstName.trimmingCharacters(in: .whitespacesAndNewlines) + " " + users[rowSelected].lastName.trimmingCharacters(in: .whitespacesAndNewlines)
                    : "* * * Multiple * * *"

        
        case "goToAppProfile":
            
            guard let devices = self.users as? [Device] else {
                return
            }

            guard let appProfilesTableVC = segue.destination as? AppProfilesTableViewController else { fatalError(" could not segue ") }

            appProfilesTableVC.schoolInfo = schoolInfo
             switch selectionMode {
            case .multipleDisabled:
                devicesSelected.removeAll()
                devicesSelected.append(devices[rowSelected])
                appProfilesTableVC.navigationItem.prompt = "Select the kiosk mode app for \(devices[rowSelected].name) device"
                
            case .multipleEnabled:
               guard let indexPaths = collectionView.indexPathsForSelectedItems else {fatalError("Could not get the index paths")}
               devicesSelected.removeAll()
               for indexPath in indexPaths {
                   devicesSelected.append(devices[indexPath.row])
               }
               selectionMode.toggle()
                appProfilesTableVC.navigationItem.prompt = "Select the kiosk mode app for multiple devices"
            }
            appProfilesTableVC.itemsToDisplay = .devices
            
        case "gotoAppTable":
            
            guard let devices = self.users as? [Device] else {
                return
            }
            
            guard let appTableVC = segue.destination as? AppTableViewController else { fatalError(" could not segue ") }
            
            appTableVC.schoolInfo = schoolInfo
            
            print("Going to app profile because dealing ith devices")
            switch selectionMode {
            case .multipleDisabled:
                devicesSelected.removeAll()
                devicesSelected.append(devices[rowSelected])
                appTableVC.navigationItem.prompt = "Select the kiosk mode app for \(devices[rowSelected].name) device"
                
            case .multipleEnabled:
                guard let indexPaths = collectionView.indexPathsForSelectedItems else {fatalError("Could not get the index paths")}
                devicesSelected.removeAll()
                for indexPath in indexPaths {
                    devicesSelected.append(devices[indexPath.row])
                }
                selectionMode.toggle()
                appTableVC.navigationItem.prompt = "Select the kiosk mode app for multiple devices"
            }
            appTableVC.itemsToDisplay = .devices
            
        default:
            break
        }

        /*
        switch selectionMode {
            
        case .multipleDisabled:
            switch segue.identifier {
            case "goToStudentDetail":
                guard let studentProfileStaticTableVC = segue.destination as? StudentProfileStaticTableViewController else { fatalError(" could not segue ") }
                studentProfileStaticTableVC.user = users[rowSelected]
                studentProfileStaticTableVC.usersSelected.append(users[rowSelected])
                studentProfileStaticTableVC.notesDelegate = self
                
                studentProfileStaticTableVC.navigationItem.title =
                    studentProfileStaticTableVC.usersSelected.count == 1 ? users[rowSelected].firstName.trimmingCharacters(in: .whitespacesAndNewlines) + " " + users[rowSelected].lastName.trimmingCharacters(in: .whitespacesAndNewlines) : "* * * Multiple * * *"
                
                print("finished Segue")
            default:
                break
            }
            
        case .multipleEnabled:
            switch segue.identifier {
            case "goToStudentDetail":
                
                guard let studentProfileStaticTableVC = segue.destination as? StudentProfileStaticTableViewController else { fatalError(" could not segue ") }
                guard let indexPaths = collectionView.indexPathsForSelectedItems else {fatalError("Could not get the index paths")}
                for indexPath in indexPaths {
                    studentProfileStaticTableVC.usersSelected.append(users[indexPath.row])
                }
                
                studentProfileStaticTableVC.notesDelegate = self
                
                studentProfileStaticTableVC.navigationItem.title =
                    studentProfileStaticTableVC.usersSelected.count == 1 ? users[rowSelected].firstName.trimmingCharacters(in: .whitespacesAndNewlines) + " " + users[rowSelected].lastName.trimmingCharacters(in: .whitespacesAndNewlines) : "* * * Multiple * * *"
                selectionMode.toggle()
                print("finished Segue")
            default:
                break
            }
            
        }
       */
    }

}

   extension StudentCollectionViewController {
    
    @IBAction func fromAppsListbackToDeviceList(seque: UIStoryboardSegue)  {
        /// What we need
        guard let appTableViewController =  seque.source as? AppTableViewController else {fatalError("Was not the AppTableViewController VC")}

//        let selectedappProfile = appTableViewController.selectedProfile.replacingOccurrences(of: UserDefaultsHelper.appFilter, with: "")

        for (_, device)  in devicesSelected.enumerated() {
            upDateDeviceNotes(appProfileToUse: appTableViewController.selectedProfile, for: device)
        }

    }
    
    @IBAction func backToDeviceList(seque: UIStoryboardSegue)  {
        /// What we need
        guard let appProfilesTableVC =  seque.source as? AppProfilesTableViewController else {fatalError("Was not the AppProfilesTable VC")}
        
        let segmentIdx = appProfilesTableVC.navBarSegmentedControl.selectedSegmentIndex
        guard let row = appProfilesTableVC.rowSelected else { fatalError("There was no row selected")}
        
        /// get the profile name ,  use it to show on the screen so we take off the prefix
//        let selectedappProfile = appProfilesTableVC.profileArray[segmentIdx][row].name.replacingOccurrences(of: UserDefaultsHelper.appFilter, with: "")
        for device in devicesSelected {
            print(device.UDID)
        }

        ///  Update the device
        for (_, device)  in devicesSelected.enumerated() {
            upDateDeviceNotes(appProfileToUse: appProfilesTableVC.profileArray[segmentIdx][row].name, for: device)
        }
      
    }
    
    func upDateDeviceNotes(appProfileToUse: String , for deviceToUpdate: Device)  {
        
        // save profile and device being updated
        beingUpdatedDevice = deviceToUpdate
        beingUpdatedAppProfile = appProfileToUse
        
        // See if it is asking for student login
        var appProfileToUseModified = appProfileToUse
        var initiateSecondUpdate = false
        
        if appProfileToUse.contains("- Student Login") {
            print("**********","it does contain student login profile")
            appProfileToUseModified = "Profile-App-1Kiosk - All Apps"
            initiateSecondUpdate = true
        }
        
        //*** Real Update moveiPadIntoDeviceGroup - Update its notes property
        GetDataApi.updateNoteProperty(GeneratedReq.init(request: ValidReqs.updateDeviceProperty(deviceId: deviceToUpdate.UDID, propertyName: "notes", propertyValue: appProfileToUseModified))) {
            DispatchQueue.main.async {
                print( "```*** Updated the notes property of this iPad - Hooray Job well done")
                if initiateSecondUpdate {
                    self.tracker = "y"
                }
            }
        }
    }
}


