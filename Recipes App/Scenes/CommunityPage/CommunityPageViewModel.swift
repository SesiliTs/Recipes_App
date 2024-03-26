//
//  CommunityPageViewModel.swift
//  Recipes App
//
//  Created by Sesili Tsikaridze on 26.03.24.
//

import Foundation
import FirebaseFirestore

final class CommunityPageViewModel {
    
    @Published var allPosts = [Post]()
    
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
    
}
