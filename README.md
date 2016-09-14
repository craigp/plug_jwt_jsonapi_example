# Simple API Example/Template

This is a very simple and rather contrived example/template for using Cowboy &
Plug to build a very simple HTTP API that uses JSON Web Tokens and JSON API.
There's a lot missing, like proper authentication and user management and it's
probably not completely true to either standard; it was really just an exercise
to see what I could do with minimal dependencies. I thought I'd throw it up
here in case it's useful to someone else.

The server runs on port 4002, and it resets the secret key on each restart, so
if you restart it you'll need to login to create a new token. The "login" in
this case is simply a call to the `login/` endpoint with acceptable content
headers. Not using acceptable content headers will give you an `HTTP/415` error.

```bash
curl -v localhost:4002/login -H "content-type:application/vnd.api+json" -H "accept:application/*"

* Connected to localhost (127.0.0.1) port 4002 (#0)
> GET /login HTTP/1.1
> Host: localhost:4002
> User-Agent: curl/7.43.0
> content-type:application/vnd.api+json
> accept:fml/text,application/*
>
< HTTP/1.1 200 OK
< server: Cowboy
< date: Wed, 14 Sep 2016 09:49:27 GMT
< content-length: 0
< cache-control: max-age=0, private, must-revalidate
< authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ1c2VyOmNyYWlncCIsImV4cCI6MTQ3NjQzODU2NywiaWF0IjoxNDczODQ2NTY3LCJpc3MiOiJQbHVnSnd0SnNvbmFwaUV4YW1wbGUiLCJqdGkiOiI4M2Q2OTZkNS1mMDZmLTQ5MjgtOTJiYS01MTU4Mjg5NzBjYzciLCJwZW0iOnt9LCJzdWIiOiJ1c2VyOmNyYWlncCIsInR5cCI6InRva2VuIn0.dkkTBKgofssqNqVVGQxIrpiZULCtwPRg7wj6RrG9Nr_rkYiOp84qYy3yEccf_VqL6Vner2LtP1hPG8rNpULPJg
< x-expires: 1476438567
< content-type: application/vnd.api+json
<
* Connection #0 to host localhost left intact
```

The token comes back in the `Authorization` header, which you can then use to call the `test/` endpoint.

```bash
curl -v localhost:4002/test -H "content-type:application/vnd.api+json" -H "accept:application/*" -H "Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ1c2VyOmNyYWlncCIsImV4cCI6MTQ3NjQzODU2NywiaWF0IjoxNDczODQ2NTY3LCJpc3MiOiJQbHVnSnd0SnNvbmFwaUV4YW1wbGUiLCJqdGkiOiI4M2Q2OTZkNS1mMDZmLTQ5MjgtOTJiYS01MTU4Mjg5NzBjYzciLCJwZW0iOnt9LCJzdWIiOiJ1c2VyOmNyYWlncCIsInR5cCI6InRva2VuIn0.dkkTBKgofssqNqVVGQxIrpiZULCtwPRg7wj6RrG9Nr_rkYiOp84qYy3yEccf_VqL6Vner2LtP1hPG8rNpULPJg"

* Connected to localhost (127.0.0.1) port 4002 (#0)
> GET /test HTTP/1.1
> Host: localhost:4002
> User-Agent: curl/7.43.0
> content-type:application/vnd.api+json
> accept:fml/text,application/*
> Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ1c2VyOmNyYWlncCIsImV4cCI6MTQ3NjQzODU2NywiaWF0IjoxNDczODQ2NTY3LCJpc3MiOiJQbHVnSnd0SnNvbmFwaUV4YW1wbGUiLCJqdGkiOiI4M2Q2OTZkNS1mMDZmLTQ5MjgtOTJiYS01MTU4Mjg5NzBjYzciLCJwZW0iOnt9LCJzdWIiOiJ1c2VyOmNyYWlncCIsInR5cCI6InRva2VuIn0.dkkTBKgofssqNqVVGQxIrpiZULCtwPRg7wj6RrG9Nr_rkYiOp84qYy3yEccf_VqL6Vner2LtP1hPG8rNpULPJg
>
< HTTP/1.1 200 OK
< server: Cowboy
< date: Wed, 14 Sep 2016 09:49:38 GMT
< content-length: 2
< cache-control: max-age=0, private, must-revalidate
< content-type: application/vnd.api+json
<
* Connection #0 to host localhost left intact
OK%
```

As expected, if you call it without a token or with the wrong token, it will return an `HTTP/401` error.

```bash
curl -v localhost:4002/test -H "content-type:application/vnd.api+json" -H "accept:application/*" -H "Authorization: Bearer NOT_MY_TOKEN"

* Connected to localhost (127.0.0.1) port 4002 (#0)
> GET /test HTTP/1.1
> Host: localhost:4002
> User-Agent: curl/7.43.0
> content-type:application/vnd.api+json
> accept:fml/text,application/*
> Authorization: Bearer NOT_MY_TOKEN
>
< HTTP/1.1 401 Unauthorized
< server: Cowboy
< date: Wed, 14 Sep 2016 09:55:23 GMT
< content-length: 0
< cache-control: max-age=0, private, must-revalidate
< content-type: application/vnd.api+json
<
* Connection #0 to host localhost left intact
```

