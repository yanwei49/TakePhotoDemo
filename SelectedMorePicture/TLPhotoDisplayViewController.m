//
//  TLPhotoDisplayViewController.m
//  GoFarmApp
//
//  Created by 颜魏 on 15/6/29.
//  Copyright (c) 2015年 唐农网络科技(深圳)有限公司. All rights reserved.
//

#import "TLPhotoDisplayViewController.h"
//#import <AssetsLibrary/AssetsLibrary.h>
#import "TLAlbumCollectionViewCell.h"

@interface TLPhotoDisplayViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation TLPhotoDisplayViewController
{
    UIBarButtonItem     *_rightItem;
    NSMutableArray      *_selectAssetsArray;
    UICollectionView    *_collectionView;
    NSMutableArray      *_dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _selectAssetsArray = [[NSMutableArray alloc] init];
    [self createRightBarButton];
    [self createCollectionView];
    [self obtainDataDource];
}

#pragma mark - create
- (void) createRightBarButton {
    _rightItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"cancel", nil) style:UIBarButtonItemStyleDone target:self action:@selector(actionRightItem:)];
    self.navigationItem.rightBarButtonItem = _rightItem;
    if (_selectedAssetsUrl.count) {
        _rightItem.title = NSLocalizedString(@"down", nil);
        for (NSString *url in _selectedAssetsUrl) {
            //将相册图片的URL转换成asset对象
            ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
            [lib assetForURL:[NSURL URLWithString:url] resultBlock:^(ALAsset *asset){
                //在这里使用asset来获取图片
                [_selectAssetsArray addObject:asset];
            }
            failureBlock:^(NSError *error){
            }];
        }
    }
}

- (void) createCollectionView {
    UICollectionViewFlowLayout  *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-25)/4, ([UIScreen mainScreen].bounds.size.width-25)/4);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[TLAlbumCollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCell"];
    [self.view addSubview:_collectionView];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        make.left.equalTo(@5);
        make.bottom.equalTo(@0);
        make.right.equalTo(@-5);
    }];
}

#pragma mark - obtainDataDource 
- (void) obtainDataDource {
    _dataSource = [[NSMutableArray alloc] init];
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop)
    {
        if (asset)
        {
            [_dataSource addObject:asset];
        }
        else
        {
            [_collectionView reloadData];
        }
    };
    
    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}

#pragma mark - action
- (void) actionRightItem:(UIBarButtonItem *)item {
    [self.navigationController popToRootViewControllerAnimated:NO];
//    [self dismissViewControllerAnimated:NO completion:nil];
    if ([item.title isEqualToString:NSLocalizedString(@"down", nil)]) {
        if ([_delegate respondsToSelector:@selector(photoDisplayViewController:selectedAssets:)]) {
            [_delegate photoDisplayViewController:self selectedAssets:_selectAssetsArray];
        }
    }
}

#pragma mark - collectionViewDelegate
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TLAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
    
    ALAsset *asset = _dataSource[indexPath.item];
    //获取相册下的图片
    cell.image = [UIImage imageWithCGImage:asset.thumbnail];
    NSString *assetUrl = [(NSURL*)[asset valueForProperty:ALAssetPropertyAssetURL] absoluteString];
    for (NSString *selectedAssetUrl in _selectedAssetsUrl) {
        if ([assetUrl isEqualToString:selectedAssetUrl]) {
            cell.selectedState = YES;
            [_selectedAssetsUrl removeObject:selectedAssetUrl];
            [_selectAssetsArray addObject:_dataSource[indexPath.row]];
            break;
        }
    }
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_isMorePicture) {
        TLAlbumCollectionViewCell *cell = (TLAlbumCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.selectedState = !cell.selectedState;
        if (cell.selectedState == YES) {
            [_selectAssetsArray addObject:_dataSource[indexPath.item]];
        }else {
            [_selectAssetsArray removeObject:_dataSource[indexPath.item]];
        }
        if (_selectAssetsArray.count) {
            _rightItem.title = NSLocalizedString(@"down", nil);
        }else {
            _rightItem.title = NSLocalizedString(@"cancel", nil);
        }
    }else  {
        [self.navigationController popToRootViewControllerAnimated:NO];
        if ([_delegate respondsToSelector:@selector(photoDisplayViewController:selectedAsset:)]) {
            __weak TLPhotoDisplayViewController *this = self;
            [_delegate photoDisplayViewController:this selectedAsset:_dataSource[indexPath.item]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
