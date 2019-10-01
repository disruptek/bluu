
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
  Call_QueryExecute_568209 = ref object of OpenApiRestCall_567658
proc url_QueryExecute_568211(protocol: Scheme; host: string; base: string;
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

proc validate_QueryExecute_568210(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568212 = path.getOrDefault("resourceGroupName")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "resourceGroupName", valid_568212
  var valid_568213 = path.getOrDefault("subscriptionId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "subscriptionId", valid_568213
  var valid_568214 = path.getOrDefault("workspaceName")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "workspaceName", valid_568214
  result.add "path", section
  ## parameters in `query` object:
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_568215 = query.getOrDefault("apiVersion")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = newJString("2017-10-01"))
  if valid_568215 != nil:
    section.add "apiVersion", valid_568215
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

proc call*(call_568217: Call_QueryExecute_568209; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes an Analytics query for data. [Here](https://dev.loganalytics.io/documentation/Using-the-API) is an example for using POST with an Analytics query.
  ## 
  let valid = call_568217.validator(path, query, header, formData, body)
  let scheme = call_568217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568217.url(scheme.get, call_568217.host, call_568217.base,
                         call_568217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568217, url, valid)

proc call*(call_568218: Call_QueryExecute_568209; resourceGroupName: string;
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
  var path_568219 = newJObject()
  var query_568220 = newJObject()
  var body_568221 = newJObject()
  add(path_568219, "resourceGroupName", newJString(resourceGroupName))
  add(path_568219, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_568221 = body
  add(path_568219, "workspaceName", newJString(workspaceName))
  add(query_568220, "apiVersion", newJString(apiVersion))
  result = call_568218.call(path_568219, query_568220, nil, nil, body_568221)

var queryExecute* = Call_QueryExecute_568209(name: "queryExecute",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/query",
    validator: validate_QueryExecute_568210, base: "", url: url_QueryExecute_568211,
    schemes: {Scheme.Https})
type
  Call_QueryGet_567880 = ref object of OpenApiRestCall_567658
proc url_QueryGet_567882(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_QueryGet_567881(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568055 = path.getOrDefault("resourceGroupName")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "resourceGroupName", valid_568055
  var valid_568056 = path.getOrDefault("subscriptionId")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "subscriptionId", valid_568056
  var valid_568057 = path.getOrDefault("workspaceName")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "workspaceName", valid_568057
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
  var valid_568058 = query.getOrDefault("query")
  valid_568058 = validateParameter(valid_568058, JString, required = true,
                                 default = nil)
  if valid_568058 != nil:
    section.add "query", valid_568058
  var valid_568059 = query.getOrDefault("timespan")
  valid_568059 = validateParameter(valid_568059, JString, required = false,
                                 default = nil)
  if valid_568059 != nil:
    section.add "timespan", valid_568059
  var valid_568073 = query.getOrDefault("apiVersion")
  valid_568073 = validateParameter(valid_568073, JString, required = true,
                                 default = newJString("2017-10-01"))
  if valid_568073 != nil:
    section.add "apiVersion", valid_568073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568096: Call_QueryGet_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes an Analytics query for data
  ## 
  let valid = call_568096.validator(path, query, header, formData, body)
  let scheme = call_568096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568096.url(scheme.get, call_568096.host, call_568096.base,
                         call_568096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568096, url, valid)

proc call*(call_568167: Call_QueryGet_567880; resourceGroupName: string;
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
  var path_568168 = newJObject()
  var query_568170 = newJObject()
  add(path_568168, "resourceGroupName", newJString(resourceGroupName))
  add(query_568170, "query", newJString(query))
  add(query_568170, "timespan", newJString(timespan))
  add(path_568168, "subscriptionId", newJString(subscriptionId))
  add(path_568168, "workspaceName", newJString(workspaceName))
  add(query_568170, "apiVersion", newJString(apiVersion))
  result = call_568167.call(path_568168, query_568170, nil, nil, nil)

var queryGet* = Call_QueryGet_567880(name: "queryGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/query",
                                  validator: validate_QueryGet_567881, base: "",
                                  url: url_QueryGet_567882,
                                  schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
