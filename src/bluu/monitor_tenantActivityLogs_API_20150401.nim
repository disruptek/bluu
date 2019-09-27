
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: MonitorManagementClient
## version: 2015-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  macServiceName = "monitor-tenantActivityLogs_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_TenantActivityLogsList_593630 = ref object of OpenApiRestCall_593408
proc url_TenantActivityLogsList_593632(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_TenantActivityLogsList_593631(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the Activity Logs for the Tenant.<br>Everything that is applicable to the API to get the Activity Logs for the subscription is applicable to this API (the parameters, $filter, etc.).<br>One thing to point out here is that this API does *not* retrieve the logs at the individual subscription of the tenant but only surfaces the logs that were generated at the tenant level.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : Used to fetch events with only the given properties.<br>The **$select** argument is a comma separated list of property names to be returned. Possible values are: *authorization*, *claims*, *correlationId*, *description*, *eventDataId*, *eventName*, *eventTimestamp*, *httpRequest*, *level*, *operationId*, *operationName*, *properties*, *resourceGroupName*, *resourceProviderName*, *resourceId*, *status*, *submissionTimestamp*, *subStatus*, *subscriptionId*
  ##   $filter: JString
  ##          : Reduces the set of data collected. <br>The **$filter** is very restricted and allows only the following patterns.<br>- List events for a resource group: $filter=eventTimestamp ge '<Start Time>' and eventTimestamp le '<End Time>' and eventChannels eq 'Admin, Operation' and resourceGroupName eq '<ResourceGroupName>'.<br>- List events for resource: $filter=eventTimestamp ge '<Start Time>' and eventTimestamp le '<End Time>' and eventChannels eq 'Admin, Operation' and resourceUri eq '<ResourceURI>'.<br>- List events for a subscription: $filter=eventTimestamp ge '<Start Time>' and eventTimestamp le '<End Time>' and eventChannels eq 'Admin, Operation'.<br>- List events for a resource provider: $filter=eventTimestamp ge '<Start Time>' and eventTimestamp le '<End Time>' and eventChannels eq 'Admin, Operation' and resourceProvider eq '<ResourceProviderName>'.<br>- List events for a correlation Id: api-version=2014-04-01&$filter=eventTimestamp ge '2014-07-16T04:36:37.6407898Z' and eventTimestamp le '2014-07-20T04:36:37.6407898Z' and eventChannels eq 'Admin, Operation' and correlationId eq '<CorrelationID>'.<br>**NOTE**: No other syntax is allowed.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593792 = query.getOrDefault("api-version")
  valid_593792 = validateParameter(valid_593792, JString, required = true,
                                 default = nil)
  if valid_593792 != nil:
    section.add "api-version", valid_593792
  var valid_593793 = query.getOrDefault("$select")
  valid_593793 = validateParameter(valid_593793, JString, required = false,
                                 default = nil)
  if valid_593793 != nil:
    section.add "$select", valid_593793
  var valid_593794 = query.getOrDefault("$filter")
  valid_593794 = validateParameter(valid_593794, JString, required = false,
                                 default = nil)
  if valid_593794 != nil:
    section.add "$filter", valid_593794
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593817: Call_TenantActivityLogsList_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Activity Logs for the Tenant.<br>Everything that is applicable to the API to get the Activity Logs for the subscription is applicable to this API (the parameters, $filter, etc.).<br>One thing to point out here is that this API does *not* retrieve the logs at the individual subscription of the tenant but only surfaces the logs that were generated at the tenant level.
  ## 
  let valid = call_593817.validator(path, query, header, formData, body)
  let scheme = call_593817.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593817.url(scheme.get, call_593817.host, call_593817.base,
                         call_593817.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593817, url, valid)

proc call*(call_593888: Call_TenantActivityLogsList_593630; apiVersion: string;
          Select: string = ""; Filter: string = ""): Recallable =
  ## tenantActivityLogsList
  ## Gets the Activity Logs for the Tenant.<br>Everything that is applicable to the API to get the Activity Logs for the subscription is applicable to this API (the parameters, $filter, etc.).<br>One thing to point out here is that this API does *not* retrieve the logs at the individual subscription of the tenant but only surfaces the logs that were generated at the tenant level.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : Used to fetch events with only the given properties.<br>The **$select** argument is a comma separated list of property names to be returned. Possible values are: *authorization*, *claims*, *correlationId*, *description*, *eventDataId*, *eventName*, *eventTimestamp*, *httpRequest*, *level*, *operationId*, *operationName*, *properties*, *resourceGroupName*, *resourceProviderName*, *resourceId*, *status*, *submissionTimestamp*, *subStatus*, *subscriptionId*
  ##   Filter: string
  ##         : Reduces the set of data collected. <br>The **$filter** is very restricted and allows only the following patterns.<br>- List events for a resource group: $filter=eventTimestamp ge '<Start Time>' and eventTimestamp le '<End Time>' and eventChannels eq 'Admin, Operation' and resourceGroupName eq '<ResourceGroupName>'.<br>- List events for resource: $filter=eventTimestamp ge '<Start Time>' and eventTimestamp le '<End Time>' and eventChannels eq 'Admin, Operation' and resourceUri eq '<ResourceURI>'.<br>- List events for a subscription: $filter=eventTimestamp ge '<Start Time>' and eventTimestamp le '<End Time>' and eventChannels eq 'Admin, Operation'.<br>- List events for a resource provider: $filter=eventTimestamp ge '<Start Time>' and eventTimestamp le '<End Time>' and eventChannels eq 'Admin, Operation' and resourceProvider eq '<ResourceProviderName>'.<br>- List events for a correlation Id: api-version=2014-04-01&$filter=eventTimestamp ge '2014-07-16T04:36:37.6407898Z' and eventTimestamp le '2014-07-20T04:36:37.6407898Z' and eventChannels eq 'Admin, Operation' and correlationId eq '<CorrelationID>'.<br>**NOTE**: No other syntax is allowed.
  var query_593889 = newJObject()
  add(query_593889, "api-version", newJString(apiVersion))
  add(query_593889, "$select", newJString(Select))
  add(query_593889, "$filter", newJString(Filter))
  result = call_593888.call(nil, query_593889, nil, nil, nil)

var tenantActivityLogsList* = Call_TenantActivityLogsList_593630(
    name: "tenantActivityLogsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/microsoft.insights/eventtypes/management/values",
    validator: validate_TenantActivityLogsList_593631, base: "",
    url: url_TenantActivityLogsList_593632, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
