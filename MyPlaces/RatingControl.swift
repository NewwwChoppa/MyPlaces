//
//  RatingControl.swift
//  MyPlaces
//
//  Created by Андрей on 27.11.2023.
//

import UIKit

class RatingControl: UIStackView {
    
    // MARK: Properties
    
    private var ratingButtons = [UIButton]()
    
    var starSize = CGSize(width: 44.0, height: 44.0)
    var starCount = 5
    var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: Button action
    
    @objc func ratingButtonTapped(button: UIButton) {
        
        guard let index = ratingButtons.firstIndex(of: button) else { return }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    // MARK: Private methods
    
    private func setupButtons() {
        
        for _ in 0..<starCount {
            
            // Load button image
            let filledStar = UIImage(named: "filledStar")
            let emptyStar = UIImage(named: "emptyStar")
            let highlightedStar = UIImage(named: "highlightedStar")
            
            
            
            // Create the button
            let button = UIButton()
            
            // Set the button image
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])

            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Setup the button action
            button.addTarget(self, action: #selector(ratingButtonTapped), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button on the rating buttons array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionState()
    }
    
    private func updateButtonSelectionState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
