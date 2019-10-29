
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: CommerceManagementClient
## version: 2015-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Admin Commerce Management Client.
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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-CommerceAdmin"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SubscriberUsageAggregatesList_563761 = ref object of OpenApiRestCall_563539
proc url_SubscriberUsageAggregatesList_563763(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Commerce/subscriberUsageAggregates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriberUsageAggregatesList_563762(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a collection of SubscriberUsageAggregates, which are UsageAggregates from direct tenants.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563938 = path.getOrDefault("subscriptionId")
  valid_563938 = validateParameter(valid_563938, JString, required = true,
                                 default = nil)
  if valid_563938 != nil:
    section.add "subscriptionId", valid_563938
  result.add "path", section
  ## parameters in `query` object:
  ##   reportedStartTime: JString (required)
  ##                    : The reported start time (inclusive).
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   aggregationGranularity: JString
  ##                         : The aggregation granularity.
  ##   continuationToken: JString
  ##                    : The continuation token.
  ##   reportedEndTime: JString (required)
  ##                  : The reported end time (exclusive).
  ##   subscriberId: JString
  ##               : The tenant subscription identifier.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `reportedStartTime` field"
  var valid_563939 = query.getOrDefault("reportedStartTime")
  valid_563939 = validateParameter(valid_563939, JString, required = true,
                                 default = nil)
  if valid_563939 != nil:
    section.add "reportedStartTime", valid_563939
  var valid_563953 = query.getOrDefault("api-version")
  valid_563953 = validateParameter(valid_563953, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_563953 != nil:
    section.add "api-version", valid_563953
  var valid_563954 = query.getOrDefault("aggregationGranularity")
  valid_563954 = validateParameter(valid_563954, JString, required = false,
                                 default = nil)
  if valid_563954 != nil:
    section.add "aggregationGranularity", valid_563954
  var valid_563955 = query.getOrDefault("continuationToken")
  valid_563955 = validateParameter(valid_563955, JString, required = false,
                                 default = nil)
  if valid_563955 != nil:
    section.add "continuationToken", valid_563955
  var valid_563956 = query.getOrDefault("reportedEndTime")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "reportedEndTime", valid_563956
  var valid_563957 = query.getOrDefault("subscriberId")
  valid_563957 = validateParameter(valid_563957, JString, required = false,
                                 default = nil)
  if valid_563957 != nil:
    section.add "subscriberId", valid_563957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563980: Call_SubscriberUsageAggregatesList_563761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a collection of SubscriberUsageAggregates, which are UsageAggregates from direct tenants.
  ## 
  let valid = call_563980.validator(path, query, header, formData, body)
  let scheme = call_563980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563980.url(scheme.get, call_563980.host, call_563980.base,
                         call_563980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563980, url, valid)

proc call*(call_564051: Call_SubscriberUsageAggregatesList_563761;
          reportedStartTime: string; subscriptionId: string;
          reportedEndTime: string; apiVersion: string = "2015-06-01-preview";
          aggregationGranularity: string = ""; continuationToken: string = "";
          subscriberId: string = ""): Recallable =
  ## subscriberUsageAggregatesList
  ## Gets a collection of SubscriberUsageAggregates, which are UsageAggregates from direct tenants.
  ##   reportedStartTime: string (required)
  ##                    : The reported start time (inclusive).
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   aggregationGranularity: string
  ##                         : The aggregation granularity.
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   reportedEndTime: string (required)
  ##                  : The reported end time (exclusive).
  ##   subscriberId: string
  ##               : The tenant subscription identifier.
  var path_564052 = newJObject()
  var query_564054 = newJObject()
  add(query_564054, "reportedStartTime", newJString(reportedStartTime))
  add(query_564054, "api-version", newJString(apiVersion))
  add(path_564052, "subscriptionId", newJString(subscriptionId))
  add(query_564054, "aggregationGranularity", newJString(aggregationGranularity))
  add(query_564054, "continuationToken", newJString(continuationToken))
  add(query_564054, "reportedEndTime", newJString(reportedEndTime))
  add(query_564054, "subscriberId", newJString(subscriberId))
  result = call_564051.call(path_564052, query_564054, nil, nil, nil)

var subscriberUsageAggregatesList* = Call_SubscriberUsageAggregatesList_563761(
    name: "subscriberUsageAggregatesList", meth: HttpMethod.HttpGet,
    host: "management.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Commerce/subscriberUsageAggregates",
    validator: validate_SubscriberUsageAggregatesList_563762, base: "",
    url: url_SubscriberUsageAggregatesList_563763, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
