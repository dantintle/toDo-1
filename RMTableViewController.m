//
//  RMTableViewController.m
//  toDo
//
//  Created by Robert Manson on 10/13/13.
//  Copyright (c) 2013 Robert Manson. All rights reserved.
//

#import "RMTableViewController.h"
#import "RMCustomCell.h"
#import <objc/runtime.h>

static char NSIntItemIndexPath;

@interface RMTableViewController ()
@property (nonatomic, strong) NSMutableArray * items;
@end

@implementation RMTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        self.tableView.allowsSelection = NO;
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setUpToolbar
{
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"To Do List";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINib *customNib = [UINib nibWithNibName:@"RMCustomCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"RMCustomCell"];
    
    
    [self setUpToolbar];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing)
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
    {
        [self setUpToolbar];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RMCustomCell";
    RMCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.itemText.text = [self.items objectAtIndex:indexPath.row];
    cell.itemText.delegate = self;
    objc_setAssociatedObject(cell.itemText, &NSIntItemIndexPath, [NSNumber numberWithBool:indexPath.row], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return cell;
}

- (void)addItem:sender {
    [self.items insertObject:@"" atIndex:0];
    [self.tableView reloadData];
    RMCustomCell *selectedCell = (RMCustomCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [selectedCell.itemText becomeFirstResponder];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.items removeObjectAtIndex: indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *stringToMove = [self.items objectAtIndex:fromIndexPath.row];
    [self.items removeObjectAtIndex:fromIndexPath.row];
    [self.items insertObject:stringToMove atIndex:toIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setUpToolbar];
}

#pragma mark - UITextField delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.view action:@selector(endEditing:)];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger index = [(NSNumber*)objc_getAssociatedObject(textField, &NSIntItemIndexPath) integerValue];
    [self.items replaceObjectAtIndex:index withObject:textField.text];
    [self setUpToolbar];
}

@end
