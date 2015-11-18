//
//  main.m
//  BritishKeyboardDetector
//
//  Created by James Russell on 11/17/15.
//  Copyright © 2015 James Russell. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <xpc/xpc.h>
#include <unistd.h>

BOOL debug = false;

char *kbSwitchArgs[] = {
    "keyboardSwitcher",
    "select",
    "British - PC",
    NULL
};

void handleEvent() {
    xpc_set_event_stream_handler("com.apple.iokit.matching", NULL, ^(xpc_object_t event) {
        // Every event has the key XPC_EVENT_KEY_NAME set to a string that
        // is the name you gave the event in your launchd.plist.
        if (debug) {
            const char *name = xpc_dictionary_get_string(event, XPC_EVENT_KEY_NAME);
        
            // IOKit events have the IORegistryEntryNumber as a payload.
            uint64_t id = xpc_dictionary_get_uint64(event, "IOMatchLaunchServiceID");
            // Reconstruct the node you were interested in here using the IOKit APIs.
            NSLog(@"Received event: %s: %llu", name, id);
        }
        
    });
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        handleEvent();
        if(debug) {
            NSLog(@"Hello, World!");
        }
        execve("/usr/local/bin/keyboardSwitcher", kbSwitchArgs, NULL);
    }
    return 0;
}
