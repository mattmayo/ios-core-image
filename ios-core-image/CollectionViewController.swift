import UIKit

private let reuseIdentifier = "collection-view-cell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let images = NSBundle.mainBundle().pathsForResourcesOfType("jpg", inDirectory: nil)
    private var cellWidth = UIScreen.mainScreen().bounds.width
    private let cellHeight = CGFloat(200)

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
        let imageUrl = self.images[indexPath.row]
        cell.imageView.image = UIImage(contentsOfFile: imageUrl)
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
        let screenWidth = UIScreen.mainScreen().bounds.width
        self.cellWidth = (self.cellWidth == screenWidth) ? screenWidth / 2 : screenWidth
        self.collectionView?.reloadData()
    }
}
