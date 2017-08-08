//
// CheckInLocationViewController.m
// Project
//
// Created by Ziv on 16/12/30.
//
//

#import "ZXPlacePickerViewController.h"
@import AddressBookUI.ABAddressFormatting;
@import GooglePlaces;
@import MapKit;
#import "Lang.h"
#import "CocoaUtils.h"
#import "UIConstants.h"
#import "UIToolKit.h"
#import "GoogleNearbySearchResult.h"
#import "GoogleNearbySearchResultJsonMapper.h"
#import <AFNetworking/AFNetworking.h>

static NSString *const GoogleAPIKey = @"AIzaSyAPDWS3qn5Ro1T8-jyVRWOdSfD_FSFhy3w";
static CGFloat const Pan = 500;

typedef NS_ENUM (NSUInteger, FloatViewMode) {
	FloatViewModeDismiss,
	FloatViewModeThumbnail,
	FloatViewModeHalfScreen,
	FloatViewModeFullScreen,
};

@interface LocationAnnotation : MKPointAnnotation
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) NSAttributedString *attributedTitle;
@property (nonatomic, strong) NSAttributedString *attributedSubtitle;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, assign) BOOL showsCallout;
@end

@implementation LocationAnnotation
@end

@interface ZXPlacePickerViewController () <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, GMSAutocompleteResultsViewControllerDelegate> {
	CLLocationManager *manager;
}

@property (nonatomic, assign) FloatViewMode floatViewMode;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, assign) CLLocationCoordinate2D selectedCoordinate;

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UIButton *userTrackingButton;
@property (nonatomic, weak) IBOutlet UIView *floatView;
@property (nonatomic, weak) IBOutlet UIView *floatStickView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *locationView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *floatViewTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *floatViewHeightConstraint;

@property (nonatomic, strong) NSArray *cellDataArray;

@end

@implementation ZXPlacePickerViewController

- (instancetype)init {
	if (self = [super init]) {
		self.edgesForExtendedLayout = UIRectEdgeNone;
		self.hidesBottomBarWhenPushed = YES;
		self.title = @"Place Picker";
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	if (YES) {
		manager = [[CLLocationManager alloc] init];
		if (![CLLocationManager locationServicesEnabled]) {
			NSLog(@"设备为打开定位服务");
		}
		[manager requestWhenInUseAuthorization];
		if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
			NSLog(@"手机未开起定位服务");
		}
	}
	if (YES) {
		GMSAutocompleteResultsViewController *resultsViewController = [[GMSAutocompleteResultsViewController alloc] init];
		resultsViewController.delegate = self;

		self.searchController = [[UISearchController alloc] initWithSearchResultsController:resultsViewController];
// self.searchController.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.searchController.searchBar.searchBarStyle = UISearchBarStyleDefault;
		[self.searchController.searchBar sizeToFit];
		[self.view addSubview:self.searchController.searchBar];
		self.definesPresentationContext = YES;
		self.searchController.searchResultsUpdater = resultsViewController;
	}
	if (YES) {
		self.mapView.userTrackingMode = MKUserTrackingModeFollow;
		self.mapView.showsCompass = NO;
	}
	[self.tableView reloadData];
	[self configureOtherViews];
	[self moveFloatViewWithMode:FloatViewModeHalfScreen animated:NO completion:nil];
}

#pragma mark - Public

#pragma mark - Network

// - (void)searchNeighbouringPlace:(CLLocationCoordinate2D)coordinate completed:(void (^) (NSArray<MKMapItem *> *mapItems))completed {
// [self.activityIndicator startAnimating];
// MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
// request.naturalLanguageQuery = @"hotel";
// request.region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100);
// MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
// [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
// [self.activityIndicator stopAnimating];
// if (!error) {
// if (completed) {
// completed(response.mapItems);
// }
// }
// }];
// }

- (void)searchNeighbouringPlace:(CLLocationCoordinate2D)coordinate completed:(void (^)(NSArray<GoogleNearbySearchResult *> *results))completed {
	GoogleNearbySearch *request = [[GoogleNearbySearch alloc] init];
	request.latitude = coordinate.latitude;
	request.longitude = coordinate.longitude;
	request.radius = Pan;
	request.googleApiKey = GoogleAPIKey;

	[self.activityIndicator startAnimating];
	AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
	sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
	NSURLSessionDataTask *dataTask = [sessionManager GET:request.url parameters:[request parameters] progress:^(NSProgress *_Nonnull downloadProgress) {
	} success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
		[self.activityIndicator stopAnimating];
		NSLog(@"%@", responseObject);
		GoogleNearbySearchResultJsonMapper *mapper = [[GoogleNearbySearchResultJsonMapper alloc] init];
		if (![mapper parseWithJSONObject:responseObject]) {
			GoogleNearbySearchResponse *response = mapper.response;
			if (response.results.count > 0) {
				if (completed) {
                    for (GoogleNearbySearchResult* result in response.results) {
                        result.distance = [CocoaUtils distanceFromCoordinate:CLLocationCoordinate2DMake(result.latitude, result.longitude) toCoordinate:coordinate];
                    }
                    // sort
                    completed([response.results sortedArrayUsingComparator:^NSComparisonResult(GoogleNearbySearchResult*  _Nonnull obj1, GoogleNearbySearchResult*  _Nonnull obj2) {
                        if (obj1.distance < obj2.distance) {
                            return NSOrderedAscending;
                        }
                        return NSOrderedDescending;
                    }]);
				}
			}
		}
	} failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
		[self.activityIndicator stopAnimating];
		NSLog(@"Error: %@", error.localizedDescription);
	}];
	NSLog(@"GET: %@", dataTask.currentRequest.URL);
}

