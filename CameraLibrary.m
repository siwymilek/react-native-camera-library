#import "CameraLibrary.h"
#import <Photos/PHAsset.h>
#import <Photos/PHFetchResult.h>
#import <Photos/PHImageManager.h>
#import <Photos/PHFetchOptions.h>

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation CameraLibrary

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(getPhotos:(NSDictionary *)props callback:(RCTResponseSenderBlock)callback)
{

    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;

    PHFetchResult *allPhotosResult = [PHAsset fetchAssetsWithOptions:options];
    NSMutableArray *collection = [NSMutableArray array];

    PHImageRequestOptions *requestOptionForPhotos = [[PHImageRequestOptions alloc] init];
    requestOptionForPhotos.networkAccessAllowed = YES;
    requestOptionForPhotos.synchronous = YES;

    BOOL nextPage = YES;

    int countObjects = (int)[allPhotosResult count];

    int perPage = 20;
    int page = [[props valueForKey:@"page"] intValue];
    int lastPage = ceil(countObjects/perPage);

    //    int from = (page-1)*perPage;
    //    int to = (page*perPage)-1;
    //    if(to > countObjects) {
    //        to = countObjects;
    //        nextPage = NO;
    //    }

    int from = countObjects-((page-1)*perPage)-1;
    int to = countObjects-(page*perPage);
    if(to < 0) {
        to = 0;
    }

    if(to == 0) {
        nextPage = NO;
    }

    for(int i = from; i >= to; i--) {
        PHAsset *asset = [allPhotosResult objectAtIndex:i];

        __block NSMutableDictionary *item = [NSMutableDictionary dictionary];
        __block BOOL fetched = NO;
        __block NSString *baseThumbnail = nil;
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);

        if([asset mediaType] == 1) {
            //Photo

            [[PHImageManager defaultManager]
             requestImageForAsset:asset
             targetSize:CGSizeMake(80, 80)
             contentMode:PHImageContentModeAspectFill
             options:requestOptionForPhotos
             resultHandler:^(UIImage *result, NSDictionary *info) {

                 NSData *data = UIImagePNGRepresentation(result);
                 NSString *base = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];

                 if(base != nil) {
                     NSString *filename = [asset.localIdentifier substringWithRange:NSMakeRange(0, 36)];
                     NSString *url = [NSString stringWithFormat:@"assets-library://asset/asset.JPG?id=%@&ext=JPG", filename];

                     [item setValue:url forKey:@"url"];
                     [item setValue:base forKey:@"thumbnail"];
                     [item setValue:@"photo" forKey:@"type"];

                     fetched = YES;

//                     [self upload:url];
                 }

                 dispatch_semaphore_signal(sema);
             }];
        } else if([asset mediaType] == 2) {
            // Video

            [[PHImageManager defaultManager]
             requestAVAssetForVideo:asset options:nil
             resultHandler:^(AVAsset * _Nullable result, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {

                 AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:result];
                 gen.appliesPreferredTrackTransform = YES;

                 if(gen) {
                     CMTime time = CMTimeMakeWithSeconds(0.0, 600);
                     NSError *error = nil;
                     CMTime actualTime;

                     CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
                     UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
                     CGImageRelease(image);

                     NSData *data = UIImagePNGRepresentation([self imageWithImage:thumb scaledToSize:CGSizeMake(40, 40)]);
                     NSString *base = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];

                     if(base) {
//                         [item setValue:[NSString stringWithFormat:@"%@", [(AVURLAsset *)result URL]] forKey:@"url"];
                         NSString *filename = [asset.localIdentifier substringWithRange:NSMakeRange(0, 36)];
                         NSString *url = [NSString stringWithFormat:@"assets-library://asset/asset.MOV?id=%@&ext=MOV", filename];
                         NSInteger duration = asset.duration;
                         
                         [item setValue:[NSString stringWithFormat:@"%@", url] forKey:@"url"];
                         [item setValue:base forKey:@"thumbnail"];
                         [item setValue:[NSNumber numberWithInt:duration] forKey:@"duration"];
                         [item setValue:@"video" forKey:@"type"];

                         fetched = YES;
                     }
                 }

                 dispatch_semaphore_signal(sema);
             }];
        }

        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

        if(fetched) {
            [collection addObject:item];
        }
    }

    callback(@[@{
                   @"objects": collection,
                   @"next_page": [NSNumber numberWithBool:nextPage],
                   @"current_page": [NSNumber numberWithInt:page],
                   @"last_page": [NSNumber numberWithInt:lastPage]
                   }]);
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//- (void)upload:(NSString *)filepath {
//    NSURL *assetUrl = [[NSURL alloc] initWithString:filepath];
//    PHFetchResult *collection = [PHAsset fetchAssetsWithALAssetURLs:[NSArray arrayWithObject:assetUrl] options:nil];
//
//    PHImageRequestOptions *requestOptionForPhotos = [[PHImageRequestOptions alloc] init];
//    requestOptionForPhotos.networkAccessAllowed = YES;
//
//    for(PHAsset *asset in collection) {
//        [[PHImageManager defaultManager]
//         requestImageForAsset:asset
//         targetSize:CGSizeMake(80, 80)
//         contentMode:PHImageContentModeAspectFill
//         options:requestOptionForPhotos
//         resultHandler:^(UIImage *result, NSDictionary *info) {
//             if(result) {
//
//             }
//         }];
//    }
//}




@end
