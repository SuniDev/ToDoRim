//
//  Utils.swift
//  Todorim
//
//  Created by suni on 8/12/24.
//

import UIKit
import FirebaseRemoteConfig
import StoreKit
import AppTrackingTransparency
import AdSupport
import FirebaseAnalytics

class Utils {
    static func getHorizontalLayer(frame: CGRect, colors: [UIColor]) -> CAGradientLayer {
        return CAGradientLayer(frame: frame, colors: colors, startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1.0, y: 0.5))
    }
    
    static func getVerticalLayer(frame: CGRect, colors: [UIColor]) -> CAGradientLayer {
        return CAGradientLayer(frame: frame, colors: colors, startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1))
    }
    
    static func getCompleteAttributedText(with text: String) -> NSMutableAttributedString {
        let attribute = NSMutableAttributedString(string: text)
        attribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attribute.length))
        return attribute
    }
    
    static func moveAppStore() {
        if let appStoreURL = URL(string: "https://apps.apple.com/app/\(Constants.appStoreId)") {
            DispatchQueue.main.async {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    static func moveAppReviewInStore() {
        if let appStoreURL = URL(string: "https://apps.apple.com/app/\(Constants.appStoreId)?action=write-review") {
            DispatchQueue.main.async {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    static func moveAppSetting() {
        if let appSetting = URL(string: UIApplication.openSettingsURLString) {
            DispatchQueue.main.async {
                UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
            }
        }
    }
    
    static var remoteConfig: RemoteConfig?
    
    static func initConfig() {
        if remoteConfig == nil {
            remoteConfig = RemoteConfig.remoteConfig()
            // 개발 모드에서는 신속한 테스트를 위해 최소 페치 간격을 설정합니다.
            let settings = RemoteConfigSettings()
            settings.minimumFetchInterval = 0
            remoteConfig?.configSettings = settings
            
            // 디폴트 값 설정 (옵션)
            remoteConfig?.setDefaults(fromPlist: "RemoteConfigDefaults")
        }
    }
    
    enum AppUpdate {
        case forceUpdate
        case latestUpdate
        case none
    }
    
    enum AppVersionKey: String {
        case forceUpdateVersion
        case latestUpdateVersion
        
        func getKey() -> String {
        #if DEBUG
            return self.rawValue + "_dev"
        #else
            return self.rawValue
        #endif
        }
    }
    
    static func checkForUpdate(completion: @escaping (_ update: AppUpdate, _ storeVersion: String?) -> Void) {
        guard let remoteConfig else {
            completion(.none, nil)
            return
        }

        // Remote Config 값 가져오기
        remoteConfig.fetch { status, error in
            guard error == nil, status == .success else {
                completion(.none, nil)
                return
            }

            remoteConfig.activate { _, error in
                guard error == nil else {
                    completion(.none, nil)
                    return
                }

                // 버전 값 가져오기
                let forceVersion = remoteConfig[AppVersionKey.forceUpdateVersion.getKey()].stringValue
                let latestVersion = remoteConfig[AppVersionKey.latestUpdateVersion.getKey()].stringValue
                let currentVersion = Constants.appVersion

                // 강제 업데이트 확인
                if versionNeedsUpdate(currentVersion, comparedTo: forceVersion) {
                    completion(.forceUpdate, forceVersion)
                    return
                }

                // 최신 업데이트 확인
                if versionNeedsUpdate(currentVersion, comparedTo: latestVersion) {
                    completion(.latestUpdate, latestVersion)
                    return
                }

                // 업데이트가 없음
                completion(.none, latestVersion)
            }
        }
    }

    private static func versionNeedsUpdate(_ currentVersion: String, comparedTo newVersion: String) -> Bool {
        let currentComponents = currentVersion.split(separator: ".").map { Int($0) ?? 0 }
        let newComponents = newVersion.split(separator: ".").map { Int($0) ?? 0 }

        for index in 0..<max(currentComponents.count, newComponents.count) {
            let current = index < currentComponents.count ? currentComponents[index] : 0
            let new = index < newComponents.count ? newComponents[index] : 0
            if current < new {
                return true
            } else if current > new {
                return false
            }
        }

        return false
    }
    
    static func isJailbroken() -> Bool {
        #if targetEnvironment(simulator)
        // 시뮬레이터에서는 탈옥 확인을 하지 않습니다.
        return false
        #else
        // 탈옥된 디바이스에서 발견될 수 있는 경로들
        let jailbreakFilePaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/",
            "/private/var/stash"
        ]
        
        // 탈옥 관련 파일 존재 여부 확인
        for path in jailbreakFilePaths where FileManager.default.fileExists(atPath: path) {
            return true
        }
        
        // 시스템 디렉토리에 쓰기 권한 테스트
        let testPath = "/private/jailbreakTest.txt"
        do {
            try "This is a test.".write(toFile: testPath, atomically: true, encoding: .utf8)
            // 쓰기 성공 시 탈옥된 것으로 간주
            try FileManager.default.removeItem(atPath: testPath)
            return true
        } catch {
            // 쓰기 실패 시 탈옥되지 않은 것으로 간주
        }
        
        // Cydia URL Scheme 확인
        if let cydiaUrl = URL(string: "cydia://package/com.example.package"), UIApplication.shared.canOpenURL(cydiaUrl) {
            return true
        }
        
        return false
        #endif
    }
    
    static func requestTrackingAuthorization(completion: @escaping () -> Void) {
        ATTrackingManager.requestTrackingAuthorization { status in
            let isShowRequestIDAFAuth = UserDefaultStorage.getObject(forKey: .isShowRequestIDAFAuth)
            switch status {
            case .authorized:
                if !(isShowRequestIDAFAuth as? Bool ?? false) {
                    UserDefaultStorage.set(true, forKey: .isShowRequestIDAFAuth)
                }
                Analytics.setAnalyticsCollectionEnabled(true)
                completion()
            case.denied:
                if !(isShowRequestIDAFAuth as? Bool ?? false) {
                    UserDefaultStorage.set(true, forKey: .isShowRequestIDAFAuth)
                }
                Analytics.setAnalyticsCollectionEnabled(false)
                completion()
            case.notDetermined:
                Utils.retryRequestTrackingPermission(completion: completion)
            case.restricted:
                Analytics.setAnalyticsCollectionEnabled(false)
                completion()
            default:
                Analytics.setAnalyticsCollectionEnabled(false)
                completion()
            }
        }
    }
    
    static func retryRequestTrackingPermission(completion: @escaping () -> Void) {
        // 권한이 아직 결정되지 않은 상태
        ATTrackingManager.requestTrackingAuthorization { status in
            let isShowRequestIDAFAuth = UserDefaultStorage.getObject(forKey: .isShowRequestIDAFAuth)
            switch status {
            case .authorized:
                if !(isShowRequestIDAFAuth as? Bool ?? false) {
                    UserDefaultStorage.set(true, forKey: .isShowRequestIDAFAuth)
                }
                Analytics.setAnalyticsCollectionEnabled(true)
            case .denied:
                if !(isShowRequestIDAFAuth as? Bool ?? false) {
                    UserDefaultStorage.set(true, forKey: .isShowRequestIDAFAuth)
                }
                Analytics.setAnalyticsCollectionEnabled(false)
            case .restricted, .notDetermined:
                Analytics.setAnalyticsCollectionEnabled(false)
            @unknown default:
                Analytics.setAnalyticsCollectionEnabled(false)
            }
            completion()
        }
    }
    
    static var isAdsRemoved: Bool {
        return UserDefaultStorage.getObject(forKey: .isAdsRemoved) as? Bool ?? false
    }
}
