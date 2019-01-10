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
    
    let audioSuffix: [String] = ["mp3", "wma", "wav", "m4a", "flac", "wv", "mp2", "mmf"]
    let docSuffix: [String] = ["doc", "docx", "pdf", "xls", "ppt", "pptx", "txt"]
    
    func isAudio(_ suffix: String) ->Bool {
        for audio in self.audioSuffix {
            if suffix == audio {
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
}
