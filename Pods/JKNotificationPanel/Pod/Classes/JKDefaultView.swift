//
//  JKDefaultView.swift
//  Pods
//
//  Created by Ter on 12/20/2558 BE.
//  http://www.macfeteria.com
//



public enum JKStatus:Int {
    case success
    case warning
    case failed
}


open class JKDefaultView: UIView {
    
    
    private let verticalSpace:CGFloat = 8
    private let horizontalSpace:CGFloat = 8
    private let iconSize:CGFloat = 26
    private let defaultTitleLableHeight:CGFloat = 22

    var imageIcon:UIImageView!
    var textLabel:UILabel!
    var baseView:UIView!


    override init (frame : CGRect) {

        super.init(frame : frame)

        imageIcon = UIImageView(frame: CGRect(x: verticalSpace, y: horizontalSpace, width: iconSize, height: iconSize))
        imageIcon.backgroundColor = UIColor.clear

        let textLabelX = verticalSpace + iconSize + verticalSpace
        textLabel = UILabel(frame: CGRect(x: textLabelX, y: horizontalSpace, width: frame.width - textLabelX - horizontalSpace, height: 26))
        textLabel.isUserInteractionEnabled = true
        textLabel.textColor = UIColor.white
        baseView = UIView(frame: frame)
        baseView.backgroundColor = UIColor(red: 35.0/255.0, green: 160.0/255.0, blue: 73.0/255.0, alpha: 1)
        baseView.addSubview(imageIcon)
        baseView.addSubview(textLabel)
        self.addSubview(baseView)

    }

    open func transitionTo(size:CGSize) {
        let xPosition = verticalSpace + iconSize + verticalSpace
        self.frame.size = CGSize(width: size.width, height: self.frame.height)
        textLabel.frame.size = CGSize(width: size.width - xPosition - horizontalSpace, height: 26)
        baseView.frame.size = CGSize(width: size.width, height: baseView.frame.height)

        // adjust text label
        self.setTitle(textLabel.text)
    }

    open func setImage(_ icon:UIImage) {
        imageIcon.image = icon
    }


    open func setColor(_ color:UIColor) {
        self.baseView.backgroundColor = color
    }

    open func setTitle(_ text:String?) {

        guard (text != nil) else { return }

        textLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        textLabel.text = text
        textLabel.numberOfLines = 0
        textLabel.sizeToFit()

        textLabel.frame.origin.y = horizontalSpace + 2

        let height = textLabel.frame.height
        var frameHeight = (verticalSpace * 2) + height
        if frameHeight < 44 { frameHeight = 44 }

        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: frameHeight)
        baseView.frame = self.frame

    }


    func loadImageBundle(named imageName:String) ->UIImage? {
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: "JKNotificationPanel", withExtension: "bundle")
        {
            let imageBundel = Bundle(url:bundleURL )
            let image = UIImage(named: imageName, in: imageBundel, compatibleWith: nil)
            return image
        }
        return nil
    }

    open func setPanelStatus(_ status:JKStatus) {
        switch (status) {
        case .success:
            imageIcon.image = loadImageBundle(named: "success-icon")
            textLabel.text = "Success"
            baseView.backgroundColor = UIColor(red: 35.0/255.0, green: 160.0/255.0, blue: 73.0/255.0, alpha: 1)
        case .warning:
            imageIcon.image = loadImageBundle(named: "warning-icon")
            textLabel.text = "Warning"
            baseView.backgroundColor = UIColor(red: 249.0/255.0, green: 169.0/255.0, blue: 69.0/255.0, alpha: 1)
        case .failed:
            imageIcon.image = loadImageBundle(named: "fail-icon")
            textLabel.text = "Failed"
            baseView.backgroundColor = UIColor(red: 67.0/255.0, green: 69.0/255.0, blue: 80.0/255.0, alpha: 1)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
    

}
