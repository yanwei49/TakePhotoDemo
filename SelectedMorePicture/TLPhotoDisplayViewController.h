//
//  TLPhotoDisplayViewController.h
//  GoFarmApp
//
//  Created by 颜魏 on 15/6/29.
//  Copyright (c) 2015年 唐农网络科技(深圳)有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class TLPhotoDisplayViewController;
@class ALAsset;
@protocol TLPhotoDisplayViewControllerDelegate <NSObject>

- (void) photoDisplayViewController:(TLPhotoDisplayViewController *)viewController selectedAssets:(NSArray *)assets;
- (void) photoDisplayViewController:(TLPhotoDisplayViewController *)viewController selectedAsset:(ALAsset *)asset;

@end

@interface TLPhotoDisplayViewController : UIViewController

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
//@property (nonatomic, strong) NSArray   *alassets;
@property (nonatomic, assign) BOOL      isMorePicture;
@property (nonatomic, assign) id<TLPhotoDisplayViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray                         *selectedAssetsUrl;  //已经选择了得asset对象数组

@end
