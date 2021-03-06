//
//  ViewController.m
//  XFSettingsExample
//
//  Created by Yizzuide on 15/6/28.
//  Copyright © 2015年 Yizzuide. All rights reserved.
//

#import "NSString+Tools.h"
#import "UIViewController+XFSettings.h"
#import "UpdateViewController.h"
#import "ViewController.h"
#import "XFNewFriendViewController.h"
#import "XFSettings.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface ViewController ()<XFSettingTableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title                  = @"设置";
    self.view.backgroundColor                  = [UIColor whiteColor];
    
    // set cell attrs
    XFCellAttrsData *cellAttrsData             = [XFCellAttrsData cellColorDataWithBackgroundColor :[UIColor whiteColor] selBackgroundColor :[UIColor colorWithWhite :0 alpha :0.4]];
    // 设置图标大小
    cellAttrsData.contentIconSize              = 20;
    // 设置内容间距
    cellAttrsData.contentEachOtherPadding      = 15;
    // cell 线条颜色
//    cellAttrsData.cellBottomLineColor        = [UIColor purpleColor];
    // 显示填充整个cell宽度画线
//    cellAttrsData.cellFullLineEnable         = YES;
    // 标题文字大小（其它文字会按个大小自动调整）
    cellAttrsData.contentTextMaxSize           = 13;
    // 标题颜色
    cellAttrsData.contentTitleTextColor        = [UIColor purpleColor];
    // 详细文字颜色
    cellAttrsData.contentDetailTextColor       = [UIColor blueColor];
    // 辅助文字颜色
    cellAttrsData.contentInfoTextColor         = [UIColor brownColor];
    // 表格风格
    cellAttrsData.tableViewStyle               = UITableViewStyleGrouped;
    // 卡片样式
    cellAttrsData.settingStyle                 = XFSettingStyleCard;
    // 卡片样式下的外间距
    cellAttrsData.cardSettingStyleMargin       = 20;
    // 卡片样式下的圆角
    cellAttrsData.cardSettingStyleCornerRadius = 5;
    
    self.xf_cellAttrsData                      = cellAttrsData;
    // 设置数据源
    self.xf_dataSource                         = self;
    // 调用配置设置
    [self xf_setup];
    
    // 获得UITableView来设置分隔线样式
    self.xf_tableView.separatorStyle           = UITableViewCellSeparatorStyleNone;
    
    
}

