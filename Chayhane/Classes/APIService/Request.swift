//
//  Request.swift
//  Chayhane
//
//  Created by djepbarov on 11.07.2018.
//  Copyright © 2018 chayhane. All rights reserved.
//

import Foundation

class MyRequestController {
    func sendRequest(to token: String, message: String, title: String, sound: String, selectedSound: String,  completionHandler: @escaping (String)-> Void){
        var stringWillReturn = ""
        /* Configure session, choose between:
         * defaultSessionConfiguration
         * ephemeralSessionConfiguration
         * backgroundSessionConfigurationWithIdentifier:
         And set session-wide properties, such as: HTTPAdditionalHeaders,
         HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
         */
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        /* Create the Request:
         Request (5) (POST https://fcm.googleapis.com/fcm/send)
         */
        
        guard let URL = URL(string: "https://fcm.googleapis.com/fcm/send") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        
        // Headers
        
        request.addValue("key=AAAA_p9bScY:APA91bFUjMf_mKfapJcw0BkI7PZI4UYxAQbJsZHLx5kvd1YM8viNkBrIfjiBxlmWA8XV3EWAmF1zXFXFSVpAiFb0yDXZJ2KiX_mvbColtyPPjgM4K6oOT_CW6JUn85UKECB01laM5qSP3b9uBfwmhzEk537X49UNew", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // JSON Body
        let bodyObject: [String : Any] = [
            "notification": [
                "title": title,
                "sound": sound,
                "body": message
            ],
            "to": token,
        ]
        
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: bodyObject, options: [])
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                stringWillReturn = "Successful"
                completionHandler(stringWillReturn)
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
                stringWillReturn = "Unsuccessful"
                completionHandler(stringWillReturn)
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}



