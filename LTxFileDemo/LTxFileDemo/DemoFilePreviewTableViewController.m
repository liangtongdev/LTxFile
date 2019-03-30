//
//  DemoFilePreviewTableViewController.m
//  LTxFileDemo
//
//  Created by liangtong on 2019/3/29.
//  Copyright © 2019 LIANGTONG. All rights reserved.
//

#import "DemoFilePreviewTableViewController.h"
#import <LTxFile/LTxFile.h>

@interface DemoFilePreviewTableViewController ()

@end

@implementation DemoFilePreviewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* identifier = cell.reuseIdentifier;
    
    LTxFilePreviewViewController* previewVC = [[LTxFilePreviewViewController alloc] init];
    if ([identifier isEqualToString:@"local pdf file"]) {
        previewVC.filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"filePreview_local" ofType:@"pdf"]];
    }else if ([identifier isEqualToString:@"local video"]) {
        previewVC.filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"filePreview_local" ofType:@"MOV"]];
    }else if ([identifier isEqualToString:@"local html"]) {
        previewVC.filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"filePreview_local" ofType:@"html"]];
    }else if ([identifier isEqualToString:@"cache online pdf"]) {
        previewVC.fileURL = [NSURL URLWithString:@"https://developer.apple.com/ibeacon/Getting-Started-with-iBeacon.pdf"];
        previewVC.useCache = true;
        previewVC.pathInSandbox = @"Library/Caches";
    }else if ([identifier isEqualToString:@"cache online video"]) {
        previewVC.fileURL = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
        previewVC.useCache = true;
        previewVC.pathInSandbox = @"Library/Caches";
    }else if ([identifier isEqualToString:@"cache online html"]) {
        previewVC.fileURL = [NSURL URLWithString:@"http://www.liangtong.site/about/index.html"];
        previewVC.useCache = true;
        previewVC.pathInSandbox = @"Library/Caches";
    }else if ([identifier isEqualToString:@"online pdf"]) {
        previewVC.fileURL = [NSURL URLWithString:@"https://developer.apple.com/ibeacon/Getting-Started-with-iBeacon.pdf"];
    }else if ([identifier isEqualToString:@"online video"]) {
        previewVC.fileURL = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    }else if ([identifier isEqualToString:@"online html"]) {
        previewVC.fileURL = [NSURL URLWithString:@"https://www.github.com/"];
    }else if ([identifier isEqualToString:@"open with other"]) {
        previewVC.filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"filePreview_local" ofType:@"pdf"]];
        previewVC.shareWithOtherApp = true;
        previewVC.shareBtnTextColor = [UIColor brownColor];
    }
    
    previewVC.title = [identifier uppercaseString];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:previewVC animated:true];
    });
}


@end
