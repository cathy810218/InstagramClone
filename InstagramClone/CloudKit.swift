//
//  CloudKit.swift
//  InstagramClone
//
//  Created by Cathy Oun on 3/28/17.
//  Copyright © 2017 cathyoun. All rights reserved.
//

import Foundation
import CloudKit
import UIKit


typealias PostCompletion = (Bool) -> ()
typealias PostsCompletion = ([Post]?) -> ()

class CloudKit {
    
    static let shared = CloudKit()
    
    let container = CKContainer.default()
    
    var privateDatabase: CKDatabase {
        return container.privateCloudDatabase
    }
    
    var publicDatabase: CKDatabase {
        return container.publicCloudDatabase
    }
    
    func save(post: Post, toPrivateDatabase: Bool, completion: @escaping PostCompletion) {
        do {
            if let record = try Post.recordFor(post: post) {
                
                if toPrivateDatabase {
                    privateDatabase.save(record, completionHandler: { (record, error) in
                        
                        if error != nil {
                            completion(false)
                            return
                        }
                        if let record = record {
                            print(record)
                            completion(true)
                        } else {
                            completion(false)
                        }
                    })
                } else {
                    publicDatabase.save(record, completionHandler: { (record, error) in
                        
                        if error != nil {
                            completion(false)
                            return
                        }
                        if let record = record {
                            print(record)
                            completion(true)
                        } else {
                            completion(false)
                        }
                    })
                }
            }
        } catch {
            print(error)
        }
    }
    
    func getPosts(fromPrivateDatabase: Bool, completion: @escaping PostsCompletion) {
        
        let postQuery = CKQuery(recordType: "Post", predicate: NSPredicate(value: true))
        
        let database = fromPrivateDatabase ? privateDatabase : publicDatabase
        
        database.perform(postQuery, inZoneWith: nil) { (records, error) in
            if error != nil {
                OperationQueue.main.addOperation {
                    completion(nil)
                }
            }
            
            if let records = records {
                var posts = [Post]()
                for record in records {
                    if let asset = record["image"] as? CKAsset {
                        let path = asset.fileURL.path
                        if let image = UIImage(contentsOfFile: path) {
                            let post = Post(image: image, date: record.creationDate!)
                            posts.append(post)
                        }
                    }
                }
                OperationQueue.main.addOperation {
                    completion(posts)
                }
            }
        }
    }
    
}
