//
//  TLAlbumCollectionViewCell.m
//  GoFarmApp
//
//  Created by 颜魏 on 15/6/30.
//  Copyright (c) 2015年 唐农网络科技(深圳)有限公司. All rights reserved.
//

#import "TLAlbumCollectionViewCell.h"

@implementation TLAlbumCollectionViewCell
{
    UIImageView    *_imageView;
    UIView         *_selectedView;
    UIImageView    *_selectedImageView;
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_imageView];
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.bottom.equalTo(@0);
            make.right.equalTo(@0);
        }];
        
        _selectedView = [[UIView alloc] init];
        _selectedView.backgroundColor = [UIColor blackColor];
        _selectedView.alpha = 0.5;
        _selectedView.hidden = YES;
        [self addSubview:_selectedView];
        [_selectedView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.bottom.equalTo(@0);
            make.right.equalTo(@0);
        }];
        
        _selectedImageView = [[UIImageView alloc] init];
        _selectedImageView.image = [UIImage imageNamed:@"alu_tables_arrow"];
        _selectedImageView.backgroundColor = [UIColor whiteColor];
        [_selectedView addSubview:_selectedImageView];
        [_selectedImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.right.equalTo(@-10);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
    }
    
    return self;
}

- (void) setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
}

- (void) setSelectedState:(BOOL)selectedState {
    _selectedState = selectedState;
    _selectedView.hidden = !selectedState;
}


@end
