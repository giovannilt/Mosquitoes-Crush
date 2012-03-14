//
//  Game.m
//  AppScaffold
//

#import "Game.h" 

static SPTextureAtlas* ATLAS = nil;
static NSString* ATW_REGULAR = nil;
static NSString* ATW_BOLD = nil;
static NSString* MF_THIN = nil;

@implementation Game

- (id)initWithWidth:(float)width height:(float)height
{
    if ((self = [super initWithWidth:width height:height]))
    {
        ATW_BOLD = [SPTextField registerBitmapFontFromFile:@"atwbold.fnt"];
        ATW_REGULAR = [SPTextField registerBitmapFontFromFile:@"atwregular.fnt"];
        MF_THIN = [SPTextField registerBitmapFontFromFile:@"mf.fnt"];
        
        mMainMenu = [[MainMenu alloc] initWithWidth:width andHeight:height];
        [self addChild:mMainMenu];
        [mMainMenu release];
         
        [self addEventListener:@selector(onEnterFrame:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    }
    return self;
}

+(SPTexture *)texture:(NSString *)name {
    return [ATLAS textureByName:name];
}

+(NSArray *)textures:(NSString *)name {
    return [ATLAS texturesStartingWith:name];
}

+(void)initATLAS {
    ATLAS = [[SPTextureAtlas atlasWithContentsOfFile:@"atlas.xml"] retain];
}

+(NSString *)fontMF {
    return MF_THIN;
}

+(NSString *)fontATWR {
    return ATW_REGULAR;
}

+(NSString *)fontATWB {
    return ATW_BOLD;
}

+(void)releaseATLAS {
    [ATLAS release];
    ATLAS = nil;
}

- (void) onEnterFrame:(SPEnterFrameEvent*) event {
    [mMainMenu advanceTime:event.passedTime];
}

@end
