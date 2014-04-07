

#import <UIKit/UIKit.h>



@interface FaceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
	NSMutableArray            *_phraseArray;
    
    
}

@property (retain, nonatomic) IBOutlet UIScrollView *faceScrollView;
@property (nonatomic, retain) NSMutableArray            *phraseArray;

-(IBAction)dismissMyselfAction:(id)sender;
- (void)showEmojiView;
@end
