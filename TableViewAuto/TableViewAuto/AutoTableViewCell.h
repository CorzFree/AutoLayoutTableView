//
//  AutoTableViewCell.h
//  TableViewAuto
//
//  Created by crw on 15/8/13.
//  Copyright (c) 2015年 crw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDFeedEntity.h"

@interface AutoTableViewCell : UITableViewCell
@property(nonatomic, strong) UILabel     *titleLabel;
@property(nonatomic, strong) UILabel     *contentLabel;
@property(nonatomic, strong) UIImageView *mainImageView;
@property(nonatomic, strong) UILabel     *userNameLabel;
@property(nonatomic, strong) UILabel     *timeLabel;
@property(nonatomic, strong) FDFeedEntity *entity;
@end
