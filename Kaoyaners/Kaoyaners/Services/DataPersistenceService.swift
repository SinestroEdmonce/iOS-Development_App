//
//  DataPersistenceService.swift
//  Kaoyaners
//
//  Created by sinestro on 2019/1/7.
//  Copyright © 2019 cn.nju. All rights reserved.
//

import UIKit

class DataPersistenceService: NSObject {
    private let _defaultUserId: String = "admin"
    private let _defaultUserPwd: String = "1234567"
    private let _defaultAvatar: String = "_avatar_default"
    
    // Different keys
    let userIdKey: String = "userId"
    let userPwdKey: String = "userPwd"
    let photoAuthStatusKey: String = "photoEnables"
    let cameraAuthStatusKey: String = "cameraEnable"
    let favCirclesKey: String = "favCircles"
    let favUsersKey: String = "favUsers"
    let favArticlesKey: String = "favArticles"
    let avatarImageKey: String = "avatarImage"
    let fileNameUploadKey: String = "fileNameUpload"
    let fileNameDownloadKey: String = "fileNameDownload"
    
    // Set Default
    func saveDefault() {
        self.saveCurrentUserId(self._defaultUserId)
        self.saveCurrentPwd(self._defaultUserPwd)
        self.saveAvatarImageUrl(self._defaultAvatar)
        self.savePhotoAuthorization("1")
        self.saveCameraAuthorization("1")
        self.saveFavouriteCircleId([])
        self.saveFavouriteArticleId([])
        self.saveFavouriteUserId([])
        self.saveFileNamesUploaded([])
        self.saveFileNamesDownload([:])
    }
    
    func isDefaultAccount() -> Bool {
        let userDefaults = UserDefaults.standard
        if let currentId = userDefaults.string(forKey: self.userIdKey) {
            return (currentId == self._defaultUserId)
        }
        return true
    }
    
    func isDefaultAvatar() -> Bool {
        let userDefaults = UserDefaults.standard
        if let avatar = userDefaults.string(forKey: self.avatarImageKey) {
            return (avatar == self._defaultAvatar)
        }
        return true
    }

    // User id
    func saveCurrentUserId(_ currentId: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(currentId, forKey: self.userIdKey)
    }
    
    func getCurrentUserId(key: String) -> String {
        let userDefaults = UserDefaults.standard
        if let currentId = userDefaults.string(forKey: key) {
            return currentId
        }
        return self._defaultUserId
    }
    
    // User password
    func saveCurrentPwd(_ currentPwd: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(currentPwd, forKey: self.userPwdKey)
    }

    func getCurrentUserPwd(key: String) -> String {
        let userDefaults = UserDefaults.standard
        if let currentPwd = userDefaults.string(forKey: key) {
            return currentPwd
        }
        return self._defaultUserPwd
    }
    
    // Authorization status
    func savePhotoAuthorization(_ currentStatus: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(currentStatus, forKey: self.photoAuthStatusKey)
    }
    
    func saveCameraAuthorization(_ currentStatus: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(currentStatus, forKey: self.cameraAuthStatusKey)
    }

    func getCurrentAuthStatus(key: String) -> Bool {
        let userDefaults = UserDefaults.standard
        if let authStatus = userDefaults.string(forKey: key) {
            if authStatus == "1" {
                return true
            }
            else {
                return false
            }
        }
        return false
    }

