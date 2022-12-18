# Implementation of WebSocket Interface for a Twitter-like engine
## Problem Statment
Implementation of WebSocket interface for Twitter API implemented using actor model in Erlang. The main functionalities of this engine will be
-   To provide an interactive client interface
-   Updating feed without client intervention.
-   Client should be able to
	-   Register
	-   Send tweets
	-   View Feed and Retweet
	-   Subscribed
	-   Query using hashtags, mentions & subscribed users.

## Implementation
### HTTP vs WebSockets
In HTTP long polling, the client has to continuously pull the updates from the server and update accordingly. If there’s a continuous stream of data, the client will have to request more pull requests and wait till the server is free. It is ineffective.
In Web Sockets, a channel is created which enables the server to send a stream of data without client asking server.
### Cowboy
Cowboy is a small, fast, HTTP server for Erlang/OTP. Cowboy provides a complete web stack which is supported by HTTP/1.1, HTTP/2, Websocket, REST

Let us discuss on how to create and run a cowboy application in a linux/Mac device.
-   Create a directory with all lower cases
-   Install erlang.mk: ```wget https://erlang.mk/erlang.mk```
-   Bootstrap the application : ```make -f erlang.mk bootstrap bootstrap-rel```
-   Run the application : ```make run```
-   Now, add cowboy to the existing dependencies(in Makefile)
-   Add Routing and listening in the ```<app name>_app.erl```
-   Run the application : ```make run```
[**For more references, check out the documentation**](https://ninenines.eu/docs/en/cowboy/2.6/guide/getting_started/)

### Architecture
####  Register
![image](https://user-images.githubusercontent.com/60289522/208279767-094aa9f2-ab50-411a-9142-ee7887c9645d.png )

####  Twitter Functionality
![image](https://user-images.githubusercontent.com/60289522/208279769-266b9d0c-df66-4ab8-a554-8c479adeadd1.png)

####  Feed Update with WebSocket
![image](https://user-images.githubusercontent.com/60289522/208279773-f7355592-89f4-421d-ab60-c143ffdcd3af.png)

#### Routing & Connections**
##### Routes
![image](https://user-images.githubusercontent.com/60289522/208279774-766416b1-a85e-4d22-a893-c3dba6ad3662.png)

##### Connections
![image](https://user-images.githubusercontent.com/60289522/208279777-1035d4d5-19f9-48cb-91ea-ed225ba2dc8e.png)

## Run Instructions
-   Run the following in terminal
```
cd twitterws
make run
```
-   Open [http://localhost:8081/](http://localhost:8081/) in your desired browsers.

## Conclusions

A websocket interface for a twitter like engine is successfully implemented with an interactive user interface through which users can perform functionalities like
-   Tweet
-   Register
-   Subscribe
-   Retweet
-   Query tweets by mention, hashtag & by subscribed users
A websocket connection is established after registering and redirected to /name/main. Once a user tweeted, all the subscribed users will instantly get in the feed through websockets without any user interaction.

## Relevant Links
- [Twitter API README](https://github.com/koushik4/COP5615-DOSP/blob/main/Twitter%20API/README.md)
- [Twitter API Source Code](https://github.com/koushik4/COP5615-DOSP/tree/main/Twitter%20API)
- [Youtube Link](https://youtu.be/21jNTJ_o3R4)
