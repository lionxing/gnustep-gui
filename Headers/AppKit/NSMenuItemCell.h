/* 
   NSMenuItemCell.h

   Copyright (C) 1996 Free Software Foundation, Inc.

   Author:  Michael Hanni <mhanni@sprintmail.com>
   Date: June 1999
   
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

#ifndef _GNUstep_H_NSMenuItemCell
#define _GNUstep_H_NSMenuItemCell

#include <AppKit/NSActionCell.h>
#include <AppKit/NSButtonCell.h>
#include <AppKit/NSMenuItem.h>

@class NSMenuView;

typedef void (*DrawingIMP)(id, SEL, NSRect, NSView*);

@interface NSMenuItemCell : NSButtonCell <NSCopying, NSCoding>
{
  NSMenuItem *_menuItem;
  NSMenuView *_menuView;

  // Cache
  BOOL _needs_sizing;
  float _imageWidth;
  float _titleWidth;
  float _keyEquivalentWidth;
  float _stateImageWidth;
  float _menuItemHeight;

  NSImage *_imageToDisplay;
  NSString *_titleToDisplay;
  NSSize _imageSize;

  /* If we belong to a popupbutton, we display image on the extreme
     right */
  BOOL _mcell_belongs_to_popupbutton;

@private
  NSColor *_backgroundColor;
}

- (void)setHighlighted:(BOOL)flag;
- (BOOL)isHighlighted;

- (void)setMenuItem:(NSMenuItem *)item;
- (NSMenuItem *)menuItem;

- (void)setMenuView:(NSMenuView *)menuView;
- (NSMenuView *)menuView;

- (void)calcSize;
- (void)setNeedsSizing:(BOOL)flag;
- (BOOL)needsSizing;

- (float)imageWidth;
- (float)titleWidth;
- (float)keyEquivalentWidth;
- (float)stateImageWidth;

- (NSRect)imageRectForBounds:(NSRect)cellFrame;
- (NSRect)keyEquivalentRectForBounds:(NSRect)cellFrame;
- (NSRect)stateImageRectForBounds:(NSRect)cellFrame;
- (NSRect)titleRectForBounds:(NSRect)cellFrame;

- (void)drawBorderAndBackgroundWithFrame:(NSRect)cellFrame
                                  inView:(NSView *)controlView;
- (void)drawImageWithFrame:(NSRect)cellFrame
                    inView:(NSView *)controlView;
- (void)drawKeyEquivalentWithFrame:(NSRect)cellFrame
                            inView:(NSView *)controlView;
- (void)drawSeparatorItemWithFrame:(NSRect)cellFrame
                            inView:(NSView *)controlView;
- (void)drawStateImageWithFrame:(NSRect)cellFrame   
                         inView:(NSView *)controlView;
- (void)drawTitleWithFrame:(NSRect)cellFrame
                    inView:(NSView *)controlView;
@end

#endif