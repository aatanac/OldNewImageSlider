//
//  OldNewImageSlider.swift
//  Testing
//
//  Created by Aleksandar Atanackovic on 03/07/2018.
//  Copyright © 2018 Aleksandar Atanackovic. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable
public class OldNewImageSlider: UIView {
    
    // MARK: Properties
    
    // Constraints
    private var trailing: NSLayoutConstraint?
    private var scrollerWidth: NSLayoutConstraint?
    private var scrollerTrailing: NSLayoutConstraint?
    
    // Rect used for holding current thumb rect
    private var holdingRect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    @IBInspectable
    public var topImage: UIImage? {
        didSet {
            self.topImageView.image = self.topImage
        }
    }
    
    @IBInspectable
    public var bottomImage: UIImage? {
        didSet {
            self.bottomImageView.image = self.bottomImage
        }
    }
    
    @IBInspectable
    public var thumbArea: CGFloat = 50 {
        didSet {
            self.handleThumbAreaChange()
        }
    }
    
    private var bottomImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private var topImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private var topImageViewHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private var scrollerHolder: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        return view
    }()
    
    private var thumb: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    // Setup as lazy to perform only first time in layoutSubviews
    private lazy var configureOrigin: Void = {
        self.holdingRect = self.topImageViewHolder.frame
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        self.configurePan()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
        self.configurePan()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        _ = self.configureOrigin
    }
    
}

extension OldNewImageSlider {
    
    // MARK: UI
    
    /// Init configure of UI
    private func configureUI() {
        
        self.topImageViewHolder.addSubview(self.topImageView)
        self.addSubview(self.bottomImageView)
        self.addSubview(self.topImageViewHolder)
        self.addSubview(self.scrollerHolder)
        
        NSLayoutConstraint.activate([
            self.bottomImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.bottomImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            self.bottomImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            self.bottomImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
            ])
        
        self.trailing = self.topImageViewHolder.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            self.topImageViewHolder.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.topImageViewHolder.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            self.topImageViewHolder.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.trailing!
            ])
        
        NSLayoutConstraint.activate([
            self.topImageView.topAnchor.constraint(equalTo: self.topImageViewHolder.topAnchor, constant: 0),
            self.topImageView.bottomAnchor.constraint(equalTo: self.topImageViewHolder.bottomAnchor, constant: 0),
            self.topImageView.leadingAnchor.constraint(equalTo: self.topImageViewHolder.leadingAnchor, constant: 0),
            self.topImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1)
            ])
        
        self.scrollerWidth = self.scrollerHolder.widthAnchor.constraint(equalToConstant: self.thumbArea)
        self.scrollerTrailing = self.scrollerHolder.trailingAnchor.constraint(equalTo: self.topImageViewHolder.trailingAnchor, constant: self.thumbArea / 2)
        
        NSLayoutConstraint.activate([
            self.scrollerHolder.topAnchor.constraint(equalTo: self.topImageViewHolder.topAnchor, constant: 0),
            self.scrollerHolder.bottomAnchor.constraint(equalTo: self.topImageViewHolder.bottomAnchor, constant: 0),
            self.scrollerTrailing!,
            self.scrollerWidth!
            ])
    }
    
    /// Adding pan gesture to scroller
    private func configurePan() {
        let tap = UIPanGestureRecognizer(target: self, action: #selector(gesture(sender:)))
        self.scrollerHolder.isUserInteractionEnabled = true
        self.scrollerHolder.addGestureRecognizer(tap)
    }
    
    /// Change constriaints which are depending on thumbArea property
    private func handleThumbAreaChange() {
        self.scrollerWidth?.constant = self.thumbArea
        self.scrollerTrailing?.constant = self.thumbArea / 2
        
        self.layoutIfNeeded()
    }
    
    /// Configuring custom view for thumb
    ///
    /// - Parameter completion: (UIView) -> Void sending thumb holder with closure
    public func configureCustomThumb(completion: (UIView) -> Void) {
        completion(self.scrollerHolder)
    }
    
    /// Seting up custom thumb view
    ///
    /// - Parameters:
    ///   - color: UIColor for default thumb
    ///   - size: CGFloat size for default thumb
    public func addDefaultThumb(color: UIColor = .white, size: CGFloat = 40) {
        self.scrollerHolder.addSubview(self.thumb)
        self.thumb.backgroundColor = color
        
        NSLayoutConstraint.activate([
            self.thumb.centerXAnchor.constraint(equalTo: self.scrollerHolder.centerXAnchor),
            self.thumb.centerYAnchor.constraint(equalTo: self.scrollerHolder.centerYAnchor),
            self.thumb.widthAnchor.constraint(equalToConstant: size),
            self.thumb.heightAnchor.constraint(equalToConstant: size)
            ])
        
        self.thumb.layer.cornerRadius = size / 2
    }
    
    // MARK: Action
    
    /// Action handling drag event
    ///
    /// - Parameter sender: UIPanGestureRecognizer
    @objc private func gesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        
        switch sender.state {
        case .began, .changed:
            self.handlePanMove(to: translation)
            
        case .ended, .cancelled:
            self.holdingRect = self.topImageViewHolder.frame
            
        default: break
        }
    }
    
    /// Separating calculation for moving thumb
    ///
    /// - Parameter point: translated point of touch
    private func handlePanMove(to point: CGPoint) {
        var newTrailing = -self.frame.size.width + self.holdingRect.size.width + point.x
        newTrailing = max(newTrailing, -self.frame.size.width)
        newTrailing = min(0, newTrailing)
        self.trailing?.constant = newTrailing
        self.layoutIfNeeded()
    }
    
}
