//
//  Game.m
//  AppScaffold
//

#import "Game.h" 

static SPTextureAtlas* ATLAS = nil;

@implementation Game

- (id)initWithWidth:(float)width height:(float)height
{
    if ((self = [super initWithWidth:width height:height]))
    {
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

+(void)releaseATLAS {
    [ATLAS release];
    ATLAS = nil;
}

- (void) onEnterFrame:(SPEnterFrameEvent*) event {
    [mMainMenu advanceTime:event.passedTime];
}

@end
