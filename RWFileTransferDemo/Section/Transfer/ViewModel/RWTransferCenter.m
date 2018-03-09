//
//  RWTransferCenter.m
//  RWFileTransferDemo
//
//  Created by RyanWong on 2018/3/3.
//  Copyright © 2018年 RyanWong. All rights reserved.
//

#import "RWTransferCenter.h"
#import "RWTransferViewModel.h"

static RWTransferCenter *_center = nil;

@interface RWTransferCenter()

@end

@implementation RWTransferCenter

+ (instancetype)center {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _center = [[RWTransferCenter alloc] init];
    });
    return _center;
}

- (void)setupReadyTaskDatas:(NSArray <RWPhotoModel *>*)datas {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:datas.count];
    for (RWPhotoModel *model in datas) {
        RWTransferViewModel *viewModel = [[RWTransferViewModel alloc] initWithModel:model];
        viewModel.source = RWTransferSourceMine;
        [array addObject:viewModel];
        NSLog(@"%@", viewModel.timestampText);
    }
    @synchronized(self) {
        [self.readyTaskDatas addObjectsFromArray:array];
    }
}

- (RWTransferViewModel *)currentReadyTask {
    RWTransferViewModel *viewModel;
    @synchronized(self) {
        viewModel = self.readyTaskDatas[0];
    }
    return viewModel;
}

- (void)nextReadyTask {
    @synchronized(self) {
        [self.readyTaskDatas removeObjectAtIndex:0];
    }
}

#pragma mark - Lazy load

- (NSMutableArray *)readyTaskDatas {
    if (!_readyTaskDatas) {
        _readyTaskDatas = [NSMutableArray array];
    }
    return _readyTaskDatas;
}

- (NSMutableArray *)allTaskDatas {
    if (!_allTaskDatas) {
        _allTaskDatas = [NSMutableArray array];
    }
    return _allTaskDatas;
}

@end
