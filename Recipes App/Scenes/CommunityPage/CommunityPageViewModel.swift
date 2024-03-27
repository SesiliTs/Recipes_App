//
//  CommunityPageViewModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 26.03.24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class CommunityPageViewModel {
    
    @Published var allPosts = [Post]()
    private var currentUser: User?
    
    init() {
        fetchPosts { posts in
            self.allPosts = posts
        }
    }
    
    func fetchPosts(completion: @escaping ([Post]) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("posts").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion([])
            } else {
                var posts = [Post]()
                for document in querySnapshot!.documents {
                    do {
                        if let post = try document.data(as: Post?.self) {
                            posts.append(post)
                        } else {
                            print("Error decoding recipe data for document: \(document.documentID)")
                        }
                    } catch {
                        print("Error decoding recipe data for document: \(document.documentID), error: \(error)")
                    }
                }
                completion(posts)
            }
        }
    }
    
    func fetchComments(for postId: String, completion: @escaping ([Comment]) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("posts").document(postId).collection("comments").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion([])
            } else {
                var comments = [Comment]()
                for document in querySnapshot!.documents {
                    do {
                        if let comment = try document.data(as: Comment?.self) {
                            comments.append(comment)
                        } else {
                            print("Error decoding comment data for document: \(document.documentID)")
                        }
                    } catch {
                        print("Error decoding comment data for document: \(document.documentID), error: \(error)")
                    }
                }
                completion(comments)
            }
        }
    }
    
    //    func addPost(_ post: Post, completion: @escaping (Error?) -> Void) {
    //        let db = Firestore.firestore()
    //
    //        do {
    //            let postData = try Firestore.Encoder().encode(post)
    //
    //            db.collection("posts").addDocument(data: postData) { error in
    //                if let error = error {
    //                    print("Error adding document: \(error)")
    //                    completion(error)
    //                } else {
    //                    completion(nil)
    //                }
    //            }
    //        } catch {
    //            print("Error encoding post data: \(error)")
    //            completion(error)
    //        }
    //    }
    
    func addPost(question: String, body: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let postId = UUID().uuidString
        
        let dateFormatter = DateFormatter.postDateFormatter()
        let dateString = dateFormatter.string(from: Date())
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetching user data: \(error)")
                completion(error)
            } else if let snapshot = snapshot, snapshot.exists {
                if let data = snapshot.data(),
                   let userName = data["fullname"] as? String,
                   let imageURL = data["photoURL"] as? String {
                    
                    let postData: [String: Any] = [
                        "id": postId,
                        "question": question,
                        "body": body,
                        "userName": userName,
                        "date": dateString,
                        "imageURL": imageURL
                    ]
                    
                    db.collection("posts").document(postId).setData(postData) { error in
                        if let error = error {
                            print("Error adding document: \(error)")
                            completion(error)
                        } else {
                            completion(nil)
                        }
                    }
                } else {
                    let error = NSError(domain: "ViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "User data not found"])
                    completion(error)
                }
            } else {
                let error = NSError(domain: "ViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "User document does not exist"])
                completion(error)
            }
        }
    }
    
}
