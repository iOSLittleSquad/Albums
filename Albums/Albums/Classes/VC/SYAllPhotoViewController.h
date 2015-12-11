//
//  ViewController.h
//  Photo
//
//  Created by sy on 15/12/9.
//  Copyright © 2015年 xywy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYCollectionViewCell.h"
#import "SYSelectPhoto.h"
#import "SYPhotoModel.h"
#import "SYPhotoInfoModel.h"
#import "SYLookViewController.h"
#import "UIColor+HexColor.h"

typedef void(^TransPhotoArray)(NSMutableArray *photoArray);
@interface SYAllPhotoViewController : UIViewController
@property (nonatomic,strong)TransPhotoArray transPhotoArray;
@property (nonatomic)ALAssetsGroupType type;
@property (nonatomic)PhotoSelectStyle style;
@property (nonatomic,strong)ALAssetsGroup *assetsGroup;
@end

