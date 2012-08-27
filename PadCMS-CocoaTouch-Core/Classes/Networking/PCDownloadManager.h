//
//  PCDownloadManager.h
//  Pad CMS
//
//  Created by Alexey Igoshev on 4/30/12.
//  Copyright (c) PadCMS (http://www.padcms.net)
//
//
//  This software is governed by the CeCILL-C  license under French law and
//  abiding by the rules of distribution of free software.  You can  use,
//  modify and/ or redistribute the software under the terms of the CeCILL-C
//  license as circulated by CEA, CNRS and INRIA at the following URL
//  "http://www.cecill.info".
//  
//  As a counterpart to the access to the source code and  rights to copy,
//  modify and redistribute granted by the license, users are provided only
//  with a limited warranty  and the software's author,  the holder of the
//  economic rights,  and the successive licensors  have only  limited
//  liability.
//  
//  In this respect, the user's attention is drawn to the risks associated
//  with loading,  using,  modifying and/or developing or reproducing the
//  software by the user in light of its specific status of free software,
//  that may mean  that it is complicated to manipulate,  and  that  also
//  therefore means  that it is reserved for developers  and  experienced
//  professionals having in-depth computer knowledge. Users are therefore
//  encouraged to load and test the software's suitability as regards their
//  requirements in conditions enabling the security of their systems and/or
//  data to be ensured and,  more generally, to use and operate it in the
//  same conditions as regards security.
//  
//  The fact that you are presently reading this means that you have had
//  knowledge of the CeCILL-C license and that you accept its terms.
//

#import <Foundation/Foundation.h>


PADCMS_EXTERN NSString* primaryKey;
PADCMS_EXTERN NSString* secondaryKey;


typedef enum _ItemType {
  PAGE = 0,
  VERTICAL_TOC  = 1,
  VERTICAL_HELP= 2,
  HORIZONTAL_HELP = 3,
  HORIZONTAL_TOC = 4,
  THUMBNAIL = 5,
	HORIZONTAL_SCROLLING_PANE = 6,
	TILED = 7
} ItemType;

@class PCRevision;

@interface PCDownloadManager : NSObject

@property(retain) PCRevision* revision;
@property(retain) NSMutableDictionary* operationsDic;
@property(retain) NSMutableArray* portraiteTocOperations;
@property(retain) NSMutableDictionary* helpOperations;
@property(retain) NSMutableDictionary* horizontalPageOperations;
@property(retain) NSMutableArray* horizontalTocOperations;
@property (nonatomic) dispatch_queue_t callbackQueue;
@property BOOL isReady;

+ (PCDownloadManager *)sharedManager;

-(void)startDownloading;

-(void)cancelAllOperations;

-(BOOL)prepareForDownloading;

-(void)launchCoverPageDownloading;


@end
