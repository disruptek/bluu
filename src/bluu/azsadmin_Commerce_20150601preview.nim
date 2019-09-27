
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
  macServiceName = "azsadmin-Commerce"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593630 = ref object of OpenApiRestCall_593408
proc url_OperationsList_593632(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593631(path: JsonNode; query: JsonNode;
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
  var valid_593804 = query.getOrDefault("api-version")
  valid_593804 = validateParameter(valid_593804, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_593804 != nil:
    section.add "api-version", valid_593804
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593827: Call_OperationsList_593630; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of supported REST operations.
  ## 
  let valid = call_593827.validator(path, query, header, formData, body)
  let scheme = call_593827.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593827.url(scheme.get, call_593827.host, call_593827.base,
                         call_593827.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593827, url, valid)

proc call*(call_593898: Call_OperationsList_593630;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## operationsList
  ## Returns the list of supported REST operations.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  var query_593899 = newJObject()
  add(query_593899, "api-version", newJString(apiVersion))
  result = call_593898.call(nil, query_593899, nil, nil, nil)

var operationsList* = Call_OperationsList_593630(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external",
    route: "/providers/Microsoft.Commerce.Admin/operations",
    validator: validate_OperationsList_593631, base: "", url: url_OperationsList_593632,
    schemes: {Scheme.Https})
type
  Call_SubscriberUsageAggregatesList_593939 = ref object of OpenApiRestCall_593408
proc url_SubscriberUsageAggregatesList_593941(protocol: Scheme; host: string;
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

proc validate_SubscriberUsageAggregatesList_593940(path: JsonNode; query: JsonNode;
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
  var valid_593956 = path.getOrDefault("subscriptionId")
  valid_593956 = validateParameter(valid_593956, JString, required = true,
                                 default = nil)
  if valid_593956 != nil:
    section.add "subscriptionId", valid_593956
  result.add "path", section
  ## parameters in `query` object:
  ##   subscriberId: JString
  ##               : The tenant subscription identifier.
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   reportedStartTime: JString (required)
  ##                    : The reported start time (inclusive).
  ##   reportedEndTime: JString (required)
  ##                  : The reported end time (exclusive).
  ##   continuationToken: JString
  ##                    : The continuation token.
  ##   aggregationGranularity: JString
  ##                         : The aggregation granularity.
  section = newJObject()
  var valid_593957 = query.getOrDefault("subscriberId")
  valid_593957 = validateParameter(valid_593957, JString, required = false,
                                 default = nil)
  if valid_593957 != nil:
    section.add "subscriberId", valid_593957
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593958 = query.getOrDefault("api-version")
  valid_593958 = validateParameter(valid_593958, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_593958 != nil:
    section.add "api-version", valid_593958
  var valid_593959 = query.getOrDefault("reportedStartTime")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "reportedStartTime", valid_593959
  var valid_593960 = query.getOrDefault("reportedEndTime")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "reportedEndTime", valid_593960
  var valid_593961 = query.getOrDefault("continuationToken")
  valid_593961 = validateParameter(valid_593961, JString, required = false,
                                 default = nil)
  if valid_593961 != nil:
    section.add "continuationToken", valid_593961
  var valid_593962 = query.getOrDefault("aggregationGranularity")
  valid_593962 = validateParameter(valid_593962, JString, required = false,
                                 default = nil)
  if valid_593962 != nil:
    section.add "aggregationGranularity", valid_593962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593963: Call_SubscriberUsageAggregatesList_593939; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a collection of SubscriberUsageAggregates, which are UsageAggregates from users.
  ## 
  let valid = call_593963.validator(path, query, header, formData, body)
  let scheme = call_593963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593963.url(scheme.get, call_593963.host, call_593963.base,
                         call_593963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593963, url, valid)

proc call*(call_593964: Call_SubscriberUsageAggregatesList_593939;
          subscriptionId: string; reportedStartTime: string;
          reportedEndTime: string; subscriberId: string = "";
          apiVersion: string = "2015-06-01-preview"; continuationToken: string = "";
          aggregationGranularity: string = ""): Recallable =
  ## subscriberUsageAggregatesList
  ## Gets a collection of SubscriberUsageAggregates, which are UsageAggregates from users.
  ##   subscriberId: string
  ##               : The tenant subscription identifier.
  ##   apiVersion: string (required)
  ##             : Client API Version.
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
  var path_593965 = newJObject()
  var query_593966 = newJObject()
  add(query_593966, "subscriberId", newJString(subscriberId))
  add(query_593966, "api-version", newJString(apiVersion))
  add(path_593965, "subscriptionId", newJString(subscriptionId))
  add(query_593966, "reportedStartTime", newJString(reportedStartTime))
  add(query_593966, "reportedEndTime", newJString(reportedEndTime))
  add(query_593966, "continuationToken", newJString(continuationToken))
  add(query_593966, "aggregationGranularity", newJString(aggregationGranularity))
  result = call_593964.call(path_593965, query_593966, nil, nil, nil)

var subscriberUsageAggregatesList* = Call_SubscriberUsageAggregatesList_593939(
    name: "subscriberUsageAggregatesList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Commerce.Admin/subscriberUsageAggregates",
    validator: validate_SubscriberUsageAggregatesList_593940, base: "",
    url: url_SubscriberUsageAggregatesList_593941, schemes: {Scheme.Https})
type
  Call_UpdateEncryption_593967 = ref object of OpenApiRestCall_593408
proc url_UpdateEncryption_593969(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateEncryption_593968(path: JsonNode; query: JsonNode;
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
  var valid_593970 = path.getOrDefault("subscriptionId")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "subscriptionId", valid_593970
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593971 = query.getOrDefault("api-version")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = newJString("2015-06-01-preview"))
  if valid_593971 != nil:
    section.add "api-version", valid_593971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593972: Call_UpdateEncryption_593967; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the encryption.
  ## 
  let valid = call_593972.validator(path, query, header, formData, body)
  let scheme = call_593972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593972.url(scheme.get, call_593972.host, call_593972.base,
                         call_593972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593972, url, valid)

proc call*(call_593973: Call_UpdateEncryption_593967; subscriptionId: string;
          apiVersion: string = "2015-06-01-preview"): Recallable =
  ## updateEncryption
  ## Update the encryption.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.The subscription ID forms part of the URI for every service call.
  var path_593974 = newJObject()
  var query_593975 = newJObject()
  add(query_593975, "api-version", newJString(apiVersion))
  add(path_593974, "subscriptionId", newJString(subscriptionId))
  result = call_593973.call(path_593974, query_593975, nil, nil, nil)

var updateEncryption* = Call_UpdateEncryption_593967(name: "updateEncryption",
    meth: HttpMethod.HttpPost, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Commerce.Admin/updateEncryption",
    validator: validate_UpdateEncryption_593968, base: "",
    url: url_UpdateEncryption_593969, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
