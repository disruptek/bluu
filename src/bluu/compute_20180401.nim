
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ComputeManagementClient
## version: 2018-04-01
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
  Call_ImagesList_564110 = ref object of OpenApiRestCall_563565
proc url_ImagesList_564112(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ImagesList_564111(path: JsonNode; query: JsonNode; header: JsonNode;
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

proc call*(call_564115: Call_ImagesList_564110; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Images in the subscription. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.
  ## 
  let valid = call_564115.validator(path, query, header, formData, body)
  let scheme = call_564115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564115.url(scheme.get, call_564115.host, call_564115.base,
                         call_564115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564115, url, valid)

proc call*(call_564116: Call_ImagesList_564110; apiVersion: string;
          subscriptionId: string): Recallable =
  ## imagesList
  ## Gets the list of Images in the subscription. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564117 = newJObject()
  var query_564118 = newJObject()
  add(query_564118, "api-version", newJString(apiVersion))
  add(path_564117, "subscriptionId", newJString(subscriptionId))
  result = call_564116.call(path_564117, query_564118, nil, nil, nil)

var imagesList* = Call_ImagesList_564110(name: "imagesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/images",
                                      validator: validate_ImagesList_564111,
                                      base: "", url: url_ImagesList_564112,
                                      schemes: {Scheme.Https})
type
  Call_LogAnalyticsExportRequestRateByInterval_564119 = ref object of OpenApiRestCall_563565
proc url_LogAnalyticsExportRequestRateByInterval_564121(protocol: Scheme;
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

proc validate_LogAnalyticsExportRequestRateByInterval_564120(path: JsonNode;
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
  var valid_564139 = path.getOrDefault("subscriptionId")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "subscriptionId", valid_564139
  var valid_564140 = path.getOrDefault("location")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "location", valid_564140
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564141 = query.getOrDefault("api-version")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "api-version", valid_564141
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

proc call*(call_564143: Call_LogAnalyticsExportRequestRateByInterval_564119;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Export logs that show Api requests made by this subscription in the given time window to show throttling activities.
  ## 
  let valid = call_564143.validator(path, query, header, formData, body)
  let scheme = call_564143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564143.url(scheme.get, call_564143.host, call_564143.base,
                         call_564143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564143, url, valid)

proc call*(call_564144: Call_LogAnalyticsExportRequestRateByInterval_564119;
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
  var path_564145 = newJObject()
  var query_564146 = newJObject()
  var body_564147 = newJObject()
  add(query_564146, "api-version", newJString(apiVersion))
  add(path_564145, "subscriptionId", newJString(subscriptionId))
  add(path_564145, "location", newJString(location))
  if parameters != nil:
    body_564147 = parameters
  result = call_564144.call(path_564145, query_564146, nil, nil, body_564147)

var logAnalyticsExportRequestRateByInterval* = Call_LogAnalyticsExportRequestRateByInterval_564119(
    name: "logAnalyticsExportRequestRateByInterval", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/logAnalytics/apiAccess/getRequestRateByInterval",
    validator: validate_LogAnalyticsExportRequestRateByInterval_564120, base: "",
    url: url_LogAnalyticsExportRequestRateByInterval_564121,
    schemes: {Scheme.Https})
type
  Call_LogAnalyticsExportThrottledRequests_564148 = ref object of OpenApiRestCall_563565
proc url_LogAnalyticsExportThrottledRequests_564150(protocol: Scheme; host: string;
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

proc validate_LogAnalyticsExportThrottledRequests_564149(path: JsonNode;
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
  var valid_564151 = path.getOrDefault("subscriptionId")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "subscriptionId", valid_564151
  var valid_564152 = path.getOrDefault("location")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "location", valid_564152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564153 = query.getOrDefault("api-version")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "api-version", valid_564153
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

proc call*(call_564155: Call_LogAnalyticsExportThrottledRequests_564148;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Export logs that show total throttled Api requests for this subscription in the given time window.
  ## 
  let valid = call_564155.validator(path, query, header, formData, body)
  let scheme = call_564155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564155.url(scheme.get, call_564155.host, call_564155.base,
                         call_564155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564155, url, valid)

proc call*(call_564156: Call_LogAnalyticsExportThrottledRequests_564148;
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
  var path_564157 = newJObject()
  var query_564158 = newJObject()
  var body_564159 = newJObject()
  add(query_564158, "api-version", newJString(apiVersion))
  add(path_564157, "subscriptionId", newJString(subscriptionId))
  add(path_564157, "location", newJString(location))
  if parameters != nil:
    body_564159 = parameters
  result = call_564156.call(path_564157, query_564158, nil, nil, body_564159)

var logAnalyticsExportThrottledRequests* = Call_LogAnalyticsExportThrottledRequests_564148(
    name: "logAnalyticsExportThrottledRequests", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/logAnalytics/apiAccess/getThrottledRequests",
    validator: validate_LogAnalyticsExportThrottledRequests_564149, base: "",
    url: url_LogAnalyticsExportThrottledRequests_564150, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesListPublishers_564160 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineImagesListPublishers_564162(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImagesListPublishers_564161(path: JsonNode;
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
  var valid_564163 = path.getOrDefault("subscriptionId")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "subscriptionId", valid_564163
  var valid_564164 = path.getOrDefault("location")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "location", valid_564164
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564165 = query.getOrDefault("api-version")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "api-version", valid_564165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564166: Call_VirtualMachineImagesListPublishers_564160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual machine image publishers for the specified Azure location.
  ## 
  let valid = call_564166.validator(path, query, header, formData, body)
  let scheme = call_564166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564166.url(scheme.get, call_564166.host, call_564166.base,
                         call_564166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564166, url, valid)

proc call*(call_564167: Call_VirtualMachineImagesListPublishers_564160;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## virtualMachineImagesListPublishers
  ## Gets a list of virtual machine image publishers for the specified Azure location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_564168 = newJObject()
  var query_564169 = newJObject()
  add(query_564169, "api-version", newJString(apiVersion))
  add(path_564168, "subscriptionId", newJString(subscriptionId))
  add(path_564168, "location", newJString(location))
  result = call_564167.call(path_564168, query_564169, nil, nil, nil)

var virtualMachineImagesListPublishers* = Call_VirtualMachineImagesListPublishers_564160(
    name: "virtualMachineImagesListPublishers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers",
    validator: validate_VirtualMachineImagesListPublishers_564161, base: "",
    url: url_VirtualMachineImagesListPublishers_564162, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionImagesListTypes_564170 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineExtensionImagesListTypes_564172(protocol: Scheme;
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

proc validate_VirtualMachineExtensionImagesListTypes_564171(path: JsonNode;
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
  var valid_564173 = path.getOrDefault("publisherName")
  valid_564173 = validateParameter(valid_564173, JString, required = true,
                                 default = nil)
  if valid_564173 != nil:
    section.add "publisherName", valid_564173
  var valid_564174 = path.getOrDefault("subscriptionId")
  valid_564174 = validateParameter(valid_564174, JString, required = true,
                                 default = nil)
  if valid_564174 != nil:
    section.add "subscriptionId", valid_564174
  var valid_564175 = path.getOrDefault("location")
  valid_564175 = validateParameter(valid_564175, JString, required = true,
                                 default = nil)
  if valid_564175 != nil:
    section.add "location", valid_564175
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564176 = query.getOrDefault("api-version")
  valid_564176 = validateParameter(valid_564176, JString, required = true,
                                 default = nil)
  if valid_564176 != nil:
    section.add "api-version", valid_564176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564177: Call_VirtualMachineExtensionImagesListTypes_564170;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual machine extension image types.
  ## 
  let valid = call_564177.validator(path, query, header, formData, body)
  let scheme = call_564177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564177.url(scheme.get, call_564177.host, call_564177.base,
                         call_564177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564177, url, valid)

proc call*(call_564178: Call_VirtualMachineExtensionImagesListTypes_564170;
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
  var path_564179 = newJObject()
  var query_564180 = newJObject()
  add(path_564179, "publisherName", newJString(publisherName))
  add(query_564180, "api-version", newJString(apiVersion))
  add(path_564179, "subscriptionId", newJString(subscriptionId))
  add(path_564179, "location", newJString(location))
  result = call_564178.call(path_564179, query_564180, nil, nil, nil)

var virtualMachineExtensionImagesListTypes* = Call_VirtualMachineExtensionImagesListTypes_564170(
    name: "virtualMachineExtensionImagesListTypes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types",
    validator: validate_VirtualMachineExtensionImagesListTypes_564171, base: "",
    url: url_VirtualMachineExtensionImagesListTypes_564172,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionImagesListVersions_564181 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineExtensionImagesListVersions_564183(protocol: Scheme;
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

proc validate_VirtualMachineExtensionImagesListVersions_564182(path: JsonNode;
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
  var valid_564184 = path.getOrDefault("publisherName")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "publisherName", valid_564184
  var valid_564185 = path.getOrDefault("type")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "type", valid_564185
  var valid_564186 = path.getOrDefault("subscriptionId")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "subscriptionId", valid_564186
  var valid_564187 = path.getOrDefault("location")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "location", valid_564187
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $orderby: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_564188 = query.getOrDefault("$top")
  valid_564188 = validateParameter(valid_564188, JInt, required = false, default = nil)
  if valid_564188 != nil:
    section.add "$top", valid_564188
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564189 = query.getOrDefault("api-version")
  valid_564189 = validateParameter(valid_564189, JString, required = true,
                                 default = nil)
  if valid_564189 != nil:
    section.add "api-version", valid_564189
  var valid_564190 = query.getOrDefault("$orderby")
  valid_564190 = validateParameter(valid_564190, JString, required = false,
                                 default = nil)
  if valid_564190 != nil:
    section.add "$orderby", valid_564190
  var valid_564191 = query.getOrDefault("$filter")
  valid_564191 = validateParameter(valid_564191, JString, required = false,
                                 default = nil)
  if valid_564191 != nil:
    section.add "$filter", valid_564191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564192: Call_VirtualMachineExtensionImagesListVersions_564181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual machine extension image versions.
  ## 
  let valid = call_564192.validator(path, query, header, formData, body)
  let scheme = call_564192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564192.url(scheme.get, call_564192.host, call_564192.base,
                         call_564192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564192, url, valid)

proc call*(call_564193: Call_VirtualMachineExtensionImagesListVersions_564181;
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
  var path_564194 = newJObject()
  var query_564195 = newJObject()
  add(path_564194, "publisherName", newJString(publisherName))
  add(query_564195, "$top", newJInt(Top))
  add(path_564194, "type", newJString(`type`))
  add(query_564195, "api-version", newJString(apiVersion))
  add(path_564194, "subscriptionId", newJString(subscriptionId))
  add(query_564195, "$orderby", newJString(Orderby))
  add(path_564194, "location", newJString(location))
  add(query_564195, "$filter", newJString(Filter))
  result = call_564193.call(path_564194, query_564195, nil, nil, nil)

var virtualMachineExtensionImagesListVersions* = Call_VirtualMachineExtensionImagesListVersions_564181(
    name: "virtualMachineExtensionImagesListVersions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types/{type}/versions",
    validator: validate_VirtualMachineExtensionImagesListVersions_564182,
    base: "", url: url_VirtualMachineExtensionImagesListVersions_564183,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionImagesGet_564196 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineExtensionImagesGet_564198(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionImagesGet_564197(path: JsonNode;
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
  var valid_564199 = path.getOrDefault("publisherName")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "publisherName", valid_564199
  var valid_564200 = path.getOrDefault("version")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "version", valid_564200
  var valid_564201 = path.getOrDefault("type")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "type", valid_564201
  var valid_564202 = path.getOrDefault("subscriptionId")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "subscriptionId", valid_564202
  var valid_564203 = path.getOrDefault("location")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "location", valid_564203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564204 = query.getOrDefault("api-version")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "api-version", valid_564204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564205: Call_VirtualMachineExtensionImagesGet_564196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a virtual machine extension image.
  ## 
  let valid = call_564205.validator(path, query, header, formData, body)
  let scheme = call_564205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564205.url(scheme.get, call_564205.host, call_564205.base,
                         call_564205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564205, url, valid)

proc call*(call_564206: Call_VirtualMachineExtensionImagesGet_564196;
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
  var path_564207 = newJObject()
  var query_564208 = newJObject()
  add(path_564207, "publisherName", newJString(publisherName))
  add(path_564207, "version", newJString(version))
  add(query_564208, "api-version", newJString(apiVersion))
  add(path_564207, "type", newJString(`type`))
  add(path_564207, "subscriptionId", newJString(subscriptionId))
  add(path_564207, "location", newJString(location))
  result = call_564206.call(path_564207, query_564208, nil, nil, nil)

var virtualMachineExtensionImagesGet* = Call_VirtualMachineExtensionImagesGet_564196(
    name: "virtualMachineExtensionImagesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types/{type}/versions/{version}",
    validator: validate_VirtualMachineExtensionImagesGet_564197, base: "",
    url: url_VirtualMachineExtensionImagesGet_564198, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesListOffers_564209 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineImagesListOffers_564211(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImagesListOffers_564210(path: JsonNode;
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
  var valid_564212 = path.getOrDefault("publisherName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "publisherName", valid_564212
  var valid_564213 = path.getOrDefault("subscriptionId")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "subscriptionId", valid_564213
  var valid_564214 = path.getOrDefault("location")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "location", valid_564214
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564215 = query.getOrDefault("api-version")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "api-version", valid_564215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564216: Call_VirtualMachineImagesListOffers_564209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of virtual machine image offers for the specified location and publisher.
  ## 
  let valid = call_564216.validator(path, query, header, formData, body)
  let scheme = call_564216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564216.url(scheme.get, call_564216.host, call_564216.base,
                         call_564216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564216, url, valid)

proc call*(call_564217: Call_VirtualMachineImagesListOffers_564209;
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
  var path_564218 = newJObject()
  var query_564219 = newJObject()
  add(path_564218, "publisherName", newJString(publisherName))
  add(query_564219, "api-version", newJString(apiVersion))
  add(path_564218, "subscriptionId", newJString(subscriptionId))
  add(path_564218, "location", newJString(location))
  result = call_564217.call(path_564218, query_564219, nil, nil, nil)

var virtualMachineImagesListOffers* = Call_VirtualMachineImagesListOffers_564209(
    name: "virtualMachineImagesListOffers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers",
    validator: validate_VirtualMachineImagesListOffers_564210, base: "",
    url: url_VirtualMachineImagesListOffers_564211, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesListSkus_564220 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineImagesListSkus_564222(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImagesListSkus_564221(path: JsonNode; query: JsonNode;
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
  var valid_564223 = path.getOrDefault("publisherName")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "publisherName", valid_564223
  var valid_564224 = path.getOrDefault("offer")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "offer", valid_564224
  var valid_564225 = path.getOrDefault("subscriptionId")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "subscriptionId", valid_564225
  var valid_564226 = path.getOrDefault("location")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "location", valid_564226
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564227 = query.getOrDefault("api-version")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "api-version", valid_564227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564228: Call_VirtualMachineImagesListSkus_564220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of virtual machine image SKUs for the specified location, publisher, and offer.
  ## 
  let valid = call_564228.validator(path, query, header, formData, body)
  let scheme = call_564228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564228.url(scheme.get, call_564228.host, call_564228.base,
                         call_564228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564228, url, valid)

proc call*(call_564229: Call_VirtualMachineImagesListSkus_564220;
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
  var path_564230 = newJObject()
  var query_564231 = newJObject()
  add(path_564230, "publisherName", newJString(publisherName))
  add(path_564230, "offer", newJString(offer))
  add(query_564231, "api-version", newJString(apiVersion))
  add(path_564230, "subscriptionId", newJString(subscriptionId))
  add(path_564230, "location", newJString(location))
  result = call_564229.call(path_564230, query_564231, nil, nil, nil)

var virtualMachineImagesListSkus* = Call_VirtualMachineImagesListSkus_564220(
    name: "virtualMachineImagesListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus",
    validator: validate_VirtualMachineImagesListSkus_564221, base: "",
    url: url_VirtualMachineImagesListSkus_564222, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesList_564232 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineImagesList_564234(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImagesList_564233(path: JsonNode; query: JsonNode;
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
  var valid_564235 = path.getOrDefault("publisherName")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "publisherName", valid_564235
  var valid_564236 = path.getOrDefault("offer")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "offer", valid_564236
  var valid_564237 = path.getOrDefault("subscriptionId")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "subscriptionId", valid_564237
  var valid_564238 = path.getOrDefault("location")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "location", valid_564238
  var valid_564239 = path.getOrDefault("skus")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "skus", valid_564239
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $orderby: JString
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_564240 = query.getOrDefault("$top")
  valid_564240 = validateParameter(valid_564240, JInt, required = false, default = nil)
  if valid_564240 != nil:
    section.add "$top", valid_564240
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564241 = query.getOrDefault("api-version")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "api-version", valid_564241
  var valid_564242 = query.getOrDefault("$orderby")
  valid_564242 = validateParameter(valid_564242, JString, required = false,
                                 default = nil)
  if valid_564242 != nil:
    section.add "$orderby", valid_564242
  var valid_564243 = query.getOrDefault("$filter")
  valid_564243 = validateParameter(valid_564243, JString, required = false,
                                 default = nil)
  if valid_564243 != nil:
    section.add "$filter", valid_564243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564244: Call_VirtualMachineImagesList_564232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all virtual machine image versions for the specified location, publisher, offer, and SKU.
  ## 
  let valid = call_564244.validator(path, query, header, formData, body)
  let scheme = call_564244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564244.url(scheme.get, call_564244.host, call_564244.base,
                         call_564244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564244, url, valid)

proc call*(call_564245: Call_VirtualMachineImagesList_564232;
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
  var path_564246 = newJObject()
  var query_564247 = newJObject()
  add(path_564246, "publisherName", newJString(publisherName))
  add(path_564246, "offer", newJString(offer))
  add(query_564247, "$top", newJInt(Top))
  add(query_564247, "api-version", newJString(apiVersion))
  add(path_564246, "subscriptionId", newJString(subscriptionId))
  add(query_564247, "$orderby", newJString(Orderby))
  add(path_564246, "location", newJString(location))
  add(query_564247, "$filter", newJString(Filter))
  add(path_564246, "skus", newJString(skus))
  result = call_564245.call(path_564246, query_564247, nil, nil, nil)

var virtualMachineImagesList* = Call_VirtualMachineImagesList_564232(
    name: "virtualMachineImagesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions",
    validator: validate_VirtualMachineImagesList_564233, base: "",
    url: url_VirtualMachineImagesList_564234, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesGet_564248 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineImagesGet_564250(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineImagesGet_564249(path: JsonNode; query: JsonNode;
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
  var valid_564251 = path.getOrDefault("publisherName")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "publisherName", valid_564251
  var valid_564252 = path.getOrDefault("offer")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "offer", valid_564252
  var valid_564253 = path.getOrDefault("version")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "version", valid_564253
  var valid_564254 = path.getOrDefault("subscriptionId")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "subscriptionId", valid_564254
  var valid_564255 = path.getOrDefault("location")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "location", valid_564255
  var valid_564256 = path.getOrDefault("skus")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "skus", valid_564256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564257 = query.getOrDefault("api-version")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "api-version", valid_564257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564258: Call_VirtualMachineImagesGet_564248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a virtual machine image.
  ## 
  let valid = call_564258.validator(path, query, header, formData, body)
  let scheme = call_564258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564258.url(scheme.get, call_564258.host, call_564258.base,
                         call_564258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564258, url, valid)

proc call*(call_564259: Call_VirtualMachineImagesGet_564248; publisherName: string;
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
  var path_564260 = newJObject()
  var query_564261 = newJObject()
  add(path_564260, "publisherName", newJString(publisherName))
  add(path_564260, "offer", newJString(offer))
  add(path_564260, "version", newJString(version))
  add(query_564261, "api-version", newJString(apiVersion))
  add(path_564260, "subscriptionId", newJString(subscriptionId))
  add(path_564260, "location", newJString(location))
  add(path_564260, "skus", newJString(skus))
  result = call_564259.call(path_564260, query_564261, nil, nil, nil)

var virtualMachineImagesGet* = Call_VirtualMachineImagesGet_564248(
    name: "virtualMachineImagesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions/{version}",
    validator: validate_VirtualMachineImagesGet_564249, base: "",
    url: url_VirtualMachineImagesGet_564250, schemes: {Scheme.Https})
type
  Call_UsageList_564262 = ref object of OpenApiRestCall_563565
proc url_UsageList_564264(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsageList_564263(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564265 = path.getOrDefault("subscriptionId")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "subscriptionId", valid_564265
  var valid_564266 = path.getOrDefault("location")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "location", valid_564266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564267 = query.getOrDefault("api-version")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "api-version", valid_564267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564268: Call_UsageList_564262; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets, for the specified location, the current compute resource usage information as well as the limits for compute resources under the subscription.
  ## 
  let valid = call_564268.validator(path, query, header, formData, body)
  let scheme = call_564268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564268.url(scheme.get, call_564268.host, call_564268.base,
                         call_564268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564268, url, valid)

proc call*(call_564269: Call_UsageList_564262; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usageList
  ## Gets, for the specified location, the current compute resource usage information as well as the limits for compute resources under the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location for which resource usage is queried.
  var path_564270 = newJObject()
  var query_564271 = newJObject()
  add(query_564271, "api-version", newJString(apiVersion))
  add(path_564270, "subscriptionId", newJString(subscriptionId))
  add(path_564270, "location", newJString(location))
  result = call_564269.call(path_564270, query_564271, nil, nil, nil)

var usageList* = Call_UsageList_564262(name: "usageList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/usages",
                                    validator: validate_UsageList_564263,
                                    base: "", url: url_UsageList_564264,
                                    schemes: {Scheme.Https})
type
  Call_VirtualMachinesListByLocation_564272 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesListByLocation_564274(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesListByLocation_564273(path: JsonNode; query: JsonNode;
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
  var valid_564275 = path.getOrDefault("subscriptionId")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "subscriptionId", valid_564275
  var valid_564276 = path.getOrDefault("location")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "location", valid_564276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564277 = query.getOrDefault("api-version")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "api-version", valid_564277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564278: Call_VirtualMachinesListByLocation_564272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the virtual machines under the specified subscription for the specified location.
  ## 
  let valid = call_564278.validator(path, query, header, formData, body)
  let scheme = call_564278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564278.url(scheme.get, call_564278.host, call_564278.base,
                         call_564278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564278, url, valid)

proc call*(call_564279: Call_VirtualMachinesListByLocation_564272;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## virtualMachinesListByLocation
  ## Gets all the virtual machines under the specified subscription for the specified location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location for which virtual machines under the subscription are queried.
  var path_564280 = newJObject()
  var query_564281 = newJObject()
  add(query_564281, "api-version", newJString(apiVersion))
  add(path_564280, "subscriptionId", newJString(subscriptionId))
  add(path_564280, "location", newJString(location))
  result = call_564279.call(path_564280, query_564281, nil, nil, nil)

var virtualMachinesListByLocation* = Call_VirtualMachinesListByLocation_564272(
    name: "virtualMachinesListByLocation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/virtualMachines",
    validator: validate_VirtualMachinesListByLocation_564273, base: "",
    url: url_VirtualMachinesListByLocation_564274, schemes: {Scheme.Https})
type
  Call_VirtualMachineSizesList_564282 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineSizesList_564284(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineSizesList_564283(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all available virtual machine sizes for a subscription in a location.
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
  var valid_564285 = path.getOrDefault("subscriptionId")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "subscriptionId", valid_564285
  var valid_564286 = path.getOrDefault("location")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "location", valid_564286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564287 = query.getOrDefault("api-version")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "api-version", valid_564287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564288: Call_VirtualMachineSizesList_564282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all available virtual machine sizes for a subscription in a location.
  ## 
  let valid = call_564288.validator(path, query, header, formData, body)
  let scheme = call_564288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564288.url(scheme.get, call_564288.host, call_564288.base,
                         call_564288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564288, url, valid)

proc call*(call_564289: Call_VirtualMachineSizesList_564282; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## virtualMachineSizesList
  ## Lists all available virtual machine sizes for a subscription in a location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  var path_564290 = newJObject()
  var query_564291 = newJObject()
  add(query_564291, "api-version", newJString(apiVersion))
  add(path_564290, "subscriptionId", newJString(subscriptionId))
  add(path_564290, "location", newJString(location))
  result = call_564289.call(path_564290, query_564291, nil, nil, nil)

var virtualMachineSizesList* = Call_VirtualMachineSizesList_564282(
    name: "virtualMachineSizesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/vmSizes",
    validator: validate_VirtualMachineSizesList_564283, base: "",
    url: url_VirtualMachineSizesList_564284, schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsListBySubscription_564292 = ref object of OpenApiRestCall_563565
proc url_ProximityPlacementGroupsListBySubscription_564294(protocol: Scheme;
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

proc validate_ProximityPlacementGroupsListBySubscription_564293(path: JsonNode;
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
  var valid_564295 = path.getOrDefault("subscriptionId")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = nil)
  if valid_564295 != nil:
    section.add "subscriptionId", valid_564295
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

proc call*(call_564297: Call_ProximityPlacementGroupsListBySubscription_564292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all proximity placement groups in a subscription.
  ## 
  let valid = call_564297.validator(path, query, header, formData, body)
  let scheme = call_564297.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564297.url(scheme.get, call_564297.host, call_564297.base,
                         call_564297.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564297, url, valid)

proc call*(call_564298: Call_ProximityPlacementGroupsListBySubscription_564292;
          apiVersion: string; subscriptionId: string): Recallable =
  ## proximityPlacementGroupsListBySubscription
  ## Lists all proximity placement groups in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564299 = newJObject()
  var query_564300 = newJObject()
  add(query_564300, "api-version", newJString(apiVersion))
  add(path_564299, "subscriptionId", newJString(subscriptionId))
  result = call_564298.call(path_564299, query_564300, nil, nil, nil)

var proximityPlacementGroupsListBySubscription* = Call_ProximityPlacementGroupsListBySubscription_564292(
    name: "proximityPlacementGroupsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/proximityPlacementGroups",
    validator: validate_ProximityPlacementGroupsListBySubscription_564293,
    base: "", url: url_ProximityPlacementGroupsListBySubscription_564294,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsListAll_564301 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsListAll_564303(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsListAll_564302(path: JsonNode;
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

proc call*(call_564306: Call_VirtualMachineScaleSetsListAll_564301; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all VM Scale Sets in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM Scale Sets.
  ## 
  let valid = call_564306.validator(path, query, header, formData, body)
  let scheme = call_564306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564306.url(scheme.get, call_564306.host, call_564306.base,
                         call_564306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564306, url, valid)

proc call*(call_564307: Call_VirtualMachineScaleSetsListAll_564301;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsListAll
  ## Gets a list of all VM Scale Sets in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM Scale Sets.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564308 = newJObject()
  var query_564309 = newJObject()
  add(query_564309, "api-version", newJString(apiVersion))
  add(path_564308, "subscriptionId", newJString(subscriptionId))
  result = call_564307.call(path_564308, query_564309, nil, nil, nil)

var virtualMachineScaleSetsListAll* = Call_VirtualMachineScaleSetsListAll_564301(
    name: "virtualMachineScaleSetsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachineScaleSets",
    validator: validate_VirtualMachineScaleSetsListAll_564302, base: "",
    url: url_VirtualMachineScaleSetsListAll_564303, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListAll_564310 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesListAll_564312(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesListAll_564311(path: JsonNode; query: JsonNode;
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

proc call*(call_564315: Call_VirtualMachinesListAll_564310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the virtual machines in the specified subscription. Use the nextLink property in the response to get the next page of virtual machines.
  ## 
  let valid = call_564315.validator(path, query, header, formData, body)
  let scheme = call_564315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564315.url(scheme.get, call_564315.host, call_564315.base,
                         call_564315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564315, url, valid)

proc call*(call_564316: Call_VirtualMachinesListAll_564310; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachinesListAll
  ## Lists all of the virtual machines in the specified subscription. Use the nextLink property in the response to get the next page of virtual machines.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564317 = newJObject()
  var query_564318 = newJObject()
  add(query_564318, "api-version", newJString(apiVersion))
  add(path_564317, "subscriptionId", newJString(subscriptionId))
  result = call_564316.call(path_564317, query_564318, nil, nil, nil)

var virtualMachinesListAll* = Call_VirtualMachinesListAll_564310(
    name: "virtualMachinesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachines",
    validator: validate_VirtualMachinesListAll_564311, base: "",
    url: url_VirtualMachinesListAll_564312, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsList_564319 = ref object of OpenApiRestCall_563565
proc url_AvailabilitySetsList_564321(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsList_564320(path: JsonNode; query: JsonNode;
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
  var valid_564322 = path.getOrDefault("subscriptionId")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "subscriptionId", valid_564322
  var valid_564323 = path.getOrDefault("resourceGroupName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "resourceGroupName", valid_564323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564324 = query.getOrDefault("api-version")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = nil)
  if valid_564324 != nil:
    section.add "api-version", valid_564324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564325: Call_AvailabilitySetsList_564319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all availability sets in a resource group.
  ## 
  let valid = call_564325.validator(path, query, header, formData, body)
  let scheme = call_564325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564325.url(scheme.get, call_564325.host, call_564325.base,
                         call_564325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564325, url, valid)

proc call*(call_564326: Call_AvailabilitySetsList_564319; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## availabilitySetsList
  ## Lists all availability sets in a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564327 = newJObject()
  var query_564328 = newJObject()
  add(query_564328, "api-version", newJString(apiVersion))
  add(path_564327, "subscriptionId", newJString(subscriptionId))
  add(path_564327, "resourceGroupName", newJString(resourceGroupName))
  result = call_564326.call(path_564327, query_564328, nil, nil, nil)

var availabilitySetsList* = Call_AvailabilitySetsList_564319(
    name: "availabilitySetsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets",
    validator: validate_AvailabilitySetsList_564320, base: "",
    url: url_AvailabilitySetsList_564321, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsCreateOrUpdate_564340 = ref object of OpenApiRestCall_563565
proc url_AvailabilitySetsCreateOrUpdate_564342(protocol: Scheme; host: string;
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

proc validate_AvailabilitySetsCreateOrUpdate_564341(path: JsonNode;
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
  var valid_564343 = path.getOrDefault("availabilitySetName")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "availabilitySetName", valid_564343
  var valid_564344 = path.getOrDefault("subscriptionId")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "subscriptionId", valid_564344
  var valid_564345 = path.getOrDefault("resourceGroupName")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "resourceGroupName", valid_564345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564346 = query.getOrDefault("api-version")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "api-version", valid_564346
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

proc call*(call_564348: Call_AvailabilitySetsCreateOrUpdate_564340; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an availability set.
  ## 
  let valid = call_564348.validator(path, query, header, formData, body)
  let scheme = call_564348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564348.url(scheme.get, call_564348.host, call_564348.base,
                         call_564348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564348, url, valid)

proc call*(call_564349: Call_AvailabilitySetsCreateOrUpdate_564340;
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
  var path_564350 = newJObject()
  var query_564351 = newJObject()
  var body_564352 = newJObject()
  add(path_564350, "availabilitySetName", newJString(availabilitySetName))
  add(query_564351, "api-version", newJString(apiVersion))
  add(path_564350, "subscriptionId", newJString(subscriptionId))
  add(path_564350, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564352 = parameters
  result = call_564349.call(path_564350, query_564351, nil, nil, body_564352)

var availabilitySetsCreateOrUpdate* = Call_AvailabilitySetsCreateOrUpdate_564340(
    name: "availabilitySetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsCreateOrUpdate_564341, base: "",
    url: url_AvailabilitySetsCreateOrUpdate_564342, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsGet_564329 = ref object of OpenApiRestCall_563565
proc url_AvailabilitySetsGet_564331(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsGet_564330(path: JsonNode; query: JsonNode;
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
  var valid_564332 = path.getOrDefault("availabilitySetName")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "availabilitySetName", valid_564332
  var valid_564333 = path.getOrDefault("subscriptionId")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "subscriptionId", valid_564333
  var valid_564334 = path.getOrDefault("resourceGroupName")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "resourceGroupName", valid_564334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564335 = query.getOrDefault("api-version")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "api-version", valid_564335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564336: Call_AvailabilitySetsGet_564329; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about an availability set.
  ## 
  let valid = call_564336.validator(path, query, header, formData, body)
  let scheme = call_564336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564336.url(scheme.get, call_564336.host, call_564336.base,
                         call_564336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564336, url, valid)

proc call*(call_564337: Call_AvailabilitySetsGet_564329;
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
  var path_564338 = newJObject()
  var query_564339 = newJObject()
  add(path_564338, "availabilitySetName", newJString(availabilitySetName))
  add(query_564339, "api-version", newJString(apiVersion))
  add(path_564338, "subscriptionId", newJString(subscriptionId))
  add(path_564338, "resourceGroupName", newJString(resourceGroupName))
  result = call_564337.call(path_564338, query_564339, nil, nil, nil)

var availabilitySetsGet* = Call_AvailabilitySetsGet_564329(
    name: "availabilitySetsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsGet_564330, base: "",
    url: url_AvailabilitySetsGet_564331, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsUpdate_564364 = ref object of OpenApiRestCall_563565
proc url_AvailabilitySetsUpdate_564366(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsUpdate_564365(path: JsonNode; query: JsonNode;
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
  var valid_564367 = path.getOrDefault("availabilitySetName")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "availabilitySetName", valid_564367
  var valid_564368 = path.getOrDefault("subscriptionId")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "subscriptionId", valid_564368
  var valid_564369 = path.getOrDefault("resourceGroupName")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "resourceGroupName", valid_564369
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564370 = query.getOrDefault("api-version")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "api-version", valid_564370
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

proc call*(call_564372: Call_AvailabilitySetsUpdate_564364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an availability set.
  ## 
  let valid = call_564372.validator(path, query, header, formData, body)
  let scheme = call_564372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564372.url(scheme.get, call_564372.host, call_564372.base,
                         call_564372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564372, url, valid)

proc call*(call_564373: Call_AvailabilitySetsUpdate_564364;
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
  var path_564374 = newJObject()
  var query_564375 = newJObject()
  var body_564376 = newJObject()
  add(path_564374, "availabilitySetName", newJString(availabilitySetName))
  add(query_564375, "api-version", newJString(apiVersion))
  add(path_564374, "subscriptionId", newJString(subscriptionId))
  add(path_564374, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564376 = parameters
  result = call_564373.call(path_564374, query_564375, nil, nil, body_564376)

var availabilitySetsUpdate* = Call_AvailabilitySetsUpdate_564364(
    name: "availabilitySetsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsUpdate_564365, base: "",
    url: url_AvailabilitySetsUpdate_564366, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsDelete_564353 = ref object of OpenApiRestCall_563565
proc url_AvailabilitySetsDelete_564355(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsDelete_564354(path: JsonNode; query: JsonNode;
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
  var valid_564356 = path.getOrDefault("availabilitySetName")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "availabilitySetName", valid_564356
  var valid_564357 = path.getOrDefault("subscriptionId")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "subscriptionId", valid_564357
  var valid_564358 = path.getOrDefault("resourceGroupName")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "resourceGroupName", valid_564358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564359 = query.getOrDefault("api-version")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "api-version", valid_564359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564360: Call_AvailabilitySetsDelete_564353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an availability set.
  ## 
  let valid = call_564360.validator(path, query, header, formData, body)
  let scheme = call_564360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564360.url(scheme.get, call_564360.host, call_564360.base,
                         call_564360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564360, url, valid)

proc call*(call_564361: Call_AvailabilitySetsDelete_564353;
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
  var path_564362 = newJObject()
  var query_564363 = newJObject()
  add(path_564362, "availabilitySetName", newJString(availabilitySetName))
  add(query_564363, "api-version", newJString(apiVersion))
  add(path_564362, "subscriptionId", newJString(subscriptionId))
  add(path_564362, "resourceGroupName", newJString(resourceGroupName))
  result = call_564361.call(path_564362, query_564363, nil, nil, nil)

var availabilitySetsDelete* = Call_AvailabilitySetsDelete_564353(
    name: "availabilitySetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsDelete_564354, base: "",
    url: url_AvailabilitySetsDelete_564355, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsListAvailableSizes_564377 = ref object of OpenApiRestCall_563565
proc url_AvailabilitySetsListAvailableSizes_564379(protocol: Scheme; host: string;
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

proc validate_AvailabilitySetsListAvailableSizes_564378(path: JsonNode;
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
  var valid_564380 = path.getOrDefault("availabilitySetName")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "availabilitySetName", valid_564380
  var valid_564381 = path.getOrDefault("subscriptionId")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "subscriptionId", valid_564381
  var valid_564382 = path.getOrDefault("resourceGroupName")
  valid_564382 = validateParameter(valid_564382, JString, required = true,
                                 default = nil)
  if valid_564382 != nil:
    section.add "resourceGroupName", valid_564382
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564383 = query.getOrDefault("api-version")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = nil)
  if valid_564383 != nil:
    section.add "api-version", valid_564383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564384: Call_AvailabilitySetsListAvailableSizes_564377;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available virtual machine sizes that can be used to create a new virtual machine in an existing availability set.
  ## 
  let valid = call_564384.validator(path, query, header, formData, body)
  let scheme = call_564384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564384.url(scheme.get, call_564384.host, call_564384.base,
                         call_564384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564384, url, valid)

proc call*(call_564385: Call_AvailabilitySetsListAvailableSizes_564377;
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
  var path_564386 = newJObject()
  var query_564387 = newJObject()
  add(path_564386, "availabilitySetName", newJString(availabilitySetName))
  add(query_564387, "api-version", newJString(apiVersion))
  add(path_564386, "subscriptionId", newJString(subscriptionId))
  add(path_564386, "resourceGroupName", newJString(resourceGroupName))
  result = call_564385.call(path_564386, query_564387, nil, nil, nil)

var availabilitySetsListAvailableSizes* = Call_AvailabilitySetsListAvailableSizes_564377(
    name: "availabilitySetsListAvailableSizes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}/vmSizes",
    validator: validate_AvailabilitySetsListAvailableSizes_564378, base: "",
    url: url_AvailabilitySetsListAvailableSizes_564379, schemes: {Scheme.Https})
type
  Call_ImagesListByResourceGroup_564388 = ref object of OpenApiRestCall_563565
proc url_ImagesListByResourceGroup_564390(protocol: Scheme; host: string;
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

proc validate_ImagesListByResourceGroup_564389(path: JsonNode; query: JsonNode;
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
  var valid_564391 = path.getOrDefault("subscriptionId")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "subscriptionId", valid_564391
  var valid_564392 = path.getOrDefault("resourceGroupName")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = nil)
  if valid_564392 != nil:
    section.add "resourceGroupName", valid_564392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564393 = query.getOrDefault("api-version")
  valid_564393 = validateParameter(valid_564393, JString, required = true,
                                 default = nil)
  if valid_564393 != nil:
    section.add "api-version", valid_564393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564394: Call_ImagesListByResourceGroup_564388; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of images under a resource group.
  ## 
  let valid = call_564394.validator(path, query, header, formData, body)
  let scheme = call_564394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564394.url(scheme.get, call_564394.host, call_564394.base,
                         call_564394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564394, url, valid)

proc call*(call_564395: Call_ImagesListByResourceGroup_564388; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## imagesListByResourceGroup
  ## Gets the list of images under a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564396 = newJObject()
  var query_564397 = newJObject()
  add(query_564397, "api-version", newJString(apiVersion))
  add(path_564396, "subscriptionId", newJString(subscriptionId))
  add(path_564396, "resourceGroupName", newJString(resourceGroupName))
  result = call_564395.call(path_564396, query_564397, nil, nil, nil)

var imagesListByResourceGroup* = Call_ImagesListByResourceGroup_564388(
    name: "imagesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images",
    validator: validate_ImagesListByResourceGroup_564389, base: "",
    url: url_ImagesListByResourceGroup_564390, schemes: {Scheme.Https})
type
  Call_ImagesCreateOrUpdate_564410 = ref object of OpenApiRestCall_563565
proc url_ImagesCreateOrUpdate_564412(protocol: Scheme; host: string; base: string;
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

proc validate_ImagesCreateOrUpdate_564411(path: JsonNode; query: JsonNode;
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
  var valid_564413 = path.getOrDefault("imageName")
  valid_564413 = validateParameter(valid_564413, JString, required = true,
                                 default = nil)
  if valid_564413 != nil:
    section.add "imageName", valid_564413
  var valid_564414 = path.getOrDefault("subscriptionId")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "subscriptionId", valid_564414
  var valid_564415 = path.getOrDefault("resourceGroupName")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "resourceGroupName", valid_564415
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564416 = query.getOrDefault("api-version")
  valid_564416 = validateParameter(valid_564416, JString, required = true,
                                 default = nil)
  if valid_564416 != nil:
    section.add "api-version", valid_564416
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

proc call*(call_564418: Call_ImagesCreateOrUpdate_564410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an image.
  ## 
  let valid = call_564418.validator(path, query, header, formData, body)
  let scheme = call_564418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564418.url(scheme.get, call_564418.host, call_564418.base,
                         call_564418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564418, url, valid)

proc call*(call_564419: Call_ImagesCreateOrUpdate_564410; imageName: string;
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
  var path_564420 = newJObject()
  var query_564421 = newJObject()
  var body_564422 = newJObject()
  add(path_564420, "imageName", newJString(imageName))
  add(query_564421, "api-version", newJString(apiVersion))
  add(path_564420, "subscriptionId", newJString(subscriptionId))
  add(path_564420, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564422 = parameters
  result = call_564419.call(path_564420, query_564421, nil, nil, body_564422)

var imagesCreateOrUpdate* = Call_ImagesCreateOrUpdate_564410(
    name: "imagesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesCreateOrUpdate_564411, base: "",
    url: url_ImagesCreateOrUpdate_564412, schemes: {Scheme.Https})
type
  Call_ImagesGet_564398 = ref object of OpenApiRestCall_563565
proc url_ImagesGet_564400(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ImagesGet_564399(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564401 = path.getOrDefault("imageName")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "imageName", valid_564401
  var valid_564402 = path.getOrDefault("subscriptionId")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "subscriptionId", valid_564402
  var valid_564403 = path.getOrDefault("resourceGroupName")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "resourceGroupName", valid_564403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564404 = query.getOrDefault("api-version")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "api-version", valid_564404
  var valid_564405 = query.getOrDefault("$expand")
  valid_564405 = validateParameter(valid_564405, JString, required = false,
                                 default = nil)
  if valid_564405 != nil:
    section.add "$expand", valid_564405
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564406: Call_ImagesGet_564398; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an image.
  ## 
  let valid = call_564406.validator(path, query, header, formData, body)
  let scheme = call_564406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564406.url(scheme.get, call_564406.host, call_564406.base,
                         call_564406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564406, url, valid)

proc call*(call_564407: Call_ImagesGet_564398; imageName: string; apiVersion: string;
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
  var path_564408 = newJObject()
  var query_564409 = newJObject()
  add(path_564408, "imageName", newJString(imageName))
  add(query_564409, "api-version", newJString(apiVersion))
  add(query_564409, "$expand", newJString(Expand))
  add(path_564408, "subscriptionId", newJString(subscriptionId))
  add(path_564408, "resourceGroupName", newJString(resourceGroupName))
  result = call_564407.call(path_564408, query_564409, nil, nil, nil)

var imagesGet* = Call_ImagesGet_564398(name: "imagesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
                                    validator: validate_ImagesGet_564399,
                                    base: "", url: url_ImagesGet_564400,
                                    schemes: {Scheme.Https})
type
  Call_ImagesUpdate_564434 = ref object of OpenApiRestCall_563565
proc url_ImagesUpdate_564436(protocol: Scheme; host: string; base: string;
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

proc validate_ImagesUpdate_564435(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564437 = path.getOrDefault("imageName")
  valid_564437 = validateParameter(valid_564437, JString, required = true,
                                 default = nil)
  if valid_564437 != nil:
    section.add "imageName", valid_564437
  var valid_564438 = path.getOrDefault("subscriptionId")
  valid_564438 = validateParameter(valid_564438, JString, required = true,
                                 default = nil)
  if valid_564438 != nil:
    section.add "subscriptionId", valid_564438
  var valid_564439 = path.getOrDefault("resourceGroupName")
  valid_564439 = validateParameter(valid_564439, JString, required = true,
                                 default = nil)
  if valid_564439 != nil:
    section.add "resourceGroupName", valid_564439
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564440 = query.getOrDefault("api-version")
  valid_564440 = validateParameter(valid_564440, JString, required = true,
                                 default = nil)
  if valid_564440 != nil:
    section.add "api-version", valid_564440
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

proc call*(call_564442: Call_ImagesUpdate_564434; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an image.
  ## 
  let valid = call_564442.validator(path, query, header, formData, body)
  let scheme = call_564442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564442.url(scheme.get, call_564442.host, call_564442.base,
                         call_564442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564442, url, valid)

proc call*(call_564443: Call_ImagesUpdate_564434; imageName: string;
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
  var path_564444 = newJObject()
  var query_564445 = newJObject()
  var body_564446 = newJObject()
  add(path_564444, "imageName", newJString(imageName))
  add(query_564445, "api-version", newJString(apiVersion))
  add(path_564444, "subscriptionId", newJString(subscriptionId))
  add(path_564444, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564446 = parameters
  result = call_564443.call(path_564444, query_564445, nil, nil, body_564446)

var imagesUpdate* = Call_ImagesUpdate_564434(name: "imagesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesUpdate_564435, base: "", url: url_ImagesUpdate_564436,
    schemes: {Scheme.Https})
type
  Call_ImagesDelete_564423 = ref object of OpenApiRestCall_563565
proc url_ImagesDelete_564425(protocol: Scheme; host: string; base: string;
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

proc validate_ImagesDelete_564424(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_564426 = path.getOrDefault("imageName")
  valid_564426 = validateParameter(valid_564426, JString, required = true,
                                 default = nil)
  if valid_564426 != nil:
    section.add "imageName", valid_564426
  var valid_564427 = path.getOrDefault("subscriptionId")
  valid_564427 = validateParameter(valid_564427, JString, required = true,
                                 default = nil)
  if valid_564427 != nil:
    section.add "subscriptionId", valid_564427
  var valid_564428 = path.getOrDefault("resourceGroupName")
  valid_564428 = validateParameter(valid_564428, JString, required = true,
                                 default = nil)
  if valid_564428 != nil:
    section.add "resourceGroupName", valid_564428
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564429 = query.getOrDefault("api-version")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "api-version", valid_564429
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564430: Call_ImagesDelete_564423; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Image.
  ## 
  let valid = call_564430.validator(path, query, header, formData, body)
  let scheme = call_564430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564430.url(scheme.get, call_564430.host, call_564430.base,
                         call_564430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564430, url, valid)

proc call*(call_564431: Call_ImagesDelete_564423; imageName: string;
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
  var path_564432 = newJObject()
  var query_564433 = newJObject()
  add(path_564432, "imageName", newJString(imageName))
  add(query_564433, "api-version", newJString(apiVersion))
  add(path_564432, "subscriptionId", newJString(subscriptionId))
  add(path_564432, "resourceGroupName", newJString(resourceGroupName))
  result = call_564431.call(path_564432, query_564433, nil, nil, nil)

var imagesDelete* = Call_ImagesDelete_564423(name: "imagesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesDelete_564424, base: "", url: url_ImagesDelete_564425,
    schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsListByResourceGroup_564447 = ref object of OpenApiRestCall_563565
proc url_ProximityPlacementGroupsListByResourceGroup_564449(protocol: Scheme;
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

proc validate_ProximityPlacementGroupsListByResourceGroup_564448(path: JsonNode;
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
  var valid_564450 = path.getOrDefault("subscriptionId")
  valid_564450 = validateParameter(valid_564450, JString, required = true,
                                 default = nil)
  if valid_564450 != nil:
    section.add "subscriptionId", valid_564450
  var valid_564451 = path.getOrDefault("resourceGroupName")
  valid_564451 = validateParameter(valid_564451, JString, required = true,
                                 default = nil)
  if valid_564451 != nil:
    section.add "resourceGroupName", valid_564451
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564452 = query.getOrDefault("api-version")
  valid_564452 = validateParameter(valid_564452, JString, required = true,
                                 default = nil)
  if valid_564452 != nil:
    section.add "api-version", valid_564452
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564453: Call_ProximityPlacementGroupsListByResourceGroup_564447;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all proximity placement groups in a resource group.
  ## 
  let valid = call_564453.validator(path, query, header, formData, body)
  let scheme = call_564453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564453.url(scheme.get, call_564453.host, call_564453.base,
                         call_564453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564453, url, valid)

proc call*(call_564454: Call_ProximityPlacementGroupsListByResourceGroup_564447;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## proximityPlacementGroupsListByResourceGroup
  ## Lists all proximity placement groups in a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564455 = newJObject()
  var query_564456 = newJObject()
  add(query_564456, "api-version", newJString(apiVersion))
  add(path_564455, "subscriptionId", newJString(subscriptionId))
  add(path_564455, "resourceGroupName", newJString(resourceGroupName))
  result = call_564454.call(path_564455, query_564456, nil, nil, nil)

var proximityPlacementGroupsListByResourceGroup* = Call_ProximityPlacementGroupsListByResourceGroup_564447(
    name: "proximityPlacementGroupsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups",
    validator: validate_ProximityPlacementGroupsListByResourceGroup_564448,
    base: "", url: url_ProximityPlacementGroupsListByResourceGroup_564449,
    schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsCreateOrUpdate_564468 = ref object of OpenApiRestCall_563565
proc url_ProximityPlacementGroupsCreateOrUpdate_564470(protocol: Scheme;
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

proc validate_ProximityPlacementGroupsCreateOrUpdate_564469(path: JsonNode;
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
  var valid_564471 = path.getOrDefault("proximityPlacementGroupName")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "proximityPlacementGroupName", valid_564471
  var valid_564472 = path.getOrDefault("subscriptionId")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "subscriptionId", valid_564472
  var valid_564473 = path.getOrDefault("resourceGroupName")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "resourceGroupName", valid_564473
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564474 = query.getOrDefault("api-version")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "api-version", valid_564474
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

proc call*(call_564476: Call_ProximityPlacementGroupsCreateOrUpdate_564468;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a proximity placement group.
  ## 
  let valid = call_564476.validator(path, query, header, formData, body)
  let scheme = call_564476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564476.url(scheme.get, call_564476.host, call_564476.base,
                         call_564476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564476, url, valid)

proc call*(call_564477: Call_ProximityPlacementGroupsCreateOrUpdate_564468;
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
  var path_564478 = newJObject()
  var query_564479 = newJObject()
  var body_564480 = newJObject()
  add(query_564479, "api-version", newJString(apiVersion))
  add(path_564478, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  add(path_564478, "subscriptionId", newJString(subscriptionId))
  add(path_564478, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564480 = parameters
  result = call_564477.call(path_564478, query_564479, nil, nil, body_564480)

var proximityPlacementGroupsCreateOrUpdate* = Call_ProximityPlacementGroupsCreateOrUpdate_564468(
    name: "proximityPlacementGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsCreateOrUpdate_564469, base: "",
    url: url_ProximityPlacementGroupsCreateOrUpdate_564470,
    schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsGet_564457 = ref object of OpenApiRestCall_563565
proc url_ProximityPlacementGroupsGet_564459(protocol: Scheme; host: string;
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

proc validate_ProximityPlacementGroupsGet_564458(path: JsonNode; query: JsonNode;
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
  var valid_564460 = path.getOrDefault("proximityPlacementGroupName")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "proximityPlacementGroupName", valid_564460
  var valid_564461 = path.getOrDefault("subscriptionId")
  valid_564461 = validateParameter(valid_564461, JString, required = true,
                                 default = nil)
  if valid_564461 != nil:
    section.add "subscriptionId", valid_564461
  var valid_564462 = path.getOrDefault("resourceGroupName")
  valid_564462 = validateParameter(valid_564462, JString, required = true,
                                 default = nil)
  if valid_564462 != nil:
    section.add "resourceGroupName", valid_564462
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564463 = query.getOrDefault("api-version")
  valid_564463 = validateParameter(valid_564463, JString, required = true,
                                 default = nil)
  if valid_564463 != nil:
    section.add "api-version", valid_564463
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564464: Call_ProximityPlacementGroupsGet_564457; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a proximity placement group .
  ## 
  let valid = call_564464.validator(path, query, header, formData, body)
  let scheme = call_564464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564464.url(scheme.get, call_564464.host, call_564464.base,
                         call_564464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564464, url, valid)

proc call*(call_564465: Call_ProximityPlacementGroupsGet_564457;
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
  var path_564466 = newJObject()
  var query_564467 = newJObject()
  add(query_564467, "api-version", newJString(apiVersion))
  add(path_564466, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  add(path_564466, "subscriptionId", newJString(subscriptionId))
  add(path_564466, "resourceGroupName", newJString(resourceGroupName))
  result = call_564465.call(path_564466, query_564467, nil, nil, nil)

var proximityPlacementGroupsGet* = Call_ProximityPlacementGroupsGet_564457(
    name: "proximityPlacementGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsGet_564458, base: "",
    url: url_ProximityPlacementGroupsGet_564459, schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsUpdate_564492 = ref object of OpenApiRestCall_563565
proc url_ProximityPlacementGroupsUpdate_564494(protocol: Scheme; host: string;
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

proc validate_ProximityPlacementGroupsUpdate_564493(path: JsonNode;
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
  var valid_564495 = path.getOrDefault("proximityPlacementGroupName")
  valid_564495 = validateParameter(valid_564495, JString, required = true,
                                 default = nil)
  if valid_564495 != nil:
    section.add "proximityPlacementGroupName", valid_564495
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564498 = query.getOrDefault("api-version")
  valid_564498 = validateParameter(valid_564498, JString, required = true,
                                 default = nil)
  if valid_564498 != nil:
    section.add "api-version", valid_564498
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

proc call*(call_564500: Call_ProximityPlacementGroupsUpdate_564492; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a proximity placement group.
  ## 
  let valid = call_564500.validator(path, query, header, formData, body)
  let scheme = call_564500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564500.url(scheme.get, call_564500.host, call_564500.base,
                         call_564500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564500, url, valid)

proc call*(call_564501: Call_ProximityPlacementGroupsUpdate_564492;
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
  var path_564502 = newJObject()
  var query_564503 = newJObject()
  var body_564504 = newJObject()
  add(query_564503, "api-version", newJString(apiVersion))
  add(path_564502, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  add(path_564502, "subscriptionId", newJString(subscriptionId))
  add(path_564502, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564504 = parameters
  result = call_564501.call(path_564502, query_564503, nil, nil, body_564504)

var proximityPlacementGroupsUpdate* = Call_ProximityPlacementGroupsUpdate_564492(
    name: "proximityPlacementGroupsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsUpdate_564493, base: "",
    url: url_ProximityPlacementGroupsUpdate_564494, schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsDelete_564481 = ref object of OpenApiRestCall_563565
proc url_ProximityPlacementGroupsDelete_564483(protocol: Scheme; host: string;
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

proc validate_ProximityPlacementGroupsDelete_564482(path: JsonNode;
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
  var valid_564484 = path.getOrDefault("proximityPlacementGroupName")
  valid_564484 = validateParameter(valid_564484, JString, required = true,
                                 default = nil)
  if valid_564484 != nil:
    section.add "proximityPlacementGroupName", valid_564484
  var valid_564485 = path.getOrDefault("subscriptionId")
  valid_564485 = validateParameter(valid_564485, JString, required = true,
                                 default = nil)
  if valid_564485 != nil:
    section.add "subscriptionId", valid_564485
  var valid_564486 = path.getOrDefault("resourceGroupName")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "resourceGroupName", valid_564486
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564487 = query.getOrDefault("api-version")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "api-version", valid_564487
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564488: Call_ProximityPlacementGroupsDelete_564481; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a proximity placement group.
  ## 
  let valid = call_564488.validator(path, query, header, formData, body)
  let scheme = call_564488.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564488.url(scheme.get, call_564488.host, call_564488.base,
                         call_564488.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564488, url, valid)

proc call*(call_564489: Call_ProximityPlacementGroupsDelete_564481;
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
  var path_564490 = newJObject()
  var query_564491 = newJObject()
  add(query_564491, "api-version", newJString(apiVersion))
  add(path_564490, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  add(path_564490, "subscriptionId", newJString(subscriptionId))
  add(path_564490, "resourceGroupName", newJString(resourceGroupName))
  result = call_564489.call(path_564490, query_564491, nil, nil, nil)

var proximityPlacementGroupsDelete* = Call_ProximityPlacementGroupsDelete_564481(
    name: "proximityPlacementGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsDelete_564482, base: "",
    url: url_ProximityPlacementGroupsDelete_564483, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsList_564505 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsList_564507(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsList_564506(path: JsonNode; query: JsonNode;
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
  var valid_564508 = path.getOrDefault("subscriptionId")
  valid_564508 = validateParameter(valid_564508, JString, required = true,
                                 default = nil)
  if valid_564508 != nil:
    section.add "subscriptionId", valid_564508
  var valid_564509 = path.getOrDefault("resourceGroupName")
  valid_564509 = validateParameter(valid_564509, JString, required = true,
                                 default = nil)
  if valid_564509 != nil:
    section.add "resourceGroupName", valid_564509
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564510 = query.getOrDefault("api-version")
  valid_564510 = validateParameter(valid_564510, JString, required = true,
                                 default = nil)
  if valid_564510 != nil:
    section.add "api-version", valid_564510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564511: Call_VirtualMachineScaleSetsList_564505; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all VM scale sets under a resource group.
  ## 
  let valid = call_564511.validator(path, query, header, formData, body)
  let scheme = call_564511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564511.url(scheme.get, call_564511.host, call_564511.base,
                         call_564511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564511, url, valid)

proc call*(call_564512: Call_VirtualMachineScaleSetsList_564505;
          apiVersion: string; subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualMachineScaleSetsList
  ## Gets a list of all VM scale sets under a resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564513 = newJObject()
  var query_564514 = newJObject()
  add(query_564514, "api-version", newJString(apiVersion))
  add(path_564513, "subscriptionId", newJString(subscriptionId))
  add(path_564513, "resourceGroupName", newJString(resourceGroupName))
  result = call_564512.call(path_564513, query_564514, nil, nil, nil)

var virtualMachineScaleSetsList* = Call_VirtualMachineScaleSetsList_564505(
    name: "virtualMachineScaleSetsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets",
    validator: validate_VirtualMachineScaleSetsList_564506, base: "",
    url: url_VirtualMachineScaleSetsList_564507, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsList_564515 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsList_564517(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsList_564516(path: JsonNode; query: JsonNode;
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
  var valid_564518 = path.getOrDefault("subscriptionId")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "subscriptionId", valid_564518
  var valid_564519 = path.getOrDefault("virtualMachineScaleSetName")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = nil)
  if valid_564519 != nil:
    section.add "virtualMachineScaleSetName", valid_564519
  var valid_564520 = path.getOrDefault("resourceGroupName")
  valid_564520 = validateParameter(valid_564520, JString, required = true,
                                 default = nil)
  if valid_564520 != nil:
    section.add "resourceGroupName", valid_564520
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
  var valid_564521 = query.getOrDefault("api-version")
  valid_564521 = validateParameter(valid_564521, JString, required = true,
                                 default = nil)
  if valid_564521 != nil:
    section.add "api-version", valid_564521
  var valid_564522 = query.getOrDefault("$select")
  valid_564522 = validateParameter(valid_564522, JString, required = false,
                                 default = nil)
  if valid_564522 != nil:
    section.add "$select", valid_564522
  var valid_564523 = query.getOrDefault("$expand")
  valid_564523 = validateParameter(valid_564523, JString, required = false,
                                 default = nil)
  if valid_564523 != nil:
    section.add "$expand", valid_564523
  var valid_564524 = query.getOrDefault("$filter")
  valid_564524 = validateParameter(valid_564524, JString, required = false,
                                 default = nil)
  if valid_564524 != nil:
    section.add "$filter", valid_564524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564525: Call_VirtualMachineScaleSetVMsList_564515; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all virtual machines in a VM scale sets.
  ## 
  let valid = call_564525.validator(path, query, header, formData, body)
  let scheme = call_564525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564525.url(scheme.get, call_564525.host, call_564525.base,
                         call_564525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564525, url, valid)

proc call*(call_564526: Call_VirtualMachineScaleSetVMsList_564515;
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
  var path_564527 = newJObject()
  var query_564528 = newJObject()
  add(query_564528, "api-version", newJString(apiVersion))
  add(query_564528, "$select", newJString(Select))
  add(query_564528, "$expand", newJString(Expand))
  add(path_564527, "subscriptionId", newJString(subscriptionId))
  add(path_564527, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  add(path_564527, "resourceGroupName", newJString(resourceGroupName))
  add(query_564528, "$filter", newJString(Filter))
  result = call_564526.call(path_564527, query_564528, nil, nil, nil)

var virtualMachineScaleSetVMsList* = Call_VirtualMachineScaleSetVMsList_564515(
    name: "virtualMachineScaleSetVMsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines",
    validator: validate_VirtualMachineScaleSetVMsList_564516, base: "",
    url: url_VirtualMachineScaleSetVMsList_564517, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsCreateOrUpdate_564540 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsCreateOrUpdate_564542(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsCreateOrUpdate_564541(path: JsonNode;
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
  var valid_564543 = path.getOrDefault("vmScaleSetName")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "vmScaleSetName", valid_564543
  var valid_564544 = path.getOrDefault("subscriptionId")
  valid_564544 = validateParameter(valid_564544, JString, required = true,
                                 default = nil)
  if valid_564544 != nil:
    section.add "subscriptionId", valid_564544
  var valid_564545 = path.getOrDefault("resourceGroupName")
  valid_564545 = validateParameter(valid_564545, JString, required = true,
                                 default = nil)
  if valid_564545 != nil:
    section.add "resourceGroupName", valid_564545
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564546 = query.getOrDefault("api-version")
  valid_564546 = validateParameter(valid_564546, JString, required = true,
                                 default = nil)
  if valid_564546 != nil:
    section.add "api-version", valid_564546
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

proc call*(call_564548: Call_VirtualMachineScaleSetsCreateOrUpdate_564540;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a VM scale set.
  ## 
  let valid = call_564548.validator(path, query, header, formData, body)
  let scheme = call_564548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564548.url(scheme.get, call_564548.host, call_564548.base,
                         call_564548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564548, url, valid)

proc call*(call_564549: Call_VirtualMachineScaleSetsCreateOrUpdate_564540;
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
  var path_564550 = newJObject()
  var query_564551 = newJObject()
  var body_564552 = newJObject()
  add(query_564551, "api-version", newJString(apiVersion))
  add(path_564550, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564550, "subscriptionId", newJString(subscriptionId))
  add(path_564550, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564552 = parameters
  result = call_564549.call(path_564550, query_564551, nil, nil, body_564552)

var virtualMachineScaleSetsCreateOrUpdate* = Call_VirtualMachineScaleSetsCreateOrUpdate_564540(
    name: "virtualMachineScaleSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsCreateOrUpdate_564541, base: "",
    url: url_VirtualMachineScaleSetsCreateOrUpdate_564542, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGet_564529 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsGet_564531(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsGet_564530(path: JsonNode; query: JsonNode;
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
  var valid_564532 = path.getOrDefault("vmScaleSetName")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "vmScaleSetName", valid_564532
  var valid_564533 = path.getOrDefault("subscriptionId")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "subscriptionId", valid_564533
  var valid_564534 = path.getOrDefault("resourceGroupName")
  valid_564534 = validateParameter(valid_564534, JString, required = true,
                                 default = nil)
  if valid_564534 != nil:
    section.add "resourceGroupName", valid_564534
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564535 = query.getOrDefault("api-version")
  valid_564535 = validateParameter(valid_564535, JString, required = true,
                                 default = nil)
  if valid_564535 != nil:
    section.add "api-version", valid_564535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564536: Call_VirtualMachineScaleSetsGet_564529; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Display information about a virtual machine scale set.
  ## 
  let valid = call_564536.validator(path, query, header, formData, body)
  let scheme = call_564536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564536.url(scheme.get, call_564536.host, call_564536.base,
                         call_564536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564536, url, valid)

proc call*(call_564537: Call_VirtualMachineScaleSetsGet_564529; apiVersion: string;
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
  var path_564538 = newJObject()
  var query_564539 = newJObject()
  add(query_564539, "api-version", newJString(apiVersion))
  add(path_564538, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564538, "subscriptionId", newJString(subscriptionId))
  add(path_564538, "resourceGroupName", newJString(resourceGroupName))
  result = call_564537.call(path_564538, query_564539, nil, nil, nil)

var virtualMachineScaleSetsGet* = Call_VirtualMachineScaleSetsGet_564529(
    name: "virtualMachineScaleSetsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsGet_564530, base: "",
    url: url_VirtualMachineScaleSetsGet_564531, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsUpdate_564564 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsUpdate_564566(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsUpdate_564565(path: JsonNode; query: JsonNode;
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
  var valid_564567 = path.getOrDefault("vmScaleSetName")
  valid_564567 = validateParameter(valid_564567, JString, required = true,
                                 default = nil)
  if valid_564567 != nil:
    section.add "vmScaleSetName", valid_564567
  var valid_564568 = path.getOrDefault("subscriptionId")
  valid_564568 = validateParameter(valid_564568, JString, required = true,
                                 default = nil)
  if valid_564568 != nil:
    section.add "subscriptionId", valid_564568
  var valid_564569 = path.getOrDefault("resourceGroupName")
  valid_564569 = validateParameter(valid_564569, JString, required = true,
                                 default = nil)
  if valid_564569 != nil:
    section.add "resourceGroupName", valid_564569
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564570 = query.getOrDefault("api-version")
  valid_564570 = validateParameter(valid_564570, JString, required = true,
                                 default = nil)
  if valid_564570 != nil:
    section.add "api-version", valid_564570
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

proc call*(call_564572: Call_VirtualMachineScaleSetsUpdate_564564; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a VM scale set.
  ## 
  let valid = call_564572.validator(path, query, header, formData, body)
  let scheme = call_564572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564572.url(scheme.get, call_564572.host, call_564572.base,
                         call_564572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564572, url, valid)

proc call*(call_564573: Call_VirtualMachineScaleSetsUpdate_564564;
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
  var path_564574 = newJObject()
  var query_564575 = newJObject()
  var body_564576 = newJObject()
  add(query_564575, "api-version", newJString(apiVersion))
  add(path_564574, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564574, "subscriptionId", newJString(subscriptionId))
  add(path_564574, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564576 = parameters
  result = call_564573.call(path_564574, query_564575, nil, nil, body_564576)

var virtualMachineScaleSetsUpdate* = Call_VirtualMachineScaleSetsUpdate_564564(
    name: "virtualMachineScaleSetsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsUpdate_564565, base: "",
    url: url_VirtualMachineScaleSetsUpdate_564566, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDelete_564553 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsDelete_564555(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsDelete_564554(path: JsonNode; query: JsonNode;
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
  var valid_564556 = path.getOrDefault("vmScaleSetName")
  valid_564556 = validateParameter(valid_564556, JString, required = true,
                                 default = nil)
  if valid_564556 != nil:
    section.add "vmScaleSetName", valid_564556
  var valid_564557 = path.getOrDefault("subscriptionId")
  valid_564557 = validateParameter(valid_564557, JString, required = true,
                                 default = nil)
  if valid_564557 != nil:
    section.add "subscriptionId", valid_564557
  var valid_564558 = path.getOrDefault("resourceGroupName")
  valid_564558 = validateParameter(valid_564558, JString, required = true,
                                 default = nil)
  if valid_564558 != nil:
    section.add "resourceGroupName", valid_564558
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564559 = query.getOrDefault("api-version")
  valid_564559 = validateParameter(valid_564559, JString, required = true,
                                 default = nil)
  if valid_564559 != nil:
    section.add "api-version", valid_564559
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564560: Call_VirtualMachineScaleSetsDelete_564553; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VM scale set.
  ## 
  let valid = call_564560.validator(path, query, header, formData, body)
  let scheme = call_564560.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564560.url(scheme.get, call_564560.host, call_564560.base,
                         call_564560.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564560, url, valid)

proc call*(call_564561: Call_VirtualMachineScaleSetsDelete_564553;
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
  var path_564562 = newJObject()
  var query_564563 = newJObject()
  add(query_564563, "api-version", newJString(apiVersion))
  add(path_564562, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564562, "subscriptionId", newJString(subscriptionId))
  add(path_564562, "resourceGroupName", newJString(resourceGroupName))
  result = call_564561.call(path_564562, query_564563, nil, nil, nil)

var virtualMachineScaleSetsDelete* = Call_VirtualMachineScaleSetsDelete_564553(
    name: "virtualMachineScaleSetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsDelete_564554, base: "",
    url: url_VirtualMachineScaleSetsDelete_564555, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDeallocate_564577 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsDeallocate_564579(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsDeallocate_564578(path: JsonNode;
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
  var valid_564580 = path.getOrDefault("vmScaleSetName")
  valid_564580 = validateParameter(valid_564580, JString, required = true,
                                 default = nil)
  if valid_564580 != nil:
    section.add "vmScaleSetName", valid_564580
  var valid_564581 = path.getOrDefault("subscriptionId")
  valid_564581 = validateParameter(valid_564581, JString, required = true,
                                 default = nil)
  if valid_564581 != nil:
    section.add "subscriptionId", valid_564581
  var valid_564582 = path.getOrDefault("resourceGroupName")
  valid_564582 = validateParameter(valid_564582, JString, required = true,
                                 default = nil)
  if valid_564582 != nil:
    section.add "resourceGroupName", valid_564582
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564583 = query.getOrDefault("api-version")
  valid_564583 = validateParameter(valid_564583, JString, required = true,
                                 default = nil)
  if valid_564583 != nil:
    section.add "api-version", valid_564583
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

proc call*(call_564585: Call_VirtualMachineScaleSetsDeallocate_564577;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deallocates specific virtual machines in a VM scale set. Shuts down the virtual machines and releases the compute resources. You are not billed for the compute resources that this virtual machine scale set deallocates.
  ## 
  let valid = call_564585.validator(path, query, header, formData, body)
  let scheme = call_564585.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564585.url(scheme.get, call_564585.host, call_564585.base,
                         call_564585.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564585, url, valid)

proc call*(call_564586: Call_VirtualMachineScaleSetsDeallocate_564577;
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
  var path_564587 = newJObject()
  var query_564588 = newJObject()
  var body_564589 = newJObject()
  add(query_564588, "api-version", newJString(apiVersion))
  add(path_564587, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564587, "subscriptionId", newJString(subscriptionId))
  add(path_564587, "resourceGroupName", newJString(resourceGroupName))
  if vmInstanceIDs != nil:
    body_564589 = vmInstanceIDs
  result = call_564586.call(path_564587, query_564588, nil, nil, body_564589)

var virtualMachineScaleSetsDeallocate* = Call_VirtualMachineScaleSetsDeallocate_564577(
    name: "virtualMachineScaleSetsDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/deallocate",
    validator: validate_VirtualMachineScaleSetsDeallocate_564578, base: "",
    url: url_VirtualMachineScaleSetsDeallocate_564579, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDeleteInstances_564590 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsDeleteInstances_564592(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsDeleteInstances_564591(path: JsonNode;
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
  var valid_564593 = path.getOrDefault("vmScaleSetName")
  valid_564593 = validateParameter(valid_564593, JString, required = true,
                                 default = nil)
  if valid_564593 != nil:
    section.add "vmScaleSetName", valid_564593
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
  ## parameters in `body` object:
  ##   vmInstanceIDs: JObject (required)
  ##                : A list of virtual machine instance IDs from the VM scale set.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564598: Call_VirtualMachineScaleSetsDeleteInstances_564590;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes virtual machines in a VM scale set.
  ## 
  let valid = call_564598.validator(path, query, header, formData, body)
  let scheme = call_564598.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564598.url(scheme.get, call_564598.host, call_564598.base,
                         call_564598.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564598, url, valid)

proc call*(call_564599: Call_VirtualMachineScaleSetsDeleteInstances_564590;
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
  var path_564600 = newJObject()
  var query_564601 = newJObject()
  var body_564602 = newJObject()
  add(query_564601, "api-version", newJString(apiVersion))
  add(path_564600, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564600, "subscriptionId", newJString(subscriptionId))
  add(path_564600, "resourceGroupName", newJString(resourceGroupName))
  if vmInstanceIDs != nil:
    body_564602 = vmInstanceIDs
  result = call_564599.call(path_564600, query_564601, nil, nil, body_564602)

var virtualMachineScaleSetsDeleteInstances* = Call_VirtualMachineScaleSetsDeleteInstances_564590(
    name: "virtualMachineScaleSetsDeleteInstances", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/delete",
    validator: validate_VirtualMachineScaleSetsDeleteInstances_564591, base: "",
    url: url_VirtualMachineScaleSetsDeleteInstances_564592,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsList_564603 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetExtensionsList_564605(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetExtensionsList_564604(path: JsonNode;
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
  var valid_564606 = path.getOrDefault("vmScaleSetName")
  valid_564606 = validateParameter(valid_564606, JString, required = true,
                                 default = nil)
  if valid_564606 != nil:
    section.add "vmScaleSetName", valid_564606
  var valid_564607 = path.getOrDefault("subscriptionId")
  valid_564607 = validateParameter(valid_564607, JString, required = true,
                                 default = nil)
  if valid_564607 != nil:
    section.add "subscriptionId", valid_564607
  var valid_564608 = path.getOrDefault("resourceGroupName")
  valid_564608 = validateParameter(valid_564608, JString, required = true,
                                 default = nil)
  if valid_564608 != nil:
    section.add "resourceGroupName", valid_564608
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564609 = query.getOrDefault("api-version")
  valid_564609 = validateParameter(valid_564609, JString, required = true,
                                 default = nil)
  if valid_564609 != nil:
    section.add "api-version", valid_564609
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564610: Call_VirtualMachineScaleSetExtensionsList_564603;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of all extensions in a VM scale set.
  ## 
  let valid = call_564610.validator(path, query, header, formData, body)
  let scheme = call_564610.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564610.url(scheme.get, call_564610.host, call_564610.base,
                         call_564610.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564610, url, valid)

proc call*(call_564611: Call_VirtualMachineScaleSetExtensionsList_564603;
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
  var path_564612 = newJObject()
  var query_564613 = newJObject()
  add(query_564613, "api-version", newJString(apiVersion))
  add(path_564612, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564612, "subscriptionId", newJString(subscriptionId))
  add(path_564612, "resourceGroupName", newJString(resourceGroupName))
  result = call_564611.call(path_564612, query_564613, nil, nil, nil)

var virtualMachineScaleSetExtensionsList* = Call_VirtualMachineScaleSetExtensionsList_564603(
    name: "virtualMachineScaleSetExtensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions",
    validator: validate_VirtualMachineScaleSetExtensionsList_564604, base: "",
    url: url_VirtualMachineScaleSetExtensionsList_564605, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_564627 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetExtensionsCreateOrUpdate_564629(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetExtensionsCreateOrUpdate_564628(
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
  var valid_564630 = path.getOrDefault("vmScaleSetName")
  valid_564630 = validateParameter(valid_564630, JString, required = true,
                                 default = nil)
  if valid_564630 != nil:
    section.add "vmScaleSetName", valid_564630
  var valid_564631 = path.getOrDefault("subscriptionId")
  valid_564631 = validateParameter(valid_564631, JString, required = true,
                                 default = nil)
  if valid_564631 != nil:
    section.add "subscriptionId", valid_564631
  var valid_564632 = path.getOrDefault("resourceGroupName")
  valid_564632 = validateParameter(valid_564632, JString, required = true,
                                 default = nil)
  if valid_564632 != nil:
    section.add "resourceGroupName", valid_564632
  var valid_564633 = path.getOrDefault("vmssExtensionName")
  valid_564633 = validateParameter(valid_564633, JString, required = true,
                                 default = nil)
  if valid_564633 != nil:
    section.add "vmssExtensionName", valid_564633
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564634 = query.getOrDefault("api-version")
  valid_564634 = validateParameter(valid_564634, JString, required = true,
                                 default = nil)
  if valid_564634 != nil:
    section.add "api-version", valid_564634
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

proc call*(call_564636: Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_564627;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update an extension.
  ## 
  let valid = call_564636.validator(path, query, header, formData, body)
  let scheme = call_564636.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564636.url(scheme.get, call_564636.host, call_564636.base,
                         call_564636.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564636, url, valid)

proc call*(call_564637: Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_564627;
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
  var path_564638 = newJObject()
  var query_564639 = newJObject()
  var body_564640 = newJObject()
  add(query_564639, "api-version", newJString(apiVersion))
  add(path_564638, "vmScaleSetName", newJString(vmScaleSetName))
  if extensionParameters != nil:
    body_564640 = extensionParameters
  add(path_564638, "subscriptionId", newJString(subscriptionId))
  add(path_564638, "resourceGroupName", newJString(resourceGroupName))
  add(path_564638, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_564637.call(path_564638, query_564639, nil, nil, body_564640)

var virtualMachineScaleSetExtensionsCreateOrUpdate* = Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_564627(
    name: "virtualMachineScaleSetExtensionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsCreateOrUpdate_564628,
    base: "", url: url_VirtualMachineScaleSetExtensionsCreateOrUpdate_564629,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsGet_564614 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetExtensionsGet_564616(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetExtensionsGet_564615(path: JsonNode;
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
  var valid_564617 = path.getOrDefault("vmScaleSetName")
  valid_564617 = validateParameter(valid_564617, JString, required = true,
                                 default = nil)
  if valid_564617 != nil:
    section.add "vmScaleSetName", valid_564617
  var valid_564618 = path.getOrDefault("subscriptionId")
  valid_564618 = validateParameter(valid_564618, JString, required = true,
                                 default = nil)
  if valid_564618 != nil:
    section.add "subscriptionId", valid_564618
  var valid_564619 = path.getOrDefault("resourceGroupName")
  valid_564619 = validateParameter(valid_564619, JString, required = true,
                                 default = nil)
  if valid_564619 != nil:
    section.add "resourceGroupName", valid_564619
  var valid_564620 = path.getOrDefault("vmssExtensionName")
  valid_564620 = validateParameter(valid_564620, JString, required = true,
                                 default = nil)
  if valid_564620 != nil:
    section.add "vmssExtensionName", valid_564620
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564621 = query.getOrDefault("api-version")
  valid_564621 = validateParameter(valid_564621, JString, required = true,
                                 default = nil)
  if valid_564621 != nil:
    section.add "api-version", valid_564621
  var valid_564622 = query.getOrDefault("$expand")
  valid_564622 = validateParameter(valid_564622, JString, required = false,
                                 default = nil)
  if valid_564622 != nil:
    section.add "$expand", valid_564622
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564623: Call_VirtualMachineScaleSetExtensionsGet_564614;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to get the extension.
  ## 
  let valid = call_564623.validator(path, query, header, formData, body)
  let scheme = call_564623.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564623.url(scheme.get, call_564623.host, call_564623.base,
                         call_564623.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564623, url, valid)

proc call*(call_564624: Call_VirtualMachineScaleSetExtensionsGet_564614;
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
  var path_564625 = newJObject()
  var query_564626 = newJObject()
  add(query_564626, "api-version", newJString(apiVersion))
  add(path_564625, "vmScaleSetName", newJString(vmScaleSetName))
  add(query_564626, "$expand", newJString(Expand))
  add(path_564625, "subscriptionId", newJString(subscriptionId))
  add(path_564625, "resourceGroupName", newJString(resourceGroupName))
  add(path_564625, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_564624.call(path_564625, query_564626, nil, nil, nil)

var virtualMachineScaleSetExtensionsGet* = Call_VirtualMachineScaleSetExtensionsGet_564614(
    name: "virtualMachineScaleSetExtensionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsGet_564615, base: "",
    url: url_VirtualMachineScaleSetExtensionsGet_564616, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsDelete_564641 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetExtensionsDelete_564643(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetExtensionsDelete_564642(path: JsonNode;
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
  var valid_564644 = path.getOrDefault("vmScaleSetName")
  valid_564644 = validateParameter(valid_564644, JString, required = true,
                                 default = nil)
  if valid_564644 != nil:
    section.add "vmScaleSetName", valid_564644
  var valid_564645 = path.getOrDefault("subscriptionId")
  valid_564645 = validateParameter(valid_564645, JString, required = true,
                                 default = nil)
  if valid_564645 != nil:
    section.add "subscriptionId", valid_564645
  var valid_564646 = path.getOrDefault("resourceGroupName")
  valid_564646 = validateParameter(valid_564646, JString, required = true,
                                 default = nil)
  if valid_564646 != nil:
    section.add "resourceGroupName", valid_564646
  var valid_564647 = path.getOrDefault("vmssExtensionName")
  valid_564647 = validateParameter(valid_564647, JString, required = true,
                                 default = nil)
  if valid_564647 != nil:
    section.add "vmssExtensionName", valid_564647
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564648 = query.getOrDefault("api-version")
  valid_564648 = validateParameter(valid_564648, JString, required = true,
                                 default = nil)
  if valid_564648 != nil:
    section.add "api-version", valid_564648
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564649: Call_VirtualMachineScaleSetExtensionsDelete_564641;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete the extension.
  ## 
  let valid = call_564649.validator(path, query, header, formData, body)
  let scheme = call_564649.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564649.url(scheme.get, call_564649.host, call_564649.base,
                         call_564649.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564649, url, valid)

proc call*(call_564650: Call_VirtualMachineScaleSetExtensionsDelete_564641;
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
  var path_564651 = newJObject()
  var query_564652 = newJObject()
  add(query_564652, "api-version", newJString(apiVersion))
  add(path_564651, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564651, "subscriptionId", newJString(subscriptionId))
  add(path_564651, "resourceGroupName", newJString(resourceGroupName))
  add(path_564651, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_564650.call(path_564651, query_564652, nil, nil, nil)

var virtualMachineScaleSetExtensionsDelete* = Call_VirtualMachineScaleSetExtensionsDelete_564641(
    name: "virtualMachineScaleSetExtensionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsDelete_564642, base: "",
    url: url_VirtualMachineScaleSetExtensionsDelete_564643,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_564653 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_564655(
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

proc validate_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_564654(
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
  var valid_564656 = path.getOrDefault("vmScaleSetName")
  valid_564656 = validateParameter(valid_564656, JString, required = true,
                                 default = nil)
  if valid_564656 != nil:
    section.add "vmScaleSetName", valid_564656
  var valid_564657 = path.getOrDefault("subscriptionId")
  valid_564657 = validateParameter(valid_564657, JString, required = true,
                                 default = nil)
  if valid_564657 != nil:
    section.add "subscriptionId", valid_564657
  var valid_564658 = path.getOrDefault("resourceGroupName")
  valid_564658 = validateParameter(valid_564658, JString, required = true,
                                 default = nil)
  if valid_564658 != nil:
    section.add "resourceGroupName", valid_564658
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   platformUpdateDomain: JInt (required)
  ##                       : The platform update domain for which a manual recovery walk is requested
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564659 = query.getOrDefault("api-version")
  valid_564659 = validateParameter(valid_564659, JString, required = true,
                                 default = nil)
  if valid_564659 != nil:
    section.add "api-version", valid_564659
  var valid_564660 = query.getOrDefault("platformUpdateDomain")
  valid_564660 = validateParameter(valid_564660, JInt, required = true, default = nil)
  if valid_564660 != nil:
    section.add "platformUpdateDomain", valid_564660
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564661: Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_564653;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Manual platform update domain walk to update virtual machines in a service fabric virtual machine scale set.
  ## 
  let valid = call_564661.validator(path, query, header, formData, body)
  let scheme = call_564661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564661.url(scheme.get, call_564661.host, call_564661.base,
                         call_564661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564661, url, valid)

proc call*(call_564662: Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_564653;
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
  var path_564663 = newJObject()
  var query_564664 = newJObject()
  add(query_564664, "api-version", newJString(apiVersion))
  add(path_564663, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564663, "subscriptionId", newJString(subscriptionId))
  add(path_564663, "resourceGroupName", newJString(resourceGroupName))
  add(query_564664, "platformUpdateDomain", newJInt(platformUpdateDomain))
  result = call_564662.call(path_564663, query_564664, nil, nil, nil)

var virtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk* = Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_564653(name: "virtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/forceRecoveryServiceFabricPlatformUpdateDomainWalk", validator: validate_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_564654,
    base: "", url: url_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_564655,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGetInstanceView_564665 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsGetInstanceView_564667(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsGetInstanceView_564666(path: JsonNode;
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
  var valid_564668 = path.getOrDefault("vmScaleSetName")
  valid_564668 = validateParameter(valid_564668, JString, required = true,
                                 default = nil)
  if valid_564668 != nil:
    section.add "vmScaleSetName", valid_564668
  var valid_564669 = path.getOrDefault("subscriptionId")
  valid_564669 = validateParameter(valid_564669, JString, required = true,
                                 default = nil)
  if valid_564669 != nil:
    section.add "subscriptionId", valid_564669
  var valid_564670 = path.getOrDefault("resourceGroupName")
  valid_564670 = validateParameter(valid_564670, JString, required = true,
                                 default = nil)
  if valid_564670 != nil:
    section.add "resourceGroupName", valid_564670
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564671 = query.getOrDefault("api-version")
  valid_564671 = validateParameter(valid_564671, JString, required = true,
                                 default = nil)
  if valid_564671 != nil:
    section.add "api-version", valid_564671
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564672: Call_VirtualMachineScaleSetsGetInstanceView_564665;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of a VM scale set instance.
  ## 
  let valid = call_564672.validator(path, query, header, formData, body)
  let scheme = call_564672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564672.url(scheme.get, call_564672.host, call_564672.base,
                         call_564672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564672, url, valid)

proc call*(call_564673: Call_VirtualMachineScaleSetsGetInstanceView_564665;
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
  var path_564674 = newJObject()
  var query_564675 = newJObject()
  add(query_564675, "api-version", newJString(apiVersion))
  add(path_564674, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564674, "subscriptionId", newJString(subscriptionId))
  add(path_564674, "resourceGroupName", newJString(resourceGroupName))
  result = call_564673.call(path_564674, query_564675, nil, nil, nil)

var virtualMachineScaleSetsGetInstanceView* = Call_VirtualMachineScaleSetsGetInstanceView_564665(
    name: "virtualMachineScaleSetsGetInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/instanceView",
    validator: validate_VirtualMachineScaleSetsGetInstanceView_564666, base: "",
    url: url_VirtualMachineScaleSetsGetInstanceView_564667,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsUpdateInstances_564676 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsUpdateInstances_564678(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsUpdateInstances_564677(path: JsonNode;
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
  var valid_564679 = path.getOrDefault("vmScaleSetName")
  valid_564679 = validateParameter(valid_564679, JString, required = true,
                                 default = nil)
  if valid_564679 != nil:
    section.add "vmScaleSetName", valid_564679
  var valid_564680 = path.getOrDefault("subscriptionId")
  valid_564680 = validateParameter(valid_564680, JString, required = true,
                                 default = nil)
  if valid_564680 != nil:
    section.add "subscriptionId", valid_564680
  var valid_564681 = path.getOrDefault("resourceGroupName")
  valid_564681 = validateParameter(valid_564681, JString, required = true,
                                 default = nil)
  if valid_564681 != nil:
    section.add "resourceGroupName", valid_564681
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564682 = query.getOrDefault("api-version")
  valid_564682 = validateParameter(valid_564682, JString, required = true,
                                 default = nil)
  if valid_564682 != nil:
    section.add "api-version", valid_564682
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

proc call*(call_564684: Call_VirtualMachineScaleSetsUpdateInstances_564676;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upgrades one or more virtual machines to the latest SKU set in the VM scale set model.
  ## 
  let valid = call_564684.validator(path, query, header, formData, body)
  let scheme = call_564684.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564684.url(scheme.get, call_564684.host, call_564684.base,
                         call_564684.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564684, url, valid)

proc call*(call_564685: Call_VirtualMachineScaleSetsUpdateInstances_564676;
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
  var path_564686 = newJObject()
  var query_564687 = newJObject()
  var body_564688 = newJObject()
  add(query_564687, "api-version", newJString(apiVersion))
  add(path_564686, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564686, "subscriptionId", newJString(subscriptionId))
  add(path_564686, "resourceGroupName", newJString(resourceGroupName))
  if vmInstanceIDs != nil:
    body_564688 = vmInstanceIDs
  result = call_564685.call(path_564686, query_564687, nil, nil, body_564688)

var virtualMachineScaleSetsUpdateInstances* = Call_VirtualMachineScaleSetsUpdateInstances_564676(
    name: "virtualMachineScaleSetsUpdateInstances", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/manualupgrade",
    validator: validate_VirtualMachineScaleSetsUpdateInstances_564677, base: "",
    url: url_VirtualMachineScaleSetsUpdateInstances_564678,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_564689 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_564691(
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

proc validate_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_564690(
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
  var valid_564692 = path.getOrDefault("vmScaleSetName")
  valid_564692 = validateParameter(valid_564692, JString, required = true,
                                 default = nil)
  if valid_564692 != nil:
    section.add "vmScaleSetName", valid_564692
  var valid_564693 = path.getOrDefault("subscriptionId")
  valid_564693 = validateParameter(valid_564693, JString, required = true,
                                 default = nil)
  if valid_564693 != nil:
    section.add "subscriptionId", valid_564693
  var valid_564694 = path.getOrDefault("resourceGroupName")
  valid_564694 = validateParameter(valid_564694, JString, required = true,
                                 default = nil)
  if valid_564694 != nil:
    section.add "resourceGroupName", valid_564694
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564695 = query.getOrDefault("api-version")
  valid_564695 = validateParameter(valid_564695, JString, required = true,
                                 default = nil)
  if valid_564695 != nil:
    section.add "api-version", valid_564695
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564696: Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_564689;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a rolling upgrade to move all virtual machine scale set instances to the latest available Platform Image OS version. Instances which are already running the latest available OS version are not affected.
  ## 
  let valid = call_564696.validator(path, query, header, formData, body)
  let scheme = call_564696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564696.url(scheme.get, call_564696.host, call_564696.base,
                         call_564696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564696, url, valid)

proc call*(call_564697: Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_564689;
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
  var path_564698 = newJObject()
  var query_564699 = newJObject()
  add(query_564699, "api-version", newJString(apiVersion))
  add(path_564698, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564698, "subscriptionId", newJString(subscriptionId))
  add(path_564698, "resourceGroupName", newJString(resourceGroupName))
  result = call_564697.call(path_564698, query_564699, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesStartOSUpgrade* = Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_564689(
    name: "virtualMachineScaleSetRollingUpgradesStartOSUpgrade",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/osRollingUpgrade",
    validator: validate_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_564690,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_564691,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGetOSUpgradeHistory_564700 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsGetOSUpgradeHistory_564702(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsGetOSUpgradeHistory_564701(path: JsonNode;
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
  var valid_564703 = path.getOrDefault("vmScaleSetName")
  valid_564703 = validateParameter(valid_564703, JString, required = true,
                                 default = nil)
  if valid_564703 != nil:
    section.add "vmScaleSetName", valid_564703
  var valid_564704 = path.getOrDefault("subscriptionId")
  valid_564704 = validateParameter(valid_564704, JString, required = true,
                                 default = nil)
  if valid_564704 != nil:
    section.add "subscriptionId", valid_564704
  var valid_564705 = path.getOrDefault("resourceGroupName")
  valid_564705 = validateParameter(valid_564705, JString, required = true,
                                 default = nil)
  if valid_564705 != nil:
    section.add "resourceGroupName", valid_564705
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564706 = query.getOrDefault("api-version")
  valid_564706 = validateParameter(valid_564706, JString, required = true,
                                 default = nil)
  if valid_564706 != nil:
    section.add "api-version", valid_564706
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564707: Call_VirtualMachineScaleSetsGetOSUpgradeHistory_564700;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets list of OS upgrades on a VM scale set instance.
  ## 
  let valid = call_564707.validator(path, query, header, formData, body)
  let scheme = call_564707.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564707.url(scheme.get, call_564707.host, call_564707.base,
                         call_564707.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564707, url, valid)

proc call*(call_564708: Call_VirtualMachineScaleSetsGetOSUpgradeHistory_564700;
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
  var path_564709 = newJObject()
  var query_564710 = newJObject()
  add(query_564710, "api-version", newJString(apiVersion))
  add(path_564709, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564709, "subscriptionId", newJString(subscriptionId))
  add(path_564709, "resourceGroupName", newJString(resourceGroupName))
  result = call_564708.call(path_564709, query_564710, nil, nil, nil)

var virtualMachineScaleSetsGetOSUpgradeHistory* = Call_VirtualMachineScaleSetsGetOSUpgradeHistory_564700(
    name: "virtualMachineScaleSetsGetOSUpgradeHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/osUpgradeHistory",
    validator: validate_VirtualMachineScaleSetsGetOSUpgradeHistory_564701,
    base: "", url: url_VirtualMachineScaleSetsGetOSUpgradeHistory_564702,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsPerformMaintenance_564711 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsPerformMaintenance_564713(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsPerformMaintenance_564712(path: JsonNode;
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
  var valid_564714 = path.getOrDefault("vmScaleSetName")
  valid_564714 = validateParameter(valid_564714, JString, required = true,
                                 default = nil)
  if valid_564714 != nil:
    section.add "vmScaleSetName", valid_564714
  var valid_564715 = path.getOrDefault("subscriptionId")
  valid_564715 = validateParameter(valid_564715, JString, required = true,
                                 default = nil)
  if valid_564715 != nil:
    section.add "subscriptionId", valid_564715
  var valid_564716 = path.getOrDefault("resourceGroupName")
  valid_564716 = validateParameter(valid_564716, JString, required = true,
                                 default = nil)
  if valid_564716 != nil:
    section.add "resourceGroupName", valid_564716
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564717 = query.getOrDefault("api-version")
  valid_564717 = validateParameter(valid_564717, JString, required = true,
                                 default = nil)
  if valid_564717 != nil:
    section.add "api-version", valid_564717
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

proc call*(call_564719: Call_VirtualMachineScaleSetsPerformMaintenance_564711;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Perform maintenance on one or more virtual machines in a VM scale set. Operation on instances which are not eligible for perform maintenance will be failed. Please refer to best practices for more details: https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-maintenance-notifications
  ## 
  let valid = call_564719.validator(path, query, header, formData, body)
  let scheme = call_564719.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564719.url(scheme.get, call_564719.host, call_564719.base,
                         call_564719.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564719, url, valid)

proc call*(call_564720: Call_VirtualMachineScaleSetsPerformMaintenance_564711;
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
  var path_564721 = newJObject()
  var query_564722 = newJObject()
  var body_564723 = newJObject()
  add(query_564722, "api-version", newJString(apiVersion))
  add(path_564721, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564721, "subscriptionId", newJString(subscriptionId))
  add(path_564721, "resourceGroupName", newJString(resourceGroupName))
  if vmInstanceIDs != nil:
    body_564723 = vmInstanceIDs
  result = call_564720.call(path_564721, query_564722, nil, nil, body_564723)

var virtualMachineScaleSetsPerformMaintenance* = Call_VirtualMachineScaleSetsPerformMaintenance_564711(
    name: "virtualMachineScaleSetsPerformMaintenance", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/performMaintenance",
    validator: validate_VirtualMachineScaleSetsPerformMaintenance_564712,
    base: "", url: url_VirtualMachineScaleSetsPerformMaintenance_564713,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsPowerOff_564724 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsPowerOff_564726(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsPowerOff_564725(path: JsonNode;
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
  var valid_564727 = path.getOrDefault("vmScaleSetName")
  valid_564727 = validateParameter(valid_564727, JString, required = true,
                                 default = nil)
  if valid_564727 != nil:
    section.add "vmScaleSetName", valid_564727
  var valid_564728 = path.getOrDefault("subscriptionId")
  valid_564728 = validateParameter(valid_564728, JString, required = true,
                                 default = nil)
  if valid_564728 != nil:
    section.add "subscriptionId", valid_564728
  var valid_564729 = path.getOrDefault("resourceGroupName")
  valid_564729 = validateParameter(valid_564729, JString, required = true,
                                 default = nil)
  if valid_564729 != nil:
    section.add "resourceGroupName", valid_564729
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564730 = query.getOrDefault("api-version")
  valid_564730 = validateParameter(valid_564730, JString, required = true,
                                 default = nil)
  if valid_564730 != nil:
    section.add "api-version", valid_564730
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

proc call*(call_564732: Call_VirtualMachineScaleSetsPowerOff_564724;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Power off (stop) one or more virtual machines in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  let valid = call_564732.validator(path, query, header, formData, body)
  let scheme = call_564732.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564732.url(scheme.get, call_564732.host, call_564732.base,
                         call_564732.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564732, url, valid)

proc call*(call_564733: Call_VirtualMachineScaleSetsPowerOff_564724;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; vmInstanceIDs: JsonNode = nil): Recallable =
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
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_564734 = newJObject()
  var query_564735 = newJObject()
  var body_564736 = newJObject()
  add(query_564735, "api-version", newJString(apiVersion))
  add(path_564734, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564734, "subscriptionId", newJString(subscriptionId))
  add(path_564734, "resourceGroupName", newJString(resourceGroupName))
  if vmInstanceIDs != nil:
    body_564736 = vmInstanceIDs
  result = call_564733.call(path_564734, query_564735, nil, nil, body_564736)

var virtualMachineScaleSetsPowerOff* = Call_VirtualMachineScaleSetsPowerOff_564724(
    name: "virtualMachineScaleSetsPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/poweroff",
    validator: validate_VirtualMachineScaleSetsPowerOff_564725, base: "",
    url: url_VirtualMachineScaleSetsPowerOff_564726, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsRedeploy_564737 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsRedeploy_564739(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsRedeploy_564738(path: JsonNode;
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
  var valid_564740 = path.getOrDefault("vmScaleSetName")
  valid_564740 = validateParameter(valid_564740, JString, required = true,
                                 default = nil)
  if valid_564740 != nil:
    section.add "vmScaleSetName", valid_564740
  var valid_564741 = path.getOrDefault("subscriptionId")
  valid_564741 = validateParameter(valid_564741, JString, required = true,
                                 default = nil)
  if valid_564741 != nil:
    section.add "subscriptionId", valid_564741
  var valid_564742 = path.getOrDefault("resourceGroupName")
  valid_564742 = validateParameter(valid_564742, JString, required = true,
                                 default = nil)
  if valid_564742 != nil:
    section.add "resourceGroupName", valid_564742
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564743 = query.getOrDefault("api-version")
  valid_564743 = validateParameter(valid_564743, JString, required = true,
                                 default = nil)
  if valid_564743 != nil:
    section.add "api-version", valid_564743
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

proc call*(call_564745: Call_VirtualMachineScaleSetsRedeploy_564737;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Shuts down all the virtual machines in the virtual machine scale set, moves them to a new node, and powers them back on.
  ## 
  let valid = call_564745.validator(path, query, header, formData, body)
  let scheme = call_564745.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564745.url(scheme.get, call_564745.host, call_564745.base,
                         call_564745.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564745, url, valid)

proc call*(call_564746: Call_VirtualMachineScaleSetsRedeploy_564737;
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
  var path_564747 = newJObject()
  var query_564748 = newJObject()
  var body_564749 = newJObject()
  add(query_564748, "api-version", newJString(apiVersion))
  add(path_564747, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564747, "subscriptionId", newJString(subscriptionId))
  add(path_564747, "resourceGroupName", newJString(resourceGroupName))
  if vmInstanceIDs != nil:
    body_564749 = vmInstanceIDs
  result = call_564746.call(path_564747, query_564748, nil, nil, body_564749)

var virtualMachineScaleSetsRedeploy* = Call_VirtualMachineScaleSetsRedeploy_564737(
    name: "virtualMachineScaleSetsRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/redeploy",
    validator: validate_VirtualMachineScaleSetsRedeploy_564738, base: "",
    url: url_VirtualMachineScaleSetsRedeploy_564739, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsReimage_564750 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsReimage_564752(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsReimage_564751(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reimages (upgrade the operating system) one or more virtual machines in a VM scale set.
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
  var valid_564753 = path.getOrDefault("vmScaleSetName")
  valid_564753 = validateParameter(valid_564753, JString, required = true,
                                 default = nil)
  if valid_564753 != nil:
    section.add "vmScaleSetName", valid_564753
  var valid_564754 = path.getOrDefault("subscriptionId")
  valid_564754 = validateParameter(valid_564754, JString, required = true,
                                 default = nil)
  if valid_564754 != nil:
    section.add "subscriptionId", valid_564754
  var valid_564755 = path.getOrDefault("resourceGroupName")
  valid_564755 = validateParameter(valid_564755, JString, required = true,
                                 default = nil)
  if valid_564755 != nil:
    section.add "resourceGroupName", valid_564755
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564756 = query.getOrDefault("api-version")
  valid_564756 = validateParameter(valid_564756, JString, required = true,
                                 default = nil)
  if valid_564756 != nil:
    section.add "api-version", valid_564756
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

proc call*(call_564758: Call_VirtualMachineScaleSetsReimage_564750; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reimages (upgrade the operating system) one or more virtual machines in a VM scale set.
  ## 
  let valid = call_564758.validator(path, query, header, formData, body)
  let scheme = call_564758.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564758.url(scheme.get, call_564758.host, call_564758.base,
                         call_564758.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564758, url, valid)

proc call*(call_564759: Call_VirtualMachineScaleSetsReimage_564750;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsReimage
  ## Reimages (upgrade the operating system) one or more virtual machines in a VM scale set.
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
  var path_564760 = newJObject()
  var query_564761 = newJObject()
  var body_564762 = newJObject()
  add(query_564761, "api-version", newJString(apiVersion))
  add(path_564760, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564760, "subscriptionId", newJString(subscriptionId))
  add(path_564760, "resourceGroupName", newJString(resourceGroupName))
  if vmInstanceIDs != nil:
    body_564762 = vmInstanceIDs
  result = call_564759.call(path_564760, query_564761, nil, nil, body_564762)

var virtualMachineScaleSetsReimage* = Call_VirtualMachineScaleSetsReimage_564750(
    name: "virtualMachineScaleSetsReimage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/reimage",
    validator: validate_VirtualMachineScaleSetsReimage_564751, base: "",
    url: url_VirtualMachineScaleSetsReimage_564752, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsReimageAll_564763 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsReimageAll_564765(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsReimageAll_564764(path: JsonNode;
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
  var valid_564766 = path.getOrDefault("vmScaleSetName")
  valid_564766 = validateParameter(valid_564766, JString, required = true,
                                 default = nil)
  if valid_564766 != nil:
    section.add "vmScaleSetName", valid_564766
  var valid_564767 = path.getOrDefault("subscriptionId")
  valid_564767 = validateParameter(valid_564767, JString, required = true,
                                 default = nil)
  if valid_564767 != nil:
    section.add "subscriptionId", valid_564767
  var valid_564768 = path.getOrDefault("resourceGroupName")
  valid_564768 = validateParameter(valid_564768, JString, required = true,
                                 default = nil)
  if valid_564768 != nil:
    section.add "resourceGroupName", valid_564768
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564769 = query.getOrDefault("api-version")
  valid_564769 = validateParameter(valid_564769, JString, required = true,
                                 default = nil)
  if valid_564769 != nil:
    section.add "api-version", valid_564769
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

proc call*(call_564771: Call_VirtualMachineScaleSetsReimageAll_564763;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reimages all the disks ( including data disks ) in the virtual machines in a VM scale set. This operation is only supported for managed disks.
  ## 
  let valid = call_564771.validator(path, query, header, formData, body)
  let scheme = call_564771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564771.url(scheme.get, call_564771.host, call_564771.base,
                         call_564771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564771, url, valid)

proc call*(call_564772: Call_VirtualMachineScaleSetsReimageAll_564763;
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
  var path_564773 = newJObject()
  var query_564774 = newJObject()
  var body_564775 = newJObject()
  add(query_564774, "api-version", newJString(apiVersion))
  add(path_564773, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564773, "subscriptionId", newJString(subscriptionId))
  add(path_564773, "resourceGroupName", newJString(resourceGroupName))
  if vmInstanceIDs != nil:
    body_564775 = vmInstanceIDs
  result = call_564772.call(path_564773, query_564774, nil, nil, body_564775)

var virtualMachineScaleSetsReimageAll* = Call_VirtualMachineScaleSetsReimageAll_564763(
    name: "virtualMachineScaleSetsReimageAll", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/reimageall",
    validator: validate_VirtualMachineScaleSetsReimageAll_564764, base: "",
    url: url_VirtualMachineScaleSetsReimageAll_564765, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsRestart_564776 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsRestart_564778(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsRestart_564777(path: JsonNode;
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
  var valid_564779 = path.getOrDefault("vmScaleSetName")
  valid_564779 = validateParameter(valid_564779, JString, required = true,
                                 default = nil)
  if valid_564779 != nil:
    section.add "vmScaleSetName", valid_564779
  var valid_564780 = path.getOrDefault("subscriptionId")
  valid_564780 = validateParameter(valid_564780, JString, required = true,
                                 default = nil)
  if valid_564780 != nil:
    section.add "subscriptionId", valid_564780
  var valid_564781 = path.getOrDefault("resourceGroupName")
  valid_564781 = validateParameter(valid_564781, JString, required = true,
                                 default = nil)
  if valid_564781 != nil:
    section.add "resourceGroupName", valid_564781
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564782 = query.getOrDefault("api-version")
  valid_564782 = validateParameter(valid_564782, JString, required = true,
                                 default = nil)
  if valid_564782 != nil:
    section.add "api-version", valid_564782
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

proc call*(call_564784: Call_VirtualMachineScaleSetsRestart_564776; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts one or more virtual machines in a VM scale set.
  ## 
  let valid = call_564784.validator(path, query, header, formData, body)
  let scheme = call_564784.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564784.url(scheme.get, call_564784.host, call_564784.base,
                         call_564784.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564784, url, valid)

proc call*(call_564785: Call_VirtualMachineScaleSetsRestart_564776;
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
  var path_564786 = newJObject()
  var query_564787 = newJObject()
  var body_564788 = newJObject()
  add(query_564787, "api-version", newJString(apiVersion))
  add(path_564786, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564786, "subscriptionId", newJString(subscriptionId))
  add(path_564786, "resourceGroupName", newJString(resourceGroupName))
  if vmInstanceIDs != nil:
    body_564788 = vmInstanceIDs
  result = call_564785.call(path_564786, query_564787, nil, nil, body_564788)

var virtualMachineScaleSetsRestart* = Call_VirtualMachineScaleSetsRestart_564776(
    name: "virtualMachineScaleSetsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/restart",
    validator: validate_VirtualMachineScaleSetsRestart_564777, base: "",
    url: url_VirtualMachineScaleSetsRestart_564778, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesCancel_564789 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetRollingUpgradesCancel_564791(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetRollingUpgradesCancel_564790(path: JsonNode;
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
  var valid_564792 = path.getOrDefault("vmScaleSetName")
  valid_564792 = validateParameter(valid_564792, JString, required = true,
                                 default = nil)
  if valid_564792 != nil:
    section.add "vmScaleSetName", valid_564792
  var valid_564793 = path.getOrDefault("subscriptionId")
  valid_564793 = validateParameter(valid_564793, JString, required = true,
                                 default = nil)
  if valid_564793 != nil:
    section.add "subscriptionId", valid_564793
  var valid_564794 = path.getOrDefault("resourceGroupName")
  valid_564794 = validateParameter(valid_564794, JString, required = true,
                                 default = nil)
  if valid_564794 != nil:
    section.add "resourceGroupName", valid_564794
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564795 = query.getOrDefault("api-version")
  valid_564795 = validateParameter(valid_564795, JString, required = true,
                                 default = nil)
  if valid_564795 != nil:
    section.add "api-version", valid_564795
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564796: Call_VirtualMachineScaleSetRollingUpgradesCancel_564789;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the current virtual machine scale set rolling upgrade.
  ## 
  let valid = call_564796.validator(path, query, header, formData, body)
  let scheme = call_564796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564796.url(scheme.get, call_564796.host, call_564796.base,
                         call_564796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564796, url, valid)

proc call*(call_564797: Call_VirtualMachineScaleSetRollingUpgradesCancel_564789;
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
  var path_564798 = newJObject()
  var query_564799 = newJObject()
  add(query_564799, "api-version", newJString(apiVersion))
  add(path_564798, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564798, "subscriptionId", newJString(subscriptionId))
  add(path_564798, "resourceGroupName", newJString(resourceGroupName))
  result = call_564797.call(path_564798, query_564799, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesCancel* = Call_VirtualMachineScaleSetRollingUpgradesCancel_564789(
    name: "virtualMachineScaleSetRollingUpgradesCancel",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/rollingUpgrades/cancel",
    validator: validate_VirtualMachineScaleSetRollingUpgradesCancel_564790,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesCancel_564791,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesGetLatest_564800 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetRollingUpgradesGetLatest_564802(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetRollingUpgradesGetLatest_564801(
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
  var valid_564803 = path.getOrDefault("vmScaleSetName")
  valid_564803 = validateParameter(valid_564803, JString, required = true,
                                 default = nil)
  if valid_564803 != nil:
    section.add "vmScaleSetName", valid_564803
  var valid_564804 = path.getOrDefault("subscriptionId")
  valid_564804 = validateParameter(valid_564804, JString, required = true,
                                 default = nil)
  if valid_564804 != nil:
    section.add "subscriptionId", valid_564804
  var valid_564805 = path.getOrDefault("resourceGroupName")
  valid_564805 = validateParameter(valid_564805, JString, required = true,
                                 default = nil)
  if valid_564805 != nil:
    section.add "resourceGroupName", valid_564805
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564806 = query.getOrDefault("api-version")
  valid_564806 = validateParameter(valid_564806, JString, required = true,
                                 default = nil)
  if valid_564806 != nil:
    section.add "api-version", valid_564806
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564807: Call_VirtualMachineScaleSetRollingUpgradesGetLatest_564800;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of the latest virtual machine scale set rolling upgrade.
  ## 
  let valid = call_564807.validator(path, query, header, formData, body)
  let scheme = call_564807.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564807.url(scheme.get, call_564807.host, call_564807.base,
                         call_564807.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564807, url, valid)

proc call*(call_564808: Call_VirtualMachineScaleSetRollingUpgradesGetLatest_564800;
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
  var path_564809 = newJObject()
  var query_564810 = newJObject()
  add(query_564810, "api-version", newJString(apiVersion))
  add(path_564809, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564809, "subscriptionId", newJString(subscriptionId))
  add(path_564809, "resourceGroupName", newJString(resourceGroupName))
  result = call_564808.call(path_564809, query_564810, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesGetLatest* = Call_VirtualMachineScaleSetRollingUpgradesGetLatest_564800(
    name: "virtualMachineScaleSetRollingUpgradesGetLatest",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/rollingUpgrades/latest",
    validator: validate_VirtualMachineScaleSetRollingUpgradesGetLatest_564801,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesGetLatest_564802,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsListSkus_564811 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsListSkus_564813(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsListSkus_564812(path: JsonNode;
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
  var valid_564814 = path.getOrDefault("vmScaleSetName")
  valid_564814 = validateParameter(valid_564814, JString, required = true,
                                 default = nil)
  if valid_564814 != nil:
    section.add "vmScaleSetName", valid_564814
  var valid_564815 = path.getOrDefault("subscriptionId")
  valid_564815 = validateParameter(valid_564815, JString, required = true,
                                 default = nil)
  if valid_564815 != nil:
    section.add "subscriptionId", valid_564815
  var valid_564816 = path.getOrDefault("resourceGroupName")
  valid_564816 = validateParameter(valid_564816, JString, required = true,
                                 default = nil)
  if valid_564816 != nil:
    section.add "resourceGroupName", valid_564816
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564817 = query.getOrDefault("api-version")
  valid_564817 = validateParameter(valid_564817, JString, required = true,
                                 default = nil)
  if valid_564817 != nil:
    section.add "api-version", valid_564817
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564818: Call_VirtualMachineScaleSetsListSkus_564811;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of SKUs available for your VM scale set, including the minimum and maximum VM instances allowed for each SKU.
  ## 
  let valid = call_564818.validator(path, query, header, formData, body)
  let scheme = call_564818.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564818.url(scheme.get, call_564818.host, call_564818.base,
                         call_564818.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564818, url, valid)

proc call*(call_564819: Call_VirtualMachineScaleSetsListSkus_564811;
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
  var path_564820 = newJObject()
  var query_564821 = newJObject()
  add(query_564821, "api-version", newJString(apiVersion))
  add(path_564820, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564820, "subscriptionId", newJString(subscriptionId))
  add(path_564820, "resourceGroupName", newJString(resourceGroupName))
  result = call_564819.call(path_564820, query_564821, nil, nil, nil)

var virtualMachineScaleSetsListSkus* = Call_VirtualMachineScaleSetsListSkus_564811(
    name: "virtualMachineScaleSetsListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/skus",
    validator: validate_VirtualMachineScaleSetsListSkus_564812, base: "",
    url: url_VirtualMachineScaleSetsListSkus_564813, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsStart_564822 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetsStart_564824(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsStart_564823(path: JsonNode; query: JsonNode;
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
  var valid_564825 = path.getOrDefault("vmScaleSetName")
  valid_564825 = validateParameter(valid_564825, JString, required = true,
                                 default = nil)
  if valid_564825 != nil:
    section.add "vmScaleSetName", valid_564825
  var valid_564826 = path.getOrDefault("subscriptionId")
  valid_564826 = validateParameter(valid_564826, JString, required = true,
                                 default = nil)
  if valid_564826 != nil:
    section.add "subscriptionId", valid_564826
  var valid_564827 = path.getOrDefault("resourceGroupName")
  valid_564827 = validateParameter(valid_564827, JString, required = true,
                                 default = nil)
  if valid_564827 != nil:
    section.add "resourceGroupName", valid_564827
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564828 = query.getOrDefault("api-version")
  valid_564828 = validateParameter(valid_564828, JString, required = true,
                                 default = nil)
  if valid_564828 != nil:
    section.add "api-version", valid_564828
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

proc call*(call_564830: Call_VirtualMachineScaleSetsStart_564822; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts one or more virtual machines in a VM scale set.
  ## 
  let valid = call_564830.validator(path, query, header, formData, body)
  let scheme = call_564830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564830.url(scheme.get, call_564830.host, call_564830.base,
                         call_564830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564830, url, valid)

proc call*(call_564831: Call_VirtualMachineScaleSetsStart_564822;
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
  var path_564832 = newJObject()
  var query_564833 = newJObject()
  var body_564834 = newJObject()
  add(query_564833, "api-version", newJString(apiVersion))
  add(path_564832, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564832, "subscriptionId", newJString(subscriptionId))
  add(path_564832, "resourceGroupName", newJString(resourceGroupName))
  if vmInstanceIDs != nil:
    body_564834 = vmInstanceIDs
  result = call_564831.call(path_564832, query_564833, nil, nil, body_564834)

var virtualMachineScaleSetsStart* = Call_VirtualMachineScaleSetsStart_564822(
    name: "virtualMachineScaleSetsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/start",
    validator: validate_VirtualMachineScaleSetsStart_564823, base: "",
    url: url_VirtualMachineScaleSetsStart_564824, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsUpdate_564847 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsUpdate_564849(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsUpdate_564848(path: JsonNode;
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
  var valid_564850 = path.getOrDefault("vmScaleSetName")
  valid_564850 = validateParameter(valid_564850, JString, required = true,
                                 default = nil)
  if valid_564850 != nil:
    section.add "vmScaleSetName", valid_564850
  var valid_564851 = path.getOrDefault("subscriptionId")
  valid_564851 = validateParameter(valid_564851, JString, required = true,
                                 default = nil)
  if valid_564851 != nil:
    section.add "subscriptionId", valid_564851
  var valid_564852 = path.getOrDefault("resourceGroupName")
  valid_564852 = validateParameter(valid_564852, JString, required = true,
                                 default = nil)
  if valid_564852 != nil:
    section.add "resourceGroupName", valid_564852
  var valid_564853 = path.getOrDefault("instanceId")
  valid_564853 = validateParameter(valid_564853, JString, required = true,
                                 default = nil)
  if valid_564853 != nil:
    section.add "instanceId", valid_564853
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564854 = query.getOrDefault("api-version")
  valid_564854 = validateParameter(valid_564854, JString, required = true,
                                 default = nil)
  if valid_564854 != nil:
    section.add "api-version", valid_564854
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

proc call*(call_564856: Call_VirtualMachineScaleSetVMsUpdate_564847;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a virtual machine of a VM scale set.
  ## 
  let valid = call_564856.validator(path, query, header, formData, body)
  let scheme = call_564856.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564856.url(scheme.get, call_564856.host, call_564856.base,
                         call_564856.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564856, url, valid)

proc call*(call_564857: Call_VirtualMachineScaleSetVMsUpdate_564847;
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
  var path_564858 = newJObject()
  var query_564859 = newJObject()
  var body_564860 = newJObject()
  add(query_564859, "api-version", newJString(apiVersion))
  add(path_564858, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564858, "subscriptionId", newJString(subscriptionId))
  add(path_564858, "resourceGroupName", newJString(resourceGroupName))
  add(path_564858, "instanceId", newJString(instanceId))
  if parameters != nil:
    body_564860 = parameters
  result = call_564857.call(path_564858, query_564859, nil, nil, body_564860)

var virtualMachineScaleSetVMsUpdate* = Call_VirtualMachineScaleSetVMsUpdate_564847(
    name: "virtualMachineScaleSetVMsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsUpdate_564848, base: "",
    url: url_VirtualMachineScaleSetVMsUpdate_564849, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsGet_564835 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsGet_564837(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsGet_564836(path: JsonNode; query: JsonNode;
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
  var valid_564838 = path.getOrDefault("vmScaleSetName")
  valid_564838 = validateParameter(valid_564838, JString, required = true,
                                 default = nil)
  if valid_564838 != nil:
    section.add "vmScaleSetName", valid_564838
  var valid_564839 = path.getOrDefault("subscriptionId")
  valid_564839 = validateParameter(valid_564839, JString, required = true,
                                 default = nil)
  if valid_564839 != nil:
    section.add "subscriptionId", valid_564839
  var valid_564840 = path.getOrDefault("resourceGroupName")
  valid_564840 = validateParameter(valid_564840, JString, required = true,
                                 default = nil)
  if valid_564840 != nil:
    section.add "resourceGroupName", valid_564840
  var valid_564841 = path.getOrDefault("instanceId")
  valid_564841 = validateParameter(valid_564841, JString, required = true,
                                 default = nil)
  if valid_564841 != nil:
    section.add "instanceId", valid_564841
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564842 = query.getOrDefault("api-version")
  valid_564842 = validateParameter(valid_564842, JString, required = true,
                                 default = nil)
  if valid_564842 != nil:
    section.add "api-version", valid_564842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564843: Call_VirtualMachineScaleSetVMsGet_564835; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a virtual machine from a VM scale set.
  ## 
  let valid = call_564843.validator(path, query, header, formData, body)
  let scheme = call_564843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564843.url(scheme.get, call_564843.host, call_564843.base,
                         call_564843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564843, url, valid)

proc call*(call_564844: Call_VirtualMachineScaleSetVMsGet_564835;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsGet
  ## Gets a virtual machine from a VM scale set.
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
  var path_564845 = newJObject()
  var query_564846 = newJObject()
  add(query_564846, "api-version", newJString(apiVersion))
  add(path_564845, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564845, "subscriptionId", newJString(subscriptionId))
  add(path_564845, "resourceGroupName", newJString(resourceGroupName))
  add(path_564845, "instanceId", newJString(instanceId))
  result = call_564844.call(path_564845, query_564846, nil, nil, nil)

var virtualMachineScaleSetVMsGet* = Call_VirtualMachineScaleSetVMsGet_564835(
    name: "virtualMachineScaleSetVMsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsGet_564836, base: "",
    url: url_VirtualMachineScaleSetVMsGet_564837, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsDelete_564861 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsDelete_564863(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsDelete_564862(path: JsonNode;
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
  var valid_564864 = path.getOrDefault("vmScaleSetName")
  valid_564864 = validateParameter(valid_564864, JString, required = true,
                                 default = nil)
  if valid_564864 != nil:
    section.add "vmScaleSetName", valid_564864
  var valid_564865 = path.getOrDefault("subscriptionId")
  valid_564865 = validateParameter(valid_564865, JString, required = true,
                                 default = nil)
  if valid_564865 != nil:
    section.add "subscriptionId", valid_564865
  var valid_564866 = path.getOrDefault("resourceGroupName")
  valid_564866 = validateParameter(valid_564866, JString, required = true,
                                 default = nil)
  if valid_564866 != nil:
    section.add "resourceGroupName", valid_564866
  var valid_564867 = path.getOrDefault("instanceId")
  valid_564867 = validateParameter(valid_564867, JString, required = true,
                                 default = nil)
  if valid_564867 != nil:
    section.add "instanceId", valid_564867
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564868 = query.getOrDefault("api-version")
  valid_564868 = validateParameter(valid_564868, JString, required = true,
                                 default = nil)
  if valid_564868 != nil:
    section.add "api-version", valid_564868
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564869: Call_VirtualMachineScaleSetVMsDelete_564861;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a virtual machine from a VM scale set.
  ## 
  let valid = call_564869.validator(path, query, header, formData, body)
  let scheme = call_564869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564869.url(scheme.get, call_564869.host, call_564869.base,
                         call_564869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564869, url, valid)

proc call*(call_564870: Call_VirtualMachineScaleSetVMsDelete_564861;
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
  var path_564871 = newJObject()
  var query_564872 = newJObject()
  add(query_564872, "api-version", newJString(apiVersion))
  add(path_564871, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564871, "subscriptionId", newJString(subscriptionId))
  add(path_564871, "resourceGroupName", newJString(resourceGroupName))
  add(path_564871, "instanceId", newJString(instanceId))
  result = call_564870.call(path_564871, query_564872, nil, nil, nil)

var virtualMachineScaleSetVMsDelete* = Call_VirtualMachineScaleSetVMsDelete_564861(
    name: "virtualMachineScaleSetVMsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsDelete_564862, base: "",
    url: url_VirtualMachineScaleSetVMsDelete_564863, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsDeallocate_564873 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsDeallocate_564875(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsDeallocate_564874(path: JsonNode;
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
  var valid_564876 = path.getOrDefault("vmScaleSetName")
  valid_564876 = validateParameter(valid_564876, JString, required = true,
                                 default = nil)
  if valid_564876 != nil:
    section.add "vmScaleSetName", valid_564876
  var valid_564877 = path.getOrDefault("subscriptionId")
  valid_564877 = validateParameter(valid_564877, JString, required = true,
                                 default = nil)
  if valid_564877 != nil:
    section.add "subscriptionId", valid_564877
  var valid_564878 = path.getOrDefault("resourceGroupName")
  valid_564878 = validateParameter(valid_564878, JString, required = true,
                                 default = nil)
  if valid_564878 != nil:
    section.add "resourceGroupName", valid_564878
  var valid_564879 = path.getOrDefault("instanceId")
  valid_564879 = validateParameter(valid_564879, JString, required = true,
                                 default = nil)
  if valid_564879 != nil:
    section.add "instanceId", valid_564879
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564880 = query.getOrDefault("api-version")
  valid_564880 = validateParameter(valid_564880, JString, required = true,
                                 default = nil)
  if valid_564880 != nil:
    section.add "api-version", valid_564880
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564881: Call_VirtualMachineScaleSetVMsDeallocate_564873;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deallocates a specific virtual machine in a VM scale set. Shuts down the virtual machine and releases the compute resources it uses. You are not billed for the compute resources of this virtual machine once it is deallocated.
  ## 
  let valid = call_564881.validator(path, query, header, formData, body)
  let scheme = call_564881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564881.url(scheme.get, call_564881.host, call_564881.base,
                         call_564881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564881, url, valid)

proc call*(call_564882: Call_VirtualMachineScaleSetVMsDeallocate_564873;
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
  var path_564883 = newJObject()
  var query_564884 = newJObject()
  add(query_564884, "api-version", newJString(apiVersion))
  add(path_564883, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564883, "subscriptionId", newJString(subscriptionId))
  add(path_564883, "resourceGroupName", newJString(resourceGroupName))
  add(path_564883, "instanceId", newJString(instanceId))
  result = call_564882.call(path_564883, query_564884, nil, nil, nil)

var virtualMachineScaleSetVMsDeallocate* = Call_VirtualMachineScaleSetVMsDeallocate_564873(
    name: "virtualMachineScaleSetVMsDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/deallocate",
    validator: validate_VirtualMachineScaleSetVMsDeallocate_564874, base: "",
    url: url_VirtualMachineScaleSetVMsDeallocate_564875, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsGetInstanceView_564885 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsGetInstanceView_564887(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetVMsGetInstanceView_564886(path: JsonNode;
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
  var valid_564888 = path.getOrDefault("vmScaleSetName")
  valid_564888 = validateParameter(valid_564888, JString, required = true,
                                 default = nil)
  if valid_564888 != nil:
    section.add "vmScaleSetName", valid_564888
  var valid_564889 = path.getOrDefault("subscriptionId")
  valid_564889 = validateParameter(valid_564889, JString, required = true,
                                 default = nil)
  if valid_564889 != nil:
    section.add "subscriptionId", valid_564889
  var valid_564890 = path.getOrDefault("resourceGroupName")
  valid_564890 = validateParameter(valid_564890, JString, required = true,
                                 default = nil)
  if valid_564890 != nil:
    section.add "resourceGroupName", valid_564890
  var valid_564891 = path.getOrDefault("instanceId")
  valid_564891 = validateParameter(valid_564891, JString, required = true,
                                 default = nil)
  if valid_564891 != nil:
    section.add "instanceId", valid_564891
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564892 = query.getOrDefault("api-version")
  valid_564892 = validateParameter(valid_564892, JString, required = true,
                                 default = nil)
  if valid_564892 != nil:
    section.add "api-version", valid_564892
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564893: Call_VirtualMachineScaleSetVMsGetInstanceView_564885;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of a virtual machine from a VM scale set.
  ## 
  let valid = call_564893.validator(path, query, header, formData, body)
  let scheme = call_564893.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564893.url(scheme.get, call_564893.host, call_564893.base,
                         call_564893.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564893, url, valid)

proc call*(call_564894: Call_VirtualMachineScaleSetVMsGetInstanceView_564885;
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
  var path_564895 = newJObject()
  var query_564896 = newJObject()
  add(query_564896, "api-version", newJString(apiVersion))
  add(path_564895, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564895, "subscriptionId", newJString(subscriptionId))
  add(path_564895, "resourceGroupName", newJString(resourceGroupName))
  add(path_564895, "instanceId", newJString(instanceId))
  result = call_564894.call(path_564895, query_564896, nil, nil, nil)

var virtualMachineScaleSetVMsGetInstanceView* = Call_VirtualMachineScaleSetVMsGetInstanceView_564885(
    name: "virtualMachineScaleSetVMsGetInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/instanceView",
    validator: validate_VirtualMachineScaleSetVMsGetInstanceView_564886, base: "",
    url: url_VirtualMachineScaleSetVMsGetInstanceView_564887,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsPerformMaintenance_564897 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsPerformMaintenance_564899(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetVMsPerformMaintenance_564898(path: JsonNode;
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
  var valid_564900 = path.getOrDefault("vmScaleSetName")
  valid_564900 = validateParameter(valid_564900, JString, required = true,
                                 default = nil)
  if valid_564900 != nil:
    section.add "vmScaleSetName", valid_564900
  var valid_564901 = path.getOrDefault("subscriptionId")
  valid_564901 = validateParameter(valid_564901, JString, required = true,
                                 default = nil)
  if valid_564901 != nil:
    section.add "subscriptionId", valid_564901
  var valid_564902 = path.getOrDefault("resourceGroupName")
  valid_564902 = validateParameter(valid_564902, JString, required = true,
                                 default = nil)
  if valid_564902 != nil:
    section.add "resourceGroupName", valid_564902
  var valid_564903 = path.getOrDefault("instanceId")
  valid_564903 = validateParameter(valid_564903, JString, required = true,
                                 default = nil)
  if valid_564903 != nil:
    section.add "instanceId", valid_564903
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564904 = query.getOrDefault("api-version")
  valid_564904 = validateParameter(valid_564904, JString, required = true,
                                 default = nil)
  if valid_564904 != nil:
    section.add "api-version", valid_564904
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564905: Call_VirtualMachineScaleSetVMsPerformMaintenance_564897;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Performs maintenance on a virtual machine in a VM scale set.
  ## 
  let valid = call_564905.validator(path, query, header, formData, body)
  let scheme = call_564905.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564905.url(scheme.get, call_564905.host, call_564905.base,
                         call_564905.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564905, url, valid)

proc call*(call_564906: Call_VirtualMachineScaleSetVMsPerformMaintenance_564897;
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
  var path_564907 = newJObject()
  var query_564908 = newJObject()
  add(query_564908, "api-version", newJString(apiVersion))
  add(path_564907, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564907, "subscriptionId", newJString(subscriptionId))
  add(path_564907, "resourceGroupName", newJString(resourceGroupName))
  add(path_564907, "instanceId", newJString(instanceId))
  result = call_564906.call(path_564907, query_564908, nil, nil, nil)

var virtualMachineScaleSetVMsPerformMaintenance* = Call_VirtualMachineScaleSetVMsPerformMaintenance_564897(
    name: "virtualMachineScaleSetVMsPerformMaintenance",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/performMaintenance",
    validator: validate_VirtualMachineScaleSetVMsPerformMaintenance_564898,
    base: "", url: url_VirtualMachineScaleSetVMsPerformMaintenance_564899,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsPowerOff_564909 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsPowerOff_564911(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsPowerOff_564910(path: JsonNode;
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
  var valid_564912 = path.getOrDefault("vmScaleSetName")
  valid_564912 = validateParameter(valid_564912, JString, required = true,
                                 default = nil)
  if valid_564912 != nil:
    section.add "vmScaleSetName", valid_564912
  var valid_564913 = path.getOrDefault("subscriptionId")
  valid_564913 = validateParameter(valid_564913, JString, required = true,
                                 default = nil)
  if valid_564913 != nil:
    section.add "subscriptionId", valid_564913
  var valid_564914 = path.getOrDefault("resourceGroupName")
  valid_564914 = validateParameter(valid_564914, JString, required = true,
                                 default = nil)
  if valid_564914 != nil:
    section.add "resourceGroupName", valid_564914
  var valid_564915 = path.getOrDefault("instanceId")
  valid_564915 = validateParameter(valid_564915, JString, required = true,
                                 default = nil)
  if valid_564915 != nil:
    section.add "instanceId", valid_564915
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564916 = query.getOrDefault("api-version")
  valid_564916 = validateParameter(valid_564916, JString, required = true,
                                 default = nil)
  if valid_564916 != nil:
    section.add "api-version", valid_564916
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564917: Call_VirtualMachineScaleSetVMsPowerOff_564909;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Power off (stop) a virtual machine in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  let valid = call_564917.validator(path, query, header, formData, body)
  let scheme = call_564917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564917.url(scheme.get, call_564917.host, call_564917.base,
                         call_564917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564917, url, valid)

proc call*(call_564918: Call_VirtualMachineScaleSetVMsPowerOff_564909;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; instanceId: string): Recallable =
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
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_564919 = newJObject()
  var query_564920 = newJObject()
  add(query_564920, "api-version", newJString(apiVersion))
  add(path_564919, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564919, "subscriptionId", newJString(subscriptionId))
  add(path_564919, "resourceGroupName", newJString(resourceGroupName))
  add(path_564919, "instanceId", newJString(instanceId))
  result = call_564918.call(path_564919, query_564920, nil, nil, nil)

var virtualMachineScaleSetVMsPowerOff* = Call_VirtualMachineScaleSetVMsPowerOff_564909(
    name: "virtualMachineScaleSetVMsPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/poweroff",
    validator: validate_VirtualMachineScaleSetVMsPowerOff_564910, base: "",
    url: url_VirtualMachineScaleSetVMsPowerOff_564911, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsRedeploy_564921 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsRedeploy_564923(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsRedeploy_564922(path: JsonNode;
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
  var valid_564924 = path.getOrDefault("vmScaleSetName")
  valid_564924 = validateParameter(valid_564924, JString, required = true,
                                 default = nil)
  if valid_564924 != nil:
    section.add "vmScaleSetName", valid_564924
  var valid_564925 = path.getOrDefault("subscriptionId")
  valid_564925 = validateParameter(valid_564925, JString, required = true,
                                 default = nil)
  if valid_564925 != nil:
    section.add "subscriptionId", valid_564925
  var valid_564926 = path.getOrDefault("resourceGroupName")
  valid_564926 = validateParameter(valid_564926, JString, required = true,
                                 default = nil)
  if valid_564926 != nil:
    section.add "resourceGroupName", valid_564926
  var valid_564927 = path.getOrDefault("instanceId")
  valid_564927 = validateParameter(valid_564927, JString, required = true,
                                 default = nil)
  if valid_564927 != nil:
    section.add "instanceId", valid_564927
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564928 = query.getOrDefault("api-version")
  valid_564928 = validateParameter(valid_564928, JString, required = true,
                                 default = nil)
  if valid_564928 != nil:
    section.add "api-version", valid_564928
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564929: Call_VirtualMachineScaleSetVMsRedeploy_564921;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Shuts down the virtual machine in the virtual machine scale set, moves it to a new node, and powers it back on.
  ## 
  let valid = call_564929.validator(path, query, header, formData, body)
  let scheme = call_564929.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564929.url(scheme.get, call_564929.host, call_564929.base,
                         call_564929.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564929, url, valid)

proc call*(call_564930: Call_VirtualMachineScaleSetVMsRedeploy_564921;
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
  var path_564931 = newJObject()
  var query_564932 = newJObject()
  add(query_564932, "api-version", newJString(apiVersion))
  add(path_564931, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564931, "subscriptionId", newJString(subscriptionId))
  add(path_564931, "resourceGroupName", newJString(resourceGroupName))
  add(path_564931, "instanceId", newJString(instanceId))
  result = call_564930.call(path_564931, query_564932, nil, nil, nil)

var virtualMachineScaleSetVMsRedeploy* = Call_VirtualMachineScaleSetVMsRedeploy_564921(
    name: "virtualMachineScaleSetVMsRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/redeploy",
    validator: validate_VirtualMachineScaleSetVMsRedeploy_564922, base: "",
    url: url_VirtualMachineScaleSetVMsRedeploy_564923, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsReimage_564933 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsReimage_564935(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsReimage_564934(path: JsonNode;
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
  var valid_564936 = path.getOrDefault("vmScaleSetName")
  valid_564936 = validateParameter(valid_564936, JString, required = true,
                                 default = nil)
  if valid_564936 != nil:
    section.add "vmScaleSetName", valid_564936
  var valid_564937 = path.getOrDefault("subscriptionId")
  valid_564937 = validateParameter(valid_564937, JString, required = true,
                                 default = nil)
  if valid_564937 != nil:
    section.add "subscriptionId", valid_564937
  var valid_564938 = path.getOrDefault("resourceGroupName")
  valid_564938 = validateParameter(valid_564938, JString, required = true,
                                 default = nil)
  if valid_564938 != nil:
    section.add "resourceGroupName", valid_564938
  var valid_564939 = path.getOrDefault("instanceId")
  valid_564939 = validateParameter(valid_564939, JString, required = true,
                                 default = nil)
  if valid_564939 != nil:
    section.add "instanceId", valid_564939
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564940 = query.getOrDefault("api-version")
  valid_564940 = validateParameter(valid_564940, JString, required = true,
                                 default = nil)
  if valid_564940 != nil:
    section.add "api-version", valid_564940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564941: Call_VirtualMachineScaleSetVMsReimage_564933;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reimages (upgrade the operating system) a specific virtual machine in a VM scale set.
  ## 
  let valid = call_564941.validator(path, query, header, formData, body)
  let scheme = call_564941.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564941.url(scheme.get, call_564941.host, call_564941.base,
                         call_564941.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564941, url, valid)

proc call*(call_564942: Call_VirtualMachineScaleSetVMsReimage_564933;
          apiVersion: string; vmScaleSetName: string; subscriptionId: string;
          resourceGroupName: string; instanceId: string): Recallable =
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
  var path_564943 = newJObject()
  var query_564944 = newJObject()
  add(query_564944, "api-version", newJString(apiVersion))
  add(path_564943, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564943, "subscriptionId", newJString(subscriptionId))
  add(path_564943, "resourceGroupName", newJString(resourceGroupName))
  add(path_564943, "instanceId", newJString(instanceId))
  result = call_564942.call(path_564943, query_564944, nil, nil, nil)

var virtualMachineScaleSetVMsReimage* = Call_VirtualMachineScaleSetVMsReimage_564933(
    name: "virtualMachineScaleSetVMsReimage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/reimage",
    validator: validate_VirtualMachineScaleSetVMsReimage_564934, base: "",
    url: url_VirtualMachineScaleSetVMsReimage_564935, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsReimageAll_564945 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsReimageAll_564947(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsReimageAll_564946(path: JsonNode;
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
  var valid_564948 = path.getOrDefault("vmScaleSetName")
  valid_564948 = validateParameter(valid_564948, JString, required = true,
                                 default = nil)
  if valid_564948 != nil:
    section.add "vmScaleSetName", valid_564948
  var valid_564949 = path.getOrDefault("subscriptionId")
  valid_564949 = validateParameter(valid_564949, JString, required = true,
                                 default = nil)
  if valid_564949 != nil:
    section.add "subscriptionId", valid_564949
  var valid_564950 = path.getOrDefault("resourceGroupName")
  valid_564950 = validateParameter(valid_564950, JString, required = true,
                                 default = nil)
  if valid_564950 != nil:
    section.add "resourceGroupName", valid_564950
  var valid_564951 = path.getOrDefault("instanceId")
  valid_564951 = validateParameter(valid_564951, JString, required = true,
                                 default = nil)
  if valid_564951 != nil:
    section.add "instanceId", valid_564951
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564952 = query.getOrDefault("api-version")
  valid_564952 = validateParameter(valid_564952, JString, required = true,
                                 default = nil)
  if valid_564952 != nil:
    section.add "api-version", valid_564952
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564953: Call_VirtualMachineScaleSetVMsReimageAll_564945;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Allows you to re-image all the disks ( including data disks ) in the a VM scale set instance. This operation is only supported for managed disks.
  ## 
  let valid = call_564953.validator(path, query, header, formData, body)
  let scheme = call_564953.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564953.url(scheme.get, call_564953.host, call_564953.base,
                         call_564953.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564953, url, valid)

proc call*(call_564954: Call_VirtualMachineScaleSetVMsReimageAll_564945;
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
  var path_564955 = newJObject()
  var query_564956 = newJObject()
  add(query_564956, "api-version", newJString(apiVersion))
  add(path_564955, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564955, "subscriptionId", newJString(subscriptionId))
  add(path_564955, "resourceGroupName", newJString(resourceGroupName))
  add(path_564955, "instanceId", newJString(instanceId))
  result = call_564954.call(path_564955, query_564956, nil, nil, nil)

var virtualMachineScaleSetVMsReimageAll* = Call_VirtualMachineScaleSetVMsReimageAll_564945(
    name: "virtualMachineScaleSetVMsReimageAll", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/reimageall",
    validator: validate_VirtualMachineScaleSetVMsReimageAll_564946, base: "",
    url: url_VirtualMachineScaleSetVMsReimageAll_564947, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsRestart_564957 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsRestart_564959(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsRestart_564958(path: JsonNode;
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
  var valid_564960 = path.getOrDefault("vmScaleSetName")
  valid_564960 = validateParameter(valid_564960, JString, required = true,
                                 default = nil)
  if valid_564960 != nil:
    section.add "vmScaleSetName", valid_564960
  var valid_564961 = path.getOrDefault("subscriptionId")
  valid_564961 = validateParameter(valid_564961, JString, required = true,
                                 default = nil)
  if valid_564961 != nil:
    section.add "subscriptionId", valid_564961
  var valid_564962 = path.getOrDefault("resourceGroupName")
  valid_564962 = validateParameter(valid_564962, JString, required = true,
                                 default = nil)
  if valid_564962 != nil:
    section.add "resourceGroupName", valid_564962
  var valid_564963 = path.getOrDefault("instanceId")
  valid_564963 = validateParameter(valid_564963, JString, required = true,
                                 default = nil)
  if valid_564963 != nil:
    section.add "instanceId", valid_564963
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564964 = query.getOrDefault("api-version")
  valid_564964 = validateParameter(valid_564964, JString, required = true,
                                 default = nil)
  if valid_564964 != nil:
    section.add "api-version", valid_564964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564965: Call_VirtualMachineScaleSetVMsRestart_564957;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Restarts a virtual machine in a VM scale set.
  ## 
  let valid = call_564965.validator(path, query, header, formData, body)
  let scheme = call_564965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564965.url(scheme.get, call_564965.host, call_564965.base,
                         call_564965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564965, url, valid)

proc call*(call_564966: Call_VirtualMachineScaleSetVMsRestart_564957;
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
  var path_564967 = newJObject()
  var query_564968 = newJObject()
  add(query_564968, "api-version", newJString(apiVersion))
  add(path_564967, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564967, "subscriptionId", newJString(subscriptionId))
  add(path_564967, "resourceGroupName", newJString(resourceGroupName))
  add(path_564967, "instanceId", newJString(instanceId))
  result = call_564966.call(path_564967, query_564968, nil, nil, nil)

var virtualMachineScaleSetVMsRestart* = Call_VirtualMachineScaleSetVMsRestart_564957(
    name: "virtualMachineScaleSetVMsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/restart",
    validator: validate_VirtualMachineScaleSetVMsRestart_564958, base: "",
    url: url_VirtualMachineScaleSetVMsRestart_564959, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsStart_564969 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineScaleSetVMsStart_564971(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsStart_564970(path: JsonNode;
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
  var valid_564972 = path.getOrDefault("vmScaleSetName")
  valid_564972 = validateParameter(valid_564972, JString, required = true,
                                 default = nil)
  if valid_564972 != nil:
    section.add "vmScaleSetName", valid_564972
  var valid_564973 = path.getOrDefault("subscriptionId")
  valid_564973 = validateParameter(valid_564973, JString, required = true,
                                 default = nil)
  if valid_564973 != nil:
    section.add "subscriptionId", valid_564973
  var valid_564974 = path.getOrDefault("resourceGroupName")
  valid_564974 = validateParameter(valid_564974, JString, required = true,
                                 default = nil)
  if valid_564974 != nil:
    section.add "resourceGroupName", valid_564974
  var valid_564975 = path.getOrDefault("instanceId")
  valid_564975 = validateParameter(valid_564975, JString, required = true,
                                 default = nil)
  if valid_564975 != nil:
    section.add "instanceId", valid_564975
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564976 = query.getOrDefault("api-version")
  valid_564976 = validateParameter(valid_564976, JString, required = true,
                                 default = nil)
  if valid_564976 != nil:
    section.add "api-version", valid_564976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564977: Call_VirtualMachineScaleSetVMsStart_564969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a virtual machine in a VM scale set.
  ## 
  let valid = call_564977.validator(path, query, header, formData, body)
  let scheme = call_564977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564977.url(scheme.get, call_564977.host, call_564977.base,
                         call_564977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564977, url, valid)

proc call*(call_564978: Call_VirtualMachineScaleSetVMsStart_564969;
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
  var path_564979 = newJObject()
  var query_564980 = newJObject()
  add(query_564980, "api-version", newJString(apiVersion))
  add(path_564979, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_564979, "subscriptionId", newJString(subscriptionId))
  add(path_564979, "resourceGroupName", newJString(resourceGroupName))
  add(path_564979, "instanceId", newJString(instanceId))
  result = call_564978.call(path_564979, query_564980, nil, nil, nil)

var virtualMachineScaleSetVMsStart* = Call_VirtualMachineScaleSetVMsStart_564969(
    name: "virtualMachineScaleSetVMsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/start",
    validator: validate_VirtualMachineScaleSetVMsStart_564970, base: "",
    url: url_VirtualMachineScaleSetVMsStart_564971, schemes: {Scheme.Https})
type
  Call_VirtualMachinesList_564981 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesList_564983(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesList_564982(path: JsonNode; query: JsonNode;
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
  var valid_564984 = path.getOrDefault("subscriptionId")
  valid_564984 = validateParameter(valid_564984, JString, required = true,
                                 default = nil)
  if valid_564984 != nil:
    section.add "subscriptionId", valid_564984
  var valid_564985 = path.getOrDefault("resourceGroupName")
  valid_564985 = validateParameter(valid_564985, JString, required = true,
                                 default = nil)
  if valid_564985 != nil:
    section.add "resourceGroupName", valid_564985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564986 = query.getOrDefault("api-version")
  valid_564986 = validateParameter(valid_564986, JString, required = true,
                                 default = nil)
  if valid_564986 != nil:
    section.add "api-version", valid_564986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564987: Call_VirtualMachinesList_564981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the virtual machines in the specified resource group. Use the nextLink property in the response to get the next page of virtual machines.
  ## 
  let valid = call_564987.validator(path, query, header, formData, body)
  let scheme = call_564987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564987.url(scheme.get, call_564987.host, call_564987.base,
                         call_564987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564987, url, valid)

proc call*(call_564988: Call_VirtualMachinesList_564981; apiVersion: string;
          subscriptionId: string; resourceGroupName: string): Recallable =
  ## virtualMachinesList
  ## Lists all of the virtual machines in the specified resource group. Use the nextLink property in the response to get the next page of virtual machines.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564989 = newJObject()
  var query_564990 = newJObject()
  add(query_564990, "api-version", newJString(apiVersion))
  add(path_564989, "subscriptionId", newJString(subscriptionId))
  add(path_564989, "resourceGroupName", newJString(resourceGroupName))
  result = call_564988.call(path_564989, query_564990, nil, nil, nil)

var virtualMachinesList* = Call_VirtualMachinesList_564981(
    name: "virtualMachinesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines",
    validator: validate_VirtualMachinesList_564982, base: "",
    url: url_VirtualMachinesList_564983, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCreateOrUpdate_565016 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesCreateOrUpdate_565018(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesCreateOrUpdate_565017(path: JsonNode; query: JsonNode;
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
  var valid_565021 = path.getOrDefault("vmName")
  valid_565021 = validateParameter(valid_565021, JString, required = true,
                                 default = nil)
  if valid_565021 != nil:
    section.add "vmName", valid_565021
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
  ##             : Parameters supplied to the Create Virtual Machine operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565024: Call_VirtualMachinesCreateOrUpdate_565016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a virtual machine.
  ## 
  let valid = call_565024.validator(path, query, header, formData, body)
  let scheme = call_565024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565024.url(scheme.get, call_565024.host, call_565024.base,
                         call_565024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565024, url, valid)

proc call*(call_565025: Call_VirtualMachinesCreateOrUpdate_565016;
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
  var path_565026 = newJObject()
  var query_565027 = newJObject()
  var body_565028 = newJObject()
  add(query_565027, "api-version", newJString(apiVersion))
  add(path_565026, "subscriptionId", newJString(subscriptionId))
  add(path_565026, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_565028 = parameters
  add(path_565026, "vmName", newJString(vmName))
  result = call_565025.call(path_565026, query_565027, nil, nil, body_565028)

var virtualMachinesCreateOrUpdate* = Call_VirtualMachinesCreateOrUpdate_565016(
    name: "virtualMachinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesCreateOrUpdate_565017, base: "",
    url: url_VirtualMachinesCreateOrUpdate_565018, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGet_564991 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesGet_564993(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesGet_564992(path: JsonNode; query: JsonNode;
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
  var valid_564994 = path.getOrDefault("subscriptionId")
  valid_564994 = validateParameter(valid_564994, JString, required = true,
                                 default = nil)
  if valid_564994 != nil:
    section.add "subscriptionId", valid_564994
  var valid_564995 = path.getOrDefault("resourceGroupName")
  valid_564995 = validateParameter(valid_564995, JString, required = true,
                                 default = nil)
  if valid_564995 != nil:
    section.add "resourceGroupName", valid_564995
  var valid_564996 = path.getOrDefault("vmName")
  valid_564996 = validateParameter(valid_564996, JString, required = true,
                                 default = nil)
  if valid_564996 != nil:
    section.add "vmName", valid_564996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564997 = query.getOrDefault("api-version")
  valid_564997 = validateParameter(valid_564997, JString, required = true,
                                 default = nil)
  if valid_564997 != nil:
    section.add "api-version", valid_564997
  var valid_565011 = query.getOrDefault("$expand")
  valid_565011 = validateParameter(valid_565011, JString, required = false,
                                 default = newJString("instanceView"))
  if valid_565011 != nil:
    section.add "$expand", valid_565011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565012: Call_VirtualMachinesGet_564991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the model view or the instance view of a virtual machine.
  ## 
  let valid = call_565012.validator(path, query, header, formData, body)
  let scheme = call_565012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565012.url(scheme.get, call_565012.host, call_565012.base,
                         call_565012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565012, url, valid)

proc call*(call_565013: Call_VirtualMachinesGet_564991; apiVersion: string;
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
  var path_565014 = newJObject()
  var query_565015 = newJObject()
  add(query_565015, "api-version", newJString(apiVersion))
  add(query_565015, "$expand", newJString(Expand))
  add(path_565014, "subscriptionId", newJString(subscriptionId))
  add(path_565014, "resourceGroupName", newJString(resourceGroupName))
  add(path_565014, "vmName", newJString(vmName))
  result = call_565013.call(path_565014, query_565015, nil, nil, nil)

var virtualMachinesGet* = Call_VirtualMachinesGet_564991(
    name: "virtualMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesGet_564992, base: "",
    url: url_VirtualMachinesGet_564993, schemes: {Scheme.Https})
type
  Call_VirtualMachinesUpdate_565040 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesUpdate_565042(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesUpdate_565041(path: JsonNode; query: JsonNode;
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
  var valid_565043 = path.getOrDefault("subscriptionId")
  valid_565043 = validateParameter(valid_565043, JString, required = true,
                                 default = nil)
  if valid_565043 != nil:
    section.add "subscriptionId", valid_565043
  var valid_565044 = path.getOrDefault("resourceGroupName")
  valid_565044 = validateParameter(valid_565044, JString, required = true,
                                 default = nil)
  if valid_565044 != nil:
    section.add "resourceGroupName", valid_565044
  var valid_565045 = path.getOrDefault("vmName")
  valid_565045 = validateParameter(valid_565045, JString, required = true,
                                 default = nil)
  if valid_565045 != nil:
    section.add "vmName", valid_565045
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565046 = query.getOrDefault("api-version")
  valid_565046 = validateParameter(valid_565046, JString, required = true,
                                 default = nil)
  if valid_565046 != nil:
    section.add "api-version", valid_565046
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

proc call*(call_565048: Call_VirtualMachinesUpdate_565040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a virtual machine.
  ## 
  let valid = call_565048.validator(path, query, header, formData, body)
  let scheme = call_565048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565048.url(scheme.get, call_565048.host, call_565048.base,
                         call_565048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565048, url, valid)

proc call*(call_565049: Call_VirtualMachinesUpdate_565040; apiVersion: string;
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
  var path_565050 = newJObject()
  var query_565051 = newJObject()
  var body_565052 = newJObject()
  add(query_565051, "api-version", newJString(apiVersion))
  add(path_565050, "subscriptionId", newJString(subscriptionId))
  add(path_565050, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_565052 = parameters
  add(path_565050, "vmName", newJString(vmName))
  result = call_565049.call(path_565050, query_565051, nil, nil, body_565052)

var virtualMachinesUpdate* = Call_VirtualMachinesUpdate_565040(
    name: "virtualMachinesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesUpdate_565041, base: "",
    url: url_VirtualMachinesUpdate_565042, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDelete_565029 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesDelete_565031(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesDelete_565030(path: JsonNode; query: JsonNode;
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
  var valid_565032 = path.getOrDefault("subscriptionId")
  valid_565032 = validateParameter(valid_565032, JString, required = true,
                                 default = nil)
  if valid_565032 != nil:
    section.add "subscriptionId", valid_565032
  var valid_565033 = path.getOrDefault("resourceGroupName")
  valid_565033 = validateParameter(valid_565033, JString, required = true,
                                 default = nil)
  if valid_565033 != nil:
    section.add "resourceGroupName", valid_565033
  var valid_565034 = path.getOrDefault("vmName")
  valid_565034 = validateParameter(valid_565034, JString, required = true,
                                 default = nil)
  if valid_565034 != nil:
    section.add "vmName", valid_565034
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565035 = query.getOrDefault("api-version")
  valid_565035 = validateParameter(valid_565035, JString, required = true,
                                 default = nil)
  if valid_565035 != nil:
    section.add "api-version", valid_565035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565036: Call_VirtualMachinesDelete_565029; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a virtual machine.
  ## 
  let valid = call_565036.validator(path, query, header, formData, body)
  let scheme = call_565036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565036.url(scheme.get, call_565036.host, call_565036.base,
                         call_565036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565036, url, valid)

proc call*(call_565037: Call_VirtualMachinesDelete_565029; apiVersion: string;
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
  var path_565038 = newJObject()
  var query_565039 = newJObject()
  add(query_565039, "api-version", newJString(apiVersion))
  add(path_565038, "subscriptionId", newJString(subscriptionId))
  add(path_565038, "resourceGroupName", newJString(resourceGroupName))
  add(path_565038, "vmName", newJString(vmName))
  result = call_565037.call(path_565038, query_565039, nil, nil, nil)

var virtualMachinesDelete* = Call_VirtualMachinesDelete_565029(
    name: "virtualMachinesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesDelete_565030, base: "",
    url: url_VirtualMachinesDelete_565031, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCapture_565053 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesCapture_565055(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesCapture_565054(path: JsonNode; query: JsonNode;
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
  var valid_565056 = path.getOrDefault("subscriptionId")
  valid_565056 = validateParameter(valid_565056, JString, required = true,
                                 default = nil)
  if valid_565056 != nil:
    section.add "subscriptionId", valid_565056
  var valid_565057 = path.getOrDefault("resourceGroupName")
  valid_565057 = validateParameter(valid_565057, JString, required = true,
                                 default = nil)
  if valid_565057 != nil:
    section.add "resourceGroupName", valid_565057
  var valid_565058 = path.getOrDefault("vmName")
  valid_565058 = validateParameter(valid_565058, JString, required = true,
                                 default = nil)
  if valid_565058 != nil:
    section.add "vmName", valid_565058
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565059 = query.getOrDefault("api-version")
  valid_565059 = validateParameter(valid_565059, JString, required = true,
                                 default = nil)
  if valid_565059 != nil:
    section.add "api-version", valid_565059
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

proc call*(call_565061: Call_VirtualMachinesCapture_565053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Captures the VM by copying virtual hard disks of the VM and outputs a template that can be used to create similar VMs.
  ## 
  let valid = call_565061.validator(path, query, header, formData, body)
  let scheme = call_565061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565061.url(scheme.get, call_565061.host, call_565061.base,
                         call_565061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565061, url, valid)

proc call*(call_565062: Call_VirtualMachinesCapture_565053; apiVersion: string;
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
  var path_565063 = newJObject()
  var query_565064 = newJObject()
  var body_565065 = newJObject()
  add(query_565064, "api-version", newJString(apiVersion))
  add(path_565063, "subscriptionId", newJString(subscriptionId))
  add(path_565063, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_565065 = parameters
  add(path_565063, "vmName", newJString(vmName))
  result = call_565062.call(path_565063, query_565064, nil, nil, body_565065)

var virtualMachinesCapture* = Call_VirtualMachinesCapture_565053(
    name: "virtualMachinesCapture", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/capture",
    validator: validate_VirtualMachinesCapture_565054, base: "",
    url: url_VirtualMachinesCapture_565055, schemes: {Scheme.Https})
type
  Call_VirtualMachinesConvertToManagedDisks_565066 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesConvertToManagedDisks_565068(protocol: Scheme;
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

proc validate_VirtualMachinesConvertToManagedDisks_565067(path: JsonNode;
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
  var valid_565071 = path.getOrDefault("vmName")
  valid_565071 = validateParameter(valid_565071, JString, required = true,
                                 default = nil)
  if valid_565071 != nil:
    section.add "vmName", valid_565071
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

proc call*(call_565073: Call_VirtualMachinesConvertToManagedDisks_565066;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Converts virtual machine disks from blob-based to managed disks. Virtual machine must be stop-deallocated before invoking this operation.
  ## 
  let valid = call_565073.validator(path, query, header, formData, body)
  let scheme = call_565073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565073.url(scheme.get, call_565073.host, call_565073.base,
                         call_565073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565073, url, valid)

proc call*(call_565074: Call_VirtualMachinesConvertToManagedDisks_565066;
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
  var path_565075 = newJObject()
  var query_565076 = newJObject()
  add(query_565076, "api-version", newJString(apiVersion))
  add(path_565075, "subscriptionId", newJString(subscriptionId))
  add(path_565075, "resourceGroupName", newJString(resourceGroupName))
  add(path_565075, "vmName", newJString(vmName))
  result = call_565074.call(path_565075, query_565076, nil, nil, nil)

var virtualMachinesConvertToManagedDisks* = Call_VirtualMachinesConvertToManagedDisks_565066(
    name: "virtualMachinesConvertToManagedDisks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/convertToManagedDisks",
    validator: validate_VirtualMachinesConvertToManagedDisks_565067, base: "",
    url: url_VirtualMachinesConvertToManagedDisks_565068, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDeallocate_565077 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesDeallocate_565079(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesDeallocate_565078(path: JsonNode; query: JsonNode;
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
  var valid_565080 = path.getOrDefault("subscriptionId")
  valid_565080 = validateParameter(valid_565080, JString, required = true,
                                 default = nil)
  if valid_565080 != nil:
    section.add "subscriptionId", valid_565080
  var valid_565081 = path.getOrDefault("resourceGroupName")
  valid_565081 = validateParameter(valid_565081, JString, required = true,
                                 default = nil)
  if valid_565081 != nil:
    section.add "resourceGroupName", valid_565081
  var valid_565082 = path.getOrDefault("vmName")
  valid_565082 = validateParameter(valid_565082, JString, required = true,
                                 default = nil)
  if valid_565082 != nil:
    section.add "vmName", valid_565082
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565083 = query.getOrDefault("api-version")
  valid_565083 = validateParameter(valid_565083, JString, required = true,
                                 default = nil)
  if valid_565083 != nil:
    section.add "api-version", valid_565083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565084: Call_VirtualMachinesDeallocate_565077; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shuts down the virtual machine and releases the compute resources. You are not billed for the compute resources that this virtual machine uses.
  ## 
  let valid = call_565084.validator(path, query, header, formData, body)
  let scheme = call_565084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565084.url(scheme.get, call_565084.host, call_565084.base,
                         call_565084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565084, url, valid)

proc call*(call_565085: Call_VirtualMachinesDeallocate_565077; apiVersion: string;
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
  var path_565086 = newJObject()
  var query_565087 = newJObject()
  add(query_565087, "api-version", newJString(apiVersion))
  add(path_565086, "subscriptionId", newJString(subscriptionId))
  add(path_565086, "resourceGroupName", newJString(resourceGroupName))
  add(path_565086, "vmName", newJString(vmName))
  result = call_565085.call(path_565086, query_565087, nil, nil, nil)

var virtualMachinesDeallocate* = Call_VirtualMachinesDeallocate_565077(
    name: "virtualMachinesDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/deallocate",
    validator: validate_VirtualMachinesDeallocate_565078, base: "",
    url: url_VirtualMachinesDeallocate_565079, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsList_565088 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineExtensionsList_565090(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionsList_565089(path: JsonNode; query: JsonNode;
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
  var valid_565091 = path.getOrDefault("subscriptionId")
  valid_565091 = validateParameter(valid_565091, JString, required = true,
                                 default = nil)
  if valid_565091 != nil:
    section.add "subscriptionId", valid_565091
  var valid_565092 = path.getOrDefault("resourceGroupName")
  valid_565092 = validateParameter(valid_565092, JString, required = true,
                                 default = nil)
  if valid_565092 != nil:
    section.add "resourceGroupName", valid_565092
  var valid_565093 = path.getOrDefault("vmName")
  valid_565093 = validateParameter(valid_565093, JString, required = true,
                                 default = nil)
  if valid_565093 != nil:
    section.add "vmName", valid_565093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565094 = query.getOrDefault("api-version")
  valid_565094 = validateParameter(valid_565094, JString, required = true,
                                 default = nil)
  if valid_565094 != nil:
    section.add "api-version", valid_565094
  var valid_565095 = query.getOrDefault("$expand")
  valid_565095 = validateParameter(valid_565095, JString, required = false,
                                 default = nil)
  if valid_565095 != nil:
    section.add "$expand", valid_565095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565096: Call_VirtualMachineExtensionsList_565088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get all extensions of a Virtual Machine.
  ## 
  let valid = call_565096.validator(path, query, header, formData, body)
  let scheme = call_565096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565096.url(scheme.get, call_565096.host, call_565096.base,
                         call_565096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565096, url, valid)

proc call*(call_565097: Call_VirtualMachineExtensionsList_565088;
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
  var path_565098 = newJObject()
  var query_565099 = newJObject()
  add(query_565099, "api-version", newJString(apiVersion))
  add(query_565099, "$expand", newJString(Expand))
  add(path_565098, "subscriptionId", newJString(subscriptionId))
  add(path_565098, "resourceGroupName", newJString(resourceGroupName))
  add(path_565098, "vmName", newJString(vmName))
  result = call_565097.call(path_565098, query_565099, nil, nil, nil)

var virtualMachineExtensionsList* = Call_VirtualMachineExtensionsList_565088(
    name: "virtualMachineExtensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions",
    validator: validate_VirtualMachineExtensionsList_565089, base: "",
    url: url_VirtualMachineExtensionsList_565090, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsCreateOrUpdate_565113 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineExtensionsCreateOrUpdate_565115(protocol: Scheme;
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

proc validate_VirtualMachineExtensionsCreateOrUpdate_565114(path: JsonNode;
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
  var valid_565116 = path.getOrDefault("subscriptionId")
  valid_565116 = validateParameter(valid_565116, JString, required = true,
                                 default = nil)
  if valid_565116 != nil:
    section.add "subscriptionId", valid_565116
  var valid_565117 = path.getOrDefault("resourceGroupName")
  valid_565117 = validateParameter(valid_565117, JString, required = true,
                                 default = nil)
  if valid_565117 != nil:
    section.add "resourceGroupName", valid_565117
  var valid_565118 = path.getOrDefault("vmExtensionName")
  valid_565118 = validateParameter(valid_565118, JString, required = true,
                                 default = nil)
  if valid_565118 != nil:
    section.add "vmExtensionName", valid_565118
  var valid_565119 = path.getOrDefault("vmName")
  valid_565119 = validateParameter(valid_565119, JString, required = true,
                                 default = nil)
  if valid_565119 != nil:
    section.add "vmName", valid_565119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565120 = query.getOrDefault("api-version")
  valid_565120 = validateParameter(valid_565120, JString, required = true,
                                 default = nil)
  if valid_565120 != nil:
    section.add "api-version", valid_565120
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

proc call*(call_565122: Call_VirtualMachineExtensionsCreateOrUpdate_565113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update the extension.
  ## 
  let valid = call_565122.validator(path, query, header, formData, body)
  let scheme = call_565122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565122.url(scheme.get, call_565122.host, call_565122.base,
                         call_565122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565122, url, valid)

proc call*(call_565123: Call_VirtualMachineExtensionsCreateOrUpdate_565113;
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
  var path_565124 = newJObject()
  var query_565125 = newJObject()
  var body_565126 = newJObject()
  add(query_565125, "api-version", newJString(apiVersion))
  if extensionParameters != nil:
    body_565126 = extensionParameters
  add(path_565124, "subscriptionId", newJString(subscriptionId))
  add(path_565124, "resourceGroupName", newJString(resourceGroupName))
  add(path_565124, "vmExtensionName", newJString(vmExtensionName))
  add(path_565124, "vmName", newJString(vmName))
  result = call_565123.call(path_565124, query_565125, nil, nil, body_565126)

var virtualMachineExtensionsCreateOrUpdate* = Call_VirtualMachineExtensionsCreateOrUpdate_565113(
    name: "virtualMachineExtensionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsCreateOrUpdate_565114, base: "",
    url: url_VirtualMachineExtensionsCreateOrUpdate_565115,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsGet_565100 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineExtensionsGet_565102(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionsGet_565101(path: JsonNode; query: JsonNode;
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
  var valid_565103 = path.getOrDefault("subscriptionId")
  valid_565103 = validateParameter(valid_565103, JString, required = true,
                                 default = nil)
  if valid_565103 != nil:
    section.add "subscriptionId", valid_565103
  var valid_565104 = path.getOrDefault("resourceGroupName")
  valid_565104 = validateParameter(valid_565104, JString, required = true,
                                 default = nil)
  if valid_565104 != nil:
    section.add "resourceGroupName", valid_565104
  var valid_565105 = path.getOrDefault("vmExtensionName")
  valid_565105 = validateParameter(valid_565105, JString, required = true,
                                 default = nil)
  if valid_565105 != nil:
    section.add "vmExtensionName", valid_565105
  var valid_565106 = path.getOrDefault("vmName")
  valid_565106 = validateParameter(valid_565106, JString, required = true,
                                 default = nil)
  if valid_565106 != nil:
    section.add "vmName", valid_565106
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565107 = query.getOrDefault("api-version")
  valid_565107 = validateParameter(valid_565107, JString, required = true,
                                 default = nil)
  if valid_565107 != nil:
    section.add "api-version", valid_565107
  var valid_565108 = query.getOrDefault("$expand")
  valid_565108 = validateParameter(valid_565108, JString, required = false,
                                 default = nil)
  if valid_565108 != nil:
    section.add "$expand", valid_565108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565109: Call_VirtualMachineExtensionsGet_565100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get the extension.
  ## 
  let valid = call_565109.validator(path, query, header, formData, body)
  let scheme = call_565109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565109.url(scheme.get, call_565109.host, call_565109.base,
                         call_565109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565109, url, valid)

proc call*(call_565110: Call_VirtualMachineExtensionsGet_565100;
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
  var path_565111 = newJObject()
  var query_565112 = newJObject()
  add(query_565112, "api-version", newJString(apiVersion))
  add(query_565112, "$expand", newJString(Expand))
  add(path_565111, "subscriptionId", newJString(subscriptionId))
  add(path_565111, "resourceGroupName", newJString(resourceGroupName))
  add(path_565111, "vmExtensionName", newJString(vmExtensionName))
  add(path_565111, "vmName", newJString(vmName))
  result = call_565110.call(path_565111, query_565112, nil, nil, nil)

var virtualMachineExtensionsGet* = Call_VirtualMachineExtensionsGet_565100(
    name: "virtualMachineExtensionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsGet_565101, base: "",
    url: url_VirtualMachineExtensionsGet_565102, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsUpdate_565139 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineExtensionsUpdate_565141(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionsUpdate_565140(path: JsonNode;
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
  var valid_565142 = path.getOrDefault("subscriptionId")
  valid_565142 = validateParameter(valid_565142, JString, required = true,
                                 default = nil)
  if valid_565142 != nil:
    section.add "subscriptionId", valid_565142
  var valid_565143 = path.getOrDefault("resourceGroupName")
  valid_565143 = validateParameter(valid_565143, JString, required = true,
                                 default = nil)
  if valid_565143 != nil:
    section.add "resourceGroupName", valid_565143
  var valid_565144 = path.getOrDefault("vmExtensionName")
  valid_565144 = validateParameter(valid_565144, JString, required = true,
                                 default = nil)
  if valid_565144 != nil:
    section.add "vmExtensionName", valid_565144
  var valid_565145 = path.getOrDefault("vmName")
  valid_565145 = validateParameter(valid_565145, JString, required = true,
                                 default = nil)
  if valid_565145 != nil:
    section.add "vmName", valid_565145
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565146 = query.getOrDefault("api-version")
  valid_565146 = validateParameter(valid_565146, JString, required = true,
                                 default = nil)
  if valid_565146 != nil:
    section.add "api-version", valid_565146
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

proc call*(call_565148: Call_VirtualMachineExtensionsUpdate_565139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update the extension.
  ## 
  let valid = call_565148.validator(path, query, header, formData, body)
  let scheme = call_565148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565148.url(scheme.get, call_565148.host, call_565148.base,
                         call_565148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565148, url, valid)

proc call*(call_565149: Call_VirtualMachineExtensionsUpdate_565139;
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
  var path_565150 = newJObject()
  var query_565151 = newJObject()
  var body_565152 = newJObject()
  add(query_565151, "api-version", newJString(apiVersion))
  if extensionParameters != nil:
    body_565152 = extensionParameters
  add(path_565150, "subscriptionId", newJString(subscriptionId))
  add(path_565150, "resourceGroupName", newJString(resourceGroupName))
  add(path_565150, "vmExtensionName", newJString(vmExtensionName))
  add(path_565150, "vmName", newJString(vmName))
  result = call_565149.call(path_565150, query_565151, nil, nil, body_565152)

var virtualMachineExtensionsUpdate* = Call_VirtualMachineExtensionsUpdate_565139(
    name: "virtualMachineExtensionsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsUpdate_565140, base: "",
    url: url_VirtualMachineExtensionsUpdate_565141, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsDelete_565127 = ref object of OpenApiRestCall_563565
proc url_VirtualMachineExtensionsDelete_565129(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionsDelete_565128(path: JsonNode;
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
  var valid_565130 = path.getOrDefault("subscriptionId")
  valid_565130 = validateParameter(valid_565130, JString, required = true,
                                 default = nil)
  if valid_565130 != nil:
    section.add "subscriptionId", valid_565130
  var valid_565131 = path.getOrDefault("resourceGroupName")
  valid_565131 = validateParameter(valid_565131, JString, required = true,
                                 default = nil)
  if valid_565131 != nil:
    section.add "resourceGroupName", valid_565131
  var valid_565132 = path.getOrDefault("vmExtensionName")
  valid_565132 = validateParameter(valid_565132, JString, required = true,
                                 default = nil)
  if valid_565132 != nil:
    section.add "vmExtensionName", valid_565132
  var valid_565133 = path.getOrDefault("vmName")
  valid_565133 = validateParameter(valid_565133, JString, required = true,
                                 default = nil)
  if valid_565133 != nil:
    section.add "vmName", valid_565133
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565134 = query.getOrDefault("api-version")
  valid_565134 = validateParameter(valid_565134, JString, required = true,
                                 default = nil)
  if valid_565134 != nil:
    section.add "api-version", valid_565134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565135: Call_VirtualMachineExtensionsDelete_565127; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete the extension.
  ## 
  let valid = call_565135.validator(path, query, header, formData, body)
  let scheme = call_565135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565135.url(scheme.get, call_565135.host, call_565135.base,
                         call_565135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565135, url, valid)

proc call*(call_565136: Call_VirtualMachineExtensionsDelete_565127;
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
  var path_565137 = newJObject()
  var query_565138 = newJObject()
  add(query_565138, "api-version", newJString(apiVersion))
  add(path_565137, "subscriptionId", newJString(subscriptionId))
  add(path_565137, "resourceGroupName", newJString(resourceGroupName))
  add(path_565137, "vmExtensionName", newJString(vmExtensionName))
  add(path_565137, "vmName", newJString(vmName))
  result = call_565136.call(path_565137, query_565138, nil, nil, nil)

var virtualMachineExtensionsDelete* = Call_VirtualMachineExtensionsDelete_565127(
    name: "virtualMachineExtensionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsDelete_565128, base: "",
    url: url_VirtualMachineExtensionsDelete_565129, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGeneralize_565153 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesGeneralize_565155(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesGeneralize_565154(path: JsonNode; query: JsonNode;
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
  var valid_565156 = path.getOrDefault("subscriptionId")
  valid_565156 = validateParameter(valid_565156, JString, required = true,
                                 default = nil)
  if valid_565156 != nil:
    section.add "subscriptionId", valid_565156
  var valid_565157 = path.getOrDefault("resourceGroupName")
  valid_565157 = validateParameter(valid_565157, JString, required = true,
                                 default = nil)
  if valid_565157 != nil:
    section.add "resourceGroupName", valid_565157
  var valid_565158 = path.getOrDefault("vmName")
  valid_565158 = validateParameter(valid_565158, JString, required = true,
                                 default = nil)
  if valid_565158 != nil:
    section.add "vmName", valid_565158
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565159 = query.getOrDefault("api-version")
  valid_565159 = validateParameter(valid_565159, JString, required = true,
                                 default = nil)
  if valid_565159 != nil:
    section.add "api-version", valid_565159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565160: Call_VirtualMachinesGeneralize_565153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the state of the virtual machine to generalized.
  ## 
  let valid = call_565160.validator(path, query, header, formData, body)
  let scheme = call_565160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565160.url(scheme.get, call_565160.host, call_565160.base,
                         call_565160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565160, url, valid)

proc call*(call_565161: Call_VirtualMachinesGeneralize_565153; apiVersion: string;
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
  var path_565162 = newJObject()
  var query_565163 = newJObject()
  add(query_565163, "api-version", newJString(apiVersion))
  add(path_565162, "subscriptionId", newJString(subscriptionId))
  add(path_565162, "resourceGroupName", newJString(resourceGroupName))
  add(path_565162, "vmName", newJString(vmName))
  result = call_565161.call(path_565162, query_565163, nil, nil, nil)

var virtualMachinesGeneralize* = Call_VirtualMachinesGeneralize_565153(
    name: "virtualMachinesGeneralize", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/generalize",
    validator: validate_VirtualMachinesGeneralize_565154, base: "",
    url: url_VirtualMachinesGeneralize_565155, schemes: {Scheme.Https})
type
  Call_VirtualMachinesInstanceView_565164 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesInstanceView_565166(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesInstanceView_565165(path: JsonNode; query: JsonNode;
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
  var valid_565167 = path.getOrDefault("subscriptionId")
  valid_565167 = validateParameter(valid_565167, JString, required = true,
                                 default = nil)
  if valid_565167 != nil:
    section.add "subscriptionId", valid_565167
  var valid_565168 = path.getOrDefault("resourceGroupName")
  valid_565168 = validateParameter(valid_565168, JString, required = true,
                                 default = nil)
  if valid_565168 != nil:
    section.add "resourceGroupName", valid_565168
  var valid_565169 = path.getOrDefault("vmName")
  valid_565169 = validateParameter(valid_565169, JString, required = true,
                                 default = nil)
  if valid_565169 != nil:
    section.add "vmName", valid_565169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565170 = query.getOrDefault("api-version")
  valid_565170 = validateParameter(valid_565170, JString, required = true,
                                 default = nil)
  if valid_565170 != nil:
    section.add "api-version", valid_565170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565171: Call_VirtualMachinesInstanceView_565164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the run-time state of a virtual machine.
  ## 
  let valid = call_565171.validator(path, query, header, formData, body)
  let scheme = call_565171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565171.url(scheme.get, call_565171.host, call_565171.base,
                         call_565171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565171, url, valid)

proc call*(call_565172: Call_VirtualMachinesInstanceView_565164;
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
  var path_565173 = newJObject()
  var query_565174 = newJObject()
  add(query_565174, "api-version", newJString(apiVersion))
  add(path_565173, "subscriptionId", newJString(subscriptionId))
  add(path_565173, "resourceGroupName", newJString(resourceGroupName))
  add(path_565173, "vmName", newJString(vmName))
  result = call_565172.call(path_565173, query_565174, nil, nil, nil)

var virtualMachinesInstanceView* = Call_VirtualMachinesInstanceView_565164(
    name: "virtualMachinesInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/instanceView",
    validator: validate_VirtualMachinesInstanceView_565165, base: "",
    url: url_VirtualMachinesInstanceView_565166, schemes: {Scheme.Https})
type
  Call_VirtualMachinesPerformMaintenance_565175 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesPerformMaintenance_565177(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesPerformMaintenance_565176(path: JsonNode;
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
  var valid_565178 = path.getOrDefault("subscriptionId")
  valid_565178 = validateParameter(valid_565178, JString, required = true,
                                 default = nil)
  if valid_565178 != nil:
    section.add "subscriptionId", valid_565178
  var valid_565179 = path.getOrDefault("resourceGroupName")
  valid_565179 = validateParameter(valid_565179, JString, required = true,
                                 default = nil)
  if valid_565179 != nil:
    section.add "resourceGroupName", valid_565179
  var valid_565180 = path.getOrDefault("vmName")
  valid_565180 = validateParameter(valid_565180, JString, required = true,
                                 default = nil)
  if valid_565180 != nil:
    section.add "vmName", valid_565180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565181 = query.getOrDefault("api-version")
  valid_565181 = validateParameter(valid_565181, JString, required = true,
                                 default = nil)
  if valid_565181 != nil:
    section.add "api-version", valid_565181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565182: Call_VirtualMachinesPerformMaintenance_565175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to perform maintenance on a virtual machine.
  ## 
  let valid = call_565182.validator(path, query, header, formData, body)
  let scheme = call_565182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565182.url(scheme.get, call_565182.host, call_565182.base,
                         call_565182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565182, url, valid)

proc call*(call_565183: Call_VirtualMachinesPerformMaintenance_565175;
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
  var path_565184 = newJObject()
  var query_565185 = newJObject()
  add(query_565185, "api-version", newJString(apiVersion))
  add(path_565184, "subscriptionId", newJString(subscriptionId))
  add(path_565184, "resourceGroupName", newJString(resourceGroupName))
  add(path_565184, "vmName", newJString(vmName))
  result = call_565183.call(path_565184, query_565185, nil, nil, nil)

var virtualMachinesPerformMaintenance* = Call_VirtualMachinesPerformMaintenance_565175(
    name: "virtualMachinesPerformMaintenance", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/performMaintenance",
    validator: validate_VirtualMachinesPerformMaintenance_565176, base: "",
    url: url_VirtualMachinesPerformMaintenance_565177, schemes: {Scheme.Https})
type
  Call_VirtualMachinesPowerOff_565186 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesPowerOff_565188(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesPowerOff_565187(path: JsonNode; query: JsonNode;
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
  var valid_565189 = path.getOrDefault("subscriptionId")
  valid_565189 = validateParameter(valid_565189, JString, required = true,
                                 default = nil)
  if valid_565189 != nil:
    section.add "subscriptionId", valid_565189
  var valid_565190 = path.getOrDefault("resourceGroupName")
  valid_565190 = validateParameter(valid_565190, JString, required = true,
                                 default = nil)
  if valid_565190 != nil:
    section.add "resourceGroupName", valid_565190
  var valid_565191 = path.getOrDefault("vmName")
  valid_565191 = validateParameter(valid_565191, JString, required = true,
                                 default = nil)
  if valid_565191 != nil:
    section.add "vmName", valid_565191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565192 = query.getOrDefault("api-version")
  valid_565192 = validateParameter(valid_565192, JString, required = true,
                                 default = nil)
  if valid_565192 != nil:
    section.add "api-version", valid_565192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565193: Call_VirtualMachinesPowerOff_565186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to power off (stop) a virtual machine. The virtual machine can be restarted with the same provisioned resources. You are still charged for this virtual machine.
  ## 
  let valid = call_565193.validator(path, query, header, formData, body)
  let scheme = call_565193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565193.url(scheme.get, call_565193.host, call_565193.base,
                         call_565193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565193, url, valid)

proc call*(call_565194: Call_VirtualMachinesPowerOff_565186; apiVersion: string;
          subscriptionId: string; resourceGroupName: string; vmName: string): Recallable =
  ## virtualMachinesPowerOff
  ## The operation to power off (stop) a virtual machine. The virtual machine can be restarted with the same provisioned resources. You are still charged for this virtual machine.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_565195 = newJObject()
  var query_565196 = newJObject()
  add(query_565196, "api-version", newJString(apiVersion))
  add(path_565195, "subscriptionId", newJString(subscriptionId))
  add(path_565195, "resourceGroupName", newJString(resourceGroupName))
  add(path_565195, "vmName", newJString(vmName))
  result = call_565194.call(path_565195, query_565196, nil, nil, nil)

var virtualMachinesPowerOff* = Call_VirtualMachinesPowerOff_565186(
    name: "virtualMachinesPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/powerOff",
    validator: validate_VirtualMachinesPowerOff_565187, base: "",
    url: url_VirtualMachinesPowerOff_565188, schemes: {Scheme.Https})
type
  Call_VirtualMachinesRedeploy_565197 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesRedeploy_565199(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesRedeploy_565198(path: JsonNode; query: JsonNode;
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
  var valid_565200 = path.getOrDefault("subscriptionId")
  valid_565200 = validateParameter(valid_565200, JString, required = true,
                                 default = nil)
  if valid_565200 != nil:
    section.add "subscriptionId", valid_565200
  var valid_565201 = path.getOrDefault("resourceGroupName")
  valid_565201 = validateParameter(valid_565201, JString, required = true,
                                 default = nil)
  if valid_565201 != nil:
    section.add "resourceGroupName", valid_565201
  var valid_565202 = path.getOrDefault("vmName")
  valid_565202 = validateParameter(valid_565202, JString, required = true,
                                 default = nil)
  if valid_565202 != nil:
    section.add "vmName", valid_565202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565203 = query.getOrDefault("api-version")
  valid_565203 = validateParameter(valid_565203, JString, required = true,
                                 default = nil)
  if valid_565203 != nil:
    section.add "api-version", valid_565203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565204: Call_VirtualMachinesRedeploy_565197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shuts down the virtual machine, moves it to a new node, and powers it back on.
  ## 
  let valid = call_565204.validator(path, query, header, formData, body)
  let scheme = call_565204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565204.url(scheme.get, call_565204.host, call_565204.base,
                         call_565204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565204, url, valid)

proc call*(call_565205: Call_VirtualMachinesRedeploy_565197; apiVersion: string;
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
  var path_565206 = newJObject()
  var query_565207 = newJObject()
  add(query_565207, "api-version", newJString(apiVersion))
  add(path_565206, "subscriptionId", newJString(subscriptionId))
  add(path_565206, "resourceGroupName", newJString(resourceGroupName))
  add(path_565206, "vmName", newJString(vmName))
  result = call_565205.call(path_565206, query_565207, nil, nil, nil)

var virtualMachinesRedeploy* = Call_VirtualMachinesRedeploy_565197(
    name: "virtualMachinesRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/redeploy",
    validator: validate_VirtualMachinesRedeploy_565198, base: "",
    url: url_VirtualMachinesRedeploy_565199, schemes: {Scheme.Https})
type
  Call_VirtualMachinesRestart_565208 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesRestart_565210(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesRestart_565209(path: JsonNode; query: JsonNode;
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
  var valid_565211 = path.getOrDefault("subscriptionId")
  valid_565211 = validateParameter(valid_565211, JString, required = true,
                                 default = nil)
  if valid_565211 != nil:
    section.add "subscriptionId", valid_565211
  var valid_565212 = path.getOrDefault("resourceGroupName")
  valid_565212 = validateParameter(valid_565212, JString, required = true,
                                 default = nil)
  if valid_565212 != nil:
    section.add "resourceGroupName", valid_565212
  var valid_565213 = path.getOrDefault("vmName")
  valid_565213 = validateParameter(valid_565213, JString, required = true,
                                 default = nil)
  if valid_565213 != nil:
    section.add "vmName", valid_565213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565214 = query.getOrDefault("api-version")
  valid_565214 = validateParameter(valid_565214, JString, required = true,
                                 default = nil)
  if valid_565214 != nil:
    section.add "api-version", valid_565214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565215: Call_VirtualMachinesRestart_565208; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to restart a virtual machine.
  ## 
  let valid = call_565215.validator(path, query, header, formData, body)
  let scheme = call_565215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565215.url(scheme.get, call_565215.host, call_565215.base,
                         call_565215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565215, url, valid)

proc call*(call_565216: Call_VirtualMachinesRestart_565208; apiVersion: string;
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
  var path_565217 = newJObject()
  var query_565218 = newJObject()
  add(query_565218, "api-version", newJString(apiVersion))
  add(path_565217, "subscriptionId", newJString(subscriptionId))
  add(path_565217, "resourceGroupName", newJString(resourceGroupName))
  add(path_565217, "vmName", newJString(vmName))
  result = call_565216.call(path_565217, query_565218, nil, nil, nil)

var virtualMachinesRestart* = Call_VirtualMachinesRestart_565208(
    name: "virtualMachinesRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/restart",
    validator: validate_VirtualMachinesRestart_565209, base: "",
    url: url_VirtualMachinesRestart_565210, schemes: {Scheme.Https})
type
  Call_VirtualMachinesStart_565219 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesStart_565221(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesStart_565220(path: JsonNode; query: JsonNode;
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
  var valid_565222 = path.getOrDefault("subscriptionId")
  valid_565222 = validateParameter(valid_565222, JString, required = true,
                                 default = nil)
  if valid_565222 != nil:
    section.add "subscriptionId", valid_565222
  var valid_565223 = path.getOrDefault("resourceGroupName")
  valid_565223 = validateParameter(valid_565223, JString, required = true,
                                 default = nil)
  if valid_565223 != nil:
    section.add "resourceGroupName", valid_565223
  var valid_565224 = path.getOrDefault("vmName")
  valid_565224 = validateParameter(valid_565224, JString, required = true,
                                 default = nil)
  if valid_565224 != nil:
    section.add "vmName", valid_565224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565225 = query.getOrDefault("api-version")
  valid_565225 = validateParameter(valid_565225, JString, required = true,
                                 default = nil)
  if valid_565225 != nil:
    section.add "api-version", valid_565225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565226: Call_VirtualMachinesStart_565219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to start a virtual machine.
  ## 
  let valid = call_565226.validator(path, query, header, formData, body)
  let scheme = call_565226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565226.url(scheme.get, call_565226.host, call_565226.base,
                         call_565226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565226, url, valid)

proc call*(call_565227: Call_VirtualMachinesStart_565219; apiVersion: string;
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
  var path_565228 = newJObject()
  var query_565229 = newJObject()
  add(query_565229, "api-version", newJString(apiVersion))
  add(path_565228, "subscriptionId", newJString(subscriptionId))
  add(path_565228, "resourceGroupName", newJString(resourceGroupName))
  add(path_565228, "vmName", newJString(vmName))
  result = call_565227.call(path_565228, query_565229, nil, nil, nil)

var virtualMachinesStart* = Call_VirtualMachinesStart_565219(
    name: "virtualMachinesStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/start",
    validator: validate_VirtualMachinesStart_565220, base: "",
    url: url_VirtualMachinesStart_565221, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListAvailableSizes_565230 = ref object of OpenApiRestCall_563565
proc url_VirtualMachinesListAvailableSizes_565232(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesListAvailableSizes_565231(path: JsonNode;
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
  var valid_565233 = path.getOrDefault("subscriptionId")
  valid_565233 = validateParameter(valid_565233, JString, required = true,
                                 default = nil)
  if valid_565233 != nil:
    section.add "subscriptionId", valid_565233
  var valid_565234 = path.getOrDefault("resourceGroupName")
  valid_565234 = validateParameter(valid_565234, JString, required = true,
                                 default = nil)
  if valid_565234 != nil:
    section.add "resourceGroupName", valid_565234
  var valid_565235 = path.getOrDefault("vmName")
  valid_565235 = validateParameter(valid_565235, JString, required = true,
                                 default = nil)
  if valid_565235 != nil:
    section.add "vmName", valid_565235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565236 = query.getOrDefault("api-version")
  valid_565236 = validateParameter(valid_565236, JString, required = true,
                                 default = nil)
  if valid_565236 != nil:
    section.add "api-version", valid_565236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565237: Call_VirtualMachinesListAvailableSizes_565230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available virtual machine sizes to which the specified virtual machine can be resized.
  ## 
  let valid = call_565237.validator(path, query, header, formData, body)
  let scheme = call_565237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565237.url(scheme.get, call_565237.host, call_565237.base,
                         call_565237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565237, url, valid)

proc call*(call_565238: Call_VirtualMachinesListAvailableSizes_565230;
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
  var path_565239 = newJObject()
  var query_565240 = newJObject()
  add(query_565240, "api-version", newJString(apiVersion))
  add(path_565239, "subscriptionId", newJString(subscriptionId))
  add(path_565239, "resourceGroupName", newJString(resourceGroupName))
  add(path_565239, "vmName", newJString(vmName))
  result = call_565238.call(path_565239, query_565240, nil, nil, nil)

var virtualMachinesListAvailableSizes* = Call_VirtualMachinesListAvailableSizes_565230(
    name: "virtualMachinesListAvailableSizes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/vmSizes",
    validator: validate_VirtualMachinesListAvailableSizes_565231, base: "",
    url: url_VirtualMachinesListAvailableSizes_565232, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
