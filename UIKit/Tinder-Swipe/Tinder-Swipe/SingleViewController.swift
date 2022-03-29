//  Tinder-Swipe
//
//  Created by Ikmal Azman on 06/02/2022.
// iOS Tinder-Like Swipe - Part 1- UIPanGestureRecognizer
// https://www.youtube.com/watch?v=0fXR-Ksuqo4
// iOS Tinder-Like Swipe - Part 2- UIPanGestureRecognizer
// https://www.youtube.com/watch?v=5hXPnipCDBQ
// iOS Tinder-Like Swipe - Part 3 - Animating card off screen
// https://www.youtube.com/watch?v=sBnqFLJqn9M
// iOS Tinder-Like Swipe - Part 4 - Rotating the Card
//https://www.youtube.com/watch?v=F5Rh4kDongo&t
// Making a Tinder-esque Card Swiping interface using Swift (CollectionView)
// https://exploringswift.com/blog/making-a-tinder-esque-card-swiping-interface-using-swift

import UIKit

final class SingleViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    let thumbsUpImage = UIImage(systemName: "hand.thumbsup.circle.fill")!
    let thumbsDownImage = UIImage(systemName: "hand.thumbsdown.circle.fill")!
    
    var divisor : CGFloat = 0.0
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupView()
        setupCardViewPanGesture()
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
        resetCardPosition()
    }
    
    @objc
    func didPanCardView(_ sender : UIPanGestureRecognizer) {
        //MARK: - Drag direction
        // Get reference of the view that attach to gesture recognizer
        let card = sender.view!
        // Keep track how far finger move from selected view
        // Provide coordinate info of distance from first point of view to its last point
        let gesturePoint = sender.translation(in: card)
        // Set the card from center of screen and add with gesture point to move and set new center of the card
        // Allow to drag and move the card
        card.center = CGPoint(x: view.center.x + gesturePoint.x,
                              y: view.center.y + gesturePoint.y)
        
        // Allow to determine current state of the gesture
        if sender.state == UIGestureRecognizer.State.ended {
            //MARK: - Animate card off the screen
            // Create imaginary margin on the screen on left and right, when card pass the margin, the card will dissapear from screen
            // Determine the center of card(x), if less 75 from center, continue animate it to the left
            if card.center.x < 75 {
                // Animate Move to left side of screen
                UIView.animate(withDuration: 0.3) {
                    // x positon, allow to make the card move to further left
                    // y position, allow to make card little bit fall animate the card
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y - 55)
                    // Hide the card when animating off
                    card.alpha = 0
                }
                // Return, to prevent code below(reset center card) execute when it met condition
                return
            } else if card.center.x > (view.frame.width - 75) {
                // Get the total widht of the screen and substract 75 of the right screen, if the center of card overlapse width of screen, dissapear the card from screen
                // Animate move card on to the right of screen
                UIView.animate(withDuration: 0.3) {
                    // x positon, allow to make the card move to further right
                    // y position, allow to make card little bit fall animate the card
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y - 55)
                    card.alpha = 0
                }
                // Return, to prevent code below(reset center card) execute when it met condition
                return
            }
            self.resetCardPosition()
        }
        //MARK: - Display image
        // Get the center of the screen and center of the card when drag(difference value of distace between center card and screen)
        // Compare between card center and screen center(allow to determine either card it go to left or right)
        let xFromCenter = card.center.x - view.center.x
        
        // Determine direction of the card
        if xFromCenter > 0 {
            // Right
            thumbImageView.image = thumbsUpImage
            thumbImageView.tintColor = .green
        } else {
            // Left
            thumbImageView.image = thumbsDownImage
            thumbImageView.tintColor = .red
        }
        //MARK: - Image Opacity
        // Decrease opacity of imageview based on distance it from center of the screen when card start drag to its direction
        // Use difference value between center of screen and card to change the opacity of the image
        // Divide center of card with center of screen, e.g. 25/50 = 0.5 alpha
        let imageOpacity = abs(xFromCenter) / view.center.x
        thumbImageView.alpha = imageOpacity
        
        //MARK: - Rotating the cards when drag
        // Rotate card gradually to 35 degree when move to left or right
        // CGAffineTransform, allow to rotate, scale, place new coordinate to object, while preserve the parallel object relationship
        // rotationAngle, radian(degree to rotate)
        // 0.61 radian, 35 degree
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / divisor)
    }
    
    //MARK: - Reset card position
    func . {
        // Reset the card to the parent view center when finger is remove from card
        UIView.animate(withDuration: 0.2) {
            self.cardView.center = self.view.center
            self.thumbImageView.alpha = 0
            self.cardView.alpha = 1
            // Reset the transform to its original position, scale, rotation
            self.cardView.transform = .identity
        }
    }
}

extension SingleViewController {
    private func setupView() {
        cardView.layer.cornerRadius = 15
        foodImageView.layer.cornerRadius = 15
        // start from center of screen
        // (view.frame.width / 2), get center from half of screen width
        //  0.79(45 degree), degree that want to be rotate
        divisor = (view.frame.width / 2) / 0.79
    }
    
    private func setupCardViewPanGesture() {
        // Create a pan gesture recognizer, allow to move and drag view
        let panGesture = UIPanGestureRecognizer()
        panGesture.minimumNumberOfTouches = 1
        // Get action when gesture detected
        panGesture.addTarget(self, action: #selector(didPanCardView(_:)))
        // Add gesture to card view
        cardView.addGestureRecognizer(panGesture)
    }
}

