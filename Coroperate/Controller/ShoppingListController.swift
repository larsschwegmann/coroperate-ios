//
//  ShoppingListController.swift
//  Coroperate
//
//  Created by Lars Schwegmann on 21.03.20.
//  Copyright © 2020 Lars Schwegmann. All rights reserved.
//

import Foundation
import UIKit
import Eureka
import BLTNBoard
import Combine

class ShoppingListController: FormViewController {


    @IBOutlet weak var requestBarButton: UIBarButtonItem!

    var bltnManager: BLTNItemManager?
    var cancellable: Cancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.setEditing(true, animated: false)

        NotificationCenter.default.addObserver(forName: .ReadyToCreateUser, object: nil, queue: nil) { (notification) in
            let userToCreate = User(id: nil,
                                    firstName: SettingsManager.shared.firstName!,
                                    lastName: SettingsManager.shared.lastName!,
                                    username: SettingsManager.shared.email!,
                                    password: SettingsManager.shared.password!,
                                    email: SettingsManager.shared.email!,
                                    profile: Profile(address: "nil", zipCode: SettingsManager.shared.zipCode!, city: "nil"))
            let userCreationRequest = CreateUserRequest(user: userToCreate)
            self.cancellable = APIClient().send(userCreationRequest).sink(receiveCompletion: { completion in
                // HAndle this
            }) { (value) in
                SettingsManager.shared.onboardingComplete = true

                // Create token
                let username = SettingsManager.shared.email!
                let password = SettingsManager.shared.password!
                self.cancellable = APIClient().send(ObtainTokenRequest(username: username, password: password)).sink(receiveCompletion: { completion in
                    // HAndle this
                    print(completion)
                }) { result in
                    SettingsManager.shared.accessToken = result.value.access
                    SettingsManager.shared.refreshToken = result.value.refresh
                }
            }
        }

        if SettingsManager.shared.onboardingComplete {
            // Create token
            let username = SettingsManager.shared.email!
            let password = SettingsManager.shared.password!
            self.cancellable = APIClient().send(ObtainTokenRequest(username: username, password: password)).sink(receiveCompletion: { completion in
                // HAndle this
                print(completion)
            }) { result in
                SettingsManager.shared.accessToken = result.value.access
                SettingsManager.shared.refreshToken = result.value.refresh
            }
        }

        form +++
        MultivaluedSection(multivaluedOptions: [.Insert, .Delete, .Reorder], header: nil, footer: nil, {
            $0.tag = "shoppingList"
            $0.addButtonProvider = { section in
                return ButtonRow() {
                    $0.title = "Artikel hinzufügen"
                }.cellUpdate { (cell, row) in
                    cell.textLabel?.textAlignment = .left
                }
            }
            $0.multivaluedRowToInsertAt = { index in
                return TextRow() {
                    $0.placeholder = "Anzahl, Artikel einfügen"
                    $0.cell.textField.tag = $0.indexPath?.row ?? 0
                }
            }
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // check onboarding
        if !SettingsManager.shared.onboardingComplete {
            let item = OnboardingDataSource.makeOnboardingIntro()
            let manager = BLTNItemManager(rootItem: item)
            manager.showBulletin(above: self)
            self.bltnManager = manager
        }
    }
    
    @IBAction func requestButtonPressed(_ sender: Any) {
        let itemSection = self.form.sectionBy(tag: "shoppingList") as! MultivaluedSection
        let items = (itemSection.values() as! [String]).map({ ShoppingListItem(item: $0) })
        let createRequestController = CreateReqeustController(items: items)
        let navcon = UINavigationController(rootViewController: createRequestController)
        self.present(navcon, animated: true, completion: nil)
    }
}
