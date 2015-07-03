//
//  TLPhotoAlbumViewController.m
//  GoFarmApp
//
//  Created by 颜魏 on 15/6/29.
//  Copyright (c) 2015年 唐农网络科技(深圳)有限公司. All rights reserved.
//

#import "TLPhotoAlbumViewController.h"
#import "TLPhotoDisplayViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface TLPhotoAlbumViewController ()<UITableViewDataSource, UITableViewDelegate, TLPhotoDisplayViewControllerDelegate>

@end

@implementation TLPhotoAlbumViewController
{
    UITableView           *_tableView;
    NSMutableDictionary   *_dataSource;
    ALAssetsLibrary       *_assetsLibrary;
    NSMutableArray        *_pictureGroups;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"album", nil);
    self.view.backgroundColor = [UIColor greenColor];
    
    [self createCancelBarButton];
    [self obtainDataSource];
    [self createTableView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

#pragma mark obtainDataSource
- (void) obtainDataSource {
    _dataSource = [[NSMutableDictionary alloc] init];
    _pictureGroups = [[NSMutableArray alloc] init];
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    NSMutableArray *groups=[[NSMutableArray alloc] init];
    //遍历相册里面的所有组
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            NSMutableArray *assets = [NSMutableArray array];
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    [assets addObject:result];
                }
            }];
            NSString *albumName = [group valueForProperty:ALAssetsGroupPropertyName];
            [_dataSource setObject:assets forKey:albumName];
            [groups addObject:group];
        }else {
            _pictureGroups = groups;
            [_tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - create
- (void) createCancelBarButton {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"cancel", nil) style:UIBarButtonItemStyleDone target:self action:@selector(actionRightItem:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void) createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.right.equalTo(@0);
    }];
}

#pragma mark - action
- (void) actionRightItem:(UIBarButtonItem *)item {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - tableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _pictureGroups.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    //获取相册每个分组的组名
    NSString *albumName = [_pictureGroups[indexPath.row] valueForProperty:ALAssetsGroupPropertyName];
    //获取相册每个分组的封面图
    UIImage* image = [UIImage imageWithCGImage:[_pictureGroups[indexPath.row] posterImage]];
    cell.imageView.image = image;
    NSArray *array = _dataSource[albumName];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld张)",albumName,array.count];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TLPhotoDisplayViewController *displayVC = [[TLPhotoDisplayViewController alloc] init];
    displayVC.assetsGroup = _pictureGroups[indexPath.row];
    displayVC.title = _dataSource.allKeys[indexPath.row];
    displayVC.delegate = self;
    displayVC.isMorePicture = _pictureNumber;
    displayVC.selectedAssetsUrl = _selectedAssetsUrl;
    [self.navigationController pushViewController:displayVC animated:YES];
//    UINavigationController *nav = self.navigationController;
//    nav.viewControllers = @[displayVC];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:displayVC];
//    [self presentViewController:nav animated:YES completion:nil];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


#pragma mark - photoDisplayDelegate
- (void) photoDisplayViewController:(TLPhotoDisplayViewController *)viewController selectedAsset:(ALAsset *)asset {
    [self dismissViewControllerAnimated:NO completion:nil];
    if ([_delegate respondsToSelector:@selector(photoAlbumViewController:selectedAsset:)]) {
        __weak TLPhotoAlbumViewController *this = self;
        [_delegate photoAlbumViewController:this selectedAsset:asset];
    }
}

- (void) photoDisplayViewController:(TLPhotoDisplayViewController *)viewController selectedAssets:(NSArray *)assets {
    [self dismissViewControllerAnimated:NO completion:nil];
    if ([_delegate respondsToSelector:@selector(photoAlbumViewController:selectedAssets:)]) {
        [_delegate photoAlbumViewController:self selectedAssets:assets];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
