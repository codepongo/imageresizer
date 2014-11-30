#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#include <stdio.h>

void Help(const char* name)
{
	printf("%s <output> <-i input> <-s percent> [-help]\n\
				  output - output image file name\n\
				  -i input - input image file name\n\
				  -s percent  - scale percent such as -s 70 means scale 70%%\n\
				  -h - print help information", name);
	exit(0);
}

int main (int argc, const char * argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	if (argc < 4)
	{
		Help(argv[0]);
	}
	NSString* input = nil;
	NSString* output = nil;
	
	[[NSString alloc]initWithString:@""];
	int percent = 0;
	int i = 1;
	while( i < argc)
	{
		if (0 == strcmp(argv[i],"-i"))
		{
			i++;
			if (i < argc)
			{
				input = [NSString stringWithCString:(const char*)argv[i]  encoding:NSUTF8StringEncoding];
			}
			else
			{
				Help(argv[0]);
			}
		}
		else if (0 == strcmp(argv[i],"-s"))
		{
			i++;
			if (i < argc)
			{
				percent = [[NSString stringWithCString:(const char*)argv[i]  encoding:NSUTF8StringEncoding] intValue];
			}
			else
			{
				Help(argv[0]);
			}
		}
		else
		{
			output = [NSString stringWithCString:(const char*)argv[i]  encoding:NSUTF8StringEncoding];
		}
		i++;
		
	}
	if (input == nil || output == nil || percent == 0)
	{
		Help(argv[0]);
	}
	

	NSImage* from = [[NSImage alloc]initWithContentsOfFile:(input)];

	NSSize size = NSMakeSize([from size].width * percent / 100, [from size].height * percent / 100);	
	NSRect rc = NSMakeRect(0, 0, size.width, size.height);
	
	
	NSImageRep *rep = [from bestRepresentationForRect:rc context:nil hints:nil];
	
	NSImage* to = [[NSImage alloc] initWithSize:size];
	
    [to lockFocus];
    [rep drawInRect: rc];
    [to unlockFocus];
	
	NSBitmapImageRep *r = [NSBitmapImageRep imageRepWithData:[to TIFFRepresentation]];
	
		//NSDictionary *proper = [NSDictionary dictionaryWithObject:NSumber forKey:NSImageCompressionFactor];
	NSData* data = [r representationUsingType:NSJPEGFileType properties:nil];
	[data writeToFile:[[NSString stringWithString:output] stringByExpandingTildeInPath]atomically:YES]; 
	[pool release];
    return 0;
}
