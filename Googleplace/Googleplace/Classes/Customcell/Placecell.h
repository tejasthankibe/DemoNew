#import <UIKit/UIKit.h>

@interface Placecell : UITableViewCell
{
    IBOutlet UILabel *lblname;
    IBOutlet UIImageView *imgicon;
    IBOutlet UILabel *lbladdress;
}

@property (nonatomic,retain) IBOutlet UILabel *lblname;
@property (nonatomic,retain) IBOutlet UIImageView *imgicon;
@property (nonatomic,retain) IBOutlet UILabel *lbladdress;

@end
