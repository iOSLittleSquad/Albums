//
//  PhotoModel.h
//  Photo
//
//  Created by sy on 15/12/9.
//  Copyright © 2015年 xywy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface SYPhotoModel : NSObject
@property (nonatomic)BOOL isHiden;
@property (nonatomic,strong)ALAsset *asset;
@end
