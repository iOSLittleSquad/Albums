//
//  PhotoInfoModel.h
//  Photo
//
//  Created by sy on 15/12/10.
//  Copyright © 2015年 xywy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface SYPhotoInfoModel : NSObject
@property (nonatomic,strong)UIImage *resolutionPhoto;  //高清图
@property (nonatomic,strong)UIImage *screenPhoto;  //全屏图
@property (nonatomic,strong)NSString *filename;   //资源图片名字
@property (nonatomic,strong)NSString *uti;   //唯一标识
@property (nonatomic,strong)NSString *url;   //地址
@property (nonatomic,strong)ALAsset *asset;   //未处理的数据类
@property (nonatomic)BOOL isDel;
@property (nonatomic)NSInteger index;

@end
