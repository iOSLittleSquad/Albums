//
//  LookViewController.m
//  Photo
//
//  Created by sy on 15/12/10.
//  Copyright © 2015年 xywy. All rights reserved.
//

#import "SYLookViewController.h"
#import "SYPhotoInfoModel.h"
#import "UIColor+HexColor.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface SYLookViewController ()<UIScrollViewDelegate>
@property (nonatomic)BOOL isHidden;
@property (nonatomic,strong)UIView *navView;
@property (nonatomic,strong)UIView *tabView;
@property (nonatomic,strong)UIButton *selectBtn;
@property (nonatomic,strong)UIScrollView *photoScrollView;
@property (nonatomic,strong)UIButton *completeBtn; //完成按钮
@property (nonatomic,strong)UILabel *numLabel;

@end

@implementation SYLookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    NSLog(@"------look   %f",HEIGHT);
    _isHidden = NO;
    _photoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    _photoScrollView.backgroundColor = [UIColor blackColor];
    _photoScrollView.contentSize = CGSizeMake(WIDTH * [self.selectPhoto count], 1);
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    _photoScrollView.showsVerticalScrollIndicator = NO;
    _photoScrollView.pagingEnabled = YES;
    _photoScrollView.bounces = NO;
    _photoScrollView.delegate = self;
    [self.view addSubview:_photoScrollView];
    for (int i = 0;i < [self.selectPhoto count];i++) {
        SYPhotoInfoModel *photoModel = self.selectPhoto[i];
        CGFloat scal = photoModel.resolutionPhoto.size.height/photoModel.resolutionPhoto.size.width;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * WIDTH, 0, WIDTH, WIDTH * scal)];
        imageView.center = CGPointMake(WIDTH/2+i*WIDTH, HEIGHT/2 - 32);
        imageView.image = photoModel.resolutionPhoto;
        imageView.userInteractionEnabled = YES;
        [_photoScrollView addSubview:imageView];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
        [imageView addGestureRecognizer:tapGes];
    }
    [self creatNavAndTab];
}
- (void)creatNavAndTab
{
    _navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    _navView.backgroundColor = [UIColor colorWithHexString:@"131313"];
    [self.view addSubview:_navView];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:backBtn];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(WIDTH - 30, 20 + (44-20)/2, 20, 20);
    [_selectBtn setTitle:@"√" forState:UIControlStateNormal];
    [_selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _selectBtn.backgroundColor = [UIColor colorWithHexString:@"1fb922"];
    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _selectBtn.layer.cornerRadius = 10;
    _selectBtn.layer.masksToBounds = YES;
    [_selectBtn addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:_selectBtn];
    
    
    //因为导航栏隐藏，所以这里y = HEIGHT - 44
    _tabView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 44, WIDTH, 44)];
    _tabView.backgroundColor = [UIColor colorWithHexString:@"131313"];
    [self.view addSubview:_tabView];
    
    
    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _completeBtn.frame = CGRectMake(WIDTH - 50, 0, 40, 44);
    [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    _completeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_completeBtn setTitleColor:[UIColor colorWithHexString:@"1fb922"] forState:UIControlStateNormal];
    [_completeBtn addTarget:self action:@selector(completeClick) forControlEvents:UIControlEventTouchUpInside];
    [_tabView addSubview:_completeBtn];
    
    
    _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 65, 17.5, 15, 15)];
    _numLabel.backgroundColor = [UIColor colorWithHexString:@"1fb922"];
    _numLabel.textColor = [UIColor whiteColor];
    _numLabel.font = [UIFont systemFontOfSize:12];
    _numLabel.layer.masksToBounds = YES;
    _numLabel.layer.cornerRadius = 7.5;
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.hidden = YES;
    [_tabView addSubview:_numLabel];
    [self reloadPhotoNum];
}
#pragma 完成
- (void)completeClick
{
    if (_complete) {
        _complete();
    }
}
#pragma mark scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = _photoScrollView.contentOffset.x/WIDTH;
    SYPhotoInfoModel *photo = [_selectPhoto objectAtIndex:index];
    if (photo.isDel) {
        _selectBtn.backgroundColor = [UIColor colorWithHexString:@"111111"];
    }
    else{
        _selectBtn.backgroundColor = [UIColor colorWithHexString:@"1fb922"];
    }

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}
#pragma mark 选择 or 删除
- (void)selectClick
{
    NSInteger index = _photoScrollView.contentOffset.x/WIDTH;
    SYPhotoInfoModel *photo = [_selectPhoto objectAtIndex:index];
    if (photo.isDel) {
        photo.isDel = NO;
        _selectBtn.backgroundColor = [UIColor colorWithHexString:@"1fb922"];
        _addPhoto(photo.index);
    }
    else{
        photo.isDel = YES;
        _selectBtn.backgroundColor = [UIColor colorWithHexString:@"111111"];
        _delPhoto(photo.index,photo.url);
    }
    [self reloadPhotoNum];
}
#pragma mark 刷新下方数字
- (void)reloadPhotoNum
{
    NSInteger num = 0;
    for (SYPhotoInfoModel *photo in _selectPhoto) {
        if (!photo.isDel) {
            num ++;
        }
    }
    if (num>0) {
        _numLabel.text = [@(num)stringValue];
        _numLabel.hidden = NO;
    }
    else{
        _numLabel.hidden = YES;
    }
}
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
#pragma mark 隐藏或显示条形框
- (void)tapClick
{
    if (_isHidden) {
        _navView.hidden = NO;
        _tabView.hidden = NO;
        _isHidden = NO;
    }
    else{
        _navView.hidden = YES;
        _tabView.hidden = YES;
        _isHidden = YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
