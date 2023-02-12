#import <UIKit/UIKit.h>

static bool kEnabled = NO;
static bool kRotatedAppLibrary = NO;
static bool kKeepEmptyFolders = NO;
static bool kNoAppLibrary = NO;
static bool kDontSplitRotatedFolders = NO;

/*
//This interface isnt needed for anything in the project, I was just copying some 
//of the methods that seemed interesting or could be helpful in updating other tweaks.

@interface SBFolder : NSObject
- (bool)isAllowedToContainIcon:(id)arg1;
- (bool)isAllowedToContainIcons:(id)arg1;
- (bool)isCancelable;
- (bool)isEmpty;
- (bool)isExtraList:(id)arg1;
- (bool)isExtraListIndex:(unsigned long long)arg1;
- (bool)isFull;
- (bool)isIconStateDirty;
- (bool)isLibraryCategoryFolder;
- (bool)isRootFolder;
- (bool)listsAllowRotatedLayout;
@end
*/

%hook SBIconController
-(bool)isAppLibraryAllowed {
if(kEnabled &&  kNoAppLibrary) {
    return 0;
}
else if(kEnabled && kRotatedAppLibrary && !kNoAppLibrary) {
return 1;
}
else {
return %orig;
     }
}

-(bool)isAppLibrarySupported {
if(kEnabled &&  kNoAppLibrary) {
    return 0;
}
else if(kEnabled && kRotatedAppLibrary && !kNoAppLibrary) {
return 1;
}
else {
return %orig;
      }
}

%end

%hook SBFolder
-(bool)shouldRemoveWhenEmpty {
if(kEnabled && kKeepEmptyFolders){
return NO;
}
return %orig;
}
//These methods will prevent the folders from disappearing when the icons are removed, but the empty folder icons
//Will disappear after reboots and safe node crashes if a tweak like icon Support/ icon state / icon anus etc is not used.

-(bool)isEmpty {
if(kEnabled && kKeepEmptyFolders) {
return NO;
}
return %orig;
}
//Rotated app library not working yet, need to research and test more
- (bool)listsAllowRotatedLayout {
if(kEnabled && kRotatedAppLibrary) {
return YES;
}
return %orig;
}

- (void)setListsAllowRotatedLayout:(bool)arg1 {
if(kEnabled && kRotatedAppLibrary) {
arg1 =1;
return %orig(arg1);
}
return %orig(arg1);
}

%end

//Keep folders how they were in lower iOS versions when rotating them, as one multi-page folder.
%hook SBFloatyFolderControllerConfiguration
-(BOOL)displaysMultipleIconListsInLandscapeOrientation {
    if(kEnabled && kDontSplitRotatedFolders) {
        return 0;
    }
    return %orig;
}

-(void)setDisplaysMultipleIconListsInLandscapeOrientation {
    if(kEnabled && kDontSplitRotatedFolders) {
        arg1=0;
        return %orig(arg1);
    }
    return %orig(arg1);
}
%end



/*
//was just curious if this can be helpful in customizing the APP Lbibrary, not using it yet for anything
%hook SBHAppLibrarySettings
-(unsigned long long)minimumNumberOfIconsToShowSectionHeaderInDeweySearch {
return %orig;
}

-(void)setMinimumNumberOfIconsToShowSectionHeaderInDeweySearch:(unsigned long long)arg1 {
return %orig(arg1);
}
%end
*/

//handle prefs with user defaults

static void
loadPrefs() {
    static NSUserDefaults *prefs = [[NSUserDefaults alloc]
                                    initWithSuiteName:@"com.i0stweak3r.byebyeapplibrary"];
    kEnabled = [prefs boolForKey:@"enabled"] ? [prefs boolForKey:@"enabled"] : NO;
     kNoAppLibrary = [prefs boolForKey:@"noAppLibrary"] ? [prefs boolForKey:@"noAppLibrary"] : NO;
    kRotatedAppLibrary = [prefs boolForKey:@"rotatedAppLibrary"] ? [prefs boolForKey:@"rotatedAppLibrary"] : NO;
   kKeepEmptyFolders = [prefs boolForKey:@"keepEmptyFolders"]; 
   kDontSplitRotatedFolders = [[prefs objectForKey:@"dontSplitRotatedFolders"]boolValue] ? [prefs boolForKey:@"dontSplitRotatedFolders"] : NO;
    }


%ctor {
    CFNotificationCenterAddObserver(
                                    CFNotificationCenterGetDarwinNotifyCenter(), NULL,
                                    (CFNotificationCallback)loadPrefs,
                                    CFSTR("com.i0stweak3r.byebyeapplibrary/saved"), NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    loadPrefs();

}