    // Favourite circles
    func saveFavouriteCircleId(_ circleId: [String]) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(circleId, forKey: self.favCirclesKey)
    }
    
    func appendFavouriteCircleId(_ circleId: [String]) {
        let userDefaults = UserDefaults.standard
        if var currentFavCircles = userDefaults.stringArray(forKey: self.favCirclesKey) {
            currentFavCircles.append(contentsOf: circleId)
            userDefaults.set(currentFavCircles, forKey: self.favCirclesKey)
        }
        else {
            userDefaults.set(circleId, forKey: self.favCirclesKey)
        }
    }
    
    func getFavouriteCircleId(key: String) -> [String] {
        let userDefaults = UserDefaults.standard
        if let favCircles = userDefaults.stringArray(forKey: key) {
            return favCircles
        }
        return []
    }
    
    // Favourite users
    func saveFavouriteUserId(_ userId: [String]) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(userId, forKey: self.favUsersKey)
    }
    
    func appendFavouriteUserId(_ userId: [String]) {
        let userDefaults = UserDefaults.standard
        if var currentFavUsers = userDefaults.stringArray(forKey: self.favUsersKey) {
            currentFavUsers.append(contentsOf: userId)
            userDefaults.set(currentFavUsers, forKey: self.favUsersKey)
        }
        else {
            userDefaults.set(userId, forKey: self.favUsersKey)
        }
    }
    
    func getFavouriteUserId(key: String) -> [String] {
        let userDefaults = UserDefaults.standard
        if let favUser = userDefaults.stringArray(forKey: key) {
            return favUser
        }
        return []
    }
    
    // Favourite articles
    func saveFavouriteArticleId(_ articleId: [String]) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(articleId, forKey: self.favArticlesKey)
    }
    
    func appendFavouriteArticleId(_ articleId: [String]) {
        let userDefaults = UserDefaults.standard
        if var currentFavArticles = userDefaults.stringArray(forKey: self.favArticlesKey) {
            currentFavArticles.append(contentsOf: articleId)
            userDefaults.set(currentFavArticles, forKey: self.favArticlesKey)
        }
        else {
            userDefaults.set(articleId, forKey: self.favArticlesKey)
        }
    }
    
    func getFavouriteArticleId(key: String) -> [String] {
        let userDefaults = UserDefaults.standard
        if let favArticles = userDefaults.stringArray(forKey: key) {
            return favArticles
        }
        return []
    }
    
    // Avatar image URL
    func saveAvatarImageUrl(_ currentAvatar: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(currentAvatar, forKey: self.avatarImageKey)
    }
    
    func getAvatarImage(key: String) -> String {
        let userDefaults = UserDefaults.standard
        // Whether login in and exist an account
        if let userId = userDefaults.string(forKey: self.userIdKey) {
            if userId == self._defaultUserId {
                return self._defaultAvatar
            }
        }
        else {
            return self._defaultAvatar
        }
        
        if let favUser = userDefaults.string(forKey: key) {
            return favUser
        }
        return self._defaultAvatar
    }
    
    // Files shared on 'my' own
    func saveFileNamesUploaded(_ fileName: [String]) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(fileName, forKey: self.fileNameUploadKey)
    }
    
    func appendFileNamesUpload(_ fileName: [String]) {
        let userDefaults = UserDefaults.standard
        if var currentFileName = userDefaults.stringArray(forKey: self.fileNameUploadKey) {
            currentFileName.append(contentsOf: fileName)
            userDefaults.set(currentFileName, forKey: self.fileNameUploadKey)
        }
        else {
            userDefaults.set(fileName, forKey: self.fileNameUploadKey)
        }
    }
    
    func getFileNamesUpload(key: String) -> [String] {
        let userDefaults = UserDefaults.standard
        if let fileNames = userDefaults.stringArray(forKey: key) {
            return fileNames
        }
        return []
    }
    
    // Files dowloaded on 'my' own
    func saveFileNamesDownload(_ fileName: [String: String]) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(fileName, forKey: self.fileNameDownloadKey)
    }
    
    func appendFileNamesDownload(_ fileName: [String: String]) {
        let userDefaults = UserDefaults.standard
        if let currentFileName = userDefaults.object(forKey: self.fileNameDownloadKey) {
            var fileDict = currentFileName as! [String: String]
            fileDict.merge(fileName, uniquingKeysWith: { (old, new) in new })
            userDefaults.set(fileDict, forKey: self.fileNameDownloadKey)
        }
        else {
            userDefaults.set(fileName, forKey: self.fileNameDownloadKey)
        }
    }
    
    func getFileNamesDownload(key: String) -> [String: String] {
        let userDefaults = UserDefaults.standard
        if let fileNames = userDefaults.object(forKey: key) {
            return (fileNames as! [String: String])
        }
        return [:]
    }
    
}
