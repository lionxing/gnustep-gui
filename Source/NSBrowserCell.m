/*
   NSBrowserCell.m

   Cell class for the NSBrowser

   Copyright (C) 1996, 1997, 1999 Free Software Foundation, Inc.

   Author:  Scott Christley <scottc@net-community.com>
   Date: 1996
   
   Author: Nicola Pero <n.pero@mi.flashnet.it>
   Date: December 1999

   This file is part of the GNUstep GUI Library.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Library General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU Library General Public
   License along with this library; see the file COPYING.LIB.
   If not, write to the Free Software Foundation,
   59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*/

#include <gnustep/gui/config.h>

#include <AppKit/NSBrowserCell.h>
#include <AppKit/NSColor.h>
#include <AppKit/NSFont.h>
#include <AppKit/NSImage.h>
#include <AppKit/NSGraphics.h>
#include <AppKit/NSEvent.h>
#include <AppKit/NSWindow.h>

/*
 * Class variables
 */
static NSImage	*_branch_image;
static NSImage	*_highlight_image;

static Class	_colorClass;

static NSFont *_userDefaultFont;

// GNUstep user default to have NSBrowserCell in bold if non leaf
static BOOL _gsFontifyCells = NO;
static NSFont *_nonLeafFont;
static NSFont *_leafFont;

@implementation NSBrowserCell

/*
 * Class methods
 */
+ (void) initialize
{
  if (self == [NSBrowserCell class])
    {
      [self setVersion: 1];
      ASSIGN(_branch_image, [NSImage imageNamed: @"common_3DArrowRight"]);
      ASSIGN(_highlight_image, [NSImage imageNamed: @"common_3DArrowRightH"]);

      ASSIGN (_userDefaultFont, [NSFont userFontOfSize: 0]);
      /*
       * Cache classes to avoid overheads of poor compiler implementation.
       */
      _colorClass = [NSColor class];
      
      // A GNUstep experimental feature
      if ([[NSUserDefaults standardUserDefaults] 
	    boolForKey: @"GSBrowserCellFontify"])
	{
	  _gsFontifyCells = YES;
	  _nonLeafFont = RETAIN ([NSFont boldSystemFontOfSize: 0]);
	  _leafFont = RETAIN ([NSFont systemFontOfSize: 0]);
	}
    }
}

/*
 * Accessing Graphic Attributes
 */
+ (NSImage*) branchImage
{
  return _branch_image;
}

+ (NSImage*) highlightedBranchImage
{
  return _highlight_image;
}

/*
 * Instance methods
 */
- (id) initTextCell: (NSString *)aString
{
  _cell.type = NSTextCellType;
  _cell_font = RETAIN(_userDefaultFont);
  _contents = RETAIN(aString);
  _cell.float_autorange = YES;
  _cell_float_right = 6;
  _action_mask = NSLeftMouseUpMask;
  
  // Implicitly performed by allocation: 
  //
  //_cell_image = nil;
  //_cell.image_position = NSNoImage;
  //_cell.state = 0;
  //_cell.is_disabled = NO;
  //_cell.is_highlighted = NO;
  //_cell.is_editable = NO;
  //_cell.is_bordered = NO;
  //_cell.is_bezeled = NO;
  //_cell.is_scrollable = NO;
  //_cell.is_selectable = NO;
  //_cell.is_continuous = NO;
  //_cell_float_left = 0;
  //_cell.text_align = NSLeftTextAlignment;
  //_alternateImage = nil;
  //_browsercell_is_leaf = NO; 
  //_browsercell_is_loaded = NO;

  if (_gsFontifyCells)
    ASSIGN (_cell_font, _nonLeafFont);

  return self;
}

- (id) initImageCell: (NSImage *)anImage
{
  _cell.type = NSImageCellType;
  _cell_image = RETAIN(anImage);
  _cell.image_position = NSImageOnly;
  _cell_font = RETAIN(_userDefaultFont);
  _action_mask = NSLeftMouseUpMask;

  // Implicitly performed by allocation:
  //
  //_cell.is_disabled = NO;
  //_cell.state = 0;
  //_cell.is_highlighted = NO;
  //_cell.is_editable = NO;
  //_cell.is_bordered = NO;
  //_cell.is_bezeled = NO;
  //_cell.is_scrollable = NO;
  //_cell.is_selectable = NO;
  //_cell.is_continuous = NO;
  //_cell.float_autorange = NO;
  //_cell_float_left = 0;
  //_cell_float_right = 0;
  //_cell.text_align = NSLeftTextAlignment;
  //_alternateImage = nil;
  //_browsercell_is_leaf = NO; 
  //_browsercell_is_loaded = NO;

  if (_gsFontifyCells)
    ASSIGN (_cell_font, _nonLeafFont);
  
  return self;
}


- (void) dealloc
{
  TEST_RELEASE(_alternateImage);

  [super dealloc];
}

