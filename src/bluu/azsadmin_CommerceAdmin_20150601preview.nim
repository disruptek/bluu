
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "azsadmin-CommerceAdmin"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SubscriberUsageAggregatesList_593630 = ref object of OpenApiRestCall_593408
proc url_SubscriberUsageAggregatesList_593632(protocol: Scheme; host: string;
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

proc validate_SubscriberUsageAggregatesList_593631(path: JsonNode; query: JsonNode;
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
  var valid_593805 = path.getOrDefault("subscriptionId")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "subscriptionId", valid_593805
  result.add "path", section
  ## parameters in `query` object:
  ##   subscriberId: JString
  ##               : The tenant subscription identifier.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   reportedStartTime: JString (required)
  ##                    : The reported start time (inclusive).
  ##   reportedEndTime: JString (required)
  ##                  : The reported end time (exclusive).
  ##   continuationToken: JString
  ##                    : The continuation token.
  ##   aggregationGranularity: JString
  ##                         : The aggregation granularity.
  section = newJObject()
  var valid_593806 = query.getOrDefault("subscriberId")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "subscriberId", valid_593806
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593820 = query.getOrDefault("api-version")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_593820 != nil:
    section.add "api-version", valid_593820
  var valid_593821 = query.getOrDefault("reportedStartTime")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "reportedStartTime", valid_593821
  var valid_593822 = query.getOrDefault("reportedEndTime")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "reportedEndTime", valid_593822
  var valid_593823 = query.getOrDefault("continuationToken")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "continuationToken", valid_593823
  var valid_593824 = query.getOrDefault("aggregationGranularity")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "aggregationGranularity", valid_593824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593847: Call_SubscriberUsageAggregatesList_593630; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a collection of SubscriberUsageAggregates, which are UsageAggregates from direct tenants.
  ## 
  let valid = call_593847.validator(path, query, header, formData, body)
  let scheme = call_593847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593847.url(scheme.get, call_593847.host, call_593847.base,
                         call_593847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593847, url, valid)

proc call*(call_593918: Call_SubscriberUsageAggregatesList_593630;
          subscriptionId: string; reportedStartTime: string;
          reportedEndTime: string; subscriberId: string = "";
          apiVersion: string = "2015-06-01-preview"; continuationToken: string = "";
          aggregationGranularity: string = ""): Recallable =
  ## subscriberUsageAggregatesList
  ## Gets a collection of SubscriberUsageAggregates, which are UsageAggregates from direct tenants.
  ##   subscriberId: string
  ##               : The tenant subscription identifier.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  ##   reportedStartTime: string (required)
  ##                    : The reported start time (inclusive).
  ##   reportedEndTime: string (required)
  ##                  : The reported end time (exclusive).
  ##   continuationToken: string
  ##                    : The continuation token.
  ##   aggregationGranularity: string
  ##                         : The aggregation granularity.
  var path_593919 = newJObject()
  var query_593921 = newJObject()
  add(query_593921, "subscriberId", newJString(subscriberId))
  add(query_593921, "api-version", newJString(apiVersion))
  add(path_593919, "subscriptionId", newJString(subscriptionId))
  add(query_593921, "reportedStartTime", newJString(reportedStartTime))
  add(query_593921, "reportedEndTime", newJString(reportedEndTime))
  add(query_593921, "continuationToken", newJString(continuationToken))
  add(query_593921, "aggregationGranularity", newJString(aggregationGranularity))
  result = call_593918.call(path_593919, query_593921, nil, nil, nil)

var subscriberUsageAggregatesList* = Call_SubscriberUsageAggregatesList_593630(
    name: "subscriberUsageAggregatesList", meth: HttpMethod.HttpGet,
    host: "management.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Commerce/subscriberUsageAggregates",
    validator: validate_SubscriberUsageAggregatesList_593631, base: "",
    url: url_SubscriberUsageAggregatesList_593632, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
