//
//  UploadState.swift
//  Collexion
//
//  Created by Kevin Tan on 1/5/22.
//

import Foundation

enum UploadState {
  case idle
  case uploading
  case failed(error: Error)
}
