//
//  UIColor+String.m
//
//  Created by Kevin Zhang on 11/3/14.
//

#import "UIColor+String.h"

static NSMutableDictionary* colorNames;

@implementation UIColor (String)

+(UIColor*)colorFromRGB:(int) rgbValue {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

+(UIColor*)colorFromRGBA:(int) rgbValue {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0
                           alpha:((float)((rgbValue & 0xFF0000) >> 24))/255.0];
}

+(void)load {
    colorNames = [[NSMutableDictionary alloc] init];
     [colorNames setObject:[self colorFromRGB:0xF0F8FF] forKey:[@"AliceBlue" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFAEBD7] forKey:[@"AntiqueWhite" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x00FFFF] forKey:[@"Aqua" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x7FFFD4] forKey:[@"Aquamarine" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xF0FFFF] forKey:[@"Azure" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xF5F5DC] forKey:[@"Beige" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFE4C4] forKey:[@"Bisque" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x000000] forKey:[@"Black" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFEBCD] forKey:[@"BlanchedAlmond" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x0000FF] forKey:[@"Blue" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x8A2BE2] forKey:[@"BlueViolet" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xA52A2A] forKey:[@"Brown" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xDEB887] forKey:[@"BurlyWood" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x5F9EA0] forKey:[@"CadetBlue" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x7FFF00] forKey:[@"Chartreuse" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xD2691E] forKey:[@"Chocolate" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFF7F50] forKey:[@"Coral" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x6495ED] forKey:[@"CornflowerBlue" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFF8DC] forKey:[@"Cornsilk" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xDC143C] forKey:[@"Crimson" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x00FFFF] forKey:[@"Cyan" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x00008B] forKey:[@"DarkBlue" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x008B8B] forKey:[@"DarkCyan" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xB8860B] forKey:[@"DarkGoldenRod" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xA9A9A9] forKey:[@"DarkGray" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x006400] forKey:[@"DarkGreen" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xBDB76B] forKey:[@"DarkKhaki" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x8B008B] forKey:[@"DarkMagenta" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x556B2F] forKey:[@"DarkOliveGreen" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFF8C00] forKey:[@"DarkOrange" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x9932CC] forKey:[@"DarkOrchid" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x8B0000] forKey:[@"DarkRed" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xE9967A] forKey:[@"DarkSalmon" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x8FBC8F] forKey:[@"DarkSeaGreen" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x483D8B] forKey:[@"DarkSlateBlue" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x2F4F4F] forKey:[@"DarkSlateGray" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x00CED1] forKey:[@"DarkTurquoise" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x9400D3] forKey:[@"DarkViolet" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFF1493] forKey:[@"DeepPink" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x00BFFF] forKey:[@"DeepSkyBlue" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x696969] forKey:[@"DimGray" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x1E90FF] forKey:[@"DodgerBlue" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xB22222] forKey:[@"FireBrick" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFFAF0] forKey:[@"FloralWhite" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x228B22] forKey:[@"ForestGreen" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFF00FF] forKey:[@"Fuchsia" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xDCDCDC] forKey:[@"Gainsboro" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xF8F8FF] forKey:[@"GhostWhite" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFD700] forKey:[@"Gold" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xDAA520] forKey:[@"GoldenRod" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x808080] forKey:[@"Gray" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x008000] forKey:[@"Green" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xADFF2F] forKey:[@"GreenYellow" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xF0FFF0] forKey:[@"HoneyDew" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFF69B4] forKey:[@"HotPink" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xCD5C5C] forKey:[@"IndianRed" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x4B0082] forKey:[@"Indigo" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFFFF0] forKey:[@"Ivory" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xF0E68C] forKey:[@"Khaki" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xE6E6FA] forKey:[@"Lavender" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFF0F5] forKey:[@"LavenderBlush" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x7CFC00] forKey:[@"LawnGreen" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFFACD] forKey:[@"LemonChiffon" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xADD8E6] forKey:[@"LightBlue" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xF08080] forKey:[@"LightCoral" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xE0FFFF] forKey:[@"LightCyan" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFAFAD2] forKey:[@"LightGoldenRodYellow" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xD3D3D3] forKey:[@"LightGray" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x90EE90] forKey:[@"LightGreen" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFB6C1] forKey:[@"LightPink" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFA07A] forKey:[@"LightSalmon" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x20B2AA] forKey:[@"LightSeaGreen" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x87CEFA] forKey:[@"LightSkyBlue" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x778899] forKey:[@"LightSlateGray" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xB0C4DE] forKey:[@"LightSteelBlue" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFFFE0] forKey:[@"LightYellow" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x00FF00] forKey:[@"Lime" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x32CD32] forKey:[@"LimeGreen" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFAF0E6] forKey:[@"Linen" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFF00FF] forKey:[@"Magenta" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x800000] forKey:[@"Maroon" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x66CDAA] forKey:[@"MediumAquaMarine" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x0000CD] forKey:[@"MediumBlue" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xBA55D3] forKey:[@"MediumOrchid" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x9370DB] forKey:[@"MediumPurple" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x3CB371] forKey:[@"MediumSeaGreen" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x7B68EE] forKey:[@"MediumSlateBlue" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x00FA9A] forKey:[@"MediumSpringGreen" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x48D1CC] forKey:[@"MediumTurquoise" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xC71585] forKey:[@"MediumVioletRed" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x191970] forKey:[@"MidnightBlue" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xF5FFFA] forKey:[@"MintCream" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFE4E1] forKey:[@"MistyRose" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFE4B5] forKey:[@"Moccasin" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFDEAD] forKey:[@"NavajoWhite" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x000080] forKey:[@"Navy" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFDF5E6] forKey:[@"OldLace" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x808000] forKey:[@"Olive" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x6B8E23] forKey:[@"OliveDrab" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFA500] forKey:[@"Orange" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFF4500] forKey:[@"OrangeRed" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xDA70D6] forKey:[@"Orchid" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xEEE8AA] forKey:[@"PaleGoldenRod" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x98FB98] forKey:[@"PaleGreen" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xAFEEEE] forKey:[@"PaleTurquoise" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xDB7093] forKey:[@"PaleVioletRed" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFEFD5] forKey:[@"PapayaWhip" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFDAB9] forKey:[@"PeachPuff" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xCD853F] forKey:[@"Peru" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFC0CB] forKey:[@"Pink" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xDDA0DD] forKey:[@"Plum" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xB0E0E6] forKey:[@"PowderBlue" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x800080] forKey:[@"Purple" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFF0000] forKey:[@"Red" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xBC8F8F] forKey:[@"RosyBrown" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x4169E1] forKey:[@"RoyalBlue" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x8B4513] forKey:[@"SaddleBrown" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFA8072] forKey:[@"Salmon" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xF4A460] forKey:[@"SandyBrown" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x2E8B57] forKey:[@"SeaGreen" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFF5EE] forKey:[@"SeaShell" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xA0522D] forKey:[@"Sienna" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xC0C0C0] forKey:[@"Silver" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x87CEEB] forKey:[@"SkyBlue" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x6A5ACD] forKey:[@"SlateBlue" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x708090] forKey:[@"SlateGray" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFFAFA] forKey:[@"Snow" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x00FF7F] forKey:[@"SpringGreen" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x4682B4] forKey:[@"SteelBlue" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xD2B48C] forKey:[@"Tan" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x008080] forKey:[@"Teal" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xD8BFD8] forKey:[@"Thistle" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFF6347] forKey:[@"Tomato" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0x40E0D0] forKey:[@"Turquoise" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xEE82EE] forKey:[@"Violet" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xF5DEB3] forKey:[@"Wheat" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFFFFF] forKey:[@"White" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xF5F5F5] forKey:[@"WhiteSmoke" lowercaseString]];
     [colorNames setObject:[self colorFromRGB:0xFFFF00] forKey:[@"Yellow" lowercaseString]];
    [colorNames setObject:[self colorFromRGB:0x9ACD32] forKey:[@"YellowGreen" lowercaseString]];
    [colorNames setObject:[UIColor clearColor] forKey:[@"clear" lowercaseString]];
}

