import UIKit
import ImageIO

private let reuseIdentifier = "collection-view-cell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let images = NSBundle.mainBundle().pathsForResourcesOfType("jpg", inDirectory: nil)
    private let businessNames = ["CREAM San Francisco", "Artis Coffee", "Verde Tea Cafe",
        "(TFM) Tea For Me", "AK Subs", "Parktown Veterinary Clinic", "Tpumps", "Chromatic Coffee",
        "Papabubble SF", "Dusty Buns Bistro", "V Cafe", "Super Cue Cafe", "Thai Recipe Cousine",
        "Sextant Coffee"]
    private var cellWidth = UIScreen.mainScreen().bounds.width
    private let cellHeight = CGFloat(200)
    private var noFilter = false

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Built in filters that are ready to go
        for filter in CIFilter.filterNamesInCategory(kCICategoryBlur) {
            print(filter)
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        let screenWidth = UIScreen.mainScreen().bounds.width
        self.cellWidth = (self.cellWidth == screenWidth) ? size.width : size.width / 2
        self.collectionViewLayout.invalidateLayout()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        
        if (self.noFilter == true) {
            cell.imageView.image = UIImage(contentsOfFile: self.images[indexPath.row])
            cell.label.text = self.businessNames[indexPath.row]
            return cell
        }
    
        let imageUrl = self.images[indexPath.row]
        
        // Apply a filter
        let image = CIImage(contentsOfURL: NSURL(fileURLWithPath: imageUrl))
        
        // Apply tilt and shift
        cell.imageView.image = UIImage(CGImage: self.applyFilterTiltAndShift(image!))
        
        // Apply auto fix
        //cell.imageView.image = UIImage(CGImage: self.applyFilterAutoAdjustments(image!))
        cell.label.text = self.businessNames[indexPath.row]
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(cellWidth, cellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    // MARK: - IBAction
    
    @IBAction func changeSizeTouched(sender: UIBarButtonItem) {
        toggleSize()
    }
    
    @IBAction func changeFilterTouched(sender: UIBarButtonItem) {
        toggleFilter()
    }
    
    // MARK: - Private func
    
    private func toggleSize() {
        let screenWidth = UIScreen.mainScreen().bounds.width
        self.cellWidth = (self.cellWidth == screenWidth) ? screenWidth / 2 : screenWidth
        self.collectionView?.reloadData()
    }
    
    private func toggleFilter() {
        self.noFilter = self.noFilter == true ? false : true
        self.collectionView?.reloadData()
        
    }
    
    private func applyFilterAutoAdjustments(image: CIImage) -> CGImageRef {
        var newImage = image
        let context = CIContext(options: nil)
        let filters = newImage.autoAdjustmentFiltersWithOptions([CIDetectorImageOrientation: 1])
        for filter in filters {
            filter.setValue(newImage, forKey: kCIInputImageKey)
            newImage = filter.outputImage!
        }
        return context.createCGImage(newImage, fromRect: (newImage.extent))
    }
    
    private func applyFilterTiltAndShift(image: CIImage) -> CGImageRef {
        let context = CIContext(options: nil)
        
        let topGradientFilter = CIFilter(name: "CISmoothLinearGradient", withInputParameters: ["inputPoint0": CIVector(x: 0, y: 0), "inputPoint1": CIVector(x: 200, y: 200), "inputColor0": CIColor(color: UIColor.blackColor()), "inputColor1": CIColor(color: UIColor.whiteColor())])
        //let blurFilter = CIFilter(name: "CIMedianFilter", withInputParameters: ["inputImage": image]
        //let filter = CIFilter(name: "CISRGBToneCurveToLinear", withInputParameters: ["inputImage": image!])
        //let filter = CIFilter(name: "CILinearToSRGBToneCurve", withInputParameters: ["inputImage": image!])
        //let filter = CIFilter(name: "CIColorClamp", withInputParameters: ["inputImage": image!, "inputMinComponents": CIVector(x: 0, y: 0, z: 0, w: 0), "inputMaxComponents": CIVector(x: 170, y: 170, z: 170, w: 1)])
        
        // Step 4 Apply filter
        let result: CIImage = topGradientFilter?.valueForKey(kCIOutputImageKey) as! CIImage
        let rect = result.extent
        
        // Step 5 Extract image
        return context.createCGImage(result, fromRect: rect)
    }
}
