Some performance tests for Grand Central Dispatch queues and objective-c blocks.

You can check out the Profiler screenshots and compare it with the test code.  
The main conclusion is that the performance overhead of using dispatch queues versus execution in a loop is tiny.  
Same with using blocks versus static functions.

I'd love to see someone doing more extensive testing of this stuff.
