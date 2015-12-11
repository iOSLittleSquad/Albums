//
//  SYSelectPhoto.m
//  Photo
//
//  Created by sy on 15/12/9.
//  Copyright © 2015年 xywy. All rights reserved.
//

#import "SYSelectPhoto.h"
#import "SYPhotoModel.h"
@implementation SYSelectPhoto
static ALAssetsLibrary *shareAssertsLibrary;
+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    if (!shareAssertsLibrary) {
        shareAssertsLibrary = [[ALAssetsLibrary alloc]init];
    }
    return shareAssertsLibrary;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allPhoto = [[NSMutableArray alloc]init];
    }
    return self;
}
#pragma mark 获取所有相册
- (void)getPhotoLibraryGroup:(ALAssetsGroupType)groupType :(PhotoSelectStyle)style
{
    ALAssetsLibraryGroupsEnumerationResultsBlock librarygroupBlock = ^(ALAssetsGroup *group, BOOL *stop){
        if (style == SelectWithPhoto) {
            if ([group numberOfAssets]) {
                [self getAllPhoto:group];
            }
        }
        else{
            if ([group numberOfAssets]) {
                _sendPhotoListBlock(group);
            }
        }
    };
    [[SYSelectPhoto defaultAssetsLibrary] enumerateGroupsWithTypes:groupType usingBlock:librarygroupBlock failureBlock:nil];

}
#pragma mark 获取某相册下所有照片
- (void)getAllPhoto:(ALAssetsGroup *)group
{
    if (group!=nil) {
        ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                SYPhotoModel *photoModel = [[SYPhotoModel alloc]init];
                photoModel.isHiden = YES;
                photoModel.asset = result;
                [self.allPhoto addObject:photoModel];
            }else{
                
            }
        };
        [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
        if ([self.allPhoto count]) {
            if (_sendPhotoBlock) {
                _sendPhotoBlock(self.allPhoto);
            }
        }
    }
}

@end
