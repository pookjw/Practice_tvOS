//
//  ViewController.m
//  Project4
//
//  Created by Jinwoo Kim on 2/9/21.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.title == nil) return;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://content.guardianapis.com/%@?api-key=%@&show-fields=thumbnail,headline,standfirst,body", [self.title lowercaseString], apiKey]];
    if (url == nil) return;
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        [self fetch:url];
    });
}

- (void)fetch:(NSURL *)url {
    // attempt to download the contents of this URL
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    if (data) {
        // convert that to JSON and pull out the array we care about
        self.articles = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"response"][@"results"];
        
        // reload the collection view on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    } else {
        // something went wrong!
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.articles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *newsCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (newsCell == nil) {
        [NSException raise:@"NewsCellIsNil" format:@"Unable to dequeue NewsCell from UICollectionView!"];
    }
    
    NSUInteger _idx = 0;
    NSDictionary<NSString *, id> *_newsItem;
    for (NSDictionary<NSString *, id> *dic in self.articles) {
        if (_idx == indexPath.row) {
            _newsItem = dic;
            break;
        }
        _idx += 1;
    }
    NSString *title = _newsItem[@"fields"][@"headline"];
    NSString *thumbnail = _newsItem[@"fields"][@"thumbnail"];
    
    [newsCell.textLabel setText:title];
    
    NSURL *imageURL = [NSURL URLWithString:thumbnail];
    
    if (imageURL) {
        [newsCell.imageView loadURL:imageURL];
    }
    
    return newsCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ReaderViewController *reader = [self.storyboard instantiateViewControllerWithIdentifier:@"Reader"];
    if (reader == nil) return;
    reader.article = self.articles[indexPath.row];
    [self presentViewController:reader animated:YES completion:nil];
}

#pragma UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *text = searchController.searchBar.text;
    if (text == nil) return;
    
    if (text.length == 0) {
        self.articles = @[];
        [self.collectionView reloadData];
    } else {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://content.guardianapis.com/search?api-key=%@&q=%@&show-fields=thumbnail,headline,standfirst,body", apiKey, [text lowercaseString]]];
        if (url == nil) return;
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            [self fetch:url];
        });
    }
}

@end
