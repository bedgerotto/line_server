# Line Server Problem

## Requirements to run
- Docker

  The service contains a Dockerfile that can be used to build and run the service through the `./build.sh` and `./run.sh` scripts respectively

## How does your system work? (if not addressed in comments in source)
This is basically a rails (Api only) application that exposes the `/lines/:line_number` endpoint.

When a request is received, the requested line number is forwarded to the `FileReader` service. This service will do three operations:
- Validate that the provided `line_number` is a valid integer
- validate that the provided `line_number` exists in the file
  - To do so, the total number of lines is extracted using a command line provided by the S.O. called `wc`. This number is read once and store on the `FILE_TOTAL_LINES` constant
- read and return the requested line
  - While reading hte line, the service uses the SO `sed` command to loop fetch the requested line. Once the line is found it's stored on the memory cache and returned in the request response body as a json `{ "text": "line read from the file" }`

## How will your system perform with a 1 GB file? a 10 GB file? a 100 GB file?
The system performs fairly well with a 1GB file but the performance decreases with larger files

## How will your system perform with 100 users? 10000 users? 1000000 users?
The system also performs fairly well with 100 simultaneous users, but performance decreases as more users start triggering requests 

## What documentation, websites, papers, etc did you consult in doing this assignment?
Stackoverflow, Rails Docs, Ruby Docs, `wc` command man page and `sed` command man page

## What third-party libraries or other tools does the system use? How did you choose each library or framework you used?
It uses rails and all the basic libraries a api only rails application does.
Rails was chosen just because it's the tool I'm most familiarized with so I could do things faster with it.

## How long did you spend on this exercise? If you had unlimited more time to spend on this, how would you spend it and how would you prioritize each item?
I spent 2 to 3 hours.

If I had unlimited time to work on this project I'l start search for tools and techniques that would make file reading faster. I'd also work on something to break large files into smaller chunks to enable multiple IO operations (since requests would read lines from different files).

In terms of organizing and prioritizing the work, I'd try to first focus on what would bring more value to users first. So maybe breaking files into smaller chunks would help the service to respond to more requests faster. Then I could focus on investigating how to improve the read operations.

## If you were to critique your code, what would you have to say about it?
It's a good starting point. It's well structured, tested and it'd be easy to maintain.
If it was a real project, the memory cache should be improved and probably extracted to something like Redis and it should also have a cache expire mechanism
