//
//  HighlightsTableViewCell.swift
//  FanZone
//
//  Created by Mahmoud Mohamed Atrees on 09/02/2024.
//

import UIKit

protocol HighlightsTableViewCellDelegate: AnyObject {
    func didTapImage(url: URL?)
}

class HighlightsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var highlightsImageView: UIImageView!
    @IBOutlet weak var PlayButtonImageView: UIImageView!
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var labelBackground: UIView!
    
    weak var delegate: HighlightsTableViewCellDelegate?

    var url: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        PlayButtonImageView.isUserInteractionEnabled = true
        PlayButtonImageView.addGestureRecognizer(tapGesture)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: labelBackground.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        labelBackground.layer.mask = maskLayer
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func imageViewTapped() {
        delegate?.didTapImage(url: url)
    }
    
}
