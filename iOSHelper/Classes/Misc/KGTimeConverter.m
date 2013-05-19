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

@property (nonatomic, strong) NSNumber *number;

@end


@implementation KGTimeConverter

@synthesize timeUnit = timeUnit_;
@synthesize timeFormat = timeFormat_;
@synthesize number = number_;

+ (KGTimeConverter *)timeConverterWithNumber:(NSNumber *)number {
    return [[KGTimeConverter alloc] initWithNumber:number];
}

- (id)init {
    return [self initWithNumber:[NSNumber numberWithFloat:0]];
}

- (id)initWithNumber:(NSNumber *)number {
    self = [super init];
    if (self) {
        timeUnit_ = KGTimeUnitMillisecond;
        timeFormat_ = KGTimeFormatMinutesSeconds;
        number_ = (number != nil) ? number : [NSNumber numberWithFloat:0];
    }
    return self;
}

- (float)milliseconds {
    if (self.timeUnit == KGTimeUnitMillisecond) return [self.number floatValue];
    else if (self.timeUnit == KGTimeUnitSecond) return [self.number floatValue] * 1000;
    else if (self.timeUnit == KGTimeUnitMinute) return [self.number floatValue] * 1000 * 60;
    else return [self.number floatValue];
}

- (float)seconds {
    if (self.timeUnit == KGTimeUnitMillisecond) return [self.number floatValue] / 1000.f;
    else if (self.timeUnit == KGTimeUnitSecond) return [self.number floatValue];
    else if (self.timeUnit == KGTimeUnitMinute) return [self.number floatValue] * 60;
    else return [self.number floatValue];
}

- (float)minutes {
    if (self.timeUnit == KGTimeUnitMillisecond) return [self.number floatValue] / (1000.f * 60.f);
    else if (self.timeUnit == KGTimeUnitSecond) return [self.number floatValue] / 60.f;
    else if (self.timeUnit == KGTimeUnitMinute) return [self.number floatValue];
    else return [self.number floatValue];
}

- (float)hours {
    if (self.timeUnit == KGTimeUnitMillisecond) return [self.number floatValue] / (1000.f * 60.f * 60.f);
    else if (self.timeUnit == KGTimeUnitSecond) return [self.number floatValue] / (60.f * 60.f);
    else if (self.timeUnit == KGTimeUnitMinute) return [self.number floatValue] / 60.f;
    else return [self.number floatValue];
}

- (float)days {
    if (self.timeUnit == KGTimeUnitMillisecond) return [self.number floatValue] / (1000.f * 60.f * 60.f * 24.f);
    else if (self.timeUnit == KGTimeUnitSecond) return [self.number floatValue] / (60.f * 60.f * 24.f);
    else if (self.timeUnit == KGTimeUnitMinute) return [self.number floatValue] / (60.f * 24.f);
    else return [self.number floatValue];
}

- (NSString *)timeString {
    NSString *outputString = @"";
    
    int seconds = self.seconds;
    
    if (self.timeFormat == KGTimeFormatSeconds) {
        int sec = seconds % 60;
        outputString = [NSString stringWithFormat:@"%02d", sec];
    }
    else if (self.timeFormat == KGTimeFormatMinutesSeconds) {
        int sec = seconds % 60;
        int min = (seconds/60) % 60;
        outputString = [NSString stringWithFormat:@"%02d:%02d", min, sec];
    }
    else if (self.timeFormat == KGTimeFormatHoursMinutesSeconds) {
        int sec = seconds % 60;
        int min = (seconds/60) % 60;
        int hours = (seconds/3600) % 24;
        outputString = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, min, sec];
    }
    else if (self.timeFormat == KGTimeFormatDaysHoursMinutesSeconds) {
        int sec = seconds % 60;
        int min = (seconds/60) % 60;
        int hours = (seconds/3600) % 24;
        int days = (seconds/(3600 * 24)) % 7;
        outputString = [NSString stringWithFormat:@"%02d:%02d:%02d:%02d", days, hours, min, sec];
    }
    
    return outputString;
}

@end
