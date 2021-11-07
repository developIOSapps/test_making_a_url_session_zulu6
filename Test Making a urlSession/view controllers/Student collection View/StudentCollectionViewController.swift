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
    func updateStudentNote(passedNoted: String, user: User)
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
    
    var classGroupCodeInt: Int!
    
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

    
    var studentsOfClass = StudentsOfClass()
    var theClassReturnObject: ClassReturnObject?
    var getAStudentPictute: GetAStudentPictute = GetAStudentPictute()
   
    //  MARK: -  URL Stuff
    var url: URL = URL(string: "https://manage.zuludesk.com/storage/public/1049131/photos/647bba344396e7c8170902bcf2e15551.jpg")!
    
    // used to execute the dataRetrevial from the Web API
    var webApiJsonDecoder = WebApiJsonDecoder()

    
    
    
    @IBOutlet weak var barButtonSelectCancel: UIBarButtonItem!
    
    
    // MARK: - View Controller Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)


         if classGroupCodeInt ==  nil {
            print("in about to perform segue")
             performSegue(withIdentifier: "loginScr", sender: nil)
         }
        
     }
    
    fileprivate func setUpToolBar() {
        addBarButton = UIBarButtonItem(title: "Select App Prolfiles", style: .plain, target: self, action: #selector(addTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        addBarButton.isEnabled = false
        toolbarItems = [addBarButton, spacer]
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

                    
            // UserDefaultsHelper.removeGroupID()
            // UserDefaultsHelper.removeGroupName()
            
            // Customize the navigation bar
            // navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            // navigationController?.navigationBar.shadowImage = UIImage()
            // navigationController?.hidesBarsOnSwipe = true
            
                self.activityIndicator.animateActivity(title: "Loading...", view: self.view, navigationItem: navigationItem)
            navigationController?.navigationBar.tintColor = UIColor(named: "tintContrast")
            barButtonSelectCancel.title = "Select"
            
            setUpToolBar()
            
            collectionView.allowsMultipleSelection = false
            
            classGroupCodeInt = UserDefaultsHelper.groupID
            className = UserDefaultsHelper.groupName

            switch itemsToDisplay {
            case .students:
                if classGroupCodeInt ==  nil {
                    print("in about to perform segue")
                    performSegue(withIdentifier: "loginScr", sender: nil)
                } else {
                    
                    // Register cell classes
                    self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
                    
                    // title = navBarTitle
                    
                    // FIXME: 01-13-21 Code to get student pictures - working
                    /* -
                     GetDataApi.getClassDetail(GeneratedReq.init(request: ValidReqs.classDetail(classId: "3813b0d4-280f-4a3d-ab55-a8274bc9ead6"))) { (classDetailResponse) in
                     DispatchQueue.main.async {
                     
                     guard let classDetailResponse = classDetailResponse as? ClassDetailResponse else {fatalError("could not convert it to classDetailResponse")}
                     /// Just load in the users into this class if needed
                     self.students = classDetailResponse.class.students.sorted { $0.lastName < $1.lastName }
                     /// Here we have what we need
                     classDetailResponse.class.students.forEach { print($0.firstName + "--" + $0.lastName) }
                     self.activityIndicator.stopAnimating(navigationItem: self.navigationItem)
                     self.collectionView.reloadData()
                     }
                     }
                     */
                    studentsOfClass.getTheClassFromWeb { [self] in
                        // get the student from the class based on the username, then we could get the picture
                        print("we got the class object")
                        let classGroupCodeStr = String(classGroupCodeInt)
                        print("*^* here")
                        GetDataApi.getUserListByGroupResponse (GeneratedReq.init(request: ValidReqs.usersInDeviceGroup(parameterDict: ["memberOf" : classGroupCodeStr ]) )) { (userResponse) in
                            DispatchQueue.main.async {
                                
                                guard let usrResponse = userResponse as? UserResponse else {fatalError("could not convert it to Users")}
                                /// Just load in the users into this class if needed
                                self.users = usrResponse.users.sorted { $0.lastName < $1.lastName }
                                /// Here we have what we need
                                usrResponse.users.forEach { print($0.firstName + "--" + $0.lastName  + "--" + $0.username) }
                                self.activityIndicator.stopAnimating(navigationItem: self.navigationItem)
                                self.collectionView.reloadData()
                            }
                        }
                    }
                    
                }
                case .devices:
                    if classGroupCodeInt ==  nil {
                        print("in about to perform segue")
                        performSegue(withIdentifier: "loginScr", sender: nil)
                    } else {
                        
                        // Register cell classes
                        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
                        
                        // title = navBarTitle
                        let classGroupCodeStr = String(classGroupCodeInt)
                        
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
                
            }
        
    }
    

    @IBAction func buttonClicked(_ sender: UIBarButtonItem) {
        selectionMode.toggle()
    }
    
    @objc func addTapped() {
        switch itemsToDisplay {
        case .students:
            performSegue(withIdentifier: "goToStudentDetail", sender: nil)
        case .devices:
             performSegue(withIdentifier: "goToAppProfile", sender: nil)
//            performSegue(withIdentifier: "gotoAppTable", sender: nil)
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
        print("*^* In will display\(indexPath.row)")
        // Configure the cell
        
        // get the current student
        let userStudent = users[indexPath.row]
        
        dump(userStudent)
        // 2a Get the studentIdx to get the photo url and for future index path
        guard let students: [ClassReturnObject.Clss.Student] = (self.studentsOfClass.theClassReturnObject?.class.students),
              let studentIdxInClass = students.firstIndex(where: { $0.id == Int(userStudent.identity) } )
        else {fatalError("couldn't find the student")}
        

        // 2b.1 get the photo url
        let photoURL = students[studentIdxInClass].photo
        
        // if there is no picture uploaded for the student then set it to stub and leave
        print("*^*^*^",photoURL.absoluteString)
        if photoURL.absoluteString.contains(Constants.avatar) {
            print("*^*^*^","its an avatar")
            if let cell = cell as? StudentCollectionViewCell {
                print("*^*^*^","update its an avatar")
                cell.update(displaying: UIImage(named: "avatar"))
            }
            return
        }
        
        
        // 2b.2 make file url from photo url
        let newFileURL: URL = {
            let lp: String = { photoURL.lastPathComponent}()
            let docURL: URL = {
                return  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            }()
            return docURL.appendingPathComponent(lp)
        }()
        
        print("*^*^",newFileURL)
        // 3 execute the function that takes the closure
          self.getAStudentPictute.retreiveDataAsPictureFle(withURL: photoURL) { data in
              DispatchQueue.main.async {
                
              
                 let replaceImage = UIImage(data: data)

                  // - get the index
                  /*
                  The index path for the photo might have changed between the
                  time the request started and finished, so find the most
                  recent index path
                  */
                  guard let students: [ClassReturnObject.Clss.Student] = (self.studentsOfClass.theClassReturnObject?.class.students),
                      let studentIdxInClass = students.firstIndex(where: { $0.photo == photoURL } )
                  else {fatalError("couldn't find the student")}
              
                  // - create the indexpath object
                  let studentIndexPath = IndexPath(item: studentIdxInClass, section: 0)

print(data)
                  // - When the request finishes, only update the cell if it's still visible
                  if let cell = self.collectionView.cellForItem(at: studentIndexPath)
                                                               as? StudentCollectionViewCell {
                    print("do cell ypdate")
                      cell.update(displaying: replaceImage)
                  }

                 
                  // cell.studentImageView.image = UIImage(data: data)
                  // cell.studentNameLabel.text = student.title // + " " + student.lastName
                 // return cell

                  // return replaceImage
                 //self.theStudentPic.image = replaceImage
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
        }

        // cell.studentImageView.image = UIImage(named: student.picName)
        cell.studentNameLabel.text = student.title // + " " + student.lastName
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
                 performSegue(withIdentifier: "goToAppProfile", sender: nil)
//                performSegue(withIdentifier: "gotoAppTable", sender: nil)
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
        guard let vc = segue.source as? LoginViewController, let groupID = vc.groupID, let groupName = vc.groupName  else { fatalError("No Class Group Code")  }
        classGroupCodeInt = groupID
        className = groupName
        print("Returned from Segue \(classGroupCodeInt)")
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        navigationItem.title = itemsToDisplay.barTitle

         // title = navBarTitle
        let classGroupCodeStr = String(classGroupCodeInt)

        switch itemsToDisplay {
            case .students:
                GetDataApi.getUserListByGroupResponse (GeneratedReq.init(request: ValidReqs.usersInDeviceGroup(parameterDict: ["memberOf" : classGroupCodeStr ]) )) { (userResponse) in
                    DispatchQueue.main.async {
                        
                        guard let usrResponse = userResponse as? UserResponse else {fatalError("could not convert it to Users")}
                        
                        /// Just load in the users into this class if needed
                        self.users = usrResponse.users.sorted { $0.lastName < $1.lastName }
                        /// Here we have what we need
                        usrResponse.users.forEach { print($0.firstName + "--" + $0.lastName) }
                        self.activityIndicator.stopAnimating(navigationItem: self.navigationItem)
                        self.collectionView.reloadData()
                    }
                }
            case .devices:
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
      
    }
    
    func updateStudentNote(passedNoted: String, user: User) {
        guard let users = self.users as? [User] else {
            fatalError(" can not convert it to user type")
        }
        
        if let idx = users.firstIndex(of: user) {
            self.users[idx].notes = passedNoted
            print("Updating in the delegate the student at position \(idx) with note \(passedNoted)")
        }
    }

//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        print("in should perform segue")
//               switch users[rowSelected] {
//               case is User:
//                   print("IT Is **USER**")
//                    return true
//               case is Device:
//                   print("IT Is **Device**")
//                   return false
//               default:
//                   return false
//               }
//
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
              print("in should perform segue")
                      switch users[rowSelected] {
                      case is User:
                          print("IT Is **USER**")
                      case is Device:
                          print("IT Is **Device**")
                      default:
                          break
                      }
        
        
        
        /// This meansI am selecting students
        switch segue.identifier  {
            
        case "goToStudentDetail":
           
                         guard let users = self.users as? [User] else {
                return
            }

            guard let studentProfileStaticTableVC = segue.destination as? StudentProfileStaticTableViewController else { fatalError(" could not segue ") }
            
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

            print("Going to app profile because dealing ith devices")
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
        print(appTableViewController.selectedProfile, "0000000000000000000")

        let selectedappProfile = appTableViewController.selectedProfile.replacingOccurrences(of: UserDefaultsHelper.appFilter, with: "")
        print("**********",selectedappProfile)

        for (position, device)  in devicesSelected.enumerated() {
            upDateDeviceNotes(appProfileToUse: appTableViewController.selectedProfile, for: device)
        }

    }
    

    
    @IBAction func backToDeviceList(seque: UIStoryboardSegue)  {
        
        print("came back from app profile")
       
        /// What we need
        guard let appProfilesTableVC =  seque.source as? AppProfilesTableViewController else {fatalError("Was not the AppProfilesTable VC")}
        
        let segmentIdx = appProfilesTableVC.navBarSegmentedControl.selectedSegmentIndex
        guard let row = appProfilesTableVC.rowSelected else { fatalError("There was no row selected")}
        
        /// get the profile name ,  use it to show on the screen so we take off the prefix
        let selectedappProfile = appProfilesTableVC.profileArray[segmentIdx][row].name.replacingOccurrences(of: UserDefaultsHelper.appFilter, with: "")
        print("**********",selectedappProfile)
        for device in devicesSelected {
            print(device.UDID)
        }
        
  
        ///  Update the device
        for (position, device)  in devicesSelected.enumerated() {
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


