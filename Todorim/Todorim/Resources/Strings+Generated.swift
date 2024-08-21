// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Alert {
    internal enum AuthLocation {
      /// 기기의 '설정 > 개인정보보호' 에서 위치 접근을 허용해 주세요.
      internal static let message = L10n.tr("Localizable", "alert. auth_location. message", fallback: "기기의 '설정 > 개인정보보호' 에서 위치 접근을 허용해 주세요.")
      /// 위치 서비스를 이용할 수 없습니다.
      internal static let title = L10n.tr("Localizable", "alert. auth_location. title", fallback: "위치 서비스를 이용할 수 없습니다.")
    }
    internal enum AuthNoti {
      /// 기기의 '설정 > ToDoRim' 에서 알림을 허용해 주세요.
      internal static let message = L10n.tr("Localizable", "alert. auth_noti. message", fallback: "기기의 '설정 > ToDoRim' 에서 알림을 허용해 주세요.")
      /// 알림 서비스를 이용할 수 없습니다.
      internal static let title = L10n.tr("Localizable", "alert. auth_noti. title", fallback: "알림 서비스를 이용할 수 없습니다.")
    }
    internal enum Button {
      /// 취소
      internal static let cancel = L10n.tr("Localizable", "alert. button. cancel", fallback: "취소")
      /// 삭제
      internal static let delete = L10n.tr("Localizable", "alert. button. delete", fallback: "삭제")
      /// 확인
      internal static let done = L10n.tr("Localizable", "alert. button. done", fallback: "확인")
      /// 나중에
      internal static let later = L10n.tr("Localizable", "alert. button. later", fallback: "나중에")
      /// 업데이트
      internal static let update = L10n.tr("Localizable", "alert. button. update", fallback: "업데이트")
    }
    internal enum DeleteGroup {
      /// 그룹내 할일이 모두 삭제됩니다.
      internal static let message = L10n.tr("Localizable", "alert. delete_group. message", fallback: "그룹내 할일이 모두 삭제됩니다.")
      /// 그룹을 삭제하시겠습니까?
      internal static let title = L10n.tr("Localizable", "alert. delete_group. title", fallback: "그룹을 삭제하시겠습니까?")
    }
    internal enum ForceUpdate {
      /// ToDoRim을 계속 사용하려면 새로운 버전으로 업데이트해야 해요. 지금 바로 업데이트해 주세요!
      internal static let message = L10n.tr("Localizable", "alert. force_update. message", fallback: "ToDoRim을 계속 사용하려면 새로운 버전으로 업데이트해야 해요. 지금 바로 업데이트해 주세요!")
      /// 업데이트가 필요합니다.
      internal static let title = L10n.tr("Localizable", "alert. force_update. title", fallback: "업데이트가 필요합니다.")
    }
    internal enum LatestUpdate {
      /// ToDoRim의 새로운 기능과 개선된 성능을 경험할 수 있어요. 앱을 지금 최신 버전으로 업데이트해 보세요!
      internal static let message = L10n.tr("Localizable", "alert. latest_update. message", fallback: "ToDoRim의 새로운 기능과 개선된 성능을 경험할 수 있어요. 앱을 지금 최신 버전으로 업데이트해 보세요!")
      /// 새로운 버전 업데이트가 있어요
      internal static let title = L10n.tr("Localizable", "alert. latest_update. title", fallback: "새로운 버전 업데이트가 있어요")
    }
    internal enum SearchLocation {
      internal enum RadiusWarning {
        /// 반경은 최소 100m 이상 입니다.
        internal static let title = L10n.tr("Localizable", "alert. search_location. radius_warning. title", fallback: "반경은 최소 100m 이상 입니다.")
      }
      internal enum TextWarning {
        /// 잘못된 입력입니다.
        internal static let title = L10n.tr("Localizable", "alert. search_location. text_warning. title", fallback: "잘못된 입력입니다.")
      }
    }
    internal enum WriteGroup {
      internal enum EmptyName {
        /// 그룹 이름을 입력하세요.
        internal static let title = L10n.tr("Localizable", "alert. write_group. empty_name. title", fallback: "그룹 이름을 입력하세요.")
      }
    }
    internal enum WriteTodo {
      internal enum EmptyDate {
        /// 알림 날짜를 선택하세요.
        internal static let title = L10n.tr("Localizable", "alert. write_todo. empty_date. title", fallback: "알림 날짜를 선택하세요.")
      }
      internal enum EmptyLocation {
        /// 알림 위치를 선택하세요.
        internal static let title = L10n.tr("Localizable", "alert. write_todo. empty_location. title", fallback: "알림 위치를 선택하세요.")
      }
      internal enum EmptyMonth {
        /// 알림 월을 선택하세요.
        internal static let title = L10n.tr("Localizable", "alert. write_todo. empty_month. title", fallback: "알림 월을 선택하세요.")
      }
      internal enum EmptyName {
        /// 할일 이름을 입력하세요.
        internal static let title = L10n.tr("Localizable", "alert. write_todo. empty_name. title", fallback: "할일 이름을 입력하세요.")
      }
      internal enum EmptyTime {
        /// 알림 시간을 선택하세요.
        internal static let title = L10n.tr("Localizable", "alert. write_todo. empty_time. title", fallback: "알림 시간을 선택하세요.")
      }
      internal enum EmptyWeek {
        /// 알림 요일을 선택하세요.
        internal static let title = L10n.tr("Localizable", "alert. write_todo. empty_week. title", fallback: "알림 요일을 선택하세요.")
      }
    }
  }
  internal enum Button {
    /// 추가
    internal static let add = L10n.tr("Localizable", "button. add", fallback: "추가")
    /// 수정
    internal static let edit = L10n.tr("Localizable", "button. edit", fallback: "수정")
  }
  internal enum Group {
    internal enum Edit {
      /// 그룹 수정
      internal static let title = L10n.tr("Localizable", "group. edit. title", fallback: "그룹 수정")
    }
    internal enum Init {
      /// 그룹을 커스텀해보세요!
      internal static let title = L10n.tr("Localizable", "group. init. title", fallback: "그룹을 커스텀해보세요!")
    }
    internal enum Write {
      /// 그룹 추가
      internal static let title = L10n.tr("Localizable", "group. write. title", fallback: "그룹 추가")
    }
  }
  internal enum Location {
    /// 현재 위치
    internal static let current = L10n.tr("Localizable", "location. current", fallback: "현재 위치")
    /// Localizable.strings
    ///   Todorim
    /// 
    ///   Created by suni on 8/12/24.
    internal static let entry = L10n.tr("Localizable", "location. entry", fallback: "도착할 때")
    /// 출발할 때
    internal static let exit = L10n.tr("Localizable", "location. exit", fallback: "출발할 때")
    internal enum Search {
      /// 장소를 검색하세요.
      internal static let placeholder = L10n.tr("Localizable", "location. search. placeholder", fallback: "장소를 검색하세요.")
    }
  }
  internal enum Picker {
    internal enum Day {
      /// 반복할 일을 선택하세요.
      internal static let placeholder = L10n.tr("Localizable", "picker. day. placeholder", fallback: "반복할 일을 선택하세요.")
    }
    internal enum Week {
      /// 반복할 요일을 선택하세요.
      internal static let placeholder = L10n.tr("Localizable", "picker. week. placeholder", fallback: "반복할 요일을 선택하세요.")
    }
  }
  internal enum Repeat {
    /// 매일
    internal static let daily = L10n.tr("Localizable", "repeat. daily", fallback: "매일")
    /// 매월
    internal static let monthly = L10n.tr("Localizable", "repeat. monthly", fallback: "매월")
    /// 반복안함
    internal static let `none` = L10n.tr("Localizable", "repeat. none", fallback: "반복안함")
    /// 매주
    internal static let weekly = L10n.tr("Localizable", "repeat. weekly", fallback: "매주")
  }
  internal enum Todo {
    internal enum Edit {
      /// 할일 수정
      internal static let title = L10n.tr("Localizable", "todo. edit. title", fallback: "할일 수정")
    }
    internal enum Init {
      /// 할일을 추가해보세요
      internal static let title = L10n.tr("Localizable", "todo. init. title", fallback: "할일을 추가해보세요")
    }
    internal enum SelectLocation {
      /// 위치 선택
      internal static let title = L10n.tr("Localizable", "todo. select_location. title", fallback: "위치 선택")
    }
    internal enum Write {
      /// 할일 추가
      internal static let title = L10n.tr("Localizable", "todo. write. title", fallback: "할일 추가")
    }
  }
  internal enum Week {
    /// 금요일
    internal static let friday = L10n.tr("Localizable", "week. friday", fallback: "금요일")
    /// 월요일
    internal static let monday = L10n.tr("Localizable", "week. monday", fallback: "월요일")
    /// 토요일
    internal static let saturday = L10n.tr("Localizable", "week. saturday", fallback: "토요일")
    /// 일요일
    internal static let sunday = L10n.tr("Localizable", "week. sunday", fallback: "일요일")
    /// 목요일
    internal static let thursday = L10n.tr("Localizable", "week. thursday", fallback: "목요일")
    /// 화요일
    internal static let tuesday = L10n.tr("Localizable", "week. tuesday", fallback: "화요일")
    /// 수요일
    internal static let wednesday = L10n.tr("Localizable", "week. wednesday", fallback: "수요일")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
