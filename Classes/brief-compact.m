//
//  brief-compact.m
//  Briefs
//
//  Created by Rob Rhyne on 9/3/09.
//  Copyright Digital Arch Design, 2009. See LICENSE file for details.
//

#import <Foundation/Foundation.h>
#import "BFScene.h"
#import "BFActor.h"


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Declarations

        void  __pp(NSString *fmt, ...);
      NSData* __image_data(NSString *, NSString *);
NSDictionary* __process(BFScene *, NSString *);


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Main Function

int main (int argc, const char * argv[]) 
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSProcessInfo     *info = [NSProcessInfo processInfo];
  NSArray           *args = [info arguments];
  
  // 0. Validate arguments
  if ([args count] < 2) {
    __pp(@"Usage: %@ unpacked [output]", [info processName]);
    exit(0);
  }

  // 1. Convert local paths into absolute paths & 
  //    derive the working directory of the brief
  NSString *path = [args objectAtIndex:1];
  if (![path isAbsolutePath]) {
    path = [[[NSFileManager defaultManager] currentDirectoryPath] stringByAppendingFormat:@"/%@", path];
  }
  NSString *workingDirectory = [path stringByDeletingLastPathComponent];
  
  // 2. Read in passed brief
  NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
  NSMutableArray *scenes = [NSMutableArray arrayWithCapacity:[[dict valueForKey:@"scenes"] count]];
  
  // 3. Process the brief, scene by scene
  for (NSDictionary *dictionary in [dict valueForKey:@"scenes"]) {
    BFScene *scene = [[BFScene alloc] init:[dictionary valueForKey:@"name"] withDictionary:dictionary];
    [scenes addObject: __process(scene, workingDirectory)];
    [scene release];
  }
  
  // 4. Collect compacted contents 
  [dict setObject:scenes forKey:@"scenes"];
  
  // 5. Write out compacted brief to file. If no output
  //    path is passed, default to "output.brieflist"
  NSString *output;
  if ([args count] > 2) {
    output = [args objectAtIndex:2];
    if (![output isAbsolutePath]) {
      output = [[[NSFileManager defaultManager] currentDirectoryPath] stringByAppendingFormat:@"/%@", output];
    }
  }
  else {
    output = [[[NSFileManager defaultManager] currentDirectoryPath] stringByAppendingFormat:@"/%@", @"output.brieflist"];
  }
  __pp(@"Writing compacted brief to: %@", output);
  
  NSString *error;
  NSData *data = [NSPropertyListSerialization dataFromPropertyList:dict 
                                                            format:NSPropertyListBinaryFormat_v1_0 
                                                  errorDescription:&error];
  [data writeToFile:output atomically:YES];
  
  //[dict writeToFile:output atomically:NO];
  
  [pool drain];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Functions

/** process scene & actor images */
NSDictionary* __process(BFScene *scene, NSString *directory)
{
  __pp(@"Compacting %@", [scene name]);
  NSDictionary *dict = [scene copyAsDictionary];
  NSMutableDictionary *unpackedDictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
  
  // compact scene images
  NSData *imageData = __image_data([scene bg], directory);
  [unpackedDictionary setObject:imageData forKey:@"img"];
  
  int count = 0;
  NSArray *arrayOfActors = [unpackedDictionary objectForKey:@"actors"];
  NSMutableArray *newActorsArray = [NSMutableArray arrayWithCapacity:[arrayOfActors count]];
  for (BFActor *actor in [scene actors]) {
    __pp(@"           %@", [actor name]);
    
    NSMutableDictionary *unpackedActor = [NSMutableDictionary dictionaryWithDictionary:[arrayOfActors objectAtIndex:count]];
    NSData *actorImageData = __image_data([actor bg], directory);
    [unpackedActor setObject:actorImageData forKey:@"img"];
    [newActorsArray addObject:unpackedActor]; //insertObject:unpackedActor atIndex:count++];
  }
  [unpackedDictionary setObject:arrayOfActors forKey:@"actors"];
  
  [dict release];
  
  return unpackedDictionary;
}


/** get image data for the file referenced by the path */
NSData* __image_data(NSString *path, NSString *directory)
{
  NSString *imagePath = path;
  if (![path isAbsolutePath]) {
    imagePath = [directory stringByAppendingFormat:@"/%@", imagePath];
  }
  return [NSData dataWithContentsOfFile:imagePath];
}

/** print out message, with format out standard out */
void __pp(NSString *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
  
	NSString *output = [[NSString alloc] initWithFormat:fmt arguments:ap];
	printf([output UTF8String]);
	printf("\n");
	[output release];
  
	va_end(ap);
}