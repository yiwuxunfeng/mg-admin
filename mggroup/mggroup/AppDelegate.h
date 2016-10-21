//
//  AppDelegate.h
//  mggroup
//
//  Created by 罗禹 on 16/6/16.
//  Copyright © 2016年 luoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MTWaiter+CoreDataClass.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (NSArray *)arrayFromCoreData:(NSString *)entityName
                     predicate:(NSPredicate *)predicate
                         limit:(NSUInteger)limit
                        offset:(NSUInteger)offset
                       orderBy:(NSArray *)sortDescriptors;

- (NSManagedObject *)insertIntoCoreData:(NSString *)entityName;

- (void)deleteFromCoreData:(NSManagedObject *) obj;
- (MTWaiter *)findWaiterById:(NSString *)waiterId;

+ (AppDelegate *)sharedDelegate;

@end

