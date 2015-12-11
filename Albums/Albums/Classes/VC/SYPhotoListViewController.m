//
//  SYPhotoListViewController.m
//  Photo
//
//  Created by sy on 15/12/11.
//  Copyright © 2015年 xywy. All rights reserved.
//

#import "SYPhotoListViewController.h"
#import "SYPhotoListTableViewCell.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface SYPhotoListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *photoListTableView;
@property (nonatomic,strong)NSMutableArray *photoListArray;
@end

@implementation SYPhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _photoListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,WIDTH , HEIGHT - 64) style:UITableViewStylePlain];
    _photoListTableView.delegate = self;
    _photoListTableView.dataSource = self;
    _photoListTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_photoListTableView];
    _photoListArray = [[NSMutableArray alloc]init];
    
    SYSelectPhoto *syphoto = [[SYSelectPhoto alloc]init];
    syphoto.sendPhotoListBlock = ^(ALAssetsGroup *group){
        [_photoListArray addObject:group];
        [_photoListTableView reloadData];

    };
    [syphoto getPhotoLibraryGroup:ALAssetsGroupAll :SelectOnlyList ];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_photoListArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cellName";
    SYPhotoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[SYPhotoListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    ALAssetsGroup *assetsGroup = [_photoListArray objectAtIndex:indexPath.row];
    UIImage *photoImg = [UIImage imageWithCGImage:[assetsGroup posterImage]];
    cell.photoImageView.image = photoImg;
    cell.nameLabel.text = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    [cell.nameLabel sizeToFit];
    cell.nameLabel.frame = CGRectMake(55, 5, cell.nameLabel.frame.size.width, 40);
    
    cell.numLabel.text = [NSString stringWithFormat:@"（%zd）",[assetsGroup numberOfAssets]];
    [cell.numLabel sizeToFit];
    cell.numLabel.frame = CGRectMake(cell.nameLabel.frame.origin.x+cell.nameLabel.frame.size.width, 5, cell.numLabel.frame.size.width, 40);
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYAllPhotoViewController *allVC = [[SYAllPhotoViewController alloc]init];
    allVC.assetsGroup = [_photoListArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:allVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
