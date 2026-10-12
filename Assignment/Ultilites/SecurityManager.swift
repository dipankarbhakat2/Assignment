//
//  SecurityManager.swift
//  Assignment
//
//  Created by Dipankar Bhakat on 12/10/26.
//

import Foundation
import Observation
import UIKit

@Observable
final class SecurityManager {
    private(set) var isDeviceJailbroken: Bool = false
    init() {
        self.isDeviceJailbroken = checkJailbreakStatus()
    }
    // Executes multiple lightweight heuristics to check for a jailbroken environment.
    func checkJailbreakStatus() -> Bool {
        #if targetEnvironment(simulator)
        return false // Skip checks on Xcode Simulator
        #endif
        // 1. Check for common jailbreak files/apps
        let jailbreakPaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/"
        ]
        for path in jailbreakPaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        // 2. Check Sandbox Violations (Try writing to a system directory)
        let sampleText = "Jailbreak Detection Test"
        let systemPath = "/private/jailbreak_test.txt"
        do {
            try sampleText.write(toFile: systemPath, atomically: true, encoding: .utf8)
            // If writing succeeds, the sandbox is broken (device is jailbroken)
            try? FileManager.default.removeItem(atPath: systemPath)
            return true
        } catch {
            // Fails as expected on a secure, sandboxed device
        }
        // 3. Check if system links can be opened
        if let cydiaURL = URL(string: "cydia://package/com.example.package"),
           UIApplication.shared.canOpenURL(cydiaURL) {
            return true
        }
        return false
    }
}