- (id) copyWithZone: (NSZone*)zone
{
  NSBrowserCell	*c = [super copyWithZone: zone];

  if (_alternateImage)
    c->_alternateImage = RETAIN(_alternateImage);
  c->_browsercell_is_leaf = _browsercell_is_leaf;
  c->_browsercell_is_loaded = _browsercell_is_loaded;

  return c;
}

/*
 * Accessing Graphic Attributes
 */
- (NSImage*) alternateImage
{
  return _alternateImage;
}

- (void) setAlternateImage: (NSImage *)anImage
{
  ASSIGN(_alternateImage, anImage);
}

/*
 * Placing in the Browser Hierarchy
 */
- (BOOL) isLeaf
{
  return _browsercell_is_leaf;
}

- (void) setLeaf: (BOOL)flag
{
  if (_browsercell_is_leaf == flag)
    return;

  _browsercell_is_leaf = flag;
  
  if (_gsFontifyCells)
    {
      if (_browsercell_is_leaf)
	{
	  ASSIGN (_cell_font, _leafFont);
	}
      else 
	{
	  ASSIGN (_cell_font, _nonLeafFont);
	}
    }
}

/*
 * Determining Loaded Status
 */
- (BOOL) isLoaded
{
  return _browsercell_is_loaded;
}

- (void) setLoaded: (BOOL)flag
{
  _browsercell_is_loaded = flag;
}

/*
 * Setting State
 */
- (void) reset
{
  _cell.is_highlighted = NO;
  _cell.state = NO;
}

- (void) set
{
  _cell.is_highlighted = YES;
  _cell.state = YES;
}

/*
 * Displaying
 */
- (void) drawInteriorWithFrame: (NSRect)cellFrame inView: (NSView *)controlView
{
  NSRect	title_rect = cellFrame;
  NSImage	*image = nil;
  NSColor	*backColor;
  NSWindow      *cvWin = [controlView window];

  if (!cvWin)
    return;

  [controlView lockFocus];

  if (_cell.is_highlighted || _cell.state)
    {
      backColor = [_colorClass selectedControlColor];
      [backColor set];
      if (!_browsercell_is_leaf)
	image = [isa highlightedBranchImage];
    }
  else
    {
      backColor = [cvWin backgroundColor];
      [backColor set];
      if (!_browsercell_is_leaf)
	image = [isa branchImage];
    }
  
  // Clear the background
  NSRectFill(cellFrame);	

  // Draw the branch image if there is one
  if (image) 
    {
      NSRect image_rect;

      image_rect.origin = cellFrame.origin;
      image_rect.size = [image size];
      image_rect.origin.x += cellFrame.size.width - image_rect.size.width - 4.0;
      image_rect.origin.y
	+= (cellFrame.size.height - image_rect.size.height) / 2.0;
      [image setBackgroundColor: backColor];
      /*
       * Images are always drawn with their bottom-left corner at the origin
       * so we must adjust the position to take account of a flipped view.
       */
      if ([controlView isFlipped])
	image_rect.origin.y += image_rect.size.height;
      [image compositeToPoint: image_rect.origin operation: NSCompositeCopy];

      title_rect.size.width -= image_rect.size.width + 8;	
    }
  
  // Draw the body of the cell
  if ((_cell.type == NSImageCellType) 
      && (_cell.is_highlighted || _cell.state)
      && _alternateImage)
    {
      // Draw the alternateImage 
      NSSize size;
      NSPoint position;
      
      size = [_alternateImage size];
      position.x = MAX(NSMidX(title_rect) - (size.width/2.),0.);
      position.y = MAX(NSMidY(title_rect) - (size.height/2.),0.);
      if ([controlView isFlipped])
	position.y += size.height;
      [_alternateImage compositeToPoint: position 
		       operation: NSCompositeCopy];
    }
  else
    {
      // Draw image, or text
      [super drawInteriorWithFrame: title_rect inView: controlView];
    }

  [controlView unlockFocus];
}

- (BOOL) isOpaque
{
  return YES;
}

/*
 * NSCoding protocol
 */
- (void) encodeWithCoder: (NSCoder*)aCoder
{
  BOOL tmp;
  [super encodeWithCoder: aCoder];
  
  tmp = _browsercell_is_leaf;
  [aCoder encodeValueOfObjCType: @encode(BOOL) at: &tmp];
  tmp = _browsercell_is_loaded;
  [aCoder encodeValueOfObjCType: @encode(BOOL) at: &tmp];
  [aCoder encodeObject: _alternateImage];
}

- (id) initWithCoder: (NSCoder*)aDecoder
{
  BOOL tmp;
  [super initWithCoder: aDecoder];

  [aDecoder decodeValueOfObjCType: @encode(BOOL) at: &tmp];
  _browsercell_is_leaf = tmp;
  [aDecoder decodeValueOfObjCType: @encode(BOOL) at: &tmp];
  _browsercell_is_loaded = tmp;
  [aDecoder decodeValueOfObjCType: @encode(id) at: &_alternateImage];

  return self;
}

@end
