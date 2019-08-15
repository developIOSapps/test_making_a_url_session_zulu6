//
//  DeviceDetailResponse.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 8/14/19.
//  Copyright © 2019 DIA. All rights reserved.
//

import Foundation
public struct DeviceDetailResponse: Codable {
    public struct Device: Codable {
        public let modified: String
        public let `class`: String
        public let iCloudBackupEnabled: Int
        public let totalCapacity: Int
        public let groupIds: [Int]
        public let inTrash: Bool
        public let deviceEnrollType: String
        public let iTunesStoreLoggedIn: Int
        public struct Owner: Codable {
        }
        public let owner: Owner
        public let bluetoothMAC: String
//        public struct Region: Codable {
//            public let string: String
//            public let coordinates: Any? //TODO: Specify the type to conforms Codable protocol
//        }
//        public let region: Region
        public let locationId: Int
        public struct Os: Codable {
            public let prefix: String
            public let version: String
        }
        public let os: Os
        public let name: String
        public let isManaged: Bool
        public let iCloudBackupLatest: Int
        public let hardwareEncryptionEnabled: Int
        public let deviceDepProfile: String
        public let uDID: String
        public let serialNumber: String
        public let assetTag: String
        public struct Model: Codable {
            public let name: String
            public struct `Type`: Codable {
                public let value: String
            }
            public let type: Type
            public let identifier: String
        }
        public let model: Model
        public let isSupervised: Bool
        public let batteryLevel: Int
        public let passcodeCompliant: Int
        public let groups: [String]
        public let hasPasscode: Bool
        public let wiFiMAC: String
        public let iPAddress: String
        public let notes: String
        public let availableCapacity: Int
        public struct LastCheckin: Codable {
            public let date: String
            public let timezone: String
            public let timezoneType: Int
            private enum CodingKeys: String, CodingKey {
                case date
                case timezone
                case timezoneType = "timezone_type"
            }
        }
        public let lastCheckin: LastCheckin
        private enum CodingKeys: String, CodingKey {
            case modified
            case `class` = "class"
            case iCloudBackupEnabled
            case totalCapacity
            case groupIds
            case inTrash
            case deviceEnrollType
            case iTunesStoreLoggedIn
            case owner
            case bluetoothMAC
//            case region
            case locationId
            case os
            case name
            case isManaged
            case iCloudBackupLatest
            case hardwareEncryptionEnabled
            case deviceDepProfile
            case uDID = "UDID"
            case serialNumber
            case assetTag
            case model
            case isSupervised
            case batteryLevel
            case passcodeCompliant
            case groups
            case hasPasscode
            case wiFiMAC = "WiFiMAC"
            case iPAddress = "IPAddress"
            case notes
            case availableCapacity
            case lastCheckin
        }
    }
    public let device: Device
    public let code: Int
}
