#import "KGView.h"


static char kg_drawRectContext;
static char kg_layoutSubviewsContext;


@implementation KGView

////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
////////////////////////////////////////////////////////////////////////

+ (id)viewWithFrame:(CGRect)frame drawingBlock:(kg_draw_block)block {
    KGView *view = [[[self class] alloc] initWithFrame:frame];
    view.drawingBlock = block;
    
    return view;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIView
////////////////////////////////////////////////////////////////////////

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];

    // will be added to view hierarchy
    if (self.superview == nil && newSuperview != nil) {
        NSSet *keyPathsForValuesAffectingDrawRect = [[self class] keyPathsForValuesAffectingDrawRect];
        NSSet *keyPathsForValuesAffectingLayoutSubviews = [[self class] keyPathsForValuesAffectingLayoutSubviews];

        for (NSString *keyPath in keyPathsForValuesAffectingDrawRect) {
            [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:&kg_drawRectContext];
        }

        for (NSString *keyPath in keyPathsForValuesAffectingLayoutSubviews) {
            [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:&kg_layoutSubviewsContext];
        }
    }

    // will be removed from view hierarchy
    else if (self.superview != nil && newSuperview == nil) {
        NSSet *keyPathsForValuesAffectingDrawRect = [[self class] keyPathsForValuesAffectingDrawRect];
        NSSet *keyPathsForValuesAffectingLayoutSubviews = [[self class] keyPathsForValuesAffectingLayoutSubviews];

        for (NSString *keyPath in keyPathsForValuesAffectingDrawRect) {
            [self removeObserver:self forKeyPath:keyPath context:&kg_drawRectContext];
        }

        for (NSString *keyPath in keyPathsForValuesAffectingLayoutSubviews) {
            [self removeObserver:self forKeyPath:keyPath context:&kg_layoutSubviewsContext];
        }
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject
////////////////////////////////////////////////////////////////////////

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &kg_drawRectContext) {
        [object setNeedsDisplay];
    } else if (context == &kg_layoutSubviewsContext) {
        [object setNeedsLayout];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - FKView
////////////////////////////////////////////////////////////////////////

+ (NSSet *)keyPathsForValuesAffectingDrawRect {
    return nil;
}

+ (NSSet *)keyPathsForValuesAffectingLayoutSubviews {
    return nil;
}

////////////////////////////////////////////////////////////////////////
#pragma mark - UIView
////////////////////////////////////////////////////////////////////////

- (void)drawRect:(CGRect)rect {
    if (self.drawingBlock != nil) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSaveGState(context);
        self.drawingBlock(self, context);
        CGContextRestoreGState(context);
    }
}

@end
