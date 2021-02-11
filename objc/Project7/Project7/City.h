//
//  City.h
//  Project7
//
//  Created by Jinwoo Kim on 2/11/21.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface City : NSObject
- (City *)initWithName:(NSString *)name country:(NSString *)country coordinates:(CLLocationCoordinate2D)coordinates;
@property (readonly, nonatomic) NSString *formattedName;
@property NSString *name;
@property NSString *country;
@property CLLocationCoordinate2D coordinates;
- (BOOL)matchesWithText:(NSString *)text;
- (BOOL)isEqualToCity:(City *)comparison;
@end
