//
//  ArucoWrapper.mm
//  ArucoDemo
//
//  Created by Carlo Rapisarda on 20/06/2018.
//  Copyright © 2018 Carlo Rapisarda. All rights reserved.
//

#import "ArucoWrapper.h"
#import "Utilities.h"

#import <opencv2/imgproc/imgproc.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/core/core.hpp>



#import "aruco.h"



#pragma mark - Constants

ArucoPreviewRotationType const ArucoPreviewRotationTypeNone = -1;
ArucoPreviewRotationType const ArucoPreviewRotationTypeCw90 = cv::ROTATE_90_CLOCKWISE;
ArucoPreviewRotationType const ArucoPreviewRotationTypeCw180 = cv::ROTATE_180;
ArucoPreviewRotationType const ArucoPreviewRotationTypeCw270 = cv::ROTATE_90_COUNTERCLOCKWISE;


#pragma mark - ArucoMarker

@implementation ArucoMarker

-(id _Nullable) initWithCMarker:(aruco::Marker)cmarker {
    if (!(cmarker.isValid() && cmarker.isPoseValid())) {
        return nil;
    } else if (self = [super init]) {
        self.identifier = cmarker.id;
        self.poseRX = cmarker.Rvec.at<float>(0);
        self.poseRY = cmarker.Rvec.at<float>(1);
        self.poseRZ = cmarker.Rvec.at<float>(2);
        self.poseTX = cmarker.Tvec.at<float>(0);
        self.poseTY = cmarker.Tvec.at<float>(1);
        self.poseTZ = cmarker.Tvec.at<float>(2);
        
//        NSLog(@"outside: %f", _poseTX);
    }
    return self;
}

@end


#pragma mark - ArucoTracker

@interface ArucoTracker()
@property std::map<uint32_t, aruco::MarkerPoseTracker> *mapOfTrackers;
@property aruco::MarkerPoseTracker *tracker;
@property aruco::MarkerDetector *detector;
@property aruco::CameraParameters *camParams;
@property CIContext *ciContext;
@property BOOL setupDone;
@end

@implementation ArucoTracker

-(id _Nonnull) initWithCalibrationFile:(NSString *_Nonnull)calibrationFilepath delegate:(_Nonnull id<ArucoTrackerDelegate>)delegate {
    if (self = [super init]) {
        self.mapOfTrackers = new std::map<uint32_t, aruco::MarkerPoseTracker>();
        self.tracker = new aruco::MarkerPoseTracker();
        self.detector = new aruco::MarkerDetector();
        self.camParams = new aruco::CameraParameters();
        self.markerSize = 0.04;
        self.outputImages = true;
        self.previewRotation = -1;
        self.ciContext = [[CIContext alloc] init];
        self.setupDone = false;
        self.delegate = delegate;
        [self readCalibration:calibrationFilepath];
    }
    return self;
}

-(void) readCalibration:(NSString *)filepath {
    
    self.camParams->readFromXMLFile([filepath UTF8String]);
}

-(void) prepareForOutput:(AVCaptureVideoDataOutput *)videoOutput orientation:(AVCaptureVideoOrientation)orientation {

    dispatch_queue_t queue = dispatch_queue_create("video-sample-buffer", nil);
    [videoOutput setSampleBufferDelegate:self queue:queue];
    [videoOutput setAlwaysDiscardsLateVideoFrames:true];

    [videoOutput setVideoSettings:@{
        (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)
    }];

    AVCaptureConnection *conn = [videoOutput connectionWithMediaType:AVMediaTypeVideo];

    if (conn.isVideoMirroringSupported && conn.isVideoOrientationSupported) {
        [conn setVideoOrientation:orientation];
    } else {
        [NSException raise:@"DeviceNotSupported" format:@"Device does not support one or more required features"];
    }

    self.setupDone = false;
}

-(bool)isPoseStill:(float)topLength bottomLength:(float)bottomLength rightLength:(float)rightLength leftLength:(float)leftLength threshHold:(float)threshHold {
    
    float ratio_top_right = fabs(topLength / rightLength - 1);
    float ratio_top_bottom = fabs(topLength / bottomLength - 1);
    float ratio_top_left = fabs(topLength / leftLength - 1);
    float ratio_right_bottom = fabs(rightLength / bottomLength - 1);
    float ratio_right_left = fabs(rightLength / leftLength - 1);
    float ratio_bottom_left = fabs(bottomLength / leftLength - 1);

    float average_ratio = (ratio_top_right + ratio_top_bottom + ratio_top_left + ratio_right_bottom + ratio_right_left + ratio_bottom_left) / 6;
    
    if(average_ratio < threshHold){
        return true;
    }else{
        return false;

    }
}

