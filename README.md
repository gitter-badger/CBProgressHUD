# CBProgressHUD

![Image_1](https://github.com/cbangchen/CBProgressHUD/blob/master/Resources/CBProgress_1.png)
![Image_2](https://github.com/cbangchen/CBProgressHUD/blob/master/Resources/CBProgress_2.png)
![Image_3](https://github.com/cbangchen/CBProgressHUD/blob/master/Resources/CBProgress_3.png)
![Image_4](https://github.com/cbangchen/CBProgressHUD/blob/master/Resources/CBProgress_4.png)
![Image_5](https://github.com/cbangchen/CBProgressHUD/blob/master/Resources/CBProgress_5.png)


[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/cbangchen/CBNetworking#)[![MIT Licence](https://badges.frapsoft.com/os/mit/mit.svg?v=102)](https://opensource.org/licenses/mit-license.php)[![Open Source Love](https://badges.frapsoft.com/os/v2/open-source.svg?v=102)](https://github.com/ellerbrock/open-source-badge/) 

## Installation with CocoaPods

CocoaPods is a dependency manager for Objective-C

### Podfile

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '7.0'

pod 'CBProgressHUD', '~> 1.0.0'
```
Then, **cd** you directory and  run the following command:

```
$ pod install
```

### Mode

**Only Text**
- CBProgressHUDModeText   

**ActivityIndicatorView(Text)**
- CBProgressHUDModeIndeterminate 

**ProgressView(Text)**
- CBProgressHUDModeAnnularDeterminate 

### Basic Usage

#### Show A HUD View With One Single Line Code

```
+ (instancetype)showHUDAddedTo:(UIView *)view
                          mode:(CBProgressHUDMode)mode
                          text:(NSString *)text
                      animated:(BOOL)animated;
```

#### Hide All HUDs For A View With One Single Line Code

```
+ (void)hideHUDForView:(UIView *)view
              animated:(BOOL)animated;
```

#### Hide A HUD View With A Single Line Code 

```
- (void)hideAnimated:(BOOL)animated;
```

#### Hide A HUD View With Another Single Line Code 

```
- (void)hideAnimated:(BOOL)animated
          afterDelay:(NSTimeInterval)delay;
```
