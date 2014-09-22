//
//  ViewController.m
//  Barcodes2Go
//
//  Created by Camden Narzt on 2014-09-22.
//  Copyright (c) 2014 Camden Narzt. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation;

@interface ViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (strong) AVCaptureSession *captureSession;

@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
    if(videoInput){
        [self.captureSession addInput:videoInput];

        AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [self.captureSession addOutput:metadataOutput];
        NSArray* list = [metadataOutput availableMetadataObjectTypes];
        if (list.count > 0) {
            [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            [metadataOutput setMetadataObjectTypes:list];

            AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
            previewLayer.frame = self.view.layer.bounds;
            [self.view.layer addSublayer:previewLayer];

            [self.captureSession startRunning];
        } else {
            NSLog(@"Error: no supported barcode types");
        }
    }else{
        NSLog(@"Error: %@", error);
    }
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for(AVMetadataMachineReadableCodeObject *metadataObject in metadataObjects)
    {
        NSLog(@"Barcode = %@", metadataObject.stringValue);
        NSLog(@"Type = %@", metadataObject.type);

// CGRect highlightViewRect = CGRectZero;
// AVMetadataMachineReadableCodeObject *barCodeObject = (AVMetadataMachineReadableCodeObject *)[self.preview transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
//        highlightViewRect = barCodeObject.bounds;
//        self.highlightView.frame = highlightViewRect;
//        [self.captureSession stopRunning];
    }
}

@end