+(BOOL)numberFromStr:(NSString*)colorStr :(float *)pvalue {
    if ([colorStr hasPrefix:@"0x"]) {
        NSScanner* scanner = [NSScanner scannerWithString:colorStr];
        unsigned int value;
        [scanner setScanLocation:2];
        BOOL ret = [scanner scanHexInt:&value];
        *pvalue = value;
        return ret;
    }
    
    if ([colorStr hasPrefix:@"#"]) {
        NSScanner* scanner = [NSScanner scannerWithString:colorStr];
        unsigned int value;
        [scanner setScanLocation:1];
        BOOL ret = [scanner scanHexInt:&value];
        *pvalue = value;
        return ret;
    }
    
    NSScanner* scanner = [NSScanner scannerWithString:colorStr];
    return [scanner scanFloat:pvalue];
}

+(UIColor*) colorFromString:(NSString*) colorStr {
    UIColor* color = [colorNames objectForKey:[colorStr lowercaseString]];
    if(color)
        return color;
    NSString* original = colorStr;
    
    colorStr = [colorStr lowercaseString];
    colorStr = [colorStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    float value;
    if ([self numberFromStr:colorStr :&value]) {
        if (colorStr.length == 7) {
            return [self colorFromRGB:value];
        }
        if (colorStr.length == 9) {
            return [self colorFromRGBA:value];
        }
    }
    
    if ([colorStr hasPrefix:@"rgb("]) {
        colorStr = [colorStr substringFromIndex:4];
        colorStr = [colorStr substringToIndex:colorStr.length-1];
        NSArray *rgb = [colorStr componentsSeparatedByString:@","];
        float r,g,b, a;
        BOOL valid = [self numberFromStr:[rgb objectAtIndex:0] :&r]
        && [self numberFromStr:[rgb objectAtIndex:1] :&g]
        && [self numberFromStr:[rgb objectAtIndex:2] :&b];
            if (valid) {
                return [self colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
            }
            else {
                NSLog(@"invalid rgb str %@", colorStr);
                return nil;
            }
    }
    
    if ([colorStr hasPrefix:@"rgba("]) {
        colorStr = [colorStr substringFromIndex:5];
        colorStr = [colorStr substringToIndex:colorStr.length-1];
        NSArray *rgb = [colorStr componentsSeparatedByString:@","];
        float r,g,b, a;
        BOOL valid = [self numberFromStr:[rgb objectAtIndex:0] :&r]
        && [self numberFromStr:[rgb objectAtIndex:1] :&g]
        && [self numberFromStr:[rgb objectAtIndex:2] :&b]
        && [self numberFromStr:[rgb objectAtIndex:3] :&a];
            if (valid) {
                return [self colorWithRed:r/255 green:g/255 blue:b/255 alpha:a];
            }
            else {
                NSLog(@"invalid rgba str %@", colorStr);
                return nil;
            }
    }
    
    return nil;
}

@end
