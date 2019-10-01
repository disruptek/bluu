
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ComputeManagementClient
## version: 2018-10-01
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

  OpenApiRestCall_567667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567667): Option[Scheme] {.used.} =
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
  macServiceName = "compute"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567889 = ref object of OpenApiRestCall_567667
proc url_OperationsList_567891(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567890(path: JsonNode; query: JsonNode;
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
  var valid_568050 = query.getOrDefault("api-version")
  valid_568050 = validateParameter(valid_568050, JString, required = true,
                                 default = nil)
  if valid_568050 != nil:
    section.add "api-version", valid_568050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568073: Call_OperationsList_567889; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of compute operations.
  ## 
  let valid = call_568073.validator(path, query, header, formData, body)
  let scheme = call_568073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568073.url(scheme.get, call_568073.host, call_568073.base,
                         call_568073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568073, url, valid)

proc call*(call_568144: Call_OperationsList_567889; apiVersion: string): Recallable =
  ## operationsList
  ## Gets a list of compute operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568145 = newJObject()
  add(query_568145, "api-version", newJString(apiVersion))
  result = call_568144.call(nil, query_568145, nil, nil, nil)

var operationsList* = Call_OperationsList_567889(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Compute/operations",
    validator: validate_OperationsList_567890, base: "", url: url_OperationsList_567891,
    schemes: {Scheme.Https})
type
  Call_AvailabilitySetsListBySubscription_568185 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsListBySubscription_568187(protocol: Scheme; host: string;
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

proc validate_AvailabilitySetsListBySubscription_568186(path: JsonNode;
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
  var valid_568203 = path.getOrDefault("subscriptionId")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "subscriptionId", valid_568203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : The expand expression to apply to the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568204 = query.getOrDefault("api-version")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "api-version", valid_568204
  var valid_568205 = query.getOrDefault("$expand")
  valid_568205 = validateParameter(valid_568205, JString, required = false,
                                 default = nil)
  if valid_568205 != nil:
    section.add "$expand", valid_568205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568206: Call_AvailabilitySetsListBySubscription_568185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all availability sets in a subscription.
  ## 
  let valid = call_568206.validator(path, query, header, formData, body)
  let scheme = call_568206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568206.url(scheme.get, call_568206.host, call_568206.base,
                         call_568206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568206, url, valid)

proc call*(call_568207: Call_AvailabilitySetsListBySubscription_568185;
          apiVersion: string; subscriptionId: string; Expand: string = ""): Recallable =
  ## availabilitySetsListBySubscription
  ## Lists all availability sets in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : The expand expression to apply to the operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568208 = newJObject()
  var query_568209 = newJObject()
  add(query_568209, "api-version", newJString(apiVersion))
  add(query_568209, "$expand", newJString(Expand))
  add(path_568208, "subscriptionId", newJString(subscriptionId))
  result = call_568207.call(path_568208, query_568209, nil, nil, nil)

var availabilitySetsListBySubscription* = Call_AvailabilitySetsListBySubscription_568185(
    name: "availabilitySetsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/availabilitySets",
    validator: validate_AvailabilitySetsListBySubscription_568186, base: "",
    url: url_AvailabilitySetsListBySubscription_568187, schemes: {Scheme.Https})
type
  Call_ImagesList_568210 = ref object of OpenApiRestCall_567667
proc url_ImagesList_568212(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ImagesList_568211(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568213 = path.getOrDefault("subscriptionId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "subscriptionId", valid_568213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568214 = query.getOrDefault("api-version")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "api-version", valid_568214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568215: Call_ImagesList_568210; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Images in the subscription. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.
  ## 
  let valid = call_568215.validator(path, query, header, formData, body)
  let scheme = call_568215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568215.url(scheme.get, call_568215.host, call_568215.base,
                         call_568215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568215, url, valid)

proc call*(call_568216: Call_ImagesList_568210; apiVersion: string;
          subscriptionId: string): Recallable =
  ## imagesList
  ## Gets the list of Images in the subscription. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568217 = newJObject()
  var query_568218 = newJObject()
  add(query_568218, "api-version", newJString(apiVersion))
  add(path_568217, "subscriptionId", newJString(subscriptionId))
  result = call_568216.call(path_568217, query_568218, nil, nil, nil)

var imagesList* = Call_ImagesList_568210(name: "imagesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/images",
                                      validator: validate_ImagesList_568211,
                                      base: "", url: url_ImagesList_568212,
                                      schemes: {Scheme.Https})
type
  Call_LogAnalyticsExportRequestRateByInterval_568219 = ref object of OpenApiRestCall_567667
proc url_LogAnalyticsExportRequestRateByInterval_568221(protocol: Scheme;
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

proc validate_LogAnalyticsExportRequestRateByInterval_568220(path: JsonNode;
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
  var valid_568239 = path.getOrDefault("subscriptionId")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "subscriptionId", valid_568239
  var valid_568240 = path.getOrDefault("location")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "location", valid_568240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568241 = query.getOrDefault("api-version")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "api-version", valid_568241
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

proc call*(call_568243: Call_LogAnalyticsExportRequestRateByInterval_568219;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Export logs that show Api requests made by this subscription in the given time window to show throttling activities.
  ## 
  let valid = call_568243.validator(path, query, header, formData, body)
  let scheme = call_568243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568243.url(scheme.get, call_568243.host, call_568243.base,
                         call_568243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568243, url, valid)

proc call*(call_568244: Call_LogAnalyticsExportRequestRateByInterval_568219;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          location: string): Recallable =
  ## logAnalyticsExportRequestRateByInterval
  ## Export logs that show Api requests made by this subscription in the given time window to show throttling activities.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the LogAnalytics getRequestRateByInterval Api.
  ##   location: string (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  var path_568245 = newJObject()
  var query_568246 = newJObject()
  var body_568247 = newJObject()
  add(query_568246, "api-version", newJString(apiVersion))
  add(path_568245, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568247 = parameters
  add(path_568245, "location", newJString(location))
  result = call_568244.call(path_568245, query_568246, nil, nil, body_568247)

var logAnalyticsExportRequestRateByInterval* = Call_LogAnalyticsExportRequestRateByInterval_568219(
    name: "logAnalyticsExportRequestRateByInterval", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/logAnalytics/apiAccess/getRequestRateByInterval",
    validator: validate_LogAnalyticsExportRequestRateByInterval_568220, base: "",
    url: url_LogAnalyticsExportRequestRateByInterval_568221,
    schemes: {Scheme.Https})
type
  Call_LogAnalyticsExportThrottledRequests_568248 = ref object of OpenApiRestCall_567667
proc url_LogAnalyticsExportThrottledRequests_568250(protocol: Scheme; host: string;
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

proc validate_LogAnalyticsExportThrottledRequests_568249(path: JsonNode;
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
  var valid_568251 = path.getOrDefault("subscriptionId")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "subscriptionId", valid_568251
  var valid_568252 = path.getOrDefault("location")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "location", valid_568252
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568253 = query.getOrDefault("api-version")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "api-version", valid_568253
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

proc call*(call_568255: Call_LogAnalyticsExportThrottledRequests_568248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Export logs that show total throttled Api requests for this subscription in the given time window.
  ## 
  let valid = call_568255.validator(path, query, header, formData, body)
  let scheme = call_568255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568255.url(scheme.get, call_568255.host, call_568255.base,
                         call_568255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568255, url, valid)

proc call*(call_568256: Call_LogAnalyticsExportThrottledRequests_568248;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          location: string): Recallable =
  ## logAnalyticsExportThrottledRequests
  ## Export logs that show total throttled Api requests for this subscription in the given time window.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the LogAnalytics getThrottledRequests Api.
  ##   location: string (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  var path_568257 = newJObject()
  var query_568258 = newJObject()
  var body_568259 = newJObject()
  add(query_568258, "api-version", newJString(apiVersion))
  add(path_568257, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568259 = parameters
  add(path_568257, "location", newJString(location))
  result = call_568256.call(path_568257, query_568258, nil, nil, body_568259)

var logAnalyticsExportThrottledRequests* = Call_LogAnalyticsExportThrottledRequests_568248(
    name: "logAnalyticsExportThrottledRequests", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/logAnalytics/apiAccess/getThrottledRequests",
    validator: validate_LogAnalyticsExportThrottledRequests_568249, base: "",
    url: url_LogAnalyticsExportThrottledRequests_568250, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesListPublishers_568260 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineImagesListPublishers_568262(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImagesListPublishers_568261(path: JsonNode;
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
  var valid_568263 = path.getOrDefault("subscriptionId")
  valid_568263 = validateParameter(valid_568263, JString, required = true,
                                 default = nil)
  if valid_568263 != nil:
    section.add "subscriptionId", valid_568263
  var valid_568264 = path.getOrDefault("location")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "location", valid_568264
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568265 = query.getOrDefault("api-version")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "api-version", valid_568265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568266: Call_VirtualMachineImagesListPublishers_568260;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual machine image publishers for the specified Azure location.
  ## 
  let valid = call_568266.validator(path, query, header, formData, body)
  let scheme = call_568266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568266.url(scheme.get, call_568266.host, call_568266.base,
                         call_568266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568266, url, valid)

proc call*(call_568267: Call_VirtualMachineImagesListPublishers_568260;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## virtualMachineImagesListPublishers
  ## Gets a list of virtual machine image publishers for the specified Azure location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_568268 = newJObject()
  var query_568269 = newJObject()
  add(query_568269, "api-version", newJString(apiVersion))
  add(path_568268, "subscriptionId", newJString(subscriptionId))
  add(path_568268, "location", newJString(location))
  result = call_568267.call(path_568268, query_568269, nil, nil, nil)

var virtualMachineImagesListPublishers* = Call_VirtualMachineImagesListPublishers_568260(
    name: "virtualMachineImagesListPublishers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers",
    validator: validate_VirtualMachineImagesListPublishers_568261, base: "",
    url: url_VirtualMachineImagesListPublishers_568262, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionImagesListTypes_568270 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionImagesListTypes_568272(protocol: Scheme;
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

proc validate_VirtualMachineExtensionImagesListTypes_568271(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of virtual machine extension image types.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: JString (required)
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568273 = path.getOrDefault("subscriptionId")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "subscriptionId", valid_568273
  var valid_568274 = path.getOrDefault("publisherName")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "publisherName", valid_568274
  var valid_568275 = path.getOrDefault("location")
  valid_568275 = validateParameter(valid_568275, JString, required = true,
                                 default = nil)
  if valid_568275 != nil:
    section.add "location", valid_568275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568276 = query.getOrDefault("api-version")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "api-version", valid_568276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568277: Call_VirtualMachineExtensionImagesListTypes_568270;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual machine extension image types.
  ## 
  let valid = call_568277.validator(path, query, header, formData, body)
  let scheme = call_568277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568277.url(scheme.get, call_568277.host, call_568277.base,
                         call_568277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568277, url, valid)

proc call*(call_568278: Call_VirtualMachineExtensionImagesListTypes_568270;
          apiVersion: string; subscriptionId: string; publisherName: string;
          location: string): Recallable =
  ## virtualMachineExtensionImagesListTypes
  ## Gets a list of virtual machine extension image types.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: string (required)
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_568279 = newJObject()
  var query_568280 = newJObject()
  add(query_568280, "api-version", newJString(apiVersion))
  add(path_568279, "subscriptionId", newJString(subscriptionId))
  add(path_568279, "publisherName", newJString(publisherName))
  add(path_568279, "location", newJString(location))
  result = call_568278.call(path_568279, query_568280, nil, nil, nil)

var virtualMachineExtensionImagesListTypes* = Call_VirtualMachineExtensionImagesListTypes_568270(
    name: "virtualMachineExtensionImagesListTypes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types",
    validator: validate_VirtualMachineExtensionImagesListTypes_568271, base: "",
    url: url_VirtualMachineExtensionImagesListTypes_568272,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionImagesListVersions_568281 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionImagesListVersions_568283(protocol: Scheme;
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

proc validate_VirtualMachineExtensionImagesListVersions_568282(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of virtual machine extension image versions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: JString (required)
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_568284 = path.getOrDefault("type")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "type", valid_568284
  var valid_568285 = path.getOrDefault("subscriptionId")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "subscriptionId", valid_568285
  var valid_568286 = path.getOrDefault("publisherName")
  valid_568286 = validateParameter(valid_568286, JString, required = true,
                                 default = nil)
  if valid_568286 != nil:
    section.add "publisherName", valid_568286
  var valid_568287 = path.getOrDefault("location")
  valid_568287 = validateParameter(valid_568287, JString, required = true,
                                 default = nil)
  if valid_568287 != nil:
    section.add "location", valid_568287
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_568288 = query.getOrDefault("$orderby")
  valid_568288 = validateParameter(valid_568288, JString, required = false,
                                 default = nil)
  if valid_568288 != nil:
    section.add "$orderby", valid_568288
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568289 = query.getOrDefault("api-version")
  valid_568289 = validateParameter(valid_568289, JString, required = true,
                                 default = nil)
  if valid_568289 != nil:
    section.add "api-version", valid_568289
  var valid_568290 = query.getOrDefault("$top")
  valid_568290 = validateParameter(valid_568290, JInt, required = false, default = nil)
  if valid_568290 != nil:
    section.add "$top", valid_568290
  var valid_568291 = query.getOrDefault("$filter")
  valid_568291 = validateParameter(valid_568291, JString, required = false,
                                 default = nil)
  if valid_568291 != nil:
    section.add "$filter", valid_568291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568292: Call_VirtualMachineExtensionImagesListVersions_568281;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual machine extension image versions.
  ## 
  let valid = call_568292.validator(path, query, header, formData, body)
  let scheme = call_568292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568292.url(scheme.get, call_568292.host, call_568292.base,
                         call_568292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568292, url, valid)

proc call*(call_568293: Call_VirtualMachineExtensionImagesListVersions_568281;
          `type`: string; apiVersion: string; subscriptionId: string;
          publisherName: string; location: string; Orderby: string = ""; Top: int = 0;
          Filter: string = ""): Recallable =
  ## virtualMachineExtensionImagesListVersions
  ## Gets a list of virtual machine extension image versions.
  ##   type: string (required)
  ##   Orderby: string
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##   publisherName: string (required)
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568294 = newJObject()
  var query_568295 = newJObject()
  add(path_568294, "type", newJString(`type`))
  add(query_568295, "$orderby", newJString(Orderby))
  add(query_568295, "api-version", newJString(apiVersion))
  add(path_568294, "subscriptionId", newJString(subscriptionId))
  add(query_568295, "$top", newJInt(Top))
  add(path_568294, "publisherName", newJString(publisherName))
  add(path_568294, "location", newJString(location))
  add(query_568295, "$filter", newJString(Filter))
  result = call_568293.call(path_568294, query_568295, nil, nil, nil)

var virtualMachineExtensionImagesListVersions* = Call_VirtualMachineExtensionImagesListVersions_568281(
    name: "virtualMachineExtensionImagesListVersions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types/{type}/versions",
    validator: validate_VirtualMachineExtensionImagesListVersions_568282,
    base: "", url: url_VirtualMachineExtensionImagesListVersions_568283,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionImagesGet_568296 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionImagesGet_568298(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionImagesGet_568297(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a virtual machine extension image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   type: JString (required)
  ##   version: JString (required)
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: JString (required)
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `type` field"
  var valid_568299 = path.getOrDefault("type")
  valid_568299 = validateParameter(valid_568299, JString, required = true,
                                 default = nil)
  if valid_568299 != nil:
    section.add "type", valid_568299
  var valid_568300 = path.getOrDefault("version")
  valid_568300 = validateParameter(valid_568300, JString, required = true,
                                 default = nil)
  if valid_568300 != nil:
    section.add "version", valid_568300
  var valid_568301 = path.getOrDefault("subscriptionId")
  valid_568301 = validateParameter(valid_568301, JString, required = true,
                                 default = nil)
  if valid_568301 != nil:
    section.add "subscriptionId", valid_568301
  var valid_568302 = path.getOrDefault("publisherName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "publisherName", valid_568302
  var valid_568303 = path.getOrDefault("location")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "location", valid_568303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568304 = query.getOrDefault("api-version")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "api-version", valid_568304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568305: Call_VirtualMachineExtensionImagesGet_568296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a virtual machine extension image.
  ## 
  let valid = call_568305.validator(path, query, header, formData, body)
  let scheme = call_568305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568305.url(scheme.get, call_568305.host, call_568305.base,
                         call_568305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568305, url, valid)

proc call*(call_568306: Call_VirtualMachineExtensionImagesGet_568296;
          `type`: string; apiVersion: string; version: string; subscriptionId: string;
          publisherName: string; location: string): Recallable =
  ## virtualMachineExtensionImagesGet
  ## Gets a virtual machine extension image.
  ##   type: string (required)
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   version: string (required)
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: string (required)
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_568307 = newJObject()
  var query_568308 = newJObject()
  add(path_568307, "type", newJString(`type`))
  add(query_568308, "api-version", newJString(apiVersion))
  add(path_568307, "version", newJString(version))
  add(path_568307, "subscriptionId", newJString(subscriptionId))
  add(path_568307, "publisherName", newJString(publisherName))
  add(path_568307, "location", newJString(location))
  result = call_568306.call(path_568307, query_568308, nil, nil, nil)

var virtualMachineExtensionImagesGet* = Call_VirtualMachineExtensionImagesGet_568296(
    name: "virtualMachineExtensionImagesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types/{type}/versions/{version}",
    validator: validate_VirtualMachineExtensionImagesGet_568297, base: "",
    url: url_VirtualMachineExtensionImagesGet_568298, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesListOffers_568309 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineImagesListOffers_568311(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImagesListOffers_568310(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of virtual machine image offers for the specified location and publisher.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: JString (required)
  ##                : A valid image publisher.
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568312 = path.getOrDefault("subscriptionId")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "subscriptionId", valid_568312
  var valid_568313 = path.getOrDefault("publisherName")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "publisherName", valid_568313
  var valid_568314 = path.getOrDefault("location")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "location", valid_568314
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568315 = query.getOrDefault("api-version")
  valid_568315 = validateParameter(valid_568315, JString, required = true,
                                 default = nil)
  if valid_568315 != nil:
    section.add "api-version", valid_568315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568316: Call_VirtualMachineImagesListOffers_568309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of virtual machine image offers for the specified location and publisher.
  ## 
  let valid = call_568316.validator(path, query, header, formData, body)
  let scheme = call_568316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568316.url(scheme.get, call_568316.host, call_568316.base,
                         call_568316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568316, url, valid)

proc call*(call_568317: Call_VirtualMachineImagesListOffers_568309;
          apiVersion: string; subscriptionId: string; publisherName: string;
          location: string): Recallable =
  ## virtualMachineImagesListOffers
  ## Gets a list of virtual machine image offers for the specified location and publisher.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: string (required)
  ##                : A valid image publisher.
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_568318 = newJObject()
  var query_568319 = newJObject()
  add(query_568319, "api-version", newJString(apiVersion))
  add(path_568318, "subscriptionId", newJString(subscriptionId))
  add(path_568318, "publisherName", newJString(publisherName))
  add(path_568318, "location", newJString(location))
  result = call_568317.call(path_568318, query_568319, nil, nil, nil)

var virtualMachineImagesListOffers* = Call_VirtualMachineImagesListOffers_568309(
    name: "virtualMachineImagesListOffers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers",
    validator: validate_VirtualMachineImagesListOffers_568310, base: "",
    url: url_VirtualMachineImagesListOffers_568311, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesListSkus_568320 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineImagesListSkus_568322(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImagesListSkus_568321(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of virtual machine image SKUs for the specified location, publisher, and offer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: JString (required)
  ##                : A valid image publisher.
  ##   offer: JString (required)
  ##        : A valid image publisher offer.
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568323 = path.getOrDefault("subscriptionId")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "subscriptionId", valid_568323
  var valid_568324 = path.getOrDefault("publisherName")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "publisherName", valid_568324
  var valid_568325 = path.getOrDefault("offer")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "offer", valid_568325
  var valid_568326 = path.getOrDefault("location")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "location", valid_568326
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568327 = query.getOrDefault("api-version")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "api-version", valid_568327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568328: Call_VirtualMachineImagesListSkus_568320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of virtual machine image SKUs for the specified location, publisher, and offer.
  ## 
  let valid = call_568328.validator(path, query, header, formData, body)
  let scheme = call_568328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568328.url(scheme.get, call_568328.host, call_568328.base,
                         call_568328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568328, url, valid)

proc call*(call_568329: Call_VirtualMachineImagesListSkus_568320;
          apiVersion: string; subscriptionId: string; publisherName: string;
          offer: string; location: string): Recallable =
  ## virtualMachineImagesListSkus
  ## Gets a list of virtual machine image SKUs for the specified location, publisher, and offer.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: string (required)
  ##                : A valid image publisher.
  ##   offer: string (required)
  ##        : A valid image publisher offer.
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_568330 = newJObject()
  var query_568331 = newJObject()
  add(query_568331, "api-version", newJString(apiVersion))
  add(path_568330, "subscriptionId", newJString(subscriptionId))
  add(path_568330, "publisherName", newJString(publisherName))
  add(path_568330, "offer", newJString(offer))
  add(path_568330, "location", newJString(location))
  result = call_568329.call(path_568330, query_568331, nil, nil, nil)

var virtualMachineImagesListSkus* = Call_VirtualMachineImagesListSkus_568320(
    name: "virtualMachineImagesListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus",
    validator: validate_VirtualMachineImagesListSkus_568321, base: "",
    url: url_VirtualMachineImagesListSkus_568322, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesList_568332 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineImagesList_568334(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImagesList_568333(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all virtual machine image versions for the specified location, publisher, offer, and SKU.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skus: JString (required)
  ##       : A valid image SKU.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: JString (required)
  ##                : A valid image publisher.
  ##   offer: JString (required)
  ##        : A valid image publisher offer.
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skus` field"
  var valid_568335 = path.getOrDefault("skus")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "skus", valid_568335
  var valid_568336 = path.getOrDefault("subscriptionId")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "subscriptionId", valid_568336
  var valid_568337 = path.getOrDefault("publisherName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "publisherName", valid_568337
  var valid_568338 = path.getOrDefault("offer")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "offer", valid_568338
  var valid_568339 = path.getOrDefault("location")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "location", valid_568339
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_568340 = query.getOrDefault("$orderby")
  valid_568340 = validateParameter(valid_568340, JString, required = false,
                                 default = nil)
  if valid_568340 != nil:
    section.add "$orderby", valid_568340
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568341 = query.getOrDefault("api-version")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "api-version", valid_568341
  var valid_568342 = query.getOrDefault("$top")
  valid_568342 = validateParameter(valid_568342, JInt, required = false, default = nil)
  if valid_568342 != nil:
    section.add "$top", valid_568342
  var valid_568343 = query.getOrDefault("$filter")
  valid_568343 = validateParameter(valid_568343, JString, required = false,
                                 default = nil)
  if valid_568343 != nil:
    section.add "$filter", valid_568343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568344: Call_VirtualMachineImagesList_568332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all virtual machine image versions for the specified location, publisher, offer, and SKU.
  ## 
  let valid = call_568344.validator(path, query, header, formData, body)
  let scheme = call_568344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568344.url(scheme.get, call_568344.host, call_568344.base,
                         call_568344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568344, url, valid)

proc call*(call_568345: Call_VirtualMachineImagesList_568332; apiVersion: string;
          skus: string; subscriptionId: string; publisherName: string; offer: string;
          location: string; Orderby: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## virtualMachineImagesList
  ## Gets a list of all virtual machine image versions for the specified location, publisher, offer, and SKU.
  ##   Orderby: string
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   skus: string (required)
  ##       : A valid image SKU.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##   publisherName: string (required)
  ##                : A valid image publisher.
  ##   offer: string (required)
  ##        : A valid image publisher offer.
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  ##   Filter: string
  ##         : The filter to apply on the operation.
  var path_568346 = newJObject()
  var query_568347 = newJObject()
  add(query_568347, "$orderby", newJString(Orderby))
  add(query_568347, "api-version", newJString(apiVersion))
  add(path_568346, "skus", newJString(skus))
  add(path_568346, "subscriptionId", newJString(subscriptionId))
  add(query_568347, "$top", newJInt(Top))
  add(path_568346, "publisherName", newJString(publisherName))
  add(path_568346, "offer", newJString(offer))
  add(path_568346, "location", newJString(location))
  add(query_568347, "$filter", newJString(Filter))
  result = call_568345.call(path_568346, query_568347, nil, nil, nil)

var virtualMachineImagesList* = Call_VirtualMachineImagesList_568332(
    name: "virtualMachineImagesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions",
    validator: validate_VirtualMachineImagesList_568333, base: "",
    url: url_VirtualMachineImagesList_568334, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesGet_568348 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineImagesGet_568350(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineImagesGet_568349(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a virtual machine image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   skus: JString (required)
  ##       : A valid image SKU.
  ##   version: JString (required)
  ##          : A valid image SKU version.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: JString (required)
  ##                : A valid image publisher.
  ##   offer: JString (required)
  ##        : A valid image publisher offer.
  ##   location: JString (required)
  ##           : The name of a supported Azure region.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `skus` field"
  var valid_568351 = path.getOrDefault("skus")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "skus", valid_568351
  var valid_568352 = path.getOrDefault("version")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "version", valid_568352
  var valid_568353 = path.getOrDefault("subscriptionId")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "subscriptionId", valid_568353
  var valid_568354 = path.getOrDefault("publisherName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "publisherName", valid_568354
  var valid_568355 = path.getOrDefault("offer")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "offer", valid_568355
  var valid_568356 = path.getOrDefault("location")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = nil)
  if valid_568356 != nil:
    section.add "location", valid_568356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568357 = query.getOrDefault("api-version")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "api-version", valid_568357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568358: Call_VirtualMachineImagesGet_568348; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a virtual machine image.
  ## 
  let valid = call_568358.validator(path, query, header, formData, body)
  let scheme = call_568358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568358.url(scheme.get, call_568358.host, call_568358.base,
                         call_568358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568358, url, valid)

proc call*(call_568359: Call_VirtualMachineImagesGet_568348; apiVersion: string;
          skus: string; version: string; subscriptionId: string;
          publisherName: string; offer: string; location: string): Recallable =
  ## virtualMachineImagesGet
  ## Gets a virtual machine image.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   skus: string (required)
  ##       : A valid image SKU.
  ##   version: string (required)
  ##          : A valid image SKU version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   publisherName: string (required)
  ##                : A valid image publisher.
  ##   offer: string (required)
  ##        : A valid image publisher offer.
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_568360 = newJObject()
  var query_568361 = newJObject()
  add(query_568361, "api-version", newJString(apiVersion))
  add(path_568360, "skus", newJString(skus))
  add(path_568360, "version", newJString(version))
  add(path_568360, "subscriptionId", newJString(subscriptionId))
  add(path_568360, "publisherName", newJString(publisherName))
  add(path_568360, "offer", newJString(offer))
  add(path_568360, "location", newJString(location))
  result = call_568359.call(path_568360, query_568361, nil, nil, nil)

var virtualMachineImagesGet* = Call_VirtualMachineImagesGet_568348(
    name: "virtualMachineImagesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions/{version}",
    validator: validate_VirtualMachineImagesGet_568349, base: "",
    url: url_VirtualMachineImagesGet_568350, schemes: {Scheme.Https})
type
  Call_UsageList_568362 = ref object of OpenApiRestCall_567667
proc url_UsageList_568364(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsageList_568363(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568365 = path.getOrDefault("subscriptionId")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "subscriptionId", valid_568365
  var valid_568366 = path.getOrDefault("location")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "location", valid_568366
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568367 = query.getOrDefault("api-version")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "api-version", valid_568367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568368: Call_UsageList_568362; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets, for the specified location, the current compute resource usage information as well as the limits for compute resources under the subscription.
  ## 
  let valid = call_568368.validator(path, query, header, formData, body)
  let scheme = call_568368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568368.url(scheme.get, call_568368.host, call_568368.base,
                         call_568368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568368, url, valid)

proc call*(call_568369: Call_UsageList_568362; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usageList
  ## Gets, for the specified location, the current compute resource usage information as well as the limits for compute resources under the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location for which resource usage is queried.
  var path_568370 = newJObject()
  var query_568371 = newJObject()
  add(query_568371, "api-version", newJString(apiVersion))
  add(path_568370, "subscriptionId", newJString(subscriptionId))
  add(path_568370, "location", newJString(location))
  result = call_568369.call(path_568370, query_568371, nil, nil, nil)

var usageList* = Call_UsageList_568362(name: "usageList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/usages",
                                    validator: validate_UsageList_568363,
                                    base: "", url: url_UsageList_568364,
                                    schemes: {Scheme.Https})
type
  Call_VirtualMachinesListByLocation_568372 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesListByLocation_568374(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesListByLocation_568373(path: JsonNode; query: JsonNode;
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
  var valid_568375 = path.getOrDefault("subscriptionId")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "subscriptionId", valid_568375
  var valid_568376 = path.getOrDefault("location")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "location", valid_568376
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568377 = query.getOrDefault("api-version")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "api-version", valid_568377
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568378: Call_VirtualMachinesListByLocation_568372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the virtual machines under the specified subscription for the specified location.
  ## 
  let valid = call_568378.validator(path, query, header, formData, body)
  let scheme = call_568378.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568378.url(scheme.get, call_568378.host, call_568378.base,
                         call_568378.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568378, url, valid)

proc call*(call_568379: Call_VirtualMachinesListByLocation_568372;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## virtualMachinesListByLocation
  ## Gets all the virtual machines under the specified subscription for the specified location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location for which virtual machines under the subscription are queried.
  var path_568380 = newJObject()
  var query_568381 = newJObject()
  add(query_568381, "api-version", newJString(apiVersion))
  add(path_568380, "subscriptionId", newJString(subscriptionId))
  add(path_568380, "location", newJString(location))
  result = call_568379.call(path_568380, query_568381, nil, nil, nil)

var virtualMachinesListByLocation* = Call_VirtualMachinesListByLocation_568372(
    name: "virtualMachinesListByLocation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/virtualMachines",
    validator: validate_VirtualMachinesListByLocation_568373, base: "",
    url: url_VirtualMachinesListByLocation_568374, schemes: {Scheme.Https})
type
  Call_VirtualMachineSizesList_568382 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineSizesList_568384(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineSizesList_568383(path: JsonNode; query: JsonNode;
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
  var valid_568385 = path.getOrDefault("subscriptionId")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "subscriptionId", valid_568385
  var valid_568386 = path.getOrDefault("location")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "location", valid_568386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568387 = query.getOrDefault("api-version")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "api-version", valid_568387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568388: Call_VirtualMachineSizesList_568382; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This API is deprecated. Use [Resources Skus](https://docs.microsoft.com/en-us/rest/api/compute/resourceskus/list)
  ## 
  let valid = call_568388.validator(path, query, header, formData, body)
  let scheme = call_568388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568388.url(scheme.get, call_568388.host, call_568388.base,
                         call_568388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568388, url, valid)

proc call*(call_568389: Call_VirtualMachineSizesList_568382; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## virtualMachineSizesList
  ## This API is deprecated. Use [Resources Skus](https://docs.microsoft.com/en-us/rest/api/compute/resourceskus/list)
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  var path_568390 = newJObject()
  var query_568391 = newJObject()
  add(query_568391, "api-version", newJString(apiVersion))
  add(path_568390, "subscriptionId", newJString(subscriptionId))
  add(path_568390, "location", newJString(location))
  result = call_568389.call(path_568390, query_568391, nil, nil, nil)

var virtualMachineSizesList* = Call_VirtualMachineSizesList_568382(
    name: "virtualMachineSizesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/vmSizes",
    validator: validate_VirtualMachineSizesList_568383, base: "",
    url: url_VirtualMachineSizesList_568384, schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsListBySubscription_568392 = ref object of OpenApiRestCall_567667
proc url_ProximityPlacementGroupsListBySubscription_568394(protocol: Scheme;
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

proc validate_ProximityPlacementGroupsListBySubscription_568393(path: JsonNode;
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
  var valid_568395 = path.getOrDefault("subscriptionId")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "subscriptionId", valid_568395
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568396 = query.getOrDefault("api-version")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "api-version", valid_568396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568397: Call_ProximityPlacementGroupsListBySubscription_568392;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all proximity placement groups in a subscription.
  ## 
  let valid = call_568397.validator(path, query, header, formData, body)
  let scheme = call_568397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568397.url(scheme.get, call_568397.host, call_568397.base,
                         call_568397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568397, url, valid)

proc call*(call_568398: Call_ProximityPlacementGroupsListBySubscription_568392;
          apiVersion: string; subscriptionId: string): Recallable =
  ## proximityPlacementGroupsListBySubscription
  ## Lists all proximity placement groups in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568399 = newJObject()
  var query_568400 = newJObject()
  add(query_568400, "api-version", newJString(apiVersion))
  add(path_568399, "subscriptionId", newJString(subscriptionId))
  result = call_568398.call(path_568399, query_568400, nil, nil, nil)

var proximityPlacementGroupsListBySubscription* = Call_ProximityPlacementGroupsListBySubscription_568392(
    name: "proximityPlacementGroupsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/proximityPlacementGroups",
    validator: validate_ProximityPlacementGroupsListBySubscription_568393,
    base: "", url: url_ProximityPlacementGroupsListBySubscription_568394,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsListAll_568401 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsListAll_568403(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsListAll_568402(path: JsonNode;
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
  var valid_568404 = path.getOrDefault("subscriptionId")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "subscriptionId", valid_568404
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568405 = query.getOrDefault("api-version")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "api-version", valid_568405
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568406: Call_VirtualMachineScaleSetsListAll_568401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all VM Scale Sets in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM Scale Sets.
  ## 
  let valid = call_568406.validator(path, query, header, formData, body)
  let scheme = call_568406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568406.url(scheme.get, call_568406.host, call_568406.base,
                         call_568406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568406, url, valid)

proc call*(call_568407: Call_VirtualMachineScaleSetsListAll_568401;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsListAll
  ## Gets a list of all VM Scale Sets in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM Scale Sets.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568408 = newJObject()
  var query_568409 = newJObject()
  add(query_568409, "api-version", newJString(apiVersion))
  add(path_568408, "subscriptionId", newJString(subscriptionId))
  result = call_568407.call(path_568408, query_568409, nil, nil, nil)

var virtualMachineScaleSetsListAll* = Call_VirtualMachineScaleSetsListAll_568401(
    name: "virtualMachineScaleSetsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachineScaleSets",
    validator: validate_VirtualMachineScaleSetsListAll_568402, base: "",
    url: url_VirtualMachineScaleSetsListAll_568403, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListAll_568410 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesListAll_568412(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesListAll_568411(path: JsonNode; query: JsonNode;
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
  var valid_568413 = path.getOrDefault("subscriptionId")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "subscriptionId", valid_568413
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568414 = query.getOrDefault("api-version")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "api-version", valid_568414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568415: Call_VirtualMachinesListAll_568410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the virtual machines in the specified subscription. Use the nextLink property in the response to get the next page of virtual machines.
  ## 
  let valid = call_568415.validator(path, query, header, formData, body)
  let scheme = call_568415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568415.url(scheme.get, call_568415.host, call_568415.base,
                         call_568415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568415, url, valid)

proc call*(call_568416: Call_VirtualMachinesListAll_568410; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachinesListAll
  ## Lists all of the virtual machines in the specified subscription. Use the nextLink property in the response to get the next page of virtual machines.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568417 = newJObject()
  var query_568418 = newJObject()
  add(query_568418, "api-version", newJString(apiVersion))
  add(path_568417, "subscriptionId", newJString(subscriptionId))
  result = call_568416.call(path_568417, query_568418, nil, nil, nil)

var virtualMachinesListAll* = Call_VirtualMachinesListAll_568410(
    name: "virtualMachinesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachines",
    validator: validate_VirtualMachinesListAll_568411, base: "",
    url: url_VirtualMachinesListAll_568412, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsList_568419 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsList_568421(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsList_568420(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all availability sets in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568422 = path.getOrDefault("resourceGroupName")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "resourceGroupName", valid_568422
  var valid_568423 = path.getOrDefault("subscriptionId")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "subscriptionId", valid_568423
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568424 = query.getOrDefault("api-version")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "api-version", valid_568424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568425: Call_AvailabilitySetsList_568419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all availability sets in a resource group.
  ## 
  let valid = call_568425.validator(path, query, header, formData, body)
  let scheme = call_568425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568425.url(scheme.get, call_568425.host, call_568425.base,
                         call_568425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568425, url, valid)

proc call*(call_568426: Call_AvailabilitySetsList_568419;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## availabilitySetsList
  ## Lists all availability sets in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568427 = newJObject()
  var query_568428 = newJObject()
  add(path_568427, "resourceGroupName", newJString(resourceGroupName))
  add(query_568428, "api-version", newJString(apiVersion))
  add(path_568427, "subscriptionId", newJString(subscriptionId))
  result = call_568426.call(path_568427, query_568428, nil, nil, nil)

var availabilitySetsList* = Call_AvailabilitySetsList_568419(
    name: "availabilitySetsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets",
    validator: validate_AvailabilitySetsList_568420, base: "",
    url: url_AvailabilitySetsList_568421, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsCreateOrUpdate_568440 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsCreateOrUpdate_568442(protocol: Scheme; host: string;
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

proc validate_AvailabilitySetsCreateOrUpdate_568441(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an availability set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   availabilitySetName: JString (required)
  ##                      : The name of the availability set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568443 = path.getOrDefault("resourceGroupName")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "resourceGroupName", valid_568443
  var valid_568444 = path.getOrDefault("subscriptionId")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "subscriptionId", valid_568444
  var valid_568445 = path.getOrDefault("availabilitySetName")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "availabilitySetName", valid_568445
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568446 = query.getOrDefault("api-version")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = nil)
  if valid_568446 != nil:
    section.add "api-version", valid_568446
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

proc call*(call_568448: Call_AvailabilitySetsCreateOrUpdate_568440; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an availability set.
  ## 
  let valid = call_568448.validator(path, query, header, formData, body)
  let scheme = call_568448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568448.url(scheme.get, call_568448.host, call_568448.base,
                         call_568448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568448, url, valid)

proc call*(call_568449: Call_AvailabilitySetsCreateOrUpdate_568440;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          availabilitySetName: string; parameters: JsonNode): Recallable =
  ## availabilitySetsCreateOrUpdate
  ## Create or update an availability set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   availabilitySetName: string (required)
  ##                      : The name of the availability set.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Availability Set operation.
  var path_568450 = newJObject()
  var query_568451 = newJObject()
  var body_568452 = newJObject()
  add(path_568450, "resourceGroupName", newJString(resourceGroupName))
  add(query_568451, "api-version", newJString(apiVersion))
  add(path_568450, "subscriptionId", newJString(subscriptionId))
  add(path_568450, "availabilitySetName", newJString(availabilitySetName))
  if parameters != nil:
    body_568452 = parameters
  result = call_568449.call(path_568450, query_568451, nil, nil, body_568452)

var availabilitySetsCreateOrUpdate* = Call_AvailabilitySetsCreateOrUpdate_568440(
    name: "availabilitySetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsCreateOrUpdate_568441, base: "",
    url: url_AvailabilitySetsCreateOrUpdate_568442, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsGet_568429 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsGet_568431(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsGet_568430(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves information about an availability set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   availabilitySetName: JString (required)
  ##                      : The name of the availability set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568432 = path.getOrDefault("resourceGroupName")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "resourceGroupName", valid_568432
  var valid_568433 = path.getOrDefault("subscriptionId")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "subscriptionId", valid_568433
  var valid_568434 = path.getOrDefault("availabilitySetName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "availabilitySetName", valid_568434
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568435 = query.getOrDefault("api-version")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "api-version", valid_568435
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568436: Call_AvailabilitySetsGet_568429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about an availability set.
  ## 
  let valid = call_568436.validator(path, query, header, formData, body)
  let scheme = call_568436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568436.url(scheme.get, call_568436.host, call_568436.base,
                         call_568436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568436, url, valid)

proc call*(call_568437: Call_AvailabilitySetsGet_568429; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; availabilitySetName: string): Recallable =
  ## availabilitySetsGet
  ## Retrieves information about an availability set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   availabilitySetName: string (required)
  ##                      : The name of the availability set.
  var path_568438 = newJObject()
  var query_568439 = newJObject()
  add(path_568438, "resourceGroupName", newJString(resourceGroupName))
  add(query_568439, "api-version", newJString(apiVersion))
  add(path_568438, "subscriptionId", newJString(subscriptionId))
  add(path_568438, "availabilitySetName", newJString(availabilitySetName))
  result = call_568437.call(path_568438, query_568439, nil, nil, nil)

var availabilitySetsGet* = Call_AvailabilitySetsGet_568429(
    name: "availabilitySetsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsGet_568430, base: "",
    url: url_AvailabilitySetsGet_568431, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsUpdate_568464 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsUpdate_568466(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsUpdate_568465(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an availability set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   availabilitySetName: JString (required)
  ##                      : The name of the availability set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568467 = path.getOrDefault("resourceGroupName")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "resourceGroupName", valid_568467
  var valid_568468 = path.getOrDefault("subscriptionId")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "subscriptionId", valid_568468
  var valid_568469 = path.getOrDefault("availabilitySetName")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "availabilitySetName", valid_568469
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568470 = query.getOrDefault("api-version")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "api-version", valid_568470
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

proc call*(call_568472: Call_AvailabilitySetsUpdate_568464; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an availability set.
  ## 
  let valid = call_568472.validator(path, query, header, formData, body)
  let scheme = call_568472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568472.url(scheme.get, call_568472.host, call_568472.base,
                         call_568472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568472, url, valid)

proc call*(call_568473: Call_AvailabilitySetsUpdate_568464;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          availabilitySetName: string; parameters: JsonNode): Recallable =
  ## availabilitySetsUpdate
  ## Update an availability set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   availabilitySetName: string (required)
  ##                      : The name of the availability set.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Availability Set operation.
  var path_568474 = newJObject()
  var query_568475 = newJObject()
  var body_568476 = newJObject()
  add(path_568474, "resourceGroupName", newJString(resourceGroupName))
  add(query_568475, "api-version", newJString(apiVersion))
  add(path_568474, "subscriptionId", newJString(subscriptionId))
  add(path_568474, "availabilitySetName", newJString(availabilitySetName))
  if parameters != nil:
    body_568476 = parameters
  result = call_568473.call(path_568474, query_568475, nil, nil, body_568476)

var availabilitySetsUpdate* = Call_AvailabilitySetsUpdate_568464(
    name: "availabilitySetsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsUpdate_568465, base: "",
    url: url_AvailabilitySetsUpdate_568466, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsDelete_568453 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsDelete_568455(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsDelete_568454(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an availability set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   availabilitySetName: JString (required)
  ##                      : The name of the availability set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568456 = path.getOrDefault("resourceGroupName")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "resourceGroupName", valid_568456
  var valid_568457 = path.getOrDefault("subscriptionId")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "subscriptionId", valid_568457
  var valid_568458 = path.getOrDefault("availabilitySetName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "availabilitySetName", valid_568458
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568459 = query.getOrDefault("api-version")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "api-version", valid_568459
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568460: Call_AvailabilitySetsDelete_568453; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an availability set.
  ## 
  let valid = call_568460.validator(path, query, header, formData, body)
  let scheme = call_568460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568460.url(scheme.get, call_568460.host, call_568460.base,
                         call_568460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568460, url, valid)

proc call*(call_568461: Call_AvailabilitySetsDelete_568453;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          availabilitySetName: string): Recallable =
  ## availabilitySetsDelete
  ## Delete an availability set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   availabilitySetName: string (required)
  ##                      : The name of the availability set.
  var path_568462 = newJObject()
  var query_568463 = newJObject()
  add(path_568462, "resourceGroupName", newJString(resourceGroupName))
  add(query_568463, "api-version", newJString(apiVersion))
  add(path_568462, "subscriptionId", newJString(subscriptionId))
  add(path_568462, "availabilitySetName", newJString(availabilitySetName))
  result = call_568461.call(path_568462, query_568463, nil, nil, nil)

var availabilitySetsDelete* = Call_AvailabilitySetsDelete_568453(
    name: "availabilitySetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsDelete_568454, base: "",
    url: url_AvailabilitySetsDelete_568455, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsListAvailableSizes_568477 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsListAvailableSizes_568479(protocol: Scheme; host: string;
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

proc validate_AvailabilitySetsListAvailableSizes_568478(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all available virtual machine sizes that can be used to create a new virtual machine in an existing availability set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   availabilitySetName: JString (required)
  ##                      : The name of the availability set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568480 = path.getOrDefault("resourceGroupName")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "resourceGroupName", valid_568480
  var valid_568481 = path.getOrDefault("subscriptionId")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "subscriptionId", valid_568481
  var valid_568482 = path.getOrDefault("availabilitySetName")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "availabilitySetName", valid_568482
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568483 = query.getOrDefault("api-version")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "api-version", valid_568483
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568484: Call_AvailabilitySetsListAvailableSizes_568477;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available virtual machine sizes that can be used to create a new virtual machine in an existing availability set.
  ## 
  let valid = call_568484.validator(path, query, header, formData, body)
  let scheme = call_568484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568484.url(scheme.get, call_568484.host, call_568484.base,
                         call_568484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568484, url, valid)

proc call*(call_568485: Call_AvailabilitySetsListAvailableSizes_568477;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          availabilitySetName: string): Recallable =
  ## availabilitySetsListAvailableSizes
  ## Lists all available virtual machine sizes that can be used to create a new virtual machine in an existing availability set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   availabilitySetName: string (required)
  ##                      : The name of the availability set.
  var path_568486 = newJObject()
  var query_568487 = newJObject()
  add(path_568486, "resourceGroupName", newJString(resourceGroupName))
  add(query_568487, "api-version", newJString(apiVersion))
  add(path_568486, "subscriptionId", newJString(subscriptionId))
  add(path_568486, "availabilitySetName", newJString(availabilitySetName))
  result = call_568485.call(path_568486, query_568487, nil, nil, nil)

var availabilitySetsListAvailableSizes* = Call_AvailabilitySetsListAvailableSizes_568477(
    name: "availabilitySetsListAvailableSizes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}/vmSizes",
    validator: validate_AvailabilitySetsListAvailableSizes_568478, base: "",
    url: url_AvailabilitySetsListAvailableSizes_568479, schemes: {Scheme.Https})
type
  Call_ImagesListByResourceGroup_568488 = ref object of OpenApiRestCall_567667
proc url_ImagesListByResourceGroup_568490(protocol: Scheme; host: string;
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

proc validate_ImagesListByResourceGroup_568489(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of images under a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568491 = path.getOrDefault("resourceGroupName")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "resourceGroupName", valid_568491
  var valid_568492 = path.getOrDefault("subscriptionId")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "subscriptionId", valid_568492
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568493 = query.getOrDefault("api-version")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "api-version", valid_568493
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568494: Call_ImagesListByResourceGroup_568488; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of images under a resource group.
  ## 
  let valid = call_568494.validator(path, query, header, formData, body)
  let scheme = call_568494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568494.url(scheme.get, call_568494.host, call_568494.base,
                         call_568494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568494, url, valid)

proc call*(call_568495: Call_ImagesListByResourceGroup_568488;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## imagesListByResourceGroup
  ## Gets the list of images under a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568496 = newJObject()
  var query_568497 = newJObject()
  add(path_568496, "resourceGroupName", newJString(resourceGroupName))
  add(query_568497, "api-version", newJString(apiVersion))
  add(path_568496, "subscriptionId", newJString(subscriptionId))
  result = call_568495.call(path_568496, query_568497, nil, nil, nil)

var imagesListByResourceGroup* = Call_ImagesListByResourceGroup_568488(
    name: "imagesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images",
    validator: validate_ImagesListByResourceGroup_568489, base: "",
    url: url_ImagesListByResourceGroup_568490, schemes: {Scheme.Https})
type
  Call_ImagesCreateOrUpdate_568510 = ref object of OpenApiRestCall_567667
proc url_ImagesCreateOrUpdate_568512(protocol: Scheme; host: string; base: string;
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

proc validate_ImagesCreateOrUpdate_568511(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update an image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   imageName: JString (required)
  ##            : The name of the image.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568513 = path.getOrDefault("resourceGroupName")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "resourceGroupName", valid_568513
  var valid_568514 = path.getOrDefault("subscriptionId")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "subscriptionId", valid_568514
  var valid_568515 = path.getOrDefault("imageName")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "imageName", valid_568515
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568516 = query.getOrDefault("api-version")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "api-version", valid_568516
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

proc call*(call_568518: Call_ImagesCreateOrUpdate_568510; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an image.
  ## 
  let valid = call_568518.validator(path, query, header, formData, body)
  let scheme = call_568518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568518.url(scheme.get, call_568518.host, call_568518.base,
                         call_568518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568518, url, valid)

proc call*(call_568519: Call_ImagesCreateOrUpdate_568510;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          imageName: string; parameters: JsonNode): Recallable =
  ## imagesCreateOrUpdate
  ## Create or update an image.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   imageName: string (required)
  ##            : The name of the image.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Image operation.
  var path_568520 = newJObject()
  var query_568521 = newJObject()
  var body_568522 = newJObject()
  add(path_568520, "resourceGroupName", newJString(resourceGroupName))
  add(query_568521, "api-version", newJString(apiVersion))
  add(path_568520, "subscriptionId", newJString(subscriptionId))
  add(path_568520, "imageName", newJString(imageName))
  if parameters != nil:
    body_568522 = parameters
  result = call_568519.call(path_568520, query_568521, nil, nil, body_568522)

var imagesCreateOrUpdate* = Call_ImagesCreateOrUpdate_568510(
    name: "imagesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesCreateOrUpdate_568511, base: "",
    url: url_ImagesCreateOrUpdate_568512, schemes: {Scheme.Https})
type
  Call_ImagesGet_568498 = ref object of OpenApiRestCall_567667
proc url_ImagesGet_568500(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ImagesGet_568499(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   imageName: JString (required)
  ##            : The name of the image.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568501 = path.getOrDefault("resourceGroupName")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "resourceGroupName", valid_568501
  var valid_568502 = path.getOrDefault("subscriptionId")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "subscriptionId", valid_568502
  var valid_568503 = path.getOrDefault("imageName")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "imageName", valid_568503
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_568504 = query.getOrDefault("$expand")
  valid_568504 = validateParameter(valid_568504, JString, required = false,
                                 default = nil)
  if valid_568504 != nil:
    section.add "$expand", valid_568504
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568505 = query.getOrDefault("api-version")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "api-version", valid_568505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568506: Call_ImagesGet_568498; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an image.
  ## 
  let valid = call_568506.validator(path, query, header, formData, body)
  let scheme = call_568506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568506.url(scheme.get, call_568506.host, call_568506.base,
                         call_568506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568506, url, valid)

proc call*(call_568507: Call_ImagesGet_568498; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; imageName: string;
          Expand: string = ""): Recallable =
  ## imagesGet
  ## Gets an image.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   imageName: string (required)
  ##            : The name of the image.
  var path_568508 = newJObject()
  var query_568509 = newJObject()
  add(path_568508, "resourceGroupName", newJString(resourceGroupName))
  add(query_568509, "$expand", newJString(Expand))
  add(query_568509, "api-version", newJString(apiVersion))
  add(path_568508, "subscriptionId", newJString(subscriptionId))
  add(path_568508, "imageName", newJString(imageName))
  result = call_568507.call(path_568508, query_568509, nil, nil, nil)

var imagesGet* = Call_ImagesGet_568498(name: "imagesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
                                    validator: validate_ImagesGet_568499,
                                    base: "", url: url_ImagesGet_568500,
                                    schemes: {Scheme.Https})
type
  Call_ImagesUpdate_568534 = ref object of OpenApiRestCall_567667
proc url_ImagesUpdate_568536(protocol: Scheme; host: string; base: string;
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

proc validate_ImagesUpdate_568535(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   imageName: JString (required)
  ##            : The name of the image.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568537 = path.getOrDefault("resourceGroupName")
  valid_568537 = validateParameter(valid_568537, JString, required = true,
                                 default = nil)
  if valid_568537 != nil:
    section.add "resourceGroupName", valid_568537
  var valid_568538 = path.getOrDefault("subscriptionId")
  valid_568538 = validateParameter(valid_568538, JString, required = true,
                                 default = nil)
  if valid_568538 != nil:
    section.add "subscriptionId", valid_568538
  var valid_568539 = path.getOrDefault("imageName")
  valid_568539 = validateParameter(valid_568539, JString, required = true,
                                 default = nil)
  if valid_568539 != nil:
    section.add "imageName", valid_568539
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568540 = query.getOrDefault("api-version")
  valid_568540 = validateParameter(valid_568540, JString, required = true,
                                 default = nil)
  if valid_568540 != nil:
    section.add "api-version", valid_568540
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

proc call*(call_568542: Call_ImagesUpdate_568534; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an image.
  ## 
  let valid = call_568542.validator(path, query, header, formData, body)
  let scheme = call_568542.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568542.url(scheme.get, call_568542.host, call_568542.base,
                         call_568542.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568542, url, valid)

proc call*(call_568543: Call_ImagesUpdate_568534; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; imageName: string;
          parameters: JsonNode): Recallable =
  ## imagesUpdate
  ## Update an image.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   imageName: string (required)
  ##            : The name of the image.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Image operation.
  var path_568544 = newJObject()
  var query_568545 = newJObject()
  var body_568546 = newJObject()
  add(path_568544, "resourceGroupName", newJString(resourceGroupName))
  add(query_568545, "api-version", newJString(apiVersion))
  add(path_568544, "subscriptionId", newJString(subscriptionId))
  add(path_568544, "imageName", newJString(imageName))
  if parameters != nil:
    body_568546 = parameters
  result = call_568543.call(path_568544, query_568545, nil, nil, body_568546)

var imagesUpdate* = Call_ImagesUpdate_568534(name: "imagesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesUpdate_568535, base: "", url: url_ImagesUpdate_568536,
    schemes: {Scheme.Https})
type
  Call_ImagesDelete_568523 = ref object of OpenApiRestCall_567667
proc url_ImagesDelete_568525(protocol: Scheme; host: string; base: string;
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

proc validate_ImagesDelete_568524(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an Image.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   imageName: JString (required)
  ##            : The name of the image.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568526 = path.getOrDefault("resourceGroupName")
  valid_568526 = validateParameter(valid_568526, JString, required = true,
                                 default = nil)
  if valid_568526 != nil:
    section.add "resourceGroupName", valid_568526
  var valid_568527 = path.getOrDefault("subscriptionId")
  valid_568527 = validateParameter(valid_568527, JString, required = true,
                                 default = nil)
  if valid_568527 != nil:
    section.add "subscriptionId", valid_568527
  var valid_568528 = path.getOrDefault("imageName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "imageName", valid_568528
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568529 = query.getOrDefault("api-version")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "api-version", valid_568529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568530: Call_ImagesDelete_568523; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Image.
  ## 
  let valid = call_568530.validator(path, query, header, formData, body)
  let scheme = call_568530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568530.url(scheme.get, call_568530.host, call_568530.base,
                         call_568530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568530, url, valid)

proc call*(call_568531: Call_ImagesDelete_568523; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; imageName: string): Recallable =
  ## imagesDelete
  ## Deletes an Image.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   imageName: string (required)
  ##            : The name of the image.
  var path_568532 = newJObject()
  var query_568533 = newJObject()
  add(path_568532, "resourceGroupName", newJString(resourceGroupName))
  add(query_568533, "api-version", newJString(apiVersion))
  add(path_568532, "subscriptionId", newJString(subscriptionId))
  add(path_568532, "imageName", newJString(imageName))
  result = call_568531.call(path_568532, query_568533, nil, nil, nil)

var imagesDelete* = Call_ImagesDelete_568523(name: "imagesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesDelete_568524, base: "", url: url_ImagesDelete_568525,
    schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsListByResourceGroup_568547 = ref object of OpenApiRestCall_567667
proc url_ProximityPlacementGroupsListByResourceGroup_568549(protocol: Scheme;
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

proc validate_ProximityPlacementGroupsListByResourceGroup_568548(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all proximity placement groups in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568550 = path.getOrDefault("resourceGroupName")
  valid_568550 = validateParameter(valid_568550, JString, required = true,
                                 default = nil)
  if valid_568550 != nil:
    section.add "resourceGroupName", valid_568550
  var valid_568551 = path.getOrDefault("subscriptionId")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "subscriptionId", valid_568551
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568552 = query.getOrDefault("api-version")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "api-version", valid_568552
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568553: Call_ProximityPlacementGroupsListByResourceGroup_568547;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all proximity placement groups in a resource group.
  ## 
  let valid = call_568553.validator(path, query, header, formData, body)
  let scheme = call_568553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568553.url(scheme.get, call_568553.host, call_568553.base,
                         call_568553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568553, url, valid)

proc call*(call_568554: Call_ProximityPlacementGroupsListByResourceGroup_568547;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## proximityPlacementGroupsListByResourceGroup
  ## Lists all proximity placement groups in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568555 = newJObject()
  var query_568556 = newJObject()
  add(path_568555, "resourceGroupName", newJString(resourceGroupName))
  add(query_568556, "api-version", newJString(apiVersion))
  add(path_568555, "subscriptionId", newJString(subscriptionId))
  result = call_568554.call(path_568555, query_568556, nil, nil, nil)

var proximityPlacementGroupsListByResourceGroup* = Call_ProximityPlacementGroupsListByResourceGroup_568547(
    name: "proximityPlacementGroupsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups",
    validator: validate_ProximityPlacementGroupsListByResourceGroup_568548,
    base: "", url: url_ProximityPlacementGroupsListByResourceGroup_568549,
    schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsCreateOrUpdate_568568 = ref object of OpenApiRestCall_567667
proc url_ProximityPlacementGroupsCreateOrUpdate_568570(protocol: Scheme;
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

proc validate_ProximityPlacementGroupsCreateOrUpdate_568569(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a proximity placement group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   proximityPlacementGroupName: JString (required)
  ##                              : The name of the proximity placement group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568571 = path.getOrDefault("resourceGroupName")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "resourceGroupName", valid_568571
  var valid_568572 = path.getOrDefault("subscriptionId")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "subscriptionId", valid_568572
  var valid_568573 = path.getOrDefault("proximityPlacementGroupName")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "proximityPlacementGroupName", valid_568573
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568574 = query.getOrDefault("api-version")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "api-version", valid_568574
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

proc call*(call_568576: Call_ProximityPlacementGroupsCreateOrUpdate_568568;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a proximity placement group.
  ## 
  let valid = call_568576.validator(path, query, header, formData, body)
  let scheme = call_568576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568576.url(scheme.get, call_568576.host, call_568576.base,
                         call_568576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568576, url, valid)

proc call*(call_568577: Call_ProximityPlacementGroupsCreateOrUpdate_568568;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          proximityPlacementGroupName: string; parameters: JsonNode): Recallable =
  ## proximityPlacementGroupsCreateOrUpdate
  ## Create or update a proximity placement group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   proximityPlacementGroupName: string (required)
  ##                              : The name of the proximity placement group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Proximity Placement Group operation.
  var path_568578 = newJObject()
  var query_568579 = newJObject()
  var body_568580 = newJObject()
  add(path_568578, "resourceGroupName", newJString(resourceGroupName))
  add(query_568579, "api-version", newJString(apiVersion))
  add(path_568578, "subscriptionId", newJString(subscriptionId))
  add(path_568578, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  if parameters != nil:
    body_568580 = parameters
  result = call_568577.call(path_568578, query_568579, nil, nil, body_568580)

var proximityPlacementGroupsCreateOrUpdate* = Call_ProximityPlacementGroupsCreateOrUpdate_568568(
    name: "proximityPlacementGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsCreateOrUpdate_568569, base: "",
    url: url_ProximityPlacementGroupsCreateOrUpdate_568570,
    schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsGet_568557 = ref object of OpenApiRestCall_567667
proc url_ProximityPlacementGroupsGet_568559(protocol: Scheme; host: string;
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

proc validate_ProximityPlacementGroupsGet_568558(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves information about a proximity placement group .
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   proximityPlacementGroupName: JString (required)
  ##                              : The name of the proximity placement group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568560 = path.getOrDefault("resourceGroupName")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "resourceGroupName", valid_568560
  var valid_568561 = path.getOrDefault("subscriptionId")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = nil)
  if valid_568561 != nil:
    section.add "subscriptionId", valid_568561
  var valid_568562 = path.getOrDefault("proximityPlacementGroupName")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "proximityPlacementGroupName", valid_568562
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568563 = query.getOrDefault("api-version")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "api-version", valid_568563
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568564: Call_ProximityPlacementGroupsGet_568557; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a proximity placement group .
  ## 
  let valid = call_568564.validator(path, query, header, formData, body)
  let scheme = call_568564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568564.url(scheme.get, call_568564.host, call_568564.base,
                         call_568564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568564, url, valid)

proc call*(call_568565: Call_ProximityPlacementGroupsGet_568557;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          proximityPlacementGroupName: string): Recallable =
  ## proximityPlacementGroupsGet
  ## Retrieves information about a proximity placement group .
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   proximityPlacementGroupName: string (required)
  ##                              : The name of the proximity placement group.
  var path_568566 = newJObject()
  var query_568567 = newJObject()
  add(path_568566, "resourceGroupName", newJString(resourceGroupName))
  add(query_568567, "api-version", newJString(apiVersion))
  add(path_568566, "subscriptionId", newJString(subscriptionId))
  add(path_568566, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  result = call_568565.call(path_568566, query_568567, nil, nil, nil)

var proximityPlacementGroupsGet* = Call_ProximityPlacementGroupsGet_568557(
    name: "proximityPlacementGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsGet_568558, base: "",
    url: url_ProximityPlacementGroupsGet_568559, schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsUpdate_568592 = ref object of OpenApiRestCall_567667
proc url_ProximityPlacementGroupsUpdate_568594(protocol: Scheme; host: string;
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

proc validate_ProximityPlacementGroupsUpdate_568593(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a proximity placement group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   proximityPlacementGroupName: JString (required)
  ##                              : The name of the proximity placement group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568595 = path.getOrDefault("resourceGroupName")
  valid_568595 = validateParameter(valid_568595, JString, required = true,
                                 default = nil)
  if valid_568595 != nil:
    section.add "resourceGroupName", valid_568595
  var valid_568596 = path.getOrDefault("subscriptionId")
  valid_568596 = validateParameter(valid_568596, JString, required = true,
                                 default = nil)
  if valid_568596 != nil:
    section.add "subscriptionId", valid_568596
  var valid_568597 = path.getOrDefault("proximityPlacementGroupName")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "proximityPlacementGroupName", valid_568597
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568598 = query.getOrDefault("api-version")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "api-version", valid_568598
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

proc call*(call_568600: Call_ProximityPlacementGroupsUpdate_568592; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a proximity placement group.
  ## 
  let valid = call_568600.validator(path, query, header, formData, body)
  let scheme = call_568600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568600.url(scheme.get, call_568600.host, call_568600.base,
                         call_568600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568600, url, valid)

proc call*(call_568601: Call_ProximityPlacementGroupsUpdate_568592;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          proximityPlacementGroupName: string; parameters: JsonNode): Recallable =
  ## proximityPlacementGroupsUpdate
  ## Update a proximity placement group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   proximityPlacementGroupName: string (required)
  ##                              : The name of the proximity placement group.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Proximity Placement Group operation.
  var path_568602 = newJObject()
  var query_568603 = newJObject()
  var body_568604 = newJObject()
  add(path_568602, "resourceGroupName", newJString(resourceGroupName))
  add(query_568603, "api-version", newJString(apiVersion))
  add(path_568602, "subscriptionId", newJString(subscriptionId))
  add(path_568602, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  if parameters != nil:
    body_568604 = parameters
  result = call_568601.call(path_568602, query_568603, nil, nil, body_568604)

var proximityPlacementGroupsUpdate* = Call_ProximityPlacementGroupsUpdate_568592(
    name: "proximityPlacementGroupsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsUpdate_568593, base: "",
    url: url_ProximityPlacementGroupsUpdate_568594, schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsDelete_568581 = ref object of OpenApiRestCall_567667
proc url_ProximityPlacementGroupsDelete_568583(protocol: Scheme; host: string;
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

proc validate_ProximityPlacementGroupsDelete_568582(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a proximity placement group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   proximityPlacementGroupName: JString (required)
  ##                              : The name of the proximity placement group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568584 = path.getOrDefault("resourceGroupName")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "resourceGroupName", valid_568584
  var valid_568585 = path.getOrDefault("subscriptionId")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "subscriptionId", valid_568585
  var valid_568586 = path.getOrDefault("proximityPlacementGroupName")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "proximityPlacementGroupName", valid_568586
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568587 = query.getOrDefault("api-version")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "api-version", valid_568587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568588: Call_ProximityPlacementGroupsDelete_568581; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a proximity placement group.
  ## 
  let valid = call_568588.validator(path, query, header, formData, body)
  let scheme = call_568588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568588.url(scheme.get, call_568588.host, call_568588.base,
                         call_568588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568588, url, valid)

proc call*(call_568589: Call_ProximityPlacementGroupsDelete_568581;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          proximityPlacementGroupName: string): Recallable =
  ## proximityPlacementGroupsDelete
  ## Delete a proximity placement group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   proximityPlacementGroupName: string (required)
  ##                              : The name of the proximity placement group.
  var path_568590 = newJObject()
  var query_568591 = newJObject()
  add(path_568590, "resourceGroupName", newJString(resourceGroupName))
  add(query_568591, "api-version", newJString(apiVersion))
  add(path_568590, "subscriptionId", newJString(subscriptionId))
  add(path_568590, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  result = call_568589.call(path_568590, query_568591, nil, nil, nil)

var proximityPlacementGroupsDelete* = Call_ProximityPlacementGroupsDelete_568581(
    name: "proximityPlacementGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsDelete_568582, base: "",
    url: url_ProximityPlacementGroupsDelete_568583, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsList_568605 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsList_568607(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsList_568606(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all VM scale sets under a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568608 = path.getOrDefault("resourceGroupName")
  valid_568608 = validateParameter(valid_568608, JString, required = true,
                                 default = nil)
  if valid_568608 != nil:
    section.add "resourceGroupName", valid_568608
  var valid_568609 = path.getOrDefault("subscriptionId")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "subscriptionId", valid_568609
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568610 = query.getOrDefault("api-version")
  valid_568610 = validateParameter(valid_568610, JString, required = true,
                                 default = nil)
  if valid_568610 != nil:
    section.add "api-version", valid_568610
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568611: Call_VirtualMachineScaleSetsList_568605; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all VM scale sets under a resource group.
  ## 
  let valid = call_568611.validator(path, query, header, formData, body)
  let scheme = call_568611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568611.url(scheme.get, call_568611.host, call_568611.base,
                         call_568611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568611, url, valid)

proc call*(call_568612: Call_VirtualMachineScaleSetsList_568605;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsList
  ## Gets a list of all VM scale sets under a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568613 = newJObject()
  var query_568614 = newJObject()
  add(path_568613, "resourceGroupName", newJString(resourceGroupName))
  add(query_568614, "api-version", newJString(apiVersion))
  add(path_568613, "subscriptionId", newJString(subscriptionId))
  result = call_568612.call(path_568613, query_568614, nil, nil, nil)

var virtualMachineScaleSetsList* = Call_VirtualMachineScaleSetsList_568605(
    name: "virtualMachineScaleSetsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets",
    validator: validate_VirtualMachineScaleSetsList_568606, base: "",
    url: url_VirtualMachineScaleSetsList_568607, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsList_568615 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsList_568617(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsList_568616(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all virtual machines in a VM scale sets.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: JString (required)
  ##                             : The name of the VM scale set.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568618 = path.getOrDefault("resourceGroupName")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "resourceGroupName", valid_568618
  var valid_568619 = path.getOrDefault("subscriptionId")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = nil)
  if valid_568619 != nil:
    section.add "subscriptionId", valid_568619
  var valid_568620 = path.getOrDefault("virtualMachineScaleSetName")
  valid_568620 = validateParameter(valid_568620, JString, required = true,
                                 default = nil)
  if valid_568620 != nil:
    section.add "virtualMachineScaleSetName", valid_568620
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply to the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : The list parameters.
  ##   $filter: JString
  ##          : The filter to apply to the operation.
  section = newJObject()
  var valid_568621 = query.getOrDefault("$expand")
  valid_568621 = validateParameter(valid_568621, JString, required = false,
                                 default = nil)
  if valid_568621 != nil:
    section.add "$expand", valid_568621
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568622 = query.getOrDefault("api-version")
  valid_568622 = validateParameter(valid_568622, JString, required = true,
                                 default = nil)
  if valid_568622 != nil:
    section.add "api-version", valid_568622
  var valid_568623 = query.getOrDefault("$select")
  valid_568623 = validateParameter(valid_568623, JString, required = false,
                                 default = nil)
  if valid_568623 != nil:
    section.add "$select", valid_568623
  var valid_568624 = query.getOrDefault("$filter")
  valid_568624 = validateParameter(valid_568624, JString, required = false,
                                 default = nil)
  if valid_568624 != nil:
    section.add "$filter", valid_568624
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568625: Call_VirtualMachineScaleSetVMsList_568615; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all virtual machines in a VM scale sets.
  ## 
  let valid = call_568625.validator(path, query, header, formData, body)
  let scheme = call_568625.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568625.url(scheme.get, call_568625.host, call_568625.base,
                         call_568625.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568625, url, valid)

proc call*(call_568626: Call_VirtualMachineScaleSetVMsList_568615;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          virtualMachineScaleSetName: string; Expand: string = "";
          Select: string = ""; Filter: string = ""): Recallable =
  ## virtualMachineScaleSetVMsList
  ## Gets a list of all virtual machines in a VM scale sets.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : The expand expression to apply to the operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Select: string
  ##         : The list parameters.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the VM scale set.
  ##   Filter: string
  ##         : The filter to apply to the operation.
  var path_568627 = newJObject()
  var query_568628 = newJObject()
  add(path_568627, "resourceGroupName", newJString(resourceGroupName))
  add(query_568628, "$expand", newJString(Expand))
  add(query_568628, "api-version", newJString(apiVersion))
  add(path_568627, "subscriptionId", newJString(subscriptionId))
  add(query_568628, "$select", newJString(Select))
  add(path_568627, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  add(query_568628, "$filter", newJString(Filter))
  result = call_568626.call(path_568627, query_568628, nil, nil, nil)

var virtualMachineScaleSetVMsList* = Call_VirtualMachineScaleSetVMsList_568615(
    name: "virtualMachineScaleSetVMsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines",
    validator: validate_VirtualMachineScaleSetVMsList_568616, base: "",
    url: url_VirtualMachineScaleSetVMsList_568617, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsCreateOrUpdate_568640 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsCreateOrUpdate_568642(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsCreateOrUpdate_568641(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set to create or update.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568643 = path.getOrDefault("vmScaleSetName")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "vmScaleSetName", valid_568643
  var valid_568644 = path.getOrDefault("resourceGroupName")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "resourceGroupName", valid_568644
  var valid_568645 = path.getOrDefault("subscriptionId")
  valid_568645 = validateParameter(valid_568645, JString, required = true,
                                 default = nil)
  if valid_568645 != nil:
    section.add "subscriptionId", valid_568645
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568646 = query.getOrDefault("api-version")
  valid_568646 = validateParameter(valid_568646, JString, required = true,
                                 default = nil)
  if valid_568646 != nil:
    section.add "api-version", valid_568646
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

proc call*(call_568648: Call_VirtualMachineScaleSetsCreateOrUpdate_568640;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a VM scale set.
  ## 
  let valid = call_568648.validator(path, query, header, formData, body)
  let scheme = call_568648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568648.url(scheme.get, call_568648.host, call_568648.base,
                         call_568648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568648, url, valid)

proc call*(call_568649: Call_VirtualMachineScaleSetsCreateOrUpdate_568640;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## virtualMachineScaleSetsCreateOrUpdate
  ## Create or update a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set to create or update.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The scale set object.
  var path_568650 = newJObject()
  var query_568651 = newJObject()
  var body_568652 = newJObject()
  add(path_568650, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568650, "resourceGroupName", newJString(resourceGroupName))
  add(query_568651, "api-version", newJString(apiVersion))
  add(path_568650, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568652 = parameters
  result = call_568649.call(path_568650, query_568651, nil, nil, body_568652)

var virtualMachineScaleSetsCreateOrUpdate* = Call_VirtualMachineScaleSetsCreateOrUpdate_568640(
    name: "virtualMachineScaleSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsCreateOrUpdate_568641, base: "",
    url: url_VirtualMachineScaleSetsCreateOrUpdate_568642, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGet_568629 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsGet_568631(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsGet_568630(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Display information about a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568632 = path.getOrDefault("vmScaleSetName")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "vmScaleSetName", valid_568632
  var valid_568633 = path.getOrDefault("resourceGroupName")
  valid_568633 = validateParameter(valid_568633, JString, required = true,
                                 default = nil)
  if valid_568633 != nil:
    section.add "resourceGroupName", valid_568633
  var valid_568634 = path.getOrDefault("subscriptionId")
  valid_568634 = validateParameter(valid_568634, JString, required = true,
                                 default = nil)
  if valid_568634 != nil:
    section.add "subscriptionId", valid_568634
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568635 = query.getOrDefault("api-version")
  valid_568635 = validateParameter(valid_568635, JString, required = true,
                                 default = nil)
  if valid_568635 != nil:
    section.add "api-version", valid_568635
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568636: Call_VirtualMachineScaleSetsGet_568629; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Display information about a virtual machine scale set.
  ## 
  let valid = call_568636.validator(path, query, header, formData, body)
  let scheme = call_568636.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568636.url(scheme.get, call_568636.host, call_568636.base,
                         call_568636.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568636, url, valid)

proc call*(call_568637: Call_VirtualMachineScaleSetsGet_568629;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsGet
  ## Display information about a virtual machine scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568638 = newJObject()
  var query_568639 = newJObject()
  add(path_568638, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568638, "resourceGroupName", newJString(resourceGroupName))
  add(query_568639, "api-version", newJString(apiVersion))
  add(path_568638, "subscriptionId", newJString(subscriptionId))
  result = call_568637.call(path_568638, query_568639, nil, nil, nil)

var virtualMachineScaleSetsGet* = Call_VirtualMachineScaleSetsGet_568629(
    name: "virtualMachineScaleSetsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsGet_568630, base: "",
    url: url_VirtualMachineScaleSetsGet_568631, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsUpdate_568664 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsUpdate_568666(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsUpdate_568665(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set to create or update.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568667 = path.getOrDefault("vmScaleSetName")
  valid_568667 = validateParameter(valid_568667, JString, required = true,
                                 default = nil)
  if valid_568667 != nil:
    section.add "vmScaleSetName", valid_568667
  var valid_568668 = path.getOrDefault("resourceGroupName")
  valid_568668 = validateParameter(valid_568668, JString, required = true,
                                 default = nil)
  if valid_568668 != nil:
    section.add "resourceGroupName", valid_568668
  var valid_568669 = path.getOrDefault("subscriptionId")
  valid_568669 = validateParameter(valid_568669, JString, required = true,
                                 default = nil)
  if valid_568669 != nil:
    section.add "subscriptionId", valid_568669
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568670 = query.getOrDefault("api-version")
  valid_568670 = validateParameter(valid_568670, JString, required = true,
                                 default = nil)
  if valid_568670 != nil:
    section.add "api-version", valid_568670
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

proc call*(call_568672: Call_VirtualMachineScaleSetsUpdate_568664; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a VM scale set.
  ## 
  let valid = call_568672.validator(path, query, header, formData, body)
  let scheme = call_568672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568672.url(scheme.get, call_568672.host, call_568672.base,
                         call_568672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568672, url, valid)

proc call*(call_568673: Call_VirtualMachineScaleSetsUpdate_568664;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## virtualMachineScaleSetsUpdate
  ## Update a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set to create or update.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The scale set object.
  var path_568674 = newJObject()
  var query_568675 = newJObject()
  var body_568676 = newJObject()
  add(path_568674, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568674, "resourceGroupName", newJString(resourceGroupName))
  add(query_568675, "api-version", newJString(apiVersion))
  add(path_568674, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568676 = parameters
  result = call_568673.call(path_568674, query_568675, nil, nil, body_568676)

var virtualMachineScaleSetsUpdate* = Call_VirtualMachineScaleSetsUpdate_568664(
    name: "virtualMachineScaleSetsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsUpdate_568665, base: "",
    url: url_VirtualMachineScaleSetsUpdate_568666, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDelete_568653 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsDelete_568655(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsDelete_568654(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568656 = path.getOrDefault("vmScaleSetName")
  valid_568656 = validateParameter(valid_568656, JString, required = true,
                                 default = nil)
  if valid_568656 != nil:
    section.add "vmScaleSetName", valid_568656
  var valid_568657 = path.getOrDefault("resourceGroupName")
  valid_568657 = validateParameter(valid_568657, JString, required = true,
                                 default = nil)
  if valid_568657 != nil:
    section.add "resourceGroupName", valid_568657
  var valid_568658 = path.getOrDefault("subscriptionId")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "subscriptionId", valid_568658
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568659 = query.getOrDefault("api-version")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "api-version", valid_568659
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568660: Call_VirtualMachineScaleSetsDelete_568653; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VM scale set.
  ## 
  let valid = call_568660.validator(path, query, header, formData, body)
  let scheme = call_568660.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568660.url(scheme.get, call_568660.host, call_568660.base,
                         call_568660.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568660, url, valid)

proc call*(call_568661: Call_VirtualMachineScaleSetsDelete_568653;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsDelete
  ## Deletes a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568662 = newJObject()
  var query_568663 = newJObject()
  add(path_568662, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568662, "resourceGroupName", newJString(resourceGroupName))
  add(query_568663, "api-version", newJString(apiVersion))
  add(path_568662, "subscriptionId", newJString(subscriptionId))
  result = call_568661.call(path_568662, query_568663, nil, nil, nil)

var virtualMachineScaleSetsDelete* = Call_VirtualMachineScaleSetsDelete_568653(
    name: "virtualMachineScaleSetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsDelete_568654, base: "",
    url: url_VirtualMachineScaleSetsDelete_568655, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDeallocate_568677 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsDeallocate_568679(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsDeallocate_568678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deallocates specific virtual machines in a VM scale set. Shuts down the virtual machines and releases the compute resources. You are not billed for the compute resources that this virtual machine scale set deallocates.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568680 = path.getOrDefault("vmScaleSetName")
  valid_568680 = validateParameter(valid_568680, JString, required = true,
                                 default = nil)
  if valid_568680 != nil:
    section.add "vmScaleSetName", valid_568680
  var valid_568681 = path.getOrDefault("resourceGroupName")
  valid_568681 = validateParameter(valid_568681, JString, required = true,
                                 default = nil)
  if valid_568681 != nil:
    section.add "resourceGroupName", valid_568681
  var valid_568682 = path.getOrDefault("subscriptionId")
  valid_568682 = validateParameter(valid_568682, JString, required = true,
                                 default = nil)
  if valid_568682 != nil:
    section.add "subscriptionId", valid_568682
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568683 = query.getOrDefault("api-version")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "api-version", valid_568683
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

proc call*(call_568685: Call_VirtualMachineScaleSetsDeallocate_568677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deallocates specific virtual machines in a VM scale set. Shuts down the virtual machines and releases the compute resources. You are not billed for the compute resources that this virtual machine scale set deallocates.
  ## 
  let valid = call_568685.validator(path, query, header, formData, body)
  let scheme = call_568685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568685.url(scheme.get, call_568685.host, call_568685.base,
                         call_568685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568685, url, valid)

proc call*(call_568686: Call_VirtualMachineScaleSetsDeallocate_568677;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsDeallocate
  ## Deallocates specific virtual machines in a VM scale set. Shuts down the virtual machines and releases the compute resources. You are not billed for the compute resources that this virtual machine scale set deallocates.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_568687 = newJObject()
  var query_568688 = newJObject()
  var body_568689 = newJObject()
  add(path_568687, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568687, "resourceGroupName", newJString(resourceGroupName))
  add(query_568688, "api-version", newJString(apiVersion))
  add(path_568687, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568689 = vmInstanceIDs
  result = call_568686.call(path_568687, query_568688, nil, nil, body_568689)

var virtualMachineScaleSetsDeallocate* = Call_VirtualMachineScaleSetsDeallocate_568677(
    name: "virtualMachineScaleSetsDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/deallocate",
    validator: validate_VirtualMachineScaleSetsDeallocate_568678, base: "",
    url: url_VirtualMachineScaleSetsDeallocate_568679, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDeleteInstances_568690 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsDeleteInstances_568692(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsDeleteInstances_568691(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes virtual machines in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568693 = path.getOrDefault("vmScaleSetName")
  valid_568693 = validateParameter(valid_568693, JString, required = true,
                                 default = nil)
  if valid_568693 != nil:
    section.add "vmScaleSetName", valid_568693
  var valid_568694 = path.getOrDefault("resourceGroupName")
  valid_568694 = validateParameter(valid_568694, JString, required = true,
                                 default = nil)
  if valid_568694 != nil:
    section.add "resourceGroupName", valid_568694
  var valid_568695 = path.getOrDefault("subscriptionId")
  valid_568695 = validateParameter(valid_568695, JString, required = true,
                                 default = nil)
  if valid_568695 != nil:
    section.add "subscriptionId", valid_568695
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568696 = query.getOrDefault("api-version")
  valid_568696 = validateParameter(valid_568696, JString, required = true,
                                 default = nil)
  if valid_568696 != nil:
    section.add "api-version", valid_568696
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

proc call*(call_568698: Call_VirtualMachineScaleSetsDeleteInstances_568690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes virtual machines in a VM scale set.
  ## 
  let valid = call_568698.validator(path, query, header, formData, body)
  let scheme = call_568698.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568698.url(scheme.get, call_568698.host, call_568698.base,
                         call_568698.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568698, url, valid)

proc call*(call_568699: Call_VirtualMachineScaleSetsDeleteInstances_568690;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmInstanceIDs: JsonNode): Recallable =
  ## virtualMachineScaleSetsDeleteInstances
  ## Deletes virtual machines in a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmInstanceIDs: JObject (required)
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_568700 = newJObject()
  var query_568701 = newJObject()
  var body_568702 = newJObject()
  add(path_568700, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568700, "resourceGroupName", newJString(resourceGroupName))
  add(query_568701, "api-version", newJString(apiVersion))
  add(path_568700, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568702 = vmInstanceIDs
  result = call_568699.call(path_568700, query_568701, nil, nil, body_568702)

var virtualMachineScaleSetsDeleteInstances* = Call_VirtualMachineScaleSetsDeleteInstances_568690(
    name: "virtualMachineScaleSetsDeleteInstances", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/delete",
    validator: validate_VirtualMachineScaleSetsDeleteInstances_568691, base: "",
    url: url_VirtualMachineScaleSetsDeleteInstances_568692,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_568703 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_568705(
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

proc validate_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_568704(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Starts a rolling upgrade to move all extensions for all virtual machine scale set instances to the latest available extension version. Instances which are already running the latest extension versions are not affected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568706 = path.getOrDefault("vmScaleSetName")
  valid_568706 = validateParameter(valid_568706, JString, required = true,
                                 default = nil)
  if valid_568706 != nil:
    section.add "vmScaleSetName", valid_568706
  var valid_568707 = path.getOrDefault("resourceGroupName")
  valid_568707 = validateParameter(valid_568707, JString, required = true,
                                 default = nil)
  if valid_568707 != nil:
    section.add "resourceGroupName", valid_568707
  var valid_568708 = path.getOrDefault("subscriptionId")
  valid_568708 = validateParameter(valid_568708, JString, required = true,
                                 default = nil)
  if valid_568708 != nil:
    section.add "subscriptionId", valid_568708
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568709 = query.getOrDefault("api-version")
  valid_568709 = validateParameter(valid_568709, JString, required = true,
                                 default = nil)
  if valid_568709 != nil:
    section.add "api-version", valid_568709
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568710: Call_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_568703;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a rolling upgrade to move all extensions for all virtual machine scale set instances to the latest available extension version. Instances which are already running the latest extension versions are not affected.
  ## 
  let valid = call_568710.validator(path, query, header, formData, body)
  let scheme = call_568710.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568710.url(scheme.get, call_568710.host, call_568710.base,
                         call_568710.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568710, url, valid)

proc call*(call_568711: Call_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_568703;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineScaleSetRollingUpgradesStartExtensionUpgrade
  ## Starts a rolling upgrade to move all extensions for all virtual machine scale set instances to the latest available extension version. Instances which are already running the latest extension versions are not affected.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568712 = newJObject()
  var query_568713 = newJObject()
  add(path_568712, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568712, "resourceGroupName", newJString(resourceGroupName))
  add(query_568713, "api-version", newJString(apiVersion))
  add(path_568712, "subscriptionId", newJString(subscriptionId))
  result = call_568711.call(path_568712, query_568713, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesStartExtensionUpgrade* = Call_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_568703(
    name: "virtualMachineScaleSetRollingUpgradesStartExtensionUpgrade",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensionRollingUpgrade", validator: validate_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_568704,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_568705,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsList_568714 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetExtensionsList_568716(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetExtensionsList_568715(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of all extensions in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set containing the extension.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568717 = path.getOrDefault("vmScaleSetName")
  valid_568717 = validateParameter(valid_568717, JString, required = true,
                                 default = nil)
  if valid_568717 != nil:
    section.add "vmScaleSetName", valid_568717
  var valid_568718 = path.getOrDefault("resourceGroupName")
  valid_568718 = validateParameter(valid_568718, JString, required = true,
                                 default = nil)
  if valid_568718 != nil:
    section.add "resourceGroupName", valid_568718
  var valid_568719 = path.getOrDefault("subscriptionId")
  valid_568719 = validateParameter(valid_568719, JString, required = true,
                                 default = nil)
  if valid_568719 != nil:
    section.add "subscriptionId", valid_568719
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568720 = query.getOrDefault("api-version")
  valid_568720 = validateParameter(valid_568720, JString, required = true,
                                 default = nil)
  if valid_568720 != nil:
    section.add "api-version", valid_568720
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568721: Call_VirtualMachineScaleSetExtensionsList_568714;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of all extensions in a VM scale set.
  ## 
  let valid = call_568721.validator(path, query, header, formData, body)
  let scheme = call_568721.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568721.url(scheme.get, call_568721.host, call_568721.base,
                         call_568721.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568721, url, valid)

proc call*(call_568722: Call_VirtualMachineScaleSetExtensionsList_568714;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineScaleSetExtensionsList
  ## Gets a list of all extensions in a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set containing the extension.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568723 = newJObject()
  var query_568724 = newJObject()
  add(path_568723, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568723, "resourceGroupName", newJString(resourceGroupName))
  add(query_568724, "api-version", newJString(apiVersion))
  add(path_568723, "subscriptionId", newJString(subscriptionId))
  result = call_568722.call(path_568723, query_568724, nil, nil, nil)

var virtualMachineScaleSetExtensionsList* = Call_VirtualMachineScaleSetExtensionsList_568714(
    name: "virtualMachineScaleSetExtensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions",
    validator: validate_VirtualMachineScaleSetExtensionsList_568715, base: "",
    url: url_VirtualMachineScaleSetExtensionsList_568716, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_568738 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetExtensionsCreateOrUpdate_568740(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetExtensionsCreateOrUpdate_568739(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The operation to create or update an extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set where the extension should be create or updated.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmssExtensionName: JString (required)
  ##                    : The name of the VM scale set extension.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568741 = path.getOrDefault("vmScaleSetName")
  valid_568741 = validateParameter(valid_568741, JString, required = true,
                                 default = nil)
  if valid_568741 != nil:
    section.add "vmScaleSetName", valid_568741
  var valid_568742 = path.getOrDefault("resourceGroupName")
  valid_568742 = validateParameter(valid_568742, JString, required = true,
                                 default = nil)
  if valid_568742 != nil:
    section.add "resourceGroupName", valid_568742
  var valid_568743 = path.getOrDefault("subscriptionId")
  valid_568743 = validateParameter(valid_568743, JString, required = true,
                                 default = nil)
  if valid_568743 != nil:
    section.add "subscriptionId", valid_568743
  var valid_568744 = path.getOrDefault("vmssExtensionName")
  valid_568744 = validateParameter(valid_568744, JString, required = true,
                                 default = nil)
  if valid_568744 != nil:
    section.add "vmssExtensionName", valid_568744
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568745 = query.getOrDefault("api-version")
  valid_568745 = validateParameter(valid_568745, JString, required = true,
                                 default = nil)
  if valid_568745 != nil:
    section.add "api-version", valid_568745
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

proc call*(call_568747: Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_568738;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update an extension.
  ## 
  let valid = call_568747.validator(path, query, header, formData, body)
  let scheme = call_568747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568747.url(scheme.get, call_568747.host, call_568747.base,
                         call_568747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568747, url, valid)

proc call*(call_568748: Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_568738;
          vmScaleSetName: string; extensionParameters: JsonNode;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmssExtensionName: string): Recallable =
  ## virtualMachineScaleSetExtensionsCreateOrUpdate
  ## The operation to create or update an extension.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set where the extension should be create or updated.
  ##   extensionParameters: JObject (required)
  ##                      : Parameters supplied to the Create VM scale set Extension operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmssExtensionName: string (required)
  ##                    : The name of the VM scale set extension.
  var path_568749 = newJObject()
  var query_568750 = newJObject()
  var body_568751 = newJObject()
  add(path_568749, "vmScaleSetName", newJString(vmScaleSetName))
  if extensionParameters != nil:
    body_568751 = extensionParameters
  add(path_568749, "resourceGroupName", newJString(resourceGroupName))
  add(query_568750, "api-version", newJString(apiVersion))
  add(path_568749, "subscriptionId", newJString(subscriptionId))
  add(path_568749, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_568748.call(path_568749, query_568750, nil, nil, body_568751)

var virtualMachineScaleSetExtensionsCreateOrUpdate* = Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_568738(
    name: "virtualMachineScaleSetExtensionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsCreateOrUpdate_568739,
    base: "", url: url_VirtualMachineScaleSetExtensionsCreateOrUpdate_568740,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsGet_568725 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetExtensionsGet_568727(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetExtensionsGet_568726(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to get the extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set containing the extension.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmssExtensionName: JString (required)
  ##                    : The name of the VM scale set extension.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568728 = path.getOrDefault("vmScaleSetName")
  valid_568728 = validateParameter(valid_568728, JString, required = true,
                                 default = nil)
  if valid_568728 != nil:
    section.add "vmScaleSetName", valid_568728
  var valid_568729 = path.getOrDefault("resourceGroupName")
  valid_568729 = validateParameter(valid_568729, JString, required = true,
                                 default = nil)
  if valid_568729 != nil:
    section.add "resourceGroupName", valid_568729
  var valid_568730 = path.getOrDefault("subscriptionId")
  valid_568730 = validateParameter(valid_568730, JString, required = true,
                                 default = nil)
  if valid_568730 != nil:
    section.add "subscriptionId", valid_568730
  var valid_568731 = path.getOrDefault("vmssExtensionName")
  valid_568731 = validateParameter(valid_568731, JString, required = true,
                                 default = nil)
  if valid_568731 != nil:
    section.add "vmssExtensionName", valid_568731
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_568732 = query.getOrDefault("$expand")
  valid_568732 = validateParameter(valid_568732, JString, required = false,
                                 default = nil)
  if valid_568732 != nil:
    section.add "$expand", valid_568732
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568733 = query.getOrDefault("api-version")
  valid_568733 = validateParameter(valid_568733, JString, required = true,
                                 default = nil)
  if valid_568733 != nil:
    section.add "api-version", valid_568733
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568734: Call_VirtualMachineScaleSetExtensionsGet_568725;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to get the extension.
  ## 
  let valid = call_568734.validator(path, query, header, formData, body)
  let scheme = call_568734.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568734.url(scheme.get, call_568734.host, call_568734.base,
                         call_568734.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568734, url, valid)

proc call*(call_568735: Call_VirtualMachineScaleSetExtensionsGet_568725;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmssExtensionName: string; Expand: string = ""): Recallable =
  ## virtualMachineScaleSetExtensionsGet
  ## The operation to get the extension.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set containing the extension.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmssExtensionName: string (required)
  ##                    : The name of the VM scale set extension.
  var path_568736 = newJObject()
  var query_568737 = newJObject()
  add(path_568736, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568736, "resourceGroupName", newJString(resourceGroupName))
  add(query_568737, "$expand", newJString(Expand))
  add(query_568737, "api-version", newJString(apiVersion))
  add(path_568736, "subscriptionId", newJString(subscriptionId))
  add(path_568736, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_568735.call(path_568736, query_568737, nil, nil, nil)

var virtualMachineScaleSetExtensionsGet* = Call_VirtualMachineScaleSetExtensionsGet_568725(
    name: "virtualMachineScaleSetExtensionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsGet_568726, base: "",
    url: url_VirtualMachineScaleSetExtensionsGet_568727, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsDelete_568752 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetExtensionsDelete_568754(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetExtensionsDelete_568753(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete the extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set where the extension should be deleted.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmssExtensionName: JString (required)
  ##                    : The name of the VM scale set extension.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568755 = path.getOrDefault("vmScaleSetName")
  valid_568755 = validateParameter(valid_568755, JString, required = true,
                                 default = nil)
  if valid_568755 != nil:
    section.add "vmScaleSetName", valid_568755
  var valid_568756 = path.getOrDefault("resourceGroupName")
  valid_568756 = validateParameter(valid_568756, JString, required = true,
                                 default = nil)
  if valid_568756 != nil:
    section.add "resourceGroupName", valid_568756
  var valid_568757 = path.getOrDefault("subscriptionId")
  valid_568757 = validateParameter(valid_568757, JString, required = true,
                                 default = nil)
  if valid_568757 != nil:
    section.add "subscriptionId", valid_568757
  var valid_568758 = path.getOrDefault("vmssExtensionName")
  valid_568758 = validateParameter(valid_568758, JString, required = true,
                                 default = nil)
  if valid_568758 != nil:
    section.add "vmssExtensionName", valid_568758
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568759 = query.getOrDefault("api-version")
  valid_568759 = validateParameter(valid_568759, JString, required = true,
                                 default = nil)
  if valid_568759 != nil:
    section.add "api-version", valid_568759
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568760: Call_VirtualMachineScaleSetExtensionsDelete_568752;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete the extension.
  ## 
  let valid = call_568760.validator(path, query, header, formData, body)
  let scheme = call_568760.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568760.url(scheme.get, call_568760.host, call_568760.base,
                         call_568760.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568760, url, valid)

proc call*(call_568761: Call_VirtualMachineScaleSetExtensionsDelete_568752;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmssExtensionName: string): Recallable =
  ## virtualMachineScaleSetExtensionsDelete
  ## The operation to delete the extension.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set where the extension should be deleted.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmssExtensionName: string (required)
  ##                    : The name of the VM scale set extension.
  var path_568762 = newJObject()
  var query_568763 = newJObject()
  add(path_568762, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568762, "resourceGroupName", newJString(resourceGroupName))
  add(query_568763, "api-version", newJString(apiVersion))
  add(path_568762, "subscriptionId", newJString(subscriptionId))
  add(path_568762, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_568761.call(path_568762, query_568763, nil, nil, nil)

var virtualMachineScaleSetExtensionsDelete* = Call_VirtualMachineScaleSetExtensionsDelete_568752(
    name: "virtualMachineScaleSetExtensionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsDelete_568753, base: "",
    url: url_VirtualMachineScaleSetExtensionsDelete_568754,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568764 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568766(
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

proc validate_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568765(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Manual platform update domain walk to update virtual machines in a service fabric virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568767 = path.getOrDefault("vmScaleSetName")
  valid_568767 = validateParameter(valid_568767, JString, required = true,
                                 default = nil)
  if valid_568767 != nil:
    section.add "vmScaleSetName", valid_568767
  var valid_568768 = path.getOrDefault("resourceGroupName")
  valid_568768 = validateParameter(valid_568768, JString, required = true,
                                 default = nil)
  if valid_568768 != nil:
    section.add "resourceGroupName", valid_568768
  var valid_568769 = path.getOrDefault("subscriptionId")
  valid_568769 = validateParameter(valid_568769, JString, required = true,
                                 default = nil)
  if valid_568769 != nil:
    section.add "subscriptionId", valid_568769
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   platformUpdateDomain: JInt (required)
  ##                       : The platform update domain for which a manual recovery walk is requested
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568770 = query.getOrDefault("api-version")
  valid_568770 = validateParameter(valid_568770, JString, required = true,
                                 default = nil)
  if valid_568770 != nil:
    section.add "api-version", valid_568770
  var valid_568771 = query.getOrDefault("platformUpdateDomain")
  valid_568771 = validateParameter(valid_568771, JInt, required = true, default = nil)
  if valid_568771 != nil:
    section.add "platformUpdateDomain", valid_568771
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568772: Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568764;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Manual platform update domain walk to update virtual machines in a service fabric virtual machine scale set.
  ## 
  let valid = call_568772.validator(path, query, header, formData, body)
  let scheme = call_568772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568772.url(scheme.get, call_568772.host, call_568772.base,
                         call_568772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568772, url, valid)

proc call*(call_568773: Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568764;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          platformUpdateDomain: int; subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk
  ## Manual platform update domain walk to update virtual machines in a service fabric virtual machine scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   platformUpdateDomain: int (required)
  ##                       : The platform update domain for which a manual recovery walk is requested
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568774 = newJObject()
  var query_568775 = newJObject()
  add(path_568774, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568774, "resourceGroupName", newJString(resourceGroupName))
  add(query_568775, "api-version", newJString(apiVersion))
  add(query_568775, "platformUpdateDomain", newJInt(platformUpdateDomain))
  add(path_568774, "subscriptionId", newJString(subscriptionId))
  result = call_568773.call(path_568774, query_568775, nil, nil, nil)

var virtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk* = Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568764(name: "virtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/forceRecoveryServiceFabricPlatformUpdateDomainWalk", validator: validate_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568765,
    base: "", url: url_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568766,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGetInstanceView_568776 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsGetInstanceView_568778(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsGetInstanceView_568777(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of a VM scale set instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568779 = path.getOrDefault("vmScaleSetName")
  valid_568779 = validateParameter(valid_568779, JString, required = true,
                                 default = nil)
  if valid_568779 != nil:
    section.add "vmScaleSetName", valid_568779
  var valid_568780 = path.getOrDefault("resourceGroupName")
  valid_568780 = validateParameter(valid_568780, JString, required = true,
                                 default = nil)
  if valid_568780 != nil:
    section.add "resourceGroupName", valid_568780
  var valid_568781 = path.getOrDefault("subscriptionId")
  valid_568781 = validateParameter(valid_568781, JString, required = true,
                                 default = nil)
  if valid_568781 != nil:
    section.add "subscriptionId", valid_568781
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568782 = query.getOrDefault("api-version")
  valid_568782 = validateParameter(valid_568782, JString, required = true,
                                 default = nil)
  if valid_568782 != nil:
    section.add "api-version", valid_568782
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568783: Call_VirtualMachineScaleSetsGetInstanceView_568776;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of a VM scale set instance.
  ## 
  let valid = call_568783.validator(path, query, header, formData, body)
  let scheme = call_568783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568783.url(scheme.get, call_568783.host, call_568783.base,
                         call_568783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568783, url, valid)

proc call*(call_568784: Call_VirtualMachineScaleSetsGetInstanceView_568776;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsGetInstanceView
  ## Gets the status of a VM scale set instance.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568785 = newJObject()
  var query_568786 = newJObject()
  add(path_568785, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568785, "resourceGroupName", newJString(resourceGroupName))
  add(query_568786, "api-version", newJString(apiVersion))
  add(path_568785, "subscriptionId", newJString(subscriptionId))
  result = call_568784.call(path_568785, query_568786, nil, nil, nil)

var virtualMachineScaleSetsGetInstanceView* = Call_VirtualMachineScaleSetsGetInstanceView_568776(
    name: "virtualMachineScaleSetsGetInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/instanceView",
    validator: validate_VirtualMachineScaleSetsGetInstanceView_568777, base: "",
    url: url_VirtualMachineScaleSetsGetInstanceView_568778,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsUpdateInstances_568787 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsUpdateInstances_568789(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsUpdateInstances_568788(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Upgrades one or more virtual machines to the latest SKU set in the VM scale set model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568790 = path.getOrDefault("vmScaleSetName")
  valid_568790 = validateParameter(valid_568790, JString, required = true,
                                 default = nil)
  if valid_568790 != nil:
    section.add "vmScaleSetName", valid_568790
  var valid_568791 = path.getOrDefault("resourceGroupName")
  valid_568791 = validateParameter(valid_568791, JString, required = true,
                                 default = nil)
  if valid_568791 != nil:
    section.add "resourceGroupName", valid_568791
  var valid_568792 = path.getOrDefault("subscriptionId")
  valid_568792 = validateParameter(valid_568792, JString, required = true,
                                 default = nil)
  if valid_568792 != nil:
    section.add "subscriptionId", valid_568792
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568793 = query.getOrDefault("api-version")
  valid_568793 = validateParameter(valid_568793, JString, required = true,
                                 default = nil)
  if valid_568793 != nil:
    section.add "api-version", valid_568793
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

proc call*(call_568795: Call_VirtualMachineScaleSetsUpdateInstances_568787;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upgrades one or more virtual machines to the latest SKU set in the VM scale set model.
  ## 
  let valid = call_568795.validator(path, query, header, formData, body)
  let scheme = call_568795.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568795.url(scheme.get, call_568795.host, call_568795.base,
                         call_568795.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568795, url, valid)

proc call*(call_568796: Call_VirtualMachineScaleSetsUpdateInstances_568787;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmInstanceIDs: JsonNode): Recallable =
  ## virtualMachineScaleSetsUpdateInstances
  ## Upgrades one or more virtual machines to the latest SKU set in the VM scale set model.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmInstanceIDs: JObject (required)
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_568797 = newJObject()
  var query_568798 = newJObject()
  var body_568799 = newJObject()
  add(path_568797, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568797, "resourceGroupName", newJString(resourceGroupName))
  add(query_568798, "api-version", newJString(apiVersion))
  add(path_568797, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568799 = vmInstanceIDs
  result = call_568796.call(path_568797, query_568798, nil, nil, body_568799)

var virtualMachineScaleSetsUpdateInstances* = Call_VirtualMachineScaleSetsUpdateInstances_568787(
    name: "virtualMachineScaleSetsUpdateInstances", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/manualupgrade",
    validator: validate_VirtualMachineScaleSetsUpdateInstances_568788, base: "",
    url: url_VirtualMachineScaleSetsUpdateInstances_568789,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568800 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568802(
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

proc validate_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568801(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Starts a rolling upgrade to move all virtual machine scale set instances to the latest available Platform Image OS version. Instances which are already running the latest available OS version are not affected.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568803 = path.getOrDefault("vmScaleSetName")
  valid_568803 = validateParameter(valid_568803, JString, required = true,
                                 default = nil)
  if valid_568803 != nil:
    section.add "vmScaleSetName", valid_568803
  var valid_568804 = path.getOrDefault("resourceGroupName")
  valid_568804 = validateParameter(valid_568804, JString, required = true,
                                 default = nil)
  if valid_568804 != nil:
    section.add "resourceGroupName", valid_568804
  var valid_568805 = path.getOrDefault("subscriptionId")
  valid_568805 = validateParameter(valid_568805, JString, required = true,
                                 default = nil)
  if valid_568805 != nil:
    section.add "subscriptionId", valid_568805
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568806 = query.getOrDefault("api-version")
  valid_568806 = validateParameter(valid_568806, JString, required = true,
                                 default = nil)
  if valid_568806 != nil:
    section.add "api-version", valid_568806
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568807: Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568800;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a rolling upgrade to move all virtual machine scale set instances to the latest available Platform Image OS version. Instances which are already running the latest available OS version are not affected.
  ## 
  let valid = call_568807.validator(path, query, header, formData, body)
  let scheme = call_568807.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568807.url(scheme.get, call_568807.host, call_568807.base,
                         call_568807.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568807, url, valid)

proc call*(call_568808: Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568800;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineScaleSetRollingUpgradesStartOSUpgrade
  ## Starts a rolling upgrade to move all virtual machine scale set instances to the latest available Platform Image OS version. Instances which are already running the latest available OS version are not affected.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568809 = newJObject()
  var query_568810 = newJObject()
  add(path_568809, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568809, "resourceGroupName", newJString(resourceGroupName))
  add(query_568810, "api-version", newJString(apiVersion))
  add(path_568809, "subscriptionId", newJString(subscriptionId))
  result = call_568808.call(path_568809, query_568810, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesStartOSUpgrade* = Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568800(
    name: "virtualMachineScaleSetRollingUpgradesStartOSUpgrade",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/osRollingUpgrade",
    validator: validate_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568801,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568802,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGetOSUpgradeHistory_568811 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsGetOSUpgradeHistory_568813(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsGetOSUpgradeHistory_568812(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets list of OS upgrades on a VM scale set instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568814 = path.getOrDefault("vmScaleSetName")
  valid_568814 = validateParameter(valid_568814, JString, required = true,
                                 default = nil)
  if valid_568814 != nil:
    section.add "vmScaleSetName", valid_568814
  var valid_568815 = path.getOrDefault("resourceGroupName")
  valid_568815 = validateParameter(valid_568815, JString, required = true,
                                 default = nil)
  if valid_568815 != nil:
    section.add "resourceGroupName", valid_568815
  var valid_568816 = path.getOrDefault("subscriptionId")
  valid_568816 = validateParameter(valid_568816, JString, required = true,
                                 default = nil)
  if valid_568816 != nil:
    section.add "subscriptionId", valid_568816
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568817 = query.getOrDefault("api-version")
  valid_568817 = validateParameter(valid_568817, JString, required = true,
                                 default = nil)
  if valid_568817 != nil:
    section.add "api-version", valid_568817
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568818: Call_VirtualMachineScaleSetsGetOSUpgradeHistory_568811;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets list of OS upgrades on a VM scale set instance.
  ## 
  let valid = call_568818.validator(path, query, header, formData, body)
  let scheme = call_568818.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568818.url(scheme.get, call_568818.host, call_568818.base,
                         call_568818.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568818, url, valid)

proc call*(call_568819: Call_VirtualMachineScaleSetsGetOSUpgradeHistory_568811;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsGetOSUpgradeHistory
  ## Gets list of OS upgrades on a VM scale set instance.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568820 = newJObject()
  var query_568821 = newJObject()
  add(path_568820, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568820, "resourceGroupName", newJString(resourceGroupName))
  add(query_568821, "api-version", newJString(apiVersion))
  add(path_568820, "subscriptionId", newJString(subscriptionId))
  result = call_568819.call(path_568820, query_568821, nil, nil, nil)

var virtualMachineScaleSetsGetOSUpgradeHistory* = Call_VirtualMachineScaleSetsGetOSUpgradeHistory_568811(
    name: "virtualMachineScaleSetsGetOSUpgradeHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/osUpgradeHistory",
    validator: validate_VirtualMachineScaleSetsGetOSUpgradeHistory_568812,
    base: "", url: url_VirtualMachineScaleSetsGetOSUpgradeHistory_568813,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsPerformMaintenance_568822 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsPerformMaintenance_568824(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsPerformMaintenance_568823(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Perform maintenance on one or more virtual machines in a VM scale set. Operation on instances which are not eligible for perform maintenance will be failed. Please refer to best practices for more details: https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-maintenance-notifications
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568825 = path.getOrDefault("vmScaleSetName")
  valid_568825 = validateParameter(valid_568825, JString, required = true,
                                 default = nil)
  if valid_568825 != nil:
    section.add "vmScaleSetName", valid_568825
  var valid_568826 = path.getOrDefault("resourceGroupName")
  valid_568826 = validateParameter(valid_568826, JString, required = true,
                                 default = nil)
  if valid_568826 != nil:
    section.add "resourceGroupName", valid_568826
  var valid_568827 = path.getOrDefault("subscriptionId")
  valid_568827 = validateParameter(valid_568827, JString, required = true,
                                 default = nil)
  if valid_568827 != nil:
    section.add "subscriptionId", valid_568827
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568828 = query.getOrDefault("api-version")
  valid_568828 = validateParameter(valid_568828, JString, required = true,
                                 default = nil)
  if valid_568828 != nil:
    section.add "api-version", valid_568828
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

proc call*(call_568830: Call_VirtualMachineScaleSetsPerformMaintenance_568822;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Perform maintenance on one or more virtual machines in a VM scale set. Operation on instances which are not eligible for perform maintenance will be failed. Please refer to best practices for more details: https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-maintenance-notifications
  ## 
  let valid = call_568830.validator(path, query, header, formData, body)
  let scheme = call_568830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568830.url(scheme.get, call_568830.host, call_568830.base,
                         call_568830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568830, url, valid)

proc call*(call_568831: Call_VirtualMachineScaleSetsPerformMaintenance_568822;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsPerformMaintenance
  ## Perform maintenance on one or more virtual machines in a VM scale set. Operation on instances which are not eligible for perform maintenance will be failed. Please refer to best practices for more details: https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-maintenance-notifications
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_568832 = newJObject()
  var query_568833 = newJObject()
  var body_568834 = newJObject()
  add(path_568832, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568832, "resourceGroupName", newJString(resourceGroupName))
  add(query_568833, "api-version", newJString(apiVersion))
  add(path_568832, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568834 = vmInstanceIDs
  result = call_568831.call(path_568832, query_568833, nil, nil, body_568834)

var virtualMachineScaleSetsPerformMaintenance* = Call_VirtualMachineScaleSetsPerformMaintenance_568822(
    name: "virtualMachineScaleSetsPerformMaintenance", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/performMaintenance",
    validator: validate_VirtualMachineScaleSetsPerformMaintenance_568823,
    base: "", url: url_VirtualMachineScaleSetsPerformMaintenance_568824,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsPowerOff_568835 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsPowerOff_568837(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsPowerOff_568836(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Power off (stop) one or more virtual machines in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568838 = path.getOrDefault("vmScaleSetName")
  valid_568838 = validateParameter(valid_568838, JString, required = true,
                                 default = nil)
  if valid_568838 != nil:
    section.add "vmScaleSetName", valid_568838
  var valid_568839 = path.getOrDefault("resourceGroupName")
  valid_568839 = validateParameter(valid_568839, JString, required = true,
                                 default = nil)
  if valid_568839 != nil:
    section.add "resourceGroupName", valid_568839
  var valid_568840 = path.getOrDefault("subscriptionId")
  valid_568840 = validateParameter(valid_568840, JString, required = true,
                                 default = nil)
  if valid_568840 != nil:
    section.add "subscriptionId", valid_568840
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568841 = query.getOrDefault("api-version")
  valid_568841 = validateParameter(valid_568841, JString, required = true,
                                 default = nil)
  if valid_568841 != nil:
    section.add "api-version", valid_568841
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

proc call*(call_568843: Call_VirtualMachineScaleSetsPowerOff_568835;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Power off (stop) one or more virtual machines in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  let valid = call_568843.validator(path, query, header, formData, body)
  let scheme = call_568843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568843.url(scheme.get, call_568843.host, call_568843.base,
                         call_568843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568843, url, valid)

proc call*(call_568844: Call_VirtualMachineScaleSetsPowerOff_568835;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsPowerOff
  ## Power off (stop) one or more virtual machines in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_568845 = newJObject()
  var query_568846 = newJObject()
  var body_568847 = newJObject()
  add(path_568845, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568845, "resourceGroupName", newJString(resourceGroupName))
  add(query_568846, "api-version", newJString(apiVersion))
  add(path_568845, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568847 = vmInstanceIDs
  result = call_568844.call(path_568845, query_568846, nil, nil, body_568847)

var virtualMachineScaleSetsPowerOff* = Call_VirtualMachineScaleSetsPowerOff_568835(
    name: "virtualMachineScaleSetsPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/poweroff",
    validator: validate_VirtualMachineScaleSetsPowerOff_568836, base: "",
    url: url_VirtualMachineScaleSetsPowerOff_568837, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsRedeploy_568848 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsRedeploy_568850(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsRedeploy_568849(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shuts down all the virtual machines in the virtual machine scale set, moves them to a new node, and powers them back on.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568851 = path.getOrDefault("vmScaleSetName")
  valid_568851 = validateParameter(valid_568851, JString, required = true,
                                 default = nil)
  if valid_568851 != nil:
    section.add "vmScaleSetName", valid_568851
  var valid_568852 = path.getOrDefault("resourceGroupName")
  valid_568852 = validateParameter(valid_568852, JString, required = true,
                                 default = nil)
  if valid_568852 != nil:
    section.add "resourceGroupName", valid_568852
  var valid_568853 = path.getOrDefault("subscriptionId")
  valid_568853 = validateParameter(valid_568853, JString, required = true,
                                 default = nil)
  if valid_568853 != nil:
    section.add "subscriptionId", valid_568853
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568854 = query.getOrDefault("api-version")
  valid_568854 = validateParameter(valid_568854, JString, required = true,
                                 default = nil)
  if valid_568854 != nil:
    section.add "api-version", valid_568854
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

proc call*(call_568856: Call_VirtualMachineScaleSetsRedeploy_568848;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Shuts down all the virtual machines in the virtual machine scale set, moves them to a new node, and powers them back on.
  ## 
  let valid = call_568856.validator(path, query, header, formData, body)
  let scheme = call_568856.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568856.url(scheme.get, call_568856.host, call_568856.base,
                         call_568856.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568856, url, valid)

proc call*(call_568857: Call_VirtualMachineScaleSetsRedeploy_568848;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsRedeploy
  ## Shuts down all the virtual machines in the virtual machine scale set, moves them to a new node, and powers them back on.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_568858 = newJObject()
  var query_568859 = newJObject()
  var body_568860 = newJObject()
  add(path_568858, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568858, "resourceGroupName", newJString(resourceGroupName))
  add(query_568859, "api-version", newJString(apiVersion))
  add(path_568858, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568860 = vmInstanceIDs
  result = call_568857.call(path_568858, query_568859, nil, nil, body_568860)

var virtualMachineScaleSetsRedeploy* = Call_VirtualMachineScaleSetsRedeploy_568848(
    name: "virtualMachineScaleSetsRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/redeploy",
    validator: validate_VirtualMachineScaleSetsRedeploy_568849, base: "",
    url: url_VirtualMachineScaleSetsRedeploy_568850, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsReimage_568861 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsReimage_568863(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsReimage_568862(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reimages (upgrade the operating system) one or more virtual machines in a VM scale set which don't have a ephemeral OS disk, for virtual machines who have a ephemeral OS disk the virtual machine is reset to initial state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568864 = path.getOrDefault("vmScaleSetName")
  valid_568864 = validateParameter(valid_568864, JString, required = true,
                                 default = nil)
  if valid_568864 != nil:
    section.add "vmScaleSetName", valid_568864
  var valid_568865 = path.getOrDefault("resourceGroupName")
  valid_568865 = validateParameter(valid_568865, JString, required = true,
                                 default = nil)
  if valid_568865 != nil:
    section.add "resourceGroupName", valid_568865
  var valid_568866 = path.getOrDefault("subscriptionId")
  valid_568866 = validateParameter(valid_568866, JString, required = true,
                                 default = nil)
  if valid_568866 != nil:
    section.add "subscriptionId", valid_568866
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568867 = query.getOrDefault("api-version")
  valid_568867 = validateParameter(valid_568867, JString, required = true,
                                 default = nil)
  if valid_568867 != nil:
    section.add "api-version", valid_568867
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

proc call*(call_568869: Call_VirtualMachineScaleSetsReimage_568861; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reimages (upgrade the operating system) one or more virtual machines in a VM scale set which don't have a ephemeral OS disk, for virtual machines who have a ephemeral OS disk the virtual machine is reset to initial state.
  ## 
  let valid = call_568869.validator(path, query, header, formData, body)
  let scheme = call_568869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568869.url(scheme.get, call_568869.host, call_568869.base,
                         call_568869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568869, url, valid)

proc call*(call_568870: Call_VirtualMachineScaleSetsReimage_568861;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmScaleSetReimageInput: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsReimage
  ## Reimages (upgrade the operating system) one or more virtual machines in a VM scale set which don't have a ephemeral OS disk, for virtual machines who have a ephemeral OS disk the virtual machine is reset to initial state.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmScaleSetReimageInput: JObject
  ##                         : Parameters for Reimaging VM ScaleSet.
  var path_568871 = newJObject()
  var query_568872 = newJObject()
  var body_568873 = newJObject()
  add(path_568871, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568871, "resourceGroupName", newJString(resourceGroupName))
  add(query_568872, "api-version", newJString(apiVersion))
  add(path_568871, "subscriptionId", newJString(subscriptionId))
  if vmScaleSetReimageInput != nil:
    body_568873 = vmScaleSetReimageInput
  result = call_568870.call(path_568871, query_568872, nil, nil, body_568873)

var virtualMachineScaleSetsReimage* = Call_VirtualMachineScaleSetsReimage_568861(
    name: "virtualMachineScaleSetsReimage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/reimage",
    validator: validate_VirtualMachineScaleSetsReimage_568862, base: "",
    url: url_VirtualMachineScaleSetsReimage_568863, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsReimageAll_568874 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsReimageAll_568876(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsReimageAll_568875(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reimages all the disks ( including data disks ) in the virtual machines in a VM scale set. This operation is only supported for managed disks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568877 = path.getOrDefault("vmScaleSetName")
  valid_568877 = validateParameter(valid_568877, JString, required = true,
                                 default = nil)
  if valid_568877 != nil:
    section.add "vmScaleSetName", valid_568877
  var valid_568878 = path.getOrDefault("resourceGroupName")
  valid_568878 = validateParameter(valid_568878, JString, required = true,
                                 default = nil)
  if valid_568878 != nil:
    section.add "resourceGroupName", valid_568878
  var valid_568879 = path.getOrDefault("subscriptionId")
  valid_568879 = validateParameter(valid_568879, JString, required = true,
                                 default = nil)
  if valid_568879 != nil:
    section.add "subscriptionId", valid_568879
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568880 = query.getOrDefault("api-version")
  valid_568880 = validateParameter(valid_568880, JString, required = true,
                                 default = nil)
  if valid_568880 != nil:
    section.add "api-version", valid_568880
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

proc call*(call_568882: Call_VirtualMachineScaleSetsReimageAll_568874;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reimages all the disks ( including data disks ) in the virtual machines in a VM scale set. This operation is only supported for managed disks.
  ## 
  let valid = call_568882.validator(path, query, header, formData, body)
  let scheme = call_568882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568882.url(scheme.get, call_568882.host, call_568882.base,
                         call_568882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568882, url, valid)

proc call*(call_568883: Call_VirtualMachineScaleSetsReimageAll_568874;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsReimageAll
  ## Reimages all the disks ( including data disks ) in the virtual machines in a VM scale set. This operation is only supported for managed disks.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_568884 = newJObject()
  var query_568885 = newJObject()
  var body_568886 = newJObject()
  add(path_568884, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568884, "resourceGroupName", newJString(resourceGroupName))
  add(query_568885, "api-version", newJString(apiVersion))
  add(path_568884, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568886 = vmInstanceIDs
  result = call_568883.call(path_568884, query_568885, nil, nil, body_568886)

var virtualMachineScaleSetsReimageAll* = Call_VirtualMachineScaleSetsReimageAll_568874(
    name: "virtualMachineScaleSetsReimageAll", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/reimageall",
    validator: validate_VirtualMachineScaleSetsReimageAll_568875, base: "",
    url: url_VirtualMachineScaleSetsReimageAll_568876, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsRestart_568887 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsRestart_568889(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsRestart_568888(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restarts one or more virtual machines in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568890 = path.getOrDefault("vmScaleSetName")
  valid_568890 = validateParameter(valid_568890, JString, required = true,
                                 default = nil)
  if valid_568890 != nil:
    section.add "vmScaleSetName", valid_568890
  var valid_568891 = path.getOrDefault("resourceGroupName")
  valid_568891 = validateParameter(valid_568891, JString, required = true,
                                 default = nil)
  if valid_568891 != nil:
    section.add "resourceGroupName", valid_568891
  var valid_568892 = path.getOrDefault("subscriptionId")
  valid_568892 = validateParameter(valid_568892, JString, required = true,
                                 default = nil)
  if valid_568892 != nil:
    section.add "subscriptionId", valid_568892
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568893 = query.getOrDefault("api-version")
  valid_568893 = validateParameter(valid_568893, JString, required = true,
                                 default = nil)
  if valid_568893 != nil:
    section.add "api-version", valid_568893
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

proc call*(call_568895: Call_VirtualMachineScaleSetsRestart_568887; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts one or more virtual machines in a VM scale set.
  ## 
  let valid = call_568895.validator(path, query, header, formData, body)
  let scheme = call_568895.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568895.url(scheme.get, call_568895.host, call_568895.base,
                         call_568895.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568895, url, valid)

proc call*(call_568896: Call_VirtualMachineScaleSetsRestart_568887;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsRestart
  ## Restarts one or more virtual machines in a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_568897 = newJObject()
  var query_568898 = newJObject()
  var body_568899 = newJObject()
  add(path_568897, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568897, "resourceGroupName", newJString(resourceGroupName))
  add(query_568898, "api-version", newJString(apiVersion))
  add(path_568897, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568899 = vmInstanceIDs
  result = call_568896.call(path_568897, query_568898, nil, nil, body_568899)

var virtualMachineScaleSetsRestart* = Call_VirtualMachineScaleSetsRestart_568887(
    name: "virtualMachineScaleSetsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/restart",
    validator: validate_VirtualMachineScaleSetsRestart_568888, base: "",
    url: url_VirtualMachineScaleSetsRestart_568889, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesCancel_568900 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetRollingUpgradesCancel_568902(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetRollingUpgradesCancel_568901(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the current virtual machine scale set rolling upgrade.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568903 = path.getOrDefault("vmScaleSetName")
  valid_568903 = validateParameter(valid_568903, JString, required = true,
                                 default = nil)
  if valid_568903 != nil:
    section.add "vmScaleSetName", valid_568903
  var valid_568904 = path.getOrDefault("resourceGroupName")
  valid_568904 = validateParameter(valid_568904, JString, required = true,
                                 default = nil)
  if valid_568904 != nil:
    section.add "resourceGroupName", valid_568904
  var valid_568905 = path.getOrDefault("subscriptionId")
  valid_568905 = validateParameter(valid_568905, JString, required = true,
                                 default = nil)
  if valid_568905 != nil:
    section.add "subscriptionId", valid_568905
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568906 = query.getOrDefault("api-version")
  valid_568906 = validateParameter(valid_568906, JString, required = true,
                                 default = nil)
  if valid_568906 != nil:
    section.add "api-version", valid_568906
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568907: Call_VirtualMachineScaleSetRollingUpgradesCancel_568900;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the current virtual machine scale set rolling upgrade.
  ## 
  let valid = call_568907.validator(path, query, header, formData, body)
  let scheme = call_568907.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568907.url(scheme.get, call_568907.host, call_568907.base,
                         call_568907.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568907, url, valid)

proc call*(call_568908: Call_VirtualMachineScaleSetRollingUpgradesCancel_568900;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineScaleSetRollingUpgradesCancel
  ## Cancels the current virtual machine scale set rolling upgrade.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568909 = newJObject()
  var query_568910 = newJObject()
  add(path_568909, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568909, "resourceGroupName", newJString(resourceGroupName))
  add(query_568910, "api-version", newJString(apiVersion))
  add(path_568909, "subscriptionId", newJString(subscriptionId))
  result = call_568908.call(path_568909, query_568910, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesCancel* = Call_VirtualMachineScaleSetRollingUpgradesCancel_568900(
    name: "virtualMachineScaleSetRollingUpgradesCancel",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/rollingUpgrades/cancel",
    validator: validate_VirtualMachineScaleSetRollingUpgradesCancel_568901,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesCancel_568902,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesGetLatest_568911 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetRollingUpgradesGetLatest_568913(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetRollingUpgradesGetLatest_568912(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the status of the latest virtual machine scale set rolling upgrade.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568914 = path.getOrDefault("vmScaleSetName")
  valid_568914 = validateParameter(valid_568914, JString, required = true,
                                 default = nil)
  if valid_568914 != nil:
    section.add "vmScaleSetName", valid_568914
  var valid_568915 = path.getOrDefault("resourceGroupName")
  valid_568915 = validateParameter(valid_568915, JString, required = true,
                                 default = nil)
  if valid_568915 != nil:
    section.add "resourceGroupName", valid_568915
  var valid_568916 = path.getOrDefault("subscriptionId")
  valid_568916 = validateParameter(valid_568916, JString, required = true,
                                 default = nil)
  if valid_568916 != nil:
    section.add "subscriptionId", valid_568916
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568917 = query.getOrDefault("api-version")
  valid_568917 = validateParameter(valid_568917, JString, required = true,
                                 default = nil)
  if valid_568917 != nil:
    section.add "api-version", valid_568917
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568918: Call_VirtualMachineScaleSetRollingUpgradesGetLatest_568911;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of the latest virtual machine scale set rolling upgrade.
  ## 
  let valid = call_568918.validator(path, query, header, formData, body)
  let scheme = call_568918.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568918.url(scheme.get, call_568918.host, call_568918.base,
                         call_568918.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568918, url, valid)

proc call*(call_568919: Call_VirtualMachineScaleSetRollingUpgradesGetLatest_568911;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineScaleSetRollingUpgradesGetLatest
  ## Gets the status of the latest virtual machine scale set rolling upgrade.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568920 = newJObject()
  var query_568921 = newJObject()
  add(path_568920, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568920, "resourceGroupName", newJString(resourceGroupName))
  add(query_568921, "api-version", newJString(apiVersion))
  add(path_568920, "subscriptionId", newJString(subscriptionId))
  result = call_568919.call(path_568920, query_568921, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesGetLatest* = Call_VirtualMachineScaleSetRollingUpgradesGetLatest_568911(
    name: "virtualMachineScaleSetRollingUpgradesGetLatest",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/rollingUpgrades/latest",
    validator: validate_VirtualMachineScaleSetRollingUpgradesGetLatest_568912,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesGetLatest_568913,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsListSkus_568922 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsListSkus_568924(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsListSkus_568923(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of SKUs available for your VM scale set, including the minimum and maximum VM instances allowed for each SKU.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568925 = path.getOrDefault("vmScaleSetName")
  valid_568925 = validateParameter(valid_568925, JString, required = true,
                                 default = nil)
  if valid_568925 != nil:
    section.add "vmScaleSetName", valid_568925
  var valid_568926 = path.getOrDefault("resourceGroupName")
  valid_568926 = validateParameter(valid_568926, JString, required = true,
                                 default = nil)
  if valid_568926 != nil:
    section.add "resourceGroupName", valid_568926
  var valid_568927 = path.getOrDefault("subscriptionId")
  valid_568927 = validateParameter(valid_568927, JString, required = true,
                                 default = nil)
  if valid_568927 != nil:
    section.add "subscriptionId", valid_568927
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568928 = query.getOrDefault("api-version")
  valid_568928 = validateParameter(valid_568928, JString, required = true,
                                 default = nil)
  if valid_568928 != nil:
    section.add "api-version", valid_568928
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568929: Call_VirtualMachineScaleSetsListSkus_568922;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of SKUs available for your VM scale set, including the minimum and maximum VM instances allowed for each SKU.
  ## 
  let valid = call_568929.validator(path, query, header, formData, body)
  let scheme = call_568929.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568929.url(scheme.get, call_568929.host, call_568929.base,
                         call_568929.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568929, url, valid)

proc call*(call_568930: Call_VirtualMachineScaleSetsListSkus_568922;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsListSkus
  ## Gets a list of SKUs available for your VM scale set, including the minimum and maximum VM instances allowed for each SKU.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568931 = newJObject()
  var query_568932 = newJObject()
  add(path_568931, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568931, "resourceGroupName", newJString(resourceGroupName))
  add(query_568932, "api-version", newJString(apiVersion))
  add(path_568931, "subscriptionId", newJString(subscriptionId))
  result = call_568930.call(path_568931, query_568932, nil, nil, nil)

var virtualMachineScaleSetsListSkus* = Call_VirtualMachineScaleSetsListSkus_568922(
    name: "virtualMachineScaleSetsListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/skus",
    validator: validate_VirtualMachineScaleSetsListSkus_568923, base: "",
    url: url_VirtualMachineScaleSetsListSkus_568924, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsStart_568933 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsStart_568935(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsStart_568934(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts one or more virtual machines in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568936 = path.getOrDefault("vmScaleSetName")
  valid_568936 = validateParameter(valid_568936, JString, required = true,
                                 default = nil)
  if valid_568936 != nil:
    section.add "vmScaleSetName", valid_568936
  var valid_568937 = path.getOrDefault("resourceGroupName")
  valid_568937 = validateParameter(valid_568937, JString, required = true,
                                 default = nil)
  if valid_568937 != nil:
    section.add "resourceGroupName", valid_568937
  var valid_568938 = path.getOrDefault("subscriptionId")
  valid_568938 = validateParameter(valid_568938, JString, required = true,
                                 default = nil)
  if valid_568938 != nil:
    section.add "subscriptionId", valid_568938
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568939 = query.getOrDefault("api-version")
  valid_568939 = validateParameter(valid_568939, JString, required = true,
                                 default = nil)
  if valid_568939 != nil:
    section.add "api-version", valid_568939
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

proc call*(call_568941: Call_VirtualMachineScaleSetsStart_568933; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts one or more virtual machines in a VM scale set.
  ## 
  let valid = call_568941.validator(path, query, header, formData, body)
  let scheme = call_568941.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568941.url(scheme.get, call_568941.host, call_568941.base,
                         call_568941.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568941, url, valid)

proc call*(call_568942: Call_VirtualMachineScaleSetsStart_568933;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsStart
  ## Starts one or more virtual machines in a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_568943 = newJObject()
  var query_568944 = newJObject()
  var body_568945 = newJObject()
  add(path_568943, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568943, "resourceGroupName", newJString(resourceGroupName))
  add(query_568944, "api-version", newJString(apiVersion))
  add(path_568943, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568945 = vmInstanceIDs
  result = call_568942.call(path_568943, query_568944, nil, nil, body_568945)

var virtualMachineScaleSetsStart* = Call_VirtualMachineScaleSetsStart_568933(
    name: "virtualMachineScaleSetsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/start",
    validator: validate_VirtualMachineScaleSetsStart_568934, base: "",
    url: url_VirtualMachineScaleSetsStart_568935, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsUpdate_568958 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsUpdate_568960(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsUpdate_568959(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a virtual machine of a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set where the extension should be create or updated.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568961 = path.getOrDefault("vmScaleSetName")
  valid_568961 = validateParameter(valid_568961, JString, required = true,
                                 default = nil)
  if valid_568961 != nil:
    section.add "vmScaleSetName", valid_568961
  var valid_568962 = path.getOrDefault("resourceGroupName")
  valid_568962 = validateParameter(valid_568962, JString, required = true,
                                 default = nil)
  if valid_568962 != nil:
    section.add "resourceGroupName", valid_568962
  var valid_568963 = path.getOrDefault("subscriptionId")
  valid_568963 = validateParameter(valid_568963, JString, required = true,
                                 default = nil)
  if valid_568963 != nil:
    section.add "subscriptionId", valid_568963
  var valid_568964 = path.getOrDefault("instanceId")
  valid_568964 = validateParameter(valid_568964, JString, required = true,
                                 default = nil)
  if valid_568964 != nil:
    section.add "instanceId", valid_568964
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568965 = query.getOrDefault("api-version")
  valid_568965 = validateParameter(valid_568965, JString, required = true,
                                 default = nil)
  if valid_568965 != nil:
    section.add "api-version", valid_568965
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

proc call*(call_568967: Call_VirtualMachineScaleSetVMsUpdate_568958;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a virtual machine of a VM scale set.
  ## 
  let valid = call_568967.validator(path, query, header, formData, body)
  let scheme = call_568967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568967.url(scheme.get, call_568967.host, call_568967.base,
                         call_568967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568967, url, valid)

proc call*(call_568968: Call_VirtualMachineScaleSetVMsUpdate_568958;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string; parameters: JsonNode): Recallable =
  ## virtualMachineScaleSetVMsUpdate
  ## Updates a virtual machine of a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set where the extension should be create or updated.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Virtual Machine Scale Sets VM operation.
  var path_568969 = newJObject()
  var query_568970 = newJObject()
  var body_568971 = newJObject()
  add(path_568969, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568969, "resourceGroupName", newJString(resourceGroupName))
  add(query_568970, "api-version", newJString(apiVersion))
  add(path_568969, "subscriptionId", newJString(subscriptionId))
  add(path_568969, "instanceId", newJString(instanceId))
  if parameters != nil:
    body_568971 = parameters
  result = call_568968.call(path_568969, query_568970, nil, nil, body_568971)

var virtualMachineScaleSetVMsUpdate* = Call_VirtualMachineScaleSetVMsUpdate_568958(
    name: "virtualMachineScaleSetVMsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsUpdate_568959, base: "",
    url: url_VirtualMachineScaleSetVMsUpdate_568960, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsGet_568946 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsGet_568948(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsGet_568947(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a virtual machine from a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568949 = path.getOrDefault("vmScaleSetName")
  valid_568949 = validateParameter(valid_568949, JString, required = true,
                                 default = nil)
  if valid_568949 != nil:
    section.add "vmScaleSetName", valid_568949
  var valid_568950 = path.getOrDefault("resourceGroupName")
  valid_568950 = validateParameter(valid_568950, JString, required = true,
                                 default = nil)
  if valid_568950 != nil:
    section.add "resourceGroupName", valid_568950
  var valid_568951 = path.getOrDefault("subscriptionId")
  valid_568951 = validateParameter(valid_568951, JString, required = true,
                                 default = nil)
  if valid_568951 != nil:
    section.add "subscriptionId", valid_568951
  var valid_568952 = path.getOrDefault("instanceId")
  valid_568952 = validateParameter(valid_568952, JString, required = true,
                                 default = nil)
  if valid_568952 != nil:
    section.add "instanceId", valid_568952
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568953 = query.getOrDefault("api-version")
  valid_568953 = validateParameter(valid_568953, JString, required = true,
                                 default = nil)
  if valid_568953 != nil:
    section.add "api-version", valid_568953
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568954: Call_VirtualMachineScaleSetVMsGet_568946; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a virtual machine from a VM scale set.
  ## 
  let valid = call_568954.validator(path, query, header, formData, body)
  let scheme = call_568954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568954.url(scheme.get, call_568954.host, call_568954.base,
                         call_568954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568954, url, valid)

proc call*(call_568955: Call_VirtualMachineScaleSetVMsGet_568946;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsGet
  ## Gets a virtual machine from a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_568956 = newJObject()
  var query_568957 = newJObject()
  add(path_568956, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568956, "resourceGroupName", newJString(resourceGroupName))
  add(query_568957, "api-version", newJString(apiVersion))
  add(path_568956, "subscriptionId", newJString(subscriptionId))
  add(path_568956, "instanceId", newJString(instanceId))
  result = call_568955.call(path_568956, query_568957, nil, nil, nil)

var virtualMachineScaleSetVMsGet* = Call_VirtualMachineScaleSetVMsGet_568946(
    name: "virtualMachineScaleSetVMsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsGet_568947, base: "",
    url: url_VirtualMachineScaleSetVMsGet_568948, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsDelete_568972 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsDelete_568974(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsDelete_568973(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a virtual machine from a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568975 = path.getOrDefault("vmScaleSetName")
  valid_568975 = validateParameter(valid_568975, JString, required = true,
                                 default = nil)
  if valid_568975 != nil:
    section.add "vmScaleSetName", valid_568975
  var valid_568976 = path.getOrDefault("resourceGroupName")
  valid_568976 = validateParameter(valid_568976, JString, required = true,
                                 default = nil)
  if valid_568976 != nil:
    section.add "resourceGroupName", valid_568976
  var valid_568977 = path.getOrDefault("subscriptionId")
  valid_568977 = validateParameter(valid_568977, JString, required = true,
                                 default = nil)
  if valid_568977 != nil:
    section.add "subscriptionId", valid_568977
  var valid_568978 = path.getOrDefault("instanceId")
  valid_568978 = validateParameter(valid_568978, JString, required = true,
                                 default = nil)
  if valid_568978 != nil:
    section.add "instanceId", valid_568978
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568979 = query.getOrDefault("api-version")
  valid_568979 = validateParameter(valid_568979, JString, required = true,
                                 default = nil)
  if valid_568979 != nil:
    section.add "api-version", valid_568979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568980: Call_VirtualMachineScaleSetVMsDelete_568972;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a virtual machine from a VM scale set.
  ## 
  let valid = call_568980.validator(path, query, header, formData, body)
  let scheme = call_568980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568980.url(scheme.get, call_568980.host, call_568980.base,
                         call_568980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568980, url, valid)

proc call*(call_568981: Call_VirtualMachineScaleSetVMsDelete_568972;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsDelete
  ## Deletes a virtual machine from a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_568982 = newJObject()
  var query_568983 = newJObject()
  add(path_568982, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568982, "resourceGroupName", newJString(resourceGroupName))
  add(query_568983, "api-version", newJString(apiVersion))
  add(path_568982, "subscriptionId", newJString(subscriptionId))
  add(path_568982, "instanceId", newJString(instanceId))
  result = call_568981.call(path_568982, query_568983, nil, nil, nil)

var virtualMachineScaleSetVMsDelete* = Call_VirtualMachineScaleSetVMsDelete_568972(
    name: "virtualMachineScaleSetVMsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsDelete_568973, base: "",
    url: url_VirtualMachineScaleSetVMsDelete_568974, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsDeallocate_568984 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsDeallocate_568986(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsDeallocate_568985(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deallocates a specific virtual machine in a VM scale set. Shuts down the virtual machine and releases the compute resources it uses. You are not billed for the compute resources of this virtual machine once it is deallocated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568987 = path.getOrDefault("vmScaleSetName")
  valid_568987 = validateParameter(valid_568987, JString, required = true,
                                 default = nil)
  if valid_568987 != nil:
    section.add "vmScaleSetName", valid_568987
  var valid_568988 = path.getOrDefault("resourceGroupName")
  valid_568988 = validateParameter(valid_568988, JString, required = true,
                                 default = nil)
  if valid_568988 != nil:
    section.add "resourceGroupName", valid_568988
  var valid_568989 = path.getOrDefault("subscriptionId")
  valid_568989 = validateParameter(valid_568989, JString, required = true,
                                 default = nil)
  if valid_568989 != nil:
    section.add "subscriptionId", valid_568989
  var valid_568990 = path.getOrDefault("instanceId")
  valid_568990 = validateParameter(valid_568990, JString, required = true,
                                 default = nil)
  if valid_568990 != nil:
    section.add "instanceId", valid_568990
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568991 = query.getOrDefault("api-version")
  valid_568991 = validateParameter(valid_568991, JString, required = true,
                                 default = nil)
  if valid_568991 != nil:
    section.add "api-version", valid_568991
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568992: Call_VirtualMachineScaleSetVMsDeallocate_568984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deallocates a specific virtual machine in a VM scale set. Shuts down the virtual machine and releases the compute resources it uses. You are not billed for the compute resources of this virtual machine once it is deallocated.
  ## 
  let valid = call_568992.validator(path, query, header, formData, body)
  let scheme = call_568992.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568992.url(scheme.get, call_568992.host, call_568992.base,
                         call_568992.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568992, url, valid)

proc call*(call_568993: Call_VirtualMachineScaleSetVMsDeallocate_568984;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsDeallocate
  ## Deallocates a specific virtual machine in a VM scale set. Shuts down the virtual machine and releases the compute resources it uses. You are not billed for the compute resources of this virtual machine once it is deallocated.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_568994 = newJObject()
  var query_568995 = newJObject()
  add(path_568994, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568994, "resourceGroupName", newJString(resourceGroupName))
  add(query_568995, "api-version", newJString(apiVersion))
  add(path_568994, "subscriptionId", newJString(subscriptionId))
  add(path_568994, "instanceId", newJString(instanceId))
  result = call_568993.call(path_568994, query_568995, nil, nil, nil)

var virtualMachineScaleSetVMsDeallocate* = Call_VirtualMachineScaleSetVMsDeallocate_568984(
    name: "virtualMachineScaleSetVMsDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/deallocate",
    validator: validate_VirtualMachineScaleSetVMsDeallocate_568985, base: "",
    url: url_VirtualMachineScaleSetVMsDeallocate_568986, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsGetInstanceView_568996 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsGetInstanceView_568998(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetVMsGetInstanceView_568997(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status of a virtual machine from a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568999 = path.getOrDefault("vmScaleSetName")
  valid_568999 = validateParameter(valid_568999, JString, required = true,
                                 default = nil)
  if valid_568999 != nil:
    section.add "vmScaleSetName", valid_568999
  var valid_569000 = path.getOrDefault("resourceGroupName")
  valid_569000 = validateParameter(valid_569000, JString, required = true,
                                 default = nil)
  if valid_569000 != nil:
    section.add "resourceGroupName", valid_569000
  var valid_569001 = path.getOrDefault("subscriptionId")
  valid_569001 = validateParameter(valid_569001, JString, required = true,
                                 default = nil)
  if valid_569001 != nil:
    section.add "subscriptionId", valid_569001
  var valid_569002 = path.getOrDefault("instanceId")
  valid_569002 = validateParameter(valid_569002, JString, required = true,
                                 default = nil)
  if valid_569002 != nil:
    section.add "instanceId", valid_569002
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569003 = query.getOrDefault("api-version")
  valid_569003 = validateParameter(valid_569003, JString, required = true,
                                 default = nil)
  if valid_569003 != nil:
    section.add "api-version", valid_569003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569004: Call_VirtualMachineScaleSetVMsGetInstanceView_568996;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of a virtual machine from a VM scale set.
  ## 
  let valid = call_569004.validator(path, query, header, formData, body)
  let scheme = call_569004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569004.url(scheme.get, call_569004.host, call_569004.base,
                         call_569004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569004, url, valid)

proc call*(call_569005: Call_VirtualMachineScaleSetVMsGetInstanceView_568996;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsGetInstanceView
  ## Gets the status of a virtual machine from a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_569006 = newJObject()
  var query_569007 = newJObject()
  add(path_569006, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569006, "resourceGroupName", newJString(resourceGroupName))
  add(query_569007, "api-version", newJString(apiVersion))
  add(path_569006, "subscriptionId", newJString(subscriptionId))
  add(path_569006, "instanceId", newJString(instanceId))
  result = call_569005.call(path_569006, query_569007, nil, nil, nil)

var virtualMachineScaleSetVMsGetInstanceView* = Call_VirtualMachineScaleSetVMsGetInstanceView_568996(
    name: "virtualMachineScaleSetVMsGetInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/instanceView",
    validator: validate_VirtualMachineScaleSetVMsGetInstanceView_568997, base: "",
    url: url_VirtualMachineScaleSetVMsGetInstanceView_568998,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsPerformMaintenance_569008 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsPerformMaintenance_569010(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetVMsPerformMaintenance_569009(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Performs maintenance on a virtual machine in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_569011 = path.getOrDefault("vmScaleSetName")
  valid_569011 = validateParameter(valid_569011, JString, required = true,
                                 default = nil)
  if valid_569011 != nil:
    section.add "vmScaleSetName", valid_569011
  var valid_569012 = path.getOrDefault("resourceGroupName")
  valid_569012 = validateParameter(valid_569012, JString, required = true,
                                 default = nil)
  if valid_569012 != nil:
    section.add "resourceGroupName", valid_569012
  var valid_569013 = path.getOrDefault("subscriptionId")
  valid_569013 = validateParameter(valid_569013, JString, required = true,
                                 default = nil)
  if valid_569013 != nil:
    section.add "subscriptionId", valid_569013
  var valid_569014 = path.getOrDefault("instanceId")
  valid_569014 = validateParameter(valid_569014, JString, required = true,
                                 default = nil)
  if valid_569014 != nil:
    section.add "instanceId", valid_569014
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569015 = query.getOrDefault("api-version")
  valid_569015 = validateParameter(valid_569015, JString, required = true,
                                 default = nil)
  if valid_569015 != nil:
    section.add "api-version", valid_569015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569016: Call_VirtualMachineScaleSetVMsPerformMaintenance_569008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Performs maintenance on a virtual machine in a VM scale set.
  ## 
  let valid = call_569016.validator(path, query, header, formData, body)
  let scheme = call_569016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569016.url(scheme.get, call_569016.host, call_569016.base,
                         call_569016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569016, url, valid)

proc call*(call_569017: Call_VirtualMachineScaleSetVMsPerformMaintenance_569008;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsPerformMaintenance
  ## Performs maintenance on a virtual machine in a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_569018 = newJObject()
  var query_569019 = newJObject()
  add(path_569018, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569018, "resourceGroupName", newJString(resourceGroupName))
  add(query_569019, "api-version", newJString(apiVersion))
  add(path_569018, "subscriptionId", newJString(subscriptionId))
  add(path_569018, "instanceId", newJString(instanceId))
  result = call_569017.call(path_569018, query_569019, nil, nil, nil)

var virtualMachineScaleSetVMsPerformMaintenance* = Call_VirtualMachineScaleSetVMsPerformMaintenance_569008(
    name: "virtualMachineScaleSetVMsPerformMaintenance",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/performMaintenance",
    validator: validate_VirtualMachineScaleSetVMsPerformMaintenance_569009,
    base: "", url: url_VirtualMachineScaleSetVMsPerformMaintenance_569010,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsPowerOff_569020 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsPowerOff_569022(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsPowerOff_569021(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Power off (stop) a virtual machine in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_569023 = path.getOrDefault("vmScaleSetName")
  valid_569023 = validateParameter(valid_569023, JString, required = true,
                                 default = nil)
  if valid_569023 != nil:
    section.add "vmScaleSetName", valid_569023
  var valid_569024 = path.getOrDefault("resourceGroupName")
  valid_569024 = validateParameter(valid_569024, JString, required = true,
                                 default = nil)
  if valid_569024 != nil:
    section.add "resourceGroupName", valid_569024
  var valid_569025 = path.getOrDefault("subscriptionId")
  valid_569025 = validateParameter(valid_569025, JString, required = true,
                                 default = nil)
  if valid_569025 != nil:
    section.add "subscriptionId", valid_569025
  var valid_569026 = path.getOrDefault("instanceId")
  valid_569026 = validateParameter(valid_569026, JString, required = true,
                                 default = nil)
  if valid_569026 != nil:
    section.add "instanceId", valid_569026
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569027 = query.getOrDefault("api-version")
  valid_569027 = validateParameter(valid_569027, JString, required = true,
                                 default = nil)
  if valid_569027 != nil:
    section.add "api-version", valid_569027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569028: Call_VirtualMachineScaleSetVMsPowerOff_569020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Power off (stop) a virtual machine in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  let valid = call_569028.validator(path, query, header, formData, body)
  let scheme = call_569028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569028.url(scheme.get, call_569028.host, call_569028.base,
                         call_569028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569028, url, valid)

proc call*(call_569029: Call_VirtualMachineScaleSetVMsPowerOff_569020;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsPowerOff
  ## Power off (stop) a virtual machine in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_569030 = newJObject()
  var query_569031 = newJObject()
  add(path_569030, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569030, "resourceGroupName", newJString(resourceGroupName))
  add(query_569031, "api-version", newJString(apiVersion))
  add(path_569030, "subscriptionId", newJString(subscriptionId))
  add(path_569030, "instanceId", newJString(instanceId))
  result = call_569029.call(path_569030, query_569031, nil, nil, nil)

var virtualMachineScaleSetVMsPowerOff* = Call_VirtualMachineScaleSetVMsPowerOff_569020(
    name: "virtualMachineScaleSetVMsPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/poweroff",
    validator: validate_VirtualMachineScaleSetVMsPowerOff_569021, base: "",
    url: url_VirtualMachineScaleSetVMsPowerOff_569022, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsRedeploy_569032 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsRedeploy_569034(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsRedeploy_569033(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shuts down the virtual machine in the virtual machine scale set, moves it to a new node, and powers it back on.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_569035 = path.getOrDefault("vmScaleSetName")
  valid_569035 = validateParameter(valid_569035, JString, required = true,
                                 default = nil)
  if valid_569035 != nil:
    section.add "vmScaleSetName", valid_569035
  var valid_569036 = path.getOrDefault("resourceGroupName")
  valid_569036 = validateParameter(valid_569036, JString, required = true,
                                 default = nil)
  if valid_569036 != nil:
    section.add "resourceGroupName", valid_569036
  var valid_569037 = path.getOrDefault("subscriptionId")
  valid_569037 = validateParameter(valid_569037, JString, required = true,
                                 default = nil)
  if valid_569037 != nil:
    section.add "subscriptionId", valid_569037
  var valid_569038 = path.getOrDefault("instanceId")
  valid_569038 = validateParameter(valid_569038, JString, required = true,
                                 default = nil)
  if valid_569038 != nil:
    section.add "instanceId", valid_569038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569039 = query.getOrDefault("api-version")
  valid_569039 = validateParameter(valid_569039, JString, required = true,
                                 default = nil)
  if valid_569039 != nil:
    section.add "api-version", valid_569039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569040: Call_VirtualMachineScaleSetVMsRedeploy_569032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Shuts down the virtual machine in the virtual machine scale set, moves it to a new node, and powers it back on.
  ## 
  let valid = call_569040.validator(path, query, header, formData, body)
  let scheme = call_569040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569040.url(scheme.get, call_569040.host, call_569040.base,
                         call_569040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569040, url, valid)

proc call*(call_569041: Call_VirtualMachineScaleSetVMsRedeploy_569032;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsRedeploy
  ## Shuts down the virtual machine in the virtual machine scale set, moves it to a new node, and powers it back on.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_569042 = newJObject()
  var query_569043 = newJObject()
  add(path_569042, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569042, "resourceGroupName", newJString(resourceGroupName))
  add(query_569043, "api-version", newJString(apiVersion))
  add(path_569042, "subscriptionId", newJString(subscriptionId))
  add(path_569042, "instanceId", newJString(instanceId))
  result = call_569041.call(path_569042, query_569043, nil, nil, nil)

var virtualMachineScaleSetVMsRedeploy* = Call_VirtualMachineScaleSetVMsRedeploy_569032(
    name: "virtualMachineScaleSetVMsRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/redeploy",
    validator: validate_VirtualMachineScaleSetVMsRedeploy_569033, base: "",
    url: url_VirtualMachineScaleSetVMsRedeploy_569034, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsReimage_569044 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsReimage_569046(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsReimage_569045(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reimages (upgrade the operating system) a specific virtual machine in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_569047 = path.getOrDefault("vmScaleSetName")
  valid_569047 = validateParameter(valid_569047, JString, required = true,
                                 default = nil)
  if valid_569047 != nil:
    section.add "vmScaleSetName", valid_569047
  var valid_569048 = path.getOrDefault("resourceGroupName")
  valid_569048 = validateParameter(valid_569048, JString, required = true,
                                 default = nil)
  if valid_569048 != nil:
    section.add "resourceGroupName", valid_569048
  var valid_569049 = path.getOrDefault("subscriptionId")
  valid_569049 = validateParameter(valid_569049, JString, required = true,
                                 default = nil)
  if valid_569049 != nil:
    section.add "subscriptionId", valid_569049
  var valid_569050 = path.getOrDefault("instanceId")
  valid_569050 = validateParameter(valid_569050, JString, required = true,
                                 default = nil)
  if valid_569050 != nil:
    section.add "instanceId", valid_569050
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569051 = query.getOrDefault("api-version")
  valid_569051 = validateParameter(valid_569051, JString, required = true,
                                 default = nil)
  if valid_569051 != nil:
    section.add "api-version", valid_569051
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

proc call*(call_569053: Call_VirtualMachineScaleSetVMsReimage_569044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reimages (upgrade the operating system) a specific virtual machine in a VM scale set.
  ## 
  let valid = call_569053.validator(path, query, header, formData, body)
  let scheme = call_569053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569053.url(scheme.get, call_569053.host, call_569053.base,
                         call_569053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569053, url, valid)

proc call*(call_569054: Call_VirtualMachineScaleSetVMsReimage_569044;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string;
          vmScaleSetVMReimageInput: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetVMsReimage
  ## Reimages (upgrade the operating system) a specific virtual machine in a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  ##   vmScaleSetVMReimageInput: JObject
  ##                           : Parameters for the Reimaging Virtual machine in ScaleSet.
  var path_569055 = newJObject()
  var query_569056 = newJObject()
  var body_569057 = newJObject()
  add(path_569055, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569055, "resourceGroupName", newJString(resourceGroupName))
  add(query_569056, "api-version", newJString(apiVersion))
  add(path_569055, "subscriptionId", newJString(subscriptionId))
  add(path_569055, "instanceId", newJString(instanceId))
  if vmScaleSetVMReimageInput != nil:
    body_569057 = vmScaleSetVMReimageInput
  result = call_569054.call(path_569055, query_569056, nil, nil, body_569057)

var virtualMachineScaleSetVMsReimage* = Call_VirtualMachineScaleSetVMsReimage_569044(
    name: "virtualMachineScaleSetVMsReimage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/reimage",
    validator: validate_VirtualMachineScaleSetVMsReimage_569045, base: "",
    url: url_VirtualMachineScaleSetVMsReimage_569046, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsReimageAll_569058 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsReimageAll_569060(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsReimageAll_569059(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Allows you to re-image all the disks ( including data disks ) in the a VM scale set instance. This operation is only supported for managed disks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_569061 = path.getOrDefault("vmScaleSetName")
  valid_569061 = validateParameter(valid_569061, JString, required = true,
                                 default = nil)
  if valid_569061 != nil:
    section.add "vmScaleSetName", valid_569061
  var valid_569062 = path.getOrDefault("resourceGroupName")
  valid_569062 = validateParameter(valid_569062, JString, required = true,
                                 default = nil)
  if valid_569062 != nil:
    section.add "resourceGroupName", valid_569062
  var valid_569063 = path.getOrDefault("subscriptionId")
  valid_569063 = validateParameter(valid_569063, JString, required = true,
                                 default = nil)
  if valid_569063 != nil:
    section.add "subscriptionId", valid_569063
  var valid_569064 = path.getOrDefault("instanceId")
  valid_569064 = validateParameter(valid_569064, JString, required = true,
                                 default = nil)
  if valid_569064 != nil:
    section.add "instanceId", valid_569064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569065 = query.getOrDefault("api-version")
  valid_569065 = validateParameter(valid_569065, JString, required = true,
                                 default = nil)
  if valid_569065 != nil:
    section.add "api-version", valid_569065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569066: Call_VirtualMachineScaleSetVMsReimageAll_569058;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Allows you to re-image all the disks ( including data disks ) in the a VM scale set instance. This operation is only supported for managed disks.
  ## 
  let valid = call_569066.validator(path, query, header, formData, body)
  let scheme = call_569066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569066.url(scheme.get, call_569066.host, call_569066.base,
                         call_569066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569066, url, valid)

proc call*(call_569067: Call_VirtualMachineScaleSetVMsReimageAll_569058;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsReimageAll
  ## Allows you to re-image all the disks ( including data disks ) in the a VM scale set instance. This operation is only supported for managed disks.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_569068 = newJObject()
  var query_569069 = newJObject()
  add(path_569068, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569068, "resourceGroupName", newJString(resourceGroupName))
  add(query_569069, "api-version", newJString(apiVersion))
  add(path_569068, "subscriptionId", newJString(subscriptionId))
  add(path_569068, "instanceId", newJString(instanceId))
  result = call_569067.call(path_569068, query_569069, nil, nil, nil)

var virtualMachineScaleSetVMsReimageAll* = Call_VirtualMachineScaleSetVMsReimageAll_569058(
    name: "virtualMachineScaleSetVMsReimageAll", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/reimageall",
    validator: validate_VirtualMachineScaleSetVMsReimageAll_569059, base: "",
    url: url_VirtualMachineScaleSetVMsReimageAll_569060, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsRestart_569070 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsRestart_569072(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsRestart_569071(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restarts a virtual machine in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_569073 = path.getOrDefault("vmScaleSetName")
  valid_569073 = validateParameter(valid_569073, JString, required = true,
                                 default = nil)
  if valid_569073 != nil:
    section.add "vmScaleSetName", valid_569073
  var valid_569074 = path.getOrDefault("resourceGroupName")
  valid_569074 = validateParameter(valid_569074, JString, required = true,
                                 default = nil)
  if valid_569074 != nil:
    section.add "resourceGroupName", valid_569074
  var valid_569075 = path.getOrDefault("subscriptionId")
  valid_569075 = validateParameter(valid_569075, JString, required = true,
                                 default = nil)
  if valid_569075 != nil:
    section.add "subscriptionId", valid_569075
  var valid_569076 = path.getOrDefault("instanceId")
  valid_569076 = validateParameter(valid_569076, JString, required = true,
                                 default = nil)
  if valid_569076 != nil:
    section.add "instanceId", valid_569076
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569077 = query.getOrDefault("api-version")
  valid_569077 = validateParameter(valid_569077, JString, required = true,
                                 default = nil)
  if valid_569077 != nil:
    section.add "api-version", valid_569077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569078: Call_VirtualMachineScaleSetVMsRestart_569070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Restarts a virtual machine in a VM scale set.
  ## 
  let valid = call_569078.validator(path, query, header, formData, body)
  let scheme = call_569078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569078.url(scheme.get, call_569078.host, call_569078.base,
                         call_569078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569078, url, valid)

proc call*(call_569079: Call_VirtualMachineScaleSetVMsRestart_569070;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsRestart
  ## Restarts a virtual machine in a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_569080 = newJObject()
  var query_569081 = newJObject()
  add(path_569080, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569080, "resourceGroupName", newJString(resourceGroupName))
  add(query_569081, "api-version", newJString(apiVersion))
  add(path_569080, "subscriptionId", newJString(subscriptionId))
  add(path_569080, "instanceId", newJString(instanceId))
  result = call_569079.call(path_569080, query_569081, nil, nil, nil)

var virtualMachineScaleSetVMsRestart* = Call_VirtualMachineScaleSetVMsRestart_569070(
    name: "virtualMachineScaleSetVMsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/restart",
    validator: validate_VirtualMachineScaleSetVMsRestart_569071, base: "",
    url: url_VirtualMachineScaleSetVMsRestart_569072, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsStart_569082 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsStart_569084(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsStart_569083(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a virtual machine in a VM scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: JString (required)
  ##             : The instance ID of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_569085 = path.getOrDefault("vmScaleSetName")
  valid_569085 = validateParameter(valid_569085, JString, required = true,
                                 default = nil)
  if valid_569085 != nil:
    section.add "vmScaleSetName", valid_569085
  var valid_569086 = path.getOrDefault("resourceGroupName")
  valid_569086 = validateParameter(valid_569086, JString, required = true,
                                 default = nil)
  if valid_569086 != nil:
    section.add "resourceGroupName", valid_569086
  var valid_569087 = path.getOrDefault("subscriptionId")
  valid_569087 = validateParameter(valid_569087, JString, required = true,
                                 default = nil)
  if valid_569087 != nil:
    section.add "subscriptionId", valid_569087
  var valid_569088 = path.getOrDefault("instanceId")
  valid_569088 = validateParameter(valid_569088, JString, required = true,
                                 default = nil)
  if valid_569088 != nil:
    section.add "instanceId", valid_569088
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569089 = query.getOrDefault("api-version")
  valid_569089 = validateParameter(valid_569089, JString, required = true,
                                 default = nil)
  if valid_569089 != nil:
    section.add "api-version", valid_569089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569090: Call_VirtualMachineScaleSetVMsStart_569082; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a virtual machine in a VM scale set.
  ## 
  let valid = call_569090.validator(path, query, header, formData, body)
  let scheme = call_569090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569090.url(scheme.get, call_569090.host, call_569090.base,
                         call_569090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569090, url, valid)

proc call*(call_569091: Call_VirtualMachineScaleSetVMsStart_569082;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsStart
  ## Starts a virtual machine in a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_569092 = newJObject()
  var query_569093 = newJObject()
  add(path_569092, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569092, "resourceGroupName", newJString(resourceGroupName))
  add(query_569093, "api-version", newJString(apiVersion))
  add(path_569092, "subscriptionId", newJString(subscriptionId))
  add(path_569092, "instanceId", newJString(instanceId))
  result = call_569091.call(path_569092, query_569093, nil, nil, nil)

var virtualMachineScaleSetVMsStart* = Call_VirtualMachineScaleSetVMsStart_569082(
    name: "virtualMachineScaleSetVMsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/start",
    validator: validate_VirtualMachineScaleSetVMsStart_569083, base: "",
    url: url_VirtualMachineScaleSetVMsStart_569084, schemes: {Scheme.Https})
type
  Call_VirtualMachinesList_569094 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesList_569096(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesList_569095(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Lists all of the virtual machines in the specified resource group. Use the nextLink property in the response to get the next page of virtual machines.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569097 = path.getOrDefault("resourceGroupName")
  valid_569097 = validateParameter(valid_569097, JString, required = true,
                                 default = nil)
  if valid_569097 != nil:
    section.add "resourceGroupName", valid_569097
  var valid_569098 = path.getOrDefault("subscriptionId")
  valid_569098 = validateParameter(valid_569098, JString, required = true,
                                 default = nil)
  if valid_569098 != nil:
    section.add "subscriptionId", valid_569098
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569099 = query.getOrDefault("api-version")
  valid_569099 = validateParameter(valid_569099, JString, required = true,
                                 default = nil)
  if valid_569099 != nil:
    section.add "api-version", valid_569099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569100: Call_VirtualMachinesList_569094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the virtual machines in the specified resource group. Use the nextLink property in the response to get the next page of virtual machines.
  ## 
  let valid = call_569100.validator(path, query, header, formData, body)
  let scheme = call_569100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569100.url(scheme.get, call_569100.host, call_569100.base,
                         call_569100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569100, url, valid)

proc call*(call_569101: Call_VirtualMachinesList_569094; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachinesList
  ## Lists all of the virtual machines in the specified resource group. Use the nextLink property in the response to get the next page of virtual machines.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_569102 = newJObject()
  var query_569103 = newJObject()
  add(path_569102, "resourceGroupName", newJString(resourceGroupName))
  add(query_569103, "api-version", newJString(apiVersion))
  add(path_569102, "subscriptionId", newJString(subscriptionId))
  result = call_569101.call(path_569102, query_569103, nil, nil, nil)

var virtualMachinesList* = Call_VirtualMachinesList_569094(
    name: "virtualMachinesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines",
    validator: validate_VirtualMachinesList_569095, base: "",
    url: url_VirtualMachinesList_569096, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCreateOrUpdate_569129 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesCreateOrUpdate_569131(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesCreateOrUpdate_569130(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569132 = path.getOrDefault("resourceGroupName")
  valid_569132 = validateParameter(valid_569132, JString, required = true,
                                 default = nil)
  if valid_569132 != nil:
    section.add "resourceGroupName", valid_569132
  var valid_569133 = path.getOrDefault("subscriptionId")
  valid_569133 = validateParameter(valid_569133, JString, required = true,
                                 default = nil)
  if valid_569133 != nil:
    section.add "subscriptionId", valid_569133
  var valid_569134 = path.getOrDefault("vmName")
  valid_569134 = validateParameter(valid_569134, JString, required = true,
                                 default = nil)
  if valid_569134 != nil:
    section.add "vmName", valid_569134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569135 = query.getOrDefault("api-version")
  valid_569135 = validateParameter(valid_569135, JString, required = true,
                                 default = nil)
  if valid_569135 != nil:
    section.add "api-version", valid_569135
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

proc call*(call_569137: Call_VirtualMachinesCreateOrUpdate_569129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a virtual machine.
  ## 
  let valid = call_569137.validator(path, query, header, formData, body)
  let scheme = call_569137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569137.url(scheme.get, call_569137.host, call_569137.base,
                         call_569137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569137, url, valid)

proc call*(call_569138: Call_VirtualMachinesCreateOrUpdate_569129;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string; parameters: JsonNode): Recallable =
  ## virtualMachinesCreateOrUpdate
  ## The operation to create or update a virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Virtual Machine operation.
  var path_569139 = newJObject()
  var query_569140 = newJObject()
  var body_569141 = newJObject()
  add(path_569139, "resourceGroupName", newJString(resourceGroupName))
  add(query_569140, "api-version", newJString(apiVersion))
  add(path_569139, "subscriptionId", newJString(subscriptionId))
  add(path_569139, "vmName", newJString(vmName))
  if parameters != nil:
    body_569141 = parameters
  result = call_569138.call(path_569139, query_569140, nil, nil, body_569141)

var virtualMachinesCreateOrUpdate* = Call_VirtualMachinesCreateOrUpdate_569129(
    name: "virtualMachinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesCreateOrUpdate_569130, base: "",
    url: url_VirtualMachinesCreateOrUpdate_569131, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGet_569104 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesGet_569106(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesGet_569105(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves information about the model view or the instance view of a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569107 = path.getOrDefault("resourceGroupName")
  valid_569107 = validateParameter(valid_569107, JString, required = true,
                                 default = nil)
  if valid_569107 != nil:
    section.add "resourceGroupName", valid_569107
  var valid_569108 = path.getOrDefault("subscriptionId")
  valid_569108 = validateParameter(valid_569108, JString, required = true,
                                 default = nil)
  if valid_569108 != nil:
    section.add "subscriptionId", valid_569108
  var valid_569109 = path.getOrDefault("vmName")
  valid_569109 = validateParameter(valid_569109, JString, required = true,
                                 default = nil)
  if valid_569109 != nil:
    section.add "vmName", valid_569109
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_569123 = query.getOrDefault("$expand")
  valid_569123 = validateParameter(valid_569123, JString, required = false,
                                 default = newJString("instanceView"))
  if valid_569123 != nil:
    section.add "$expand", valid_569123
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569124 = query.getOrDefault("api-version")
  valid_569124 = validateParameter(valid_569124, JString, required = true,
                                 default = nil)
  if valid_569124 != nil:
    section.add "api-version", valid_569124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569125: Call_VirtualMachinesGet_569104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the model view or the instance view of a virtual machine.
  ## 
  let valid = call_569125.validator(path, query, header, formData, body)
  let scheme = call_569125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569125.url(scheme.get, call_569125.host, call_569125.base,
                         call_569125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569125, url, valid)

proc call*(call_569126: Call_VirtualMachinesGet_569104; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; vmName: string;
          Expand: string = "instanceView"): Recallable =
  ## virtualMachinesGet
  ## Retrieves information about the model view or the instance view of a virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569127 = newJObject()
  var query_569128 = newJObject()
  add(path_569127, "resourceGroupName", newJString(resourceGroupName))
  add(query_569128, "$expand", newJString(Expand))
  add(query_569128, "api-version", newJString(apiVersion))
  add(path_569127, "subscriptionId", newJString(subscriptionId))
  add(path_569127, "vmName", newJString(vmName))
  result = call_569126.call(path_569127, query_569128, nil, nil, nil)

var virtualMachinesGet* = Call_VirtualMachinesGet_569104(
    name: "virtualMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesGet_569105, base: "",
    url: url_VirtualMachinesGet_569106, schemes: {Scheme.Https})
type
  Call_VirtualMachinesUpdate_569153 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesUpdate_569155(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesUpdate_569154(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569156 = path.getOrDefault("resourceGroupName")
  valid_569156 = validateParameter(valid_569156, JString, required = true,
                                 default = nil)
  if valid_569156 != nil:
    section.add "resourceGroupName", valid_569156
  var valid_569157 = path.getOrDefault("subscriptionId")
  valid_569157 = validateParameter(valid_569157, JString, required = true,
                                 default = nil)
  if valid_569157 != nil:
    section.add "subscriptionId", valid_569157
  var valid_569158 = path.getOrDefault("vmName")
  valid_569158 = validateParameter(valid_569158, JString, required = true,
                                 default = nil)
  if valid_569158 != nil:
    section.add "vmName", valid_569158
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569159 = query.getOrDefault("api-version")
  valid_569159 = validateParameter(valid_569159, JString, required = true,
                                 default = nil)
  if valid_569159 != nil:
    section.add "api-version", valid_569159
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

proc call*(call_569161: Call_VirtualMachinesUpdate_569153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a virtual machine.
  ## 
  let valid = call_569161.validator(path, query, header, formData, body)
  let scheme = call_569161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569161.url(scheme.get, call_569161.host, call_569161.base,
                         call_569161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569161, url, valid)

proc call*(call_569162: Call_VirtualMachinesUpdate_569153;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string; parameters: JsonNode): Recallable =
  ## virtualMachinesUpdate
  ## The operation to update a virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Virtual Machine operation.
  var path_569163 = newJObject()
  var query_569164 = newJObject()
  var body_569165 = newJObject()
  add(path_569163, "resourceGroupName", newJString(resourceGroupName))
  add(query_569164, "api-version", newJString(apiVersion))
  add(path_569163, "subscriptionId", newJString(subscriptionId))
  add(path_569163, "vmName", newJString(vmName))
  if parameters != nil:
    body_569165 = parameters
  result = call_569162.call(path_569163, query_569164, nil, nil, body_569165)

var virtualMachinesUpdate* = Call_VirtualMachinesUpdate_569153(
    name: "virtualMachinesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesUpdate_569154, base: "",
    url: url_VirtualMachinesUpdate_569155, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDelete_569142 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesDelete_569144(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesDelete_569143(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569145 = path.getOrDefault("resourceGroupName")
  valid_569145 = validateParameter(valid_569145, JString, required = true,
                                 default = nil)
  if valid_569145 != nil:
    section.add "resourceGroupName", valid_569145
  var valid_569146 = path.getOrDefault("subscriptionId")
  valid_569146 = validateParameter(valid_569146, JString, required = true,
                                 default = nil)
  if valid_569146 != nil:
    section.add "subscriptionId", valid_569146
  var valid_569147 = path.getOrDefault("vmName")
  valid_569147 = validateParameter(valid_569147, JString, required = true,
                                 default = nil)
  if valid_569147 != nil:
    section.add "vmName", valid_569147
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569148 = query.getOrDefault("api-version")
  valid_569148 = validateParameter(valid_569148, JString, required = true,
                                 default = nil)
  if valid_569148 != nil:
    section.add "api-version", valid_569148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569149: Call_VirtualMachinesDelete_569142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a virtual machine.
  ## 
  let valid = call_569149.validator(path, query, header, formData, body)
  let scheme = call_569149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569149.url(scheme.get, call_569149.host, call_569149.base,
                         call_569149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569149, url, valid)

proc call*(call_569150: Call_VirtualMachinesDelete_569142;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesDelete
  ## The operation to delete a virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569151 = newJObject()
  var query_569152 = newJObject()
  add(path_569151, "resourceGroupName", newJString(resourceGroupName))
  add(query_569152, "api-version", newJString(apiVersion))
  add(path_569151, "subscriptionId", newJString(subscriptionId))
  add(path_569151, "vmName", newJString(vmName))
  result = call_569150.call(path_569151, query_569152, nil, nil, nil)

var virtualMachinesDelete* = Call_VirtualMachinesDelete_569142(
    name: "virtualMachinesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesDelete_569143, base: "",
    url: url_VirtualMachinesDelete_569144, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCapture_569166 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesCapture_569168(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesCapture_569167(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Captures the VM by copying virtual hard disks of the VM and outputs a template that can be used to create similar VMs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569169 = path.getOrDefault("resourceGroupName")
  valid_569169 = validateParameter(valid_569169, JString, required = true,
                                 default = nil)
  if valid_569169 != nil:
    section.add "resourceGroupName", valid_569169
  var valid_569170 = path.getOrDefault("subscriptionId")
  valid_569170 = validateParameter(valid_569170, JString, required = true,
                                 default = nil)
  if valid_569170 != nil:
    section.add "subscriptionId", valid_569170
  var valid_569171 = path.getOrDefault("vmName")
  valid_569171 = validateParameter(valid_569171, JString, required = true,
                                 default = nil)
  if valid_569171 != nil:
    section.add "vmName", valid_569171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569172 = query.getOrDefault("api-version")
  valid_569172 = validateParameter(valid_569172, JString, required = true,
                                 default = nil)
  if valid_569172 != nil:
    section.add "api-version", valid_569172
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

proc call*(call_569174: Call_VirtualMachinesCapture_569166; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Captures the VM by copying virtual hard disks of the VM and outputs a template that can be used to create similar VMs.
  ## 
  let valid = call_569174.validator(path, query, header, formData, body)
  let scheme = call_569174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569174.url(scheme.get, call_569174.host, call_569174.base,
                         call_569174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569174, url, valid)

proc call*(call_569175: Call_VirtualMachinesCapture_569166;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string; parameters: JsonNode): Recallable =
  ## virtualMachinesCapture
  ## Captures the VM by copying virtual hard disks of the VM and outputs a template that can be used to create similar VMs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Capture Virtual Machine operation.
  var path_569176 = newJObject()
  var query_569177 = newJObject()
  var body_569178 = newJObject()
  add(path_569176, "resourceGroupName", newJString(resourceGroupName))
  add(query_569177, "api-version", newJString(apiVersion))
  add(path_569176, "subscriptionId", newJString(subscriptionId))
  add(path_569176, "vmName", newJString(vmName))
  if parameters != nil:
    body_569178 = parameters
  result = call_569175.call(path_569176, query_569177, nil, nil, body_569178)

var virtualMachinesCapture* = Call_VirtualMachinesCapture_569166(
    name: "virtualMachinesCapture", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/capture",
    validator: validate_VirtualMachinesCapture_569167, base: "",
    url: url_VirtualMachinesCapture_569168, schemes: {Scheme.Https})
type
  Call_VirtualMachinesConvertToManagedDisks_569179 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesConvertToManagedDisks_569181(protocol: Scheme;
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

proc validate_VirtualMachinesConvertToManagedDisks_569180(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Converts virtual machine disks from blob-based to managed disks. Virtual machine must be stop-deallocated before invoking this operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569182 = path.getOrDefault("resourceGroupName")
  valid_569182 = validateParameter(valid_569182, JString, required = true,
                                 default = nil)
  if valid_569182 != nil:
    section.add "resourceGroupName", valid_569182
  var valid_569183 = path.getOrDefault("subscriptionId")
  valid_569183 = validateParameter(valid_569183, JString, required = true,
                                 default = nil)
  if valid_569183 != nil:
    section.add "subscriptionId", valid_569183
  var valid_569184 = path.getOrDefault("vmName")
  valid_569184 = validateParameter(valid_569184, JString, required = true,
                                 default = nil)
  if valid_569184 != nil:
    section.add "vmName", valid_569184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569185 = query.getOrDefault("api-version")
  valid_569185 = validateParameter(valid_569185, JString, required = true,
                                 default = nil)
  if valid_569185 != nil:
    section.add "api-version", valid_569185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569186: Call_VirtualMachinesConvertToManagedDisks_569179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Converts virtual machine disks from blob-based to managed disks. Virtual machine must be stop-deallocated before invoking this operation.
  ## 
  let valid = call_569186.validator(path, query, header, formData, body)
  let scheme = call_569186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569186.url(scheme.get, call_569186.host, call_569186.base,
                         call_569186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569186, url, valid)

proc call*(call_569187: Call_VirtualMachinesConvertToManagedDisks_569179;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesConvertToManagedDisks
  ## Converts virtual machine disks from blob-based to managed disks. Virtual machine must be stop-deallocated before invoking this operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569188 = newJObject()
  var query_569189 = newJObject()
  add(path_569188, "resourceGroupName", newJString(resourceGroupName))
  add(query_569189, "api-version", newJString(apiVersion))
  add(path_569188, "subscriptionId", newJString(subscriptionId))
  add(path_569188, "vmName", newJString(vmName))
  result = call_569187.call(path_569188, query_569189, nil, nil, nil)

var virtualMachinesConvertToManagedDisks* = Call_VirtualMachinesConvertToManagedDisks_569179(
    name: "virtualMachinesConvertToManagedDisks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/convertToManagedDisks",
    validator: validate_VirtualMachinesConvertToManagedDisks_569180, base: "",
    url: url_VirtualMachinesConvertToManagedDisks_569181, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDeallocate_569190 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesDeallocate_569192(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesDeallocate_569191(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shuts down the virtual machine and releases the compute resources. You are not billed for the compute resources that this virtual machine uses.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569193 = path.getOrDefault("resourceGroupName")
  valid_569193 = validateParameter(valid_569193, JString, required = true,
                                 default = nil)
  if valid_569193 != nil:
    section.add "resourceGroupName", valid_569193
  var valid_569194 = path.getOrDefault("subscriptionId")
  valid_569194 = validateParameter(valid_569194, JString, required = true,
                                 default = nil)
  if valid_569194 != nil:
    section.add "subscriptionId", valid_569194
  var valid_569195 = path.getOrDefault("vmName")
  valid_569195 = validateParameter(valid_569195, JString, required = true,
                                 default = nil)
  if valid_569195 != nil:
    section.add "vmName", valid_569195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569196 = query.getOrDefault("api-version")
  valid_569196 = validateParameter(valid_569196, JString, required = true,
                                 default = nil)
  if valid_569196 != nil:
    section.add "api-version", valid_569196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569197: Call_VirtualMachinesDeallocate_569190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shuts down the virtual machine and releases the compute resources. You are not billed for the compute resources that this virtual machine uses.
  ## 
  let valid = call_569197.validator(path, query, header, formData, body)
  let scheme = call_569197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569197.url(scheme.get, call_569197.host, call_569197.base,
                         call_569197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569197, url, valid)

proc call*(call_569198: Call_VirtualMachinesDeallocate_569190;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesDeallocate
  ## Shuts down the virtual machine and releases the compute resources. You are not billed for the compute resources that this virtual machine uses.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569199 = newJObject()
  var query_569200 = newJObject()
  add(path_569199, "resourceGroupName", newJString(resourceGroupName))
  add(query_569200, "api-version", newJString(apiVersion))
  add(path_569199, "subscriptionId", newJString(subscriptionId))
  add(path_569199, "vmName", newJString(vmName))
  result = call_569198.call(path_569199, query_569200, nil, nil, nil)

var virtualMachinesDeallocate* = Call_VirtualMachinesDeallocate_569190(
    name: "virtualMachinesDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/deallocate",
    validator: validate_VirtualMachinesDeallocate_569191, base: "",
    url: url_VirtualMachinesDeallocate_569192, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsList_569201 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionsList_569203(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionsList_569202(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to get all extensions of a Virtual Machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine containing the extension.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569204 = path.getOrDefault("resourceGroupName")
  valid_569204 = validateParameter(valid_569204, JString, required = true,
                                 default = nil)
  if valid_569204 != nil:
    section.add "resourceGroupName", valid_569204
  var valid_569205 = path.getOrDefault("subscriptionId")
  valid_569205 = validateParameter(valid_569205, JString, required = true,
                                 default = nil)
  if valid_569205 != nil:
    section.add "subscriptionId", valid_569205
  var valid_569206 = path.getOrDefault("vmName")
  valid_569206 = validateParameter(valid_569206, JString, required = true,
                                 default = nil)
  if valid_569206 != nil:
    section.add "vmName", valid_569206
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_569207 = query.getOrDefault("$expand")
  valid_569207 = validateParameter(valid_569207, JString, required = false,
                                 default = nil)
  if valid_569207 != nil:
    section.add "$expand", valid_569207
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569208 = query.getOrDefault("api-version")
  valid_569208 = validateParameter(valid_569208, JString, required = true,
                                 default = nil)
  if valid_569208 != nil:
    section.add "api-version", valid_569208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569209: Call_VirtualMachineExtensionsList_569201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get all extensions of a Virtual Machine.
  ## 
  let valid = call_569209.validator(path, query, header, formData, body)
  let scheme = call_569209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569209.url(scheme.get, call_569209.host, call_569209.base,
                         call_569209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569209, url, valid)

proc call*(call_569210: Call_VirtualMachineExtensionsList_569201;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string; Expand: string = ""): Recallable =
  ## virtualMachineExtensionsList
  ## The operation to get all extensions of a Virtual Machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine containing the extension.
  var path_569211 = newJObject()
  var query_569212 = newJObject()
  add(path_569211, "resourceGroupName", newJString(resourceGroupName))
  add(query_569212, "$expand", newJString(Expand))
  add(query_569212, "api-version", newJString(apiVersion))
  add(path_569211, "subscriptionId", newJString(subscriptionId))
  add(path_569211, "vmName", newJString(vmName))
  result = call_569210.call(path_569211, query_569212, nil, nil, nil)

var virtualMachineExtensionsList* = Call_VirtualMachineExtensionsList_569201(
    name: "virtualMachineExtensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions",
    validator: validate_VirtualMachineExtensionsList_569202, base: "",
    url: url_VirtualMachineExtensionsList_569203, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsCreateOrUpdate_569226 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionsCreateOrUpdate_569228(protocol: Scheme;
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

proc validate_VirtualMachineExtensionsCreateOrUpdate_569227(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to create or update the extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmExtensionName: JString (required)
  ##                  : The name of the virtual machine extension.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine where the extension should be created or updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569229 = path.getOrDefault("resourceGroupName")
  valid_569229 = validateParameter(valid_569229, JString, required = true,
                                 default = nil)
  if valid_569229 != nil:
    section.add "resourceGroupName", valid_569229
  var valid_569230 = path.getOrDefault("vmExtensionName")
  valid_569230 = validateParameter(valid_569230, JString, required = true,
                                 default = nil)
  if valid_569230 != nil:
    section.add "vmExtensionName", valid_569230
  var valid_569231 = path.getOrDefault("subscriptionId")
  valid_569231 = validateParameter(valid_569231, JString, required = true,
                                 default = nil)
  if valid_569231 != nil:
    section.add "subscriptionId", valid_569231
  var valid_569232 = path.getOrDefault("vmName")
  valid_569232 = validateParameter(valid_569232, JString, required = true,
                                 default = nil)
  if valid_569232 != nil:
    section.add "vmName", valid_569232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569233 = query.getOrDefault("api-version")
  valid_569233 = validateParameter(valid_569233, JString, required = true,
                                 default = nil)
  if valid_569233 != nil:
    section.add "api-version", valid_569233
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

proc call*(call_569235: Call_VirtualMachineExtensionsCreateOrUpdate_569226;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update the extension.
  ## 
  let valid = call_569235.validator(path, query, header, formData, body)
  let scheme = call_569235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569235.url(scheme.get, call_569235.host, call_569235.base,
                         call_569235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569235, url, valid)

proc call*(call_569236: Call_VirtualMachineExtensionsCreateOrUpdate_569226;
          extensionParameters: JsonNode; resourceGroupName: string;
          apiVersion: string; vmExtensionName: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachineExtensionsCreateOrUpdate
  ## The operation to create or update the extension.
  ##   extensionParameters: JObject (required)
  ##                      : Parameters supplied to the Create Virtual Machine Extension operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmExtensionName: string (required)
  ##                  : The name of the virtual machine extension.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine where the extension should be created or updated.
  var path_569237 = newJObject()
  var query_569238 = newJObject()
  var body_569239 = newJObject()
  if extensionParameters != nil:
    body_569239 = extensionParameters
  add(path_569237, "resourceGroupName", newJString(resourceGroupName))
  add(query_569238, "api-version", newJString(apiVersion))
  add(path_569237, "vmExtensionName", newJString(vmExtensionName))
  add(path_569237, "subscriptionId", newJString(subscriptionId))
  add(path_569237, "vmName", newJString(vmName))
  result = call_569236.call(path_569237, query_569238, nil, nil, body_569239)

var virtualMachineExtensionsCreateOrUpdate* = Call_VirtualMachineExtensionsCreateOrUpdate_569226(
    name: "virtualMachineExtensionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsCreateOrUpdate_569227, base: "",
    url: url_VirtualMachineExtensionsCreateOrUpdate_569228,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsGet_569213 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionsGet_569215(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionsGet_569214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to get the extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmExtensionName: JString (required)
  ##                  : The name of the virtual machine extension.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine containing the extension.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569216 = path.getOrDefault("resourceGroupName")
  valid_569216 = validateParameter(valid_569216, JString, required = true,
                                 default = nil)
  if valid_569216 != nil:
    section.add "resourceGroupName", valid_569216
  var valid_569217 = path.getOrDefault("vmExtensionName")
  valid_569217 = validateParameter(valid_569217, JString, required = true,
                                 default = nil)
  if valid_569217 != nil:
    section.add "vmExtensionName", valid_569217
  var valid_569218 = path.getOrDefault("subscriptionId")
  valid_569218 = validateParameter(valid_569218, JString, required = true,
                                 default = nil)
  if valid_569218 != nil:
    section.add "subscriptionId", valid_569218
  var valid_569219 = path.getOrDefault("vmName")
  valid_569219 = validateParameter(valid_569219, JString, required = true,
                                 default = nil)
  if valid_569219 != nil:
    section.add "vmName", valid_569219
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_569220 = query.getOrDefault("$expand")
  valid_569220 = validateParameter(valid_569220, JString, required = false,
                                 default = nil)
  if valid_569220 != nil:
    section.add "$expand", valid_569220
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569221 = query.getOrDefault("api-version")
  valid_569221 = validateParameter(valid_569221, JString, required = true,
                                 default = nil)
  if valid_569221 != nil:
    section.add "api-version", valid_569221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569222: Call_VirtualMachineExtensionsGet_569213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get the extension.
  ## 
  let valid = call_569222.validator(path, query, header, formData, body)
  let scheme = call_569222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569222.url(scheme.get, call_569222.host, call_569222.base,
                         call_569222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569222, url, valid)

proc call*(call_569223: Call_VirtualMachineExtensionsGet_569213;
          resourceGroupName: string; apiVersion: string; vmExtensionName: string;
          subscriptionId: string; vmName: string; Expand: string = ""): Recallable =
  ## virtualMachineExtensionsGet
  ## The operation to get the extension.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmExtensionName: string (required)
  ##                  : The name of the virtual machine extension.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine containing the extension.
  var path_569224 = newJObject()
  var query_569225 = newJObject()
  add(path_569224, "resourceGroupName", newJString(resourceGroupName))
  add(query_569225, "$expand", newJString(Expand))
  add(query_569225, "api-version", newJString(apiVersion))
  add(path_569224, "vmExtensionName", newJString(vmExtensionName))
  add(path_569224, "subscriptionId", newJString(subscriptionId))
  add(path_569224, "vmName", newJString(vmName))
  result = call_569223.call(path_569224, query_569225, nil, nil, nil)

var virtualMachineExtensionsGet* = Call_VirtualMachineExtensionsGet_569213(
    name: "virtualMachineExtensionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsGet_569214, base: "",
    url: url_VirtualMachineExtensionsGet_569215, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsUpdate_569252 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionsUpdate_569254(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionsUpdate_569253(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to update the extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmExtensionName: JString (required)
  ##                  : The name of the virtual machine extension.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine where the extension should be updated.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569255 = path.getOrDefault("resourceGroupName")
  valid_569255 = validateParameter(valid_569255, JString, required = true,
                                 default = nil)
  if valid_569255 != nil:
    section.add "resourceGroupName", valid_569255
  var valid_569256 = path.getOrDefault("vmExtensionName")
  valid_569256 = validateParameter(valid_569256, JString, required = true,
                                 default = nil)
  if valid_569256 != nil:
    section.add "vmExtensionName", valid_569256
  var valid_569257 = path.getOrDefault("subscriptionId")
  valid_569257 = validateParameter(valid_569257, JString, required = true,
                                 default = nil)
  if valid_569257 != nil:
    section.add "subscriptionId", valid_569257
  var valid_569258 = path.getOrDefault("vmName")
  valid_569258 = validateParameter(valid_569258, JString, required = true,
                                 default = nil)
  if valid_569258 != nil:
    section.add "vmName", valid_569258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569259 = query.getOrDefault("api-version")
  valid_569259 = validateParameter(valid_569259, JString, required = true,
                                 default = nil)
  if valid_569259 != nil:
    section.add "api-version", valid_569259
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

proc call*(call_569261: Call_VirtualMachineExtensionsUpdate_569252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update the extension.
  ## 
  let valid = call_569261.validator(path, query, header, formData, body)
  let scheme = call_569261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569261.url(scheme.get, call_569261.host, call_569261.base,
                         call_569261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569261, url, valid)

proc call*(call_569262: Call_VirtualMachineExtensionsUpdate_569252;
          extensionParameters: JsonNode; resourceGroupName: string;
          apiVersion: string; vmExtensionName: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachineExtensionsUpdate
  ## The operation to update the extension.
  ##   extensionParameters: JObject (required)
  ##                      : Parameters supplied to the Update Virtual Machine Extension operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmExtensionName: string (required)
  ##                  : The name of the virtual machine extension.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine where the extension should be updated.
  var path_569263 = newJObject()
  var query_569264 = newJObject()
  var body_569265 = newJObject()
  if extensionParameters != nil:
    body_569265 = extensionParameters
  add(path_569263, "resourceGroupName", newJString(resourceGroupName))
  add(query_569264, "api-version", newJString(apiVersion))
  add(path_569263, "vmExtensionName", newJString(vmExtensionName))
  add(path_569263, "subscriptionId", newJString(subscriptionId))
  add(path_569263, "vmName", newJString(vmName))
  result = call_569262.call(path_569263, query_569264, nil, nil, body_569265)

var virtualMachineExtensionsUpdate* = Call_VirtualMachineExtensionsUpdate_569252(
    name: "virtualMachineExtensionsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsUpdate_569253, base: "",
    url: url_VirtualMachineExtensionsUpdate_569254, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsDelete_569240 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionsDelete_569242(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionsDelete_569241(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to delete the extension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   vmExtensionName: JString (required)
  ##                  : The name of the virtual machine extension.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine where the extension should be deleted.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569243 = path.getOrDefault("resourceGroupName")
  valid_569243 = validateParameter(valid_569243, JString, required = true,
                                 default = nil)
  if valid_569243 != nil:
    section.add "resourceGroupName", valid_569243
  var valid_569244 = path.getOrDefault("vmExtensionName")
  valid_569244 = validateParameter(valid_569244, JString, required = true,
                                 default = nil)
  if valid_569244 != nil:
    section.add "vmExtensionName", valid_569244
  var valid_569245 = path.getOrDefault("subscriptionId")
  valid_569245 = validateParameter(valid_569245, JString, required = true,
                                 default = nil)
  if valid_569245 != nil:
    section.add "subscriptionId", valid_569245
  var valid_569246 = path.getOrDefault("vmName")
  valid_569246 = validateParameter(valid_569246, JString, required = true,
                                 default = nil)
  if valid_569246 != nil:
    section.add "vmName", valid_569246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569247 = query.getOrDefault("api-version")
  valid_569247 = validateParameter(valid_569247, JString, required = true,
                                 default = nil)
  if valid_569247 != nil:
    section.add "api-version", valid_569247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569248: Call_VirtualMachineExtensionsDelete_569240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete the extension.
  ## 
  let valid = call_569248.validator(path, query, header, formData, body)
  let scheme = call_569248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569248.url(scheme.get, call_569248.host, call_569248.base,
                         call_569248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569248, url, valid)

proc call*(call_569249: Call_VirtualMachineExtensionsDelete_569240;
          resourceGroupName: string; apiVersion: string; vmExtensionName: string;
          subscriptionId: string; vmName: string): Recallable =
  ## virtualMachineExtensionsDelete
  ## The operation to delete the extension.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   vmExtensionName: string (required)
  ##                  : The name of the virtual machine extension.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine where the extension should be deleted.
  var path_569250 = newJObject()
  var query_569251 = newJObject()
  add(path_569250, "resourceGroupName", newJString(resourceGroupName))
  add(query_569251, "api-version", newJString(apiVersion))
  add(path_569250, "vmExtensionName", newJString(vmExtensionName))
  add(path_569250, "subscriptionId", newJString(subscriptionId))
  add(path_569250, "vmName", newJString(vmName))
  result = call_569249.call(path_569250, query_569251, nil, nil, nil)

var virtualMachineExtensionsDelete* = Call_VirtualMachineExtensionsDelete_569240(
    name: "virtualMachineExtensionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsDelete_569241, base: "",
    url: url_VirtualMachineExtensionsDelete_569242, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGeneralize_569266 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesGeneralize_569268(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesGeneralize_569267(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the state of the virtual machine to generalized.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569269 = path.getOrDefault("resourceGroupName")
  valid_569269 = validateParameter(valid_569269, JString, required = true,
                                 default = nil)
  if valid_569269 != nil:
    section.add "resourceGroupName", valid_569269
  var valid_569270 = path.getOrDefault("subscriptionId")
  valid_569270 = validateParameter(valid_569270, JString, required = true,
                                 default = nil)
  if valid_569270 != nil:
    section.add "subscriptionId", valid_569270
  var valid_569271 = path.getOrDefault("vmName")
  valid_569271 = validateParameter(valid_569271, JString, required = true,
                                 default = nil)
  if valid_569271 != nil:
    section.add "vmName", valid_569271
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569272 = query.getOrDefault("api-version")
  valid_569272 = validateParameter(valid_569272, JString, required = true,
                                 default = nil)
  if valid_569272 != nil:
    section.add "api-version", valid_569272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569273: Call_VirtualMachinesGeneralize_569266; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the state of the virtual machine to generalized.
  ## 
  let valid = call_569273.validator(path, query, header, formData, body)
  let scheme = call_569273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569273.url(scheme.get, call_569273.host, call_569273.base,
                         call_569273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569273, url, valid)

proc call*(call_569274: Call_VirtualMachinesGeneralize_569266;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesGeneralize
  ## Sets the state of the virtual machine to generalized.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569275 = newJObject()
  var query_569276 = newJObject()
  add(path_569275, "resourceGroupName", newJString(resourceGroupName))
  add(query_569276, "api-version", newJString(apiVersion))
  add(path_569275, "subscriptionId", newJString(subscriptionId))
  add(path_569275, "vmName", newJString(vmName))
  result = call_569274.call(path_569275, query_569276, nil, nil, nil)

var virtualMachinesGeneralize* = Call_VirtualMachinesGeneralize_569266(
    name: "virtualMachinesGeneralize", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/generalize",
    validator: validate_VirtualMachinesGeneralize_569267, base: "",
    url: url_VirtualMachinesGeneralize_569268, schemes: {Scheme.Https})
type
  Call_VirtualMachinesInstanceView_569277 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesInstanceView_569279(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesInstanceView_569278(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves information about the run-time state of a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569280 = path.getOrDefault("resourceGroupName")
  valid_569280 = validateParameter(valid_569280, JString, required = true,
                                 default = nil)
  if valid_569280 != nil:
    section.add "resourceGroupName", valid_569280
  var valid_569281 = path.getOrDefault("subscriptionId")
  valid_569281 = validateParameter(valid_569281, JString, required = true,
                                 default = nil)
  if valid_569281 != nil:
    section.add "subscriptionId", valid_569281
  var valid_569282 = path.getOrDefault("vmName")
  valid_569282 = validateParameter(valid_569282, JString, required = true,
                                 default = nil)
  if valid_569282 != nil:
    section.add "vmName", valid_569282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569283 = query.getOrDefault("api-version")
  valid_569283 = validateParameter(valid_569283, JString, required = true,
                                 default = nil)
  if valid_569283 != nil:
    section.add "api-version", valid_569283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569284: Call_VirtualMachinesInstanceView_569277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the run-time state of a virtual machine.
  ## 
  let valid = call_569284.validator(path, query, header, formData, body)
  let scheme = call_569284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569284.url(scheme.get, call_569284.host, call_569284.base,
                         call_569284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569284, url, valid)

proc call*(call_569285: Call_VirtualMachinesInstanceView_569277;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesInstanceView
  ## Retrieves information about the run-time state of a virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569286 = newJObject()
  var query_569287 = newJObject()
  add(path_569286, "resourceGroupName", newJString(resourceGroupName))
  add(query_569287, "api-version", newJString(apiVersion))
  add(path_569286, "subscriptionId", newJString(subscriptionId))
  add(path_569286, "vmName", newJString(vmName))
  result = call_569285.call(path_569286, query_569287, nil, nil, nil)

var virtualMachinesInstanceView* = Call_VirtualMachinesInstanceView_569277(
    name: "virtualMachinesInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/instanceView",
    validator: validate_VirtualMachinesInstanceView_569278, base: "",
    url: url_VirtualMachinesInstanceView_569279, schemes: {Scheme.Https})
type
  Call_VirtualMachinesPerformMaintenance_569288 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesPerformMaintenance_569290(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesPerformMaintenance_569289(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to perform maintenance on a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569291 = path.getOrDefault("resourceGroupName")
  valid_569291 = validateParameter(valid_569291, JString, required = true,
                                 default = nil)
  if valid_569291 != nil:
    section.add "resourceGroupName", valid_569291
  var valid_569292 = path.getOrDefault("subscriptionId")
  valid_569292 = validateParameter(valid_569292, JString, required = true,
                                 default = nil)
  if valid_569292 != nil:
    section.add "subscriptionId", valid_569292
  var valid_569293 = path.getOrDefault("vmName")
  valid_569293 = validateParameter(valid_569293, JString, required = true,
                                 default = nil)
  if valid_569293 != nil:
    section.add "vmName", valid_569293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569294 = query.getOrDefault("api-version")
  valid_569294 = validateParameter(valid_569294, JString, required = true,
                                 default = nil)
  if valid_569294 != nil:
    section.add "api-version", valid_569294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569295: Call_VirtualMachinesPerformMaintenance_569288;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to perform maintenance on a virtual machine.
  ## 
  let valid = call_569295.validator(path, query, header, formData, body)
  let scheme = call_569295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569295.url(scheme.get, call_569295.host, call_569295.base,
                         call_569295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569295, url, valid)

proc call*(call_569296: Call_VirtualMachinesPerformMaintenance_569288;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesPerformMaintenance
  ## The operation to perform maintenance on a virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569297 = newJObject()
  var query_569298 = newJObject()
  add(path_569297, "resourceGroupName", newJString(resourceGroupName))
  add(query_569298, "api-version", newJString(apiVersion))
  add(path_569297, "subscriptionId", newJString(subscriptionId))
  add(path_569297, "vmName", newJString(vmName))
  result = call_569296.call(path_569297, query_569298, nil, nil, nil)

var virtualMachinesPerformMaintenance* = Call_VirtualMachinesPerformMaintenance_569288(
    name: "virtualMachinesPerformMaintenance", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/performMaintenance",
    validator: validate_VirtualMachinesPerformMaintenance_569289, base: "",
    url: url_VirtualMachinesPerformMaintenance_569290, schemes: {Scheme.Https})
type
  Call_VirtualMachinesPowerOff_569299 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesPowerOff_569301(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesPowerOff_569300(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to power off (stop) a virtual machine. The virtual machine can be restarted with the same provisioned resources. You are still charged for this virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569302 = path.getOrDefault("resourceGroupName")
  valid_569302 = validateParameter(valid_569302, JString, required = true,
                                 default = nil)
  if valid_569302 != nil:
    section.add "resourceGroupName", valid_569302
  var valid_569303 = path.getOrDefault("subscriptionId")
  valid_569303 = validateParameter(valid_569303, JString, required = true,
                                 default = nil)
  if valid_569303 != nil:
    section.add "subscriptionId", valid_569303
  var valid_569304 = path.getOrDefault("vmName")
  valid_569304 = validateParameter(valid_569304, JString, required = true,
                                 default = nil)
  if valid_569304 != nil:
    section.add "vmName", valid_569304
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569305 = query.getOrDefault("api-version")
  valid_569305 = validateParameter(valid_569305, JString, required = true,
                                 default = nil)
  if valid_569305 != nil:
    section.add "api-version", valid_569305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569306: Call_VirtualMachinesPowerOff_569299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to power off (stop) a virtual machine. The virtual machine can be restarted with the same provisioned resources. You are still charged for this virtual machine.
  ## 
  let valid = call_569306.validator(path, query, header, formData, body)
  let scheme = call_569306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569306.url(scheme.get, call_569306.host, call_569306.base,
                         call_569306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569306, url, valid)

proc call*(call_569307: Call_VirtualMachinesPowerOff_569299;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesPowerOff
  ## The operation to power off (stop) a virtual machine. The virtual machine can be restarted with the same provisioned resources. You are still charged for this virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569308 = newJObject()
  var query_569309 = newJObject()
  add(path_569308, "resourceGroupName", newJString(resourceGroupName))
  add(query_569309, "api-version", newJString(apiVersion))
  add(path_569308, "subscriptionId", newJString(subscriptionId))
  add(path_569308, "vmName", newJString(vmName))
  result = call_569307.call(path_569308, query_569309, nil, nil, nil)

var virtualMachinesPowerOff* = Call_VirtualMachinesPowerOff_569299(
    name: "virtualMachinesPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/powerOff",
    validator: validate_VirtualMachinesPowerOff_569300, base: "",
    url: url_VirtualMachinesPowerOff_569301, schemes: {Scheme.Https})
type
  Call_VirtualMachinesRedeploy_569310 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesRedeploy_569312(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesRedeploy_569311(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Shuts down the virtual machine, moves it to a new node, and powers it back on.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569313 = path.getOrDefault("resourceGroupName")
  valid_569313 = validateParameter(valid_569313, JString, required = true,
                                 default = nil)
  if valid_569313 != nil:
    section.add "resourceGroupName", valid_569313
  var valid_569314 = path.getOrDefault("subscriptionId")
  valid_569314 = validateParameter(valid_569314, JString, required = true,
                                 default = nil)
  if valid_569314 != nil:
    section.add "subscriptionId", valid_569314
  var valid_569315 = path.getOrDefault("vmName")
  valid_569315 = validateParameter(valid_569315, JString, required = true,
                                 default = nil)
  if valid_569315 != nil:
    section.add "vmName", valid_569315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569316 = query.getOrDefault("api-version")
  valid_569316 = validateParameter(valid_569316, JString, required = true,
                                 default = nil)
  if valid_569316 != nil:
    section.add "api-version", valid_569316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569317: Call_VirtualMachinesRedeploy_569310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shuts down the virtual machine, moves it to a new node, and powers it back on.
  ## 
  let valid = call_569317.validator(path, query, header, formData, body)
  let scheme = call_569317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569317.url(scheme.get, call_569317.host, call_569317.base,
                         call_569317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569317, url, valid)

proc call*(call_569318: Call_VirtualMachinesRedeploy_569310;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesRedeploy
  ## Shuts down the virtual machine, moves it to a new node, and powers it back on.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569319 = newJObject()
  var query_569320 = newJObject()
  add(path_569319, "resourceGroupName", newJString(resourceGroupName))
  add(query_569320, "api-version", newJString(apiVersion))
  add(path_569319, "subscriptionId", newJString(subscriptionId))
  add(path_569319, "vmName", newJString(vmName))
  result = call_569318.call(path_569319, query_569320, nil, nil, nil)

var virtualMachinesRedeploy* = Call_VirtualMachinesRedeploy_569310(
    name: "virtualMachinesRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/redeploy",
    validator: validate_VirtualMachinesRedeploy_569311, base: "",
    url: url_VirtualMachinesRedeploy_569312, schemes: {Scheme.Https})
type
  Call_VirtualMachinesReimage_569321 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesReimage_569323(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesReimage_569322(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reimages the virtual machine which has an ephemeral OS disk back to its initial state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569324 = path.getOrDefault("resourceGroupName")
  valid_569324 = validateParameter(valid_569324, JString, required = true,
                                 default = nil)
  if valid_569324 != nil:
    section.add "resourceGroupName", valid_569324
  var valid_569325 = path.getOrDefault("subscriptionId")
  valid_569325 = validateParameter(valid_569325, JString, required = true,
                                 default = nil)
  if valid_569325 != nil:
    section.add "subscriptionId", valid_569325
  var valid_569326 = path.getOrDefault("vmName")
  valid_569326 = validateParameter(valid_569326, JString, required = true,
                                 default = nil)
  if valid_569326 != nil:
    section.add "vmName", valid_569326
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569327 = query.getOrDefault("api-version")
  valid_569327 = validateParameter(valid_569327, JString, required = true,
                                 default = nil)
  if valid_569327 != nil:
    section.add "api-version", valid_569327
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

proc call*(call_569329: Call_VirtualMachinesReimage_569321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reimages the virtual machine which has an ephemeral OS disk back to its initial state.
  ## 
  let valid = call_569329.validator(path, query, header, formData, body)
  let scheme = call_569329.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569329.url(scheme.get, call_569329.host, call_569329.base,
                         call_569329.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569329, url, valid)

proc call*(call_569330: Call_VirtualMachinesReimage_569321;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string; parameters: JsonNode = nil): Recallable =
  ## virtualMachinesReimage
  ## Reimages the virtual machine which has an ephemeral OS disk back to its initial state.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  ##   parameters: JObject
  ##             : Parameters supplied to the Reimage Virtual Machine operation.
  var path_569331 = newJObject()
  var query_569332 = newJObject()
  var body_569333 = newJObject()
  add(path_569331, "resourceGroupName", newJString(resourceGroupName))
  add(query_569332, "api-version", newJString(apiVersion))
  add(path_569331, "subscriptionId", newJString(subscriptionId))
  add(path_569331, "vmName", newJString(vmName))
  if parameters != nil:
    body_569333 = parameters
  result = call_569330.call(path_569331, query_569332, nil, nil, body_569333)

var virtualMachinesReimage* = Call_VirtualMachinesReimage_569321(
    name: "virtualMachinesReimage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/reimage",
    validator: validate_VirtualMachinesReimage_569322, base: "",
    url: url_VirtualMachinesReimage_569323, schemes: {Scheme.Https})
type
  Call_VirtualMachinesRestart_569334 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesRestart_569336(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesRestart_569335(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to restart a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569337 = path.getOrDefault("resourceGroupName")
  valid_569337 = validateParameter(valid_569337, JString, required = true,
                                 default = nil)
  if valid_569337 != nil:
    section.add "resourceGroupName", valid_569337
  var valid_569338 = path.getOrDefault("subscriptionId")
  valid_569338 = validateParameter(valid_569338, JString, required = true,
                                 default = nil)
  if valid_569338 != nil:
    section.add "subscriptionId", valid_569338
  var valid_569339 = path.getOrDefault("vmName")
  valid_569339 = validateParameter(valid_569339, JString, required = true,
                                 default = nil)
  if valid_569339 != nil:
    section.add "vmName", valid_569339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569340 = query.getOrDefault("api-version")
  valid_569340 = validateParameter(valid_569340, JString, required = true,
                                 default = nil)
  if valid_569340 != nil:
    section.add "api-version", valid_569340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569341: Call_VirtualMachinesRestart_569334; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to restart a virtual machine.
  ## 
  let valid = call_569341.validator(path, query, header, formData, body)
  let scheme = call_569341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569341.url(scheme.get, call_569341.host, call_569341.base,
                         call_569341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569341, url, valid)

proc call*(call_569342: Call_VirtualMachinesRestart_569334;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesRestart
  ## The operation to restart a virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569343 = newJObject()
  var query_569344 = newJObject()
  add(path_569343, "resourceGroupName", newJString(resourceGroupName))
  add(query_569344, "api-version", newJString(apiVersion))
  add(path_569343, "subscriptionId", newJString(subscriptionId))
  add(path_569343, "vmName", newJString(vmName))
  result = call_569342.call(path_569343, query_569344, nil, nil, nil)

var virtualMachinesRestart* = Call_VirtualMachinesRestart_569334(
    name: "virtualMachinesRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/restart",
    validator: validate_VirtualMachinesRestart_569335, base: "",
    url: url_VirtualMachinesRestart_569336, schemes: {Scheme.Https})
type
  Call_VirtualMachinesStart_569345 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesStart_569347(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesStart_569346(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to start a virtual machine.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569348 = path.getOrDefault("resourceGroupName")
  valid_569348 = validateParameter(valid_569348, JString, required = true,
                                 default = nil)
  if valid_569348 != nil:
    section.add "resourceGroupName", valid_569348
  var valid_569349 = path.getOrDefault("subscriptionId")
  valid_569349 = validateParameter(valid_569349, JString, required = true,
                                 default = nil)
  if valid_569349 != nil:
    section.add "subscriptionId", valid_569349
  var valid_569350 = path.getOrDefault("vmName")
  valid_569350 = validateParameter(valid_569350, JString, required = true,
                                 default = nil)
  if valid_569350 != nil:
    section.add "vmName", valid_569350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569351 = query.getOrDefault("api-version")
  valid_569351 = validateParameter(valid_569351, JString, required = true,
                                 default = nil)
  if valid_569351 != nil:
    section.add "api-version", valid_569351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569352: Call_VirtualMachinesStart_569345; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to start a virtual machine.
  ## 
  let valid = call_569352.validator(path, query, header, formData, body)
  let scheme = call_569352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569352.url(scheme.get, call_569352.host, call_569352.base,
                         call_569352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569352, url, valid)

proc call*(call_569353: Call_VirtualMachinesStart_569345;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesStart
  ## The operation to start a virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569354 = newJObject()
  var query_569355 = newJObject()
  add(path_569354, "resourceGroupName", newJString(resourceGroupName))
  add(query_569355, "api-version", newJString(apiVersion))
  add(path_569354, "subscriptionId", newJString(subscriptionId))
  add(path_569354, "vmName", newJString(vmName))
  result = call_569353.call(path_569354, query_569355, nil, nil, nil)

var virtualMachinesStart* = Call_VirtualMachinesStart_569345(
    name: "virtualMachinesStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/start",
    validator: validate_VirtualMachinesStart_569346, base: "",
    url: url_VirtualMachinesStart_569347, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListAvailableSizes_569356 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesListAvailableSizes_569358(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesListAvailableSizes_569357(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all available virtual machine sizes to which the specified virtual machine can be resized.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: JString (required)
  ##         : The name of the virtual machine.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_569359 = path.getOrDefault("resourceGroupName")
  valid_569359 = validateParameter(valid_569359, JString, required = true,
                                 default = nil)
  if valid_569359 != nil:
    section.add "resourceGroupName", valid_569359
  var valid_569360 = path.getOrDefault("subscriptionId")
  valid_569360 = validateParameter(valid_569360, JString, required = true,
                                 default = nil)
  if valid_569360 != nil:
    section.add "subscriptionId", valid_569360
  var valid_569361 = path.getOrDefault("vmName")
  valid_569361 = validateParameter(valid_569361, JString, required = true,
                                 default = nil)
  if valid_569361 != nil:
    section.add "vmName", valid_569361
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569362 = query.getOrDefault("api-version")
  valid_569362 = validateParameter(valid_569362, JString, required = true,
                                 default = nil)
  if valid_569362 != nil:
    section.add "api-version", valid_569362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569363: Call_VirtualMachinesListAvailableSizes_569356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available virtual machine sizes to which the specified virtual machine can be resized.
  ## 
  let valid = call_569363.validator(path, query, header, formData, body)
  let scheme = call_569363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569363.url(scheme.get, call_569363.host, call_569363.base,
                         call_569363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569363, url, valid)

proc call*(call_569364: Call_VirtualMachinesListAvailableSizes_569356;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesListAvailableSizes
  ## Lists all available virtual machine sizes to which the specified virtual machine can be resized.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569365 = newJObject()
  var query_569366 = newJObject()
  add(path_569365, "resourceGroupName", newJString(resourceGroupName))
  add(query_569366, "api-version", newJString(apiVersion))
  add(path_569365, "subscriptionId", newJString(subscriptionId))
  add(path_569365, "vmName", newJString(vmName))
  result = call_569364.call(path_569365, query_569366, nil, nil, nil)

var virtualMachinesListAvailableSizes* = Call_VirtualMachinesListAvailableSizes_569356(
    name: "virtualMachinesListAvailableSizes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/vmSizes",
    validator: validate_VirtualMachinesListAvailableSizes_569357, base: "",
    url: url_VirtualMachinesListAvailableSizes_569358, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
