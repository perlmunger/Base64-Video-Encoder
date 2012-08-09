//
//  AppDelegate.m
//  Encoder
//
//  Created by Matt Long on 3/1/12.
//  Copyright (c) 2012 Skye Road Systems, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "NSData+Additions.h"
#import "NSString+Additions.h"

@implementation AppDelegate

@synthesize window = _window;


@synthesize videoInputFilePathLabel;
@synthesize htmlOutputFilePathLabel;
@synthesize videoOutputFilePathLabel;
@synthesize htmlInputFilePathLabel;
@synthesize videoInputFilePath;
@synthesize htmlOutputFilePath;
@synthesize videoOutputFilePath;
@synthesize htmlInputFilePath;

static NSString *start = @"<html>"
"<head><title>Video</title></head>"
"<body>"
"<video controls height=\"576\" width=\"1024\" src=\"data:video/mp4;base64,";

static NSString *end = @"\"></video>"
"</body>"
"</html>";

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  
  // Insert code here to initialize your application
}

- (IBAction)didClickChooseInputFileButton:(id)sender
{
  NSOpenPanel *openPanel;
  
  openPanel = [NSOpenPanel openPanel];
  [openPanel setCanChooseDirectories:NO];
  [openPanel setAllowsMultipleSelection:NO];
  [openPanel setResolvesAliases:YES];
  
  if ([openPanel runModal] == NSOKButton) {
    if ([sender tag] == 10000) {
      [self setVideoInputFilePath:[[openPanel URL] path]];
    } else if ([sender tag] == 10002) {
      [self setHtmlInputFilePath:[[openPanel URL] path]];
    }
    [self updateLabels];
  }
}

- (IBAction)didClickChooseOutputFileButton:(id)sender
{
  NSSavePanel *savePanel;

  savePanel = [NSSavePanel savePanel];
  
  if( [savePanel runModal] == NSOKButton) {
    if ([sender tag] == 10001) {
      [self setHtmlOutputFilePath:[[savePanel URL] path]];
    } else if ([sender tag] == 10003) {
      [self setVideoOutputFilePath:[[savePanel URL] path]];
    }
    [self updateLabels];
  }
}

- (IBAction)didClickConvertButton:(id)sender
{
  if ([sender tag] == 10005) {
    if (![self videoInputFilePath] || ![self htmlOutputFilePath] || [[self videoInputFilePath] length] <= 0 || [[self htmlOutputFilePath] length] <= 0)
      return;
    NSData *data = [NSData dataWithContentsOfFile:[self videoInputFilePath]];
    
    NSString *encoded = [data base64String];
    
    NSString *output = [NSString stringWithFormat:@"%@%@%@", start, encoded, end];
    
    NSError *error = nil;
    if (![output writeToFile:[self htmlOutputFilePath] atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
      NSLog(@"Couldn't write file: %@", [error localizedDescription]);
    }
    
  } else if ([sender tag] == 10006) {
    if (![self videoOutputFilePath] || ![self htmlInputFilePath] || [[self videoOutputFilePath] length] <= 0 || [[self htmlInputFilePath] length] <= 0)
      return;
    
    NSError *error = nil;
    NSString *encoded = [NSString stringWithContentsOfFile:[self htmlInputFilePath] encoding:NSUTF8StringEncoding error:&error];

    if (!encoded) {
      NSLog(@"Couldn't load file: %@", [error localizedDescription]);
    }

    // Strip off the html if any
    encoded = [encoded stringByReplacingOccurrencesOfString:start withString:@""];
    encoded = [encoded stringByReplacingOccurrencesOfString:end withString:@""];

    NSData *decoded = [encoded base64Data];

    if (![decoded writeToFile:[self videoOutputFilePath] atomically:YES]) {
      NSLog(@"Couldn't write file");
    }
    
  }
  
}

- (void)updateLabels
{
  [[self videoInputFilePathLabel] setStringValue:[self videoInputFilePath]];
  [[self htmlOutputFilePathLabel] setStringValue:[self htmlOutputFilePath]];
  [[self videoOutputFilePathLabel] setStringValue:[self videoOutputFilePath]];
  [[self htmlInputFilePathLabel] setStringValue:[self htmlInputFilePath]];
}

@end
