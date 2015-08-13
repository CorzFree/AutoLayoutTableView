//
//  ViewController.m
//  结合Masonry和FDTemplateLayoutCell，自己第一个autolayout小demo，数据来自FDTemplateLayoutCell的demo，整个demo是参考FDTemplateLayoutCell demo的Storyboard布局自己用Masonry添加约束
//
//  Created by crw on 15/8/13.
//  Copyright (c) 2015年 crw. All rights reserved.
//  原文出处https://github.com/forkingdog/UITableView-FDTemplateLayoutCell

#import "ViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "FDFeedEntity.h"
#import "AutoTableViewCell.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *mTableView;
}
@property (nonatomic, strong) NSMutableArray *feedEntitySections;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:mTableView];
    
    mTableView.dataSource = self;
    mTableView.delegate   = self;
    [mTableView registerClass:[AutoTableViewCell class] forCellReuseIdentifier:@"AutoTableViewCell"];
    
    mTableView.estimatedRowHeight = 200;//预算行高
    mTableView.fd_debugLogEnabled = YES;//开启log打印高度
    [self buildTestDataThen:^{
        [mTableView reloadData];
    }];
}

- (void)buildTestDataThen:(void (^)(void))then{
    // Simulate an async request
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Data from `data.json`
        NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *feedDicts = rootDict[@"feed"];
        
        // Convert to `FDFeedEntity`
        NSMutableArray *entities = @[].mutableCopy;
        [feedDicts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [entities addObject:[[FDFeedEntity alloc] initWithDictionary:obj]];
        }];
        self.feedEntitySections = entities;
        
        // Callback
        dispatch_async(dispatch_get_main_queue(), ^{
            !then ?: then();
        });
    });
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AutoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AutoTableViewCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(AutoTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    if (indexPath.row % 2 == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.entity = self.feedEntitySections[indexPath.row];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //高度计算并且缓存
    return [tableView fd_heightForCellWithIdentifier:@"AutoTableViewCell" cacheByIndexPath:indexPath configuration:^(AutoTableViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.feedEntitySections.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FDFeedEntity *obj = self.feedEntitySections[indexPath.row];
    obj.title = @"OH，NO，TITLE CLICK";
    obj.content = @"Let our rock！！！";
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
