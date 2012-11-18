//
//  main.m
//  test1
//
//  Created by Mirko on 8/17/12.
//  Copyright (c) 2012 LivelyCode. All rights reserved.
//

#import <Foundation/Foundation.h>

#define num_queues 1000
#define operations_per_queue 100
#define MULTIPLE_QUEUES_TYPE DISPATCH_QUEUE_CONCURRENT
//#define MULTIPLE_QUEUES_TYPE DISPATCH_QUEUE_SERIAL
#define SINGLE_QUEUE_TYPE DISPATCH_QUEUE_CONCURRENT
//#define SINGLE_QUEUE_TYPE DISPATCH_QUEUE_SERIAL

typedef int (^addBlock)(int a, int b);

void test_strings(NSMutableArray *array) {
  for (int i=0; i<num_queues; i++) {
    [array addObject:[NSMutableArray array]];
  }
}

void test_queues(NSMutableArray *array) {
  for (int i=0; i<num_queues; i++) {
    dispatch_queue_t queue = dispatch_queue_create(NULL, MULTIPLE_QUEUES_TYPE);
    [array addObject:queue];
  }
}

void test_multiple_queues_execution(NSMutableArray *queues) {
  dispatch_group_t group = dispatch_group_create();
  for (int i=0; i<num_queues; i++) {
    for (int j=0; j<operations_per_queue; j++) {
      dispatch_group_async(group, [queues objectAtIndex:i], ^{
        NSMutableArray *array = [NSMutableArray array];
      });
    }
  }
  dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

void test_single_queue_execution(dispatch_queue_t queue) {
  dispatch_group_t group = dispatch_group_create();
  for (int i=0; i<num_queues*operations_per_queue; i++) {
    dispatch_group_async(group, queue, ^{
      NSMutableArray *array = [NSMutableArray array];
    });
  }
  dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

void test_operation_queue_execution(NSOperationQueue *queue) {
  for (int i=0; i<num_queues*operations_per_queue; i++) {
    [queue addOperationWithBlock:^{
      NSMutableArray *array = [NSMutableArray array];
    }];
  }
  [queue waitUntilAllOperationsAreFinished];
}

int addFunction(int a, int b) {
  return a+b;
}

void test_function() {
  for (int i=0; i<num_queues*operations_per_queue; i++) {
    NSMutableArray *array = [NSMutableArray array];
  }
}

void test_block(addBlock block) {
  for (int i=0; i<num_queues*operations_per_queue; i++) {
    NSMutableArray *array = [NSMutableArray array];
  }
}

int main(int argc, const char * argv[])
{

  @autoreleasepool {
    NSMutableArray *strings = [NSMutableArray arrayWithCapacity:num_queues];
    NSMutableArray *queues = [NSMutableArray arrayWithCapacity:num_queues];
    test_strings(strings);
    test_queues(queues);
    dispatch_queue_t queue = dispatch_queue_create(NULL, SINGLE_QUEUE_TYPE);
    test_multiple_queues_execution(queues);
    test_single_queue_execution(queue);
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    test_operation_queue_execution(operationQueue);
    
    addBlock block = ^int (int a, int b) {
      return a+b;
    };
    test_function();
    test_block(block);
  }
    return 0;
}

