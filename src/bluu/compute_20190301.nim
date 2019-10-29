
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ComputeManagementClient
## version: 2019-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Compute Management Client.
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

  OpenApiRestCall_563565 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563565](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563565): Option[Scheme] {.used.} =
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
  macServiceName = "compute"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563787 = ref object of OpenApiRestCall_563565
proc url_OperationsList_563789(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563788(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a list of compute operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563950 = query.getOrDefault("api-version")
  valid_563950 = validateParameter(valid_563950, JString, required = true,
                                 default = nil)
  if valid_563950 != nil:
    section.add "api-version", valid_563950
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563973: Call_OperationsList_563787; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of compute operations.
  ## 
  let valid = call_563973.validator(path, query, header, formData, body)
  let scheme = call_563973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563973.url(scheme.get, call_563973.host, call_563973.base,
                         call_563973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563973, url, valid)

proc call*(call_564044: Call_OperationsList_563787; apiVersion: string): Recallable =
  ## operationsList
  ## Gets a list of compute operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564045 = newJObject()
  add(query_564045, "api-version", newJString(apiVersion))
  result = call_564044.call(nil, query_564045, nil, nil, nil)

var operationsList* = Call_OperationsList_563787(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Compute/operations",
    validator: validate_OperationsList_563788, base: "", url: url_OperationsList_563789,
    schemes: {Scheme.Https})
type
  Call_AvailabilitySetsListBySubscription_564085 = ref object of OpenApiRestCall_563565
proc url_AvailabilitySetsListBySubscription_564087(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Compute/availabilitySets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilitySetsListBySubscription_564086(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all availability sets in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
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
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : The expand expression to apply to the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564104 = query.getOrDefault("api-version")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "api-version", valid_564104
  var valid_564105 = query.getOrDefault("$expand")
  valid_564105 = validateParameter(valid_564105, JString, required = false,
                                 default = nil)
  if valid_564105 != nil:
    section.add "$expand", valid_564105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564106: Call_AvailabilitySetsListBySubscription_564085;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all availability sets in a subscription.
  ## 
  let valid = call_564106.validator(path, query, header, formData, body)
  let scheme = call_564106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564106.url(scheme.get, call_564106.host, call_564106.base,
                         call_564106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564106, url, valid)

proc call*(call_564107: Call_AvailabilitySetsListBySubscription_564085;
          apiVersion: string; subscriptionId: string; Expand: string = ""): Recallable =
  ## availabilitySetsListBySubscription
  ## Lists all availability sets in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : The expand expression to apply to the operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564108 = newJObject()
  var query_564109 = newJObject()
  add(query_564109, "api-version", newJString(apiVersion))
  add(query_564109, "$expand", newJString(Expand))
  add(path_564108, "subscriptionId", newJString(subscriptionId))
  result = call_564107.call(path_564108, query_564109, nil, nil, nil)

var availabilitySetsListBySubscription* = Call_AvailabilitySetsListBySubscription_564085(
    name: "availabilitySetsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/availabilitySets",
    validator: validate_AvailabilitySetsListBySubscription_564086, base: "",
    url: url_AvailabilitySetsListBySubscription_564087, schemes: {Scheme.Https})
type
  Call_DedicatedHostGroupsListBySubscription_564110 = ref object of OpenApiRestCall_563565
proc url_DedicatedHostGroupsListBySubscription_564112(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/hostGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedHostGroupsListBySubscription_564111(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the dedicated host groups in the subscription. Use the nextLink property in the response to get the next page of dedicated host groups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564113 = path.getOrDefault("subscriptionId")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "subscriptionId", valid_564113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564114 = query.getOrDefault("api-version")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "api-version", valid_564114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564115: Call_DedicatedHostGroupsListBySubscription_564110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all of the dedicated host groups in the subscription. Use the nextLink property in the response to get the next page of dedicated host groups.
  ## 
  let valid = call_564115.validator(path, query, header, formData, body)
  let scheme = call_564115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564115.url(scheme.get, call_564115.host, call_564115.base,
                         call_564115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564115, url, valid)

proc call*(call_564116: Call_DedicatedHostGroupsListBySubscription_564110;
          apiVersion: string; subscriptionId: string): Recallable =
  ## dedicatedHostGroupsListBySubscription
  ## Lists all of the dedicated host groups in the subscription. Use the nextLink property in the response to get the next page of dedicated host groups.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564117 = newJObject()
  var query_564118 = newJObject()
  add(query_564118, "api-version", newJString(apiVersion))
  add(path_564117, "subscriptionId", newJString(subscriptionId))
  result = call_564116.call(path_564117, query_564118, nil, nil, nil)

var dedicatedHostGroupsListBySubscription* = Call_DedicatedHostGroupsListBySubscription_564110(
    name: "dedicatedHostGroupsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/hostGroups",
    validator: validate_DedicatedHostGroupsListBySubscription_564111, base: "",
    url: url_DedicatedHostGroupsListBySubscription_564112, schemes: {Scheme.Https})
type
  Call_ImagesList_564119 = ref object of OpenApiRestCall_563565
proc url_ImagesList_564121(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/images")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ImagesList_564120(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of Images in the subscription. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564122 = path.getOrDefault("subscriptionId")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = nil)
  if valid_564122 != nil:
    section.add "subscriptionId", valid_564122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564123 = query.getOrDefault("api-version")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "api-version", valid_564123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564124: Call_ImagesList_564119; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Images in the subscription. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.
  ## 
  let valid = call_564124.validator(path, query, header, formData, body)
  let scheme = call_564124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564124.url(scheme.get, call_564124.host, call_564124.base,
                         call_564124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564124, url, valid)

proc call*(call_564125: Call_ImagesList_564119; apiVersion: string;
          subscriptionId: string): Recallable =
  ## imagesList
  ## Gets the list of Images in the subscription. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564126 = newJObject()
  var query_564127 = newJObject()
  add(query_564127, "api-version", newJString(apiVersion))
  add(path_564126, "subscriptionId", newJString(subscriptionId))
  result = call_564125.call(path_564126, query_564127, nil, nil, nil)

var imagesList* = Call_ImagesList_564119(name: "imagesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/images",
                                      validator: validate_ImagesList_564120,
                                      base: "", url: url_ImagesList_564121,
                                      schemes: {Scheme.Https})
type
  Call_LogAnalyticsExportRequestRateByInterval_564128 = ref object of OpenApiRestCall_563565
proc url_LogAnalyticsExportRequestRateByInterval_564130(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"), (kind: ConstantSegment,
        value: "/logAnalytics/apiAccess/getRequestRateByInterval")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LogAnalyticsExportRequestRateByInterval_564129(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Export logs that show Api requests made by this subscription in the given time window to show throttling activities.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564148 = path.getOrDefault("subscriptionId")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "subscriptionId", valid_564148
  var valid_564149 = path.getOrDefault("location")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "location", valid_564149
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564150 = query.getOrDefault("api-version")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "api-version", valid_564150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the LogAnalytics getRequestRateByInterval Api.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564152: Call_LogAnalyticsExportRequestRateByInterval_564128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Export logs that show Api requests made by this subscription in the given time window to show throttling activities.
  ## 
  let valid = call_564152.validator(path, query, header, formData, body)
  let scheme = call_564152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564152.url(scheme.get, call_564152.host, call_564152.base,
                         call_564152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564152, url, valid)

proc call*(call_564153: Call_LogAnalyticsExportRequestRateByInterval_564128;
          apiVersion: string; subscriptionId: string; location: string;
          parameters: JsonNode): Recallable =
  ## logAnalyticsExportRequestRateByInterval
  ## Export logs that show Api requests made by this subscription in the given time window to show throttling activities.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the LogAnalytics getRequestRateByInterval Api.
  var path_564154 = newJObject()
  var query_564155 = newJObject()
  var body_564156 = newJObject()
  add(query_564155, "api-version", newJString(apiVersion))
  add(path_564154, "subscriptionId", newJString(subscriptionId))
  add(path_564154, "location", newJString(location))
  if parameters != nil:
    body_564156 = parameters
  result = call_564153.call(path_564154, query_564155, nil, nil, body_564156)

var logAnalyticsExportRequestRateByInterval* = Call_LogAnalyticsExportRequestRateByInterval_564128(
    name: "logAnalyticsExportRequestRateByInterval", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/logAnalytics/apiAccess/getRequestRateByInterval",
    validator: validate_LogAnalyticsExportRequestRateByInterval_564129, base: "",
    url: url_LogAnalyticsExportRequestRateByInterval_564130,
    schemes: {Scheme.Https})
type
  Call_LogAnalyticsExportThrottledRequests_564157 = ref object of OpenApiRestCall_563565
proc url_LogAnalyticsExportThrottledRequests_564159(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"), (kind: ConstantSegment,
        value: "/logAnalytics/apiAccess/getThrottledRequests")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LogAnalyticsExportThrottledRequests_564158(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Export logs that show total throttled Api requests for this subscription in the given time window.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564160 = path.getOrDefault("subscriptionId")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "subscriptionId", valid_564160
  var valid_564161 = path.getOrDefault("location")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = nil)
  if valid_564161 != nil:
    section.add "location", valid_564161
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564162 = query.getOrDefault("api-version")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "api-version", valid_564162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the LogAnalytics getThrottledRequests Api.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564164: Call_LogAnalyticsExportThrottledRequests_564157;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Export logs that show total throttled Api requests for this subscription in the given time window.
  ## 
  let valid = call_564164.validator(path, query, header, formData, body)
  let scheme = call_564164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564164.url(scheme.get, call_564164.host, call_564164.base,
                         call_564164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564164, url, valid)

proc call*(call_564165: Call_LogAnalyticsExportThrottledRequests_564157;
          apiVersion: string; subscriptionId: string; location: string;
          parameters: JsonNode): Recallable =
  ## logAnalyticsExportThrottledRequests
  ## Export logs that show total throttled Api requests for this subscription in the given time window.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the LogAnalytics getThrottledRequests Api.
  var path_564166 = newJObject()
  var query_564167 = newJObject()
  var body_564168 = newJObject()
  add(query_564167, "api-version", newJString(apiVersion))
  add(path_564166, "subscriptionId", newJString(subscriptionId))
  add(path_564166, "location", newJString(location))
  if parameters != nil:
    body_564168 = parameters
  result = call_564165.call(path_564166, query_564167, nil, nil, body_564168)

var logAnalyticsExportThrottledRequests* = Call_LogAnalyticsExportThrottledRequests_564157(
    name: "logAnalyticsExportThrottledRequests", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/logAnalytics/apiAccess/getThrottledRequests",
    validator: validate_LogAnalyticsExportThrottledRequests_564158, base: "",
    url: url_LogAnalyticsExportThrottledRequests_564159, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesListPublishers_564169 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineImagesListPublishers_564171(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/publishers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImagesListPublishers_564170(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of virtual machine image publishers for the specified Azure location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564172 = path.getOrDefault("subscriptionId")
  valid_564172 = validateParameter(valid_564172, JString, required = true,
                                 default = nil)
  if valid_564172 != nil:
    section.add "subscriptionId", valid_564172
  var valid_564173 = path.getOrDefault("location")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "location", valid_564173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564174 = query.getOrDefault("api-version")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "api-version", valid_564174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564175: Call_VirtualMachineImagesListPublishers_564169;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual machine image publishers for the specified Azure location.
  ## 
  let valid = call_564175.validator(path, query, header, formData, body)
  let scheme = call_564175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564175.url(scheme.get, call_564175.host, call_564175.base,
                         call_564175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564175, url, valid)

proc call*(call_564176: Call_VirtualMachineImagesListPublishers_564169;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## virtualMachineImagesListPublishers
  ## Gets a list of virtual machine image publishers for the specified Azure location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_564177 = newJObject()
  var query_564178 = newJObject()
  add(query_564178, "api-version", newJString(apiVersion))
  add(path_564177, "subscriptionId", newJString(subscriptionId))
  add(path_564177, "location", newJString(location))
  result = call_564176.call(path_564177, query_564178, nil, nil, nil)

var virtualMachineImagesListPublishers* = Call_VirtualMachineImagesListPublishers_564169(
    name: "virtualMachineImagesListPublishers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers",
    validator: validate_VirtualMachineImagesListPublishers_564170, base: "",
    url: url_VirtualMachineImagesListPublishers_564171, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionImagesListTypes_564179 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineExtensionImagesListTypes_564181(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisherName" in path, "`publisherName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/publishers/"),
               (kind: VariableSegment, value: "publisherName"), (
        kind: ConstantSegment, value: "/artifacttypes/vmextension/types")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineExtensionImagesListTypes_564180(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of virtual machine extension image types.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   publisherName: JString (required)
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `publisherName` field"
  var valid_564182 = path.getOrDefault("publisherName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "publisherName", valid_564182
  var valid_564183 = path.getOrDefault("subscriptionId")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "subscriptionId", valid_564183
  var valid_564184 = path.getOrDefault("location")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "location", valid_564184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564185 = query.getOrDefault("api-version")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "api-version", valid_564185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564186: Call_VirtualMachineExtensionImagesListTypes_564179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual machine extension image types.
  ## 
  let valid = call_564186.validator(path, query, header, formData, body)
  let scheme = call_564186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564186.url(scheme.get, call_564186.host, call_564186.base,
                         call_564186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564186, url, valid)

proc call*(call_564187: Call_VirtualMachineExtensionImagesListTypes_564179;
          publisherName: string; apiVersion: string; subscriptionId: string;
          location: string): Recallable =
  ## virtualMachineExtensionImagesListTypes
  ## Gets a list of virtual machine extension image types.
  ##   publisherName: string (required)
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_564188 = newJObject()
  var query_564189 = newJObject()
  add(path_564188, "publisherName", newJString(publisherName))
  add(query_564189, "api-version", newJString(apiVersion))
  add(path_564188, "subscriptionId", newJString(subscriptionId))
  add(path_564188, "location", newJString(location))
  result = call_564187.call(path_564188, query_564189, nil, nil, nil)

var virtualMachineExtensionImagesListTypes* = Call_VirtualMachineExtensionImagesListTypes_564179(
    name: "virtualMachineExtensionImagesListTypes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types",
    validator: validate_VirtualMachineExtensionImagesListTypes_564180, base: "",
    url: url_VirtualMachineExtensionImagesListTypes_564181,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionImagesListVersions_564190 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineExtensionImagesListVersions_564192(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisherName" in path, "`publisherName` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/publishers/"),
               (kind: VariableSegment, value: "publisherName"), (
        kind: ConstantSegment, value: "/artifacttypes/vmextension/types/"),
               (kind: VariableSegment, value: "type"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineExtensionImagesListVersions_564191(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of virtual machine extension image versions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   publisherName: JString (required)
  ##   type: JString (required)
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `publisherName` field"
  var valid_564193 = path.getOrDefault("publisherName")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "publisherName", valid_564193
  var valid_564194 = path.getOrDefault("type")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "type", valid_564194
  var valid_564195 = path.getOrDefault("subscriptionId")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "subscriptionId", valid_564195
  var valid_564196 = path.getOrDefault("location")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "location", valid_564196
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $orderby: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_564197 = query.getOrDefault("$top")
  valid_564197 = validateParameter(valid_564197, JInt, required = false, default = nil)
  if valid_564197 != nil:
    section.add "$top", valid_564197
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564198 = query.getOrDefault("api-version")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "api-version", valid_564198
  var valid_564199 = query.getOrDefault("$orderby")
  valid_564199 = validateParameter(valid_564199, JString, required = false,
                                 default = nil)
  if valid_564199 != nil:
    section.add "$orderby", valid_564199
  var valid_564200 = query.getOrDefault("$filter")
  valid_564200 = validateParameter(valid_564200, JString, required = false,
                                 default = nil)
  if valid_564200 != nil:
    section.add "$filter", valid_564200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564201: Call_VirtualMachineExtensionImagesListVersions_564190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual machine extension image versions.
  ## 
  let valid = call_564201.validator(path, query, header, formData, body)
  let scheme = call_564201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564201.url(scheme.get, call_564201.host, call_564201.base,
                         call_564201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564201, url, valid)

proc call*(call_564202: Call_VirtualMachineExtensionImagesListVersions_564190;
          publisherName: string; `type`: string; apiVersion: string;
          subscriptionId: string; location: string; Top: int = 0; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## virtualMachineExtensionImagesListVersions
  ## Gets a list of virtual machine extension image versions.
  ##   publisherName: string (required)
  ##   Top: int
  ##   type: string (required)
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Orderby: string
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_564203 = newJObject()
  var query_564204 = newJObject()
  add(path_564203, "publisherName", newJString(publisherName))
  add(query_564204, "$top", newJInt(Top))
  add(path_564203, "type", newJString(`type`))
  add(query_564204, "api-version", newJString(apiVersion))
  add(path_564203, "subscriptionId", newJString(subscriptionId))
  add(query_564204, "$orderby", newJString(Orderby))
  add(path_564203, "location", newJString(location))
  add(query_564204, "$filter", newJString(Filter))
  result = call_564202.call(path_564203, query_564204, nil, nil, nil)

var virtualMachineExtensionImagesListVersions* = Call_VirtualMachineExtensionImagesListVersions_564190(
    name: "virtualMachineExtensionImagesListVersions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types/{type}/versions",
    validator: validate_VirtualMachineExtensionImagesListVersions_564191,
    base: "", url: url_VirtualMachineExtensionImagesListVersions_564192,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionImagesGet_564205 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineExtensionImagesGet_564207(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisherName" in path, "`publisherName` is a required path parameter"
  assert "type" in path, "`type` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/publishers/"),
               (kind: VariableSegment, value: "publisherName"), (
        kind: ConstantSegment, value: "/artifacttypes/vmextension/types/"),
               (kind: VariableSegment, value: "type"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineExtensionImagesGet_564206(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a virtual machine extension image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   publisherName: JString (required)
  ##   version: JString (required)
  ##   type: JString (required)
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `publisherName` field"
  var valid_564208 = path.getOrDefault("publisherName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "publisherName", valid_564208
  var valid_564209 = path.getOrDefault("version")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "version", valid_564209
  var valid_564210 = path.getOrDefault("type")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "type", valid_564210
  var valid_564211 = path.getOrDefault("subscriptionId")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "subscriptionId", valid_564211
  var valid_564212 = path.getOrDefault("location")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "location", valid_564212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564213 = query.getOrDefault("api-version")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "api-version", valid_564213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564214: Call_VirtualMachineExtensionImagesGet_564205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a virtual machine extension image.
  ## 
  let valid = call_564214.validator(path, query, header, formData, body)
  let scheme = call_564214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564214.url(scheme.get, call_564214.host, call_564214.base,
                         call_564214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564214, url, valid)

proc call*(call_564215: Call_VirtualMachineExtensionImagesGet_564205;
          publisherName: string; version: string; apiVersion: string; `type`: string;
          subscriptionId: string; location: string): Recallable =
  ## virtualMachineExtensionImagesGet
  ## Gets a virtual machine extension image.
  ##   publisherName: string (required)
  ##   version: string (required)
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   type: string (required)
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_564216 = newJObject()
  var query_564217 = newJObject()
  add(path_564216, "publisherName", newJString(publisherName))
  add(path_564216, "version", newJString(version))
  add(query_564217, "api-version", newJString(apiVersion))
  add(path_564216, "type", newJString(`type`))
  add(path_564216, "subscriptionId", newJString(subscriptionId))
  add(path_564216, "location", newJString(location))
  result = call_564215.call(path_564216, query_564217, nil, nil, nil)

var virtualMachineExtensionImagesGet* = Call_VirtualMachineExtensionImagesGet_564205(
    name: "virtualMachineExtensionImagesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types/{type}/versions/{version}",
    validator: validate_VirtualMachineExtensionImagesGet_564206, base: "",
    url: url_VirtualMachineExtensionImagesGet_564207, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesListOffers_564218 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineImagesListOffers_564220(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisherName" in path, "`publisherName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/publishers/"),
               (kind: VariableSegment, value: "publisherName"),
               (kind: ConstantSegment, value: "/artifacttypes/vmimage/offers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImagesListOffers_564219(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of virtual machine image offers for the specified location and publisher.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   publisherName: JString (required)
  ##                : A valid image publisher.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `publisherName` field"
  var valid_564221 = path.getOrDefault("publisherName")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "publisherName", valid_564221
  var valid_564222 = path.getOrDefault("subscriptionId")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "subscriptionId", valid_564222
  var valid_564223 = path.getOrDefault("location")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "location", valid_564223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564224 = query.getOrDefault("api-version")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "api-version", valid_564224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564225: Call_VirtualMachineImagesListOffers_564218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of virtual machine image offers for the specified location and publisher.
  ## 
  let valid = call_564225.validator(path, query, header, formData, body)
  let scheme = call_564225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564225.url(scheme.get, call_564225.host, call_564225.base,
                         call_564225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564225, url, valid)

proc call*(call_564226: Call_VirtualMachineImagesListOffers_564218;
          publisherName: string; apiVersion: string; subscriptionId: string;
          location: string): Recallable =
  ## virtualMachineImagesListOffers
  ## Gets a list of virtual machine image offers for the specified location and publisher.
  ##   publisherName: string (required)
  ##                : A valid image publisher.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_564227 = newJObject()
  var query_564228 = newJObject()
  add(path_564227, "publisherName", newJString(publisherName))
  add(query_564228, "api-version", newJString(apiVersion))
  add(path_564227, "subscriptionId", newJString(subscriptionId))
  add(path_564227, "location", newJString(location))
  result = call_564226.call(path_564227, query_564228, nil, nil, nil)

var virtualMachineImagesListOffers* = Call_VirtualMachineImagesListOffers_564218(
    name: "virtualMachineImagesListOffers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers",
    validator: validate_VirtualMachineImagesListOffers_564219, base: "",
    url: url_VirtualMachineImagesListOffers_564220, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesListSkus_564229 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineImagesListSkus_564231(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisherName" in path, "`publisherName` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/publishers/"),
               (kind: VariableSegment, value: "publisherName"), (
        kind: ConstantSegment, value: "/artifacttypes/vmimage/offers/"),
               (kind: VariableSegment, value: "offer"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImagesListSkus_564230(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of virtual machine image SKUs for the specified location, publisher, and offer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   publisherName: JString (required)
  ##                : A valid image publisher.
  ##   offer: JString (required)
  ##        : A valid image publisher offer.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `publisherName` field"
  var valid_564232 = path.getOrDefault("publisherName")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "publisherName", valid_564232
  var valid_564233 = path.getOrDefault("offer")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "offer", valid_564233
  var valid_564234 = path.getOrDefault("subscriptionId")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "subscriptionId", valid_564234
  var valid_564235 = path.getOrDefault("location")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "location", valid_564235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564236 = query.getOrDefault("api-version")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "api-version", valid_564236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564237: Call_VirtualMachineImagesListSkus_564229; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of virtual machine image SKUs for the specified location, publisher, and offer.
  ## 
  let valid = call_564237.validator(path, query, header, formData, body)
  let scheme = call_564237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564237.url(scheme.get, call_564237.host, call_564237.base,
                         call_564237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564237, url, valid)

proc call*(call_564238: Call_VirtualMachineImagesListSkus_564229;
          publisherName: string; offer: string; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## virtualMachineImagesListSkus
  ## Gets a list of virtual machine image SKUs for the specified location, publisher, and offer.
  ##   publisherName: string (required)
  ##                : A valid image publisher.
  ##   offer: string (required)
  ##        : A valid image publisher offer.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_564239 = newJObject()
  var query_564240 = newJObject()
  add(path_564239, "publisherName", newJString(publisherName))
  add(path_564239, "offer", newJString(offer))
  add(query_564240, "api-version", newJString(apiVersion))
  add(path_564239, "subscriptionId", newJString(subscriptionId))
  add(path_564239, "location", newJString(location))
  result = call_564238.call(path_564239, query_564240, nil, nil, nil)

var virtualMachineImagesListSkus* = Call_VirtualMachineImagesListSkus_564229(
    name: "virtualMachineImagesListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus",
    validator: validate_VirtualMachineImagesListSkus_564230, base: "",
    url: url_VirtualMachineImagesListSkus_564231, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesList_564241 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineImagesList_564243(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisherName" in path, "`publisherName` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  assert "skus" in path, "`skus` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/publishers/"),
               (kind: VariableSegment, value: "publisherName"), (
        kind: ConstantSegment, value: "/artifacttypes/vmimage/offers/"),
               (kind: VariableSegment, value: "offer"),
               (kind: ConstantSegment, value: "/skus/"),
               (kind: VariableSegment, value: "skus"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImagesList_564242(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all virtual machine image versions for the specified location, publisher, offer, and SKU.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   publisherName: JString (required)
  ##                : A valid image publisher.
  ##   offer: JString (required)
  ##        : A valid image publisher offer.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  ##   skus: JString (required)
  ##       : A valid image SKU.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `publisherName` field"
  var valid_564244 = path.getOrDefault("publisherName")
  valid_564244 = validateParameter(valid_564244, JString, required = true,
                                 default = nil)
  if valid_564244 != nil:
    section.add "publisherName", valid_564244
  var valid_564245 = path.getOrDefault("offer")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "offer", valid_564245
  var valid_564246 = path.getOrDefault("subscriptionId")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "subscriptionId", valid_564246
  var valid_564247 = path.getOrDefault("location")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "location", valid_564247
  var valid_564248 = path.getOrDefault("skus")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "skus", valid_564248
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $orderby: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_564249 = query.getOrDefault("$top")
  valid_564249 = validateParameter(valid_564249, JInt, required = false, default = nil)
  if valid_564249 != nil:
    section.add "$top", valid_564249
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564250 = query.getOrDefault("api-version")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "api-version", valid_564250
  var valid_564251 = query.getOrDefault("$orderby")
  valid_564251 = validateParameter(valid_564251, JString, required = false,
                                 default = nil)
  if valid_564251 != nil:
    section.add "$orderby", valid_564251
  var valid_564252 = query.getOrDefault("$filter")
  valid_564252 = validateParameter(valid_564252, JString, required = false,
                                 default = nil)
  if valid_564252 != nil:
    section.add "$filter", valid_564252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564253: Call_VirtualMachineImagesList_564241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all virtual machine image versions for the specified location, publisher, offer, and SKU.
  ## 
  let valid = call_564253.validator(path, query, header, formData, body)
  let scheme = call_564253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564253.url(scheme.get, call_564253.host, call_564253.base,
                         call_564253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564253, url, valid)

proc call*(call_564254: Call_VirtualMachineImagesList_564241;
          publisherName: string; offer: string; apiVersion: string;
          subscriptionId: string; location: string; skus: string; Top: int = 0;
          Orderby: string = ""; Filter: string = ""): Recallable =
  ## virtualMachineImagesList
  ## Gets a list of all virtual machine image versions for the specified location, publisher, offer, and SKU.
  ##   publisherName: string (required)
  ##                : A valid image publisher.
  ##   offer: string (required)
  ##        : A valid image publisher offer.
  ##   Top: int
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Orderby: string
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  ##   skus: string (required)
  ##       : A valid image SKU.
  var path_564255 = newJObject()
  var query_564256 = newJObject()
  add(path_564255, "publisherName", newJString(publisherName))
  add(path_564255, "offer", newJString(offer))
  add(query_564256, "$top", newJInt(Top))
  add(query_564256, "api-version", newJString(apiVersion))
  add(path_564255, "subscriptionId", newJString(subscriptionId))
  add(query_564256, "$orderby", newJString(Orderby))
  add(path_564255, "location", newJString(location))
  add(query_564256, "$filter", newJString(Filter))
  add(path_564255, "skus", newJString(skus))
  result = call_564254.call(path_564255, query_564256, nil, nil, nil)

var virtualMachineImagesList* = Call_VirtualMachineImagesList_564241(
    name: "virtualMachineImagesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions",
    validator: validate_VirtualMachineImagesList_564242, base: "",
    url: url_VirtualMachineImagesList_564243, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesGet_564257 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineImagesGet_564259(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "publisherName" in path, "`publisherName` is a required path parameter"
  assert "offer" in path, "`offer` is a required path parameter"
  assert "skus" in path, "`skus` is a required path parameter"
  assert "version" in path, "`version` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/publishers/"),
               (kind: VariableSegment, value: "publisherName"), (
        kind: ConstantSegment, value: "/artifacttypes/vmimage/offers/"),
               (kind: VariableSegment, value: "offer"),
               (kind: ConstantSegment, value: "/skus/"),
               (kind: VariableSegment, value: "skus"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "version")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineImagesGet_564258(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a virtual machine image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   publisherName: JString (required)
  ##                : A valid image publisher.
  ##   offer: JString (required)
  ##        : A valid image publisher offer.
  ##   version: JString (required)
  ##          : A valid image SKU version.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  ##   skus: JString (required)
  ##       : A valid image SKU.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `publisherName` field"
  var valid_564260 = path.getOrDefault("publisherName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "publisherName", valid_564260
  var valid_564261 = path.getOrDefault("offer")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "offer", valid_564261
  var valid_564262 = path.getOrDefault("version")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "version", valid_564262
  var valid_564263 = path.getOrDefault("subscriptionId")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "subscriptionId", valid_564263
  var valid_564264 = path.getOrDefault("location")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "location", valid_564264
  var valid_564265 = path.getOrDefault("skus")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "skus", valid_564265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564266 = query.getOrDefault("api-version")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "api-version", valid_564266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564267: Call_VirtualMachineImagesGet_564257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a virtual machine image.
  ## 
  let valid = call_564267.validator(path, query, header, formData, body)
  let scheme = call_564267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564267.url(scheme.get, call_564267.host, call_564267.base,
                         call_564267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564267, url, valid)

proc call*(call_564268: Call_VirtualMachineImagesGet_564257; publisherName: string;
          offer: string; version: string; apiVersion: string; subscriptionId: string;
          location: string; skus: string): Recallable =
  ## virtualMachineImagesGet
  ## Gets a virtual machine image.
  ##   publisherName: string (required)
  ##                : A valid image publisher.
  ##   offer: string (required)
  ##        : A valid image publisher offer.
  ##   version: string (required)
  ##          : A valid image SKU version.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  ##   skus: string (required)
  ##       : A valid image SKU.
  var path_564269 = newJObject()
  var query_564270 = newJObject()
  add(path_564269, "publisherName", newJString(publisherName))
  add(path_564269, "offer", newJString(offer))
  add(path_564269, "version", newJString(version))
  add(query_564270, "api-version", newJString(apiVersion))
  add(path_564269, "subscriptionId", newJString(subscriptionId))
  add(path_564269, "location", newJString(location))
  add(path_564269, "skus", newJString(skus))
  result = call_564268.call(path_564269, query_564270, nil, nil, nil)

var virtualMachineImagesGet* = Call_VirtualMachineImagesGet_564257(
    name: "virtualMachineImagesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions/{version}",
    validator: validate_VirtualMachineImagesGet_564258, base: "",
    url: url_VirtualMachineImagesGet_564259, schemes: {Scheme.Https})
type
  Call_UsageList_564271 = ref object of OpenApiRestCall_563565
proc url_UsageList_564273(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/usages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UsageList_564272(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets, for the specified location, the current compute resource usage information as well as the limits for compute resources under the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The location for which resource usage is queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564274 = path.getOrDefault("subscriptionId")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "subscriptionId", valid_564274
  var valid_564275 = path.getOrDefault("location")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "location", valid_564275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564276 = query.getOrDefault("api-version")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "api-version", valid_564276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564277: Call_UsageList_564271; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets, for the specified location, the current compute resource usage information as well as the limits for compute resources under the subscription.
  ## 
  let valid = call_564277.validator(path, query, header, formData, body)
  let scheme = call_564277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564277.url(scheme.get, call_564277.host, call_564277.base,
                         call_564277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564277, url, valid)

proc call*(call_564278: Call_UsageList_564271; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usageList
  ## Gets, for the specified location, the current compute resource usage information as well as the limits for compute resources under the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location for which resource usage is queried.
  var path_564279 = newJObject()
  var query_564280 = newJObject()
  add(query_564280, "api-version", newJString(apiVersion))
  add(path_564279, "subscriptionId", newJString(subscriptionId))
  add(path_564279, "location", newJString(location))
  result = call_564278.call(path_564279, query_564280, nil, nil, nil)

var usageList* = Call_UsageList_564271(name: "usageList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/usages",
                                    validator: validate_UsageList_564272,
                                    base: "", url: url_UsageList_564273,
                                    schemes: {Scheme.Https})
type
  Call_VirtualMachinesListByLocation_564281 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesListByLocation_564283(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/virtualMachines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesListByLocation_564282(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the virtual machines under the specified subscription for the specified location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The location for which virtual machines under the subscription are queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564284 = path.getOrDefault("subscriptionId")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "subscriptionId", valid_564284
  var valid_564285 = path.getOrDefault("location")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "location", valid_564285
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564286 = query.getOrDefault("api-version")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "api-version", valid_564286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564287: Call_VirtualMachinesListByLocation_564281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the virtual machines under the specified subscription for the specified location.
  ## 
  let valid = call_564287.validator(path, query, header, formData, body)
  let scheme = call_564287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564287.url(scheme.get, call_564287.host, call_564287.base,
                         call_564287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564287, url, valid)

proc call*(call_564288: Call_VirtualMachinesListByLocation_564281;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## virtualMachinesListByLocation
  ## Gets all the virtual machines under the specified subscription for the specified location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location for which virtual machines under the subscription are queried.
  var path_564289 = newJObject()
  var query_564290 = newJObject()
  add(query_564290, "api-version", newJString(apiVersion))
  add(path_564289, "subscriptionId", newJString(subscriptionId))
  add(path_564289, "location", newJString(location))
  result = call_564288.call(path_564289, query_564290, nil, nil, nil)

var virtualMachinesListByLocation* = Call_VirtualMachinesListByLocation_564281(
    name: "virtualMachinesListByLocation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/virtualMachines",
    validator: validate_VirtualMachinesListByLocation_564282, base: "",
    url: url_VirtualMachinesListByLocation_564283, schemes: {Scheme.Https})
type
  Call_VirtualMachineSizesList_564291 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineSizesList_564293(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/vmSizes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineSizesList_564292(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This API is deprecated. Use [Resources Skus](https://docs.microsoft.com/en-us/rest/api/compute/resourceskus/list)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564294 = path.getOrDefault("subscriptionId")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "subscriptionId", valid_564294
  var valid_564295 = path.getOrDefault("location")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "location", valid_564295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564296 = query.getOrDefault("api-version")
  valid_564296 = validateParameter(valid_564296, JString, required = true,
                                 default = nil)
  if valid_564296 != nil:
    section.add "api-version", valid_564296
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564297: Call_VirtualMachineSizesList_564291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This API is deprecated. Use [Resources Skus](https://docs.microsoft.com/en-us/rest/api/compute/resourceskus/list)
  ## 
  let valid = call_564297.validator(path, query, header, formData, body)
  let scheme = call_564297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564297.url(scheme.get, call_564297.host, call_564297.base,
                         call_564297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564297, url, valid)

proc call*(call_564298: Call_VirtualMachineSizesList_564291; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## virtualMachineSizesList
  ## This API is deprecated. Use [Resources Skus](https://docs.microsoft.com/en-us/rest/api/compute/resourceskus/list)
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  var path_564299 = newJObject()
  var query_564300 = newJObject()
  add(query_564300, "api-version", newJString(apiVersion))
  add(path_564299, "subscriptionId", newJString(subscriptionId))
  add(path_564299, "location", newJString(location))
  result = call_564298.call(path_564299, query_564300, nil, nil, nil)

var virtualMachineSizesList* = Call_VirtualMachineSizesList_564291(
    name: "virtualMachineSizesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/vmSizes",
    validator: validate_VirtualMachineSizesList_564292, base: "",
    url: url_VirtualMachineSizesList_564293, schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsListBySubscription_564301 = ref object of OpenApiRestCall_563565
proc url_ProximityPlacementGroupsListBySubscription_564303(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/proximityPlacementGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximityPlacementGroupsListBySubscription_564302(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all proximity placement groups in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564304 = path.getOrDefault("subscriptionId")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "subscriptionId", valid_564304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564305 = query.getOrDefault("api-version")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "api-version", valid_564305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564306: Call_ProximityPlacementGroupsListBySubscription_564301;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all proximity placement groups in a subscription.
  ## 
  let valid = call_564306.validator(path, query, header, formData, body)
  let scheme = call_564306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564306.url(scheme.get, call_564306.host, call_564306.base,
                         call_564306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564306, url, valid)

proc call*(call_564307: Call_ProximityPlacementGroupsListBySubscription_564301;
          apiVersion: string; subscriptionId: string): Recallable =
  ## proximityPlacementGroupsListBySubscription
  ## Lists all proximity placement groups in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564308 = newJObject()
  var query_564309 = newJObject()
  add(query_564309, "api-version", newJString(apiVersion))
  add(path_564308, "subscriptionId", newJString(subscriptionId))
  result = call_564307.call(path_564308, query_564309, nil, nil, nil)

var proximityPlacementGroupsListBySubscription* = Call_ProximityPlacementGroupsListBySubscription_564301(
    name: "proximityPlacementGroupsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/proximityPlacementGroups",
    validator: validate_ProximityPlacementGroupsListBySubscription_564302,
    base: "", url: url_ProximityPlacementGroupsListBySubscription_564303,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsListAll_564310 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsListAll_564312(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsListAll_564311(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all VM Scale Sets in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM Scale Sets.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564313 = path.getOrDefault("subscriptionId")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "subscriptionId", valid_564313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564314 = query.getOrDefault("api-version")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "api-version", valid_564314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564315: Call_VirtualMachineScaleSetsListAll_564310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all VM Scale Sets in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM Scale Sets.
  ## 
  let valid = call_564315.validator(path, query, header, formData, body)
  let scheme = call_564315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564315.url(scheme.get, call_564315.host, call_564315.base,
                         call_564315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564315, url, valid)

proc call*(call_564316: Call_VirtualMachineScaleSetsListAll_564310;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsListAll
  ## Gets a list of all VM Scale Sets in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM Scale Sets.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564317 = newJObject()
  var query_564318 = newJObject()
  add(query_564318, "api-version", newJString(apiVersion))
  add(path_564317, "subscriptionId", newJString(subscriptionId))
  result = call_564316.call(path_564317, query_564318, nil, nil, nil)

var virtualMachineScaleSetsListAll* = Call_VirtualMachineScaleSetsListAll_564310(
    name: "virtualMachineScaleSetsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachineScaleSets",
    validator: validate_VirtualMachineScaleSetsListAll_564311, base: "",
    url: url_VirtualMachineScaleSetsListAll_564312, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListAll_564319 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesListAll_564321(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.Compute/virtualMachines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesListAll_564320(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the virtual machines in the specified subscription. Use the nextLink property in the response to get the next page of virtual machines.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564322 = path.getOrDefault("subscriptionId")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "subscriptionId", valid_564322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564323 = query.getOrDefault("api-version")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "api-version", valid_564323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564324: Call_VirtualMachinesListAll_564319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the virtual machines in the specified subscription. Use the nextLink property in the response to get the next page of virtual machines.
  ## 
  let valid = call_564324.validator(path, query, header, formData, body)
  let scheme = call_564324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564324.url(scheme.get, call_564324.host, call_564324.base,
                         call_564324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564324, url, valid)

proc call*(call_564325: Call_VirtualMachinesListAll_564319; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachinesListAll
  ## Lists all of the virtual machines in the specified subscription. Use the nextLink property in the response to get the next page of virtual machines.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564326 = newJObject()
  var query_564327 = newJObject()
  add(query_564327, "api-version", newJString(apiVersion))
  add(path_564326, "subscriptionId", newJString(subscriptionId))
  result = call_564325.call(path_564326, query_564327, nil, nil, nil)

var virtualMachinesListAll* = Call_VirtualMachinesListAll_564319(
    name: "virtualMachinesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachines",
    validator: validate_VirtualMachinesListAll_564320, base: "",
    url: url_VirtualMachinesListAll_564321, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsList_564328 = ref object of OpenApiRestCall_563565
proc url_AvailabilitySetsList_564330(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/availabilitySets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilitySetsList_564329(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all availability sets in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564331 = path.getOrDefault("subscriptionId")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "subscriptionId", valid_564331
  var valid_564332 = path.getOrDefault("resourceGroupName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "resourceGroupName", valid_564332
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564333 = query.getOrDefault("api-version")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "api-version", valid_564333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564334: Call_AvailabilitySetsList_564328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all availability sets in a resource group.
  ## 
  let valid = call_564334.validator(path, query, header, formData, body)
  let scheme = call_564334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564334.url(scheme.get, call_564334.host, call_564334.base,
                         call_564334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564334, url, valid)

proc call*(call_564335: Call_AvailabilitySetsList_564328; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## availabilitySetsList
  ## Lists all availability sets in a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564336 = newJObject()
  var query_564337 = newJObject()
  add(query_564337, "api-version", newJString(apiVersion))
  add(path_564336, "subscriptionId", newJString(subscriptionId))
  add(path_564336, "resourceGroupName", newJString(resourceGroupName))
  result = call_564335.call(path_564336, query_564337, nil, nil, nil)

var availabilitySetsList* = Call_AvailabilitySetsList_564328(
    name: "availabilitySetsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets",
    validator: validate_AvailabilitySetsList_564329, base: "",
    url: url_AvailabilitySetsList_564330, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsCreateOrUpdate_564349 = ref object of OpenApiRestCall_563565
proc url_AvailabilitySetsCreateOrUpdate_564351(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "availabilitySetName" in path,
        "`availabilitySetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/availabilitySets/"),
               (kind: VariableSegment, value: "availabilitySetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilitySetsCreateOrUpdate_564350(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an availability set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   availabilitySetName: JString (required)
  ##                      : The name of the availability set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `availabilitySetName` field"
  var valid_564352 = path.getOrDefault("availabilitySetName")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "availabilitySetName", valid_564352
  var valid_564353 = path.getOrDefault("subscriptionId")
  valid_564353 = validateParameter(valid_564353, JString, required = true,
                                 default = nil)
  if valid_564353 != nil:
    section.add "subscriptionId", valid_564353
  var valid_564354 = path.getOrDefault("resourceGroupName")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = nil)
  if valid_564354 != nil:
    section.add "resourceGroupName", valid_564354
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564355 = query.getOrDefault("api-version")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = nil)
  if valid_564355 != nil:
    section.add "api-version", valid_564355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Availability Set operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564357: Call_AvailabilitySetsCreateOrUpdate_564349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an availability set.
  ## 
  let valid = call_564357.validator(path, query, header, formData, body)
  let scheme = call_564357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564357.url(scheme.get, call_564357.host, call_564357.base,
                         call_564357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564357, url, valid)

proc call*(call_564358: Call_AvailabilitySetsCreateOrUpdate_564349;
          availabilitySetName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## availabilitySetsCreateOrUpdate
  ## Create or update an availability set.
  ##   availabilitySetName: string (required)
  ##                      : The name of the availability set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Availability Set operation.
  var path_564359 = newJObject()
  var query_564360 = newJObject()
  var body_564361 = newJObject()
  add(path_564359, "availabilitySetName", newJString(availabilitySetName))
  add(query_564360, "api-version", newJString(apiVersion))
  add(path_564359, "subscriptionId", newJString(subscriptionId))
  add(path_564359, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564361 = parameters
  result = call_564358.call(path_564359, query_564360, nil, nil, body_564361)

var availabilitySetsCreateOrUpdate* = Call_AvailabilitySetsCreateOrUpdate_564349(
    name: "availabilitySetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsCreateOrUpdate_564350, base: "",
    url: url_AvailabilitySetsCreateOrUpdate_564351, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsGet_564338 = ref object of OpenApiRestCall_563565
proc url_AvailabilitySetsGet_564340(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "availabilitySetName" in path,
        "`availabilitySetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/availabilitySets/"),
               (kind: VariableSegment, value: "availabilitySetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilitySetsGet_564339(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves information about an availability set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   availabilitySetName: JString (required)
  ##                      : The name of the availability set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `availabilitySetName` field"
  var valid_564341 = path.getOrDefault("availabilitySetName")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "availabilitySetName", valid_564341
  var valid_564342 = path.getOrDefault("subscriptionId")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "subscriptionId", valid_564342
  var valid_564343 = path.getOrDefault("resourceGroupName")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "resourceGroupName", valid_564343
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564344 = query.getOrDefault("api-version")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "api-version", valid_564344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564345: Call_AvailabilitySetsGet_564338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about an availability set.
  ## 
  let valid = call_564345.validator(path, query, header, formData, body)
  let scheme = call_564345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564345.url(scheme.get, call_564345.host, call_564345.base,
                         call_564345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564345, url, valid)

proc call*(call_564346: Call_AvailabilitySetsGet_564338;
          availabilitySetName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## availabilitySetsGet
  ## Retrieves information about an availability set.
  ##   availabilitySetName: string (required)
  ##                      : The name of the availability set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564347 = newJObject()
  var query_564348 = newJObject()
  add(path_564347, "availabilitySetName", newJString(availabilitySetName))
  add(query_564348, "api-version", newJString(apiVersion))
  add(path_564347, "subscriptionId", newJString(subscriptionId))
  add(path_564347, "resourceGroupName", newJString(resourceGroupName))
  result = call_564346.call(path_564347, query_564348, nil, nil, nil)

var availabilitySetsGet* = Call_AvailabilitySetsGet_564338(
    name: "availabilitySetsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsGet_564339, base: "",
    url: url_AvailabilitySetsGet_564340, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsUpdate_564373 = ref object of OpenApiRestCall_563565
proc url_AvailabilitySetsUpdate_564375(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "availabilitySetName" in path,
        "`availabilitySetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/availabilitySets/"),
               (kind: VariableSegment, value: "availabilitySetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilitySetsUpdate_564374(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an availability set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   availabilitySetName: JString (required)
  ##                      : The name of the availability set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `availabilitySetName` field"
  var valid_564376 = path.getOrDefault("availabilitySetName")
  valid_564376 = validateParameter(valid_564376, JString, required = true,
                                 default = nil)
  if valid_564376 != nil:
    section.add "availabilitySetName", valid_564376
  var valid_564377 = path.getOrDefault("subscriptionId")
  valid_564377 = validateParameter(valid_564377, JString, required = true,
                                 default = nil)
  if valid_564377 != nil:
    section.add "subscriptionId", valid_564377
  var valid_564378 = path.getOrDefault("resourceGroupName")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "resourceGroupName", valid_564378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564379 = query.getOrDefault("api-version")
  valid_564379 = validateParameter(valid_564379, JString, required = true,
                                 default = nil)
  if valid_564379 != nil:
    section.add "api-version", valid_564379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Availability Set operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564381: Call_AvailabilitySetsUpdate_564373; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an availability set.
  ## 
  let valid = call_564381.validator(path, query, header, formData, body)
  let scheme = call_564381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564381.url(scheme.get, call_564381.host, call_564381.base,
                         call_564381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564381, url, valid)

proc call*(call_564382: Call_AvailabilitySetsUpdate_564373;
          availabilitySetName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## availabilitySetsUpdate
  ## Update an availability set.
  ##   availabilitySetName: string (required)
  ##                      : The name of the availability set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Availability Set operation.
  var path_564383 = newJObject()
  var query_564384 = newJObject()
  var body_564385 = newJObject()
  add(path_564383, "availabilitySetName", newJString(availabilitySetName))
  add(query_564384, "api-version", newJString(apiVersion))
  add(path_564383, "subscriptionId", newJString(subscriptionId))
  add(path_564383, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564385 = parameters
  result = call_564382.call(path_564383, query_564384, nil, nil, body_564385)

var availabilitySetsUpdate* = Call_AvailabilitySetsUpdate_564373(
    name: "availabilitySetsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsUpdate_564374, base: "",
    url: url_AvailabilitySetsUpdate_564375, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsDelete_564362 = ref object of OpenApiRestCall_563565
proc url_AvailabilitySetsDelete_564364(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "availabilitySetName" in path,
        "`availabilitySetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/availabilitySets/"),
               (kind: VariableSegment, value: "availabilitySetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilitySetsDelete_564363(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an availability set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   availabilitySetName: JString (required)
  ##                      : The name of the availability set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `availabilitySetName` field"
  var valid_564365 = path.getOrDefault("availabilitySetName")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "availabilitySetName", valid_564365
  var valid_564366 = path.getOrDefault("subscriptionId")
  valid_564366 = validateParameter(valid_564366, JString, required = true,
                                 default = nil)
  if valid_564366 != nil:
    section.add "subscriptionId", valid_564366
  var valid_564367 = path.getOrDefault("resourceGroupName")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "resourceGroupName", valid_564367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564368 = query.getOrDefault("api-version")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "api-version", valid_564368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564369: Call_AvailabilitySetsDelete_564362; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an availability set.
  ## 
  let valid = call_564369.validator(path, query, header, formData, body)
  let scheme = call_564369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564369.url(scheme.get, call_564369.host, call_564369.base,
                         call_564369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564369, url, valid)

proc call*(call_564370: Call_AvailabilitySetsDelete_564362;
          availabilitySetName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## availabilitySetsDelete
  ## Delete an availability set.
  ##   availabilitySetName: string (required)
  ##                      : The name of the availability set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564371 = newJObject()
  var query_564372 = newJObject()
  add(path_564371, "availabilitySetName", newJString(availabilitySetName))
  add(query_564372, "api-version", newJString(apiVersion))
  add(path_564371, "subscriptionId", newJString(subscriptionId))
  add(path_564371, "resourceGroupName", newJString(resourceGroupName))
  result = call_564370.call(path_564371, query_564372, nil, nil, nil)

var availabilitySetsDelete* = Call_AvailabilitySetsDelete_564362(
    name: "availabilitySetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsDelete_564363, base: "",
    url: url_AvailabilitySetsDelete_564364, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsListAvailableSizes_564386 = ref object of OpenApiRestCall_563565
proc url_AvailabilitySetsListAvailableSizes_564388(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "availabilitySetName" in path,
        "`availabilitySetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/availabilitySets/"),
               (kind: VariableSegment, value: "availabilitySetName"),
               (kind: ConstantSegment, value: "/vmSizes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilitySetsListAvailableSizes_564387(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all available virtual machine sizes that can be used to create a new virtual machine in an existing availability set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   availabilitySetName: JString (required)
  ##                      : The name of the availability set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `availabilitySetName` field"
  var valid_564389 = path.getOrDefault("availabilitySetName")
  valid_564389 = validateParameter(valid_564389, JString, required = true,
                                 default = nil)
  if valid_564389 != nil:
    section.add "availabilitySetName", valid_564389
  var valid_564390 = path.getOrDefault("subscriptionId")
  valid_564390 = validateParameter(valid_564390, JString, required = true,
                                 default = nil)
  if valid_564390 != nil:
    section.add "subscriptionId", valid_564390
  var valid_564391 = path.getOrDefault("resourceGroupName")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "resourceGroupName", valid_564391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564392 = query.getOrDefault("api-version")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "api-version", valid_564392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564393: Call_AvailabilitySetsListAvailableSizes_564386;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available virtual machine sizes that can be used to create a new virtual machine in an existing availability set.
  ## 
  let valid = call_564393.validator(path, query, header, formData, body)
  let scheme = call_564393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564393.url(scheme.get, call_564393.host, call_564393.base,
                         call_564393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564393, url, valid)

proc call*(call_564394: Call_AvailabilitySetsListAvailableSizes_564386;
          availabilitySetName: string; apiVersion: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## availabilitySetsListAvailableSizes
  ## Lists all available virtual machine sizes that can be used to create a new virtual machine in an existing availability set.
  ##   availabilitySetName: string (required)
  ##                      : The name of the availability set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564395 = newJObject()
  var query_564396 = newJObject()
  add(path_564395, "availabilitySetName", newJString(availabilitySetName))
  add(query_564396, "api-version", newJString(apiVersion))
  add(path_564395, "subscriptionId", newJString(subscriptionId))
  add(path_564395, "resourceGroupName", newJString(resourceGroupName))
  result = call_564394.call(path_564395, query_564396, nil, nil, nil)

var availabilitySetsListAvailableSizes* = Call_AvailabilitySetsListAvailableSizes_564386(
    name: "availabilitySetsListAvailableSizes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}/vmSizes",
    validator: validate_AvailabilitySetsListAvailableSizes_564387, base: "",
    url: url_AvailabilitySetsListAvailableSizes_564388, schemes: {Scheme.Https})
type
  Call_DedicatedHostGroupsListByResourceGroup_564397 = ref object of OpenApiRestCall_563565
proc url_DedicatedHostGroupsListByResourceGroup_564399(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/hostGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedHostGroupsListByResourceGroup_564398(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the dedicated host groups in the specified resource group. Use the nextLink property in the response to get the next page of dedicated host groups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564400 = path.getOrDefault("subscriptionId")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "subscriptionId", valid_564400
  var valid_564401 = path.getOrDefault("resourceGroupName")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "resourceGroupName", valid_564401
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564402 = query.getOrDefault("api-version")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "api-version", valid_564402
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564403: Call_DedicatedHostGroupsListByResourceGroup_564397;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all of the dedicated host groups in the specified resource group. Use the nextLink property in the response to get the next page of dedicated host groups.
  ## 
  let valid = call_564403.validator(path, query, header, formData, body)
  let scheme = call_564403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564403.url(scheme.get, call_564403.host, call_564403.base,
                         call_564403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564403, url, valid)

proc call*(call_564404: Call_DedicatedHostGroupsListByResourceGroup_564397;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## dedicatedHostGroupsListByResourceGroup
  ## Lists all of the dedicated host groups in the specified resource group. Use the nextLink property in the response to get the next page of dedicated host groups.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564405 = newJObject()
  var query_564406 = newJObject()
  add(query_564406, "api-version", newJString(apiVersion))
  add(path_564405, "subscriptionId", newJString(subscriptionId))
  add(path_564405, "resourceGroupName", newJString(resourceGroupName))
  result = call_564404.call(path_564405, query_564406, nil, nil, nil)

var dedicatedHostGroupsListByResourceGroup* = Call_DedicatedHostGroupsListByResourceGroup_564397(
    name: "dedicatedHostGroupsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups",
    validator: validate_DedicatedHostGroupsListByResourceGroup_564398, base: "",
    url: url_DedicatedHostGroupsListByResourceGroup_564399,
    schemes: {Scheme.Https})
type
  Call_DedicatedHostGroupsCreateOrUpdate_564418 = ref object of OpenApiRestCall_563565
proc url_DedicatedHostGroupsCreateOrUpdate_564420(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hostGroupName" in path, "`hostGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/hostGroups/"),
               (kind: VariableSegment, value: "hostGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedHostGroupsCreateOrUpdate_564419(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a dedicated host group. For details of Dedicated Host and Dedicated Host Groups please see [Dedicated Host Documentation] (https://go.microsoft.com/fwlink/?linkid=2082596)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostGroupName: JString (required)
  ##                : The name of the dedicated host group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `hostGroupName` field"
  var valid_564421 = path.getOrDefault("hostGroupName")
  valid_564421 = validateParameter(valid_564421, JString, required = true,
                                 default = nil)
  if valid_564421 != nil:
    section.add "hostGroupName", valid_564421
  var valid_564422 = path.getOrDefault("subscriptionId")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "subscriptionId", valid_564422
  var valid_564423 = path.getOrDefault("resourceGroupName")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "resourceGroupName", valid_564423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564424 = query.getOrDefault("api-version")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "api-version", valid_564424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Dedicated Host Group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564426: Call_DedicatedHostGroupsCreateOrUpdate_564418;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a dedicated host group. For details of Dedicated Host and Dedicated Host Groups please see [Dedicated Host Documentation] (https://go.microsoft.com/fwlink/?linkid=2082596)
  ## 
  let valid = call_564426.validator(path, query, header, formData, body)
  let scheme = call_564426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564426.url(scheme.get, call_564426.host, call_564426.base,
                         call_564426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564426, url, valid)

proc call*(call_564427: Call_DedicatedHostGroupsCreateOrUpdate_564418;
          apiVersion: string; hostGroupName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## dedicatedHostGroupsCreateOrUpdate
  ## Create or update a dedicated host group. For details of Dedicated Host and Dedicated Host Groups please see [Dedicated Host Documentation] (https://go.microsoft.com/fwlink/?linkid=2082596)
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   hostGroupName: string (required)
  ##                : The name of the dedicated host group.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Dedicated Host Group.
  var path_564428 = newJObject()
  var query_564429 = newJObject()
  var body_564430 = newJObject()
  add(query_564429, "api-version", newJString(apiVersion))
  add(path_564428, "hostGroupName", newJString(hostGroupName))
  add(path_564428, "subscriptionId", newJString(subscriptionId))
  add(path_564428, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564430 = parameters
  result = call_564427.call(path_564428, query_564429, nil, nil, body_564430)

var dedicatedHostGroupsCreateOrUpdate* = Call_DedicatedHostGroupsCreateOrUpdate_564418(
    name: "dedicatedHostGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}",
    validator: validate_DedicatedHostGroupsCreateOrUpdate_564419, base: "",
    url: url_DedicatedHostGroupsCreateOrUpdate_564420, schemes: {Scheme.Https})
type
  Call_DedicatedHostGroupsGet_564407 = ref object of OpenApiRestCall_563565
proc url_DedicatedHostGroupsGet_564409(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hostGroupName" in path, "`hostGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/hostGroups/"),
               (kind: VariableSegment, value: "hostGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedHostGroupsGet_564408(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves information about a dedicated host group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostGroupName: JString (required)
  ##                : The name of the dedicated host group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `hostGroupName` field"
  var valid_564410 = path.getOrDefault("hostGroupName")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "hostGroupName", valid_564410
  var valid_564411 = path.getOrDefault("subscriptionId")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "subscriptionId", valid_564411
  var valid_564412 = path.getOrDefault("resourceGroupName")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = nil)
  if valid_564412 != nil:
    section.add "resourceGroupName", valid_564412
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564413 = query.getOrDefault("api-version")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "api-version", valid_564413
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564414: Call_DedicatedHostGroupsGet_564407; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a dedicated host group.
  ## 
  let valid = call_564414.validator(path, query, header, formData, body)
  let scheme = call_564414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564414.url(scheme.get, call_564414.host, call_564414.base,
                         call_564414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564414, url, valid)

proc call*(call_564415: Call_DedicatedHostGroupsGet_564407; apiVersion: string;
          hostGroupName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## dedicatedHostGroupsGet
  ## Retrieves information about a dedicated host group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   hostGroupName: string (required)
  ##                : The name of the dedicated host group.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564416 = newJObject()
  var query_564417 = newJObject()
  add(query_564417, "api-version", newJString(apiVersion))
  add(path_564416, "hostGroupName", newJString(hostGroupName))
  add(path_564416, "subscriptionId", newJString(subscriptionId))
  add(path_564416, "resourceGroupName", newJString(resourceGroupName))
  result = call_564415.call(path_564416, query_564417, nil, nil, nil)

var dedicatedHostGroupsGet* = Call_DedicatedHostGroupsGet_564407(
    name: "dedicatedHostGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}",
    validator: validate_DedicatedHostGroupsGet_564408, base: "",
    url: url_DedicatedHostGroupsGet_564409, schemes: {Scheme.Https})
type
  Call_DedicatedHostGroupsUpdate_564442 = ref object of OpenApiRestCall_563565
proc url_DedicatedHostGroupsUpdate_564444(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hostGroupName" in path, "`hostGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/hostGroups/"),
               (kind: VariableSegment, value: "hostGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedHostGroupsUpdate_564443(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an dedicated host group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostGroupName: JString (required)
  ##                : The name of the dedicated host group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `hostGroupName` field"
  var valid_564445 = path.getOrDefault("hostGroupName")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "hostGroupName", valid_564445
  var valid_564446 = path.getOrDefault("subscriptionId")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "subscriptionId", valid_564446
  var valid_564447 = path.getOrDefault("resourceGroupName")
  valid_564447 = validateParameter(valid_564447, JString, required = true,
                                 default = nil)
  if valid_564447 != nil:
    section.add "resourceGroupName", valid_564447
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564448 = query.getOrDefault("api-version")
  valid_564448 = validateParameter(valid_564448, JString, required = true,
                                 default = nil)
  if valid_564448 != nil:
    section.add "api-version", valid_564448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Dedicated Host Group operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564450: Call_DedicatedHostGroupsUpdate_564442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an dedicated host group.
  ## 
  let valid = call_564450.validator(path, query, header, formData, body)
  let scheme = call_564450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564450.url(scheme.get, call_564450.host, call_564450.base,
                         call_564450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564450, url, valid)

proc call*(call_564451: Call_DedicatedHostGroupsUpdate_564442; apiVersion: string;
          hostGroupName: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## dedicatedHostGroupsUpdate
  ## Update an dedicated host group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   hostGroupName: string (required)
  ##                : The name of the dedicated host group.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Dedicated Host Group operation.
  var path_564452 = newJObject()
  var query_564453 = newJObject()
  var body_564454 = newJObject()
  add(query_564453, "api-version", newJString(apiVersion))
  add(path_564452, "hostGroupName", newJString(hostGroupName))
  add(path_564452, "subscriptionId", newJString(subscriptionId))
  add(path_564452, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564454 = parameters
  result = call_564451.call(path_564452, query_564453, nil, nil, body_564454)

var dedicatedHostGroupsUpdate* = Call_DedicatedHostGroupsUpdate_564442(
    name: "dedicatedHostGroupsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}",
    validator: validate_DedicatedHostGroupsUpdate_564443, base: "",
    url: url_DedicatedHostGroupsUpdate_564444, schemes: {Scheme.Https})
type
  Call_DedicatedHostGroupsDelete_564431 = ref object of OpenApiRestCall_563565
proc url_DedicatedHostGroupsDelete_564433(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hostGroupName" in path, "`hostGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/hostGroups/"),
               (kind: VariableSegment, value: "hostGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedHostGroupsDelete_564432(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a dedicated host group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostGroupName: JString (required)
  ##                : The name of the dedicated host group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `hostGroupName` field"
  var valid_564434 = path.getOrDefault("hostGroupName")
  valid_564434 = validateParameter(valid_564434, JString, required = true,
                                 default = nil)
  if valid_564434 != nil:
    section.add "hostGroupName", valid_564434
  var valid_564435 = path.getOrDefault("subscriptionId")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = nil)
  if valid_564435 != nil:
    section.add "subscriptionId", valid_564435
  var valid_564436 = path.getOrDefault("resourceGroupName")
  valid_564436 = validateParameter(valid_564436, JString, required = true,
                                 default = nil)
  if valid_564436 != nil:
    section.add "resourceGroupName", valid_564436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564437 = query.getOrDefault("api-version")
  valid_564437 = validateParameter(valid_564437, JString, required = true,
                                 default = nil)
  if valid_564437 != nil:
    section.add "api-version", valid_564437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564438: Call_DedicatedHostGroupsDelete_564431; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a dedicated host group.
  ## 
  let valid = call_564438.validator(path, query, header, formData, body)
  let scheme = call_564438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564438.url(scheme.get, call_564438.host, call_564438.base,
                         call_564438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564438, url, valid)

proc call*(call_564439: Call_DedicatedHostGroupsDelete_564431; apiVersion: string;
          hostGroupName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## dedicatedHostGroupsDelete
  ## Delete a dedicated host group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   hostGroupName: string (required)
  ##                : The name of the dedicated host group.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564440 = newJObject()
  var query_564441 = newJObject()
  add(query_564441, "api-version", newJString(apiVersion))
  add(path_564440, "hostGroupName", newJString(hostGroupName))
  add(path_564440, "subscriptionId", newJString(subscriptionId))
  add(path_564440, "resourceGroupName", newJString(resourceGroupName))
  result = call_564439.call(path_564440, query_564441, nil, nil, nil)

var dedicatedHostGroupsDelete* = Call_DedicatedHostGroupsDelete_564431(
    name: "dedicatedHostGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}",
    validator: validate_DedicatedHostGroupsDelete_564432, base: "",
    url: url_DedicatedHostGroupsDelete_564433, schemes: {Scheme.Https})
type
  Call_DedicatedHostsListByHostGroup_564455 = ref object of OpenApiRestCall_563565
proc url_DedicatedHostsListByHostGroup_564457(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hostGroupName" in path, "`hostGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/hostGroups/"),
               (kind: VariableSegment, value: "hostGroupName"),
               (kind: ConstantSegment, value: "/hosts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedHostsListByHostGroup_564456(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the dedicated hosts in the specified dedicated host group. Use the nextLink property in the response to get the next page of dedicated hosts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostGroupName: JString (required)
  ##                : The name of the dedicated host group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `hostGroupName` field"
  var valid_564458 = path.getOrDefault("hostGroupName")
  valid_564458 = validateParameter(valid_564458, JString, required = true,
                                 default = nil)
  if valid_564458 != nil:
    section.add "hostGroupName", valid_564458
  var valid_564459 = path.getOrDefault("subscriptionId")
  valid_564459 = validateParameter(valid_564459, JString, required = true,
                                 default = nil)
  if valid_564459 != nil:
    section.add "subscriptionId", valid_564459
  var valid_564460 = path.getOrDefault("resourceGroupName")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "resourceGroupName", valid_564460
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564461 = query.getOrDefault("api-version")
  valid_564461 = validateParameter(valid_564461, JString, required = true,
                                 default = nil)
  if valid_564461 != nil:
    section.add "api-version", valid_564461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564462: Call_DedicatedHostsListByHostGroup_564455; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the dedicated hosts in the specified dedicated host group. Use the nextLink property in the response to get the next page of dedicated hosts.
  ## 
  let valid = call_564462.validator(path, query, header, formData, body)
  let scheme = call_564462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564462.url(scheme.get, call_564462.host, call_564462.base,
                         call_564462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564462, url, valid)

proc call*(call_564463: Call_DedicatedHostsListByHostGroup_564455;
          apiVersion: string; hostGroupName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## dedicatedHostsListByHostGroup
  ## Lists all of the dedicated hosts in the specified dedicated host group. Use the nextLink property in the response to get the next page of dedicated hosts.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   hostGroupName: string (required)
  ##                : The name of the dedicated host group.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564464 = newJObject()
  var query_564465 = newJObject()
  add(query_564465, "api-version", newJString(apiVersion))
  add(path_564464, "hostGroupName", newJString(hostGroupName))
  add(path_564464, "subscriptionId", newJString(subscriptionId))
  add(path_564464, "resourceGroupName", newJString(resourceGroupName))
  result = call_564463.call(path_564464, query_564465, nil, nil, nil)

var dedicatedHostsListByHostGroup* = Call_DedicatedHostsListByHostGroup_564455(
    name: "dedicatedHostsListByHostGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}/hosts",
    validator: validate_DedicatedHostsListByHostGroup_564456, base: "",
    url: url_DedicatedHostsListByHostGroup_564457, schemes: {Scheme.Https})
type
  Call_DedicatedHostsCreateOrUpdate_564492 = ref object of OpenApiRestCall_563565
proc url_DedicatedHostsCreateOrUpdate_564494(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hostGroupName" in path, "`hostGroupName` is a required path parameter"
  assert "hostName" in path, "`hostName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/hostGroups/"),
               (kind: VariableSegment, value: "hostGroupName"),
               (kind: ConstantSegment, value: "/hosts/"),
               (kind: VariableSegment, value: "hostName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedHostsCreateOrUpdate_564493(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a dedicated host .
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostGroupName: JString (required)
  ##                : The name of the dedicated host group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hostName: JString (required)
  ##           : The name of the dedicated host .
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `hostGroupName` field"
  var valid_564495 = path.getOrDefault("hostGroupName")
  valid_564495 = validateParameter(valid_564495, JString, required = true,
                                 default = nil)
  if valid_564495 != nil:
    section.add "hostGroupName", valid_564495
  var valid_564496 = path.getOrDefault("subscriptionId")
  valid_564496 = validateParameter(valid_564496, JString, required = true,
                                 default = nil)
  if valid_564496 != nil:
    section.add "subscriptionId", valid_564496
  var valid_564497 = path.getOrDefault("resourceGroupName")
  valid_564497 = validateParameter(valid_564497, JString, required = true,
                                 default = nil)
  if valid_564497 != nil:
    section.add "resourceGroupName", valid_564497
  var valid_564498 = path.getOrDefault("hostName")
  valid_564498 = validateParameter(valid_564498, JString, required = true,
                                 default = nil)
  if valid_564498 != nil:
    section.add "hostName", valid_564498
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564499 = query.getOrDefault("api-version")
  valid_564499 = validateParameter(valid_564499, JString, required = true,
                                 default = nil)
  if valid_564499 != nil:
    section.add "api-version", valid_564499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Dedicated Host.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564501: Call_DedicatedHostsCreateOrUpdate_564492; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a dedicated host .
  ## 
  let valid = call_564501.validator(path, query, header, formData, body)
  let scheme = call_564501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564501.url(scheme.get, call_564501.host, call_564501.base,
                         call_564501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564501, url, valid)

proc call*(call_564502: Call_DedicatedHostsCreateOrUpdate_564492;
          apiVersion: string; hostGroupName: string; subscriptionId: string;
          resourceGroupName: string; hostName: string; parameters: JsonNode): Recallable =
  ## dedicatedHostsCreateOrUpdate
  ## Create or update a dedicated host .
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   hostGroupName: string (required)
  ##                : The name of the dedicated host group.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hostName: string (required)
  ##           : The name of the dedicated host .
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Dedicated Host.
  var path_564503 = newJObject()
  var query_564504 = newJObject()
  var body_564505 = newJObject()
  add(query_564504, "api-version", newJString(apiVersion))
  add(path_564503, "hostGroupName", newJString(hostGroupName))
  add(path_564503, "subscriptionId", newJString(subscriptionId))
  add(path_564503, "resourceGroupName", newJString(resourceGroupName))
  add(path_564503, "hostName", newJString(hostName))
  if parameters != nil:
    body_564505 = parameters
  result = call_564502.call(path_564503, query_564504, nil, nil, body_564505)

var dedicatedHostsCreateOrUpdate* = Call_DedicatedHostsCreateOrUpdate_564492(
    name: "dedicatedHostsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}/hosts/{hostName}",
    validator: validate_DedicatedHostsCreateOrUpdate_564493, base: "",
    url: url_DedicatedHostsCreateOrUpdate_564494, schemes: {Scheme.Https})
type
  Call_DedicatedHostsGet_564466 = ref object of OpenApiRestCall_563565
proc url_DedicatedHostsGet_564468(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hostGroupName" in path, "`hostGroupName` is a required path parameter"
  assert "hostName" in path, "`hostName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/hostGroups/"),
               (kind: VariableSegment, value: "hostGroupName"),
               (kind: ConstantSegment, value: "/hosts/"),
               (kind: VariableSegment, value: "hostName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedHostsGet_564467(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves information about a dedicated host.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostGroupName: JString (required)
  ##                : The name of the dedicated host group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hostName: JString (required)
  ##           : The name of the dedicated host.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `hostGroupName` field"
  var valid_564469 = path.getOrDefault("hostGroupName")
  valid_564469 = validateParameter(valid_564469, JString, required = true,
                                 default = nil)
  if valid_564469 != nil:
    section.add "hostGroupName", valid_564469
  var valid_564470 = path.getOrDefault("subscriptionId")
  valid_564470 = validateParameter(valid_564470, JString, required = true,
                                 default = nil)
  if valid_564470 != nil:
    section.add "subscriptionId", valid_564470
  var valid_564471 = path.getOrDefault("resourceGroupName")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "resourceGroupName", valid_564471
  var valid_564472 = path.getOrDefault("hostName")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "hostName", valid_564472
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564473 = query.getOrDefault("api-version")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "api-version", valid_564473
  var valid_564487 = query.getOrDefault("$expand")
  valid_564487 = validateParameter(valid_564487, JString, required = false,
                                 default = newJString("instanceView"))
  if valid_564487 != nil:
    section.add "$expand", valid_564487
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564488: Call_DedicatedHostsGet_564466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a dedicated host.
  ## 
  let valid = call_564488.validator(path, query, header, formData, body)
  let scheme = call_564488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564488.url(scheme.get, call_564488.host, call_564488.base,
                         call_564488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564488, url, valid)

proc call*(call_564489: Call_DedicatedHostsGet_564466; apiVersion: string;
          hostGroupName: string; subscriptionId: string; resourceGroupName: string;
          hostName: string; Expand: string = "instanceView"): Recallable =
  ## dedicatedHostsGet
  ## Retrieves information about a dedicated host.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   hostGroupName: string (required)
  ##                : The name of the dedicated host group.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hostName: string (required)
  ##           : The name of the dedicated host.
  var path_564490 = newJObject()
  var query_564491 = newJObject()
  add(query_564491, "api-version", newJString(apiVersion))
  add(query_564491, "$expand", newJString(Expand))
  add(path_564490, "hostGroupName", newJString(hostGroupName))
  add(path_564490, "subscriptionId", newJString(subscriptionId))
  add(path_564490, "resourceGroupName", newJString(resourceGroupName))
  add(path_564490, "hostName", newJString(hostName))
  result = call_564489.call(path_564490, query_564491, nil, nil, nil)

var dedicatedHostsGet* = Call_DedicatedHostsGet_564466(name: "dedicatedHostsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}/hosts/{hostName}",
    validator: validate_DedicatedHostsGet_564467, base: "",
    url: url_DedicatedHostsGet_564468, schemes: {Scheme.Https})
type
  Call_DedicatedHostsUpdate_564518 = ref object of OpenApiRestCall_563565
proc url_DedicatedHostsUpdate_564520(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hostGroupName" in path, "`hostGroupName` is a required path parameter"
  assert "hostName" in path, "`hostName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/hostGroups/"),
               (kind: VariableSegment, value: "hostGroupName"),
               (kind: ConstantSegment, value: "/hosts/"),
               (kind: VariableSegment, value: "hostName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedHostsUpdate_564519(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an dedicated host .
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostGroupName: JString (required)
  ##                : The name of the dedicated host group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hostName: JString (required)
  ##           : The name of the dedicated host .
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `hostGroupName` field"
  var valid_564521 = path.getOrDefault("hostGroupName")
  valid_564521 = validateParameter(valid_564521, JString, required = true,
                                 default = nil)
  if valid_564521 != nil:
    section.add "hostGroupName", valid_564521
  var valid_564522 = path.getOrDefault("subscriptionId")
  valid_564522 = validateParameter(valid_564522, JString, required = true,
                                 default = nil)
  if valid_564522 != nil:
    section.add "subscriptionId", valid_564522
  var valid_564523 = path.getOrDefault("resourceGroupName")
  valid_564523 = validateParameter(valid_564523, JString, required = true,
                                 default = nil)
  if valid_564523 != nil:
    section.add "resourceGroupName", valid_564523
  var valid_564524 = path.getOrDefault("hostName")
  valid_564524 = validateParameter(valid_564524, JString, required = true,
                                 default = nil)
  if valid_564524 != nil:
    section.add "hostName", valid_564524
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564525 = query.getOrDefault("api-version")
  valid_564525 = validateParameter(valid_564525, JString, required = true,
                                 default = nil)
  if valid_564525 != nil:
    section.add "api-version", valid_564525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Dedicated Host operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564527: Call_DedicatedHostsUpdate_564518; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an dedicated host .
  ## 
  let valid = call_564527.validator(path, query, header, formData, body)
  let scheme = call_564527.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564527.url(scheme.get, call_564527.host, call_564527.base,
                         call_564527.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564527, url, valid)

proc call*(call_564528: Call_DedicatedHostsUpdate_564518; apiVersion: string;
          hostGroupName: string; subscriptionId: string; resourceGroupName: string;
          hostName: string; parameters: JsonNode): Recallable =
  ## dedicatedHostsUpdate
  ## Update an dedicated host .
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   hostGroupName: string (required)
  ##                : The name of the dedicated host group.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hostName: string (required)
  ##           : The name of the dedicated host .
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Dedicated Host operation.
  var path_564529 = newJObject()
  var query_564530 = newJObject()
  var body_564531 = newJObject()
  add(query_564530, "api-version", newJString(apiVersion))
  add(path_564529, "hostGroupName", newJString(hostGroupName))
  add(path_564529, "subscriptionId", newJString(subscriptionId))
  add(path_564529, "resourceGroupName", newJString(resourceGroupName))
  add(path_564529, "hostName", newJString(hostName))
  if parameters != nil:
    body_564531 = parameters
  result = call_564528.call(path_564529, query_564530, nil, nil, body_564531)

var dedicatedHostsUpdate* = Call_DedicatedHostsUpdate_564518(
    name: "dedicatedHostsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}/hosts/{hostName}",
    validator: validate_DedicatedHostsUpdate_564519, base: "",
    url: url_DedicatedHostsUpdate_564520, schemes: {Scheme.Https})
type
  Call_DedicatedHostsDelete_564506 = ref object of OpenApiRestCall_563565
proc url_DedicatedHostsDelete_564508(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "hostGroupName" in path, "`hostGroupName` is a required path parameter"
  assert "hostName" in path, "`hostName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/hostGroups/"),
               (kind: VariableSegment, value: "hostGroupName"),
               (kind: ConstantSegment, value: "/hosts/"),
               (kind: VariableSegment, value: "hostName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DedicatedHostsDelete_564507(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a dedicated host.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostGroupName: JString (required)
  ##                : The name of the dedicated host group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   hostName: JString (required)
  ##           : The name of the dedicated host.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `hostGroupName` field"
  var valid_564509 = path.getOrDefault("hostGroupName")
  valid_564509 = validateParameter(valid_564509, JString, required = true,
                                 default = nil)
  if valid_564509 != nil:
    section.add "hostGroupName", valid_564509
  var valid_564510 = path.getOrDefault("subscriptionId")
  valid_564510 = validateParameter(valid_564510, JString, required = true,
                                 default = nil)
  if valid_564510 != nil:
    section.add "subscriptionId", valid_564510
  var valid_564511 = path.getOrDefault("resourceGroupName")
  valid_564511 = validateParameter(valid_564511, JString, required = true,
                                 default = nil)
  if valid_564511 != nil:
    section.add "resourceGroupName", valid_564511
  var valid_564512 = path.getOrDefault("hostName")
  valid_564512 = validateParameter(valid_564512, JString, required = true,
                                 default = nil)
  if valid_564512 != nil:
    section.add "hostName", valid_564512
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564513 = query.getOrDefault("api-version")
  valid_564513 = validateParameter(valid_564513, JString, required = true,
                                 default = nil)
  if valid_564513 != nil:
    section.add "api-version", valid_564513
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564514: Call_DedicatedHostsDelete_564506; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a dedicated host.
  ## 
  let valid = call_564514.validator(path, query, header, formData, body)
  let scheme = call_564514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564514.url(scheme.get, call_564514.host, call_564514.base,
                         call_564514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564514, url, valid)

proc call*(call_564515: Call_DedicatedHostsDelete_564506; apiVersion: string;
          hostGroupName: string; subscriptionId: string; resourceGroupName: string;
          hostName: string): Recallable =
  ## dedicatedHostsDelete
  ## Delete a dedicated host.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   hostGroupName: string (required)
  ##                : The name of the dedicated host group.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   hostName: string (required)
  ##           : The name of the dedicated host.
  var path_564516 = newJObject()
  var query_564517 = newJObject()
  add(query_564517, "api-version", newJString(apiVersion))
  add(path_564516, "hostGroupName", newJString(hostGroupName))
  add(path_564516, "subscriptionId", newJString(subscriptionId))
  add(path_564516, "resourceGroupName", newJString(resourceGroupName))
  add(path_564516, "hostName", newJString(hostName))
  result = call_564515.call(path_564516, query_564517, nil, nil, nil)

var dedicatedHostsDelete* = Call_DedicatedHostsDelete_564506(
    name: "dedicatedHostsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}/hosts/{hostName}",
    validator: validate_DedicatedHostsDelete_564507, base: "",
    url: url_DedicatedHostsDelete_564508, schemes: {Scheme.Https})
type
  Call_ImagesListByResourceGroup_564532 = ref object of OpenApiRestCall_563565
proc url_ImagesListByResourceGroup_564534(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/images")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ImagesListByResourceGroup_564533(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of images under a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564535 = path.getOrDefault("subscriptionId")
  valid_564535 = validateParameter(valid_564535, JString, required = true,
                                 default = nil)
  if valid_564535 != nil:
    section.add "subscriptionId", valid_564535
  var valid_564536 = path.getOrDefault("resourceGroupName")
  valid_564536 = validateParameter(valid_564536, JString, required = true,
                                 default = nil)
  if valid_564536 != nil:
    section.add "resourceGroupName", valid_564536
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564537 = query.getOrDefault("api-version")
  valid_564537 = validateParameter(valid_564537, JString, required = true,
                                 default = nil)
  if valid_564537 != nil:
    section.add "api-version", valid_564537
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564538: Call_ImagesListByResourceGroup_564532; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of images under a resource group.
  ## 
  let valid = call_564538.validator(path, query, header, formData, body)
  let scheme = call_564538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564538.url(scheme.get, call_564538.host, call_564538.base,
                         call_564538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564538, url, valid)

proc call*(call_564539: Call_ImagesListByResourceGroup_564532; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## imagesListByResourceGroup
  ## Gets the list of images under a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564540 = newJObject()
  var query_564541 = newJObject()
  add(query_564541, "api-version", newJString(apiVersion))
  add(path_564540, "subscriptionId", newJString(subscriptionId))
  add(path_564540, "resourceGroupName", newJString(resourceGroupName))
  result = call_564539.call(path_564540, query_564541, nil, nil, nil)

var imagesListByResourceGroup* = Call_ImagesListByResourceGroup_564532(
    name: "imagesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images",
    validator: validate_ImagesListByResourceGroup_564533, base: "",
    url: url_ImagesListByResourceGroup_564534, schemes: {Scheme.Https})
type
  Call_ImagesCreateOrUpdate_564554 = ref object of OpenApiRestCall_563565
proc url_ImagesCreateOrUpdate_564556(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageName" in path, "`imageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/images/"),
               (kind: VariableSegment, value: "imageName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ImagesCreateOrUpdate_564555(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageName: JString (required)
  ##            : The name of the image.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `imageName` field"
  var valid_564557 = path.getOrDefault("imageName")
  valid_564557 = validateParameter(valid_564557, JString, required = true,
                                 default = nil)
  if valid_564557 != nil:
    section.add "imageName", valid_564557
  var valid_564558 = path.getOrDefault("subscriptionId")
  valid_564558 = validateParameter(valid_564558, JString, required = true,
                                 default = nil)
  if valid_564558 != nil:
    section.add "subscriptionId", valid_564558
  var valid_564559 = path.getOrDefault("resourceGroupName")
  valid_564559 = validateParameter(valid_564559, JString, required = true,
                                 default = nil)
  if valid_564559 != nil:
    section.add "resourceGroupName", valid_564559
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564560 = query.getOrDefault("api-version")
  valid_564560 = validateParameter(valid_564560, JString, required = true,
                                 default = nil)
  if valid_564560 != nil:
    section.add "api-version", valid_564560
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Image operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564562: Call_ImagesCreateOrUpdate_564554; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an image.
  ## 
  let valid = call_564562.validator(path, query, header, formData, body)
  let scheme = call_564562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564562.url(scheme.get, call_564562.host, call_564562.base,
                         call_564562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564562, url, valid)

proc call*(call_564563: Call_ImagesCreateOrUpdate_564554; imageName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## imagesCreateOrUpdate
  ## Create or update an image.
  ##   imageName: string (required)
  ##            : The name of the image.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Image operation.
  var path_564564 = newJObject()
  var query_564565 = newJObject()
  var body_564566 = newJObject()
  add(path_564564, "imageName", newJString(imageName))
  add(query_564565, "api-version", newJString(apiVersion))
  add(path_564564, "subscriptionId", newJString(subscriptionId))
  add(path_564564, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564566 = parameters
  result = call_564563.call(path_564564, query_564565, nil, nil, body_564566)

var imagesCreateOrUpdate* = Call_ImagesCreateOrUpdate_564554(
    name: "imagesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesCreateOrUpdate_564555, base: "",
    url: url_ImagesCreateOrUpdate_564556, schemes: {Scheme.Https})
type
  Call_ImagesGet_564542 = ref object of OpenApiRestCall_563565
proc url_ImagesGet_564544(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageName" in path, "`imageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/images/"),
               (kind: VariableSegment, value: "imageName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ImagesGet_564543(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageName: JString (required)
  ##            : The name of the image.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `imageName` field"
  var valid_564545 = path.getOrDefault("imageName")
  valid_564545 = validateParameter(valid_564545, JString, required = true,
                                 default = nil)
  if valid_564545 != nil:
    section.add "imageName", valid_564545
  var valid_564546 = path.getOrDefault("subscriptionId")
  valid_564546 = validateParameter(valid_564546, JString, required = true,
                                 default = nil)
  if valid_564546 != nil:
    section.add "subscriptionId", valid_564546
  var valid_564547 = path.getOrDefault("resourceGroupName")
  valid_564547 = validateParameter(valid_564547, JString, required = true,
                                 default = nil)
  if valid_564547 != nil:
    section.add "resourceGroupName", valid_564547
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564548 = query.getOrDefault("api-version")
  valid_564548 = validateParameter(valid_564548, JString, required = true,
                                 default = nil)
  if valid_564548 != nil:
    section.add "api-version", valid_564548
  var valid_564549 = query.getOrDefault("$expand")
  valid_564549 = validateParameter(valid_564549, JString, required = false,
                                 default = nil)
  if valid_564549 != nil:
    section.add "$expand", valid_564549
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564550: Call_ImagesGet_564542; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an image.
  ## 
  let valid = call_564550.validator(path, query, header, formData, body)
  let scheme = call_564550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564550.url(scheme.get, call_564550.host, call_564550.base,
                         call_564550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564550, url, valid)

proc call*(call_564551: Call_ImagesGet_564542; imageName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; Expand: string = ""): Recallable =
  ## imagesGet
  ## Gets an image.
  ##   imageName: string (required)
  ##            : The name of the image.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564552 = newJObject()
  var query_564553 = newJObject()
  add(path_564552, "imageName", newJString(imageName))
  add(query_564553, "api-version", newJString(apiVersion))
  add(query_564553, "$expand", newJString(Expand))
  add(path_564552, "subscriptionId", newJString(subscriptionId))
  add(path_564552, "resourceGroupName", newJString(resourceGroupName))
  result = call_564551.call(path_564552, query_564553, nil, nil, nil)

var imagesGet* = Call_ImagesGet_564542(name: "imagesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
                                    validator: validate_ImagesGet_564543,
                                    base: "", url: url_ImagesGet_564544,
                                    schemes: {Scheme.Https})
type
  Call_ImagesUpdate_564578 = ref object of OpenApiRestCall_563565
proc url_ImagesUpdate_564580(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageName" in path, "`imageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/images/"),
               (kind: VariableSegment, value: "imageName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ImagesUpdate_564579(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageName: JString (required)
  ##            : The name of the image.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `imageName` field"
  var valid_564581 = path.getOrDefault("imageName")
  valid_564581 = validateParameter(valid_564581, JString, required = true,
                                 default = nil)
  if valid_564581 != nil:
    section.add "imageName", valid_564581
  var valid_564582 = path.getOrDefault("subscriptionId")
  valid_564582 = validateParameter(valid_564582, JString, required = true,
                                 default = nil)
  if valid_564582 != nil:
    section.add "subscriptionId", valid_564582
  var valid_564583 = path.getOrDefault("resourceGroupName")
  valid_564583 = validateParameter(valid_564583, JString, required = true,
                                 default = nil)
  if valid_564583 != nil:
    section.add "resourceGroupName", valid_564583
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564584 = query.getOrDefault("api-version")
  valid_564584 = validateParameter(valid_564584, JString, required = true,
                                 default = nil)
  if valid_564584 != nil:
    section.add "api-version", valid_564584
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Image operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564586: Call_ImagesUpdate_564578; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an image.
  ## 
  let valid = call_564586.validator(path, query, header, formData, body)
  let scheme = call_564586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564586.url(scheme.get, call_564586.host, call_564586.base,
                         call_564586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564586, url, valid)

proc call*(call_564587: Call_ImagesUpdate_564578; imageName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## imagesUpdate
  ## Update an image.
  ##   imageName: string (required)
  ##            : The name of the image.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Image operation.
  var path_564588 = newJObject()
  var query_564589 = newJObject()
  var body_564590 = newJObject()
  add(path_564588, "imageName", newJString(imageName))
  add(query_564589, "api-version", newJString(apiVersion))
  add(path_564588, "subscriptionId", newJString(subscriptionId))
  add(path_564588, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564590 = parameters
  result = call_564587.call(path_564588, query_564589, nil, nil, body_564590)

var imagesUpdate* = Call_ImagesUpdate_564578(name: "imagesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesUpdate_564579, base: "", url: url_ImagesUpdate_564580,
    schemes: {Scheme.Https})
type
  Call_ImagesDelete_564567 = ref object of OpenApiRestCall_563565
proc url_ImagesDelete_564569(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "imageName" in path, "`imageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Compute/images/"),
               (kind: VariableSegment, value: "imageName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ImagesDelete_564568(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an Image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   imageName: JString (required)
  ##            : The name of the image.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `imageName` field"
  var valid_564570 = path.getOrDefault("imageName")
  valid_564570 = validateParameter(valid_564570, JString, required = true,
                                 default = nil)
  if valid_564570 != nil:
    section.add "imageName", valid_564570
  var valid_564571 = path.getOrDefault("subscriptionId")
  valid_564571 = validateParameter(valid_564571, JString, required = true,
                                 default = nil)
  if valid_564571 != nil:
    section.add "subscriptionId", valid_564571
  var valid_564572 = path.getOrDefault("resourceGroupName")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = nil)
  if valid_564572 != nil:
    section.add "resourceGroupName", valid_564572
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564573 = query.getOrDefault("api-version")
  valid_564573 = validateParameter(valid_564573, JString, required = true,
                                 default = nil)
  if valid_564573 != nil:
    section.add "api-version", valid_564573
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564574: Call_ImagesDelete_564567; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Image.
  ## 
  let valid = call_564574.validator(path, query, header, formData, body)
  let scheme = call_564574.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564574.url(scheme.get, call_564574.host, call_564574.base,
                         call_564574.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564574, url, valid)

proc call*(call_564575: Call_ImagesDelete_564567; imageName: string;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## imagesDelete
  ## Deletes an Image.
  ##   imageName: string (required)
  ##            : The name of the image.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564576 = newJObject()
  var query_564577 = newJObject()
  add(path_564576, "imageName", newJString(imageName))
  add(query_564577, "api-version", newJString(apiVersion))
  add(path_564576, "subscriptionId", newJString(subscriptionId))
  add(path_564576, "resourceGroupName", newJString(resourceGroupName))
  result = call_564575.call(path_564576, query_564577, nil, nil, nil)

var imagesDelete* = Call_ImagesDelete_564567(name: "imagesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesDelete_564568, base: "", url: url_ImagesDelete_564569,
    schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsListByResourceGroup_564591 = ref object of OpenApiRestCall_563565
proc url_ProximityPlacementGroupsListByResourceGroup_564593(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/proximityPlacementGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximityPlacementGroupsListByResourceGroup_564592(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all proximity placement groups in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564594 = path.getOrDefault("subscriptionId")
  valid_564594 = validateParameter(valid_564594, JString, required = true,
                                 default = nil)
  if valid_564594 != nil:
    section.add "subscriptionId", valid_564594
  var valid_564595 = path.getOrDefault("resourceGroupName")
  valid_564595 = validateParameter(valid_564595, JString, required = true,
                                 default = nil)
  if valid_564595 != nil:
    section.add "resourceGroupName", valid_564595
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564596 = query.getOrDefault("api-version")
  valid_564596 = validateParameter(valid_564596, JString, required = true,
                                 default = nil)
  if valid_564596 != nil:
    section.add "api-version", valid_564596
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564597: Call_ProximityPlacementGroupsListByResourceGroup_564591;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all proximity placement groups in a resource group.
  ## 
  let valid = call_564597.validator(path, query, header, formData, body)
  let scheme = call_564597.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564597.url(scheme.get, call_564597.host, call_564597.base,
                         call_564597.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564597, url, valid)

proc call*(call_564598: Call_ProximityPlacementGroupsListByResourceGroup_564591;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## proximityPlacementGroupsListByResourceGroup
  ## Lists all proximity placement groups in a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564599 = newJObject()
  var query_564600 = newJObject()
  add(query_564600, "api-version", newJString(apiVersion))
  add(path_564599, "subscriptionId", newJString(subscriptionId))
  add(path_564599, "resourceGroupName", newJString(resourceGroupName))
  result = call_564598.call(path_564599, query_564600, nil, nil, nil)

var proximityPlacementGroupsListByResourceGroup* = Call_ProximityPlacementGroupsListByResourceGroup_564591(
    name: "proximityPlacementGroupsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups",
    validator: validate_ProximityPlacementGroupsListByResourceGroup_564592,
    base: "", url: url_ProximityPlacementGroupsListByResourceGroup_564593,
    schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsCreateOrUpdate_564612 = ref object of OpenApiRestCall_563565
proc url_ProximityPlacementGroupsCreateOrUpdate_564614(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "proximityPlacementGroupName" in path,
        "`proximityPlacementGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/proximityPlacementGroups/"),
               (kind: VariableSegment, value: "proximityPlacementGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximityPlacementGroupsCreateOrUpdate_564613(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a proximity placement group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   proximityPlacementGroupName: JString (required)
  ##                              : The name of the proximity placement group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `proximityPlacementGroupName` field"
  var valid_564615 = path.getOrDefault("proximityPlacementGroupName")
  valid_564615 = validateParameter(valid_564615, JString, required = true,
                                 default = nil)
  if valid_564615 != nil:
    section.add "proximityPlacementGroupName", valid_564615
  var valid_564616 = path.getOrDefault("subscriptionId")
  valid_564616 = validateParameter(valid_564616, JString, required = true,
                                 default = nil)
  if valid_564616 != nil:
    section.add "subscriptionId", valid_564616
  var valid_564617 = path.getOrDefault("resourceGroupName")
  valid_564617 = validateParameter(valid_564617, JString, required = true,
                                 default = nil)
  if valid_564617 != nil:
    section.add "resourceGroupName", valid_564617
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564618 = query.getOrDefault("api-version")
  valid_564618 = validateParameter(valid_564618, JString, required = true,
                                 default = nil)
  if valid_564618 != nil:
    section.add "api-version", valid_564618
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Proximity Placement Group operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564620: Call_ProximityPlacementGroupsCreateOrUpdate_564612;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a proximity placement group.
  ## 
  let valid = call_564620.validator(path, query, header, formData, body)
  let scheme = call_564620.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564620.url(scheme.get, call_564620.host, call_564620.base,
                         call_564620.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564620, url, valid)

proc call*(call_564621: Call_ProximityPlacementGroupsCreateOrUpdate_564612;
          apiVersion: string; proximityPlacementGroupName: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## proximityPlacementGroupsCreateOrUpdate
  ## Create or update a proximity placement group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   proximityPlacementGroupName: string (required)
  ##                              : The name of the proximity placement group.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Proximity Placement Group operation.
  var path_564622 = newJObject()
  var query_564623 = newJObject()
  var body_564624 = newJObject()
  add(query_564623, "api-version", newJString(apiVersion))
  add(path_564622, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  add(path_564622, "subscriptionId", newJString(subscriptionId))
  add(path_564622, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564624 = parameters
  result = call_564621.call(path_564622, query_564623, nil, nil, body_564624)

var proximityPlacementGroupsCreateOrUpdate* = Call_ProximityPlacementGroupsCreateOrUpdate_564612(
    name: "proximityPlacementGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsCreateOrUpdate_564613, base: "",
    url: url_ProximityPlacementGroupsCreateOrUpdate_564614,
    schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsGet_564601 = ref object of OpenApiRestCall_563565
proc url_ProximityPlacementGroupsGet_564603(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "proximityPlacementGroupName" in path,
        "`proximityPlacementGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/proximityPlacementGroups/"),
               (kind: VariableSegment, value: "proximityPlacementGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximityPlacementGroupsGet_564602(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves information about a proximity placement group .
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   proximityPlacementGroupName: JString (required)
  ##                              : The name of the proximity placement group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `proximityPlacementGroupName` field"
  var valid_564604 = path.getOrDefault("proximityPlacementGroupName")
  valid_564604 = validateParameter(valid_564604, JString, required = true,
                                 default = nil)
  if valid_564604 != nil:
    section.add "proximityPlacementGroupName", valid_564604
  var valid_564605 = path.getOrDefault("subscriptionId")
  valid_564605 = validateParameter(valid_564605, JString, required = true,
                                 default = nil)
  if valid_564605 != nil:
    section.add "subscriptionId", valid_564605
  var valid_564606 = path.getOrDefault("resourceGroupName")
  valid_564606 = validateParameter(valid_564606, JString, required = true,
                                 default = nil)
  if valid_564606 != nil:
    section.add "resourceGroupName", valid_564606
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564607 = query.getOrDefault("api-version")
  valid_564607 = validateParameter(valid_564607, JString, required = true,
                                 default = nil)
  if valid_564607 != nil:
    section.add "api-version", valid_564607
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564608: Call_ProximityPlacementGroupsGet_564601; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a proximity placement group .
  ## 
  let valid = call_564608.validator(path, query, header, formData, body)
  let scheme = call_564608.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564608.url(scheme.get, call_564608.host, call_564608.base,
                         call_564608.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564608, url, valid)

proc call*(call_564609: Call_ProximityPlacementGroupsGet_564601;
          apiVersion: string; proximityPlacementGroupName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## proximityPlacementGroupsGet
  ## Retrieves information about a proximity placement group .
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   proximityPlacementGroupName: string (required)
  ##                              : The name of the proximity placement group.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564610 = newJObject()
  var query_564611 = newJObject()
  add(query_564611, "api-version", newJString(apiVersion))
  add(path_564610, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  add(path_564610, "subscriptionId", newJString(subscriptionId))
  add(path_564610, "resourceGroupName", newJString(resourceGroupName))
  result = call_564609.call(path_564610, query_564611, nil, nil, nil)

var proximityPlacementGroupsGet* = Call_ProximityPlacementGroupsGet_564601(
    name: "proximityPlacementGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsGet_564602, base: "",
    url: url_ProximityPlacementGroupsGet_564603, schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsUpdate_564636 = ref object of OpenApiRestCall_563565
proc url_ProximityPlacementGroupsUpdate_564638(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "proximityPlacementGroupName" in path,
        "`proximityPlacementGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/proximityPlacementGroups/"),
               (kind: VariableSegment, value: "proximityPlacementGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximityPlacementGroupsUpdate_564637(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a proximity placement group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   proximityPlacementGroupName: JString (required)
  ##                              : The name of the proximity placement group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `proximityPlacementGroupName` field"
  var valid_564639 = path.getOrDefault("proximityPlacementGroupName")
  valid_564639 = validateParameter(valid_564639, JString, required = true,
                                 default = nil)
  if valid_564639 != nil:
    section.add "proximityPlacementGroupName", valid_564639
  var valid_564640 = path.getOrDefault("subscriptionId")
  valid_564640 = validateParameter(valid_564640, JString, required = true,
                                 default = nil)
  if valid_564640 != nil:
    section.add "subscriptionId", valid_564640
  var valid_564641 = path.getOrDefault("resourceGroupName")
  valid_564641 = validateParameter(valid_564641, JString, required = true,
                                 default = nil)
  if valid_564641 != nil:
    section.add "resourceGroupName", valid_564641
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564642 = query.getOrDefault("api-version")
  valid_564642 = validateParameter(valid_564642, JString, required = true,
                                 default = nil)
  if valid_564642 != nil:
    section.add "api-version", valid_564642
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Proximity Placement Group operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564644: Call_ProximityPlacementGroupsUpdate_564636; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a proximity placement group.
  ## 
  let valid = call_564644.validator(path, query, header, formData, body)
  let scheme = call_564644.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564644.url(scheme.get, call_564644.host, call_564644.base,
                         call_564644.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564644, url, valid)

proc call*(call_564645: Call_ProximityPlacementGroupsUpdate_564636;
          apiVersion: string; proximityPlacementGroupName: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode): Recallable =
  ## proximityPlacementGroupsUpdate
  ## Update a proximity placement group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   proximityPlacementGroupName: string (required)
  ##                              : The name of the proximity placement group.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Proximity Placement Group operation.
  var path_564646 = newJObject()
  var query_564647 = newJObject()
  var body_564648 = newJObject()
  add(query_564647, "api-version", newJString(apiVersion))
  add(path_564646, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  add(path_564646, "subscriptionId", newJString(subscriptionId))
  add(path_564646, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564648 = parameters
  result = call_564645.call(path_564646, query_564647, nil, nil, body_564648)

var proximityPlacementGroupsUpdate* = Call_ProximityPlacementGroupsUpdate_564636(
    name: "proximityPlacementGroupsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsUpdate_564637, base: "",
    url: url_ProximityPlacementGroupsUpdate_564638, schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsDelete_564625 = ref object of OpenApiRestCall_563565
proc url_ProximityPlacementGroupsDelete_564627(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "proximityPlacementGroupName" in path,
        "`proximityPlacementGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/proximityPlacementGroups/"),
               (kind: VariableSegment, value: "proximityPlacementGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProximityPlacementGroupsDelete_564626(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a proximity placement group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   proximityPlacementGroupName: JString (required)
  ##                              : The name of the proximity placement group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `proximityPlacementGroupName` field"
  var valid_564628 = path.getOrDefault("proximityPlacementGroupName")
  valid_564628 = validateParameter(valid_564628, JString, required = true,
                                 default = nil)
  if valid_564628 != nil:
    section.add "proximityPlacementGroupName", valid_564628
  var valid_564629 = path.getOrDefault("subscriptionId")
  valid_564629 = validateParameter(valid_564629, JString, required = true,
                                 default = nil)
  if valid_564629 != nil:
    section.add "subscriptionId", valid_564629
  var valid_564630 = path.getOrDefault("resourceGroupName")
  valid_564630 = validateParameter(valid_564630, JString, required = true,
                                 default = nil)
  if valid_564630 != nil:
    section.add "resourceGroupName", valid_564630
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564631 = query.getOrDefault("api-version")
  valid_564631 = validateParameter(valid_564631, JString, required = true,
                                 default = nil)
  if valid_564631 != nil:
    section.add "api-version", valid_564631
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564632: Call_ProximityPlacementGroupsDelete_564625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a proximity placement group.
  ## 
  let valid = call_564632.validator(path, query, header, formData, body)
  let scheme = call_564632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564632.url(scheme.get, call_564632.host, call_564632.base,
                         call_564632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564632, url, valid)

proc call*(call_564633: Call_ProximityPlacementGroupsDelete_564625;
          apiVersion: string; proximityPlacementGroupName: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## proximityPlacementGroupsDelete
  ## Delete a proximity placement group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   proximityPlacementGroupName: string (required)
  ##                              : The name of the proximity placement group.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564634 = newJObject()
  var query_564635 = newJObject()
  add(query_564635, "api-version", newJString(apiVersion))
  add(path_564634, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  add(path_564634, "subscriptionId", newJString(subscriptionId))
  add(path_564634, "resourceGroupName", newJString(resourceGroupName))
  result = call_564633.call(path_564634, query_564635, nil, nil, nil)

var proximityPlacementGroupsDelete* = Call_ProximityPlacementGroupsDelete_564625(
    name: "proximityPlacementGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsDelete_564626, base: "",
    url: url_ProximityPlacementGroupsDelete_564627, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsList_564649 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsList_564651(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsList_564650(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all VM scale sets under a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564652 = path.getOrDefault("subscriptionId")
  valid_564652 = validateParameter(valid_564652, JString, required = true,
                                 default = nil)
  if valid_564652 != nil:
    section.add "subscriptionId", valid_564652
  var valid_564653 = path.getOrDefault("resourceGroupName")
  valid_564653 = validateParameter(valid_564653, JString, required = true,
                                 default = nil)
  if valid_564653 != nil:
    section.add "resourceGroupName", valid_564653
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564654 = query.getOrDefault("api-version")
  valid_564654 = validateParameter(valid_564654, JString, required = true,
                                 default = nil)
  if valid_564654 != nil:
    section.add "api-version", valid_564654
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564655: Call_VirtualMachineScaleSetsList_564649; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all VM scale sets under a resource group.
  ## 
  let valid = call_564655.validator(path, query, header, formData, body)
  let scheme = call_564655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564655.url(scheme.get, call_564655.host, call_564655.base,
                         call_564655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564655, url, valid)

proc call*(call_564656: Call_VirtualMachineScaleSetsList_564649;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualMachineScaleSetsList
  ## Gets a list of all VM scale sets under a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564657 = newJObject()
  var query_564658 = newJObject()
  add(query_564658, "api-version", newJString(apiVersion))
  add(path_564657, "subscriptionId", newJString(subscriptionId))
  add(path_564657, "resourceGroupName", newJString(resourceGroupName))
  result = call_564656.call(path_564657, query_564658, nil, nil, nil)

var virtualMachineScaleSetsList* = Call_VirtualMachineScaleSetsList_564649(
    name: "virtualMachineScaleSetsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets",
    validator: validate_VirtualMachineScaleSetsList_564650, base: "",
    url: url_VirtualMachineScaleSetsList_564651, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsList_564659 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsList_564661(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualMachineScaleSetName" in path,
        "`virtualMachineScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/virtualMachines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsList_564660(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all virtual machines in a VM scale sets.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: JString (required)
  ##                             : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564662 = path.getOrDefault("subscriptionId")
  valid_564662 = validateParameter(valid_564662, JString, required = true,
                                 default = nil)
  if valid_564662 != nil:
    section.add "subscriptionId", valid_564662
  var valid_564663 = path.getOrDefault("virtualMachineScaleSetName")
  valid_564663 = validateParameter(valid_564663, JString, required = true,
                                 default = nil)
  if valid_564663 != nil:
    section.add "virtualMachineScaleSetName", valid_564663
  var valid_564664 = path.getOrDefault("resourceGroupName")
  valid_564664 = validateParameter(valid_564664, JString, required = true,
                                 default = nil)
  if valid_564664 != nil:
    section.add "resourceGroupName", valid_564664
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : The list parameters.
  ##   $expand: JString
  ##          : The expand expression to apply to the operation.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564665 = query.getOrDefault("api-version")
  valid_564665 = validateParameter(valid_564665, JString, required = true,
                                 default = nil)
  if valid_564665 != nil:
    section.add "api-version", valid_564665
  var valid_564666 = query.getOrDefault("$select")
  valid_564666 = validateParameter(valid_564666, JString, required = false,
                                 default = nil)
  if valid_564666 != nil:
    section.add "$select", valid_564666
  var valid_564667 = query.getOrDefault("$expand")
  valid_564667 = validateParameter(valid_564667, JString, required = false,
                                 default = nil)
  if valid_564667 != nil:
    section.add "$expand", valid_564667
  var valid_564668 = query.getOrDefault("$filter")
  valid_564668 = validateParameter(valid_564668, JString, required = false,
                                 default = nil)
  if valid_564668 != nil:
    section.add "$filter", valid_564668
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564669: Call_VirtualMachineScaleSetVMsList_564659; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all virtual machines in a VM scale sets.
  ## 
  let valid = call_564669.validator(path, query, header, formData, body)
  let scheme = call_564669.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564669.url(scheme.get, call_564669.host, call_564669.base,
                         call_564669.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564669, url, valid)

proc call*(call_564670: Call_VirtualMachineScaleSetVMsList_564659;
          apiVersion: string; subscriptionId: string;
          virtualMachineScaleSetName: string; resourceGroupName: string;
          Select: string = ""; Expand: string = ""; Filter: string = ""): Recallable =
  ## virtualMachineScaleSetVMsList
  ## Gets a list of all virtual machines in a VM scale sets.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Select: string
  ##         : The list parameters.
  ##   Expand: string
  ##         : The expand expression to apply to the operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_564671 = newJObject()
  var query_564672 = newJObject()
  add(query_564672, "api-version", newJString(apiVersion))
  add(query_564672, "$select", newJString(Select))
  add(query_564672, "$expand", newJString(Expand))
  add(path_564671, "subscriptionId", newJString(subscriptionId))
  add(path_564671, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  add(path_564671, "resourceGroupName", newJString(resourceGroupName))
  add(query_564672, "$filter", newJString(Filter))
  result = call_564670.call(path_564671, query_564672, nil, nil, nil)

var virtualMachineScaleSetVMsList* = Call_VirtualMachineScaleSetVMsList_564659(
    name: "virtualMachineScaleSetVMsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines",
    validator: validate_VirtualMachineScaleSetVMsList_564660, base: "",
    url: url_VirtualMachineScaleSetVMsList_564661, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsCreateOrUpdate_564684 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsCreateOrUpdate_564686(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsCreateOrUpdate_564685(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set to create or update.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564687 = path.getOrDefault("vmScaleSetName")
  valid_564687 = validateParameter(valid_564687, JString, required = true,
                                 default = nil)
  if valid_564687 != nil:
    section.add "vmScaleSetName", valid_564687
  var valid_564688 = path.getOrDefault("subscriptionId")
  valid_564688 = validateParameter(valid_564688, JString, required = true,
                                 default = nil)
  if valid_564688 != nil:
    section.add "subscriptionId", valid_564688
  var valid_564689 = path.getOrDefault("resourceGroupName")
  valid_564689 = validateParameter(valid_564689, JString, required = true,
                                 default = nil)
  if valid_564689 != nil:
    section.add "resourceGroupName", valid_564689
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564690 = query.getOrDefault("api-version")
  valid_564690 = validateParameter(valid_564690, JString, required = true,
                                 default = nil)
  if valid_564690 != nil:
    section.add "api-version", valid_564690
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The scale set object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564692: Call_VirtualMachineScaleSetsCreateOrUpdate_564684;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a VM scale set.
  ## 
  let valid = call_564692.validator(path, query, header, formData, body)
  let scheme = call_564692.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564692.url(scheme.get, call_564692.host, call_564692.base,
                         call_564692.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564692, url, valid)

proc call*(call_564693: Call_VirtualMachineScaleSetsCreateOrUpdate_564684;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## virtualMachineScaleSetsCreateOrUpdate
  ## Create or update a VM scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set to create or update.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : The scale set object.
  var path_564694 = newJObject()
  var query_564695 = newJObject()
  var body_564696 = newJObject()
  add(query_564695, "api-version", newJString(apiVersion))
  add(path_564694, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564694, "subscriptionId", newJString(subscriptionId))
  add(path_564694, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564696 = parameters
  result = call_564693.call(path_564694, query_564695, nil, nil, body_564696)

var virtualMachineScaleSetsCreateOrUpdate* = Call_VirtualMachineScaleSetsCreateOrUpdate_564684(
    name: "virtualMachineScaleSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsCreateOrUpdate_564685, base: "",
    url: url_VirtualMachineScaleSetsCreateOrUpdate_564686, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGet_564673 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsGet_564675(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsGet_564674(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Display information about a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564676 = path.getOrDefault("vmScaleSetName")
  valid_564676 = validateParameter(valid_564676, JString, required = true,
                                 default = nil)
  if valid_564676 != nil:
    section.add "vmScaleSetName", valid_564676
  var valid_564677 = path.getOrDefault("subscriptionId")
  valid_564677 = validateParameter(valid_564677, JString, required = true,
                                 default = nil)
  if valid_564677 != nil:
    section.add "subscriptionId", valid_564677
  var valid_564678 = path.getOrDefault("resourceGroupName")
  valid_564678 = validateParameter(valid_564678, JString, required = true,
                                 default = nil)
  if valid_564678 != nil:
    section.add "resourceGroupName", valid_564678
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564679 = query.getOrDefault("api-version")
  valid_564679 = validateParameter(valid_564679, JString, required = true,
                                 default = nil)
  if valid_564679 != nil:
    section.add "api-version", valid_564679
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564680: Call_VirtualMachineScaleSetsGet_564673; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Display information about a virtual machine scale set.
  ## 
  let valid = call_564680.validator(path, query, header, formData, body)
  let scheme = call_564680.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564680.url(scheme.get, call_564680.host, call_564680.base,
                         call_564680.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564680, url, valid)

proc call*(call_564681: Call_VirtualMachineScaleSetsGet_564673; apiVersion: string;
          vmScaleSetName: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualMachineScaleSetsGet
  ## Display information about a virtual machine scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564682 = newJObject()
  var query_564683 = newJObject()
  add(query_564683, "api-version", newJString(apiVersion))
  add(path_564682, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564682, "subscriptionId", newJString(subscriptionId))
  add(path_564682, "resourceGroupName", newJString(resourceGroupName))
  result = call_564681.call(path_564682, query_564683, nil, nil, nil)

var virtualMachineScaleSetsGet* = Call_VirtualMachineScaleSetsGet_564673(
    name: "virtualMachineScaleSetsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsGet_564674, base: "",
    url: url_VirtualMachineScaleSetsGet_564675, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsUpdate_564708 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsUpdate_564710(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsUpdate_564709(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set to create or update.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564711 = path.getOrDefault("vmScaleSetName")
  valid_564711 = validateParameter(valid_564711, JString, required = true,
                                 default = nil)
  if valid_564711 != nil:
    section.add "vmScaleSetName", valid_564711
  var valid_564712 = path.getOrDefault("subscriptionId")
  valid_564712 = validateParameter(valid_564712, JString, required = true,
                                 default = nil)
  if valid_564712 != nil:
    section.add "subscriptionId", valid_564712
  var valid_564713 = path.getOrDefault("resourceGroupName")
  valid_564713 = validateParameter(valid_564713, JString, required = true,
                                 default = nil)
  if valid_564713 != nil:
    section.add "resourceGroupName", valid_564713
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564714 = query.getOrDefault("api-version")
  valid_564714 = validateParameter(valid_564714, JString, required = true,
                                 default = nil)
  if valid_564714 != nil:
    section.add "api-version", valid_564714
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The scale set object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564716: Call_VirtualMachineScaleSetsUpdate_564708; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a VM scale set.
  ## 
  let valid = call_564716.validator(path, query, header, formData, body)
  let scheme = call_564716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564716.url(scheme.get, call_564716.host, call_564716.base,
                         call_564716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564716, url, valid)

proc call*(call_564717: Call_VirtualMachineScaleSetsUpdate_564708;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## virtualMachineScaleSetsUpdate
  ## Update a VM scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set to create or update.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : The scale set object.
  var path_564718 = newJObject()
  var query_564719 = newJObject()
  var body_564720 = newJObject()
  add(query_564719, "api-version", newJString(apiVersion))
  add(path_564718, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564718, "subscriptionId", newJString(subscriptionId))
  add(path_564718, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564720 = parameters
  result = call_564717.call(path_564718, query_564719, nil, nil, body_564720)

var virtualMachineScaleSetsUpdate* = Call_VirtualMachineScaleSetsUpdate_564708(
    name: "virtualMachineScaleSetsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsUpdate_564709, base: "",
    url: url_VirtualMachineScaleSetsUpdate_564710, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDelete_564697 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsDelete_564699(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsDelete_564698(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564700 = path.getOrDefault("vmScaleSetName")
  valid_564700 = validateParameter(valid_564700, JString, required = true,
                                 default = nil)
  if valid_564700 != nil:
    section.add "vmScaleSetName", valid_564700
  var valid_564701 = path.getOrDefault("subscriptionId")
  valid_564701 = validateParameter(valid_564701, JString, required = true,
                                 default = nil)
  if valid_564701 != nil:
    section.add "subscriptionId", valid_564701
  var valid_564702 = path.getOrDefault("resourceGroupName")
  valid_564702 = validateParameter(valid_564702, JString, required = true,
                                 default = nil)
  if valid_564702 != nil:
    section.add "resourceGroupName", valid_564702
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564703 = query.getOrDefault("api-version")
  valid_564703 = validateParameter(valid_564703, JString, required = true,
                                 default = nil)
  if valid_564703 != nil:
    section.add "api-version", valid_564703
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564704: Call_VirtualMachineScaleSetsDelete_564697; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VM scale set.
  ## 
  let valid = call_564704.validator(path, query, header, formData, body)
  let scheme = call_564704.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564704.url(scheme.get, call_564704.host, call_564704.base,
                         call_564704.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564704, url, valid)

proc call*(call_564705: Call_VirtualMachineScaleSetsDelete_564697;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## virtualMachineScaleSetsDelete
  ## Deletes a VM scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564706 = newJObject()
  var query_564707 = newJObject()
  add(query_564707, "api-version", newJString(apiVersion))
  add(path_564706, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564706, "subscriptionId", newJString(subscriptionId))
  add(path_564706, "resourceGroupName", newJString(resourceGroupName))
  result = call_564705.call(path_564706, query_564707, nil, nil, nil)

var virtualMachineScaleSetsDelete* = Call_VirtualMachineScaleSetsDelete_564697(
    name: "virtualMachineScaleSetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsDelete_564698, base: "",
    url: url_VirtualMachineScaleSetsDelete_564699, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsConvertToSinglePlacementGroup_564721 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsConvertToSinglePlacementGroup_564723(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/convertToSinglePlacementGroup")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsConvertToSinglePlacementGroup_564722(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Converts SinglePlacementGroup property to false for a existing virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the virtual machine scale set to create or update.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564724 = path.getOrDefault("vmScaleSetName")
  valid_564724 = validateParameter(valid_564724, JString, required = true,
                                 default = nil)
  if valid_564724 != nil:
    section.add "vmScaleSetName", valid_564724
  var valid_564725 = path.getOrDefault("subscriptionId")
  valid_564725 = validateParameter(valid_564725, JString, required = true,
                                 default = nil)
  if valid_564725 != nil:
    section.add "subscriptionId", valid_564725
  var valid_564726 = path.getOrDefault("resourceGroupName")
  valid_564726 = validateParameter(valid_564726, JString, required = true,
                                 default = nil)
  if valid_564726 != nil:
    section.add "resourceGroupName", valid_564726
  result.add "path", section
  section = newJObject()
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The input object for ConvertToSinglePlacementGroup API.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564728: Call_VirtualMachineScaleSetsConvertToSinglePlacementGroup_564721;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Converts SinglePlacementGroup property to false for a existing virtual machine scale set.
  ## 
  let valid = call_564728.validator(path, query, header, formData, body)
  let scheme = call_564728.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564728.url(scheme.get, call_564728.host, call_564728.base,
                         call_564728.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564728, url, valid)

proc call*(call_564729: Call_VirtualMachineScaleSetsConvertToSinglePlacementGroup_564721;
          vmScaleSetName: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## virtualMachineScaleSetsConvertToSinglePlacementGroup
  ## Converts SinglePlacementGroup property to false for a existing virtual machine scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the virtual machine scale set to create or update.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : The input object for ConvertToSinglePlacementGroup API.
  var path_564730 = newJObject()
  var body_564731 = newJObject()
  add(path_564730, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564730, "subscriptionId", newJString(subscriptionId))
  add(path_564730, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564731 = parameters
  result = call_564729.call(path_564730, nil, nil, nil, body_564731)

var virtualMachineScaleSetsConvertToSinglePlacementGroup* = Call_VirtualMachineScaleSetsConvertToSinglePlacementGroup_564721(
    name: "virtualMachineScaleSetsConvertToSinglePlacementGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/convertToSinglePlacementGroup",
    validator: validate_VirtualMachineScaleSetsConvertToSinglePlacementGroup_564722,
    base: "", url: url_VirtualMachineScaleSetsConvertToSinglePlacementGroup_564723,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDeallocate_564732 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsDeallocate_564734(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/deallocate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsDeallocate_564733(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deallocates specific virtual machines in a VM scale set. Shuts down the virtual machines and releases the compute resources. You are not billed for the compute resources that this virtual machine scale set deallocates.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564735 = path.getOrDefault("vmScaleSetName")
  valid_564735 = validateParameter(valid_564735, JString, required = true,
                                 default = nil)
  if valid_564735 != nil:
    section.add "vmScaleSetName", valid_564735
  var valid_564736 = path.getOrDefault("subscriptionId")
  valid_564736 = validateParameter(valid_564736, JString, required = true,
                                 default = nil)
  if valid_564736 != nil:
    section.add "subscriptionId", valid_564736
  var valid_564737 = path.getOrDefault("resourceGroupName")
  valid_564737 = validateParameter(valid_564737, JString, required = true,
                                 default = nil)
  if valid_564737 != nil:
    section.add "resourceGroupName", valid_564737
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564738 = query.getOrDefault("api-version")
  valid_564738 = validateParameter(valid_564738, JString, required = true,
                                 default = nil)
  if valid_564738 != nil:
    section.add "api-version", valid_564738
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564740: Call_VirtualMachineScaleSetsDeallocate_564732;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deallocates specific virtual machines in a VM scale set. Shuts down the virtual machines and releases the compute resources. You are not billed for the compute resources that this virtual machine scale set deallocates.
  ## 
  let valid = call_564740.validator(path, query, header, formData, body)
  let scheme = call_564740.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564740.url(scheme.get, call_564740.host, call_564740.base,
                         call_564740.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564740, url, valid)

proc call*(call_564741: Call_VirtualMachineScaleSetsDeallocate_564732;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsDeallocate
  ## Deallocates specific virtual machines in a VM scale set. Shuts down the virtual machines and releases the compute resources. You are not billed for the compute resources that this virtual machine scale set deallocates.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_564742 = newJObject()
  var query_564743 = newJObject()
  var body_564744 = newJObject()
  add(query_564743, "api-version", newJString(apiVersion))
  add(path_564742, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564742, "subscriptionId", newJString(subscriptionId))
  add(path_564742, "resourceGroupName", newJString(resourceGroupName))
  if vmInstanceIDs != nil:
    body_564744 = vmInstanceIDs
  result = call_564741.call(path_564742, query_564743, nil, nil, body_564744)

var virtualMachineScaleSetsDeallocate* = Call_VirtualMachineScaleSetsDeallocate_564732(
    name: "virtualMachineScaleSetsDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/deallocate",
    validator: validate_VirtualMachineScaleSetsDeallocate_564733, base: "",
    url: url_VirtualMachineScaleSetsDeallocate_564734, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDeleteInstances_564745 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsDeleteInstances_564747(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/delete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsDeleteInstances_564746(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes virtual machines in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564748 = path.getOrDefault("vmScaleSetName")
  valid_564748 = validateParameter(valid_564748, JString, required = true,
                                 default = nil)
  if valid_564748 != nil:
    section.add "vmScaleSetName", valid_564748
  var valid_564749 = path.getOrDefault("subscriptionId")
  valid_564749 = validateParameter(valid_564749, JString, required = true,
                                 default = nil)
  if valid_564749 != nil:
    section.add "subscriptionId", valid_564749
  var valid_564750 = path.getOrDefault("resourceGroupName")
  valid_564750 = validateParameter(valid_564750, JString, required = true,
                                 default = nil)
  if valid_564750 != nil:
    section.add "resourceGroupName", valid_564750
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564751 = query.getOrDefault("api-version")
  valid_564751 = validateParameter(valid_564751, JString, required = true,
                                 default = nil)
  if valid_564751 != nil:
    section.add "api-version", valid_564751
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vmInstanceIDs: JObject (required)
  ##                : A list of virtual machine instance IDs from the VM scale set.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564753: Call_VirtualMachineScaleSetsDeleteInstances_564745;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes virtual machines in a VM scale set.
  ## 
  let valid = call_564753.validator(path, query, header, formData, body)
  let scheme = call_564753.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564753.url(scheme.get, call_564753.host, call_564753.base,
                         call_564753.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564753, url, valid)

proc call*(call_564754: Call_VirtualMachineScaleSetsDeleteInstances_564745;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; vmInstanceIDs: JsonNode): Recallable =
  ## virtualMachineScaleSetsDeleteInstances
  ## Deletes virtual machines in a VM scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmInstanceIDs: JObject (required)
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_564755 = newJObject()
  var query_564756 = newJObject()
  var body_564757 = newJObject()
  add(query_564756, "api-version", newJString(apiVersion))
  add(path_564755, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564755, "subscriptionId", newJString(subscriptionId))
  add(path_564755, "resourceGroupName", newJString(resourceGroupName))
  if vmInstanceIDs != nil:
    body_564757 = vmInstanceIDs
  result = call_564754.call(path_564755, query_564756, nil, nil, body_564757)

var virtualMachineScaleSetsDeleteInstances* = Call_VirtualMachineScaleSetsDeleteInstances_564745(
    name: "virtualMachineScaleSetsDeleteInstances", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/delete",
    validator: validate_VirtualMachineScaleSetsDeleteInstances_564746, base: "",
    url: url_VirtualMachineScaleSetsDeleteInstances_564747,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_564758 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_564760(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/extensionRollingUpgrade")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_564759(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Starts a rolling upgrade to move all extensions for all virtual machine scale set instances to the latest available extension version. Instances which are already running the latest extension versions are not affected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564761 = path.getOrDefault("vmScaleSetName")
  valid_564761 = validateParameter(valid_564761, JString, required = true,
                                 default = nil)
  if valid_564761 != nil:
    section.add "vmScaleSetName", valid_564761
  var valid_564762 = path.getOrDefault("subscriptionId")
  valid_564762 = validateParameter(valid_564762, JString, required = true,
                                 default = nil)
  if valid_564762 != nil:
    section.add "subscriptionId", valid_564762
  var valid_564763 = path.getOrDefault("resourceGroupName")
  valid_564763 = validateParameter(valid_564763, JString, required = true,
                                 default = nil)
  if valid_564763 != nil:
    section.add "resourceGroupName", valid_564763
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564764 = query.getOrDefault("api-version")
  valid_564764 = validateParameter(valid_564764, JString, required = true,
                                 default = nil)
  if valid_564764 != nil:
    section.add "api-version", valid_564764
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564765: Call_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_564758;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a rolling upgrade to move all extensions for all virtual machine scale set instances to the latest available extension version. Instances which are already running the latest extension versions are not affected.
  ## 
  let valid = call_564765.validator(path, query, header, formData, body)
  let scheme = call_564765.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564765.url(scheme.get, call_564765.host, call_564765.base,
                         call_564765.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564765, url, valid)

proc call*(call_564766: Call_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_564758;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## virtualMachineScaleSetRollingUpgradesStartExtensionUpgrade
  ## Starts a rolling upgrade to move all extensions for all virtual machine scale set instances to the latest available extension version. Instances which are already running the latest extension versions are not affected.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564767 = newJObject()
  var query_564768 = newJObject()
  add(query_564768, "api-version", newJString(apiVersion))
  add(path_564767, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564767, "subscriptionId", newJString(subscriptionId))
  add(path_564767, "resourceGroupName", newJString(resourceGroupName))
  result = call_564766.call(path_564767, query_564768, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesStartExtensionUpgrade* = Call_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_564758(
    name: "virtualMachineScaleSetRollingUpgradesStartExtensionUpgrade",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensionRollingUpgrade", validator: validate_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_564759,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_564760,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsList_564769 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetExtensionsList_564771(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/extensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetExtensionsList_564770(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all extensions in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set containing the extension.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564772 = path.getOrDefault("vmScaleSetName")
  valid_564772 = validateParameter(valid_564772, JString, required = true,
                                 default = nil)
  if valid_564772 != nil:
    section.add "vmScaleSetName", valid_564772
  var valid_564773 = path.getOrDefault("subscriptionId")
  valid_564773 = validateParameter(valid_564773, JString, required = true,
                                 default = nil)
  if valid_564773 != nil:
    section.add "subscriptionId", valid_564773
  var valid_564774 = path.getOrDefault("resourceGroupName")
  valid_564774 = validateParameter(valid_564774, JString, required = true,
                                 default = nil)
  if valid_564774 != nil:
    section.add "resourceGroupName", valid_564774
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564775 = query.getOrDefault("api-version")
  valid_564775 = validateParameter(valid_564775, JString, required = true,
                                 default = nil)
  if valid_564775 != nil:
    section.add "api-version", valid_564775
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564776: Call_VirtualMachineScaleSetExtensionsList_564769;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of all extensions in a VM scale set.
  ## 
  let valid = call_564776.validator(path, query, header, formData, body)
  let scheme = call_564776.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564776.url(scheme.get, call_564776.host, call_564776.base,
                         call_564776.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564776, url, valid)

proc call*(call_564777: Call_VirtualMachineScaleSetExtensionsList_564769;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## virtualMachineScaleSetExtensionsList
  ## Gets a list of all extensions in a VM scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set containing the extension.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564778 = newJObject()
  var query_564779 = newJObject()
  add(query_564779, "api-version", newJString(apiVersion))
  add(path_564778, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564778, "subscriptionId", newJString(subscriptionId))
  add(path_564778, "resourceGroupName", newJString(resourceGroupName))
  result = call_564777.call(path_564778, query_564779, nil, nil, nil)

var virtualMachineScaleSetExtensionsList* = Call_VirtualMachineScaleSetExtensionsList_564769(
    name: "virtualMachineScaleSetExtensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions",
    validator: validate_VirtualMachineScaleSetExtensionsList_564770, base: "",
    url: url_VirtualMachineScaleSetExtensionsList_564771, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_564793 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetExtensionsCreateOrUpdate_564795(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "vmssExtensionName" in path,
        "`vmssExtensionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/extensions/"),
               (kind: VariableSegment, value: "vmssExtensionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetExtensionsCreateOrUpdate_564794(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to create or update an extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set where the extension should be create or updated.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmssExtensionName: JString (required)
  ##                    : The name of the VM scale set extension.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564796 = path.getOrDefault("vmScaleSetName")
  valid_564796 = validateParameter(valid_564796, JString, required = true,
                                 default = nil)
  if valid_564796 != nil:
    section.add "vmScaleSetName", valid_564796
  var valid_564797 = path.getOrDefault("subscriptionId")
  valid_564797 = validateParameter(valid_564797, JString, required = true,
                                 default = nil)
  if valid_564797 != nil:
    section.add "subscriptionId", valid_564797
  var valid_564798 = path.getOrDefault("resourceGroupName")
  valid_564798 = validateParameter(valid_564798, JString, required = true,
                                 default = nil)
  if valid_564798 != nil:
    section.add "resourceGroupName", valid_564798
  var valid_564799 = path.getOrDefault("vmssExtensionName")
  valid_564799 = validateParameter(valid_564799, JString, required = true,
                                 default = nil)
  if valid_564799 != nil:
    section.add "vmssExtensionName", valid_564799
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564800 = query.getOrDefault("api-version")
  valid_564800 = validateParameter(valid_564800, JString, required = true,
                                 default = nil)
  if valid_564800 != nil:
    section.add "api-version", valid_564800
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   extensionParameters: JObject (required)
  ##                      : Parameters supplied to the Create VM scale set Extension operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564802: Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_564793;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update an extension.
  ## 
  let valid = call_564802.validator(path, query, header, formData, body)
  let scheme = call_564802.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564802.url(scheme.get, call_564802.host, call_564802.base,
                         call_564802.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564802, url, valid)

proc call*(call_564803: Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_564793;
          apiVersion: string; vmScaleSetName: string; extensionParameters: JsonNode;
          subscriptionId: string; resourceGroupName: string;
          vmssExtensionName: string): Recallable =
  ## virtualMachineScaleSetExtensionsCreateOrUpdate
  ## The operation to create or update an extension.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set where the extension should be create or updated.
  ##   extensionParameters: JObject (required)
  ##                      : Parameters supplied to the Create VM scale set Extension operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmssExtensionName: string (required)
  ##                    : The name of the VM scale set extension.
  var path_564804 = newJObject()
  var query_564805 = newJObject()
  var body_564806 = newJObject()
  add(query_564805, "api-version", newJString(apiVersion))
  add(path_564804, "vmScaleSetName", newJString(vmScaleSetName))
  if extensionParameters != nil:
    body_564806 = extensionParameters
  add(path_564804, "subscriptionId", newJString(subscriptionId))
  add(path_564804, "resourceGroupName", newJString(resourceGroupName))
  add(path_564804, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_564803.call(path_564804, query_564805, nil, nil, body_564806)

var virtualMachineScaleSetExtensionsCreateOrUpdate* = Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_564793(
    name: "virtualMachineScaleSetExtensionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsCreateOrUpdate_564794,
    base: "", url: url_VirtualMachineScaleSetExtensionsCreateOrUpdate_564795,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsGet_564780 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetExtensionsGet_564782(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "vmssExtensionName" in path,
        "`vmssExtensionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/extensions/"),
               (kind: VariableSegment, value: "vmssExtensionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetExtensionsGet_564781(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to get the extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set containing the extension.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmssExtensionName: JString (required)
  ##                    : The name of the VM scale set extension.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564783 = path.getOrDefault("vmScaleSetName")
  valid_564783 = validateParameter(valid_564783, JString, required = true,
                                 default = nil)
  if valid_564783 != nil:
    section.add "vmScaleSetName", valid_564783
  var valid_564784 = path.getOrDefault("subscriptionId")
  valid_564784 = validateParameter(valid_564784, JString, required = true,
                                 default = nil)
  if valid_564784 != nil:
    section.add "subscriptionId", valid_564784
  var valid_564785 = path.getOrDefault("resourceGroupName")
  valid_564785 = validateParameter(valid_564785, JString, required = true,
                                 default = nil)
  if valid_564785 != nil:
    section.add "resourceGroupName", valid_564785
  var valid_564786 = path.getOrDefault("vmssExtensionName")
  valid_564786 = validateParameter(valid_564786, JString, required = true,
                                 default = nil)
  if valid_564786 != nil:
    section.add "vmssExtensionName", valid_564786
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564787 = query.getOrDefault("api-version")
  valid_564787 = validateParameter(valid_564787, JString, required = true,
                                 default = nil)
  if valid_564787 != nil:
    section.add "api-version", valid_564787
  var valid_564788 = query.getOrDefault("$expand")
  valid_564788 = validateParameter(valid_564788, JString, required = false,
                                 default = nil)
  if valid_564788 != nil:
    section.add "$expand", valid_564788
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564789: Call_VirtualMachineScaleSetExtensionsGet_564780;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to get the extension.
  ## 
  let valid = call_564789.validator(path, query, header, formData, body)
  let scheme = call_564789.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564789.url(scheme.get, call_564789.host, call_564789.base,
                         call_564789.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564789, url, valid)

proc call*(call_564790: Call_VirtualMachineScaleSetExtensionsGet_564780;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; vmssExtensionName: string; Expand: string = ""): Recallable =
  ## virtualMachineScaleSetExtensionsGet
  ## The operation to get the extension.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set containing the extension.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmssExtensionName: string (required)
  ##                    : The name of the VM scale set extension.
  var path_564791 = newJObject()
  var query_564792 = newJObject()
  add(query_564792, "api-version", newJString(apiVersion))
  add(path_564791, "vmScaleSetName", newJString(vmScaleSetName))
  add(query_564792, "$expand", newJString(Expand))
  add(path_564791, "subscriptionId", newJString(subscriptionId))
  add(path_564791, "resourceGroupName", newJString(resourceGroupName))
  add(path_564791, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_564790.call(path_564791, query_564792, nil, nil, nil)

var virtualMachineScaleSetExtensionsGet* = Call_VirtualMachineScaleSetExtensionsGet_564780(
    name: "virtualMachineScaleSetExtensionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsGet_564781, base: "",
    url: url_VirtualMachineScaleSetExtensionsGet_564782, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsDelete_564807 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetExtensionsDelete_564809(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "vmssExtensionName" in path,
        "`vmssExtensionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/extensions/"),
               (kind: VariableSegment, value: "vmssExtensionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetExtensionsDelete_564808(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete the extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set where the extension should be deleted.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmssExtensionName: JString (required)
  ##                    : The name of the VM scale set extension.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564810 = path.getOrDefault("vmScaleSetName")
  valid_564810 = validateParameter(valid_564810, JString, required = true,
                                 default = nil)
  if valid_564810 != nil:
    section.add "vmScaleSetName", valid_564810
  var valid_564811 = path.getOrDefault("subscriptionId")
  valid_564811 = validateParameter(valid_564811, JString, required = true,
                                 default = nil)
  if valid_564811 != nil:
    section.add "subscriptionId", valid_564811
  var valid_564812 = path.getOrDefault("resourceGroupName")
  valid_564812 = validateParameter(valid_564812, JString, required = true,
                                 default = nil)
  if valid_564812 != nil:
    section.add "resourceGroupName", valid_564812
  var valid_564813 = path.getOrDefault("vmssExtensionName")
  valid_564813 = validateParameter(valid_564813, JString, required = true,
                                 default = nil)
  if valid_564813 != nil:
    section.add "vmssExtensionName", valid_564813
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564814 = query.getOrDefault("api-version")
  valid_564814 = validateParameter(valid_564814, JString, required = true,
                                 default = nil)
  if valid_564814 != nil:
    section.add "api-version", valid_564814
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564815: Call_VirtualMachineScaleSetExtensionsDelete_564807;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete the extension.
  ## 
  let valid = call_564815.validator(path, query, header, formData, body)
  let scheme = call_564815.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564815.url(scheme.get, call_564815.host, call_564815.base,
                         call_564815.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564815, url, valid)

proc call*(call_564816: Call_VirtualMachineScaleSetExtensionsDelete_564807;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; vmssExtensionName: string): Recallable =
  ## virtualMachineScaleSetExtensionsDelete
  ## The operation to delete the extension.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set where the extension should be deleted.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmssExtensionName: string (required)
  ##                    : The name of the VM scale set extension.
  var path_564817 = newJObject()
  var query_564818 = newJObject()
  add(query_564818, "api-version", newJString(apiVersion))
  add(path_564817, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564817, "subscriptionId", newJString(subscriptionId))
  add(path_564817, "resourceGroupName", newJString(resourceGroupName))
  add(path_564817, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_564816.call(path_564817, query_564818, nil, nil, nil)

var virtualMachineScaleSetExtensionsDelete* = Call_VirtualMachineScaleSetExtensionsDelete_564807(
    name: "virtualMachineScaleSetExtensionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsDelete_564808, base: "",
    url: url_VirtualMachineScaleSetExtensionsDelete_564809,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_564819 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_564821(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"), (
        kind: ConstantSegment,
        value: "/forceRecoveryServiceFabricPlatformUpdateDomainWalk")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_564820(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Manual platform update domain walk to update virtual machines in a service fabric virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564822 = path.getOrDefault("vmScaleSetName")
  valid_564822 = validateParameter(valid_564822, JString, required = true,
                                 default = nil)
  if valid_564822 != nil:
    section.add "vmScaleSetName", valid_564822
  var valid_564823 = path.getOrDefault("subscriptionId")
  valid_564823 = validateParameter(valid_564823, JString, required = true,
                                 default = nil)
  if valid_564823 != nil:
    section.add "subscriptionId", valid_564823
  var valid_564824 = path.getOrDefault("resourceGroupName")
  valid_564824 = validateParameter(valid_564824, JString, required = true,
                                 default = nil)
  if valid_564824 != nil:
    section.add "resourceGroupName", valid_564824
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   platformUpdateDomain: JInt (required)
  ##                       : The platform update domain for which a manual recovery walk is requested
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564825 = query.getOrDefault("api-version")
  valid_564825 = validateParameter(valid_564825, JString, required = true,
                                 default = nil)
  if valid_564825 != nil:
    section.add "api-version", valid_564825
  var valid_564826 = query.getOrDefault("platformUpdateDomain")
  valid_564826 = validateParameter(valid_564826, JInt, required = true, default = nil)
  if valid_564826 != nil:
    section.add "platformUpdateDomain", valid_564826
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564827: Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_564819;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Manual platform update domain walk to update virtual machines in a service fabric virtual machine scale set.
  ## 
  let valid = call_564827.validator(path, query, header, formData, body)
  let scheme = call_564827.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564827.url(scheme.get, call_564827.host, call_564827.base,
                         call_564827.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564827, url, valid)

proc call*(call_564828: Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_564819;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; platformUpdateDomain: int): Recallable =
  ## virtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk
  ## Manual platform update domain walk to update virtual machines in a service fabric virtual machine scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   platformUpdateDomain: int (required)
  ##                       : The platform update domain for which a manual recovery walk is requested
  var path_564829 = newJObject()
  var query_564830 = newJObject()
  add(query_564830, "api-version", newJString(apiVersion))
  add(path_564829, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564829, "subscriptionId", newJString(subscriptionId))
  add(path_564829, "resourceGroupName", newJString(resourceGroupName))
  add(query_564830, "platformUpdateDomain", newJInt(platformUpdateDomain))
  result = call_564828.call(path_564829, query_564830, nil, nil, nil)

var virtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk* = Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_564819(name: "virtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/forceRecoveryServiceFabricPlatformUpdateDomainWalk", validator: validate_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_564820,
    base: "", url: url_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_564821,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGetInstanceView_564831 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsGetInstanceView_564833(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/instanceView")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsGetInstanceView_564832(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of a VM scale set instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564834 = path.getOrDefault("vmScaleSetName")
  valid_564834 = validateParameter(valid_564834, JString, required = true,
                                 default = nil)
  if valid_564834 != nil:
    section.add "vmScaleSetName", valid_564834
  var valid_564835 = path.getOrDefault("subscriptionId")
  valid_564835 = validateParameter(valid_564835, JString, required = true,
                                 default = nil)
  if valid_564835 != nil:
    section.add "subscriptionId", valid_564835
  var valid_564836 = path.getOrDefault("resourceGroupName")
  valid_564836 = validateParameter(valid_564836, JString, required = true,
                                 default = nil)
  if valid_564836 != nil:
    section.add "resourceGroupName", valid_564836
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564837 = query.getOrDefault("api-version")
  valid_564837 = validateParameter(valid_564837, JString, required = true,
                                 default = nil)
  if valid_564837 != nil:
    section.add "api-version", valid_564837
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564838: Call_VirtualMachineScaleSetsGetInstanceView_564831;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of a VM scale set instance.
  ## 
  let valid = call_564838.validator(path, query, header, formData, body)
  let scheme = call_564838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564838.url(scheme.get, call_564838.host, call_564838.base,
                         call_564838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564838, url, valid)

proc call*(call_564839: Call_VirtualMachineScaleSetsGetInstanceView_564831;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## virtualMachineScaleSetsGetInstanceView
  ## Gets the status of a VM scale set instance.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564840 = newJObject()
  var query_564841 = newJObject()
  add(query_564841, "api-version", newJString(apiVersion))
  add(path_564840, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564840, "subscriptionId", newJString(subscriptionId))
  add(path_564840, "resourceGroupName", newJString(resourceGroupName))
  result = call_564839.call(path_564840, query_564841, nil, nil, nil)

var virtualMachineScaleSetsGetInstanceView* = Call_VirtualMachineScaleSetsGetInstanceView_564831(
    name: "virtualMachineScaleSetsGetInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/instanceView",
    validator: validate_VirtualMachineScaleSetsGetInstanceView_564832, base: "",
    url: url_VirtualMachineScaleSetsGetInstanceView_564833,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsUpdateInstances_564842 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsUpdateInstances_564844(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/manualupgrade")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsUpdateInstances_564843(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Upgrades one or more virtual machines to the latest SKU set in the VM scale set model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564845 = path.getOrDefault("vmScaleSetName")
  valid_564845 = validateParameter(valid_564845, JString, required = true,
                                 default = nil)
  if valid_564845 != nil:
    section.add "vmScaleSetName", valid_564845
  var valid_564846 = path.getOrDefault("subscriptionId")
  valid_564846 = validateParameter(valid_564846, JString, required = true,
                                 default = nil)
  if valid_564846 != nil:
    section.add "subscriptionId", valid_564846
  var valid_564847 = path.getOrDefault("resourceGroupName")
  valid_564847 = validateParameter(valid_564847, JString, required = true,
                                 default = nil)
  if valid_564847 != nil:
    section.add "resourceGroupName", valid_564847
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564848 = query.getOrDefault("api-version")
  valid_564848 = validateParameter(valid_564848, JString, required = true,
                                 default = nil)
  if valid_564848 != nil:
    section.add "api-version", valid_564848
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vmInstanceIDs: JObject (required)
  ##                : A list of virtual machine instance IDs from the VM scale set.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564850: Call_VirtualMachineScaleSetsUpdateInstances_564842;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upgrades one or more virtual machines to the latest SKU set in the VM scale set model.
  ## 
  let valid = call_564850.validator(path, query, header, formData, body)
  let scheme = call_564850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564850.url(scheme.get, call_564850.host, call_564850.base,
                         call_564850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564850, url, valid)

proc call*(call_564851: Call_VirtualMachineScaleSetsUpdateInstances_564842;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; vmInstanceIDs: JsonNode): Recallable =
  ## virtualMachineScaleSetsUpdateInstances
  ## Upgrades one or more virtual machines to the latest SKU set in the VM scale set model.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmInstanceIDs: JObject (required)
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_564852 = newJObject()
  var query_564853 = newJObject()
  var body_564854 = newJObject()
  add(query_564853, "api-version", newJString(apiVersion))
  add(path_564852, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564852, "subscriptionId", newJString(subscriptionId))
  add(path_564852, "resourceGroupName", newJString(resourceGroupName))
  if vmInstanceIDs != nil:
    body_564854 = vmInstanceIDs
  result = call_564851.call(path_564852, query_564853, nil, nil, body_564854)

var virtualMachineScaleSetsUpdateInstances* = Call_VirtualMachineScaleSetsUpdateInstances_564842(
    name: "virtualMachineScaleSetsUpdateInstances", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/manualupgrade",
    validator: validate_VirtualMachineScaleSetsUpdateInstances_564843, base: "",
    url: url_VirtualMachineScaleSetsUpdateInstances_564844,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_564855 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_564857(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/osRollingUpgrade")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_564856(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Starts a rolling upgrade to move all virtual machine scale set instances to the latest available Platform Image OS version. Instances which are already running the latest available OS version are not affected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564858 = path.getOrDefault("vmScaleSetName")
  valid_564858 = validateParameter(valid_564858, JString, required = true,
                                 default = nil)
  if valid_564858 != nil:
    section.add "vmScaleSetName", valid_564858
  var valid_564859 = path.getOrDefault("subscriptionId")
  valid_564859 = validateParameter(valid_564859, JString, required = true,
                                 default = nil)
  if valid_564859 != nil:
    section.add "subscriptionId", valid_564859
  var valid_564860 = path.getOrDefault("resourceGroupName")
  valid_564860 = validateParameter(valid_564860, JString, required = true,
                                 default = nil)
  if valid_564860 != nil:
    section.add "resourceGroupName", valid_564860
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564861 = query.getOrDefault("api-version")
  valid_564861 = validateParameter(valid_564861, JString, required = true,
                                 default = nil)
  if valid_564861 != nil:
    section.add "api-version", valid_564861
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564862: Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_564855;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a rolling upgrade to move all virtual machine scale set instances to the latest available Platform Image OS version. Instances which are already running the latest available OS version are not affected.
  ## 
  let valid = call_564862.validator(path, query, header, formData, body)
  let scheme = call_564862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564862.url(scheme.get, call_564862.host, call_564862.base,
                         call_564862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564862, url, valid)

proc call*(call_564863: Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_564855;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## virtualMachineScaleSetRollingUpgradesStartOSUpgrade
  ## Starts a rolling upgrade to move all virtual machine scale set instances to the latest available Platform Image OS version. Instances which are already running the latest available OS version are not affected.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564864 = newJObject()
  var query_564865 = newJObject()
  add(query_564865, "api-version", newJString(apiVersion))
  add(path_564864, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564864, "subscriptionId", newJString(subscriptionId))
  add(path_564864, "resourceGroupName", newJString(resourceGroupName))
  result = call_564863.call(path_564864, query_564865, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesStartOSUpgrade* = Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_564855(
    name: "virtualMachineScaleSetRollingUpgradesStartOSUpgrade",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/osRollingUpgrade",
    validator: validate_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_564856,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_564857,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGetOSUpgradeHistory_564866 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsGetOSUpgradeHistory_564868(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/osUpgradeHistory")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsGetOSUpgradeHistory_564867(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets list of OS upgrades on a VM scale set instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564869 = path.getOrDefault("vmScaleSetName")
  valid_564869 = validateParameter(valid_564869, JString, required = true,
                                 default = nil)
  if valid_564869 != nil:
    section.add "vmScaleSetName", valid_564869
  var valid_564870 = path.getOrDefault("subscriptionId")
  valid_564870 = validateParameter(valid_564870, JString, required = true,
                                 default = nil)
  if valid_564870 != nil:
    section.add "subscriptionId", valid_564870
  var valid_564871 = path.getOrDefault("resourceGroupName")
  valid_564871 = validateParameter(valid_564871, JString, required = true,
                                 default = nil)
  if valid_564871 != nil:
    section.add "resourceGroupName", valid_564871
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564872 = query.getOrDefault("api-version")
  valid_564872 = validateParameter(valid_564872, JString, required = true,
                                 default = nil)
  if valid_564872 != nil:
    section.add "api-version", valid_564872
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564873: Call_VirtualMachineScaleSetsGetOSUpgradeHistory_564866;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets list of OS upgrades on a VM scale set instance.
  ## 
  let valid = call_564873.validator(path, query, header, formData, body)
  let scheme = call_564873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564873.url(scheme.get, call_564873.host, call_564873.base,
                         call_564873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564873, url, valid)

proc call*(call_564874: Call_VirtualMachineScaleSetsGetOSUpgradeHistory_564866;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## virtualMachineScaleSetsGetOSUpgradeHistory
  ## Gets list of OS upgrades on a VM scale set instance.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564875 = newJObject()
  var query_564876 = newJObject()
  add(query_564876, "api-version", newJString(apiVersion))
  add(path_564875, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564875, "subscriptionId", newJString(subscriptionId))
  add(path_564875, "resourceGroupName", newJString(resourceGroupName))
  result = call_564874.call(path_564875, query_564876, nil, nil, nil)

var virtualMachineScaleSetsGetOSUpgradeHistory* = Call_VirtualMachineScaleSetsGetOSUpgradeHistory_564866(
    name: "virtualMachineScaleSetsGetOSUpgradeHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/osUpgradeHistory",
    validator: validate_VirtualMachineScaleSetsGetOSUpgradeHistory_564867,
    base: "", url: url_VirtualMachineScaleSetsGetOSUpgradeHistory_564868,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsPerformMaintenance_564877 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsPerformMaintenance_564879(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/performMaintenance")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsPerformMaintenance_564878(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Perform maintenance on one or more virtual machines in a VM scale set. Operation on instances which are not eligible for perform maintenance will be failed. Please refer to best practices for more details: https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-maintenance-notifications
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564880 = path.getOrDefault("vmScaleSetName")
  valid_564880 = validateParameter(valid_564880, JString, required = true,
                                 default = nil)
  if valid_564880 != nil:
    section.add "vmScaleSetName", valid_564880
  var valid_564881 = path.getOrDefault("subscriptionId")
  valid_564881 = validateParameter(valid_564881, JString, required = true,
                                 default = nil)
  if valid_564881 != nil:
    section.add "subscriptionId", valid_564881
  var valid_564882 = path.getOrDefault("resourceGroupName")
  valid_564882 = validateParameter(valid_564882, JString, required = true,
                                 default = nil)
  if valid_564882 != nil:
    section.add "resourceGroupName", valid_564882
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564883 = query.getOrDefault("api-version")
  valid_564883 = validateParameter(valid_564883, JString, required = true,
                                 default = nil)
  if valid_564883 != nil:
    section.add "api-version", valid_564883
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564885: Call_VirtualMachineScaleSetsPerformMaintenance_564877;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Perform maintenance on one or more virtual machines in a VM scale set. Operation on instances which are not eligible for perform maintenance will be failed. Please refer to best practices for more details: https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-maintenance-notifications
  ## 
  let valid = call_564885.validator(path, query, header, formData, body)
  let scheme = call_564885.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564885.url(scheme.get, call_564885.host, call_564885.base,
                         call_564885.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564885, url, valid)

proc call*(call_564886: Call_VirtualMachineScaleSetsPerformMaintenance_564877;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsPerformMaintenance
  ## Perform maintenance on one or more virtual machines in a VM scale set. Operation on instances which are not eligible for perform maintenance will be failed. Please refer to best practices for more details: https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-maintenance-notifications
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_564887 = newJObject()
  var query_564888 = newJObject()
  var body_564889 = newJObject()
  add(query_564888, "api-version", newJString(apiVersion))
  add(path_564887, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564887, "subscriptionId", newJString(subscriptionId))
  add(path_564887, "resourceGroupName", newJString(resourceGroupName))
  if vmInstanceIDs != nil:
    body_564889 = vmInstanceIDs
  result = call_564886.call(path_564887, query_564888, nil, nil, body_564889)

var virtualMachineScaleSetsPerformMaintenance* = Call_VirtualMachineScaleSetsPerformMaintenance_564877(
    name: "virtualMachineScaleSetsPerformMaintenance", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/performMaintenance",
    validator: validate_VirtualMachineScaleSetsPerformMaintenance_564878,
    base: "", url: url_VirtualMachineScaleSetsPerformMaintenance_564879,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsPowerOff_564890 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsPowerOff_564892(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/poweroff")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsPowerOff_564891(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Power off (stop) one or more virtual machines in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564893 = path.getOrDefault("vmScaleSetName")
  valid_564893 = validateParameter(valid_564893, JString, required = true,
                                 default = nil)
  if valid_564893 != nil:
    section.add "vmScaleSetName", valid_564893
  var valid_564894 = path.getOrDefault("subscriptionId")
  valid_564894 = validateParameter(valid_564894, JString, required = true,
                                 default = nil)
  if valid_564894 != nil:
    section.add "subscriptionId", valid_564894
  var valid_564895 = path.getOrDefault("resourceGroupName")
  valid_564895 = validateParameter(valid_564895, JString, required = true,
                                 default = nil)
  if valid_564895 != nil:
    section.add "resourceGroupName", valid_564895
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   skipShutdown: JBool
  ##               : The parameter to request non-graceful VM shutdown. True value for this flag indicates non-graceful shutdown whereas false indicates otherwise. Default value for this flag is false if not specified
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564896 = query.getOrDefault("api-version")
  valid_564896 = validateParameter(valid_564896, JString, required = true,
                                 default = nil)
  if valid_564896 != nil:
    section.add "api-version", valid_564896
  var valid_564897 = query.getOrDefault("skipShutdown")
  valid_564897 = validateParameter(valid_564897, JBool, required = false,
                                 default = newJBool(false))
  if valid_564897 != nil:
    section.add "skipShutdown", valid_564897
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564899: Call_VirtualMachineScaleSetsPowerOff_564890;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Power off (stop) one or more virtual machines in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  let valid = call_564899.validator(path, query, header, formData, body)
  let scheme = call_564899.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564899.url(scheme.get, call_564899.host, call_564899.base,
                         call_564899.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564899, url, valid)

proc call*(call_564900: Call_VirtualMachineScaleSetsPowerOff_564890;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; skipShutdown: bool = false;
          vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsPowerOff
  ## Power off (stop) one or more virtual machines in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   skipShutdown: bool
  ##               : The parameter to request non-graceful VM shutdown. True value for this flag indicates non-graceful shutdown whereas false indicates otherwise. Default value for this flag is false if not specified
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_564901 = newJObject()
  var query_564902 = newJObject()
  var body_564903 = newJObject()
  add(query_564902, "api-version", newJString(apiVersion))
  add(path_564901, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564901, "subscriptionId", newJString(subscriptionId))
  add(path_564901, "resourceGroupName", newJString(resourceGroupName))
  add(query_564902, "skipShutdown", newJBool(skipShutdown))
  if vmInstanceIDs != nil:
    body_564903 = vmInstanceIDs
  result = call_564900.call(path_564901, query_564902, nil, nil, body_564903)

var virtualMachineScaleSetsPowerOff* = Call_VirtualMachineScaleSetsPowerOff_564890(
    name: "virtualMachineScaleSetsPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/poweroff",
    validator: validate_VirtualMachineScaleSetsPowerOff_564891, base: "",
    url: url_VirtualMachineScaleSetsPowerOff_564892, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsRedeploy_564904 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsRedeploy_564906(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/redeploy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsRedeploy_564905(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shuts down all the virtual machines in the virtual machine scale set, moves them to a new node, and powers them back on.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564907 = path.getOrDefault("vmScaleSetName")
  valid_564907 = validateParameter(valid_564907, JString, required = true,
                                 default = nil)
  if valid_564907 != nil:
    section.add "vmScaleSetName", valid_564907
  var valid_564908 = path.getOrDefault("subscriptionId")
  valid_564908 = validateParameter(valid_564908, JString, required = true,
                                 default = nil)
  if valid_564908 != nil:
    section.add "subscriptionId", valid_564908
  var valid_564909 = path.getOrDefault("resourceGroupName")
  valid_564909 = validateParameter(valid_564909, JString, required = true,
                                 default = nil)
  if valid_564909 != nil:
    section.add "resourceGroupName", valid_564909
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564910 = query.getOrDefault("api-version")
  valid_564910 = validateParameter(valid_564910, JString, required = true,
                                 default = nil)
  if valid_564910 != nil:
    section.add "api-version", valid_564910
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564912: Call_VirtualMachineScaleSetsRedeploy_564904;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Shuts down all the virtual machines in the virtual machine scale set, moves them to a new node, and powers them back on.
  ## 
  let valid = call_564912.validator(path, query, header, formData, body)
  let scheme = call_564912.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564912.url(scheme.get, call_564912.host, call_564912.base,
                         call_564912.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564912, url, valid)

proc call*(call_564913: Call_VirtualMachineScaleSetsRedeploy_564904;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsRedeploy
  ## Shuts down all the virtual machines in the virtual machine scale set, moves them to a new node, and powers them back on.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_564914 = newJObject()
  var query_564915 = newJObject()
  var body_564916 = newJObject()
  add(query_564915, "api-version", newJString(apiVersion))
  add(path_564914, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564914, "subscriptionId", newJString(subscriptionId))
  add(path_564914, "resourceGroupName", newJString(resourceGroupName))
  if vmInstanceIDs != nil:
    body_564916 = vmInstanceIDs
  result = call_564913.call(path_564914, query_564915, nil, nil, body_564916)

var virtualMachineScaleSetsRedeploy* = Call_VirtualMachineScaleSetsRedeploy_564904(
    name: "virtualMachineScaleSetsRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/redeploy",
    validator: validate_VirtualMachineScaleSetsRedeploy_564905, base: "",
    url: url_VirtualMachineScaleSetsRedeploy_564906, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsReimage_564917 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsReimage_564919(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/reimage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsReimage_564918(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reimages (upgrade the operating system) one or more virtual machines in a VM scale set which don't have a ephemeral OS disk, for virtual machines who have a ephemeral OS disk the virtual machine is reset to initial state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564920 = path.getOrDefault("vmScaleSetName")
  valid_564920 = validateParameter(valid_564920, JString, required = true,
                                 default = nil)
  if valid_564920 != nil:
    section.add "vmScaleSetName", valid_564920
  var valid_564921 = path.getOrDefault("subscriptionId")
  valid_564921 = validateParameter(valid_564921, JString, required = true,
                                 default = nil)
  if valid_564921 != nil:
    section.add "subscriptionId", valid_564921
  var valid_564922 = path.getOrDefault("resourceGroupName")
  valid_564922 = validateParameter(valid_564922, JString, required = true,
                                 default = nil)
  if valid_564922 != nil:
    section.add "resourceGroupName", valid_564922
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564923 = query.getOrDefault("api-version")
  valid_564923 = validateParameter(valid_564923, JString, required = true,
                                 default = nil)
  if valid_564923 != nil:
    section.add "api-version", valid_564923
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vmScaleSetReimageInput: JObject
  ##                         : Parameters for Reimaging VM ScaleSet.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564925: Call_VirtualMachineScaleSetsReimage_564917; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reimages (upgrade the operating system) one or more virtual machines in a VM scale set which don't have a ephemeral OS disk, for virtual machines who have a ephemeral OS disk the virtual machine is reset to initial state.
  ## 
  let valid = call_564925.validator(path, query, header, formData, body)
  let scheme = call_564925.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564925.url(scheme.get, call_564925.host, call_564925.base,
                         call_564925.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564925, url, valid)

proc call*(call_564926: Call_VirtualMachineScaleSetsReimage_564917;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; vmScaleSetReimageInput: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsReimage
  ## Reimages (upgrade the operating system) one or more virtual machines in a VM scale set which don't have a ephemeral OS disk, for virtual machines who have a ephemeral OS disk the virtual machine is reset to initial state.
  ##   vmScaleSetReimageInput: JObject
  ##                         : Parameters for Reimaging VM ScaleSet.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564927 = newJObject()
  var query_564928 = newJObject()
  var body_564929 = newJObject()
  if vmScaleSetReimageInput != nil:
    body_564929 = vmScaleSetReimageInput
  add(query_564928, "api-version", newJString(apiVersion))
  add(path_564927, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564927, "subscriptionId", newJString(subscriptionId))
  add(path_564927, "resourceGroupName", newJString(resourceGroupName))
  result = call_564926.call(path_564927, query_564928, nil, nil, body_564929)

var virtualMachineScaleSetsReimage* = Call_VirtualMachineScaleSetsReimage_564917(
    name: "virtualMachineScaleSetsReimage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/reimage",
    validator: validate_VirtualMachineScaleSetsReimage_564918, base: "",
    url: url_VirtualMachineScaleSetsReimage_564919, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsReimageAll_564930 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsReimageAll_564932(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/reimageall")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsReimageAll_564931(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reimages all the disks ( including data disks ) in the virtual machines in a VM scale set. This operation is only supported for managed disks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564933 = path.getOrDefault("vmScaleSetName")
  valid_564933 = validateParameter(valid_564933, JString, required = true,
                                 default = nil)
  if valid_564933 != nil:
    section.add "vmScaleSetName", valid_564933
  var valid_564934 = path.getOrDefault("subscriptionId")
  valid_564934 = validateParameter(valid_564934, JString, required = true,
                                 default = nil)
  if valid_564934 != nil:
    section.add "subscriptionId", valid_564934
  var valid_564935 = path.getOrDefault("resourceGroupName")
  valid_564935 = validateParameter(valid_564935, JString, required = true,
                                 default = nil)
  if valid_564935 != nil:
    section.add "resourceGroupName", valid_564935
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564936 = query.getOrDefault("api-version")
  valid_564936 = validateParameter(valid_564936, JString, required = true,
                                 default = nil)
  if valid_564936 != nil:
    section.add "api-version", valid_564936
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564938: Call_VirtualMachineScaleSetsReimageAll_564930;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reimages all the disks ( including data disks ) in the virtual machines in a VM scale set. This operation is only supported for managed disks.
  ## 
  let valid = call_564938.validator(path, query, header, formData, body)
  let scheme = call_564938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564938.url(scheme.get, call_564938.host, call_564938.base,
                         call_564938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564938, url, valid)

proc call*(call_564939: Call_VirtualMachineScaleSetsReimageAll_564930;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsReimageAll
  ## Reimages all the disks ( including data disks ) in the virtual machines in a VM scale set. This operation is only supported for managed disks.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_564940 = newJObject()
  var query_564941 = newJObject()
  var body_564942 = newJObject()
  add(query_564941, "api-version", newJString(apiVersion))
  add(path_564940, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564940, "subscriptionId", newJString(subscriptionId))
  add(path_564940, "resourceGroupName", newJString(resourceGroupName))
  if vmInstanceIDs != nil:
    body_564942 = vmInstanceIDs
  result = call_564939.call(path_564940, query_564941, nil, nil, body_564942)

var virtualMachineScaleSetsReimageAll* = Call_VirtualMachineScaleSetsReimageAll_564930(
    name: "virtualMachineScaleSetsReimageAll", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/reimageall",
    validator: validate_VirtualMachineScaleSetsReimageAll_564931, base: "",
    url: url_VirtualMachineScaleSetsReimageAll_564932, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsRestart_564943 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsRestart_564945(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsRestart_564944(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restarts one or more virtual machines in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564946 = path.getOrDefault("vmScaleSetName")
  valid_564946 = validateParameter(valid_564946, JString, required = true,
                                 default = nil)
  if valid_564946 != nil:
    section.add "vmScaleSetName", valid_564946
  var valid_564947 = path.getOrDefault("subscriptionId")
  valid_564947 = validateParameter(valid_564947, JString, required = true,
                                 default = nil)
  if valid_564947 != nil:
    section.add "subscriptionId", valid_564947
  var valid_564948 = path.getOrDefault("resourceGroupName")
  valid_564948 = validateParameter(valid_564948, JString, required = true,
                                 default = nil)
  if valid_564948 != nil:
    section.add "resourceGroupName", valid_564948
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564949 = query.getOrDefault("api-version")
  valid_564949 = validateParameter(valid_564949, JString, required = true,
                                 default = nil)
  if valid_564949 != nil:
    section.add "api-version", valid_564949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564951: Call_VirtualMachineScaleSetsRestart_564943; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts one or more virtual machines in a VM scale set.
  ## 
  let valid = call_564951.validator(path, query, header, formData, body)
  let scheme = call_564951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564951.url(scheme.get, call_564951.host, call_564951.base,
                         call_564951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564951, url, valid)

proc call*(call_564952: Call_VirtualMachineScaleSetsRestart_564943;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsRestart
  ## Restarts one or more virtual machines in a VM scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_564953 = newJObject()
  var query_564954 = newJObject()
  var body_564955 = newJObject()
  add(query_564954, "api-version", newJString(apiVersion))
  add(path_564953, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564953, "subscriptionId", newJString(subscriptionId))
  add(path_564953, "resourceGroupName", newJString(resourceGroupName))
  if vmInstanceIDs != nil:
    body_564955 = vmInstanceIDs
  result = call_564952.call(path_564953, query_564954, nil, nil, body_564955)

var virtualMachineScaleSetsRestart* = Call_VirtualMachineScaleSetsRestart_564943(
    name: "virtualMachineScaleSetsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/restart",
    validator: validate_VirtualMachineScaleSetsRestart_564944, base: "",
    url: url_VirtualMachineScaleSetsRestart_564945, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesCancel_564956 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetRollingUpgradesCancel_564958(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/rollingUpgrades/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetRollingUpgradesCancel_564957(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the current virtual machine scale set rolling upgrade.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564959 = path.getOrDefault("vmScaleSetName")
  valid_564959 = validateParameter(valid_564959, JString, required = true,
                                 default = nil)
  if valid_564959 != nil:
    section.add "vmScaleSetName", valid_564959
  var valid_564960 = path.getOrDefault("subscriptionId")
  valid_564960 = validateParameter(valid_564960, JString, required = true,
                                 default = nil)
  if valid_564960 != nil:
    section.add "subscriptionId", valid_564960
  var valid_564961 = path.getOrDefault("resourceGroupName")
  valid_564961 = validateParameter(valid_564961, JString, required = true,
                                 default = nil)
  if valid_564961 != nil:
    section.add "resourceGroupName", valid_564961
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564962 = query.getOrDefault("api-version")
  valid_564962 = validateParameter(valid_564962, JString, required = true,
                                 default = nil)
  if valid_564962 != nil:
    section.add "api-version", valid_564962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564963: Call_VirtualMachineScaleSetRollingUpgradesCancel_564956;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the current virtual machine scale set rolling upgrade.
  ## 
  let valid = call_564963.validator(path, query, header, formData, body)
  let scheme = call_564963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564963.url(scheme.get, call_564963.host, call_564963.base,
                         call_564963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564963, url, valid)

proc call*(call_564964: Call_VirtualMachineScaleSetRollingUpgradesCancel_564956;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## virtualMachineScaleSetRollingUpgradesCancel
  ## Cancels the current virtual machine scale set rolling upgrade.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564965 = newJObject()
  var query_564966 = newJObject()
  add(query_564966, "api-version", newJString(apiVersion))
  add(path_564965, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564965, "subscriptionId", newJString(subscriptionId))
  add(path_564965, "resourceGroupName", newJString(resourceGroupName))
  result = call_564964.call(path_564965, query_564966, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesCancel* = Call_VirtualMachineScaleSetRollingUpgradesCancel_564956(
    name: "virtualMachineScaleSetRollingUpgradesCancel",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/rollingUpgrades/cancel",
    validator: validate_VirtualMachineScaleSetRollingUpgradesCancel_564957,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesCancel_564958,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesGetLatest_564967 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetRollingUpgradesGetLatest_564969(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/rollingUpgrades/latest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetRollingUpgradesGetLatest_564968(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the status of the latest virtual machine scale set rolling upgrade.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564970 = path.getOrDefault("vmScaleSetName")
  valid_564970 = validateParameter(valid_564970, JString, required = true,
                                 default = nil)
  if valid_564970 != nil:
    section.add "vmScaleSetName", valid_564970
  var valid_564971 = path.getOrDefault("subscriptionId")
  valid_564971 = validateParameter(valid_564971, JString, required = true,
                                 default = nil)
  if valid_564971 != nil:
    section.add "subscriptionId", valid_564971
  var valid_564972 = path.getOrDefault("resourceGroupName")
  valid_564972 = validateParameter(valid_564972, JString, required = true,
                                 default = nil)
  if valid_564972 != nil:
    section.add "resourceGroupName", valid_564972
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564973 = query.getOrDefault("api-version")
  valid_564973 = validateParameter(valid_564973, JString, required = true,
                                 default = nil)
  if valid_564973 != nil:
    section.add "api-version", valid_564973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564974: Call_VirtualMachineScaleSetRollingUpgradesGetLatest_564967;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of the latest virtual machine scale set rolling upgrade.
  ## 
  let valid = call_564974.validator(path, query, header, formData, body)
  let scheme = call_564974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564974.url(scheme.get, call_564974.host, call_564974.base,
                         call_564974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564974, url, valid)

proc call*(call_564975: Call_VirtualMachineScaleSetRollingUpgradesGetLatest_564967;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## virtualMachineScaleSetRollingUpgradesGetLatest
  ## Gets the status of the latest virtual machine scale set rolling upgrade.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564976 = newJObject()
  var query_564977 = newJObject()
  add(query_564977, "api-version", newJString(apiVersion))
  add(path_564976, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564976, "subscriptionId", newJString(subscriptionId))
  add(path_564976, "resourceGroupName", newJString(resourceGroupName))
  result = call_564975.call(path_564976, query_564977, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesGetLatest* = Call_VirtualMachineScaleSetRollingUpgradesGetLatest_564967(
    name: "virtualMachineScaleSetRollingUpgradesGetLatest",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/rollingUpgrades/latest",
    validator: validate_VirtualMachineScaleSetRollingUpgradesGetLatest_564968,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesGetLatest_564969,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsListSkus_564978 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsListSkus_564980(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/skus")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsListSkus_564979(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of SKUs available for your VM scale set, including the minimum and maximum VM instances allowed for each SKU.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564981 = path.getOrDefault("vmScaleSetName")
  valid_564981 = validateParameter(valid_564981, JString, required = true,
                                 default = nil)
  if valid_564981 != nil:
    section.add "vmScaleSetName", valid_564981
  var valid_564982 = path.getOrDefault("subscriptionId")
  valid_564982 = validateParameter(valid_564982, JString, required = true,
                                 default = nil)
  if valid_564982 != nil:
    section.add "subscriptionId", valid_564982
  var valid_564983 = path.getOrDefault("resourceGroupName")
  valid_564983 = validateParameter(valid_564983, JString, required = true,
                                 default = nil)
  if valid_564983 != nil:
    section.add "resourceGroupName", valid_564983
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564984 = query.getOrDefault("api-version")
  valid_564984 = validateParameter(valid_564984, JString, required = true,
                                 default = nil)
  if valid_564984 != nil:
    section.add "api-version", valid_564984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564985: Call_VirtualMachineScaleSetsListSkus_564978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of SKUs available for your VM scale set, including the minimum and maximum VM instances allowed for each SKU.
  ## 
  let valid = call_564985.validator(path, query, header, formData, body)
  let scheme = call_564985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564985.url(scheme.get, call_564985.host, call_564985.base,
                         call_564985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564985, url, valid)

proc call*(call_564986: Call_VirtualMachineScaleSetsListSkus_564978;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string): Recallable =
  ## virtualMachineScaleSetsListSkus
  ## Gets a list of SKUs available for your VM scale set, including the minimum and maximum VM instances allowed for each SKU.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564987 = newJObject()
  var query_564988 = newJObject()
  add(query_564988, "api-version", newJString(apiVersion))
  add(path_564987, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564987, "subscriptionId", newJString(subscriptionId))
  add(path_564987, "resourceGroupName", newJString(resourceGroupName))
  result = call_564986.call(path_564987, query_564988, nil, nil, nil)

var virtualMachineScaleSetsListSkus* = Call_VirtualMachineScaleSetsListSkus_564978(
    name: "virtualMachineScaleSetsListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/skus",
    validator: validate_VirtualMachineScaleSetsListSkus_564979, base: "",
    url: url_VirtualMachineScaleSetsListSkus_564980, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsStart_564989 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsStart_564991(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetsStart_564990(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts one or more virtual machines in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_564992 = path.getOrDefault("vmScaleSetName")
  valid_564992 = validateParameter(valid_564992, JString, required = true,
                                 default = nil)
  if valid_564992 != nil:
    section.add "vmScaleSetName", valid_564992
  var valid_564993 = path.getOrDefault("subscriptionId")
  valid_564993 = validateParameter(valid_564993, JString, required = true,
                                 default = nil)
  if valid_564993 != nil:
    section.add "subscriptionId", valid_564993
  var valid_564994 = path.getOrDefault("resourceGroupName")
  valid_564994 = validateParameter(valid_564994, JString, required = true,
                                 default = nil)
  if valid_564994 != nil:
    section.add "resourceGroupName", valid_564994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564995 = query.getOrDefault("api-version")
  valid_564995 = validateParameter(valid_564995, JString, required = true,
                                 default = nil)
  if valid_564995 != nil:
    section.add "api-version", valid_564995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564997: Call_VirtualMachineScaleSetsStart_564989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts one or more virtual machines in a VM scale set.
  ## 
  let valid = call_564997.validator(path, query, header, formData, body)
  let scheme = call_564997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564997.url(scheme.get, call_564997.host, call_564997.base,
                         call_564997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564997, url, valid)

proc call*(call_564998: Call_VirtualMachineScaleSetsStart_564989;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsStart
  ## Starts one or more virtual machines in a VM scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_564999 = newJObject()
  var query_565000 = newJObject()
  var body_565001 = newJObject()
  add(query_565000, "api-version", newJString(apiVersion))
  add(path_564999, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564999, "subscriptionId", newJString(subscriptionId))
  add(path_564999, "resourceGroupName", newJString(resourceGroupName))
  if vmInstanceIDs != nil:
    body_565001 = vmInstanceIDs
  result = call_564998.call(path_564999, query_565000, nil, nil, body_565001)

var virtualMachineScaleSetsStart* = Call_VirtualMachineScaleSetsStart_564989(
    name: "virtualMachineScaleSetsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/start",
    validator: validate_VirtualMachineScaleSetsStart_564990, base: "",
    url: url_VirtualMachineScaleSetsStart_564991, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsUpdate_565015 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsUpdate_565017(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsUpdate_565016(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a virtual machine of a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set where the extension should be create or updated.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_565018 = path.getOrDefault("vmScaleSetName")
  valid_565018 = validateParameter(valid_565018, JString, required = true,
                                 default = nil)
  if valid_565018 != nil:
    section.add "vmScaleSetName", valid_565018
  var valid_565019 = path.getOrDefault("subscriptionId")
  valid_565019 = validateParameter(valid_565019, JString, required = true,
                                 default = nil)
  if valid_565019 != nil:
    section.add "subscriptionId", valid_565019
  var valid_565020 = path.getOrDefault("resourceGroupName")
  valid_565020 = validateParameter(valid_565020, JString, required = true,
                                 default = nil)
  if valid_565020 != nil:
    section.add "resourceGroupName", valid_565020
  var valid_565021 = path.getOrDefault("instanceId")
  valid_565021 = validateParameter(valid_565021, JString, required = true,
                                 default = nil)
  if valid_565021 != nil:
    section.add "instanceId", valid_565021
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565022 = query.getOrDefault("api-version")
  valid_565022 = validateParameter(valid_565022, JString, required = true,
                                 default = nil)
  if valid_565022 != nil:
    section.add "api-version", valid_565022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Virtual Machine Scale Sets VM operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565024: Call_VirtualMachineScaleSetVMsUpdate_565015;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a virtual machine of a VM scale set.
  ## 
  let valid = call_565024.validator(path, query, header, formData, body)
  let scheme = call_565024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565024.url(scheme.get, call_565024.host, call_565024.base,
                         call_565024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565024, url, valid)

proc call*(call_565025: Call_VirtualMachineScaleSetVMsUpdate_565015;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; instanceId: string; parameters: JsonNode): Recallable =
  ## virtualMachineScaleSetVMsUpdate
  ## Updates a virtual machine of a VM scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set where the extension should be create or updated.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Virtual Machine Scale Sets VM operation.
  var path_565026 = newJObject()
  var query_565027 = newJObject()
  var body_565028 = newJObject()
  add(query_565027, "api-version", newJString(apiVersion))
  add(path_565026, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_565026, "subscriptionId", newJString(subscriptionId))
  add(path_565026, "resourceGroupName", newJString(resourceGroupName))
  add(path_565026, "instanceId", newJString(instanceId))
  if parameters != nil:
    body_565028 = parameters
  result = call_565025.call(path_565026, query_565027, nil, nil, body_565028)

var virtualMachineScaleSetVMsUpdate* = Call_VirtualMachineScaleSetVMsUpdate_565015(
    name: "virtualMachineScaleSetVMsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsUpdate_565016, base: "",
    url: url_VirtualMachineScaleSetVMsUpdate_565017, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsGet_565002 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsGet_565004(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsGet_565003(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a virtual machine from a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_565005 = path.getOrDefault("vmScaleSetName")
  valid_565005 = validateParameter(valid_565005, JString, required = true,
                                 default = nil)
  if valid_565005 != nil:
    section.add "vmScaleSetName", valid_565005
  var valid_565006 = path.getOrDefault("subscriptionId")
  valid_565006 = validateParameter(valid_565006, JString, required = true,
                                 default = nil)
  if valid_565006 != nil:
    section.add "subscriptionId", valid_565006
  var valid_565007 = path.getOrDefault("resourceGroupName")
  valid_565007 = validateParameter(valid_565007, JString, required = true,
                                 default = nil)
  if valid_565007 != nil:
    section.add "resourceGroupName", valid_565007
  var valid_565008 = path.getOrDefault("instanceId")
  valid_565008 = validateParameter(valid_565008, JString, required = true,
                                 default = nil)
  if valid_565008 != nil:
    section.add "instanceId", valid_565008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565009 = query.getOrDefault("api-version")
  valid_565009 = validateParameter(valid_565009, JString, required = true,
                                 default = nil)
  if valid_565009 != nil:
    section.add "api-version", valid_565009
  var valid_565010 = query.getOrDefault("$expand")
  valid_565010 = validateParameter(valid_565010, JString, required = false,
                                 default = newJString("instanceView"))
  if valid_565010 != nil:
    section.add "$expand", valid_565010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565011: Call_VirtualMachineScaleSetVMsGet_565002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a virtual machine from a VM scale set.
  ## 
  let valid = call_565011.validator(path, query, header, formData, body)
  let scheme = call_565011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565011.url(scheme.get, call_565011.host, call_565011.base,
                         call_565011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565011, url, valid)

proc call*(call_565012: Call_VirtualMachineScaleSetVMsGet_565002;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; instanceId: string;
          Expand: string = "instanceView"): Recallable =
  ## virtualMachineScaleSetVMsGet
  ## Gets a virtual machine from a VM scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_565013 = newJObject()
  var query_565014 = newJObject()
  add(query_565014, "api-version", newJString(apiVersion))
  add(path_565013, "vmScaleSetName", newJString(vmScaleSetName))
  add(query_565014, "$expand", newJString(Expand))
  add(path_565013, "subscriptionId", newJString(subscriptionId))
  add(path_565013, "resourceGroupName", newJString(resourceGroupName))
  add(path_565013, "instanceId", newJString(instanceId))
  result = call_565012.call(path_565013, query_565014, nil, nil, nil)

var virtualMachineScaleSetVMsGet* = Call_VirtualMachineScaleSetVMsGet_565002(
    name: "virtualMachineScaleSetVMsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsGet_565003, base: "",
    url: url_VirtualMachineScaleSetVMsGet_565004, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsDelete_565029 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsDelete_565031(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsDelete_565030(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a virtual machine from a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_565032 = path.getOrDefault("vmScaleSetName")
  valid_565032 = validateParameter(valid_565032, JString, required = true,
                                 default = nil)
  if valid_565032 != nil:
    section.add "vmScaleSetName", valid_565032
  var valid_565033 = path.getOrDefault("subscriptionId")
  valid_565033 = validateParameter(valid_565033, JString, required = true,
                                 default = nil)
  if valid_565033 != nil:
    section.add "subscriptionId", valid_565033
  var valid_565034 = path.getOrDefault("resourceGroupName")
  valid_565034 = validateParameter(valid_565034, JString, required = true,
                                 default = nil)
  if valid_565034 != nil:
    section.add "resourceGroupName", valid_565034
  var valid_565035 = path.getOrDefault("instanceId")
  valid_565035 = validateParameter(valid_565035, JString, required = true,
                                 default = nil)
  if valid_565035 != nil:
    section.add "instanceId", valid_565035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565036 = query.getOrDefault("api-version")
  valid_565036 = validateParameter(valid_565036, JString, required = true,
                                 default = nil)
  if valid_565036 != nil:
    section.add "api-version", valid_565036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565037: Call_VirtualMachineScaleSetVMsDelete_565029;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a virtual machine from a VM scale set.
  ## 
  let valid = call_565037.validator(path, query, header, formData, body)
  let scheme = call_565037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565037.url(scheme.get, call_565037.host, call_565037.base,
                         call_565037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565037, url, valid)

proc call*(call_565038: Call_VirtualMachineScaleSetVMsDelete_565029;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsDelete
  ## Deletes a virtual machine from a VM scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_565039 = newJObject()
  var query_565040 = newJObject()
  add(query_565040, "api-version", newJString(apiVersion))
  add(path_565039, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_565039, "subscriptionId", newJString(subscriptionId))
  add(path_565039, "resourceGroupName", newJString(resourceGroupName))
  add(path_565039, "instanceId", newJString(instanceId))
  result = call_565038.call(path_565039, query_565040, nil, nil, nil)

var virtualMachineScaleSetVMsDelete* = Call_VirtualMachineScaleSetVMsDelete_565029(
    name: "virtualMachineScaleSetVMsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsDelete_565030, base: "",
    url: url_VirtualMachineScaleSetVMsDelete_565031, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsDeallocate_565041 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsDeallocate_565043(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/deallocate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsDeallocate_565042(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deallocates a specific virtual machine in a VM scale set. Shuts down the virtual machine and releases the compute resources it uses. You are not billed for the compute resources of this virtual machine once it is deallocated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_565044 = path.getOrDefault("vmScaleSetName")
  valid_565044 = validateParameter(valid_565044, JString, required = true,
                                 default = nil)
  if valid_565044 != nil:
    section.add "vmScaleSetName", valid_565044
  var valid_565045 = path.getOrDefault("subscriptionId")
  valid_565045 = validateParameter(valid_565045, JString, required = true,
                                 default = nil)
  if valid_565045 != nil:
    section.add "subscriptionId", valid_565045
  var valid_565046 = path.getOrDefault("resourceGroupName")
  valid_565046 = validateParameter(valid_565046, JString, required = true,
                                 default = nil)
  if valid_565046 != nil:
    section.add "resourceGroupName", valid_565046
  var valid_565047 = path.getOrDefault("instanceId")
  valid_565047 = validateParameter(valid_565047, JString, required = true,
                                 default = nil)
  if valid_565047 != nil:
    section.add "instanceId", valid_565047
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565048 = query.getOrDefault("api-version")
  valid_565048 = validateParameter(valid_565048, JString, required = true,
                                 default = nil)
  if valid_565048 != nil:
    section.add "api-version", valid_565048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565049: Call_VirtualMachineScaleSetVMsDeallocate_565041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deallocates a specific virtual machine in a VM scale set. Shuts down the virtual machine and releases the compute resources it uses. You are not billed for the compute resources of this virtual machine once it is deallocated.
  ## 
  let valid = call_565049.validator(path, query, header, formData, body)
  let scheme = call_565049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565049.url(scheme.get, call_565049.host, call_565049.base,
                         call_565049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565049, url, valid)

proc call*(call_565050: Call_VirtualMachineScaleSetVMsDeallocate_565041;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsDeallocate
  ## Deallocates a specific virtual machine in a VM scale set. Shuts down the virtual machine and releases the compute resources it uses. You are not billed for the compute resources of this virtual machine once it is deallocated.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_565051 = newJObject()
  var query_565052 = newJObject()
  add(query_565052, "api-version", newJString(apiVersion))
  add(path_565051, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_565051, "subscriptionId", newJString(subscriptionId))
  add(path_565051, "resourceGroupName", newJString(resourceGroupName))
  add(path_565051, "instanceId", newJString(instanceId))
  result = call_565050.call(path_565051, query_565052, nil, nil, nil)

var virtualMachineScaleSetVMsDeallocate* = Call_VirtualMachineScaleSetVMsDeallocate_565041(
    name: "virtualMachineScaleSetVMsDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/deallocate",
    validator: validate_VirtualMachineScaleSetVMsDeallocate_565042, base: "",
    url: url_VirtualMachineScaleSetVMsDeallocate_565043, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsGetInstanceView_565053 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsGetInstanceView_565055(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/instanceView")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsGetInstanceView_565054(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of a virtual machine from a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_565056 = path.getOrDefault("vmScaleSetName")
  valid_565056 = validateParameter(valid_565056, JString, required = true,
                                 default = nil)
  if valid_565056 != nil:
    section.add "vmScaleSetName", valid_565056
  var valid_565057 = path.getOrDefault("subscriptionId")
  valid_565057 = validateParameter(valid_565057, JString, required = true,
                                 default = nil)
  if valid_565057 != nil:
    section.add "subscriptionId", valid_565057
  var valid_565058 = path.getOrDefault("resourceGroupName")
  valid_565058 = validateParameter(valid_565058, JString, required = true,
                                 default = nil)
  if valid_565058 != nil:
    section.add "resourceGroupName", valid_565058
  var valid_565059 = path.getOrDefault("instanceId")
  valid_565059 = validateParameter(valid_565059, JString, required = true,
                                 default = nil)
  if valid_565059 != nil:
    section.add "instanceId", valid_565059
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565060 = query.getOrDefault("api-version")
  valid_565060 = validateParameter(valid_565060, JString, required = true,
                                 default = nil)
  if valid_565060 != nil:
    section.add "api-version", valid_565060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565061: Call_VirtualMachineScaleSetVMsGetInstanceView_565053;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of a virtual machine from a VM scale set.
  ## 
  let valid = call_565061.validator(path, query, header, formData, body)
  let scheme = call_565061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565061.url(scheme.get, call_565061.host, call_565061.base,
                         call_565061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565061, url, valid)

proc call*(call_565062: Call_VirtualMachineScaleSetVMsGetInstanceView_565053;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsGetInstanceView
  ## Gets the status of a virtual machine from a VM scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_565063 = newJObject()
  var query_565064 = newJObject()
  add(query_565064, "api-version", newJString(apiVersion))
  add(path_565063, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_565063, "subscriptionId", newJString(subscriptionId))
  add(path_565063, "resourceGroupName", newJString(resourceGroupName))
  add(path_565063, "instanceId", newJString(instanceId))
  result = call_565062.call(path_565063, query_565064, nil, nil, nil)

var virtualMachineScaleSetVMsGetInstanceView* = Call_VirtualMachineScaleSetVMsGetInstanceView_565053(
    name: "virtualMachineScaleSetVMsGetInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/instanceView",
    validator: validate_VirtualMachineScaleSetVMsGetInstanceView_565054, base: "",
    url: url_VirtualMachineScaleSetVMsGetInstanceView_565055,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsPerformMaintenance_565065 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsPerformMaintenance_565067(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/performMaintenance")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsPerformMaintenance_565066(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Performs maintenance on a virtual machine in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_565068 = path.getOrDefault("vmScaleSetName")
  valid_565068 = validateParameter(valid_565068, JString, required = true,
                                 default = nil)
  if valid_565068 != nil:
    section.add "vmScaleSetName", valid_565068
  var valid_565069 = path.getOrDefault("subscriptionId")
  valid_565069 = validateParameter(valid_565069, JString, required = true,
                                 default = nil)
  if valid_565069 != nil:
    section.add "subscriptionId", valid_565069
  var valid_565070 = path.getOrDefault("resourceGroupName")
  valid_565070 = validateParameter(valid_565070, JString, required = true,
                                 default = nil)
  if valid_565070 != nil:
    section.add "resourceGroupName", valid_565070
  var valid_565071 = path.getOrDefault("instanceId")
  valid_565071 = validateParameter(valid_565071, JString, required = true,
                                 default = nil)
  if valid_565071 != nil:
    section.add "instanceId", valid_565071
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565072 = query.getOrDefault("api-version")
  valid_565072 = validateParameter(valid_565072, JString, required = true,
                                 default = nil)
  if valid_565072 != nil:
    section.add "api-version", valid_565072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565073: Call_VirtualMachineScaleSetVMsPerformMaintenance_565065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Performs maintenance on a virtual machine in a VM scale set.
  ## 
  let valid = call_565073.validator(path, query, header, formData, body)
  let scheme = call_565073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565073.url(scheme.get, call_565073.host, call_565073.base,
                         call_565073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565073, url, valid)

proc call*(call_565074: Call_VirtualMachineScaleSetVMsPerformMaintenance_565065;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsPerformMaintenance
  ## Performs maintenance on a virtual machine in a VM scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_565075 = newJObject()
  var query_565076 = newJObject()
  add(query_565076, "api-version", newJString(apiVersion))
  add(path_565075, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_565075, "subscriptionId", newJString(subscriptionId))
  add(path_565075, "resourceGroupName", newJString(resourceGroupName))
  add(path_565075, "instanceId", newJString(instanceId))
  result = call_565074.call(path_565075, query_565076, nil, nil, nil)

var virtualMachineScaleSetVMsPerformMaintenance* = Call_VirtualMachineScaleSetVMsPerformMaintenance_565065(
    name: "virtualMachineScaleSetVMsPerformMaintenance",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/performMaintenance",
    validator: validate_VirtualMachineScaleSetVMsPerformMaintenance_565066,
    base: "", url: url_VirtualMachineScaleSetVMsPerformMaintenance_565067,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsPowerOff_565077 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsPowerOff_565079(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/poweroff")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsPowerOff_565078(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Power off (stop) a virtual machine in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_565080 = path.getOrDefault("vmScaleSetName")
  valid_565080 = validateParameter(valid_565080, JString, required = true,
                                 default = nil)
  if valid_565080 != nil:
    section.add "vmScaleSetName", valid_565080
  var valid_565081 = path.getOrDefault("subscriptionId")
  valid_565081 = validateParameter(valid_565081, JString, required = true,
                                 default = nil)
  if valid_565081 != nil:
    section.add "subscriptionId", valid_565081
  var valid_565082 = path.getOrDefault("resourceGroupName")
  valid_565082 = validateParameter(valid_565082, JString, required = true,
                                 default = nil)
  if valid_565082 != nil:
    section.add "resourceGroupName", valid_565082
  var valid_565083 = path.getOrDefault("instanceId")
  valid_565083 = validateParameter(valid_565083, JString, required = true,
                                 default = nil)
  if valid_565083 != nil:
    section.add "instanceId", valid_565083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   skipShutdown: JBool
  ##               : The parameter to request non-graceful VM shutdown. True value for this flag indicates non-graceful shutdown whereas false indicates otherwise. Default value for this flag is false if not specified
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565084 = query.getOrDefault("api-version")
  valid_565084 = validateParameter(valid_565084, JString, required = true,
                                 default = nil)
  if valid_565084 != nil:
    section.add "api-version", valid_565084
  var valid_565085 = query.getOrDefault("skipShutdown")
  valid_565085 = validateParameter(valid_565085, JBool, required = false,
                                 default = newJBool(false))
  if valid_565085 != nil:
    section.add "skipShutdown", valid_565085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565086: Call_VirtualMachineScaleSetVMsPowerOff_565077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Power off (stop) a virtual machine in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  let valid = call_565086.validator(path, query, header, formData, body)
  let scheme = call_565086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565086.url(scheme.get, call_565086.host, call_565086.base,
                         call_565086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565086, url, valid)

proc call*(call_565087: Call_VirtualMachineScaleSetVMsPowerOff_565077;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; instanceId: string; skipShutdown: bool = false): Recallable =
  ## virtualMachineScaleSetVMsPowerOff
  ## Power off (stop) a virtual machine in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   skipShutdown: bool
  ##               : The parameter to request non-graceful VM shutdown. True value for this flag indicates non-graceful shutdown whereas false indicates otherwise. Default value for this flag is false if not specified
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_565088 = newJObject()
  var query_565089 = newJObject()
  add(query_565089, "api-version", newJString(apiVersion))
  add(path_565088, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_565088, "subscriptionId", newJString(subscriptionId))
  add(path_565088, "resourceGroupName", newJString(resourceGroupName))
  add(query_565089, "skipShutdown", newJBool(skipShutdown))
  add(path_565088, "instanceId", newJString(instanceId))
  result = call_565087.call(path_565088, query_565089, nil, nil, nil)

var virtualMachineScaleSetVMsPowerOff* = Call_VirtualMachineScaleSetVMsPowerOff_565077(
    name: "virtualMachineScaleSetVMsPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/poweroff",
    validator: validate_VirtualMachineScaleSetVMsPowerOff_565078, base: "",
    url: url_VirtualMachineScaleSetVMsPowerOff_565079, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsRedeploy_565090 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsRedeploy_565092(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/redeploy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsRedeploy_565091(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shuts down the virtual machine in the virtual machine scale set, moves it to a new node, and powers it back on.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_565093 = path.getOrDefault("vmScaleSetName")
  valid_565093 = validateParameter(valid_565093, JString, required = true,
                                 default = nil)
  if valid_565093 != nil:
    section.add "vmScaleSetName", valid_565093
  var valid_565094 = path.getOrDefault("subscriptionId")
  valid_565094 = validateParameter(valid_565094, JString, required = true,
                                 default = nil)
  if valid_565094 != nil:
    section.add "subscriptionId", valid_565094
  var valid_565095 = path.getOrDefault("resourceGroupName")
  valid_565095 = validateParameter(valid_565095, JString, required = true,
                                 default = nil)
  if valid_565095 != nil:
    section.add "resourceGroupName", valid_565095
  var valid_565096 = path.getOrDefault("instanceId")
  valid_565096 = validateParameter(valid_565096, JString, required = true,
                                 default = nil)
  if valid_565096 != nil:
    section.add "instanceId", valid_565096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565097 = query.getOrDefault("api-version")
  valid_565097 = validateParameter(valid_565097, JString, required = true,
                                 default = nil)
  if valid_565097 != nil:
    section.add "api-version", valid_565097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565098: Call_VirtualMachineScaleSetVMsRedeploy_565090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Shuts down the virtual machine in the virtual machine scale set, moves it to a new node, and powers it back on.
  ## 
  let valid = call_565098.validator(path, query, header, formData, body)
  let scheme = call_565098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565098.url(scheme.get, call_565098.host, call_565098.base,
                         call_565098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565098, url, valid)

proc call*(call_565099: Call_VirtualMachineScaleSetVMsRedeploy_565090;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsRedeploy
  ## Shuts down the virtual machine in the virtual machine scale set, moves it to a new node, and powers it back on.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_565100 = newJObject()
  var query_565101 = newJObject()
  add(query_565101, "api-version", newJString(apiVersion))
  add(path_565100, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_565100, "subscriptionId", newJString(subscriptionId))
  add(path_565100, "resourceGroupName", newJString(resourceGroupName))
  add(path_565100, "instanceId", newJString(instanceId))
  result = call_565099.call(path_565100, query_565101, nil, nil, nil)

var virtualMachineScaleSetVMsRedeploy* = Call_VirtualMachineScaleSetVMsRedeploy_565090(
    name: "virtualMachineScaleSetVMsRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/redeploy",
    validator: validate_VirtualMachineScaleSetVMsRedeploy_565091, base: "",
    url: url_VirtualMachineScaleSetVMsRedeploy_565092, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsReimage_565102 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsReimage_565104(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/reimage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsReimage_565103(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reimages (upgrade the operating system) a specific virtual machine in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_565105 = path.getOrDefault("vmScaleSetName")
  valid_565105 = validateParameter(valid_565105, JString, required = true,
                                 default = nil)
  if valid_565105 != nil:
    section.add "vmScaleSetName", valid_565105
  var valid_565106 = path.getOrDefault("subscriptionId")
  valid_565106 = validateParameter(valid_565106, JString, required = true,
                                 default = nil)
  if valid_565106 != nil:
    section.add "subscriptionId", valid_565106
  var valid_565107 = path.getOrDefault("resourceGroupName")
  valid_565107 = validateParameter(valid_565107, JString, required = true,
                                 default = nil)
  if valid_565107 != nil:
    section.add "resourceGroupName", valid_565107
  var valid_565108 = path.getOrDefault("instanceId")
  valid_565108 = validateParameter(valid_565108, JString, required = true,
                                 default = nil)
  if valid_565108 != nil:
    section.add "instanceId", valid_565108
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565109 = query.getOrDefault("api-version")
  valid_565109 = validateParameter(valid_565109, JString, required = true,
                                 default = nil)
  if valid_565109 != nil:
    section.add "api-version", valid_565109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   vmScaleSetVMReimageInput: JObject
  ##                           : Parameters for the Reimaging Virtual machine in ScaleSet.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565111: Call_VirtualMachineScaleSetVMsReimage_565102;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reimages (upgrade the operating system) a specific virtual machine in a VM scale set.
  ## 
  let valid = call_565111.validator(path, query, header, formData, body)
  let scheme = call_565111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565111.url(scheme.get, call_565111.host, call_565111.base,
                         call_565111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565111, url, valid)

proc call*(call_565112: Call_VirtualMachineScaleSetVMsReimage_565102;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; instanceId: string;
          vmScaleSetVMReimageInput: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetVMsReimage
  ## Reimages (upgrade the operating system) a specific virtual machine in a VM scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  ##   vmScaleSetVMReimageInput: JObject
  ##                           : Parameters for the Reimaging Virtual machine in ScaleSet.
  var path_565113 = newJObject()
  var query_565114 = newJObject()
  var body_565115 = newJObject()
  add(query_565114, "api-version", newJString(apiVersion))
  add(path_565113, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_565113, "subscriptionId", newJString(subscriptionId))
  add(path_565113, "resourceGroupName", newJString(resourceGroupName))
  add(path_565113, "instanceId", newJString(instanceId))
  if vmScaleSetVMReimageInput != nil:
    body_565115 = vmScaleSetVMReimageInput
  result = call_565112.call(path_565113, query_565114, nil, nil, body_565115)

var virtualMachineScaleSetVMsReimage* = Call_VirtualMachineScaleSetVMsReimage_565102(
    name: "virtualMachineScaleSetVMsReimage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/reimage",
    validator: validate_VirtualMachineScaleSetVMsReimage_565103, base: "",
    url: url_VirtualMachineScaleSetVMsReimage_565104, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsReimageAll_565116 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsReimageAll_565118(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/reimageall")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsReimageAll_565117(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows you to re-image all the disks ( including data disks ) in the a VM scale set instance. This operation is only supported for managed disks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_565119 = path.getOrDefault("vmScaleSetName")
  valid_565119 = validateParameter(valid_565119, JString, required = true,
                                 default = nil)
  if valid_565119 != nil:
    section.add "vmScaleSetName", valid_565119
  var valid_565120 = path.getOrDefault("subscriptionId")
  valid_565120 = validateParameter(valid_565120, JString, required = true,
                                 default = nil)
  if valid_565120 != nil:
    section.add "subscriptionId", valid_565120
  var valid_565121 = path.getOrDefault("resourceGroupName")
  valid_565121 = validateParameter(valid_565121, JString, required = true,
                                 default = nil)
  if valid_565121 != nil:
    section.add "resourceGroupName", valid_565121
  var valid_565122 = path.getOrDefault("instanceId")
  valid_565122 = validateParameter(valid_565122, JString, required = true,
                                 default = nil)
  if valid_565122 != nil:
    section.add "instanceId", valid_565122
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565123 = query.getOrDefault("api-version")
  valid_565123 = validateParameter(valid_565123, JString, required = true,
                                 default = nil)
  if valid_565123 != nil:
    section.add "api-version", valid_565123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565124: Call_VirtualMachineScaleSetVMsReimageAll_565116;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Allows you to re-image all the disks ( including data disks ) in the a VM scale set instance. This operation is only supported for managed disks.
  ## 
  let valid = call_565124.validator(path, query, header, formData, body)
  let scheme = call_565124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565124.url(scheme.get, call_565124.host, call_565124.base,
                         call_565124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565124, url, valid)

proc call*(call_565125: Call_VirtualMachineScaleSetVMsReimageAll_565116;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsReimageAll
  ## Allows you to re-image all the disks ( including data disks ) in the a VM scale set instance. This operation is only supported for managed disks.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_565126 = newJObject()
  var query_565127 = newJObject()
  add(query_565127, "api-version", newJString(apiVersion))
  add(path_565126, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_565126, "subscriptionId", newJString(subscriptionId))
  add(path_565126, "resourceGroupName", newJString(resourceGroupName))
  add(path_565126, "instanceId", newJString(instanceId))
  result = call_565125.call(path_565126, query_565127, nil, nil, nil)

var virtualMachineScaleSetVMsReimageAll* = Call_VirtualMachineScaleSetVMsReimageAll_565116(
    name: "virtualMachineScaleSetVMsReimageAll", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/reimageall",
    validator: validate_VirtualMachineScaleSetVMsReimageAll_565117, base: "",
    url: url_VirtualMachineScaleSetVMsReimageAll_565118, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsRestart_565128 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsRestart_565130(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsRestart_565129(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restarts a virtual machine in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_565131 = path.getOrDefault("vmScaleSetName")
  valid_565131 = validateParameter(valid_565131, JString, required = true,
                                 default = nil)
  if valid_565131 != nil:
    section.add "vmScaleSetName", valid_565131
  var valid_565132 = path.getOrDefault("subscriptionId")
  valid_565132 = validateParameter(valid_565132, JString, required = true,
                                 default = nil)
  if valid_565132 != nil:
    section.add "subscriptionId", valid_565132
  var valid_565133 = path.getOrDefault("resourceGroupName")
  valid_565133 = validateParameter(valid_565133, JString, required = true,
                                 default = nil)
  if valid_565133 != nil:
    section.add "resourceGroupName", valid_565133
  var valid_565134 = path.getOrDefault("instanceId")
  valid_565134 = validateParameter(valid_565134, JString, required = true,
                                 default = nil)
  if valid_565134 != nil:
    section.add "instanceId", valid_565134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565135 = query.getOrDefault("api-version")
  valid_565135 = validateParameter(valid_565135, JString, required = true,
                                 default = nil)
  if valid_565135 != nil:
    section.add "api-version", valid_565135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565136: Call_VirtualMachineScaleSetVMsRestart_565128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Restarts a virtual machine in a VM scale set.
  ## 
  let valid = call_565136.validator(path, query, header, formData, body)
  let scheme = call_565136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565136.url(scheme.get, call_565136.host, call_565136.base,
                         call_565136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565136, url, valid)

proc call*(call_565137: Call_VirtualMachineScaleSetVMsRestart_565128;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsRestart
  ## Restarts a virtual machine in a VM scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_565138 = newJObject()
  var query_565139 = newJObject()
  add(query_565139, "api-version", newJString(apiVersion))
  add(path_565138, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_565138, "subscriptionId", newJString(subscriptionId))
  add(path_565138, "resourceGroupName", newJString(resourceGroupName))
  add(path_565138, "instanceId", newJString(instanceId))
  result = call_565137.call(path_565138, query_565139, nil, nil, nil)

var virtualMachineScaleSetVMsRestart* = Call_VirtualMachineScaleSetVMsRestart_565128(
    name: "virtualMachineScaleSetVMsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/restart",
    validator: validate_VirtualMachineScaleSetVMsRestart_565129, base: "",
    url: url_VirtualMachineScaleSetVMsRestart_565130, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsStart_565140 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsStart_565142(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmScaleSetName" in path, "`vmScaleSetName` is a required path parameter"
  assert "instanceId" in path, "`instanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "vmScaleSetName"),
               (kind: ConstantSegment, value: "/virtualmachines/"),
               (kind: VariableSegment, value: "instanceId"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineScaleSetVMsStart_565141(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a virtual machine in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_565143 = path.getOrDefault("vmScaleSetName")
  valid_565143 = validateParameter(valid_565143, JString, required = true,
                                 default = nil)
  if valid_565143 != nil:
    section.add "vmScaleSetName", valid_565143
  var valid_565144 = path.getOrDefault("subscriptionId")
  valid_565144 = validateParameter(valid_565144, JString, required = true,
                                 default = nil)
  if valid_565144 != nil:
    section.add "subscriptionId", valid_565144
  var valid_565145 = path.getOrDefault("resourceGroupName")
  valid_565145 = validateParameter(valid_565145, JString, required = true,
                                 default = nil)
  if valid_565145 != nil:
    section.add "resourceGroupName", valid_565145
  var valid_565146 = path.getOrDefault("instanceId")
  valid_565146 = validateParameter(valid_565146, JString, required = true,
                                 default = nil)
  if valid_565146 != nil:
    section.add "instanceId", valid_565146
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565147 = query.getOrDefault("api-version")
  valid_565147 = validateParameter(valid_565147, JString, required = true,
                                 default = nil)
  if valid_565147 != nil:
    section.add "api-version", valid_565147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565148: Call_VirtualMachineScaleSetVMsStart_565140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a virtual machine in a VM scale set.
  ## 
  let valid = call_565148.validator(path, query, header, formData, body)
  let scheme = call_565148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565148.url(scheme.get, call_565148.host, call_565148.base,
                         call_565148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565148, url, valid)

proc call*(call_565149: Call_VirtualMachineScaleSetVMsStart_565140;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsStart
  ## Starts a virtual machine in a VM scale set.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_565150 = newJObject()
  var query_565151 = newJObject()
  add(query_565151, "api-version", newJString(apiVersion))
  add(path_565150, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_565150, "subscriptionId", newJString(subscriptionId))
  add(path_565150, "resourceGroupName", newJString(resourceGroupName))
  add(path_565150, "instanceId", newJString(instanceId))
  result = call_565149.call(path_565150, query_565151, nil, nil, nil)

var virtualMachineScaleSetVMsStart* = Call_VirtualMachineScaleSetVMsStart_565140(
    name: "virtualMachineScaleSetVMsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/start",
    validator: validate_VirtualMachineScaleSetVMsStart_565141, base: "",
    url: url_VirtualMachineScaleSetVMsStart_565142, schemes: {Scheme.Https})
type
  Call_VirtualMachinesList_565152 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesList_565154(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesList_565153(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists all of the virtual machines in the specified resource group. Use the nextLink property in the response to get the next page of virtual machines.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565155 = path.getOrDefault("subscriptionId")
  valid_565155 = validateParameter(valid_565155, JString, required = true,
                                 default = nil)
  if valid_565155 != nil:
    section.add "subscriptionId", valid_565155
  var valid_565156 = path.getOrDefault("resourceGroupName")
  valid_565156 = validateParameter(valid_565156, JString, required = true,
                                 default = nil)
  if valid_565156 != nil:
    section.add "resourceGroupName", valid_565156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565157 = query.getOrDefault("api-version")
  valid_565157 = validateParameter(valid_565157, JString, required = true,
                                 default = nil)
  if valid_565157 != nil:
    section.add "api-version", valid_565157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565158: Call_VirtualMachinesList_565152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the virtual machines in the specified resource group. Use the nextLink property in the response to get the next page of virtual machines.
  ## 
  let valid = call_565158.validator(path, query, header, formData, body)
  let scheme = call_565158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565158.url(scheme.get, call_565158.host, call_565158.base,
                         call_565158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565158, url, valid)

proc call*(call_565159: Call_VirtualMachinesList_565152; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualMachinesList
  ## Lists all of the virtual machines in the specified resource group. Use the nextLink property in the response to get the next page of virtual machines.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_565160 = newJObject()
  var query_565161 = newJObject()
  add(query_565161, "api-version", newJString(apiVersion))
  add(path_565160, "subscriptionId", newJString(subscriptionId))
  add(path_565160, "resourceGroupName", newJString(resourceGroupName))
  result = call_565159.call(path_565160, query_565161, nil, nil, nil)

var virtualMachinesList* = Call_VirtualMachinesList_565152(
    name: "virtualMachinesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines",
    validator: validate_VirtualMachinesList_565153, base: "",
    url: url_VirtualMachinesList_565154, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCreateOrUpdate_565174 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesCreateOrUpdate_565176(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesCreateOrUpdate_565175(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565177 = path.getOrDefault("subscriptionId")
  valid_565177 = validateParameter(valid_565177, JString, required = true,
                                 default = nil)
  if valid_565177 != nil:
    section.add "subscriptionId", valid_565177
  var valid_565178 = path.getOrDefault("resourceGroupName")
  valid_565178 = validateParameter(valid_565178, JString, required = true,
                                 default = nil)
  if valid_565178 != nil:
    section.add "resourceGroupName", valid_565178
  var valid_565179 = path.getOrDefault("vmName")
  valid_565179 = validateParameter(valid_565179, JString, required = true,
                                 default = nil)
  if valid_565179 != nil:
    section.add "vmName", valid_565179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565180 = query.getOrDefault("api-version")
  valid_565180 = validateParameter(valid_565180, JString, required = true,
                                 default = nil)
  if valid_565180 != nil:
    section.add "api-version", valid_565180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Virtual Machine operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565182: Call_VirtualMachinesCreateOrUpdate_565174; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a virtual machine.
  ## 
  let valid = call_565182.validator(path, query, header, formData, body)
  let scheme = call_565182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565182.url(scheme.get, call_565182.host, call_565182.base,
                         call_565182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565182, url, valid)

proc call*(call_565183: Call_VirtualMachinesCreateOrUpdate_565174;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode; vmName: string): Recallable =
  ## virtualMachinesCreateOrUpdate
  ## The operation to create or update a virtual machine.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Virtual Machine operation.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_565184 = newJObject()
  var query_565185 = newJObject()
  var body_565186 = newJObject()
  add(query_565185, "api-version", newJString(apiVersion))
  add(path_565184, "subscriptionId", newJString(subscriptionId))
  add(path_565184, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_565186 = parameters
  add(path_565184, "vmName", newJString(vmName))
  result = call_565183.call(path_565184, query_565185, nil, nil, body_565186)

var virtualMachinesCreateOrUpdate* = Call_VirtualMachinesCreateOrUpdate_565174(
    name: "virtualMachinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesCreateOrUpdate_565175, base: "",
    url: url_VirtualMachinesCreateOrUpdate_565176, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGet_565162 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesGet_565164(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesGet_565163(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves information about the model view or the instance view of a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565165 = path.getOrDefault("subscriptionId")
  valid_565165 = validateParameter(valid_565165, JString, required = true,
                                 default = nil)
  if valid_565165 != nil:
    section.add "subscriptionId", valid_565165
  var valid_565166 = path.getOrDefault("resourceGroupName")
  valid_565166 = validateParameter(valid_565166, JString, required = true,
                                 default = nil)
  if valid_565166 != nil:
    section.add "resourceGroupName", valid_565166
  var valid_565167 = path.getOrDefault("vmName")
  valid_565167 = validateParameter(valid_565167, JString, required = true,
                                 default = nil)
  if valid_565167 != nil:
    section.add "vmName", valid_565167
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565168 = query.getOrDefault("api-version")
  valid_565168 = validateParameter(valid_565168, JString, required = true,
                                 default = nil)
  if valid_565168 != nil:
    section.add "api-version", valid_565168
  var valid_565169 = query.getOrDefault("$expand")
  valid_565169 = validateParameter(valid_565169, JString, required = false,
                                 default = newJString("instanceView"))
  if valid_565169 != nil:
    section.add "$expand", valid_565169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565170: Call_VirtualMachinesGet_565162; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the model view or the instance view of a virtual machine.
  ## 
  let valid = call_565170.validator(path, query, header, formData, body)
  let scheme = call_565170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565170.url(scheme.get, call_565170.host, call_565170.base,
                         call_565170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565170, url, valid)

proc call*(call_565171: Call_VirtualMachinesGet_565162; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; vmName: string;
          Expand: string = "instanceView"): Recallable =
  ## virtualMachinesGet
  ## Retrieves information about the model view or the instance view of a virtual machine.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_565172 = newJObject()
  var query_565173 = newJObject()
  add(query_565173, "api-version", newJString(apiVersion))
  add(query_565173, "$expand", newJString(Expand))
  add(path_565172, "subscriptionId", newJString(subscriptionId))
  add(path_565172, "resourceGroupName", newJString(resourceGroupName))
  add(path_565172, "vmName", newJString(vmName))
  result = call_565171.call(path_565172, query_565173, nil, nil, nil)

var virtualMachinesGet* = Call_VirtualMachinesGet_565162(
    name: "virtualMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesGet_565163, base: "",
    url: url_VirtualMachinesGet_565164, schemes: {Scheme.Https})
type
  Call_VirtualMachinesUpdate_565198 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesUpdate_565200(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesUpdate_565199(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565201 = path.getOrDefault("subscriptionId")
  valid_565201 = validateParameter(valid_565201, JString, required = true,
                                 default = nil)
  if valid_565201 != nil:
    section.add "subscriptionId", valid_565201
  var valid_565202 = path.getOrDefault("resourceGroupName")
  valid_565202 = validateParameter(valid_565202, JString, required = true,
                                 default = nil)
  if valid_565202 != nil:
    section.add "resourceGroupName", valid_565202
  var valid_565203 = path.getOrDefault("vmName")
  valid_565203 = validateParameter(valid_565203, JString, required = true,
                                 default = nil)
  if valid_565203 != nil:
    section.add "vmName", valid_565203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565204 = query.getOrDefault("api-version")
  valid_565204 = validateParameter(valid_565204, JString, required = true,
                                 default = nil)
  if valid_565204 != nil:
    section.add "api-version", valid_565204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Virtual Machine operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565206: Call_VirtualMachinesUpdate_565198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a virtual machine.
  ## 
  let valid = call_565206.validator(path, query, header, formData, body)
  let scheme = call_565206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565206.url(scheme.get, call_565206.host, call_565206.base,
                         call_565206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565206, url, valid)

proc call*(call_565207: Call_VirtualMachinesUpdate_565198; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode;
          vmName: string): Recallable =
  ## virtualMachinesUpdate
  ## The operation to update a virtual machine.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Virtual Machine operation.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_565208 = newJObject()
  var query_565209 = newJObject()
  var body_565210 = newJObject()
  add(query_565209, "api-version", newJString(apiVersion))
  add(path_565208, "subscriptionId", newJString(subscriptionId))
  add(path_565208, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_565210 = parameters
  add(path_565208, "vmName", newJString(vmName))
  result = call_565207.call(path_565208, query_565209, nil, nil, body_565210)

var virtualMachinesUpdate* = Call_VirtualMachinesUpdate_565198(
    name: "virtualMachinesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesUpdate_565199, base: "",
    url: url_VirtualMachinesUpdate_565200, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDelete_565187 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesDelete_565189(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesDelete_565188(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565190 = path.getOrDefault("subscriptionId")
  valid_565190 = validateParameter(valid_565190, JString, required = true,
                                 default = nil)
  if valid_565190 != nil:
    section.add "subscriptionId", valid_565190
  var valid_565191 = path.getOrDefault("resourceGroupName")
  valid_565191 = validateParameter(valid_565191, JString, required = true,
                                 default = nil)
  if valid_565191 != nil:
    section.add "resourceGroupName", valid_565191
  var valid_565192 = path.getOrDefault("vmName")
  valid_565192 = validateParameter(valid_565192, JString, required = true,
                                 default = nil)
  if valid_565192 != nil:
    section.add "vmName", valid_565192
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565193 = query.getOrDefault("api-version")
  valid_565193 = validateParameter(valid_565193, JString, required = true,
                                 default = nil)
  if valid_565193 != nil:
    section.add "api-version", valid_565193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565194: Call_VirtualMachinesDelete_565187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a virtual machine.
  ## 
  let valid = call_565194.validator(path, query, header, formData, body)
  let scheme = call_565194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565194.url(scheme.get, call_565194.host, call_565194.base,
                         call_565194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565194, url, valid)

proc call*(call_565195: Call_VirtualMachinesDelete_565187; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; vmName: string): Recallable =
  ## virtualMachinesDelete
  ## The operation to delete a virtual machine.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_565196 = newJObject()
  var query_565197 = newJObject()
  add(query_565197, "api-version", newJString(apiVersion))
  add(path_565196, "subscriptionId", newJString(subscriptionId))
  add(path_565196, "resourceGroupName", newJString(resourceGroupName))
  add(path_565196, "vmName", newJString(vmName))
  result = call_565195.call(path_565196, query_565197, nil, nil, nil)

var virtualMachinesDelete* = Call_VirtualMachinesDelete_565187(
    name: "virtualMachinesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesDelete_565188, base: "",
    url: url_VirtualMachinesDelete_565189, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCapture_565211 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesCapture_565213(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/capture")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesCapture_565212(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Captures the VM by copying virtual hard disks of the VM and outputs a template that can be used to create similar VMs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565214 = path.getOrDefault("subscriptionId")
  valid_565214 = validateParameter(valid_565214, JString, required = true,
                                 default = nil)
  if valid_565214 != nil:
    section.add "subscriptionId", valid_565214
  var valid_565215 = path.getOrDefault("resourceGroupName")
  valid_565215 = validateParameter(valid_565215, JString, required = true,
                                 default = nil)
  if valid_565215 != nil:
    section.add "resourceGroupName", valid_565215
  var valid_565216 = path.getOrDefault("vmName")
  valid_565216 = validateParameter(valid_565216, JString, required = true,
                                 default = nil)
  if valid_565216 != nil:
    section.add "vmName", valid_565216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565217 = query.getOrDefault("api-version")
  valid_565217 = validateParameter(valid_565217, JString, required = true,
                                 default = nil)
  if valid_565217 != nil:
    section.add "api-version", valid_565217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Capture Virtual Machine operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565219: Call_VirtualMachinesCapture_565211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Captures the VM by copying virtual hard disks of the VM and outputs a template that can be used to create similar VMs.
  ## 
  let valid = call_565219.validator(path, query, header, formData, body)
  let scheme = call_565219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565219.url(scheme.get, call_565219.host, call_565219.base,
                         call_565219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565219, url, valid)

proc call*(call_565220: Call_VirtualMachinesCapture_565211; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; parameters: JsonNode;
          vmName: string): Recallable =
  ## virtualMachinesCapture
  ## Captures the VM by copying virtual hard disks of the VM and outputs a template that can be used to create similar VMs.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Capture Virtual Machine operation.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_565221 = newJObject()
  var query_565222 = newJObject()
  var body_565223 = newJObject()
  add(query_565222, "api-version", newJString(apiVersion))
  add(path_565221, "subscriptionId", newJString(subscriptionId))
  add(path_565221, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_565223 = parameters
  add(path_565221, "vmName", newJString(vmName))
  result = call_565220.call(path_565221, query_565222, nil, nil, body_565223)

var virtualMachinesCapture* = Call_VirtualMachinesCapture_565211(
    name: "virtualMachinesCapture", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/capture",
    validator: validate_VirtualMachinesCapture_565212, base: "",
    url: url_VirtualMachinesCapture_565213, schemes: {Scheme.Https})
type
  Call_VirtualMachinesConvertToManagedDisks_565224 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesConvertToManagedDisks_565226(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/convertToManagedDisks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesConvertToManagedDisks_565225(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Converts virtual machine disks from blob-based to managed disks. Virtual machine must be stop-deallocated before invoking this operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565227 = path.getOrDefault("subscriptionId")
  valid_565227 = validateParameter(valid_565227, JString, required = true,
                                 default = nil)
  if valid_565227 != nil:
    section.add "subscriptionId", valid_565227
  var valid_565228 = path.getOrDefault("resourceGroupName")
  valid_565228 = validateParameter(valid_565228, JString, required = true,
                                 default = nil)
  if valid_565228 != nil:
    section.add "resourceGroupName", valid_565228
  var valid_565229 = path.getOrDefault("vmName")
  valid_565229 = validateParameter(valid_565229, JString, required = true,
                                 default = nil)
  if valid_565229 != nil:
    section.add "vmName", valid_565229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565230 = query.getOrDefault("api-version")
  valid_565230 = validateParameter(valid_565230, JString, required = true,
                                 default = nil)
  if valid_565230 != nil:
    section.add "api-version", valid_565230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565231: Call_VirtualMachinesConvertToManagedDisks_565224;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Converts virtual machine disks from blob-based to managed disks. Virtual machine must be stop-deallocated before invoking this operation.
  ## 
  let valid = call_565231.validator(path, query, header, formData, body)
  let scheme = call_565231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565231.url(scheme.get, call_565231.host, call_565231.base,
                         call_565231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565231, url, valid)

proc call*(call_565232: Call_VirtualMachinesConvertToManagedDisks_565224;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          vmName: string): Recallable =
  ## virtualMachinesConvertToManagedDisks
  ## Converts virtual machine disks from blob-based to managed disks. Virtual machine must be stop-deallocated before invoking this operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_565233 = newJObject()
  var query_565234 = newJObject()
  add(query_565234, "api-version", newJString(apiVersion))
  add(path_565233, "subscriptionId", newJString(subscriptionId))
  add(path_565233, "resourceGroupName", newJString(resourceGroupName))
  add(path_565233, "vmName", newJString(vmName))
  result = call_565232.call(path_565233, query_565234, nil, nil, nil)

var virtualMachinesConvertToManagedDisks* = Call_VirtualMachinesConvertToManagedDisks_565224(
    name: "virtualMachinesConvertToManagedDisks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/convertToManagedDisks",
    validator: validate_VirtualMachinesConvertToManagedDisks_565225, base: "",
    url: url_VirtualMachinesConvertToManagedDisks_565226, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDeallocate_565235 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesDeallocate_565237(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/deallocate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesDeallocate_565236(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shuts down the virtual machine and releases the compute resources. You are not billed for the compute resources that this virtual machine uses.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565238 = path.getOrDefault("subscriptionId")
  valid_565238 = validateParameter(valid_565238, JString, required = true,
                                 default = nil)
  if valid_565238 != nil:
    section.add "subscriptionId", valid_565238
  var valid_565239 = path.getOrDefault("resourceGroupName")
  valid_565239 = validateParameter(valid_565239, JString, required = true,
                                 default = nil)
  if valid_565239 != nil:
    section.add "resourceGroupName", valid_565239
  var valid_565240 = path.getOrDefault("vmName")
  valid_565240 = validateParameter(valid_565240, JString, required = true,
                                 default = nil)
  if valid_565240 != nil:
    section.add "vmName", valid_565240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565241 = query.getOrDefault("api-version")
  valid_565241 = validateParameter(valid_565241, JString, required = true,
                                 default = nil)
  if valid_565241 != nil:
    section.add "api-version", valid_565241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565242: Call_VirtualMachinesDeallocate_565235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shuts down the virtual machine and releases the compute resources. You are not billed for the compute resources that this virtual machine uses.
  ## 
  let valid = call_565242.validator(path, query, header, formData, body)
  let scheme = call_565242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565242.url(scheme.get, call_565242.host, call_565242.base,
                         call_565242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565242, url, valid)

proc call*(call_565243: Call_VirtualMachinesDeallocate_565235; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; vmName: string): Recallable =
  ## virtualMachinesDeallocate
  ## Shuts down the virtual machine and releases the compute resources. You are not billed for the compute resources that this virtual machine uses.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_565244 = newJObject()
  var query_565245 = newJObject()
  add(query_565245, "api-version", newJString(apiVersion))
  add(path_565244, "subscriptionId", newJString(subscriptionId))
  add(path_565244, "resourceGroupName", newJString(resourceGroupName))
  add(path_565244, "vmName", newJString(vmName))
  result = call_565243.call(path_565244, query_565245, nil, nil, nil)

var virtualMachinesDeallocate* = Call_VirtualMachinesDeallocate_565235(
    name: "virtualMachinesDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/deallocate",
    validator: validate_VirtualMachinesDeallocate_565236, base: "",
    url: url_VirtualMachinesDeallocate_565237, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsList_565246 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineExtensionsList_565248(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/extensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineExtensionsList_565247(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to get all extensions of a Virtual Machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine containing the extension.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565249 = path.getOrDefault("subscriptionId")
  valid_565249 = validateParameter(valid_565249, JString, required = true,
                                 default = nil)
  if valid_565249 != nil:
    section.add "subscriptionId", valid_565249
  var valid_565250 = path.getOrDefault("resourceGroupName")
  valid_565250 = validateParameter(valid_565250, JString, required = true,
                                 default = nil)
  if valid_565250 != nil:
    section.add "resourceGroupName", valid_565250
  var valid_565251 = path.getOrDefault("vmName")
  valid_565251 = validateParameter(valid_565251, JString, required = true,
                                 default = nil)
  if valid_565251 != nil:
    section.add "vmName", valid_565251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565252 = query.getOrDefault("api-version")
  valid_565252 = validateParameter(valid_565252, JString, required = true,
                                 default = nil)
  if valid_565252 != nil:
    section.add "api-version", valid_565252
  var valid_565253 = query.getOrDefault("$expand")
  valid_565253 = validateParameter(valid_565253, JString, required = false,
                                 default = nil)
  if valid_565253 != nil:
    section.add "$expand", valid_565253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565254: Call_VirtualMachineExtensionsList_565246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get all extensions of a Virtual Machine.
  ## 
  let valid = call_565254.validator(path, query, header, formData, body)
  let scheme = call_565254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565254.url(scheme.get, call_565254.host, call_565254.base,
                         call_565254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565254, url, valid)

proc call*(call_565255: Call_VirtualMachineExtensionsList_565246;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          vmName: string; Expand: string = ""): Recallable =
  ## virtualMachineExtensionsList
  ## The operation to get all extensions of a Virtual Machine.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmName: string (required)
  ##         : The name of the virtual machine containing the extension.
  var path_565256 = newJObject()
  var query_565257 = newJObject()
  add(query_565257, "api-version", newJString(apiVersion))
  add(query_565257, "$expand", newJString(Expand))
  add(path_565256, "subscriptionId", newJString(subscriptionId))
  add(path_565256, "resourceGroupName", newJString(resourceGroupName))
  add(path_565256, "vmName", newJString(vmName))
  result = call_565255.call(path_565256, query_565257, nil, nil, nil)

var virtualMachineExtensionsList* = Call_VirtualMachineExtensionsList_565246(
    name: "virtualMachineExtensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions",
    validator: validate_VirtualMachineExtensionsList_565247, base: "",
    url: url_VirtualMachineExtensionsList_565248, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsCreateOrUpdate_565271 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineExtensionsCreateOrUpdate_565273(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  assert "vmExtensionName" in path, "`vmExtensionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/extensions/"),
               (kind: VariableSegment, value: "vmExtensionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineExtensionsCreateOrUpdate_565272(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update the extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmExtensionName: JString (required)
  ##                  : The name of the virtual machine extension.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine where the extension should be created or updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565274 = path.getOrDefault("subscriptionId")
  valid_565274 = validateParameter(valid_565274, JString, required = true,
                                 default = nil)
  if valid_565274 != nil:
    section.add "subscriptionId", valid_565274
  var valid_565275 = path.getOrDefault("resourceGroupName")
  valid_565275 = validateParameter(valid_565275, JString, required = true,
                                 default = nil)
  if valid_565275 != nil:
    section.add "resourceGroupName", valid_565275
  var valid_565276 = path.getOrDefault("vmExtensionName")
  valid_565276 = validateParameter(valid_565276, JString, required = true,
                                 default = nil)
  if valid_565276 != nil:
    section.add "vmExtensionName", valid_565276
  var valid_565277 = path.getOrDefault("vmName")
  valid_565277 = validateParameter(valid_565277, JString, required = true,
                                 default = nil)
  if valid_565277 != nil:
    section.add "vmName", valid_565277
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565278 = query.getOrDefault("api-version")
  valid_565278 = validateParameter(valid_565278, JString, required = true,
                                 default = nil)
  if valid_565278 != nil:
    section.add "api-version", valid_565278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   extensionParameters: JObject (required)
  ##                      : Parameters supplied to the Create Virtual Machine Extension operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565280: Call_VirtualMachineExtensionsCreateOrUpdate_565271;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update the extension.
  ## 
  let valid = call_565280.validator(path, query, header, formData, body)
  let scheme = call_565280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565280.url(scheme.get, call_565280.host, call_565280.base,
                         call_565280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565280, url, valid)

proc call*(call_565281: Call_VirtualMachineExtensionsCreateOrUpdate_565271;
          apiVersion: string; extensionParameters: JsonNode; subscriptionId: string;
          resourceGroupName: string; vmExtensionName: string; vmName: string): Recallable =
  ## virtualMachineExtensionsCreateOrUpdate
  ## The operation to create or update the extension.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   extensionParameters: JObject (required)
  ##                      : Parameters supplied to the Create Virtual Machine Extension operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmExtensionName: string (required)
  ##                  : The name of the virtual machine extension.
  ##   vmName: string (required)
  ##         : The name of the virtual machine where the extension should be created or updated.
  var path_565282 = newJObject()
  var query_565283 = newJObject()
  var body_565284 = newJObject()
  add(query_565283, "api-version", newJString(apiVersion))
  if extensionParameters != nil:
    body_565284 = extensionParameters
  add(path_565282, "subscriptionId", newJString(subscriptionId))
  add(path_565282, "resourceGroupName", newJString(resourceGroupName))
  add(path_565282, "vmExtensionName", newJString(vmExtensionName))
  add(path_565282, "vmName", newJString(vmName))
  result = call_565281.call(path_565282, query_565283, nil, nil, body_565284)

var virtualMachineExtensionsCreateOrUpdate* = Call_VirtualMachineExtensionsCreateOrUpdate_565271(
    name: "virtualMachineExtensionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsCreateOrUpdate_565272, base: "",
    url: url_VirtualMachineExtensionsCreateOrUpdate_565273,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsGet_565258 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineExtensionsGet_565260(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  assert "vmExtensionName" in path, "`vmExtensionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/extensions/"),
               (kind: VariableSegment, value: "vmExtensionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineExtensionsGet_565259(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to get the extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmExtensionName: JString (required)
  ##                  : The name of the virtual machine extension.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine containing the extension.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565261 = path.getOrDefault("subscriptionId")
  valid_565261 = validateParameter(valid_565261, JString, required = true,
                                 default = nil)
  if valid_565261 != nil:
    section.add "subscriptionId", valid_565261
  var valid_565262 = path.getOrDefault("resourceGroupName")
  valid_565262 = validateParameter(valid_565262, JString, required = true,
                                 default = nil)
  if valid_565262 != nil:
    section.add "resourceGroupName", valid_565262
  var valid_565263 = path.getOrDefault("vmExtensionName")
  valid_565263 = validateParameter(valid_565263, JString, required = true,
                                 default = nil)
  if valid_565263 != nil:
    section.add "vmExtensionName", valid_565263
  var valid_565264 = path.getOrDefault("vmName")
  valid_565264 = validateParameter(valid_565264, JString, required = true,
                                 default = nil)
  if valid_565264 != nil:
    section.add "vmName", valid_565264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565265 = query.getOrDefault("api-version")
  valid_565265 = validateParameter(valid_565265, JString, required = true,
                                 default = nil)
  if valid_565265 != nil:
    section.add "api-version", valid_565265
  var valid_565266 = query.getOrDefault("$expand")
  valid_565266 = validateParameter(valid_565266, JString, required = false,
                                 default = nil)
  if valid_565266 != nil:
    section.add "$expand", valid_565266
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565267: Call_VirtualMachineExtensionsGet_565258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get the extension.
  ## 
  let valid = call_565267.validator(path, query, header, formData, body)
  let scheme = call_565267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565267.url(scheme.get, call_565267.host, call_565267.base,
                         call_565267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565267, url, valid)

proc call*(call_565268: Call_VirtualMachineExtensionsGet_565258;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          vmExtensionName: string; vmName: string; Expand: string = ""): Recallable =
  ## virtualMachineExtensionsGet
  ## The operation to get the extension.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmExtensionName: string (required)
  ##                  : The name of the virtual machine extension.
  ##   vmName: string (required)
  ##         : The name of the virtual machine containing the extension.
  var path_565269 = newJObject()
  var query_565270 = newJObject()
  add(query_565270, "api-version", newJString(apiVersion))
  add(query_565270, "$expand", newJString(Expand))
  add(path_565269, "subscriptionId", newJString(subscriptionId))
  add(path_565269, "resourceGroupName", newJString(resourceGroupName))
  add(path_565269, "vmExtensionName", newJString(vmExtensionName))
  add(path_565269, "vmName", newJString(vmName))
  result = call_565268.call(path_565269, query_565270, nil, nil, nil)

var virtualMachineExtensionsGet* = Call_VirtualMachineExtensionsGet_565258(
    name: "virtualMachineExtensionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsGet_565259, base: "",
    url: url_VirtualMachineExtensionsGet_565260, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsUpdate_565297 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineExtensionsUpdate_565299(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  assert "vmExtensionName" in path, "`vmExtensionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/extensions/"),
               (kind: VariableSegment, value: "vmExtensionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineExtensionsUpdate_565298(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update the extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmExtensionName: JString (required)
  ##                  : The name of the virtual machine extension.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine where the extension should be updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565300 = path.getOrDefault("subscriptionId")
  valid_565300 = validateParameter(valid_565300, JString, required = true,
                                 default = nil)
  if valid_565300 != nil:
    section.add "subscriptionId", valid_565300
  var valid_565301 = path.getOrDefault("resourceGroupName")
  valid_565301 = validateParameter(valid_565301, JString, required = true,
                                 default = nil)
  if valid_565301 != nil:
    section.add "resourceGroupName", valid_565301
  var valid_565302 = path.getOrDefault("vmExtensionName")
  valid_565302 = validateParameter(valid_565302, JString, required = true,
                                 default = nil)
  if valid_565302 != nil:
    section.add "vmExtensionName", valid_565302
  var valid_565303 = path.getOrDefault("vmName")
  valid_565303 = validateParameter(valid_565303, JString, required = true,
                                 default = nil)
  if valid_565303 != nil:
    section.add "vmName", valid_565303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565304 = query.getOrDefault("api-version")
  valid_565304 = validateParameter(valid_565304, JString, required = true,
                                 default = nil)
  if valid_565304 != nil:
    section.add "api-version", valid_565304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   extensionParameters: JObject (required)
  ##                      : Parameters supplied to the Update Virtual Machine Extension operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565306: Call_VirtualMachineExtensionsUpdate_565297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update the extension.
  ## 
  let valid = call_565306.validator(path, query, header, formData, body)
  let scheme = call_565306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565306.url(scheme.get, call_565306.host, call_565306.base,
                         call_565306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565306, url, valid)

proc call*(call_565307: Call_VirtualMachineExtensionsUpdate_565297;
          apiVersion: string; extensionParameters: JsonNode; subscriptionId: string;
          resourceGroupName: string; vmExtensionName: string; vmName: string): Recallable =
  ## virtualMachineExtensionsUpdate
  ## The operation to update the extension.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   extensionParameters: JObject (required)
  ##                      : Parameters supplied to the Update Virtual Machine Extension operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmExtensionName: string (required)
  ##                  : The name of the virtual machine extension.
  ##   vmName: string (required)
  ##         : The name of the virtual machine where the extension should be updated.
  var path_565308 = newJObject()
  var query_565309 = newJObject()
  var body_565310 = newJObject()
  add(query_565309, "api-version", newJString(apiVersion))
  if extensionParameters != nil:
    body_565310 = extensionParameters
  add(path_565308, "subscriptionId", newJString(subscriptionId))
  add(path_565308, "resourceGroupName", newJString(resourceGroupName))
  add(path_565308, "vmExtensionName", newJString(vmExtensionName))
  add(path_565308, "vmName", newJString(vmName))
  result = call_565307.call(path_565308, query_565309, nil, nil, body_565310)

var virtualMachineExtensionsUpdate* = Call_VirtualMachineExtensionsUpdate_565297(
    name: "virtualMachineExtensionsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsUpdate_565298, base: "",
    url: url_VirtualMachineExtensionsUpdate_565299, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsDelete_565285 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineExtensionsDelete_565287(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  assert "vmExtensionName" in path, "`vmExtensionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/extensions/"),
               (kind: VariableSegment, value: "vmExtensionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachineExtensionsDelete_565286(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete the extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmExtensionName: JString (required)
  ##                  : The name of the virtual machine extension.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine where the extension should be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565288 = path.getOrDefault("subscriptionId")
  valid_565288 = validateParameter(valid_565288, JString, required = true,
                                 default = nil)
  if valid_565288 != nil:
    section.add "subscriptionId", valid_565288
  var valid_565289 = path.getOrDefault("resourceGroupName")
  valid_565289 = validateParameter(valid_565289, JString, required = true,
                                 default = nil)
  if valid_565289 != nil:
    section.add "resourceGroupName", valid_565289
  var valid_565290 = path.getOrDefault("vmExtensionName")
  valid_565290 = validateParameter(valid_565290, JString, required = true,
                                 default = nil)
  if valid_565290 != nil:
    section.add "vmExtensionName", valid_565290
  var valid_565291 = path.getOrDefault("vmName")
  valid_565291 = validateParameter(valid_565291, JString, required = true,
                                 default = nil)
  if valid_565291 != nil:
    section.add "vmName", valid_565291
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565292 = query.getOrDefault("api-version")
  valid_565292 = validateParameter(valid_565292, JString, required = true,
                                 default = nil)
  if valid_565292 != nil:
    section.add "api-version", valid_565292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565293: Call_VirtualMachineExtensionsDelete_565285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete the extension.
  ## 
  let valid = call_565293.validator(path, query, header, formData, body)
  let scheme = call_565293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565293.url(scheme.get, call_565293.host, call_565293.base,
                         call_565293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565293, url, valid)

proc call*(call_565294: Call_VirtualMachineExtensionsDelete_565285;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          vmExtensionName: string; vmName: string): Recallable =
  ## virtualMachineExtensionsDelete
  ## The operation to delete the extension.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmExtensionName: string (required)
  ##                  : The name of the virtual machine extension.
  ##   vmName: string (required)
  ##         : The name of the virtual machine where the extension should be deleted.
  var path_565295 = newJObject()
  var query_565296 = newJObject()
  add(query_565296, "api-version", newJString(apiVersion))
  add(path_565295, "subscriptionId", newJString(subscriptionId))
  add(path_565295, "resourceGroupName", newJString(resourceGroupName))
  add(path_565295, "vmExtensionName", newJString(vmExtensionName))
  add(path_565295, "vmName", newJString(vmName))
  result = call_565294.call(path_565295, query_565296, nil, nil, nil)

var virtualMachineExtensionsDelete* = Call_VirtualMachineExtensionsDelete_565285(
    name: "virtualMachineExtensionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsDelete_565286, base: "",
    url: url_VirtualMachineExtensionsDelete_565287, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGeneralize_565311 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesGeneralize_565313(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/generalize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesGeneralize_565312(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the state of the virtual machine to generalized.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565314 = path.getOrDefault("subscriptionId")
  valid_565314 = validateParameter(valid_565314, JString, required = true,
                                 default = nil)
  if valid_565314 != nil:
    section.add "subscriptionId", valid_565314
  var valid_565315 = path.getOrDefault("resourceGroupName")
  valid_565315 = validateParameter(valid_565315, JString, required = true,
                                 default = nil)
  if valid_565315 != nil:
    section.add "resourceGroupName", valid_565315
  var valid_565316 = path.getOrDefault("vmName")
  valid_565316 = validateParameter(valid_565316, JString, required = true,
                                 default = nil)
  if valid_565316 != nil:
    section.add "vmName", valid_565316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565317 = query.getOrDefault("api-version")
  valid_565317 = validateParameter(valid_565317, JString, required = true,
                                 default = nil)
  if valid_565317 != nil:
    section.add "api-version", valid_565317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565318: Call_VirtualMachinesGeneralize_565311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the state of the virtual machine to generalized.
  ## 
  let valid = call_565318.validator(path, query, header, formData, body)
  let scheme = call_565318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565318.url(scheme.get, call_565318.host, call_565318.base,
                         call_565318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565318, url, valid)

proc call*(call_565319: Call_VirtualMachinesGeneralize_565311; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; vmName: string): Recallable =
  ## virtualMachinesGeneralize
  ## Sets the state of the virtual machine to generalized.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_565320 = newJObject()
  var query_565321 = newJObject()
  add(query_565321, "api-version", newJString(apiVersion))
  add(path_565320, "subscriptionId", newJString(subscriptionId))
  add(path_565320, "resourceGroupName", newJString(resourceGroupName))
  add(path_565320, "vmName", newJString(vmName))
  result = call_565319.call(path_565320, query_565321, nil, nil, nil)

var virtualMachinesGeneralize* = Call_VirtualMachinesGeneralize_565311(
    name: "virtualMachinesGeneralize", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/generalize",
    validator: validate_VirtualMachinesGeneralize_565312, base: "",
    url: url_VirtualMachinesGeneralize_565313, schemes: {Scheme.Https})
type
  Call_VirtualMachinesInstanceView_565322 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesInstanceView_565324(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/instanceView")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesInstanceView_565323(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves information about the run-time state of a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565325 = path.getOrDefault("subscriptionId")
  valid_565325 = validateParameter(valid_565325, JString, required = true,
                                 default = nil)
  if valid_565325 != nil:
    section.add "subscriptionId", valid_565325
  var valid_565326 = path.getOrDefault("resourceGroupName")
  valid_565326 = validateParameter(valid_565326, JString, required = true,
                                 default = nil)
  if valid_565326 != nil:
    section.add "resourceGroupName", valid_565326
  var valid_565327 = path.getOrDefault("vmName")
  valid_565327 = validateParameter(valid_565327, JString, required = true,
                                 default = nil)
  if valid_565327 != nil:
    section.add "vmName", valid_565327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565328 = query.getOrDefault("api-version")
  valid_565328 = validateParameter(valid_565328, JString, required = true,
                                 default = nil)
  if valid_565328 != nil:
    section.add "api-version", valid_565328
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565329: Call_VirtualMachinesInstanceView_565322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the run-time state of a virtual machine.
  ## 
  let valid = call_565329.validator(path, query, header, formData, body)
  let scheme = call_565329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565329.url(scheme.get, call_565329.host, call_565329.base,
                         call_565329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565329, url, valid)

proc call*(call_565330: Call_VirtualMachinesInstanceView_565322;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          vmName: string): Recallable =
  ## virtualMachinesInstanceView
  ## Retrieves information about the run-time state of a virtual machine.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_565331 = newJObject()
  var query_565332 = newJObject()
  add(query_565332, "api-version", newJString(apiVersion))
  add(path_565331, "subscriptionId", newJString(subscriptionId))
  add(path_565331, "resourceGroupName", newJString(resourceGroupName))
  add(path_565331, "vmName", newJString(vmName))
  result = call_565330.call(path_565331, query_565332, nil, nil, nil)

var virtualMachinesInstanceView* = Call_VirtualMachinesInstanceView_565322(
    name: "virtualMachinesInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/instanceView",
    validator: validate_VirtualMachinesInstanceView_565323, base: "",
    url: url_VirtualMachinesInstanceView_565324, schemes: {Scheme.Https})
type
  Call_VirtualMachinesPerformMaintenance_565333 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesPerformMaintenance_565335(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/performMaintenance")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesPerformMaintenance_565334(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to perform maintenance on a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565336 = path.getOrDefault("subscriptionId")
  valid_565336 = validateParameter(valid_565336, JString, required = true,
                                 default = nil)
  if valid_565336 != nil:
    section.add "subscriptionId", valid_565336
  var valid_565337 = path.getOrDefault("resourceGroupName")
  valid_565337 = validateParameter(valid_565337, JString, required = true,
                                 default = nil)
  if valid_565337 != nil:
    section.add "resourceGroupName", valid_565337
  var valid_565338 = path.getOrDefault("vmName")
  valid_565338 = validateParameter(valid_565338, JString, required = true,
                                 default = nil)
  if valid_565338 != nil:
    section.add "vmName", valid_565338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565339 = query.getOrDefault("api-version")
  valid_565339 = validateParameter(valid_565339, JString, required = true,
                                 default = nil)
  if valid_565339 != nil:
    section.add "api-version", valid_565339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565340: Call_VirtualMachinesPerformMaintenance_565333;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to perform maintenance on a virtual machine.
  ## 
  let valid = call_565340.validator(path, query, header, formData, body)
  let scheme = call_565340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565340.url(scheme.get, call_565340.host, call_565340.base,
                         call_565340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565340, url, valid)

proc call*(call_565341: Call_VirtualMachinesPerformMaintenance_565333;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          vmName: string): Recallable =
  ## virtualMachinesPerformMaintenance
  ## The operation to perform maintenance on a virtual machine.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_565342 = newJObject()
  var query_565343 = newJObject()
  add(query_565343, "api-version", newJString(apiVersion))
  add(path_565342, "subscriptionId", newJString(subscriptionId))
  add(path_565342, "resourceGroupName", newJString(resourceGroupName))
  add(path_565342, "vmName", newJString(vmName))
  result = call_565341.call(path_565342, query_565343, nil, nil, nil)

var virtualMachinesPerformMaintenance* = Call_VirtualMachinesPerformMaintenance_565333(
    name: "virtualMachinesPerformMaintenance", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/performMaintenance",
    validator: validate_VirtualMachinesPerformMaintenance_565334, base: "",
    url: url_VirtualMachinesPerformMaintenance_565335, schemes: {Scheme.Https})
type
  Call_VirtualMachinesPowerOff_565344 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesPowerOff_565346(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/powerOff")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesPowerOff_565345(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to power off (stop) a virtual machine. The virtual machine can be restarted with the same provisioned resources. You are still charged for this virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565347 = path.getOrDefault("subscriptionId")
  valid_565347 = validateParameter(valid_565347, JString, required = true,
                                 default = nil)
  if valid_565347 != nil:
    section.add "subscriptionId", valid_565347
  var valid_565348 = path.getOrDefault("resourceGroupName")
  valid_565348 = validateParameter(valid_565348, JString, required = true,
                                 default = nil)
  if valid_565348 != nil:
    section.add "resourceGroupName", valid_565348
  var valid_565349 = path.getOrDefault("vmName")
  valid_565349 = validateParameter(valid_565349, JString, required = true,
                                 default = nil)
  if valid_565349 != nil:
    section.add "vmName", valid_565349
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   skipShutdown: JBool
  ##               : The parameter to request non-graceful VM shutdown. True value for this flag indicates non-graceful shutdown whereas false indicates otherwise. Default value for this flag is false if not specified
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565350 = query.getOrDefault("api-version")
  valid_565350 = validateParameter(valid_565350, JString, required = true,
                                 default = nil)
  if valid_565350 != nil:
    section.add "api-version", valid_565350
  var valid_565351 = query.getOrDefault("skipShutdown")
  valid_565351 = validateParameter(valid_565351, JBool, required = false,
                                 default = newJBool(false))
  if valid_565351 != nil:
    section.add "skipShutdown", valid_565351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565352: Call_VirtualMachinesPowerOff_565344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to power off (stop) a virtual machine. The virtual machine can be restarted with the same provisioned resources. You are still charged for this virtual machine.
  ## 
  let valid = call_565352.validator(path, query, header, formData, body)
  let scheme = call_565352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565352.url(scheme.get, call_565352.host, call_565352.base,
                         call_565352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565352, url, valid)

proc call*(call_565353: Call_VirtualMachinesPowerOff_565344; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; vmName: string;
          skipShutdown: bool = false): Recallable =
  ## virtualMachinesPowerOff
  ## The operation to power off (stop) a virtual machine. The virtual machine can be restarted with the same provisioned resources. You are still charged for this virtual machine.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   skipShutdown: bool
  ##               : The parameter to request non-graceful VM shutdown. True value for this flag indicates non-graceful shutdown whereas false indicates otherwise. Default value for this flag is false if not specified
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_565354 = newJObject()
  var query_565355 = newJObject()
  add(query_565355, "api-version", newJString(apiVersion))
  add(path_565354, "subscriptionId", newJString(subscriptionId))
  add(path_565354, "resourceGroupName", newJString(resourceGroupName))
  add(query_565355, "skipShutdown", newJBool(skipShutdown))
  add(path_565354, "vmName", newJString(vmName))
  result = call_565353.call(path_565354, query_565355, nil, nil, nil)

var virtualMachinesPowerOff* = Call_VirtualMachinesPowerOff_565344(
    name: "virtualMachinesPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/powerOff",
    validator: validate_VirtualMachinesPowerOff_565345, base: "",
    url: url_VirtualMachinesPowerOff_565346, schemes: {Scheme.Https})
type
  Call_VirtualMachinesRedeploy_565356 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesRedeploy_565358(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/redeploy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesRedeploy_565357(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shuts down the virtual machine, moves it to a new node, and powers it back on.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565359 = path.getOrDefault("subscriptionId")
  valid_565359 = validateParameter(valid_565359, JString, required = true,
                                 default = nil)
  if valid_565359 != nil:
    section.add "subscriptionId", valid_565359
  var valid_565360 = path.getOrDefault("resourceGroupName")
  valid_565360 = validateParameter(valid_565360, JString, required = true,
                                 default = nil)
  if valid_565360 != nil:
    section.add "resourceGroupName", valid_565360
  var valid_565361 = path.getOrDefault("vmName")
  valid_565361 = validateParameter(valid_565361, JString, required = true,
                                 default = nil)
  if valid_565361 != nil:
    section.add "vmName", valid_565361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565362 = query.getOrDefault("api-version")
  valid_565362 = validateParameter(valid_565362, JString, required = true,
                                 default = nil)
  if valid_565362 != nil:
    section.add "api-version", valid_565362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565363: Call_VirtualMachinesRedeploy_565356; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shuts down the virtual machine, moves it to a new node, and powers it back on.
  ## 
  let valid = call_565363.validator(path, query, header, formData, body)
  let scheme = call_565363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565363.url(scheme.get, call_565363.host, call_565363.base,
                         call_565363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565363, url, valid)

proc call*(call_565364: Call_VirtualMachinesRedeploy_565356; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; vmName: string): Recallable =
  ## virtualMachinesRedeploy
  ## Shuts down the virtual machine, moves it to a new node, and powers it back on.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_565365 = newJObject()
  var query_565366 = newJObject()
  add(query_565366, "api-version", newJString(apiVersion))
  add(path_565365, "subscriptionId", newJString(subscriptionId))
  add(path_565365, "resourceGroupName", newJString(resourceGroupName))
  add(path_565365, "vmName", newJString(vmName))
  result = call_565364.call(path_565365, query_565366, nil, nil, nil)

var virtualMachinesRedeploy* = Call_VirtualMachinesRedeploy_565356(
    name: "virtualMachinesRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/redeploy",
    validator: validate_VirtualMachinesRedeploy_565357, base: "",
    url: url_VirtualMachinesRedeploy_565358, schemes: {Scheme.Https})
type
  Call_VirtualMachinesReimage_565367 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesReimage_565369(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/reimage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesReimage_565368(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reimages the virtual machine which has an ephemeral OS disk back to its initial state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565370 = path.getOrDefault("subscriptionId")
  valid_565370 = validateParameter(valid_565370, JString, required = true,
                                 default = nil)
  if valid_565370 != nil:
    section.add "subscriptionId", valid_565370
  var valid_565371 = path.getOrDefault("resourceGroupName")
  valid_565371 = validateParameter(valid_565371, JString, required = true,
                                 default = nil)
  if valid_565371 != nil:
    section.add "resourceGroupName", valid_565371
  var valid_565372 = path.getOrDefault("vmName")
  valid_565372 = validateParameter(valid_565372, JString, required = true,
                                 default = nil)
  if valid_565372 != nil:
    section.add "vmName", valid_565372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565373 = query.getOrDefault("api-version")
  valid_565373 = validateParameter(valid_565373, JString, required = true,
                                 default = nil)
  if valid_565373 != nil:
    section.add "api-version", valid_565373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject
  ##             : Parameters supplied to the Reimage Virtual Machine operation.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565375: Call_VirtualMachinesReimage_565367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reimages the virtual machine which has an ephemeral OS disk back to its initial state.
  ## 
  let valid = call_565375.validator(path, query, header, formData, body)
  let scheme = call_565375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565375.url(scheme.get, call_565375.host, call_565375.base,
                         call_565375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565375, url, valid)

proc call*(call_565376: Call_VirtualMachinesReimage_565367; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; vmName: string;
          parameters: JsonNode = nil): Recallable =
  ## virtualMachinesReimage
  ## Reimages the virtual machine which has an ephemeral OS disk back to its initial state.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   parameters: JObject
  ##             : Parameters supplied to the Reimage Virtual Machine operation.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_565377 = newJObject()
  var query_565378 = newJObject()
  var body_565379 = newJObject()
  add(query_565378, "api-version", newJString(apiVersion))
  add(path_565377, "subscriptionId", newJString(subscriptionId))
  add(path_565377, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_565379 = parameters
  add(path_565377, "vmName", newJString(vmName))
  result = call_565376.call(path_565377, query_565378, nil, nil, body_565379)

var virtualMachinesReimage* = Call_VirtualMachinesReimage_565367(
    name: "virtualMachinesReimage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/reimage",
    validator: validate_VirtualMachinesReimage_565368, base: "",
    url: url_VirtualMachinesReimage_565369, schemes: {Scheme.Https})
type
  Call_VirtualMachinesRestart_565380 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesRestart_565382(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesRestart_565381(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to restart a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565383 = path.getOrDefault("subscriptionId")
  valid_565383 = validateParameter(valid_565383, JString, required = true,
                                 default = nil)
  if valid_565383 != nil:
    section.add "subscriptionId", valid_565383
  var valid_565384 = path.getOrDefault("resourceGroupName")
  valid_565384 = validateParameter(valid_565384, JString, required = true,
                                 default = nil)
  if valid_565384 != nil:
    section.add "resourceGroupName", valid_565384
  var valid_565385 = path.getOrDefault("vmName")
  valid_565385 = validateParameter(valid_565385, JString, required = true,
                                 default = nil)
  if valid_565385 != nil:
    section.add "vmName", valid_565385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565386 = query.getOrDefault("api-version")
  valid_565386 = validateParameter(valid_565386, JString, required = true,
                                 default = nil)
  if valid_565386 != nil:
    section.add "api-version", valid_565386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565387: Call_VirtualMachinesRestart_565380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to restart a virtual machine.
  ## 
  let valid = call_565387.validator(path, query, header, formData, body)
  let scheme = call_565387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565387.url(scheme.get, call_565387.host, call_565387.base,
                         call_565387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565387, url, valid)

proc call*(call_565388: Call_VirtualMachinesRestart_565380; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; vmName: string): Recallable =
  ## virtualMachinesRestart
  ## The operation to restart a virtual machine.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_565389 = newJObject()
  var query_565390 = newJObject()
  add(query_565390, "api-version", newJString(apiVersion))
  add(path_565389, "subscriptionId", newJString(subscriptionId))
  add(path_565389, "resourceGroupName", newJString(resourceGroupName))
  add(path_565389, "vmName", newJString(vmName))
  result = call_565388.call(path_565389, query_565390, nil, nil, nil)

var virtualMachinesRestart* = Call_VirtualMachinesRestart_565380(
    name: "virtualMachinesRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/restart",
    validator: validate_VirtualMachinesRestart_565381, base: "",
    url: url_VirtualMachinesRestart_565382, schemes: {Scheme.Https})
type
  Call_VirtualMachinesStart_565391 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesStart_565393(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesStart_565392(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to start a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565394 = path.getOrDefault("subscriptionId")
  valid_565394 = validateParameter(valid_565394, JString, required = true,
                                 default = nil)
  if valid_565394 != nil:
    section.add "subscriptionId", valid_565394
  var valid_565395 = path.getOrDefault("resourceGroupName")
  valid_565395 = validateParameter(valid_565395, JString, required = true,
                                 default = nil)
  if valid_565395 != nil:
    section.add "resourceGroupName", valid_565395
  var valid_565396 = path.getOrDefault("vmName")
  valid_565396 = validateParameter(valid_565396, JString, required = true,
                                 default = nil)
  if valid_565396 != nil:
    section.add "vmName", valid_565396
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565397 = query.getOrDefault("api-version")
  valid_565397 = validateParameter(valid_565397, JString, required = true,
                                 default = nil)
  if valid_565397 != nil:
    section.add "api-version", valid_565397
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565398: Call_VirtualMachinesStart_565391; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to start a virtual machine.
  ## 
  let valid = call_565398.validator(path, query, header, formData, body)
  let scheme = call_565398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565398.url(scheme.get, call_565398.host, call_565398.base,
                         call_565398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565398, url, valid)

proc call*(call_565399: Call_VirtualMachinesStart_565391; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; vmName: string): Recallable =
  ## virtualMachinesStart
  ## The operation to start a virtual machine.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_565400 = newJObject()
  var query_565401 = newJObject()
  add(query_565401, "api-version", newJString(apiVersion))
  add(path_565400, "subscriptionId", newJString(subscriptionId))
  add(path_565400, "resourceGroupName", newJString(resourceGroupName))
  add(path_565400, "vmName", newJString(vmName))
  result = call_565399.call(path_565400, query_565401, nil, nil, nil)

var virtualMachinesStart* = Call_VirtualMachinesStart_565391(
    name: "virtualMachinesStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/start",
    validator: validate_VirtualMachinesStart_565392, base: "",
    url: url_VirtualMachinesStart_565393, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListAvailableSizes_565402 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesListAvailableSizes_565404(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "vmName" in path, "`vmName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachines/"),
               (kind: VariableSegment, value: "vmName"),
               (kind: ConstantSegment, value: "/vmSizes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VirtualMachinesListAvailableSizes_565403(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all available virtual machine sizes to which the specified virtual machine can be resized.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_565405 = path.getOrDefault("subscriptionId")
  valid_565405 = validateParameter(valid_565405, JString, required = true,
                                 default = nil)
  if valid_565405 != nil:
    section.add "subscriptionId", valid_565405
  var valid_565406 = path.getOrDefault("resourceGroupName")
  valid_565406 = validateParameter(valid_565406, JString, required = true,
                                 default = nil)
  if valid_565406 != nil:
    section.add "resourceGroupName", valid_565406
  var valid_565407 = path.getOrDefault("vmName")
  valid_565407 = validateParameter(valid_565407, JString, required = true,
                                 default = nil)
  if valid_565407 != nil:
    section.add "vmName", valid_565407
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565408 = query.getOrDefault("api-version")
  valid_565408 = validateParameter(valid_565408, JString, required = true,
                                 default = nil)
  if valid_565408 != nil:
    section.add "api-version", valid_565408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565409: Call_VirtualMachinesListAvailableSizes_565402;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available virtual machine sizes to which the specified virtual machine can be resized.
  ## 
  let valid = call_565409.validator(path, query, header, formData, body)
  let scheme = call_565409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565409.url(scheme.get, call_565409.host, call_565409.base,
                         call_565409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565409, url, valid)

proc call*(call_565410: Call_VirtualMachinesListAvailableSizes_565402;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          vmName: string): Recallable =
  ## virtualMachinesListAvailableSizes
  ## Lists all available virtual machine sizes to which the specified virtual machine can be resized.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_565411 = newJObject()
  var query_565412 = newJObject()
  add(query_565412, "api-version", newJString(apiVersion))
  add(path_565411, "subscriptionId", newJString(subscriptionId))
  add(path_565411, "resourceGroupName", newJString(resourceGroupName))
  add(path_565411, "vmName", newJString(vmName))
  result = call_565410.call(path_565411, query_565412, nil, nil, nil)

var virtualMachinesListAvailableSizes* = Call_VirtualMachinesListAvailableSizes_565402(
    name: "virtualMachinesListAvailableSizes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/vmSizes",
    validator: validate_VirtualMachinesListAvailableSizes_565403, base: "",
    url: url_VirtualMachinesListAvailableSizes_565404, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
