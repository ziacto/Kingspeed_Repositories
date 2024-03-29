//
//  ArchiveController.h
//  UIShowcase
//
//  Created by Christian Brunschen on 29/05/2008.
//  Modified by Romain Pechayre on 16/11/2010
/*
 * Copyright 2008 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <UIKit/UIKit.h>
#import "ModalViewControllerDelegate.h"

@interface HistoryViewController : UITableViewController {
  NSMutableArray *scans;
  NSMutableArray *results;
  NSDateFormatter *dateFormatter;
  id<ModalViewControllerDelegate> delegate;
}

@property (nonatomic, retain) NSMutableArray *scans;
@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic, assign) id<ModalViewControllerDelegate> delegate;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

- (NSInteger)scanIndexForRow:(NSInteger)row;

@end
