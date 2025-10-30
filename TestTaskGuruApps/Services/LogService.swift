//
//  Untitled.swift
//  TestTaskGuruApps
//
//  Created by Пащенко Иван on 30.10.2025.
//

enum LogType {
    case info
    case error
}

class LogService {
    static func log(_ message: String, type: LogType = .info) {
        switch type {
        case .info:
            print("|-------------------------------|START INFO|-------------------------------|")
            print(message)
            print("|--------------------------------|END INFO|--------------------------------|")
            print("")
        case .error:
            print("|-------------------------------|START ERROR|-------------------------------|")
            print(message)
            print("|--------------------------------|END ERROR|--------------------------------|")
            print("")
        }
    }
}
