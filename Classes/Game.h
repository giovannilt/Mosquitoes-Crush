//
//  Game.h
//  AppScaffold
//

#import <Foundation/Foundation.h>
#import "Playground.h"
#import "MainMenu.h"

@interface Game : SPStage {
    MainMenu* mMainMenu;
}

+ (SPTexture*) texture:(NSString*) name;
+ (NSArray*) textures:(NSString*) name;

+(void) initATLAS;

+(void) releaseATLAS;

+(NSString*) fontATWR;
+(NSString*) fontATWB;
+(NSString*) fontMF;

- (void) onEnterFrame:(SPEnterFrameEvent*) event;
@end
