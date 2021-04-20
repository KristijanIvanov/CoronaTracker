//
//  UIAlertController+Extensions.swift
//  HiHo-App
//
//  Created by Georgy Timoshin on 07.07.2020.
//  Copyright © 2020 HiHo. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {

    public func addActions(actions: [UIAlertAction]) {
        for action in actions {
            self.addAction(action)
        }
    }

    static func okAlert(withTitle title: String? = nil, withMessage message: String? = nil) -> UIAlertController.Builder {
        return UIAlertController.Builder()
            .withTitle(title)
            .withMessage(message)
            .addOkAction()
    }

    class Builder {
        private var preferredStyle: UIAlertController.Style = .alert
        private var title: String?
        private var message: String?
        private var actions: [UIAlertAction] = [UIAlertAction]()
        private var popoverSourceView: UIView?
        private var sourceRect: CGRect?

        init() { }

        func preferredStyle(_ style: UIAlertController.Style) -> Builder {
            self.preferredStyle = style
            return self
        }

        func withTitle(_ title: String?) -> Builder {
            self.title = title
            return self
        }

        func withMessage(_ message: String?) -> Builder {
            self.message = message
            return self
        }

        func addOkAction(handler: ((UIAlertAction) -> Void)? = nil) -> Builder {
            return addDefaultActionWithTitle("OK", handler: handler)
        }

        func addActionWithTitle(_ title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) -> Builder {
            let action = UIAlertAction(title: NSLocalizedString(title, comment: ""), style: style, handler: handler)
            actions.append(action)
            return self
        }

        func addCancelAction(handler: ((UIAlertAction) -> Void)? = nil) -> Builder {
            return addCancelActionWithTitle("Cancel", handler: handler)
        }

        func addCancelActionWithTitle(_ title: String, handler: ((UIAlertAction) -> Void)? = nil) -> Builder {
            return addActionWithTitle(title, style: .cancel, handler: handler)
        }

        func addDeleteAction(handler: ((UIAlertAction) -> Void)? = nil) -> Builder {
            return addDestructiveActionWithTitle("Delete", handler: handler)
        }

        func addDefaultActionWithTitle(_ title: String, handler: ((UIAlertAction) -> Void)? = nil) -> Builder {
            return addActionWithTitle(title, style: .default, handler: handler)
        }

        func addDestructiveActionWithTitle(_ title: String, handler: ((UIAlertAction) -> Void)? = nil) -> Builder {
            return addActionWithTitle(title, style: .destructive, handler: handler)
        }

        func withPopoverSourceView(_ view: UIView?) -> Builder {
            self.popoverSourceView = view
            return self
        }

        func withSourceRect(_ rect: CGRect?) -> Builder {
            self.sourceRect = rect
            return self
        }

        func show(in viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
            viewController.present(build(), animated: animated, completion: completion)
        }

        private func build() -> UIAlertController {
            let alert = UIAlertController(title: self.title, message: self.message, preferredStyle: self.preferredStyle)
            if let popoverSourceView = self.popoverSourceView {
                alert.popoverPresentationController?.sourceView = popoverSourceView
            }
            if let sourceRect = self.sourceRect {
                alert.popoverPresentationController?.sourceRect = sourceRect
            }
            actions.forEach { action in
                alert.addAction(action)
            }
            return alert
        }
    }
}
