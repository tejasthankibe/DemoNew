
#import "Image.h"
@protocol IconDownloaderDelegate;

@interface IconDownloader : NSObject 
{
    NSInteger Key;
    id <IconDownloaderDelegate> delegate;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
    Image *imageRecord;
    NSIndexPath *indexPathInTableView;
    NSString *FileName;
}

@property (nonatomic, strong) Image *imageRecord;
@property (nonatomic, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, strong) NSString *URL;
@property (nonatomic, strong) NSString *FileName;
@property (nonatomic, readwrite) NSInteger Key;
@property (nonatomic, readwrite) int Mode;
@property (nonatomic, strong) id <IconDownloaderDelegate> delegate;
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol IconDownloaderDelegate 


- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end
