using JSON, Requests

first_request = get("https://adventofcode.com/2021/day/2/input")
request_json = JSON.parse(first_request.data)

println(request_json)