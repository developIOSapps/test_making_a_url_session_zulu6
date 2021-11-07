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
    var webApiJsonDecoder = WebApiJsonDecoder()

    //  MARK: -  Stuff for the file manager
    private var fileManger: FileManager = FileManager.default
    
    lazy var docURL: URL = {
        return  fileManger.urls(for: .documentDirectory, in: .userDomainMask).first!
    }()
    
    //  MARK: -  URL Stuff
    var url: URL = URL(string: "https://manage.zuludesk.com/storage/public/1049131/photos/647bba344396e7c8170902bcf2e15551.jpg")!
    
    func retreiveDataAsPictureFle(withURL theUrl: URL, completionHandler: @escaping (Data) -> Void) {
        print("*-* retreiveDataAsPictureFle \(HelperStuf.getTimeStamp()) ")

        let lastPath: String = { theUrl.lastPathComponent}()
        let urlForLocalFile: URL = { docURL.appendingPathComponent(lastPath) }()

        if !fileManger.fileExists(atPath: urlForLocalFile.path) {

            // get the url as string
            let studentPhotoUrl = theUrl.absoluteString
            // create enum instance
            let urlValuesforStudent = URLValues.urlForStudentPic(picUrlString: studentPhotoUrl)
            self.webApiJsonDecoder.getTheClassFromWeb(with: urlValuesforStudent.getUrlRequest(), andSession: urlValuesforStudent.getSession() ) {(data) in
                        
            // [weak self]
                
//                guard let self = self else { return }
                
                
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
        print("*-*  readPicFileFromLocalDataFileandDisplay \(HelperStuf.getTimeStamp()) ")
        readPicFileFromLocalDataFile(withURL: urlForLocalFile, completionHandler: completionHandler)
    }
    
    
     func readPicFileFromLocalDataFile(withURL urlForLocalFile: URL,  completionHandler: @escaping (Data) -> Void) {
         DispatchQueue.main.async {
             do {
                 let data = try Data(contentsOf: urlForLocalFile)
                completionHandler(data)

             } catch  {
                 print(error.localizedDescription)
             }
         }
     }
  

  
    func prepareStudentPhotoRequest(withURL url: URL) -> (URLSession, URLRequest) {
        print(url)
        let session: URLSession = {
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            return session
        }()
        
        let request: URLRequest = {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            return request
        }()
        
        return (session, request)
    }
    
    //  MARK: -  Get  data from web
    func getFromWeb(sessionToUse session: URLSession, urlRequstToUse request: URLRequest,  thenWithResultDo completionHandler: @escaping (Result<Data,Error>) -> Void)  {
        
        //  FIXME: Handle the different type of possible error codes that can occur
        
        /* Start a new Task */
        let task = session.dataTask(with: request)  { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("URL Session Task Succeeded: HTTP \(statusCode)")

            let result = Result<Data,Error> {
                if let error = error {
                    throw error
                } else if let data = data {
                    return data
                } else {
                    throw URLError.unexpectedError
                }
            }
            completionHandler(result)
            
        }
        task.resume()
        session.finishTasksAndInvalidate()
    }

}