- (NSArray *)settingItems
{
    WS(weakSelf)
    return @[ // groupArr
             @{ // groupModel
                 XFSettingGroupHeader: @"基本信息",
                 XFSettingGroupItems : @[ // items
                         @{ // itemModel
                             XFSettingItemTitle: @"我的朋友",
                             XFSettingItemIcon : @"1435582804_group",
                             XFSettingItemClass : [XFSettingInfoItem class], // 这个字段用于判断是否有右边辅助功能的cell,不写则没有
                             XFSettingItemAttrDetailText : @"你的好友",
                             XFSettingItemRelatedCellClass:[XFSettingInfoDotCell class],// 自定义的cell
                            XFSettingItemDestViewControllerClass : [XFNewFriendViewController class], // 如果有目标控制器
                             XFSettingItemDestViewControllerUserInfo : @{@"url":@"http://www.yizzuide.com"},// 目标控制器带有参数
                             XFSettingOptionActionBlock : ^(XFSettingInfoDotCell *cell,XFSettingPhaseType phaseType,id intentData){ // 如果有可选的操作
                                 if (phaseType == XFSettingPhaseTypeCellInteracted) {
                                     cell.rightInfoLabel.hidden = YES;
                                 }
                             }
                             },// end itemModel
                         @{
                             XFSettingItemTitle: @"我的消息",
                             XFSettingItemIcon : @"1435527299_message",
                             XFSettingItemClass : [XFSettingInfoItem class],                              XFSettingItemAttrDetailText : @"新的好友",
                             XFSettingItemAttrRightInfo : @"3",
                             XFSettingItemRelatedCellClass:[XFSettingInfoCountCell class],
                             XFSettingOptionActionBlock : ^(XFSettingInfoCountCell *cell,XFSettingPhaseType phaseType,id intentData){
                                 // 交互时处理
                                 if (phaseType == XFSettingPhaseTypeCellInteracted) {
                                     int count = cell.rightInfoLabel.text.intValue;
                                     cell.rightInfoLabel.text = [NSString stringWithFormat:@"%d",++count];
                                 }
                             }
                             },
                         @{
                             XFSettingItemTitle: @"缓存大小",
                             XFSettingItemIcon : @"1435529531_CD-DVD Drive-2",
                             XFSettingItemClass : [XFSettingInfoItem class],
                             XFSettingItemAttrDetailText : @"cache",
                             XFSettingItemAttrRightInfo : @"正在计算",
                             XFSettingItemRelatedCellClass:[XFSettingInfoCell class],
                             XFSettingOptionActionBlock : ^(XFSettingInfoCell *cell,XFSettingPhaseType phaseType,id intentData){
                                
                                 [weakSelf cacheDirClear:cell phaseType:phaseType];
                             }
                             },
                         @{
                             XFSettingItemTitle: @"保存我的设置",
                             XFSettingItemIcon : @"1435527366_1-8",
                             XFSettingItemClass : [XFSettingSwitchItem class],
                             XFSettingOptionActionBlock : ^(XFSettingCell *cell,XFSettingPhaseType phaseType,id intentData){
                                 // 视图初始化
                                 if (phaseType == XFSettingPhaseTypeCellInit) {
                                     // 初始化时设置为开启
                                     cell.switchView.on = YES;
                                 }else if (phaseType == XFSettingPhaseTypeCellInteracted) {
                                     if ([intentData[XFSettingIntentDataSwitchOn] boolValue]) {
                                         NSLog(@"%@", @"保存");
                                     }else{
                                         NSLog(@"%@", @"取消保存");
                                     }
                                 }
                             }
                             },
                         @{
                             XFSettingItemTitle: @"检测新版本",
                             XFSettingItemIcon : @"1435529156_cloud-arrow-up",
                             // 使用自定义向右箭头
                             XFSettingItemArrowIcon : @"CellArrow",
                             XFSettingItemClass : [XFSettingInfoItem class],
                             XFSettingItemRelatedCellClass:[XFSettingInfoCell class],
                             XFSettingItemAttrRightInfo : @"有新版本！",
                             XFSettingItemDestViewControllerClass : [UpdateViewController class],
                             XFSettingOptionActionBlock : ^(XFSettingInfoCell *cell,XFSettingPhaseType phaseType,id intentData){
                                 // 自定义初始化样式
                                 if (phaseType == XFSettingPhaseTypeCellInit) {
                                     cell.rightInfoLabel.textColor = [UIColor orangeColor];
                                     cell.rightInfoLabel.font = [UIFont systemFontOfSize:10];
                                 }
                             }
                             },
                         /*@{
                             XFSettingItemTitle: @"vip帮助",
                             XFSettingItemIcon : @"1435529211_circle_help_question-mark",
                             XFSettingOptionActionBlock : ^(XFSettingCell *cell,XFSettingPhaseType phaseType,id intentData){
                                 
                                 
                             }
                             }*/
                         @{
                             XFSettingItemTitle: @"vip帮助",
                             XFSettingItemIcon : @"1435529211_circle_help_question-mark",
                             XFSettingItemAttrDetailText : @"帮助文档",
                             XFSettingItemAttrAssistImageName : @"defaultUserIcon",
                             XFSettingItemAttrAssistImageRadii : @(XFSettingItemAttrAssistImageRadiiCircle),
                             XFSettingItemAttrAssistImageMargin: @(8.f),
                             XFSettingItemAttrAssistImageContentMode : @(UIViewContentModeScaleToFill),
                             XFSettingItemClass : [XFSettingAssistImageItem class],
                             XFSettingItemRelatedCellClass:[XFSettingAssistImageCell class],
                             XFSettingItemHeight : @55 // 自定义行高
                             },
                         @{
                             XFSettingItemTitle: @"服务协议",
                             XFSettingItemClass : [XFSettingInfoItem class],
                             XFSettingItemRelatedCellClass:[XFSettingInfoDotCell class],
                             XFSettingOptionActionBlock : ^(XFSettingInfoDotCell *cell,XFSettingPhaseType phaseType,id intentData){ // 如果有可选的操作
                                 if (phaseType == XFSettingPhaseTypeCellInit) {
                                     cell.dotColor = [UIColor greenColor];
                                 }
                                 if (phaseType == XFSettingPhaseTypeCellInteracted) {
                                     cell.rightInfoLabel.hidden = YES;
                                 }
                             }
                             },
                         @{
                             XFSettingItemTitle: @"更新数据",
                             XFSettingItemAttrRightInfo : @"123456789@qq.com",
                             XFSettingItemArrowIcon : @"CellArrow",
                             XFSettingItemClass : [XFSettingInfoItem class],
                             XFSettingItemRelatedCellClass:[XFSettingInfoCell class],
                             // 当不使用控制器类时可以实现有箭头并且不会调转
                             XFSettingItemDestViewControllerClass:[NSObject class],
                             // 只是实行相当动作
                             XFSettingOptionActionBlock : ^(XFSettingInfoCell *cell,XFSettingPhaseType phaseType,id intentData){
                                 if (phaseType == XFSettingPhaseTypeCellInit) {
                                     cell.rightInfoLabel.textColor = [UIColor grayColor];
                                     cell.rightInfoLabel.font = [UIFont systemFontOfSize:10];
                                 }
                                 if (phaseType == XFSettingPhaseTypeCellInteracted) {
                                     NSLog(@"%@",@"正在更新中。。。");
                                 }
                             }
                             },
                         @{
                             XFSettingItemTitle: @"版本号",
                             XFSettingItemClass : [XFSettingInfoItem class],
                             XFSettingItemAttrRightInfo : @"当前版本：V2.3.0",
                             // 保存的动态信息
                             XFSettingItemState:@{
                                     @"num":@1
                                     }.mutableCopy,
                             XFSettingItemRelatedCellClass:[XFSettingInfoCell class],
                             XFSettingOptionActionBlock : ^(XFSettingInfoCell *cell,XFSettingPhaseType phaseType,id intentData,id state){
                                if(phaseType == XFSettingPhaseTypeCellLayout){
                                     CGSize textSize = [cell.rightInfoLabel.text sizeWithFont:cell.rightInfoLabel.font];
                                     CGRect frame = cell.rightInfoLabel.frame;
                                     frame.origin.x =  [UIScreen mainScreen].bounds.size.width - textSize.width - 32 - 15;
                                     cell.rightInfoLabel.frame = frame;
                                 }
                                 
                                 if (phaseType == XFSettingPhaseTypeCellInteracted) {
                                     NSLog(@"当前状态数据：%@",state);
                                     // 修改数据
                                     state[@"num"] = @([state[@"num"] integerValue] + 1);
                                 }
                             }
                             },
                         ],
                 XFSettingGroupFooter : @"lalala~"
                 }// end groupModel
             ];// endgroupArr
}

// 删除cache目录
- (void)cacheDirClear:(XFSettingInfoCell *)cell phaseType:(XFSettingPhaseType)phaseType
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *cachePath =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)  lastObject];
    
    switch (phaseType) {
        case XFSettingPhaseTypeCellInit:{
            
            NSInteger totalSize = [cachePath fileSize];
            double size = totalSize / 1000.0 / 1000.0; // MaxOS和IOS以1000为单位计算
            cell.rightInfoLabel.text = [NSString stringWithFormat:@"%.1fM",size];
        }
            break;
            
        case XFSettingPhaseTypeCellInteracted:{
            NSString *info = cell.rightInfoLabel.text;
            if ([info isEqualToString:@"0.0M"]) return;
            
            cell.rightInfoLabel.text = @"正在清理中...";
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                // 直接删除目录
                [fm removeItemAtPath:cachePath error:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.rightInfoLabel.text = @"0.0M";
                    cell.detailTextLabel.text = @"清理完成";
                });
            });
        }
            break;
            default:
            break;
    }
}

@end
