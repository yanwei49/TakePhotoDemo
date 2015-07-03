//
//  TLPhotoAlbumViewController.h
//  GoFarmApp
//
//  Created by 颜魏 on 15/6/29.
//  Copyright (c) 2015年 唐农网络科技(深圳)有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TLPictureNumber){
    TLOnePicture = 0,
    TLMorePicture = 1
};

@class TLPhotoAlbumViewController;
@class ALAsset;
@protocol TLPhotoAlbumViewControllerDelegate <NSObject>

- (void) photoAlbumViewController:(TLPhotoAlbumViewController *)viewController selectedAssets:(NSArray *)assets;
- (void) photoAlbumViewController:(TLPhotoAlbumViewController *)viewController selectedAsset:(ALAsset *)asset;


@end

@interface TLPhotoAlbumViewController : UIViewController

@property (nonatomic, assign) id<TLPhotoAlbumViewControllerDelegate> delegate;
@property (nonatomic, assign) TLPictureNumber                        pictureNumber;
@property (nonatomic, strong) NSMutableArray                         *selectedAssetsUrl;  //已经选择了得asset对象数组

@end
