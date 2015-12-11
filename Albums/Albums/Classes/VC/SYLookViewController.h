//
//  LookViewController.h
//  Photo
//
//  Created by sy on 15/12/10.
//  Copyright © 2015年 xywy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DelPhoto)(NSInteger index,NSString *url);
typedef void(^AddPhoto)(NSInteger index);
typedef void(^Complete)(void);

@interface SYLookViewController : UIViewController
@property (nonatomic,strong)NSMutableArray *selectPhoto;
@property (nonatomic,strong)DelPhoto delPhoto;
@property (nonatomic,strong)AddPhoto addPhoto;
@property (nonatomic,strong)Complete complete;

@end
