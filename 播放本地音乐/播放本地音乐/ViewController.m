//
//  ViewController.m
//  播放本地音乐
//
//  Created by 周强 on 16/3/4.
//  Copyright © 2016年 周强. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVAudioPlayerDelegate>
@property (nonatomic,strong)NSMutableArray  *musicListArr;//存放本地歌曲文件名称
@property (nonatomic,assign)NSInteger    currentIndex;//当前歌曲

@property(nonatomic,strong)AVAudioPlayer *player;

@property(nonatomic,assign)UIBackgroundTaskIdentifier oldTaskId;

@end

@implementation ViewController
-(NSMutableArray *)musicListArr
{
    if (!_musicListArr) {
        _musicListArr=[NSMutableArray arrayWithObjects:@"匆匆那年.mp3",@"李白.mp3",@"平凡之路.mp3",@"月半小夜曲.mp3",@"模特.mp3", nil];
    }
    return _musicListArr;

}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
-(void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        
        switch (event.subtype) {
                
            //暂停
            case UIEventSubtypeRemoteControlPause:
                NSLog(@"pause");
                [self pauseMusicAction:nil];
                break;
            //播放
            case UIEventSubtypeRemoteControlPlay:
                NSLog(@"play");
                [self playMusicAction:nil];
                break;
             //上一首
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"previous");
                [self lastMusicAction:nil];
                break;
             //下一首
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"next");
                [self nextMusicAction:nil];
                break;
                
            default:
                break;  
        }  
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _currentIndex=0;
    
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    
    UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    
    if (newTaskId != UIBackgroundTaskInvalid && _oldTaskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask: _oldTaskId];}
    
    _oldTaskId = newTaskId;
}

//上一首歌
- (IBAction)lastMusicAction:(UIButton *)sender {
   
    if (_player) {
        
        [_player stop];
        _player.delegate=nil;
        _player = nil;
        
        if (_currentIndex>0) {
            _currentIndex--;
            NSURL *url=[[NSBundle mainBundle]URLForResource:self.musicListArr[_currentIndex] withExtension:nil];
            _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            _player.delegate = self;
             [_player prepareToPlay];
            
            [_player play];
        }
        
        
    } else {
        NSURL *url=[[NSBundle mainBundle]URLForResource:self.musicListArr[_currentIndex] withExtension:nil];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        _player.delegate = self;
         [_player prepareToPlay];
        [_player play];
    }
    
}
//播放
- (IBAction)playMusicAction:(UIButton *)sender {
  
    if (_player) {
        [_player play];
        
    } else {
        NSURL *url=[[NSBundle mainBundle]URLForResource:self.musicListArr[_currentIndex] withExtension:nil];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        _player.delegate = self;
        [_player prepareToPlay];
        [_player play];
    }
    
    
}

//暂停
- (IBAction)pauseMusicAction:(id)sender {
    
    [_player pause];
}
//下一首
- (IBAction)nextMusicAction:(UIButton *)sender {

    if (_player) {
        
        [_player stop];
        _player.delegate=nil;
        _player = nil;
        
        if (_currentIndex<self.musicListArr.count-1) {
            _currentIndex++;
            NSURL *url=[[NSBundle mainBundle]URLForResource:self.musicListArr[_currentIndex] withExtension:nil];
            _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            _player.delegate = self;
             [_player prepareToPlay];
            [_player play];
        }
        
        
    } else {
        NSURL *url=[[NSBundle mainBundle]URLForResource:self.musicListArr[_currentIndex] withExtension:nil];
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        _player.delegate = self;
         [_player prepareToPlay];
        [_player play];
    }
    
    
}
#pragma mark Delegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
   
    
    if (flag) {
        if (_currentIndex < [self.musicListArr count] - 1) {
            _currentIndex ++;
            if (_player) {
                [_player stop];
                _player.delegate=nil;
                _player = nil;
            }
            NSURL *url=[[NSBundle mainBundle]URLForResource:self.musicListArr[_currentIndex] withExtension:nil];
            _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            _player.delegate = self;
             [_player prepareToPlay];
            [_player play];
        }
    }
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"occur");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
