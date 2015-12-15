//
//  ViewController.m
//  Photo
//
//  Created by sy on 15/12/9.
//  Copyright © 2015年 xywy. All rights reserved.
//

#import "SYAllPhotoViewController.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define SPACEVALUE 2
@interface SYAllPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)NSMutableArray *selectArray;  //asset数组
@property (nonatomic,strong)NSMutableArray *photoArray;   //所有照片数组
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UIButton *lookBtn; //预览按钮
@property (nonatomic,strong)UIButton *completeBtn; //完成按钮
@property (nonatomic,strong)UILabel *numLabel;

@end

@implementation SYAllPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"----allPhot   = %f",HEIGHT);

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"所有照片";
    _selectArray = [[NSMutableArray alloc]init];
    _photoArray = [[NSMutableArray alloc]init];
    
    SYSelectPhoto *syphoto = [[SYSelectPhoto alloc]init];
    syphoto.sendPhotoBlock = ^(NSMutableArray *allPhoto){
        self.photoArray = allPhoto;
        [self.collectionView reloadData];
    };
    
    if (_assetsGroup==nil) {
        [syphoto getPhotoLibraryGroup:ALAssetsGroupAll :PhotoSelectWithPhoto];
    }
    else{
        [syphoto getAllPhoto:_assetsGroup];
    }
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((WIDTH - SPACEVALUE*5)/4, (WIDTH - SPACEVALUE*5)/4);
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = SPACEVALUE;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];

    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-40 - 64) collectionViewLayout:layout];
    _collectionView.contentInset = UIEdgeInsetsMake(2, 2, 2, 2);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.minimumZoomScale = 0;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[SYCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];

    
    [self creatToolsView];
}
- (void)creatToolsView
{
    UIView *toolsView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 64- 40, WIDTH, 40)];
    toolsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:toolsView];
    
    //预览
    _lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lookBtn.frame = CGRectMake(10, 0, 40, 40);
    [_lookBtn setEnabled:NO];
    [_lookBtn setTitle:@"预览" forState:UIControlStateNormal];
    _lookBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_lookBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [_lookBtn addTarget:self action:@selector(lookPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    [toolsView addSubview:_lookBtn];
    
    
    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _completeBtn.frame = CGRectMake(WIDTH - 50, 0, 40, 40);
    [_completeBtn setEnabled:NO];
    [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    _completeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_completeBtn setTitleColor:[UIColor colorWithHexString:@"b8e2bc"] forState:UIControlStateNormal];
    [_completeBtn addTarget:self action:@selector(completeClick) forControlEvents:UIControlEventTouchUpInside];
    [toolsView addSubview:_completeBtn];
    

    _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 65, 12.5, 15, 15)];
    _numLabel.backgroundColor = [UIColor colorWithHexString:@"1fb922"];
    _numLabel.textColor = [UIColor whiteColor];
    _numLabel.font = [UIFont systemFontOfSize:12];
    _numLabel.layer.masksToBounds = YES;
    _numLabel.layer.cornerRadius = 7.5;
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.hidden = YES;
    [toolsView addSubview:_numLabel];
}
#pragma mark 浏览
- (void)lookPhotoClick
{
    SYLookViewController *lookVC = [[SYLookViewController alloc]init];
    lookVC.selectPhoto = [self.selectArray copy];
    __weak typeof(self) weakself = self;
    //浏览页删除回调
    lookVC.delPhoto = ^(NSInteger index,NSString *url){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        SYCollectionViewCell *cell = (SYCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        cell.photoBtn.hidden = YES;
        SYPhotoModel *photo = [self.photoArray objectAtIndex:index];
        photo.isHiden = YES;
        
        for (SYPhotoInfoModel *delPhoto in self.selectArray) {
            NSString *str1= delPhoto.url;
            NSString *str2= url;
            if([str1 isEqual:str2])
            {
                [weakself.selectArray removeObject:delPhoto];
                break;
            }
        }
        [weakself reloadTool];

    };
    //浏览页添加回调
    lookVC.addPhoto = ^(NSInteger index){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        SYCollectionViewCell *cell = (SYCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        cell.photoBtn.hidden = NO;
        SYPhotoModel *photoModel = [self.photoArray objectAtIndex:index];
        photoModel.isHiden = NO;
        
        
        NSString *filename = [photoModel.asset.defaultRepresentation filename];
        
        
        SYPhotoInfoModel *infoModel = [[SYPhotoInfoModel alloc]init];
        //图片名字
        infoModel.filename = filename;
        //高清图
        infoModel.resolutionPhoto = [UIImage imageWithCGImage:[photoModel.asset.defaultRepresentation fullResolutionImage]];
        //全屏图
        infoModel.screenPhoto = [UIImage imageWithCGImage:[photoModel.asset.defaultRepresentation fullScreenImage]];
        //唯一标识
        infoModel.uti = [photoModel.asset.defaultRepresentation UTI];
        infoModel.url = [photoModel.asset valueForProperty:ALAssetPropertyAssetURL];

        infoModel.index = indexPath.row;
        infoModel.isDel = NO;


        [weakself.selectArray addObject:infoModel];
        [weakself reloadTool];
    };
    //浏览页完成回调
    lookVC.complete = ^(void){
        [weakself completeClick];
    };
    [self.navigationController pushViewController:lookVC animated:YES];
}
#pragma mark 完成选择
- (void)completeClick
{
    NSMutableArray *transArray = [[NSMutableArray alloc]init];
    for (SYPhotoInfoModel *photoModel in self.selectArray) {
        UIImage *photo = photoModel.resolutionPhoto;
        [transArray addObject:photo];
    }
    if (_transPhotoArray) {
        _transPhotoArray(transArray);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark collection delegate && dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photoArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"cell";
    SYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath ];
    if (!cell) {
        cell = [[SYCollectionViewCell alloc]init];
    }
    SYPhotoModel *photoModel = [self.photoArray objectAtIndex:indexPath.row];
    //缩略图
    UIImage *postImage = [UIImage imageWithCGImage:[photoModel.asset thumbnail]];
    cell.photoImage.image = postImage;
    if (photoModel.isHiden) {
        cell.photoBtn.hidden = YES;
    }
    else{
        cell.photoBtn.hidden = NO;
    }
    cell.backgroundColor = [UIColor colorWithRed:rand()%255/255.0 green:rand()%255/255.0 blue:rand()%255/255.0 alpha:1];
    return cell;
}

//设置元素的的大小框
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    UIEdgeInsets top = {5,5,0,0};
//    return top;
//}

//设置顶部的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={WIDTH,SPACEVALUE};
    return size;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SYCollectionViewCell *selectItem = (SYCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    SYPhotoModel *photoModel = [self.photoArray objectAtIndex:indexPath.row];

    NSString *filename = [photoModel.asset.defaultRepresentation filename];

    
    SYPhotoInfoModel *infoModel = [[SYPhotoInfoModel alloc]init];
    //图片名字
    infoModel.filename = filename;
    //高清图
    infoModel.resolutionPhoto = [UIImage imageWithCGImage:[photoModel.asset.defaultRepresentation fullResolutionImage]];
    //全屏图
    infoModel.screenPhoto = [UIImage imageWithCGImage:[photoModel.asset.defaultRepresentation fullScreenImage]];
    //唯一标识
    infoModel.url = [photoModel.asset valueForProperty:ALAssetPropertyAssetURL];
    infoModel.uti = [photoModel.asset.defaultRepresentation UTI];
    infoModel.index = indexPath.row;
    infoModel.isDel = NO;
    if (photoModel.isHiden) {
        photoModel.isHiden = NO;
        selectItem.photoBtn.hidden = NO;
        [self.selectArray addObject:infoModel];
    }
    else{
        photoModel.isHiden = YES;
        selectItem.photoBtn.hidden = YES;
        for (SYPhotoInfoModel *delPhoto in self.selectArray) {
            NSString *str1=[photoModel.asset valueForProperty:ALAssetPropertyAssetURL];
            NSString *str2= delPhoto.url;
            if([str1 isEqual:str2])
            {
                [self.selectArray removeObject:delPhoto];
                break;
            }
        }
    }
    [self reloadTool];
}

#pragma mark 刷新下方条形
- (void)reloadTool
{
    //判断是否可以预览
    if ([self.selectArray count]) {
        [_lookBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_lookBtn setEnabled:YES];
        [_completeBtn setTitleColor:[UIColor colorWithHexString:@"1fb922"] forState:UIControlStateNormal];
        [_completeBtn setEnabled:YES];
        _numLabel.hidden = NO;
        _numLabel.text = [@([self.selectArray count])stringValue];
    }
    else{
        [_lookBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [_lookBtn setEnabled:NO];
        [_completeBtn setTitleColor:[UIColor colorWithHexString:@"b8e2bc"] forState:UIControlStateNormal];
        [_completeBtn setEnabled:NO];
        _numLabel.hidden = YES;
        
    }

}
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return CGSizeMake((WIDTH-25)/4,(WIDTH-25 )/4);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
