//
//  AppDelegate.h
//  Encoder
//
//  Created by Matt Long on 3/1/12.
//  Copyright (c) 2012 Skye Road Systems, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSTextField *videoInputFilePathLabel;
@property (weak) IBOutlet NSTextField *htmlOutputFilePathLabel;
@property (weak) IBOutlet NSTextField *videoOutputFilePathLabel;
@property (weak) IBOutlet NSTextField *htmlInputFilePathLabel;

@property (copy) NSString *videoInputFilePath;
@property (copy) NSString *htmlOutputFilePath;
@property (copy) NSString *videoOutputFilePath;
@property (copy) NSString *htmlInputFilePath;

- (void)updateLabels;


@end
