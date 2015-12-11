//
//  SYPhotoListTableViewCell.m
//  Photo
//
//  Created by sy on 15/12/11.
//  Copyright © 2015年 xywy. All rights reserved.
//

#import "SYPhotoListTableViewCell.h"
#import "UIColor+HexColor.h"
@implementation SYPhotoListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [self.contentView addSubview:_photoImageView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 100, 40)];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
        
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, 100, 40)];
        _numLabel.font = [UIFont systemFontOfSize:15];
        _numLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [self.contentView addSubview:_numLabel];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