#pragma mark - Action

- (IBAction)changeUserTrackingMode:(UIButton *)sender {
	switch (self.mapView.userTrackingMode) {
		case MKUserTrackingModeNone:
			[self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
			break;

		case MKUserTrackingModeFollow:
			[self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
			break;

		case MKUserTrackingModeFollowWithHeading:
			[self.mapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
			break;

		default:
			break;
	}
}

- (IBAction)swipeFloatView:(UISwipeGestureRecognizer *)swipe {
	if (swipe.direction == UISwipeGestureRecognizerDirectionUp && self.floatViewMode != FloatViewModeFullScreen) {
		[self moveFloatViewWithMode:MIN(self.floatViewMode + 1, FloatViewModeFullScreen) animated:YES completion:nil];
	} else if (swipe.direction == UISwipeGestureRecognizerDirectionDown && self.floatViewMode != FloatViewModeHalfScreen) {
		[self moveFloatViewWithMode:MAX(self.floatViewMode - 1, FloatViewModeHalfScreen) animated:YES completion:nil];
	}
}

#pragma mark - Private

- (void)sortSearchResultByDistanceToCenterCoordinate:(CLLocationCoordinate2D)coordinate {
    
}

- (void)buildCellDataSource:(NSArray<GoogleNearbySearchResult *> *)results {
	NSMutableArray *array = [NSMutableArray array];
	__weak ZXPlacePickerViewController *weakSelf = self;
	for (GoogleNearbySearchResult *result in results) {
		TableViewCellData *data = [[TableViewCellData alloc] init];
		data.style = UITableViewCellStyleSubtitle;
		data.text = [result.name stringByAppendingString:[NSString stringWithFormat:@" (%.6lf)", result.distance]];
		data.textFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCallout];
		data.detailText = result.vicinity;
		data.detailTextFont = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
		data.detailTextColor = [UIColor lightGrayColor];
		[data setAccessoryTypeBlock:^UITableViewCellAccessoryType {
			if ([self coordinate:CLLocationCoordinate2DMake(result.latitude, result.longitude) isEquleToOtherCoordinate:self.selectedCoordinate]) {
				return UITableViewCellAccessoryCheckmark;
			}
			return UITableViewCellAccessoryNone;
		}];
		[data setDidSelectBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
			weakSelf.selectedCoordinate = CLLocationCoordinate2DMake(result.latitude, result.longitude);
			[tableView reloadData];
			[weakSelf.mapView setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(result.latitude, result.longitude), 100, 100) animated:YES];
		}];
		[array addObject:data];
	}
	self.cellDataArray = array;
}

- (BOOL)coordinate:(CLLocationCoordinate2D)coordinate isEquleToOtherCoordinate:(CLLocationCoordinate2D)otherCoordinate {
	if ([[NSString stringWithFormat:@"%.6lf", coordinate.latitude] isEqualToString:[NSString stringWithFormat:@"%.6lf", otherCoordinate.latitude]] && [[NSString stringWithFormat:@"%.6lf", coordinate.longitude] isEqualToString:[NSString stringWithFormat:@"%.6lf", otherCoordinate.longitude]]) {
		return YES;
	}
	return NO;
}

- (void)locationImageViewAnimate {
	CGPoint point = self.locationView.center;
	self.locationView.center = CGPointMake(point.x, point.y - CGRectGetHeight(self.locationView.frame));
	[UIView animateWithDuration:0.15 animations:^{
		self.locationView.center = point;
	} completion:^(BOOL finished) {
		if (finished) {
			[UIView animateWithDuration:0.07 animations:^{
				self.locationView.transform = CGAffineTransformMakeScale(1.2, 0.8);
			} completion:^(BOOL finished) {
				if (finished) {
					[UIView animateWithDuration:0.06 animations:^{
						self.locationView.transform = CGAffineTransformMakeScale(0.9, 1.1);
					} completion:^(BOOL finished) {
						if (finished) {
							[UIView animateWithDuration:0.05 animations:^{
								self.locationView.transform = CGAffineTransformIdentity;
							}];
						}
					}];
				}
			}];
		}
	}];
}

- (void)configureOtherViews {

}

- (void)configureFloatView {
	self.floatViewHeightConstraint.constant = CGRectGetHeight(self.view.frame) - [UIConstants defaultTableViewRowHeight] * 4;
	self.tableView.contentInset = UIEdgeInsetsZero;
}

