//
//  NetworkingEnumerations.swift
//  Demo
//
//  Created by Ruslan Mishyn on 07.06.2021.
//

import Foundation

/// List of fields used in header of HTTP requests
enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case acceptType = "Accept"
}

/// List of possible values used in `Content-Type` header parameter of HTTP requests
enum HTTPContentType: String {
    case any = "*/*"
    case json = "application/json"
}

///// List of possible attachment types used in HTTP requests (1st part of MIME)
//enum AttachmentType: String {
//    case undefined = "undefined"
//    case audio = "audio"
//    case video = "video"
//    case image = "image"
//    case location = "location"
//    case application = "application"
//}
//
///// List of possible resource types used in HTTP requests (2nd parameter of MIME)
//enum FileType: String {
//    case undefined = "undefined"
//    case jpeg = "jpeg"
//    case png = "png"
//    case svg = "svg"
//    case pdf = "pdf"
//    
//    /// Attachment type which must be used with current resource type to build MIME
//    var attachment: AttachmentType {
//        switch self {
//        case .undefined: return .undefined
//        case .jpeg, .png, .svg: return .image
//        case .pdf: return .application
//        }
//    }
//}
//
///// Structure describing a MIME type of HTTP request
//struct MimeType {
//    /// String representation of MIME type used in `Accept` header parameter of HTTP requests
//    var value: String { "\(attachmentType.rawValue)/\(fileType.rawValue)" }
//    /// Attachment type of MIME (1st part of representation)
//    let attachmentType: AttachmentType
//    /// Resource type of MIME (2nd part of representation)
//    let fileType: FileType
//}
