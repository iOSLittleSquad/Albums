//
//  SYCollectionViewCell.m
//  Photo
//
//  Created by sy on 15/12/9.
//  Copyright © 2015年 xywy. All rights reserved.
//

#import "SYCollectionViewCell.h"
#import "UIColor+HexColor.h"
#define WIDTH self.frame.size.width
@implementation SYCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH)];
        [self.contentView addSubview:_photoImage];
        
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoBtn.frame = CGRectMake(WIDTH - 25, 5, 20, 20);
        _photoBtn.backgroundColor = [UIColor blueColor];
        _photoBtn.layer.cornerRadius = 10;
        _photoBtn.layer.masksToBounds = YES;
        [_photoBtn setTitle:@"√" forState:UIControlStateNormal];
        [_photoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _photoBtn.backgroundColor = [UIColor colorWithHexString:@"1fb922"];
        _photoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_photoBtn];
    }
    return self;
}

@end
