//
// Destination.m
// kronos
//
// Created by Ljuba Miljkovic on 4/17/10.
// Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataHelper.h"
#import "Destination.h"

@implementation Destination

@synthesize destinationStop, routes, stop, colors, platform, direction;

- (id) initWithDestinationStop:(Stop *)_destinationStop forStop:(Stop *)_stop {

	if (self = [super init]) {

		self.destinationStop = _destinationStop;
		self.stop = _stop;
		self.routes = [DataHelper uniqueRoutesForStop:_stop];		
		self.colors = [[NSMutableArray alloc] init];

		for (Route *route in self.routes) {

			for (Direction *dir in [route.directions allObjects])

				if ([dir.stopOrder containsObject:self.stop.tag]&&[dir.stopOrder containsObject:self.destinationStop.tag]) {

					int stopIndex = [dir.stopOrder indexOfObject:self.stop.tag];
					int destionationStopIndex = [dir.stopOrder indexOfObject:self.destinationStop.tag];

					// if the desination stop is the last stop in the direction, set it as the liveRouteDirection
					if (destionationStopIndex == [dir.stopOrder count] - 1) {
						self.direction = dir;
						[self.colors addObject:dir.route.tag];
						break;

					}

					// in some cases, there is no direction with the destination stop as the last stop.
					// if stop comes before destination in this direction, find out the color of this route and add it to the array
					if (stopIndex < destionationStopIndex) {

						// save the direction that matches this stop -> destinationStop pair
						self.direction = dir;

						[self.colors addObject:dir.route.tag];
						break;

					}
				}
		}
		NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES];
		[self.colors sortUsingDescriptors:@[sorter]];

	}
	return(self);
}

// Destination objects are equal if they have the same destinationStop tag
- (BOOL) isEqual:(id)object {

	if (![object isMemberOfClass:[Destination class]]) return(NO);
	Destination *d = (Destination *)object;

	if ([self.destinationStop.tag isEqual:d.destinationStop.tag]) return(YES);
	return(NO);

}


@end
