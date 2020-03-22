//
//  OnboardingDataSource.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 21.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation
import BLTNBoard
import Combine

var cancellable: Cancellable?

enum OnboardingDataSource {
    static func makeOnboardingIntro() -> FeedbackPageBLTNItem {
        let page = FeedbackPageBLTNItem(title: "Wilkommen bei Coroperate!")

        page.descriptionText = "Mit Coroperate wollen wir das Einkaufen für Risikogruppen erleichtern."
        page.actionButtonTitle = "Los geht's!"
        page.alternativeButtonTitle = "Datenschutzerklärung"

        page.isDismissable = false

        page.actionHandler = { item in
            item.manager?.displayNextItem()
        }

        page.alternativeHandler = { item in
            //let privacyPolicyVC = SFSafariViewController(url: URL(string: "https://example.com")!)
            //item.manager?.present(privacyPolicyVC, animated: true)
        }

        page.next = makeHelperChoice()

        return page
    }

    static func makeHelperChoice() -> FeedbackPageBLTNItem {
        let page = ChoiceBLTNItem(title: "Nutzertyp wählen", optionOne: "😷 Ich muss zuhause bleiben!", optionTwo: "💪 Ich möchte Helfen!")
        page.descriptionText = "Sag uns wie du die App benutzen möchtest.\nHelfer können auch für andere hilfsbedürftige Personen bestellen."
        page.actionButtonTitle = "Weiter"
        page.isDismissable = false
        page.next = makeNameInput()
        page.actionHandler = { item in
        }
        return page
    }

    static func makeNameInput() -> FeedbackPageBLTNItem {
        let page = DualTextFieldBLTNItem(title: "Wie heißt du?", placeholderA: "Vorname", placeholderB: "Nachname")
        page.isDismissable = false
        page.actionButtonTitle = "Weiter"
        page.descriptionText = "Dein Name wird den Lieferanten/dem Besteller angezeigt."
        page.textInputHandler = { (item, text) in
            print("Text: \(text ?? "nil")")
            //let datePage = self.makeDatePage(userName: text)
            //item.manager?.push(item: datePage)
        }
        page.next = makeZipInput()
        page.actionHandler = { item in
            let firstName = page.textFieldA.text
            let lastName = page.textFieldB.text
            SettingsManager.shared.firstName = firstName
            SettingsManager.shared.lastName = lastName
            item.manager?.displayNextItem()
        }
        return page
    }

    static func makeZipInput() -> FeedbackPageBLTNItem {
        let page = TextFieldBLTNItem(title: "Wo wohnst du?", placeholder: "PLZ", keyboardType: .numberPad)
        page.isDismissable = false
        page.actionButtonTitle = "Weiter"
        page.descriptionText = "Wie lautet deine Postleitzahl?"
        page.textInputHandler = { (item, text) in
            print("Text: \(text ?? "nil")")
        }
        page.next = makeEmailInput()
        page.actionHandler = { item in
            let zipCode = page.textField.text
            SettingsManager.shared.zipCode = zipCode
            item.manager?.displayNextItem()
        }
        return page
    }

    static func makeEmailInput() -> FeedbackPageBLTNItem {
        let page = EmailFieldBLTNItem(title: "Email Adresse", placeholder: "Email")
        page.isDismissable = false
        page.actionButtonTitle = "Weiter"
        page.descriptionText = "Unter welcher Email Adresse können wir dich erreichen?"
        page.textInputHandler = { (item, text) in
            print("Text: \(text ?? "nil")")
        }
        page.next = makePasswordInput()
        page.actionHandler = { item in
            let email = page.textField.text
            SettingsManager.shared.email = email
            item.manager?.displayNextItem()
        }
        return page
    }

    static func makePasswordInput() -> FeedbackPageBLTNItem {
        let page = PasswordFieldBLTNItem(title: "Passwort", placeholder: "Passwort")
        page.isDismissable = false
        page.actionButtonTitle = "Registrieren"
        page.descriptionText = "Bitte wähle ein Passwort"
        page.textInputHandler = { (item, text) in
            print("Text: \(text ?? "nil")")
        }
        page.next = makeCompletionPage()
        page.actionHandler = { item in
            let password = page.textField.text
            SettingsManager.shared.password = password
            item.manager?.displayNextItem()
            NotificationCenter.default.post(name: .ReadyToCreateUser, object: item)
        }

        return page
    }

    static func makeCompletionPage() -> BLTNPageItem {

        let page = BLTNPageItem(title: "Setup abgeschlossen!")
        //page.shouldStartWithActivityIndicator = true
        page.image = UIImage(named: "IntroCompletion")!
        page.imageAccessibilityLabel = "Checkmark"

        let tintColor: UIColor
        if #available(iOS 13.0, *) {
            tintColor = .systemGreen
        } else {
            tintColor = #colorLiteral(red: 0.2980392157, green: 0.8509803922, blue: 0.3921568627, alpha: 1)
        }
        page.appearance.actionButtonColor = tintColor
        page.appearance.imageViewTintColor = tintColor

        page.appearance.actionButtonTitleColor = .white

        page.descriptionText = "Danke dass du mitmachst!"
        page.actionButtonTitle = "Leg Los!"

        page.isDismissable = true

        page.actionHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }

        page.alternativeHandler = { item in
            item.manager?.popToRootItem()
        }

        return page

    }
    
}

extension Notification.Name {
    static let ReadyToCreateUser = Notification.Name("ReadyToCreateUser")
}
