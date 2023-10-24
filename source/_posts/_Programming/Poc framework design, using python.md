## A general view
Key data structures:
- `Payload`
	- description about how to send http request
	- `RawPayload`: raw payload without any syntax compiling
	- `CompiledPayload`: compile special syntax in poc, consist of a series of `PayloadContent`(e.g. dict generator or binary file)
- 

Core Components:
- `PocParser`
	- analyze poc json file, generate `RawPayload`
	- compile special syntax in poc, generate `CompiledPayload`
- `PocDispatcher`
	- send poc for target URL list and handle response
	- manage a thread/process pool as `TaskDispatcher`, process every target in a single `PocExecutor`, all phases of a target should execute synchronously
	- employ `Requester`, provide requests to send
	- employ user-defined functions to do preprocess of payloads or analyze response of each payload
	- `Task`: a wrapper of concurrent task, a top-most class which could be planted with any function
	- `TaskCollection`: a collection of tasks, provide introspection methods about the state of tasks
	- `Handler`: specific functions to analyze payload or response
		- handle()
		- `PayloadHandler`: user-defined function to add some conversion to payloads, like encryption
		- `ResponseHandler`: user-defined function to analyze poc response and determine the next step
	- `Valve`: handle and control the handling progress of data flow
		- `AsyncValve`: all block action in this valve should run asynchronously 
		- `PayloadHandlerValve`: a valve wrapper for `PayloadHandler`
		- `ResponseHandlerValve`: a valve wrapper for `ResponseHandler`, parse intermediates and control the state of poc execution progress
	- `Pipline`: refer to tomcat pipline, handle data flow through a series of `Valve`
		- `AsyncPipline`: a series of task to run synchronously, could dispatch in an event loop, could abdicate CPU control when waiting for http response
	- `TaskDispatcher`: contains at least one event loop, run a thread/process pool, every thread/process has a event loop, dispatch tasks to appropriate event loop so as to maintain the balance between all event loops.
	- `PocExecutor`: run poc against a certain target, should contain a `AsyncPipline`, payloads should be handled synchronously, combine user-defined functions as a `AsyncPipline` and maintain a `TaskCollection` to support introspection.
- `Requester`
	- highly tailorable http(s) requester, support asynchronous request
- `Engine`
	- drive all components


