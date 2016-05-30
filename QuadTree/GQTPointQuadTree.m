#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "GQTPointQuadTree.h"
#import "GQTPointQuadTreeChild.h"

@implementation GQTPointQuadTree {
  /**
   * The Quad Tree data structure.
   */
  GQTPointQuadTreeChild *root_;

  /**
   * The number of items in this tree.
   */
  NSUInteger count_;
}


- (id)initWithBounds:(GQTBounds)bounds {
  if (self = [super init]) {
    _bounds = bounds;
    [self clear];
  }
  return self;
}

- (id)init {
  return [self initWithBounds:(GQTBounds){-1, -1, 1, 1}];
}

- (BOOL)add:(id<GQTPointQuadTreeItem>)item {
  if (item == nil) {
    // Item must not be nil.
    return NO;
  }

  GQTPoint point = item.point;
  if (point.x > _bounds.maxX ||
      point.x < _bounds.minX ||
      point.y > _bounds.maxY ||
      point.y < _bounds.minY) {
    return NO;
  }

  [root_ add:item withOwnBounds:_bounds atDepth:0];

  ++count_;

  return YES;
}

/**
 * Delete an item from this PointQuadTree
 *
 * @param item The item to delete.
 */
- (BOOL)remove:(id<GQTPointQuadTreeItem>)item {
  GQTPoint point = item.point;
  if (point.x > _bounds.maxX ||
      point.x < _bounds.minX ||
      point.y > _bounds.maxY ||
      point.y < _bounds.minY) {
    return NO;
  }

  BOOL removed = [root_ remove:item withOwnBounds:_bounds];

  if (removed) {
    --count_;
  }

  return removed;
}

/**
 * Delete all items from this PointQuadTree
 */
- (void)clear {
  root_ = [[GQTPointQuadTreeChild alloc] init];
  count_ = 0;
}

/**
 * Retreive all items in this PointQuadTree within a bounding box.
 *
 * @param searchBounds The bounds of the search box.
 */
- (NSArray *)searchWithBounds:(GQTBounds)searchBounds {

  NSMutableArray *results = [NSMutableArray array];
  [root_ searchWithBounds:searchBounds withOwnBounds:_bounds results:results];
  return results;
}

- (NSUInteger)count {
  return count_;
}

@end
