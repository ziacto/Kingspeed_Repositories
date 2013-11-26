//
//  RHAddressBook+DLAdditions.h
//  RHAddressBook
//
//  Created by Nguyen Mau Dat on 11/19/13.
//
//

#import "AddressBook.h"
#import <DLBaseClassAdditions/DLBaseClassAdditions.h>

@interface RHAddressBook (DLAdditions)

+ (BOOL)hasBirthdayTodayInPeople:(NSArray*)people;
- (NSMutableArray*)peopleOrderedBySortOrderingAndSectioned;

@end





@interface RHPerson (DLAdditions)

@property (nonatomic, readonly) NSString *nameSortOrdering;

@end


