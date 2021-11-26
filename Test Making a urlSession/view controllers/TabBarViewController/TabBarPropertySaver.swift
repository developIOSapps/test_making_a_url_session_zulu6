//
//  TabBarPropertySaver.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/25/21.
//  Copyright © 2021 DIA. All rights reserved.
//

import UIKit

protocol TabBarPropertySaver {
    func saveTheInfo(vc: UIViewController )
    func restoreTheInfo(vc: UIViewController)
}
