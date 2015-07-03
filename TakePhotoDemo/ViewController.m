//
//  ViewController.m
//  TakePhotoDemo
//
//  Created by 颜魏 on 15/7/3.
//  Copyright (c) 2015年 颜魏. All rights reserved.
//

#import "ViewController.h"
#import "TLPhotoAlbumViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()<UIActionSheetDelegate, TLPhotoAlbumViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController
{
    NSMutableArray   *_selectedAssetsUrl;
    NSMutableArray   *_dataSource;
}

- (IBAction)actionTakePhoto:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择图片模式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"单图", @"多图", nil];
    [sheet showInView:self.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _selectedAssetsUrl = [[NSMutableArray alloc] init];
    _dataSource = [[NSMutableArray alloc] init];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 50)/4, ([UIScreen mainScreen].bounds.size.width - 50)/4);
    
    _collectionView.collectionViewLayout = flowLayout;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}


#pragma mark - actionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    TLPhotoAlbumViewController *albumVC = [[TLPhotoAlbumViewController alloc] init];
    albumVC.delegate = self;
    if (buttonIndex == 0) {
        albumVC.pictureNumber = TLOnePicture;
        [self.navigationController pushViewController:albumVC animated:YES];
    }else if (buttonIndex == 1){
        albumVC.selectedAssetsUrl = _selectedAssetsUrl;
        albumVC.pictureNumber = TLMorePicture;
        [self.navigationController pushViewController:albumVC animated:YES];
    }else {
    
    }
}

#pragma mark - collectionViewDelegate
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    imageView.image = _dataSource[indexPath.item];
    cell.backgroundView = imageView;
    
    return cell;
}


#pragma TLPhotoAlbumViewControllerDelegate
- (void) photoAlbumViewController:(TLPhotoAlbumViewController *)viewController selectedAsset:(ALAsset *)asset {
    [_selectedAssetsUrl removeAllObjects];
    NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
    NSString *assetUrl = [(NSURL*)[asset valueForProperty:ALAssetPropertyAssetURL] absoluteString];
    [_selectedAssetsUrl addObject:assetUrl];
    UIImage  *image = [UIImage imageWithCGImage:asset.thumbnail];
    [imagesArray addObject:image];
    _dataSource = imagesArray;
    [_collectionView reloadData];
}

- (void) photoAlbumViewController:(TLPhotoAlbumViewController *)viewController selectedAssets:(NSArray *)assets {
    [_selectedAssetsUrl removeAllObjects];
    NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
    for (ALAsset *asset in assets) {
        NSString *assetUrl = [(NSURL*)[asset valueForProperty:ALAssetPropertyAssetURL] absoluteString];
        if (assetUrl) {
            [_selectedAssetsUrl addObject:assetUrl];
            UIImage  *image = [UIImage imageWithCGImage:asset.thumbnail];
            
            //            asset.thumbnail                             //图片的缩略图小图
            //            asset.defaultRepresentation.fullScreenImage//图片的大图
            
            //下面注释的这段代码对加载多张图片的时候会造成内存警告
            //            ALAssetRepresentation *assetRep = [asset defaultRepresentation];
            //            CGImageRef imgRef = [assetRep fullResolutionImage];
            //            UIImage *image = [UIImage imageWithCGImage:imgRef
            //                                                 scale:assetRep.scale
            //                                           orientation:(UIImageOrientation)assetRep.orientation];
            [imagesArray addObject:image];
        }
    }
    _dataSource = imagesArray;
    [_collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
