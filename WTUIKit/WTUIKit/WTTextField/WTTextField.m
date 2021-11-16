//
//  WTTextField.h
//  WTBaseCore
//
//  Created by jienliang on 2017/12/5.
//  Copyright © 2017年 jienliang. All rights reserved.
//

#import "WTTextField.h"

@implementation WTTextField

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.hasCopyAndPast = NO;
         self.maxLen = INT_MAX;
         [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (!self.hasCopyAndPast) {
        if (action == @selector(paste:))//禁止粘贴
            return NO;
        if (action == @selector(select:))// 禁止选择
            return NO;
        if (action == @selector(selectAll:))// 禁止全选
            return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

- (void)textFieldDidChange:(UITextField *)textField {
     [self checkTextFieldMaxLen:self.maxLen];
    if (self.textFieldDidChanged) {
        self.textFieldDidChanged();
    }
}

- (void)checkTextFieldMaxLen:(int)max {
     int kMaxLength = INT_MAX;
     if (max > 0) {
          kMaxLength = max;
     }
     NSString *toBeString = self.text;
    if ([self stringContainsEmoji:self.text]) {
        toBeString = [self disable_emoji:toBeString];
          self.text = toBeString;
          return;
     }
     
     NSString *lang = [self.textInputMode primaryLanguage];
     if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
     {
          //获取高亮部分
          UITextRange *selectedRange = [self markedTextRange];
          UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
          
          // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
          if (!position)
          {
               if (toBeString.length > kMaxLength)
               {
                    self.text = [toBeString substringToIndex:kMaxLength];
               }
          }
     }
     // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
     else
     {
          if (toBeString.length > kMaxLength)
          {
               NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:kMaxLength];
               if (rangeIndex.length == 1)
               {
                    self.text = [toBeString substringToIndex:kMaxLength];
               }
               else
               {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, kMaxLength)];
                    self.text = [toBeString substringWithRange:rangeRange];
               }
          }
     }
}

-(void)drawPlaceholderInRect:(CGRect)rect {
    if (self.placeHolderColor) {
        CGSize placeholderSize = [self.placeholder sizeWithAttributes:@{NSFontAttributeName:self.font}];
        [self.placeholder drawInRect:CGRectMake(0, (rect.size.height - placeholderSize.height)/2, rect.size.width, rect.size.height)
                      withAttributes:@{NSForegroundColorAttributeName:self.placeHolderColor,NSFontAttributeName : self.font}];
    }
}

- (BOOL)stringContainsEmoji:(NSString *)str {
    __block BOOL returnValue = NO;
    [str enumerateSubstringsInRange:NSMakeRange(0, [str length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar high = [substring characterAtIndex: 0];
                              
                              // Surrogate pair (U+1D000-1F9FF)
                              if (0xD800 <= high && high <= 0xDBFF) {
                                  const unichar low = [substring characterAtIndex: 1];
                                  const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                  
                                  if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                      returnValue = YES;
                                  }
                                  
                                  // Not surrogate pair (U+2100-27BF)
                              } else {
                                  if (0x2100 <= high && high <= 0x27BF){
                                      returnValue = YES;
                                  }
                              }
                          }];
    
    return returnValue;
}

- (NSString *)disable_emoji:(NSString *)str
{
     NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
     NSString *modifiedString = [regex stringByReplacingMatchesInString:self
                                                                options:0
                                                                  range:NSMakeRange(0, [str length])
                                                           withTemplate:@""];
     return modifiedString;
}

@end
