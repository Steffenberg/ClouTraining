//
//  SettingsTableViewCell.m
//  ClouTraining
//
//  Created by Steffen Gruschka on 23.07.15.
//  Copyright (c) 2015 fastline. All rights reserved.
//

#import "SettingsTableViewCell.h"

@implementation SettingsTableViewCell

- (void)awakeFromNib {
    _nicknameField.delegate = self;
    _passwordField.delegate = self;
    _mailField.delegate = self;
    _loginNickField.delegate = self;
    _loginPWField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)mobileSwitchChanged:(id)sender {
    UISwitch *sw = (UISwitch*)sender;
    [Communicator setDataOnlyLAN:!sw.on];
}

-(IBAction)performRegister:(id)sender{
    if([_mailField.text isEqualToString:@""]){
        [[ErrorHandler sharedInstance]handleSimpleError:@"Fehler" andMessage:@"Bitte gib eine E-Mail-Adresse ein"];
    }else if([_nicknameField.text isEqualToString:@""]){
        [[ErrorHandler sharedInstance]handleSimpleError:@"Fehler" andMessage:@"Bitte gib einen Benutzernamen ein"];
    }else if([_passwordField.text isEqualToString:@""]){
        [[ErrorHandler sharedInstance]handleSimpleError:@"Fehler" andMessage:@"Bitte gib ein Passwort ein"];
    }else{
        [[Communicator sharedInstance]performRegister:_mailField.text password:[GlobalHelperClass createSHA512:_passwordField.text] nickname:_nicknameField.text];
    }
    
}
- (IBAction)performLogin:(id)sender {
    if([_loginNickField.text isEqualToString:@""]){
        [[ErrorHandler sharedInstance]handleSimpleError:@"Fehler" andMessage:@"Bitte gib einen Benutzernamen ein"];
    }else if([_loginPWField.text isEqualToString:@""]){
        [[ErrorHandler sharedInstance]handleSimpleError:@"Fehler" andMessage:@"Bitte gib ein Passwort ein"];
    }else{
        [[Communicator sharedInstance]performLogin:_loginNickField.text password:[GlobalHelperClass createSHA512:_loginPWField.text]];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
