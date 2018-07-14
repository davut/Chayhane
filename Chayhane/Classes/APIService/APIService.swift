//
//  APIService.swift
//  Chayhane
//
//  Created by djepbarov on 9.07.2018.
//  Copyright © 2018 chayhane. All rights reserved.
//

import Firebase

class APIService {
    private var whoIs: String?
    private var db : Firestore?
    var items = [Item]()
    func getDatas(successCallback: @escaping ([Item]) -> ()) {
        db = Firestore.firestore()
        db?.collection("products").addSnapshotListener({ (query, err) in
            guard let queries = query else {return}
            self.items.removeAll()
            for document in queries.documents {
                var item = Item()
                let data = document.data()
                item.id = data["id"]! as? String
                item.label = data["name"]! as? String
                item.image = data["image"]! as? String
                item.isDrink = data["isDrink"]! as? Bool
                if let numberOfItem = data["numberOfItem"] as? Int {
                    item.numberOfItem = numberOfItem
                }
                self.items.append(item)
                successCallback(self.items)
            }
        })
    }
    
    func getDuty(successCallback: @escaping(String?, String?, String?)->()) {
        db = Firestore.firestore()
        db?.collection("duty").getDocuments(completion: { (query, error) in
            guard let query = query else {return}
            for document in query.documents {
                let name = document.data()["name"] as? String
                let token = document.data()["token"] as? String
                let uid = document.data()["uid"] as? String
                successCallback(name,token,uid)
            }
        })
    }
    
    func getCurrentUser(successCallback: @escaping(String)->())  {
        db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        db?.collection("users").whereField("uid", isEqualTo: uid!).getDocuments(completion: { (q, err) in
            guard let query = q else {return}
            for document in query.documents {
                successCallback((document.data()["role"] as? String)!)
            }
        })
    }
    
    
    func checkUser(successCallback: @escaping(String) -> ()) {
        db = Firestore.firestore()
        db?.collection("users").getDocuments(completion: { (query, err) in
            guard let queries = query else {return}
            for document in queries.documents {
                let data = document.data()
                self.whoIs = data["role"]! as? String
                successCallback(self.whoIs!)
            }
        })
    }
    
    
    func userIs() -> String? {
        self.checkUser { (role) in
            self.whoIs = role
        }
        return self.whoIs
    }
    
}
