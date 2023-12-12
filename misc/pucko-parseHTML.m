/*

 PUCKO Linux

 Copyright (c) 2023 Arthur Choung. All rights reserved.

 Email: arthur -at- hotdoglinux.com

 This file is part of PUCKO Linux.

 PUCKO Linux is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.

 */

#import "HOTDOG.h"

#include <tidy.h>
#include <tidybuffio.h>

static id getNodeType(TidyNode node)
{
    switch (tidyNodeGetType(node)) {
        case TidyNode_Root: return @"Root";
        case TidyNode_DocType: return @"DOCTYPE";
        case TidyNode_Comment: return @"Comment";
        case TidyNode_ProcIns: return @"Processing Instruction";
        case TidyNode_Text: return @"Text";
        case TidyNode_CDATA: return @"CDATA";
        case TidyNode_Section: return @"XML Section";
        case TidyNode_Asp: return @"ASP";
        case TidyNode_Jste: return @"JSTE";
        case TidyNode_Php: return @"PHP";
        case TidyNode_XmlDecl: return @"XML Declaration";
        case TidyNode_Start: return @"Start";
        case TidyNode_End: return @"End";
        case TidyNode_StartEnd: return @"StartEnd";
    }
    return nil;
}
static id parseHTMLNode(TidyDoc tdoc, TidyNode node)
{
    id result = nsdict();

    id type = getNodeType(node);
    [result setValue:type forKey:@"type"];

    char *str = tidyNodeGetName(node);
    if (str) {
        id name = nsfmt(@"%s", str);
        [result setValue:name forKey:@"name"];
    }

    id attrs = nsdict();
    for (TidyAttr attr=tidyAttrFirst(node); attr; attr=tidyAttrNext(attr)) {
        ctmbstr cstr = tidyAttrName(attr);
        if (!cstr) {
            continue;
        }
        id attrname = nsfmt(@"%s", cstr);

        cstr = tidyAttrValue(attr);
        if (!cstr) {
            continue;
        }
        id attrvalue = nsfmt(@"%s", cstr);

        [attrs setValue:attrvalue forKey:attrname];
    }
    [result setValue:attrs forKey:@"attrs"];

    if ([type isEqual:@"Comment"]) {
        TidyBuffer buf;
        tidyBufInit(&buf);
        tidyNodeGetValue(tdoc, node, &buf);
        id value = nsfmt(@"%*.*s", buf.size, buf.size, buf.bp);
        tidyBufFree(&buf);
        [result setValue:value forKey:@"value"];
    }

    if (tidyNodeIsText(node)) {
        TidyBuffer buf;
        tidyBufInit(&buf);
        tidyNodeGetText(tdoc, node, &buf);
        id text = nsfmt(@"%*.*s", buf.size, buf.size, buf.bp);
        tidyBufFree(&buf);
        [result setValue:text forKey:@"text"];
    }

    id children = nsarr();
    for (TidyNode child=tidyGetChild(node); child; child=tidyGetNext(child)) {
        id elt = parseHTMLNode(tdoc, child);
        if (elt) {
            [children addObject:elt];
        }
    }
    if ([children count]) {
        [result setValue:children forKey:@"children"];
    }
    
    return result;
}
static id parseHTML(id str)
{
    TidyDoc tdoc = tidyCreate();
    tidyOptSetValue(tdoc, TidyOutCharEncoding, "raw");
    if (tidyParseString(tdoc, [str UTF8String]) < 0) {
        return nil;
    }
    TidyNode rootNode = tidyGetRoot(tdoc);
    if (!rootNode) {
        return nil;
    }
    id result = parseHTMLNode(tdoc, rootNode);
    tidyRelease(tdoc);
    return result;
}

@implementation NSString(mekwlfmkewlfmklsdmfklsdmklf)
- (id)parseHTML
{
    return parseHTML(self);
}
@end

@implementation Definitions(fmeklwmfklsdmklfms)
+ (id)parseHTML:(id)url
{
    id filename = [url urlAsValidFilename];
    if (![filename fileExists]) {
        [Definitions downloadURL:url];
    }
    id str = [filename stringFromFile];
    return [str parseHTML];
}
+ (id)parseHTML
{
    id data = [Definitions dataFromStandardInput];
    id str = [data asString];
    return [str parseHTML];
}
@end