- (void)moveFloatViewWithMode:(FloatViewMode)mode animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
	///
	[self configureFloatView];
	CGFloat viewHeight = CGRectGetHeight(self.view.frame);
	CGFloat mapViewMinHeight = [UIConstants defaultTableViewRowHeight] * 4;
	CGFloat floatViewHeaderHeight = CGRectGetMinY(self.tableView.frame) + self.tableView.contentInset.top;
	CGFloat floatViewBodyHeight = self.tableView.contentSize.height + self.tableView.contentInset.bottom;
	CGFloat floatViewBodyMinHeight = [UIConstants defaultTableViewRowHeight] * 3;
	CGFloat floatViewBodyMaxHeight = MIN(viewHeight - mapViewMinHeight, floatViewBodyHeight);
	///
	if (mode == FloatViewModeFullScreen) {
		if (floatViewBodyMinHeight > floatViewBodyHeight) {
			mode = FloatViewModeHalfScreen;
		}
	}
	///
	self.tableView.scrollEnabled = NO;
	if (mode == FloatViewModeFullScreen) {
		if (floatViewBodyMaxHeight < floatViewBodyHeight) {
			self.tableView.scrollEnabled = YES;
		}
	}
	///
	switch (mode) {
		case FloatViewModeFullScreen: {
			self.floatViewTopConstraint.constant = viewHeight - floatViewHeaderHeight - floatViewBodyMaxHeight;
			break;
		}
		case FloatViewModeHalfScreen: {
			self.floatViewTopConstraint.constant = viewHeight - floatViewHeaderHeight - floatViewBodyMinHeight;
			break;
		}
		case FloatViewModeThumbnail: {
			self.floatViewTopConstraint.constant = viewHeight - floatViewHeaderHeight;
			break;
		}
		case FloatViewModeDismiss: {
			self.floatViewTopConstraint.constant = viewHeight;
			break;
		}

		default:
			break;
	}
	[self.floatView setNeedsUpdateConstraints];
	if (animated) {
		[UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			[self.view layoutIfNeeded];
		} completion:completion];
	} else if (completion) {
		completion(YES);
	}
	self.floatViewMode = mode;
}

#pragma mark - Map view delegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
	[self locationImageViewAnimate];
	self.selectedCoordinate = mapView.centerCoordinate;
	[self searchNeighbouringPlace:mapView.centerCoordinate completed:^(NSArray<GoogleNearbySearchResult *> *results) {
		[self buildCellDataSource:results];
		[self.tableView reloadData];
	}];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	if (![annotation isKindOfClass:[LocationAnnotation class]]) {
		return nil;
	}
	LocationAnnotation *marker = annotation;
	MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:marker.identifier];
	if (!annotationView) {
		annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:marker.identifier];
	}
	annotationView.canShowCallout = NO;
	annotationView.annotation = marker;
	annotationView.image = marker.image;
	if ([marker.identifier isEqualToString:@"BusStation"] || [marker.identifier isEqualToString:@"BusStop"]) {
		annotationView.centerOffset = CGPointMake(0, -annotationView.image.size.height / 2);
	} else {
		annotationView.centerOffset = CGPointZero;
	}
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
	for (MKAnnotationView *view in views) {
		if ([NSStringFromClass(view.class) isEqualToString:@"MKModernUserLocationView"]) {
			view.canShowCallout = NO;
		}
	}
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {

}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {

}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated {
	if (mode == MKUserTrackingModeFollowWithHeading) {
		[self.userTrackingButton setImage:[UIImage imageNamed:@"icon_location"] forState:UIControlStateNormal];
	} else if (mode == MKUserTrackingModeFollow) {
		[self.userTrackingButton setImage:[UIImage imageNamed:@"icon_location"] forState:UIControlStateNormal];
	} else if (mode == MKUserTrackingModeNone) {
		[self.userTrackingButton setImage:[UIImage imageNamed:@"icon_location"] forState:UIControlStateNormal];
	}
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
	MKPolylineRenderer *line = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
	line.lineWidth = 5;
	line.strokeColor = [UIColor aquaColor];
	return line;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.cellDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TableViewCellData *data = self.cellDataArray[indexPath.row];
	return [UIToolkit tableView:tableView atIndexPath:indexPath cellWithData:data];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	TableViewCellData *data = self.cellDataArray[indexPath.row];
	return [UIToolkit tableView:tableView atIndexPath:indexPath rowHeightWithData:data];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	TableViewCellData *data = self.cellDataArray[indexPath.row];
	[UIToolkit tableView:tableView atIndexPath:indexPath didSelectWithData:data];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	TableViewCellData *data = self.cellDataArray[indexPath.row];
	[UIToolkit tableView:tableView atIndexPath:indexPath didDeselectWithData:data];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y < -40) {
		[self moveFloatViewWithMode:FloatViewModeHalfScreen animated:YES completion:nil];
	}
}

#pragma mark - GMSAutocompleteResultsViewControllerDelegate

- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
didAutocompleteWithPlace:(GMSPlace *)place {
	[self.searchController setActive:NO];
	[self.mapView setCenterCoordinate:place.coordinate animated:YES];
}

- (void)resultsController:(GMSAutocompleteResultsViewController *)resultsController
didFailAutocompleteWithError:(NSError *)error {
	[self.searchController setActive:NO];
}

@end
