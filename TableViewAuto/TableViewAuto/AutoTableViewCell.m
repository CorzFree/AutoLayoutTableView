//
//  AutoTableViewCell.m
//  TableViewAuto
//
//  Created by crw on 15/8/13.
//  Copyright (c) 2015年 crw. All rights reserved.
//

#import "AutoTableViewCell.h"
#import "Masonry.h"
#define margin 10
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
@interface AutoTableViewCell(){
    MASConstraint *constraint_content;/**<内容上边距为5的约束,没内容时将边距设置为0 */
    MASConstraint *constraint_mainImageView;
    MASConstraint *constraint_userNameLabel;
}
@end

@implementation AutoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.bounds = [UIScreen mainScreen].bounds;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setAutoLayout];
    }
    return self;
}

- (void)addView:(UIView *)view{
    [self.contentView addSubview:view];
}

- (void)setAutoLayout{
    WS(ws);
    _titleLabel                    = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 0;
    //_titleLabel.backgroundColor    = [UIColor redColor];
    [self addView:_titleLabel];
    
    _contentLabel                  = [[UILabel alloc] init];
    _contentLabel.numberOfLines    = 0;
    _contentLabel.font             = [UIFont systemFontOfSize:14];
    _contentLabel.textColor        = [UIColor grayColor];
    //_contentLabel.backgroundColor  = [UIColor purpleColor];
    [self addView:_contentLabel];
    
    _mainImageView                 = [[UIImageView alloc] init];
    _mainImageView.contentMode     = UIViewContentModeScaleAspectFill;
    _mainImageView.clipsToBounds   = YES;
    //_mainImageView.backgroundColor = [UIColor orangeColor];
    [self addView:_mainImageView];
    
    _userNameLabel                 = [[UILabel alloc] init];
    //_userNameLabel.backgroundColor = [UIColor greenColor];
    _userNameLabel.textColor       = [UIColor orangeColor];
    _userNameLabel.font            = [UIFont systemFontOfSize:12];
    [self addView:_userNameLabel];
    
    _timeLabel                     = [[UILabel alloc] init];
    _timeLabel.textColor           = [UIColor blueColor];
    _timeLabel.font                = [UIFont systemFontOfSize:12];
    //_timeLabel.backgroundColor     = [UIColor blueColor];
    [self addView:_timeLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(ws.contentView).offset(margin);
        make.trailing.equalTo(ws.contentView.mas_trailing).offset(-margin);
        make.top.equalTo(ws.contentView).offset(margin);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_titleLabel.mas_left);
        make.right.equalTo(ws.contentView.mas_right).offset(-margin);
        //以下设置距离title的边距,设置两条优先度不同的约束，内容为空时将优先度高的约束禁用
        make.top.equalTo(_titleLabel.mas_bottom).priorityLow();//优先度低，会被优先度高覆盖
        constraint_content = make.top.equalTo(_titleLabel.mas_bottom).offset(5).priorityHigh();
    }];
    
    [_mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.height.greaterThanOrEqualTo(@0);
        make.right.lessThanOrEqualTo(ws.contentView.mas_right).offset(-margin);
        make.top.equalTo(_contentLabel.mas_bottom).priorityLow();
        constraint_mainImageView = make.top.equalTo(_contentLabel.mas_bottom).offset(5).priorityHigh();
    }];
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_left);
        make.top.equalTo(_mainImageView.mas_bottom).priorityLow();
        constraint_userNameLabel = make.top.equalTo(_mainImageView.mas_bottom).offset(5).priorityHigh();
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.contentView.mas_right).offset(-margin);
        make.top.equalTo(_userNameLabel.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-margin);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEntity:(FDFeedEntity *)entity
{
    _entity = entity;
    
    self.titleLabel.text     = entity.title;
    self.contentLabel.text   = entity.content;
    self.mainImageView.image = entity.imageName.length > 0 ? [UIImage imageNamed:entity.imageName] : nil;
    self.userNameLabel.text  = entity.username;
    self.timeLabel.text      = entity.time;
    
    self.contentLabel.text.length ==  0 ?[constraint_content deactivate]:[constraint_content activate];
    self.mainImageView.image      == nil?[constraint_mainImageView deactivate]:[constraint_mainImageView activate];
    self.userNameLabel.text.length==  0 ?[constraint_userNameLabel deactivate]:[constraint_userNameLabel activate];
}


#if 0

// If you are not using auto layout, override this method
- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat totalHeight = 0;
    totalHeight += [self.titleLabel sizeThatFits:size].height;
    totalHeight += [self.contentLabel sizeThatFits:size].height;
    totalHeight += [self.mainImageView sizeThatFits:size].height;
    totalHeight += [self.userNameLabel sizeThatFits:size].height;
    totalHeight += 40; // margins
    return CGSizeMake(size.width, totalHeight);
}

#endif

@end
