
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
  macServiceName = "azsadmin-Commerce"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563761 = ref object of OpenApiRestCall_563539
proc url_OperationsList_563763(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563762(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns the list of supported REST operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563937 = query.getOrDefault("api-version")
  valid_563937 = validateParameter(valid_563937, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_563937 != nil:
    section.add "api-version", valid_563937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563960: Call_OperationsList_563761; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of supported REST operations.
  ## 
  let valid = call_563960.validator(path, query, header, formData, body)
  let scheme = call_563960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563960.url(scheme.get, call_563960.host, call_563960.base,
                         call_563960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563960, url, valid)

proc call*(call_564031: Call_OperationsList_563761;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## operationsList
  ## Returns the list of supported REST operations.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_564032 = newJObject()
  add(query_564032, "api-version", newJString(apiVersion))
  result = call_564031.call(nil, query_564032, nil, nil, nil)

var operationsList* = Call_OperationsList_563761(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external",
    route: "/providers/Microsoft.Commerce.Admin/operations",
    validator: validate_OperationsList_563762, base: "", url: url_OperationsList_563763,
    schemes: {Scheme.Https})
type
  Call_SubscriberUsageAggregatesList_564072 = ref object of OpenApiRestCall_563539
proc url_SubscriberUsageAggregatesList_564074(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Commerce.Admin/subscriberUsageAggregates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SubscriberUsageAggregatesList_564073(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a collection of SubscriberUsageAggregates, which are UsageAggregates from users.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564089 = path.getOrDefault("subscriptionId")
  valid_564089 = validateParameter(valid_564089, JString, required = true,
                                 default = nil)
  if valid_564089 != nil:
    section.add "subscriptionId", valid_564089
  result.add "path", section
  ## parameters in `query` object:
  ##   reportedStartTime: JString (required)
  ##                    : The reported start time (inclusive).
  ##   api-version: JString (required)
  ##              : Client API Version.
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
  var valid_564090 = query.getOrDefault("reportedStartTime")
  valid_564090 = validateParameter(valid_564090, JString, required = true,
                                 default = nil)
  if valid_564090 != nil:
    section.add "reportedStartTime", valid_564090
  var valid_564091 = query.getOrDefault("api-version")
  valid_564091 = validateParameter(valid_564091, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_564091 != nil:
    section.add "api-version", valid_564091
  var valid_564092 = query.getOrDefault("aggregationGranularity")
  valid_564092 = validateParameter(valid_564092, JString, required = false,
                                 default = nil)
  if valid_564092 != nil:
    section.add "aggregationGranularity", valid_564092
  var valid_564093 = query.getOrDefault("continuationToken")
  valid_564093 = validateParameter(valid_564093, JString, required = false,
                                 default = nil)
  if valid_564093 != nil:
    section.add "continuationToken", valid_564093
  var valid_564094 = query.getOrDefault("reportedEndTime")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "reportedEndTime", valid_564094
  var valid_564095 = query.getOrDefault("subscriberId")
  valid_564095 = validateParameter(valid_564095, JString, required = false,
                                 default = nil)
  if valid_564095 != nil:
    section.add "subscriberId", valid_564095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564096: Call_SubscriberUsageAggregatesList_564072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a collection of SubscriberUsageAggregates, which are UsageAggregates from users.
  ## 
  let valid = call_564096.validator(path, query, header, formData, body)
  let scheme = call_564096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564096.url(scheme.get, call_564096.host, call_564096.base,
                         call_564096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564096, url, valid)

proc call*(call_564097: Call_SubscriberUsageAggregatesList_564072;
          reportedStartTime: string; subscriptionId: string;
          reportedEndTime: string; apiVersion: string = "2015-06-01-preview";
          aggregationGranularity: string = ""; continuationToken: string = "";
          subscriberId: string = ""): Recallable =
  ## subscriberUsageAggregatesList
  ## Gets a collection of SubscriberUsageAggregates, which are UsageAggregates from users.
  ##   reportedStartTime: string (required)
  ##                    : The reported start time (inclusive).
  ##   apiVersion: string (required)
  ##             : Client API Version.
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
  var path_564098 = newJObject()
  var query_564099 = newJObject()
  add(query_564099, "reportedStartTime", newJString(reportedStartTime))
  add(query_564099, "api-version", newJString(apiVersion))
  add(path_564098, "subscriptionId", newJString(subscriptionId))
  add(query_564099, "aggregationGranularity", newJString(aggregationGranularity))
  add(query_564099, "continuationToken", newJString(continuationToken))
  add(query_564099, "reportedEndTime", newJString(reportedEndTime))
  add(query_564099, "subscriberId", newJString(subscriberId))
  result = call_564097.call(path_564098, query_564099, nil, nil, nil)

var subscriberUsageAggregatesList* = Call_SubscriberUsageAggregatesList_564072(
    name: "subscriberUsageAggregatesList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Commerce.Admin/subscriberUsageAggregates",
    validator: validate_SubscriberUsageAggregatesList_564073, base: "",
    url: url_SubscriberUsageAggregatesList_564074, schemes: {Scheme.Https})
type
  Call_UpdateEncryption_564100 = ref object of OpenApiRestCall_563539
proc url_UpdateEncryption_564102(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Commerce.Admin/updateEncryption")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateEncryption_564101(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Update the encryption.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564103 = path.getOrDefault("subscriptionId")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "subscriptionId", valid_564103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564104 = query.getOrDefault("api-version")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_564104 != nil:
    section.add "api-version", valid_564104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564105: Call_UpdateEncryption_564100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the encryption.
  ## 
  let valid = call_564105.validator(path, query, header, formData, body)
  let scheme = call_564105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564105.url(scheme.get, call_564105.host, call_564105.base,
                         call_564105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564105, url, valid)

proc call*(call_564106: Call_UpdateEncryption_564100; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## updateEncryption
  ## Update the encryption.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  var path_564107 = newJObject()
  var query_564108 = newJObject()
  add(query_564108, "api-version", newJString(apiVersion))
  add(path_564107, "subscriptionId", newJString(subscriptionId))
  result = call_564106.call(path_564107, query_564108, nil, nil, nil)

var updateEncryption* = Call_UpdateEncryption_564100(name: "updateEncryption",
    meth: HttpMethod.HttpPost, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Commerce.Admin/updateEncryption",
    validator: validate_UpdateEncryption_564101, base: "",
    url: url_UpdateEncryption_564102, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
