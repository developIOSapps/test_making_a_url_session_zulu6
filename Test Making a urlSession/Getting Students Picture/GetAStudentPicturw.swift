//
//  GetAStudentPicturw.swift
//  Test Making a urlSession
//
//  Created by Steven Hertz on 11/7/21.
//  Copyright © 2021 DIA. All rights reserved.
//

import Foundation

//
//  GetAStudentPicture.swift
//  download jamfschool student pic
//
//  Created by Steven Hertz on 10/31/21.
//

import UIKit

class GetAStudentPicture {
    var webApiJsonDecoder: WebApiJsonDecoder!
    var schoolInfo: SchoolInfo!

    //  MARK: -  Stuff for the file manager
    private var fileManger: FileManager = FileManager.default
    
    lazy var docURL: URL = {
        return  fileManger.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()
    
    //  MARK: -  URL Stuff
//    var url: URL = URL(string: "https://manage.zuludesk.com/storage/public/1049131/photos/647bba344396e7c8170902bcf2e15551.jpg")!
    
    func retreiveDataAsPictureFle(withURL theUrl: URL, completionHandler: @escaping (Data) -> Void) {
        print("*-* retreiveDataAsPictureFle \(HelperStuf.getTimeStamp()) ")

        let lastPath: String = { theUrl.lastPathComponent}()
        let urlForLocalFile: URL = { docURL.appendingPathComponent(lastPath) }()

        if !fileManger.fileExists(atPath: urlForLocalFile.path) {

            // get the url as string
            let studentPhotoUrl = theUrl.absoluteString
            // create enum instance
            let urlValuesforStudent = URLValues.urlForStudentPic(picUrlString: studentPhotoUrl, apiKey: schoolInfo.thekey )
            self.webApiJsonDecoder.sendURLReqToProcess(with: urlValuesforStudent.getUrlRequest(), andSession: urlValuesforStudent.getSession() ) {(data) in

                // OK we are fine, we got data - so lets write it to a file so we can retieve it
                let image = UIImage(data: data)
                let targetSize = CGSize(width: 120, height: 90)

                let scaledImage = image!.scalePreservingAspectRatio(
                    targetSize: targetSize
                )
                let scaledData = scaledImage.jpegData(compressionQuality: 0.70)
                
                do { try scaledData?.write(to: urlForLocalFile) }
                catch  {
                    print(error.localizedDescription)
                    fatalError(" could not write the data")
                }
                self.readPicFileFromLocalDataFile(withURL: urlForLocalFile, completionHandler: completionHandler)
                return
            }
        }
        readPicFileFromLocalDataFile(withURL: urlForLocalFile, completionHandler: completionHandler)
    }
    
    
    func readPicFileFromLocalDataFile(withURL urlForLocalFile: URL,  completionHandler: @escaping (Data) -> Void) {
        
        do {
            let data = try Data(contentsOf: urlForLocalFile)
            completionHandler(data)
            
        } catch  {
            print(error.localizedDescription)
        }
    }
  


}
