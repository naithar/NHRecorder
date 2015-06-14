//
//  NHCameraImageEditorController.m
//  Pods
//
//  Created by Sergey Minakov on 11.06.15.
//
//

#import "NHPhotoEditorViewController.h"
//#import <SCFilterSelectorViewInternal.h>
#import "NHCameraFilterView.h"
#import "NHPhotoCaptureCropView.h"
#import "NHPhotoCropCollectionView.h"

@interface NHPhotoEditorViewController ()<NHCameraFilterViewDelegate, NHPhotoCropCollectionViewDelegate>

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NHPhotoCaptureCropView *cropImageView;

@property (nonatomic, strong) UIView *menuContainer;
@property (nonatomic, strong) UIView *menuSeparator;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIButton *cropButton;
@property (nonatomic, strong) UIButton *optionsButton;

@property (nonatomic, strong) UIView *menuContentContainer;
@property (nonatomic, strong) NHCameraFilterView *filterView;
@property (nonatomic, strong) NHPhotoCropCollectionView *cropView;

@end

@implementation NHPhotoEditorViewController

- (instancetype)initWithUIImage:(UIImage*)image {
    self = [super init];
    
    if (self) {
        _image = image;
        [self commonInit];
    }
    
    return self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.cropImageView sizeContent];
}

- (void)commonInit {
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupCropImageView];
    [self setupMenuContentView];
    [self setupMenuView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NHRecorder.back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonNavigationTouch:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonNavigationTouch:)];
}

- (void)backButtonNavigationTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextButtonNavigationTouch:(id)sender {
    if (self.cropImageView.panGestureRecognizer.state == UIGestureRecognizerStatePossible
        && self.cropImageView.pinchGestureRecognizer.state == UIGestureRecognizerStatePossible) {
        
        [self.cropImageView saveImageWithCallbackObject:self andSelector:@selector(savedCapturedImage:error:context:)];
    }
    else {
        NSLog(@"stop doing shit");
    }
}

- (void)setupCropImageView {
    self.cropImageView = [[NHPhotoCaptureCropView alloc] initWithImage:self.image];
    self.cropImageView.backgroundColor = [UIColor redColor];
    [self.cropImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.cropImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.cropImageView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cropImageView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cropImageView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cropImageView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0 constant:0]];
    
    UIView *overlay = [[UIView alloc] init];
    overlay.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.15];
    overlay.userInteractionEnabled = NO;
    overlay.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:overlay];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:overlay
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.cropImageView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:overlay
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.cropImageView
                                                               attribute:NSLayoutAttributeHeight
                                                              multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:overlay
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.cropImageView
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:overlay
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.cropImageView
                                                               attribute:NSLayoutAttributeWidth
                                                              multiplier:1.0 constant:0]];
    
    self.cropImageView.overlay = overlay;
}

- (void)setupMenuContentView {
    
    self.menuContentContainer = [[UIView alloc] init];
    [self.menuContentContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.menuContentContainer.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.menuContentContainer];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuContentContainer
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuContentContainer
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuContentContainer
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0 constant:0]];
    
    [self.menuContentContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.menuContentContainer
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.menuContentContainer
                                                                          attribute:NSLayoutAttributeHeight
                                                                         multiplier:0 constant:80]];
    
    self.filterView = [[NHCameraFilterView alloc] initWithImage:self.image];
    self.filterView.backgroundColor = [UIColor blackColor];
    self.filterView.nhDelegate = self;
    self.filterView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.filterView setSelected:0];
    [self.menuContentContainer addSubview:self.filterView];
    
    self.cropView = [[NHPhotoCropCollectionView alloc] init];
    self.cropView.backgroundColor = [UIColor greenColor];
    self.cropView.nhDelegate = self;
    self.cropView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cropView setSelected:0];
    [self.menuContentContainer addSubview:self.cropView];
    
    [self.menuContentContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.filterView
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.menuContentContainer
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0 constant:2.5]];
    
    [self.menuContentContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.filterView
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.menuContentContainer
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0 constant:0]];
    
    [self.menuContentContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.filterView
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.menuContentContainer
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0 constant:15]];
    
    [self.menuContentContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.filterView
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.menuContentContainer
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0 constant:-15]];
    
    [self.menuContentContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.cropView
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.menuContentContainer
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0 constant:2.5]];
    
    [self.menuContentContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.cropView
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.menuContentContainer
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0 constant:0]];
    
    [self.menuContentContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.cropView
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.menuContentContainer
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1.0 constant:15]];
    
    [self.menuContentContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.cropView
                                                                          attribute:NSLayoutAttributeRight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.menuContentContainer
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1.0 constant:-15]];
}

