//
//  KGTimeConverter.h
//  iOSHelper
//
//  Created by kampfgnu on 5/4/12.
//  Copyright (c) 2012 NOUS. All rights reserved.
//

typedef enum {
    KGTimeUnitMillisecond,
    KGTimeUnitSecond,
    KGTimeUnitMinute
} KGTimeUnit;

typedef enum {
    KGTimeFormatSeconds,
    KGTimeFormatMinutesSeconds,
    KGTimeFormatHoursMinutesSeconds,
    KGTimeFormatDaysHoursMinutesSeconds
} KGTimeFormat;

@interface KGTimeConverter : NSObject

+ (KGTimeConverter *)timeConverterWithNumber:(NSNumber *)number;

- (float)milliseconds;
- (float)seconds;
- (float)minutes;
- (float)hours;
- (float)days;

- (NSString *)timeString;

@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, readwrite) KGTimeUnit timeUnit;
@property (nonatomic, readwrite) KGTimeFormat timeFormat;

@end