-(void) captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {

    cv::Mat bgraImage = BufferToMat(sampleBuffer);

    cv::Mat colorImage, grayImage;
    cv::cvtColor(bgraImage, colorImage, cv::COLOR_BGRA2RGB);
    cv::cvtColor(colorImage, grayImage, cv::COLOR_RGB2GRAY);

    
    if (!self.setupDone) {
        self.camParams->CamSize = colorImage.size();
        self.setupDone = true;
    }

    auto mapOfTrackers = *self.mapOfTrackers;
    bool hasValidCamParams = self.camParams->isValid();
    std::vector<aruco::Marker> markers = self.detector->detect(grayImage, *self.camParams, self.markerSize);

    
    NSMutableArray *result = [NSMutableArray new];

    for (auto& m : markers) {
        mapOfTrackers[m.id].estimatePose(m, *self.camParams, self.markerSize);
        ArucoMarker *markerObj = [[ArucoMarker alloc] initWithCMarker:m];
        if (markerObj != nil) [result addObject:markerObj];
    }

    UIImage *preview = nil;
    
    bool isposeStill = false;
    
    
    if (self.outputImages) {

        for (auto& m : markers) {
            

            float leftTop_x = m[0].x;
            float leftTop_y = m[0].y;

            float rigthTop_x = m[1].x;
            float rigthTop_y = m[1].y;

            float rightBottom_x = m[2].x;
            float rightBottom_y = m[2].y;

            float leftBottom_x = m[3].x;
            float leftBottom_y = m[3].y;
            
            float top_length = rigthTop_x - leftTop_x;
            float right_length = rightBottom_y - rigthTop_y;
            float bottom_length = rightBottom_x - leftBottom_x;
            float left_length = leftBottom_y - leftTop_y;


            

            isposeStill = [self isPoseStill:top_length bottomLength:bottom_length rightLength:right_length leftLength:left_length threshHold:0.015];
            
            
            m.draw(colorImage, cv::Scalar(0, 0, 255), 2);
            
            if (hasValidCamParams && m.isPoseValid()) {
                
//                aruco::CvDrawingUtils::draw3dCube(colorImage, m, *self.camParams);
//                aruco::CvDrawingUtils::draw3dAxis(colorImage, m, *self.camParams);
            }
        }


        if (_previewRotation >= 0) {
            cv::rotate(colorImage, colorImage, _previewRotation);
        }

        preview = MatToUIImage(colorImage);
        
    }
    
    [self.delegate arucoTracker:self didDetectMarkers:result preview:preview get:isposeStill];
}

@end


#pragma mark - ArucoGenerator

@interface ArucoGenerator()
@property std::string dictionaryName;
@property aruco::Dictionary dictionary;
@end

@implementation ArucoGenerator

-(id _Nonnull) initWithDictionary:(NSString *_Nonnull)dictionaryName {
    if (self = [super init]) {
        self.dictionaryName = [dictionaryName UTF8String];
        self.dictionary = aruco::Dictionary::load(self.dictionaryName);
        self.enclosingCorners = false;
        self.waterMark = true;
        self.pixelSize = 75;
    }
    return self;
}

-(id _Nonnull) init {
    return [[ArucoGenerator alloc] initWithDictionary:@"ARUCO"];
}

-(UIImage *) generateMarkerImage:(int)markerID {
    cv::Mat markerImage = self.dictionary.getMarkerImage_id(markerID, self.pixelSize, self.waterMark, self.enclosingCorners);
    return MatToUIImage(markerImage);
}

@end


#pragma mark - ArucoDetector

@interface ArucoDetector()
@property aruco::MarkerDetector *detector;
@property aruco::CameraParameters *camParams;
@end

@implementation ArucoDetector

-(id _Nonnull) init {
    if (self = [super init]) {
        self.detector = new aruco::MarkerDetector();
        self.camParams = new aruco::CameraParameters();
        self.markerSize = 0.04;
    }
    return self;
}

-(NSArray<ArucoMarker *> *) detect:(UIImage *)image {
    cv::Mat colorImage, grayImage;
    UIImageToMat(image, colorImage);
    cvtColor(colorImage, grayImage, cv::COLOR_BGR2GRAY);
    std::vector<aruco::Marker> markers = self.detector->detect(grayImage, *self.camParams, self.markerSize);
    NSMutableArray *result = [NSMutableArray new];

    for (auto& m : markers) {
        ArucoMarker *markerObj = [[ArucoMarker alloc] initWithCMarker:m];

        if (markerObj != nil) [result addObject:markerObj];
    }

    return result;
}

-(UIImage *) drawMarkers:(UIImage *)image {

    cv::Mat colorImage, grayImage;
    UIImageToMat(image, colorImage);
    cvtColor(colorImage, grayImage, cv::COLOR_BGR2GRAY);
    std::vector<aruco::Marker> markers = self.detector->detect(grayImage, *self.camParams, self.markerSize);

    for (auto& m : markers) {
        m.draw(colorImage, cv::Scalar(0,0,255), 2);
    }

    return MatToUIImage(colorImage);
}

@end
