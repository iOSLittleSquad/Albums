//
//  SYSelectPhoto.h
//  Photo
//
//  Created by sy on 15/12/9.
//  Copyright © 2015年 xywy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
typedef void(^SendPhotoBlock)(NSMutableArray *photoArray);
typedef void(^SendPhotoListBlock)(ALAssetsGroup *assetsGroup);

typedef enum {
    PhotoSelectOnlyList,
    PhotoSelectWithPhoto
}PhotoSelectStyle;
@interface SYSelectPhoto : NSObject
@property (nonatomic,strong)NSMutableArray *allPhoto;
@property (nonatomic,strong)SendPhotoBlock sendPhotoBlock;
@property (nonatomic,strong)SendPhotoListBlock sendPhotoListBlock;
/**
 *  单例
 */
+ (ALAssetsLibrary *)defaultAssetsLibrary;
- (void)getPhotoLibraryGroup:(ALAssetsGroupType)groupType :(PhotoSelectStyle)style;
- (void)getAllPhoto:(ALAssetsGroup *)group;
@end
