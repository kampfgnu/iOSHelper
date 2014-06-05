//
//  KGTimeConverter.m
//  iOSHelper
//
//  Created by kampfgnu on 5/4/12.
//  Copyright (c) 2012 NOUS. All rights reserved.
//

#import "KGTimeConverter.h"

@interface KGTimeConverter ()

- (id)initWithNumber:(NSNumber *)number;

@end


@implementation KGTimeConverter

+ (KGTimeConverter *)timeConverterWithNumber:(NSNumber *)number {
    return [[KGTimeConverter alloc] initWithNumber:number];
}

- (id)init {
    return [self initWithNumber:[NSNumber numberWithFloat:0]];
}

- (id)initWithNumber:(NSNumber *)number {
    self = [super init];
    if (self) {
        self.timeUnit = KGTimeUnitMillisecond;
        self.timeFormat = KGTimeFormatMinutesSeconds;
        self.number = (number != nil) ? number : [NSNumber numberWithFloat:0];
    }
    return self;
}

- (float)milliseconds {
    if (_timeUnit == KGTimeUnitMillisecond) return [_number floatValue];
    else if (_timeUnit == KGTimeUnitSecond) return [_number floatValue] * 1000;
    else if (_timeUnit == KGTimeUnitMinute) return [_number floatValue] * 1000 * 60;
    else return [_number floatValue];
}

- (float)seconds {
    if (_timeUnit == KGTimeUnitMillisecond) return [_number floatValue] / 1000.f;
    else if (_timeUnit == KGTimeUnitSecond) return [_number floatValue];
    else if (_timeUnit == KGTimeUnitMinute) return [_number floatValue] * 60;
    else return [_number floatValue];
}

- (float)minutes {
    if (_timeUnit == KGTimeUnitMillisecond) return [_number floatValue] / (1000.f * 60.f);
    else if (_timeUnit == KGTimeUnitSecond) return [_number floatValue] / 60.f;
    else if (_timeUnit == KGTimeUnitMinute) return [_number floatValue];
    else return [_number floatValue];
}

- (float)hours {
    if (_timeUnit == KGTimeUnitMillisecond) return [_number floatValue] / (1000.f * 60.f * 60.f);
    else if (_timeUnit == KGTimeUnitSecond) return [_number floatValue] / (60.f * 60.f);
    else if (_timeUnit == KGTimeUnitMinute) return [_number floatValue] / 60.f;
    else return [_number floatValue];
}

- (float)days {
    if (_timeUnit == KGTimeUnitMillisecond) return [_number floatValue] / (1000.f * 60.f * 60.f * 24.f);
    else if (_timeUnit == KGTimeUnitSecond) return [_number floatValue] / (60.f * 60.f * 24.f);
    else if (_timeUnit == KGTimeUnitMinute) return [_number floatValue] / (60.f * 24.f);
    else return [_number floatValue];
}

- (NSString *)timeString {
    NSString *outputString = @"";
    
    int seconds = [self seconds];
    
    if (_timeFormat == KGTimeFormatSeconds) {
        int sec = seconds % 60;
        outputString = [NSString stringWithFormat:@"%02d", sec];
    }
    else if (_timeFormat == KGTimeFormatMinutesSeconds) {
        int sec = seconds % 60;
        int min = (seconds/60) % 60;
        outputString = [NSString stringWithFormat:@"%02d:%02d", min, sec];
    }
    else if (_timeFormat == KGTimeFormatHoursMinutesSeconds) {
        int sec = seconds % 60;
        int min = (seconds/60) % 60;
        int hours = (seconds/3600) % 24;
        outputString = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, min, sec];
    }
    else if (_timeFormat == KGTimeFormatDaysHoursMinutesSeconds) {
        int sec = seconds % 60;
        int min = (seconds/60) % 60;
        int hours = (seconds/3600) % 24;
        int days = (seconds/(3600 * 24)) % 7;
        outputString = [NSString stringWithFormat:@"%02d:%02d:%02d:%02d", days, hours, min, sec];
    }
    
    return outputString;
}

@end
