#import "NSDate+KGAdditions.h"
#import "KGMath.h"

static NSDateFormatter *dateFormatter_ = nil;

NSDateFormatter* dateFormatter(void);

@implementation NSDate (KGAdditions)

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class Methods
////////////////////////////////////////////////////////////////////////

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format {
	if(dateString == nil) {
    return nil;
  }
  
  NSDateFormatter *formatter = dateFormatter();
	[formatter setDateFormat:format];
  
	return [formatter dateFromString:dateString];
}

+ (NSDate *)dateWithYear:(NSInteger)year {
	return [self dateWithYear:year month:0 day:0 hour:0 minute:0 second:0];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month {
	return [self dateWithYear:year month:month day:0 hour:0 minute:0 second:0];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
	return [self dateWithYear:year month:month day:day hour:0 minute:0 second:0];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour {
	return [self dateWithYear:year month:month day:day hour:hour minute:0 second:0];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute {
	return [self dateWithYear:year month:month day:day hour:hour minute:minute second:0];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
	NSDateComponents *comps = [[NSDateComponents alloc] init];
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  
	[comps setYear:year];
	[comps setMonth:month];
	[comps setDay:day];
	[comps setHour:hour];
	[comps setMinute:minute];
	[comps setSecond:second];
  
	return [gregorian dateFromComponents:comps];
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Instance Methods
////////////////////////////////////////////////////////////////////////

- (NSString *)dateStringWithFormat:(NSString *)format {
  if(format == nil) {
    return nil;
  }
  
  NSDateFormatter* formatter = dateFormatter();
  [formatter setDateFormat:format];
  [formatter setAMSymbol:@"am"];
  [formatter setPMSymbol:@"pm"];
  
  return [formatter stringFromDate:self];
}

- (BOOL)isBefore:(NSDate *)otherDate {
	return [self timeIntervalSinceDate:otherDate] < 0;
}

- (BOOL)isAfter:(NSDate *)otherDate {
	return [self timeIntervalSinceDate:otherDate] > 0;
}

- (BOOL)isToday {
	return [[[NSDate date] midnightDate] isEqual:[self midnightDate]];
}

- (BOOL)isYesterday {
	return [[[NSDate dateWithTimeIntervalSinceNow:-KGTimeIntervalDays(1)] midnightDate] isEqual:[self midnightDate]];
}

- (BOOL)isTomorrow {
	return [[[NSDate dateWithTimeIntervalSinceNow:KGTimeIntervalDays(1)] midnightDate] isEqual:[self midnightDate]];
}

- (NSDate *)midnightDate {
	return [[NSCalendar currentCalendar] dateFromComponents:[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self]];
}

- (NSDateComponents *)gregorianCalendarComponents {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [gregorian components:(NSSecondCalendarUnit |
                                                        NSMinuteCalendarUnit |
                                                        NSHourCalendarUnit |
                                                        NSDayCalendarUnit |
                                                        NSWeekdayCalendarUnit |
                                                        NSWeekCalendarUnit |
                                                        NSWeekOfYearCalendarUnit |
                                                        NSMonthCalendarUnit |
                                                        NSYearCalendarUnit) fromDate:self];
	return components;
}

- (NSInteger)secondComponent {
	return [[self gregorianCalendarComponents] second];
}

- (NSInteger)minuteComponent {
	return [[self gregorianCalendarComponents] minute];
}

- (NSInteger)hourComponent {
	return [[self gregorianCalendarComponents] hour];
}

- (NSInteger)dayComponent {
	return [[self gregorianCalendarComponents] day];
}

- (NSInteger)dayOfYearComponent {
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSUInteger dayOfYear = [gregorian ordinalityOfUnit:NSDayCalendarUnit
                                              inUnit:NSYearCalendarUnit
                                             forDate:self];
  return dayOfYear;
}

- (NSInteger)weekdayComponent {
	return [[self gregorianCalendarComponents] weekday];
}

- (NSInteger)weekComponent {
	return [[self gregorianCalendarComponents] week];
}

- (NSInteger)weekOfYearComponent {
  return [[self gregorianCalendarComponents] weekOfYear];
}

- (NSInteger)monthComponent {
	return [[self gregorianCalendarComponents] month];
}

- (NSInteger)yearComponent {
	return [[self gregorianCalendarComponents] year];
}

- (NSInteger)daysSinceDate:(NSDate *)date {
	NSTimeInterval timeInterval = [self timeIntervalSinceDate:date];
  
	return timeInterval / 3600. / 24.;
}

- (NSDate *)dateByAddingDays:(NSUInteger)days {
  NSCalendar *calender = [NSCalendar currentCalendar];
  NSDateComponents *components = [[NSDateComponents alloc] init];
  
  components.day = days;
  
  return [calender dateByAddingComponents:components toDate:self options:0];
}

// This hard codes the assumption that a week is 7 days
- (BOOL)isSameWeekAsDate:(NSDate *)date {
	// Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
	if (self.weekComponent != date.weekComponent) {
    return NO;
  }
	
	return (ABS([self timeIntervalSinceDate:date]) < KGTimeIntervalDays(7));
}

- (BOOL)isSameDayAsDate:(NSDate *)date {
  return (self.yearComponent == date.yearComponent &&
          self.monthComponent == date.monthComponent &&
          self.dayComponent == date.dayComponent);
}

@end

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Helper Functions
////////////////////////////////////////////////////////////////////////

NSDateFormatter* dateFormatter(void) {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dateFormatter_ = [[NSDateFormatter alloc] init];
  });
  
  return dateFormatter_;
}