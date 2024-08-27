//
//  AnalyticsManager.swift
//  Todorim
//
//  Created by suni on 8/27/24.
//

import Foundation

import FirebaseAnalytics

class AnalyticsManager {
    static let shared = AnalyticsManager()
    // swiftlint:disable identifier_name
    enum EventName: String {
        // APP
        case OPEN_APP_PUSH
        case OPEN_APP
        case TAP_PERMISSION_PUSH_YES
        case TAP_PERMISSION_PUSH_NO
        case TAP_PERMISSION_IDAF_YES
        case TAP_PERMISSION_IDAF_NO
        case TAP_UPDATE_GO
        case TAP_UPDATE_LATER
        case ALERT_ERROR
        case ALERT_REQUEST_PERMISSION_PUSH
        case ALERT_REQUEST_PERMISSION_LOCATION
        case VIEW_ADS
        
        // SETTING
        case VIEW_SETTING
        case TAP_PURCHASE
        case TAP_RESTORE
        case TAP_APPREVIEW_GO
        case TAP_CONTACTUS
                
        // HOME
        case VIEW_HOME
        case TAP_HOME_WRITE_GROUP
        case TAP_HOME_COMPLETE_TODO
        case TAP_HOME_UNCOMPLETE_TODO
        
        // GROUP DETAIL
        case VIEW_GROUP_DETAIL
        case TAP_DETAIL_COMPLETE_TODO
        case TAP_DETAIL_UNCOMPLETE_TODO
        case SUCCESS_DELETE_TODO
                        
        // WRITE GROUP
        case VIEW_WRITE_GROUP
        case TAP_WRITE_GROUP_COLOR
        case SUCCESS_WRITE_GROUP
        
        // EDIT GROUP
        case VIEW_EDIT_GROUP
        case TAP_EDIT_GROUP_COLOR
        case SUCCESS_DELETE_GROUP
        case SUCCESS_EDIT_GROUP
        
        // WRITE TODO
        case VIEW_WRITE_TODO
        case TAP_SELECT_TODO_GROUP
        case TAP_DATE_NOTI_ON
        case TAP_DATE_NOTI_OFF
        case TAP_DATE_NOTI_REPEAT
        case TAP_LOCATION_NOTI_ON
        case TAP_LOCATION_NOTI_OFF
        case SUCCESS_WRITE_TODO
        
        case VIEW_SEARCH_LOCATION
        case TAP_SEARCH_POSITION
        case VIEW_SEARCH_LOCATION_TABLE
        case VIEW_SEARCH_LOCATION_MAP
        case TAP_LOCATION_TYPE
        case TAP_COMPLETE_SEARCH_LOCATION
        
        // EDIT TODO
        case VIEW_EDIT_TODO
        case SUCCESS_EDIT_TODO
    }
    
    private let errorEventNames: Set<EventName> = [
        .ALERT_ERROR
    ]
    
    enum EventParameter: String {
        case TIME_STAMP
        case APP_VERSION
        case ERROR_TITLE
        case TODO_COUNT
        case GROUP_COUNT
        case IS_COMPLETE
        case COLOR_INDEX
        case IS_DATE_NOTI
        case REPEAT_TYPE
        case IS_LOCATION_NOTI
        case RADIUS
        case LOCATION_TYPE
    }
    // swiftlint:enable identifier_name
    
    // 이벤트 로깅 메서드
    func logEvent(_ event: EventName, parameters: [EventParameter: Any]? = nil) {
        var fullParameters = parameters
         
         // 오류 이벤트의 경우 기본 파라미터 추가
         if errorEventNames.contains(event) {
             fullParameters?[.APP_VERSION] = Constants.appVersion
             fullParameters?[.TIME_STAMP] = Utils.getCurrentKSTTimestamp()
         }
         
         let params = fullParameters?.reduce(into: [String: Any]()) { result, param in
             result[param.key.rawValue] = param.value
         }
         
        if let params {
            print("Analytics.logEvent - \(event.rawValue) : \(params)")
            Analytics.logEvent(event.rawValue, parameters: params)
        } else {
            print("Analytics.logEvent - \(event.rawValue)")
            Analytics.logEvent(event.rawValue, parameters: nil)
        }
    }
}
