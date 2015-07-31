//
//  NHCameraViewController.h
//  Pods
//
//  Created by Sergey Minakov on 04.06.15.
//
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>
#import "NHRecorderButton.h"

extern const CGFloat kNHRecorderBottomViewHeight;
extern const CGFloat kNHRecorderCaptureButtonHeight;
extern const CGFloat kNHRecorderSideButtonHeight;
extern const CGFloat kNHRecorderCaptureButtonBorderOffset;

@class NHCameraGridView;
@class NHPhotoFocusView;
@class NHPhotoCaptureViewController;

@protocol NHPhotoCaptureViewControllerDelegate <NSObject>

@optional

- (void)nhPhotoCaptureDidStartExporting:(NHPhotoCaptureViewController*)photoCapture;
- (void)photoCaptureDidFinishExporting:(NHPhotoCaptureViewController*)photoCapture;

- (BOOL)nhPhotoCapture:(NHPhotoCaptureViewController*)photoCapture shouldEditImage:(UIImage*)image;
- (BOOL)nhPhotoCapture:(NHPhotoCaptureViewController*)photoCapture cameraAvailability:(AVAuthorizationStatus)status;
- (CGSize)imageSizeToFitForNHPhotoCapture:(NHPhotoCaptureViewController*)photoCapture;
@end

@interface NHPhotoCaptureViewController : UIViewController

@property (nonatomic, assign) BOOL videoCaptureEnabled;
@property (nonatomic, assign) BOOL firstController;

@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, strong) UIColor *barButtonTintColor;


@property (nonatomic, readonly, strong) GPUImageView *photoCameraView;
@property (nonatomic, readonly, strong) NHCameraGridView *cameraGridView;
@property (nonatomic, readonly, strong) NHPhotoFocusView *cameraFocusView;
@property (nonatomic, readonly, strong) UIView *bottomContainerView;

@property (nonatomic, readonly, strong) NHRecorderButton *closeButton;
@property (nonatomic, readonly, strong) NHRecorderButton *flashButton;
@property (nonatomic, readonly, strong) NHRecorderButton *gridButton;
@property (nonatomic, readonly, strong) NHRecorderButton *switchButton;

@property (nonatomic, readonly, strong) UIButton *captureButton;
@property (nonatomic, readonly, strong) NHRecorderButton *libraryButton;
@property (nonatomic, readonly, strong) NHRecorderButton *videoCaptureButton;

@property (nonatomic, weak) id<NHPhotoCaptureViewControllerDelegate> nhDelegate;

+ (Class)nhVideoCaptureClass;
+ (Class)nhPhotoEditorClass;
+ (Class)nhMediaPickerClass;

- (void)capturePhoto;
- (void)switchCameraPosition;
- (AVCaptureDevicePosition)cameraPosition;
- (void)switchFlashMode;
- (AVCaptureFlashMode)flashMode;
- (BOOL)flashEnabled;

//+ (Class)nhPhotoCaptureViewClass;
@end
