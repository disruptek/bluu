
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ApiManagementClient
## version: 2016-10-10
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these REST APIs to get the analytics reports associated with your Azure API Management deployment.
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "apimanagement-apimreports"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ReportsListByService_563777 = ref object of OpenApiRestCall_563555
proc url_ReportsListByService_563779(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "aggregation" in path, "`aggregation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ApiManagement/service/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "aggregation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportsListByService_563778(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists report records.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The name of the API Management service.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   aggregation: JString (required)
  ##              : Report aggregation.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_563942 = path.getOrDefault("serviceName")
  valid_563942 = validateParameter(valid_563942, JString, required = true,
                                 default = nil)
  if valid_563942 != nil:
    section.add "serviceName", valid_563942
  var valid_563943 = path.getOrDefault("subscriptionId")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "subscriptionId", valid_563943
  var valid_563957 = path.getOrDefault("aggregation")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = newJString("byApi"))
  if valid_563957 != nil:
    section.add "aggregation", valid_563957
  var valid_563958 = path.getOrDefault("resourceGroupName")
  valid_563958 = validateParameter(valid_563958, JString, required = true,
                                 default = nil)
  if valid_563958 != nil:
    section.add "resourceGroupName", valid_563958
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : Number of records to return.
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request.
  ##   interval: JString
  ##           : By time interval. This value is only applicable to ByTime aggregation. Interval must be multiple of 15 minutes and may not be zero. The value should be in ISO  8601 format (http://en.wikipedia.org/wiki/ISO_8601#Durations).This code can be used to convert TimSpan to a valid interval string: XmlConvert.ToString(new TimeSpan(hours, minutes, seconds))
  ##   $skip: JInt
  ##        : Number of records to skip.
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_563959 = query.getOrDefault("$top")
  valid_563959 = validateParameter(valid_563959, JInt, required = false, default = nil)
  if valid_563959 != nil:
    section.add "$top", valid_563959
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563960 = query.getOrDefault("api-version")
  valid_563960 = validateParameter(valid_563960, JString, required = true,
                                 default = nil)
  if valid_563960 != nil:
    section.add "api-version", valid_563960
  var valid_563961 = query.getOrDefault("interval")
  valid_563961 = validateParameter(valid_563961, JString, required = false,
                                 default = nil)
  if valid_563961 != nil:
    section.add "interval", valid_563961
  var valid_563962 = query.getOrDefault("$skip")
  valid_563962 = validateParameter(valid_563962, JInt, required = false, default = nil)
  if valid_563962 != nil:
    section.add "$skip", valid_563962
  var valid_563963 = query.getOrDefault("$filter")
  valid_563963 = validateParameter(valid_563963, JString, required = false,
                                 default = nil)
  if valid_563963 != nil:
    section.add "$filter", valid_563963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563990: Call_ReportsListByService_563777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists report records.
  ## 
  let valid = call_563990.validator(path, query, header, formData, body)
  let scheme = call_563990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563990.url(scheme.get, call_563990.host, call_563990.base,
                         call_563990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563990, url, valid)

proc call*(call_564061: Call_ReportsListByService_563777; serviceName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; interval: string = ""; aggregation: string = "byApi"; Skip: int = 0;
          Filter: string = ""): Recallable =
  ## reportsListByService
  ## Lists report records.
  ##   serviceName: string (required)
  ##              : The name of the API Management service.
  ##   Top: int
  ##      : Number of records to return.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request.
  ##   interval: string
  ##           : By time interval. This value is only applicable to ByTime aggregation. Interval must be multiple of 15 minutes and may not be zero. The value should be in ISO  8601 format (http://en.wikipedia.org/wiki/ISO_8601#Durations).This code can be used to convert TimSpan to a valid interval string: XmlConvert.ToString(new TimeSpan(hours, minutes, seconds))
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   aggregation: string (required)
  ##              : Report aggregation.
  ##   Skip: int
  ##       : Number of records to skip.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_564062 = newJObject()
  var query_564064 = newJObject()
  add(path_564062, "serviceName", newJString(serviceName))
  add(query_564064, "$top", newJInt(Top))
  add(query_564064, "api-version", newJString(apiVersion))
  add(query_564064, "interval", newJString(interval))
  add(path_564062, "subscriptionId", newJString(subscriptionId))
  add(path_564062, "aggregation", newJString(aggregation))
  add(query_564064, "$skip", newJInt(Skip))
  add(path_564062, "resourceGroupName", newJString(resourceGroupName))
  add(query_564064, "$filter", newJString(Filter))
  result = call_564061.call(path_564062, query_564064, nil, nil, nil)

var reportsListByService* = Call_ReportsListByService_563777(
    name: "reportsListByService", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/{aggregation}",
    validator: validate_ReportsListByService_563778, base: "",
    url: url_ReportsListByService_563779, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
