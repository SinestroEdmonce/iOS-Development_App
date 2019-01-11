//
//  AppSettings.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/10.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class AppSettings: NSObject {
    let maxFilesUpload: Int = 1
    let maxPicturesUpload: Int = 3
    let maxAutioUpload: Int = 1
    let maxArticlesInList: Int = 10
    
    private let audioSuffix: [String] = ["mp3", "wma", "wav", "m4a", "flac", "wv", "mp2", "mmf"]
    private let docSuffix: [String] = ["doc", "docx", "pdf", "xls", "ppt", "pptx", "txt"]
    private let archiveSuffix: [String] = ["zip", "tar", "gz", "rar", "jar", "7z", "tgz"]
    private let imageSuffix: [String] = ["jpg", "png", "jpeg", "bmf", "gif", "tif"]
    private let videoSuffix: [String] = ["mp4", "avi", "f4v", "mpg", "mpeg", "wmv", "mov"]
    private let fileType2Image: [String: String] = ["doc": "_doc_image",
                                                    "docx": "_doc_image",
                                                    "pdf": "_pdf_image",
                                                    "xls": "_xls_image",
                                                    "ppt": "_ppt_image",
                                                    "pptx": "_ppt_image",
                                                    "txt": "_txt_image",
                                                    "audio": "_audio_image",
                                                    "video": "_video_image",
                                                    "archive": "_archive_image",
                                                    "others": "_others_image",
                                                    "image": "_image_image",
                                                    "unknown": "_unknown_image"]
    
    
    func isAudio(_ suffix: String) ->Bool {
        for audio in self.audioSuffix {
            if suffix == audio {
                return true
            }
        }
        return false
    }
    
    func isVideo(_ suffix: String) ->Bool {
        for video in self.videoSuffix {
            if suffix == video {
                return true
            }
        }
        return false
    }
    
    func isDocument(_ suffix: String) ->Bool {
        for doc in self.docSuffix {
            if suffix == doc {
                return true
            }
        }
        return false
    }
    
    func isOtherFile(_ suffix: String) -> Bool {
        for doc in self.docSuffix {
            if suffix == doc {
                return false
            }
        }
        return true
    }
    
    func isArchive(_ suffix: String) -> Bool {
        for archive in self.archiveSuffix {
            if suffix == archive {
                return false
            }
        }
        return true
    }
    
    func isImage(_ suffix: String) -> Bool {
        for img in self.imageSuffix {
            if suffix == img {
                return false
            }
        }
        return true
    }
    
    func suffixBack2Image(_ suffix: String) -> String {
        if self.isDocument(suffix) {
            return self.fileType2Image[suffix]!
        }
        else if self.isAudio(suffix) {
            return self.fileType2Image["audio"]!
        }
        else if self.isImage(suffix) {
            return self.fileType2Image["image"]!
        }
        else if self.isOtherFile(suffix) {
            return self.fileType2Image["others"]!
        }
        else if self.isVideo(suffix) {
            return self.fileType2Image["video"]!
        }
        else if self.isArchive(suffix) {
            return self.fileType2Image["archive"]!
        }
        else {
            return self.fileType2Image["unknown"]!
        }
    }
}
