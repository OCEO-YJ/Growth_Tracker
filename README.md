# Growth Tracker iOS demo Version

## This is an iOS app for tracking baby's growth curve

## Installation

If it is your first to install this app on your computer, Do the following:
- Install the remaining dependencies by running `pod install`. If pod is not installed on your computer, please run `sudo gem install cocoapods` before you do `pod install`.

Please follow these steps to run the App properly:
- Open `workspace` instead of `xcode project`.
- From the root project folder, find the path of the `Eigen` and run the chmod.
  Please run this command on your terminal: `chmod -R 755 ./Aruco/3rdparty/eigen3/Eigen`
- Download OpenCV 3.4.7 (Recommended) or 4.1.1 (iOS pack) from [here](https://opencv.org/releases.html).
- After download the openCV library, open the sidebar of Xcode (navigation), drag the `opencv2.framework` file under the `frameworks` folder in Xcode. Select `Add folders` -> Create Folder References and `Destination` -> Copy items if needed. and `Add to Target` -> GrowthTracker.  
- Remove `Aruco` folder through the Xcode, but do not click `move to trash`.
  - After remove the folder, then drag `Aruco` folder in the root project into Xcode directly. Select `Add folders` -> Create groups and `Destination` -> Copy items if needed. and `Add to Target` -> GrowthTracker.
- Go to the `build phases` in the setting, then go to `Copy Bundle Resoruces` and keep 5 files as below
  - `camera_parameter.yml`
  - `Main.storyboard`
  - `GoogleService-info.plist`
  - `LaunchScreen.storyboard`
  - `Assets.xcassets`

- OPTIONAL: If `camera_parameter.yml` in the Resources folder is written as binary code, then remove `camera_parameter.yml` folder through the Xcode, but do not click `move to trash`, but `remove reference`.
  - After remove the file, go to the this link [here](https://drive.google.com/file/d/101spzaRg28DmzttGntuv9rruakv3o-HG/view?usp=sharing) and download the yml file.
  - After you download the yml file, then drag into the `Resources` folder and replaced with old one.

- OPTIONAL: If either `GoogleService-info.plist` cannot be found in the Xcode or `GoogleService-info.plist` cannot be loaded, please open the project root and find the `GoogleService-info.plist` file.
    - Drag it into the `BabyGrowth` folder through Xcode directly.

## Usage

Tutorial for Baby Photo Taking

- STEP1: Place the baby on the weight scale and make sure your baby lay down properly
- STEP2: Place the marker underneath the nipples and above the belly button. Make sure the marker is placed flatlyand visible. Please make sure the rotation of the marker
- STEP3: Make sure the belly button, nipples, shoulders, eyes, ears are clearly visible.
- STEP4: Make sure the limbs and hands are laid down.
- STEP5: Take the picture, and please make your lens as parallel as possibleto your baby

## Requirements

- Xcode 9.0
- iOS 10.0 or above

## Contributing

## License

This project is released under the MIT license. See `LICENSE` for more information.
