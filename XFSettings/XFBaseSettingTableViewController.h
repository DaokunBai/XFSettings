//
//  XFBaseSettingTableViewController.h
//  XFSettings
//
//  Created by Yizzuide on 15/5/27.
//  Copyright (c) 2015年 Yizzuide. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XFSettings.h"

@protocol XFBaseSettingDataSource <NSObject>

@required
/**
 *  返回要填充的数据
 *  如: 
 return @[ // groupArr
     @{ // groupModel
     XFSettingGroupHeader: @"缓存信息",
     XFSettingGroupItems : @[ // items
         @{ // itemModel
         XFSettingItemTitle: @"缓存大小",
         XFSettingItemIcon : @"draft",
         XFSettingItemClass : [XFSettingInfoItem class], // 这个字段用于判断是否有右边辅助功能的cell,不写则没有
         XFSettingItemRelatedCellClass:[XFSettingInfoCell class],// 自定义的cell
         XFSettingItemDestViewControllerClass : [destVCClass class], // 如果有目标控制器
         XFSettingOptionActionBlock : ^(XFSettingInfoCell *cell,,XFSettingPhaseType phaseType,id intentData){ // 如果有可选的操作
                 switch (phaseType) {
                     case XFSettingPhaseTypeCellInit:
                        cell.detailTextLabel.textColor = [UIColor orangeColor];
                     break;
                     case XFSettingPhaseTypeCellInteracted:
                        NSLog(@"%@",@"interated");
                        XFSettingInfoItem *item = (XFSettingInfoItem *)cell.item;
                        item.rightInfo = @"changed";
                     break;
                 }
 
         }
         }// end itemModel
     ],
     XFSettingGroupFooter : @"lalala~"
     }// end groupModel
 ];// endgroupArr
 *  @return 返回NSArray数据模型
 */
- (NSArray *)baseSettingItems;

//@optional
/**
 *  继承XFSettingCell的子类要实现这个方法
 *
 *  @return 返回子类的Class
 */
//- (Class)typeOfSettingCellForBaseSettingTableView;
@end

@interface XFBaseSettingTableViewController : UITableViewController

@property (nonatomic, weak) id<XFBaseSettingDataSource> dataSource;
@end
