/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import BLTNBoard

/**
 * An item that displays a choice with two buttons.
 *
 * This item demonstrates how to create a page bulletin item with a custom interface, and changing the
 * next item based on user interaction.
 */

class ChoiceBLTNItem: FeedbackPageBLTNItem {

    private var optionOne: String
    private var optionTwo: String

    private var optionOneContainer: UIButton!
    private var optionTwoContainer: UIButton!

    private var selectedOption = 0

    private var selectionFeedbackGenerator = SelectionFeedbackGenerator()

    init(title: String, optionOne: String, optionTwo: String) {
        self.optionOne = optionOne
        self.optionTwo = optionTwo
        super.init(title: title)
    }

    // MARK: - BLTNItem

    /**
     * Called by the manager when the item is about to be removed from the bulletin.
     *
     * Use this function as an opportunity to do any clean up or remove tap gesture recognizers /
     * button targets from your views to avoid retain cycles.
     */

    override func tearDown() {
        optionOneContainer?.removeTarget(self, action: nil, for: .touchUpInside)
        optionTwoContainer?.removeTarget(self, action: nil, for: .touchUpInside)
    }

    /**
     * Called by the manager to build the view hierachy of the bulletin.
     *
     * We need to return the view in the order we want them displayed. You should use a
     * `BulletinInterfaceFactory` to generate standard views, such as title labels and buttons.
     */

    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {

        // Choice Stack

        // We add choice cells to a group stack because they need less spacing
        let choiceStack = interfaceBuilder.makeGroupStack(spacing: 16)

        // Cat Button

        let optionOneContainer = createChoiceCell(name: self.optionOne, isSelected: true)
        optionOneContainer.addTarget(self, action: #selector(optionOneTapped), for: .touchUpInside)
        choiceStack.addArrangedSubview(optionOneContainer)

        self.optionOneContainer = optionOneContainer

        // Dog Button

        let optionTwoContainer = createChoiceCell(name: self.optionTwo, isSelected: false)
        optionTwoContainer.addTarget(self, action: #selector(optionTwoTapped), for: .touchUpInside)
        choiceStack.addArrangedSubview(optionTwoContainer)

        self.optionTwoContainer = optionTwoContainer

        return [choiceStack]

    }

    // MARK: - Custom Views

    /**
     * Creates a custom choice cell.
     */

    func createChoiceCell(name: String, isSelected: Bool) -> UIButton {

        let button = UIButton(type: .system)
        button.setTitle(name, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.contentHorizontalAlignment = .center

        if isSelected {
            button.accessibilityTraits.insert(.selected)
        } else {
            button.accessibilityTraits.remove(.selected)
        }

        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2

        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 55)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true

        let buttonColor = isSelected ? appearance.actionButtonColor : .lightGray
        button.layer.borderColor = buttonColor.cgColor
        button.setTitleColor(buttonColor, for: .normal)
        button.layer.borderColor = buttonColor.cgColor

        return button

    }

    // MARK: - Touch Events

    /// Called when the cat button is tapped.
    @objc func optionOneTapped() {
        selectedOption = 0
        // Play haptic feedback

        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()

        // Update UI

        let catButtonColor = appearance.actionButtonColor
        optionOneContainer?.layer.borderColor = catButtonColor.cgColor
        optionOneContainer?.setTitleColor(catButtonColor, for: .normal)
        optionOneContainer?.accessibilityTraits.insert(.selected)

        let dogButtonColor = UIColor.lightGray
        optionTwoContainer?.layer.borderColor = dogButtonColor.cgColor
        optionTwoContainer?.setTitleColor(dogButtonColor, for: .normal)
        optionTwoContainer?.accessibilityTraits.remove(.selected)

        // Send a notification to inform observers of the change

//        NotificationCenter.default.post(name: .FavoriteTabIndexDidChange,
//                                        object: self,
//                                        userInfo: ["Index": 0])

        // Set the next item

//        next = PetValidationBLTNItem(dataSource: .cat, animalType: "cats")

    }

    /// Called when the dog button is tapped.
    @objc func optionTwoTapped() {
        selectedOption = 1
        // Play haptic feedback

        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()

        // Update UI

        let catButtonColor = UIColor.lightGray
        optionOneContainer?.layer.borderColor = catButtonColor.cgColor
        optionOneContainer?.setTitleColor(catButtonColor, for: .normal)
        optionOneContainer?.accessibilityTraits.remove(.selected)

        let dogButtonColor = appearance.actionButtonColor
        optionTwoContainer?.layer.borderColor = dogButtonColor.cgColor
        optionTwoContainer?.setTitleColor(dogButtonColor, for: .normal)
        optionTwoContainer?.accessibilityTraits.insert(.selected)

        // Send a notification to inform observers of the change

//        NotificationCenter.default.post(name: .FavoriteTabIndexDidChange,
//                                        object: self,
//                                        userInfo: ["Index": 1])

        // Set the next item

//        next = PetValidationBLTNItem(dataSource: .dog, animalType: "dogs")

    }

    override func actionButtonTapped(sender: UIButton) {

        // Play haptic feedback
        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.selectionChanged()

        // Ask the manager to present the next item.
        manager?.displayNextItem()

    }

}