- (void)setupMenuView {
    self.menuContainer = [[UIView alloc] init];
    [self.menuContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.menuContainer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    [self.view addSubview:self.menuContainer];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuContainer
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.menuContentContainer
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuContainer
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuContainer
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0 constant:0]];
    
    [self.menuContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.menuContainer
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.menuContainer
                                                                   attribute:NSLayoutAttributeHeight
                                                                  multiplier:0 constant:45]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.cropImageView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.menuContainer
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0 constant:0]];
    
    self.filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.filterButton setTitle:@"fn" forState:UIControlStateNormal];
    [self.filterButton setTitle:@"f" forState:UIControlStateSelected];
    [self.filterButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.filterButton.backgroundColor = [UIColor greenColor];
    [self.filterButton addTarget:self action:@selector(filterButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuContainer addSubview:self.filterButton];
    
    
    self.cropButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cropButton setTitle:@"cn" forState:UIControlStateNormal];
    [self.cropButton setTitle:@"c" forState:UIControlStateSelected];
    [self.cropButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.cropButton.backgroundColor = [UIColor blueColor];
    [self.cropButton addTarget:self action:@selector(cropButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuContainer addSubview:self.cropButton];
    
    self.optionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.optionsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.optionsButton setTitle:@"on" forState:UIControlStateNormal];
    [self.optionsButton setTitle:@"o" forState:UIControlStateSelected];
    self.optionsButton.backgroundColor = [UIColor redColor];
    [self.optionsButton addTarget:self action:@selector(optionsButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuContainer addSubview:self.optionsButton];
    
    self.filterButton.selected = YES;
    [self resetContainerView];
    
    [self.menuContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.filterButton
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.menuContainer
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0 constant:0]];
    
    [self.menuContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.filterButton
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.cropButton
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0 constant:0]];
    
    [self.menuContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.cropButton
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.optionsButton
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0 constant:0]];
    
    [self.menuContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.optionsButton
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.menuContainer
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0 constant:0]];
    
    [self.menuContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.filterButton
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.menuContainer
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0 constant:0]];
    
    [self.menuContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.filterButton
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.menuContainer
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0 constant:0]];
    
    [self.menuContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.cropButton
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.menuContainer
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0 constant:0]];
    
    [self.menuContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.cropButton
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.menuContainer
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0 constant:0]];
    
    [self.menuContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.optionsButton
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.menuContainer
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0 constant:0]];
    
    [self.menuContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.optionsButton
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.menuContainer
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0 constant:0]];
    
    [self.menuContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.filterButton
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.cropButton
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:1.0 constant:0]];
    
    [self.menuContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.cropButton
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.optionsButton
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:1.0 constant:0]];
    
    self.menuSeparator = [[UIView alloc] init];
    self.menuSeparator.translatesAutoresizingMaskIntoConstraints = NO;
    self.menuSeparator.backgroundColor = [UIColor whiteColor];
    
    [self.menuContainer addSubview:self.menuSeparator];
    
    [self.menuSeparator addConstraint:[NSLayoutConstraint constraintWithItem:self.menuSeparator
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.menuSeparator
                                                                   attribute:NSLayoutAttributeHeight
                                                                  multiplier:0 constant:0.5]];
    
    [self.menuContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.menuSeparator
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.menuContainer
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0 constant:0]];
    
    [self.menuContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.menuSeparator
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.menuContainer
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0 constant:0]];
    
    [self.menuContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.menuSeparator
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.menuContainer
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0 constant:0]];
}

- (void)filterButtonTouch:(id)sender {
    self.filterButton.selected = YES;
    self.cropButton.selected = NO;
    self.optionsButton.selected = NO;
    
    [self resetContainerView];
}

- (void)cropButtonTouch:(id)sender {
    self.filterButton.selected = NO;
    self.cropButton.selected = YES;
    self.optionsButton.selected = NO;
    
    [self resetContainerView];
}

- (void)optionsButtonTouch:(id)sender {
    self.filterButton.selected = NO;
    self.cropButton.selected = NO;
    self.optionsButton.selected = YES;
    
    [self resetContainerView];
}

- (void)resetContainerView {
    if (self.filterButton.selected) {
        self.filterView.hidden = NO;
        self.cropView.hidden = YES;
    }
    else if (self.cropButton.selected) {
        self.filterView.hidden = YES;
        self.cropView.hidden = NO;
    }
    else if (self.optionsButton.selected) {
        self.filterView.hidden = YES;
        self.cropView.hidden = YES;
    }
    else {
        self.filterView.hidden = YES;
        self.cropView.hidden = YES;
    }
}

- (void)filterView:(NHCameraFilterView *)filteView didSelectFilter:(GPUImageFilter *)filter {
    [self.cropImageView setFilter:filter];
}

- (void)cropView:(NHPhotoCropCollectionView *)cropView didSelectType:(NHCropType)type {
    [self.cropImageView setCropType:type];
}

- (void)savedCapturedImage:(UIImage*)image error:(NSError*)error context:(void*)context {
    
    NSLog(@"saved - %@", error);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
