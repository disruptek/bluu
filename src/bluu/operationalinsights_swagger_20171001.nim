
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Log Analytics
## version: 2017-10-01
## termsOfService: https://dev.loganalytics.io/tos
## license:
##     name: Microsoft
##     url: https://dev.loganalytics.io/license
## 
## This API exposes Azure Log Analytics query capabilities
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "operationalinsights-swagger"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_QueryExecute_593976 = ref object of OpenApiRestCall_593425
proc url_QueryExecute_593978(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryExecute_593977(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Executes an Analytics query for data. [Here](https://dev.loganalytics.io/documentation/Using-the-API) is an example for using POST with an Analytics query.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceName: JString (required)
  ##                : Name of the Log Analytics workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593979 = path.getOrDefault("resourceGroupName")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "resourceGroupName", valid_593979
  var valid_593980 = path.getOrDefault("subscriptionId")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "subscriptionId", valid_593980
  var valid_593981 = path.getOrDefault("workspaceName")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "workspaceName", valid_593981
  result.add "path", section
  ## parameters in `query` object:
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_593982 = query.getOrDefault("apiVersion")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = newJString("2017-10-01"))
  if valid_593982 != nil:
    section.add "apiVersion", valid_593982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The Analytics query. Learn more about the [Analytics query 
  ## syntax](https://azure.microsoft.com/documentation/articles/app-insights-analytics-reference/)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593984: Call_QueryExecute_593976; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes an Analytics query for data. [Here](https://dev.loganalytics.io/documentation/Using-the-API) is an example for using POST with an Analytics query.
  ## 
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_QueryExecute_593976; resourceGroupName: string;
          subscriptionId: string; body: JsonNode; workspaceName: string;
          apiVersion: string = "2017-10-01"): Recallable =
  ## queryExecute
  ## Executes an Analytics query for data. [Here](https://dev.loganalytics.io/documentation/Using-the-API) is an example for using POST with an Analytics query.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   body: JObject (required)
  ##       : The Analytics query. Learn more about the [Analytics query 
  ## syntax](https://azure.microsoft.com/documentation/articles/app-insights-analytics-reference/)
  ##   workspaceName: string (required)
  ##                : Name of the Log Analytics workspace.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var path_593986 = newJObject()
  var query_593987 = newJObject()
  var body_593988 = newJObject()
  add(path_593986, "resourceGroupName", newJString(resourceGroupName))
  add(path_593986, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_593988 = body
  add(path_593986, "workspaceName", newJString(workspaceName))
  add(query_593987, "apiVersion", newJString(apiVersion))
  result = call_593985.call(path_593986, query_593987, nil, nil, body_593988)

var queryExecute* = Call_QueryExecute_593976(name: "queryExecute",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/query",
    validator: validate_QueryExecute_593977, base: "", url: url_QueryExecute_593978,
    schemes: {Scheme.Https})
type
  Call_QueryGet_593647 = ref object of OpenApiRestCall_593425
proc url_QueryGet_593649(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.OperationalInsights/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryGet_593648(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Executes an Analytics query for data
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceName: JString (required)
  ##                : Name of the Log Analytics workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593822 = path.getOrDefault("resourceGroupName")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "resourceGroupName", valid_593822
  var valid_593823 = path.getOrDefault("subscriptionId")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "subscriptionId", valid_593823
  var valid_593824 = path.getOrDefault("workspaceName")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "workspaceName", valid_593824
  result.add "path", section
  ## parameters in `query` object:
  ##   query: JString (required)
  ##        : The Analytics query. Learn more about the [Analytics query 
  ## syntax](https://azure.microsoft.com/documentation/articles/app-insights-analytics-reference/)
  ##   timespan: JString
  ##           : Optional. The timespan over which to query data. This is an ISO8601 time period value.  This timespan is applied in addition to any that are specified in the query expression.
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `query` field"
  var valid_593825 = query.getOrDefault("query")
  valid_593825 = validateParameter(valid_593825, JString, required = true,
                                 default = nil)
  if valid_593825 != nil:
    section.add "query", valid_593825
  var valid_593826 = query.getOrDefault("timespan")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "timespan", valid_593826
  var valid_593840 = query.getOrDefault("apiVersion")
  valid_593840 = validateParameter(valid_593840, JString, required = true,
                                 default = newJString("2017-10-01"))
  if valid_593840 != nil:
    section.add "apiVersion", valid_593840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593863: Call_QueryGet_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes an Analytics query for data
  ## 
  let valid = call_593863.validator(path, query, header, formData, body)
  let scheme = call_593863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593863.url(scheme.get, call_593863.host, call_593863.base,
                         call_593863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593863, url, valid)

proc call*(call_593934: Call_QueryGet_593647; resourceGroupName: string;
          query: string; subscriptionId: string; workspaceName: string;
          timespan: string = ""; apiVersion: string = "2017-10-01"): Recallable =
  ## queryGet
  ## Executes an Analytics query for data
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   query: string (required)
  ##        : The Analytics query. Learn more about the [Analytics query 
  ## syntax](https://azure.microsoft.com/documentation/articles/app-insights-analytics-reference/)
  ##   timespan: string
  ##           : Optional. The timespan over which to query data. This is an ISO8601 time period value.  This timespan is applied in addition to any that are specified in the query expression.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceName: string (required)
  ##                : Name of the Log Analytics workspace.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var path_593935 = newJObject()
  var query_593937 = newJObject()
  add(path_593935, "resourceGroupName", newJString(resourceGroupName))
  add(query_593937, "query", newJString(query))
  add(query_593937, "timespan", newJString(timespan))
  add(path_593935, "subscriptionId", newJString(subscriptionId))
  add(path_593935, "workspaceName", newJString(workspaceName))
  add(query_593937, "apiVersion", newJString(apiVersion))
  result = call_593934.call(path_593935, query_593937, nil, nil, nil)

var queryGet* = Call_QueryGet_593647(name: "queryGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/query",
                                  validator: validate_QueryGet_593648, base: "",
                                  url: url_QueryGet_593649,
                                  schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
