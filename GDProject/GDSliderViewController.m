//
//  GDSliderViewController.m
//  GDProject
//
//  Created by QDFish on 2018/10/9.
//

#import "GDSliderViewController.h"
#import "UIViewController+GDSliderSub.h"
#import "UIViewController+Extension.h"
#import "UIView+Extension.h"
#import "NSObject+Router.h"
#import "GDConstants.h"

//@interface GDSliderViewController ()
//
//@property (nonatomic, strong) UICollectionView *gd_sliderCollectionView;
//@property (nonatomic, strong) NSMutableDictionary *gd_sliderNetworkSubModels;
//
//
//@end
//
//@implementation GDSliderViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    self.gd_sliderNetworkSubModels = [NSMutableDictionary dictionaryWithCapacity:self.gd_sliderItems.count];
//    
//    [self.view addSubview:self.gd_sliderCollectionView];    
//    // Do any additional setup after loading the view.
//}
//
//
//#pragma mark -
//
//- (UICollectionView *)gd_sliderCollectionView {
//    if (!_gd_sliderCollectionView) {
//        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滚动方向
//        flowLayout.itemSize = [self gd_sliderCollectionViewFrame].size;//item的大小
//        flowLayout.minimumInteritemSpacing = 0.0;
//        flowLayout.minimumLineSpacing = 0.0;
//        _gd_sliderCollectionView = [[UICollectionView alloc] initWithFrame:[self gd_sliderCollectionViewFrame] collectionViewLayout:flowLayout];
//        [_gd_sliderCollectionView registerClass:[GDSliderCell class] forCellWithReuseIdentifier:NSStringFromClass([GDSliderCell class])];
//        _gd_sliderCollectionView.backgroundColor = [UIColor clearColor];
//        [self.view addSubview:_gd_sliderCollectionView];
//        _gd_sliderCollectionView.showsVerticalScrollIndicator = NO;
//        _gd_sliderCollectionView.showsHorizontalScrollIndicator = NO;
//        _gd_sliderCollectionView.pagingEnabled = YES;
//        _gd_sliderCollectionView.dataSource = self;
//        _gd_sliderCollectionView.delegate = self;
//    }
//    return _gd_sliderCollectionView;
//}
//
//- (void)gd_updateSliderNetworkSubModel:(id)model index:(NSInteger)index {
//    if (model) {
//        self.gd_sliderNetworkSubModels[[NSString stringWithFormat:@"%ld", index]] = model;
//    }
//}
//
//- (void)gd_reloadSliderVC {
//    [self.gd_sliderCollectionView reloadData];
//}
//
//#pragma mark -
//
//- (NSArray *)gd_sliderItems {
//    return nil;
//}
//
//- (Class)gd_sliderSubVCClassForItem:(id)item {
//    return nil;
//}
//
//- (CGRect)gd_sliderCollectionViewFrame {
//    return CGRectMake(0, 0, self.view.width, self.view.height);
//}
//
//#pragma mark -
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    NSArray *items = self.gd_sliderItems;
//    return [items count];
//}
//
//- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    id sliderItem = indexPath.item < self.gd_sliderItems.count ?  self.gd_sliderItems[indexPath.item] : nil;
//    id networkModel = indexPath.item < self.gd_sliderNetworkSubModels.count ? self.gd_sliderNetworkSubModels[[NSString stringWithFormat:@"%ld", indexPath.item]] : nil;
//    Class vcClass = [self gd_sliderSubVCClassForItem:sliderItem];
//    
//    UIViewController *vc = [vcClass new];
//    //初始化VC变量
//    vc.gd_isSliderSubVC = YES;
//    vc.gd_sliderIndex = indexPath.item;
//    vc.gd_superSliderVC = self;
//    [vc gd_setModelWithJson:[sliderItem gd_json]];
//    
//    GDSliderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GDSliderCell class]) forIndexPath:indexPath];
//    //cell结合VC
//    cell.gd_sliderSubVC = vc;
//    
//    //刷新网络数据
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wundeclared-selector"
//    GD_SAFE_CALL_SEL(vc, @selector(gd_setWithSliderNetworkModel:), networkModel);
//#pragma clang diagnostic popr
//    
//    return cell;
//}
//
//- (void)gd_sliderToIndex:(NSInteger)index animated:(BOOL)animated {
//    NSInteger items = [self.gd_sliderCollectionView numberOfItemsInSection:0];
//    if (index < items) {
//        [self.gd_sliderCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
//    }
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.gd_sliderCollectionView) {
//        CGFloat totalWidth = self.gd_sliderCollectionView.contentSize.width - self.gd_sliderCollectionView.width;
//        CGFloat currentWidth = self.gd_sliderCollectionView.contentOffset.x;
//        CGFloat ratio = currentWidth / totalWidth;
//        if (ratio > 1) {
//            ratio = 1;
//        } else if (ratio < 0) {
//            ratio = 0;
//        }
//        
//        if ([self respondsToSelector:@selector(gd_callBackSliderRatio:)]) {
//            [self gd_callBackSliderRatio:ratio];
//        }
//        
//    }
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (scrollView == self.gd_sliderCollectionView) {
//        UICollectionViewCell *cell = [[self.gd_sliderCollectionView visibleCells] firstObject];
//        NSIndexPath *indexPath = [self.gd_sliderCollectionView indexPathForCell:cell];
//        if ([self respondsToSelector:@selector(gd_callBackSliderIndex:)]) {
//            [self gd_callBackSliderIndex:indexPath.item];
//        }
//        
//    }
//}
//
//#pragma mark -
//
//- (BOOL)initialInteraction:(GDInteraction *)interaction {
//    return YES;
//}
//
//- (BOOL)initialNetwork:(GDNetwork *)network {
//    return NO;
//}
//
//
//@end
//
//
//
//@implementation GDSliderCell
//
//- (void)setGd_sliderSubVC:(UIViewController *)gd_sliderSubVC {
//    [self.contentView gd_removeAllSubviews];
//    _gd_sliderSubVC = gd_sliderSubVC;
//    [self.contentView addSubview:gd_sliderSubVC.view];
//    [self setNeedsLayout];
//}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.gd_sliderSubVC.view.frame = CGRectMake(0, 0, self.width, self.height);
//}
//
//@end
