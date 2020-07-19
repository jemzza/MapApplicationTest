//
//  FirebaseCollectionReference.swift
//  MapApplicationTest
//
//  Created by Alexander on 19.07.2020.
//  Copyright © 2020 Alexander Litvinov. All rights reserved.
//

import FirebaseFirestore

enum FCollectionReference: String {
  case User
  case Category
  case Items
  case Basket
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
  return Firestore.firestore().collection(collectionReference.rawValue)
}
