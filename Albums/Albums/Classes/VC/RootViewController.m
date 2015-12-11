//
//  RootViewController.m
//  Photo
//
//  Created by sy on 15/12/10.
//  Copyright © 2015年 xywy. All rights reserved.
//

#import "RootViewController.h"
#import "SYPhotoListViewController.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface RootViewController ()
@property (nonatomic,strong)UIScrollView *scrollView;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"----root   = %f",HEIGHT);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"选择照片" style:UIBarButtonItemStylePlain target:self action:@selector(selectPhoto)];
    self.navigationItem.rightBarButtonItem = item;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    
}
#pragma mark 选择照片
- (void)selectPhoto
{
    __weak typeof(self) weatself = self;
    SYAllPhotoViewController *allVC = [[SYAllPhotoViewController alloc]init];
    //选择完成返回图片数组
    allVC.transPhotoArray = ^(NSMutableArray *photoArray){
        [weatself handlePhoto:photoArray];
    };
    SYPhotoListViewController *listVC = [[SYPhotoListViewController alloc]init];

    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:listVC];
    //先push到全部照片 再跳present到nav
    [nav pushViewController:allVC animated:NO];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)handlePhoto:(NSMutableArray *)photoArray
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0;i<[photoArray count];i++) {
        UIImage *image = [photoArray objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, HEIGHT - 64)];
        imageView.image = image;
        [_scrollView addSubview:imageView];
    }
    _scrollView.contentSize = CGSizeMake(WIDTH*[photoArray count], HEIGHT - 64);
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
