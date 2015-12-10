#import "IconDownloader.h"

#define kAppIconHeight 100
#define kAppIconWidth  100

@implementation IconDownloader

@synthesize URL;
@synthesize Key;
@synthesize delegate = _delegate;
@synthesize activeDownload;
@synthesize imageConnection;
@synthesize imageRecord;
@synthesize indexPathInTableView;
@synthesize Mode;
@synthesize FileName;
#pragma mark

- (void)startDownload 
{
    self.activeDownload = [NSMutableData data];
    NSURLConnection *conn;
    
    conn = [[NSURLConnection alloc] initWithRequest:
                                 [NSURLRequest requestWithURL:
                                  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@",PHOTOURL,@"maxwidth=100&photoreference=",imageRecord.ImageName,@"&sensor=false&key=",KEY]]] delegate:self];
    
    NSLog(@"Photo URL ======= %@",[NSString stringWithFormat:@"%@%@%@%@%@",PHOTOURL,@"maxwidth=100&photoreference=",imageRecord.ImageName,@"&sensor=false&key=",KEY]);

    
    self.imageConnection = conn;
}

- (void)cancelDownload 
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    // Write Image to Disk
    NSData *imageData = UIImagePNGRepresentation(image);
    if(imageData == nil || imageData ==NULL)
        return;
    // Write Image to Disk
    
    NSString *fileName =[NSString stringWithFormat:@"Library/Caches/UserData/%@", FileName];
        NSString *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
        [imageData writeToFile:imagePath atomically:NO];
    
    if (image.size.width != kAppIconWidth  && image.size.height != kAppIconHeight) {
        CGSize itemSize = CGSizeMake(kAppIconWidth, kAppIconHeight);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [image drawInRect:imageRect];
		self.imageRecord.ContentImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else {
        self.imageRecord.ContentImage = image;
    }
    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    // call our delegate and tell it that our icon is ready for display
    
    self.imageRecord.ContentImage = image;
    [_delegate appImageDidLoad:self.indexPathInTableView];
 
       
}

@end

