//
//  Googleplace.h
//  Googleplace
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Googleplace : NSManagedObject

@property (nonatomic, retain) NSString * lid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * photoref;
@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * lng;

@end
