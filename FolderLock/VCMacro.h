//
//  VCMacro.h
//  Vaccinations
//
//  Created by Nguyen Le Duan on 11/18/14.
//  Copyright (c) 2014 Gem Vietnam. All rights reserved.
//

#ifndef Vaccinations_VCMacro_h
#define Vaccinations_VCMacro_h

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define OBJECT_NULL  (id)[NSNull null]

#define IS_IPHONE_4 (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)

#define IS_IPHONE_5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#define IS_RETINA [[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00

#define IS_IPHONE_6 (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)

#define IS_IPHONE_6_PLUS (([[UIScreen mainScreen] bounds].size.height-736)?NO:YES)

#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define IS_IOS_8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8)

#define kAppServiceName @"kChartNotesServiceName"

#define VCUUID @"uuid"
#define USERID @"userId"
#define DATE_UPDATE_END @"dateUpdateEnd"
#define EMPTY_STRING @""

#define VCLightGrayColor [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0]

#define kCountryListFileName        @"countries.json"

#define ksettingInstructionKey @"VCSettingInstructionKey"
#define kEditMainProfileInstructionKey @"VCEditMainProfileInstructionKey"
#define kAddProfileInstructionKey @"VCAddProfileInstructionKey"

#define userDefault [NSUserDefaults standardUserDefaults]

#define UIViewParentController(__view) ({ \
UIResponder *__responder = __view; \
while ([__responder isKindOfClass:[UIView class]]) \
__responder = [__responder nextResponder]; \
(UIViewController *)__responder; \
})

typedef void(^databaseHandler)(NSError * error, id result);

/* define alertView */
#define CANNOT_REDIRECT_TO_WEBSITE [[[UIAlertView alloc] initWithTitle:nil message:VCLocalizedString(kLocalizeKeyCannotRedirectWebsite) delegate:self cancelButtonTitle:VCLocalizedString(kLocalizeKeyOK) otherButtonTitles:nil, nil] show]

#define DEVICE_NOT_CONFIGURE_TO_SEND_MAIL [[[UIAlertView alloc] initWithTitle:nil message:VCLocalizedString(kLocalizeKeyDeviceNotConfigureToSendEmail) delegate:self cancelButtonTitle:VCLocalizedString(kLocalizeKeyOK) otherButtonTitles:nil, nil] show]
#define EMAIL_ADDRESS_IS_EMPTY [[[UIAlertView alloc] initWithTitle:nil message:VCLocalizedString(kLocalizeKeyEmailAddressEmpty) delegate:self cancelButtonTitle:VCLocalizedString(kLocalizeKeyOK) otherButtonTitles:nil, nil] show]
// font styles

#define VCFontRegular(v) [UIFont fontWithName:@"DroidSans" size:v]
#define VCFontBold(v) [UIFont fontWithName:@"DroidSans-Bold" size:v]
#define VCTitleFont(v) [UIFont fontWithName:@"Berlin Sans FB Demi" size:v]

#define H1_FONT VCFontBold(19)
#define H2_FONT VCFontBold(19)
#define H3_FONT VCFontBold(19)
#define H4_FONT VCFontRegular(15)
#define H5_FONT VCFontRegular(15)
#define H6_FONT VCFontRegular(15)
#define H7_FONT VCFontBold(15)
#define H8_FONT VCFontBold(16)
#define H9_FONT VCFontRegular(12)
#define H10_FONT VCFontRegular(12)
#define H11_FONT VCFontRegular(15)
#define H12_FONT VCFontBold(15)
#define H17_FONT VCFontBold(17)
#define H18_FONT VCFontRegular(17)
#define H19_FONT VCFontBold(18)
#define H20_FONT VCFontRegular(18)

#define H13_FONT VCFontBold(23)
#define H14_FONT VCFontRegular(19)
#define H15_FONT VCFontBold(26)
#define H16_FONT VCFontRegular(23)
// font color
#define RGBCOLOR(RED, GREEN, BLUE, ALPHA) [UIColor colorWithRed:RED/255.0f green:GREEN/255.0f blue:BLUE/255.0f alpha:ALPHA]
#define SBSeparateTableViewColor [UIColor colorWithRed:188.0/255 green:188.0/255 blue:188.0/255 alpha:1.0]
#define H1_COLOR RGBCOLOR(255,255,255,1)
#define H2_COLOR RGBCOLOR(0,0,0,1)
#define H3_COLOR RGBCOLOR(135,135,135,1)
#define H4_COLOR RGBCOLOR(255,255,255,1)
#define H5_COLOR RGBCOLOR(0,0,0,1)
#define H6_COLOR RGBCOLOR(135,135,135,1)
#define H7_COLOR RGBCOLOR(255,255,255,1)
#define H8_COLOR RGBCOLOR(255,255,255,1)
#define H9_COLOR RGBCOLOR(135,135,135,1)
#define H10_COLOR RGBCOLOR(224,23,23,1)
#define H11_COLOR RGBCOLOR(113,213,253,1)
#define H12_COLOR RGBCOLOR(0,0,0,1)
#define H13_COLOR RGBCOLOR(255,255,255,1)
#define H14_COLOR RGBCOLOR(255,255,255,1)
#define H15_COLOR RGBCOLOR(255,255,255,1)
#define H16_COLOR RGBCOLOR(255,255,255,1)
#endif
