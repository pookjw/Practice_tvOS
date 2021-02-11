//
//  City.m
//  Project7
//
//  Created by Jinwoo Kim on 2/11/21.
//

#import "City.h"

@implementation City

- (City *)initWithName:(NSString *)name country:(NSString *)country coordinates:(CLLocationCoordinate2D)coordinates {
    self = [self init];
    if (self) {
        self.name = name;
        self.country = country;
        self.coordinates = coordinates;
    }
    return self;
}

- (NSString *)formattedName {
    return [NSString stringWithFormat:@"%@ (%@)", self.name, self.country];
}

- (BOOL)matchesWithText:(NSString *)text {
    return ([self.name localizedCaseInsensitiveContainsString:text] || [self.country localizedCaseInsensitiveContainsString:text]);
}

- (BOOL)isEqualToCity:(City *)comparison {
    return [self.name isEqualToString:comparison.name];
}

@end
