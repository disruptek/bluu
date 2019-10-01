
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ComputeManagementClient
## version: 2017-12-01
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
  ## Lists all available virtual machine sizes for a subscription in a location.
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
  ## Lists all available virtual machine sizes for a subscription in a location.
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
  Call_VirtualMachineScaleSetsListAll_568392 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsListAll_568394(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsListAll_568393(path: JsonNode;
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

proc call*(call_568397: Call_VirtualMachineScaleSetsListAll_568392; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all VM Scale Sets in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM Scale Sets.
  ## 
  let valid = call_568397.validator(path, query, header, formData, body)
  let scheme = call_568397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568397.url(scheme.get, call_568397.host, call_568397.base,
                         call_568397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568397, url, valid)

proc call*(call_568398: Call_VirtualMachineScaleSetsListAll_568392;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsListAll
  ## Gets a list of all VM Scale Sets in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM Scale Sets.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568399 = newJObject()
  var query_568400 = newJObject()
  add(query_568400, "api-version", newJString(apiVersion))
  add(path_568399, "subscriptionId", newJString(subscriptionId))
  result = call_568398.call(path_568399, query_568400, nil, nil, nil)

var virtualMachineScaleSetsListAll* = Call_VirtualMachineScaleSetsListAll_568392(
    name: "virtualMachineScaleSetsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachineScaleSets",
    validator: validate_VirtualMachineScaleSetsListAll_568393, base: "",
    url: url_VirtualMachineScaleSetsListAll_568394, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListAll_568401 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesListAll_568403(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesListAll_568402(path: JsonNode; query: JsonNode;
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

proc call*(call_568406: Call_VirtualMachinesListAll_568401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the virtual machines in the specified subscription. Use the nextLink property in the response to get the next page of virtual machines.
  ## 
  let valid = call_568406.validator(path, query, header, formData, body)
  let scheme = call_568406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568406.url(scheme.get, call_568406.host, call_568406.base,
                         call_568406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568406, url, valid)

proc call*(call_568407: Call_VirtualMachinesListAll_568401; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachinesListAll
  ## Lists all of the virtual machines in the specified subscription. Use the nextLink property in the response to get the next page of virtual machines.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568408 = newJObject()
  var query_568409 = newJObject()
  add(query_568409, "api-version", newJString(apiVersion))
  add(path_568408, "subscriptionId", newJString(subscriptionId))
  result = call_568407.call(path_568408, query_568409, nil, nil, nil)

var virtualMachinesListAll* = Call_VirtualMachinesListAll_568401(
    name: "virtualMachinesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachines",
    validator: validate_VirtualMachinesListAll_568402, base: "",
    url: url_VirtualMachinesListAll_568403, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsList_568410 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsList_568412(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsList_568411(path: JsonNode; query: JsonNode;
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
  var valid_568413 = path.getOrDefault("resourceGroupName")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "resourceGroupName", valid_568413
  var valid_568414 = path.getOrDefault("subscriptionId")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "subscriptionId", valid_568414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568415 = query.getOrDefault("api-version")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "api-version", valid_568415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568416: Call_AvailabilitySetsList_568410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all availability sets in a resource group.
  ## 
  let valid = call_568416.validator(path, query, header, formData, body)
  let scheme = call_568416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568416.url(scheme.get, call_568416.host, call_568416.base,
                         call_568416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568416, url, valid)

proc call*(call_568417: Call_AvailabilitySetsList_568410;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## availabilitySetsList
  ## Lists all availability sets in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568418 = newJObject()
  var query_568419 = newJObject()
  add(path_568418, "resourceGroupName", newJString(resourceGroupName))
  add(query_568419, "api-version", newJString(apiVersion))
  add(path_568418, "subscriptionId", newJString(subscriptionId))
  result = call_568417.call(path_568418, query_568419, nil, nil, nil)

var availabilitySetsList* = Call_AvailabilitySetsList_568410(
    name: "availabilitySetsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets",
    validator: validate_AvailabilitySetsList_568411, base: "",
    url: url_AvailabilitySetsList_568412, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsCreateOrUpdate_568431 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsCreateOrUpdate_568433(protocol: Scheme; host: string;
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

proc validate_AvailabilitySetsCreateOrUpdate_568432(path: JsonNode;
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
  var valid_568434 = path.getOrDefault("resourceGroupName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "resourceGroupName", valid_568434
  var valid_568435 = path.getOrDefault("subscriptionId")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "subscriptionId", valid_568435
  var valid_568436 = path.getOrDefault("availabilitySetName")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "availabilitySetName", valid_568436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568437 = query.getOrDefault("api-version")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "api-version", valid_568437
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

proc call*(call_568439: Call_AvailabilitySetsCreateOrUpdate_568431; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an availability set.
  ## 
  let valid = call_568439.validator(path, query, header, formData, body)
  let scheme = call_568439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568439.url(scheme.get, call_568439.host, call_568439.base,
                         call_568439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568439, url, valid)

proc call*(call_568440: Call_AvailabilitySetsCreateOrUpdate_568431;
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
  var path_568441 = newJObject()
  var query_568442 = newJObject()
  var body_568443 = newJObject()
  add(path_568441, "resourceGroupName", newJString(resourceGroupName))
  add(query_568442, "api-version", newJString(apiVersion))
  add(path_568441, "subscriptionId", newJString(subscriptionId))
  add(path_568441, "availabilitySetName", newJString(availabilitySetName))
  if parameters != nil:
    body_568443 = parameters
  result = call_568440.call(path_568441, query_568442, nil, nil, body_568443)

var availabilitySetsCreateOrUpdate* = Call_AvailabilitySetsCreateOrUpdate_568431(
    name: "availabilitySetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsCreateOrUpdate_568432, base: "",
    url: url_AvailabilitySetsCreateOrUpdate_568433, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsGet_568420 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsGet_568422(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsGet_568421(path: JsonNode; query: JsonNode;
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
  var valid_568423 = path.getOrDefault("resourceGroupName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "resourceGroupName", valid_568423
  var valid_568424 = path.getOrDefault("subscriptionId")
  valid_568424 = validateParameter(valid_568424, JString, required = true,
                                 default = nil)
  if valid_568424 != nil:
    section.add "subscriptionId", valid_568424
  var valid_568425 = path.getOrDefault("availabilitySetName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "availabilitySetName", valid_568425
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568426 = query.getOrDefault("api-version")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "api-version", valid_568426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568427: Call_AvailabilitySetsGet_568420; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about an availability set.
  ## 
  let valid = call_568427.validator(path, query, header, formData, body)
  let scheme = call_568427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568427.url(scheme.get, call_568427.host, call_568427.base,
                         call_568427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568427, url, valid)

proc call*(call_568428: Call_AvailabilitySetsGet_568420; resourceGroupName: string;
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
  var path_568429 = newJObject()
  var query_568430 = newJObject()
  add(path_568429, "resourceGroupName", newJString(resourceGroupName))
  add(query_568430, "api-version", newJString(apiVersion))
  add(path_568429, "subscriptionId", newJString(subscriptionId))
  add(path_568429, "availabilitySetName", newJString(availabilitySetName))
  result = call_568428.call(path_568429, query_568430, nil, nil, nil)

var availabilitySetsGet* = Call_AvailabilitySetsGet_568420(
    name: "availabilitySetsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsGet_568421, base: "",
    url: url_AvailabilitySetsGet_568422, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsUpdate_568455 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsUpdate_568457(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsUpdate_568456(path: JsonNode; query: JsonNode;
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
  var valid_568458 = path.getOrDefault("resourceGroupName")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "resourceGroupName", valid_568458
  var valid_568459 = path.getOrDefault("subscriptionId")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "subscriptionId", valid_568459
  var valid_568460 = path.getOrDefault("availabilitySetName")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "availabilitySetName", valid_568460
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568461 = query.getOrDefault("api-version")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "api-version", valid_568461
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

proc call*(call_568463: Call_AvailabilitySetsUpdate_568455; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an availability set.
  ## 
  let valid = call_568463.validator(path, query, header, formData, body)
  let scheme = call_568463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568463.url(scheme.get, call_568463.host, call_568463.base,
                         call_568463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568463, url, valid)

proc call*(call_568464: Call_AvailabilitySetsUpdate_568455;
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
  var path_568465 = newJObject()
  var query_568466 = newJObject()
  var body_568467 = newJObject()
  add(path_568465, "resourceGroupName", newJString(resourceGroupName))
  add(query_568466, "api-version", newJString(apiVersion))
  add(path_568465, "subscriptionId", newJString(subscriptionId))
  add(path_568465, "availabilitySetName", newJString(availabilitySetName))
  if parameters != nil:
    body_568467 = parameters
  result = call_568464.call(path_568465, query_568466, nil, nil, body_568467)

var availabilitySetsUpdate* = Call_AvailabilitySetsUpdate_568455(
    name: "availabilitySetsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsUpdate_568456, base: "",
    url: url_AvailabilitySetsUpdate_568457, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsDelete_568444 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsDelete_568446(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsDelete_568445(path: JsonNode; query: JsonNode;
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
  var valid_568447 = path.getOrDefault("resourceGroupName")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "resourceGroupName", valid_568447
  var valid_568448 = path.getOrDefault("subscriptionId")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "subscriptionId", valid_568448
  var valid_568449 = path.getOrDefault("availabilitySetName")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "availabilitySetName", valid_568449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568450 = query.getOrDefault("api-version")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "api-version", valid_568450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568451: Call_AvailabilitySetsDelete_568444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an availability set.
  ## 
  let valid = call_568451.validator(path, query, header, formData, body)
  let scheme = call_568451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568451.url(scheme.get, call_568451.host, call_568451.base,
                         call_568451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568451, url, valid)

proc call*(call_568452: Call_AvailabilitySetsDelete_568444;
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
  var path_568453 = newJObject()
  var query_568454 = newJObject()
  add(path_568453, "resourceGroupName", newJString(resourceGroupName))
  add(query_568454, "api-version", newJString(apiVersion))
  add(path_568453, "subscriptionId", newJString(subscriptionId))
  add(path_568453, "availabilitySetName", newJString(availabilitySetName))
  result = call_568452.call(path_568453, query_568454, nil, nil, nil)

var availabilitySetsDelete* = Call_AvailabilitySetsDelete_568444(
    name: "availabilitySetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsDelete_568445, base: "",
    url: url_AvailabilitySetsDelete_568446, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsListAvailableSizes_568468 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsListAvailableSizes_568470(protocol: Scheme; host: string;
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

proc validate_AvailabilitySetsListAvailableSizes_568469(path: JsonNode;
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
  var valid_568471 = path.getOrDefault("resourceGroupName")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "resourceGroupName", valid_568471
  var valid_568472 = path.getOrDefault("subscriptionId")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "subscriptionId", valid_568472
  var valid_568473 = path.getOrDefault("availabilitySetName")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "availabilitySetName", valid_568473
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568474 = query.getOrDefault("api-version")
  valid_568474 = validateParameter(valid_568474, JString, required = true,
                                 default = nil)
  if valid_568474 != nil:
    section.add "api-version", valid_568474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568475: Call_AvailabilitySetsListAvailableSizes_568468;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available virtual machine sizes that can be used to create a new virtual machine in an existing availability set.
  ## 
  let valid = call_568475.validator(path, query, header, formData, body)
  let scheme = call_568475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568475.url(scheme.get, call_568475.host, call_568475.base,
                         call_568475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568475, url, valid)

proc call*(call_568476: Call_AvailabilitySetsListAvailableSizes_568468;
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
  var path_568477 = newJObject()
  var query_568478 = newJObject()
  add(path_568477, "resourceGroupName", newJString(resourceGroupName))
  add(query_568478, "api-version", newJString(apiVersion))
  add(path_568477, "subscriptionId", newJString(subscriptionId))
  add(path_568477, "availabilitySetName", newJString(availabilitySetName))
  result = call_568476.call(path_568477, query_568478, nil, nil, nil)

var availabilitySetsListAvailableSizes* = Call_AvailabilitySetsListAvailableSizes_568468(
    name: "availabilitySetsListAvailableSizes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}/vmSizes",
    validator: validate_AvailabilitySetsListAvailableSizes_568469, base: "",
    url: url_AvailabilitySetsListAvailableSizes_568470, schemes: {Scheme.Https})
type
  Call_ImagesListByResourceGroup_568479 = ref object of OpenApiRestCall_567667
proc url_ImagesListByResourceGroup_568481(protocol: Scheme; host: string;
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

proc validate_ImagesListByResourceGroup_568480(path: JsonNode; query: JsonNode;
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
  var valid_568482 = path.getOrDefault("resourceGroupName")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "resourceGroupName", valid_568482
  var valid_568483 = path.getOrDefault("subscriptionId")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = nil)
  if valid_568483 != nil:
    section.add "subscriptionId", valid_568483
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568484 = query.getOrDefault("api-version")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "api-version", valid_568484
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568485: Call_ImagesListByResourceGroup_568479; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of images under a resource group.
  ## 
  let valid = call_568485.validator(path, query, header, formData, body)
  let scheme = call_568485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568485.url(scheme.get, call_568485.host, call_568485.base,
                         call_568485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568485, url, valid)

proc call*(call_568486: Call_ImagesListByResourceGroup_568479;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## imagesListByResourceGroup
  ## Gets the list of images under a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568487 = newJObject()
  var query_568488 = newJObject()
  add(path_568487, "resourceGroupName", newJString(resourceGroupName))
  add(query_568488, "api-version", newJString(apiVersion))
  add(path_568487, "subscriptionId", newJString(subscriptionId))
  result = call_568486.call(path_568487, query_568488, nil, nil, nil)

var imagesListByResourceGroup* = Call_ImagesListByResourceGroup_568479(
    name: "imagesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images",
    validator: validate_ImagesListByResourceGroup_568480, base: "",
    url: url_ImagesListByResourceGroup_568481, schemes: {Scheme.Https})
type
  Call_ImagesCreateOrUpdate_568501 = ref object of OpenApiRestCall_567667
proc url_ImagesCreateOrUpdate_568503(protocol: Scheme; host: string; base: string;
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

proc validate_ImagesCreateOrUpdate_568502(path: JsonNode; query: JsonNode;
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
  var valid_568504 = path.getOrDefault("resourceGroupName")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "resourceGroupName", valid_568504
  var valid_568505 = path.getOrDefault("subscriptionId")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "subscriptionId", valid_568505
  var valid_568506 = path.getOrDefault("imageName")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "imageName", valid_568506
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568507 = query.getOrDefault("api-version")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "api-version", valid_568507
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

proc call*(call_568509: Call_ImagesCreateOrUpdate_568501; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an image.
  ## 
  let valid = call_568509.validator(path, query, header, formData, body)
  let scheme = call_568509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568509.url(scheme.get, call_568509.host, call_568509.base,
                         call_568509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568509, url, valid)

proc call*(call_568510: Call_ImagesCreateOrUpdate_568501;
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
  var path_568511 = newJObject()
  var query_568512 = newJObject()
  var body_568513 = newJObject()
  add(path_568511, "resourceGroupName", newJString(resourceGroupName))
  add(query_568512, "api-version", newJString(apiVersion))
  add(path_568511, "subscriptionId", newJString(subscriptionId))
  add(path_568511, "imageName", newJString(imageName))
  if parameters != nil:
    body_568513 = parameters
  result = call_568510.call(path_568511, query_568512, nil, nil, body_568513)

var imagesCreateOrUpdate* = Call_ImagesCreateOrUpdate_568501(
    name: "imagesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesCreateOrUpdate_568502, base: "",
    url: url_ImagesCreateOrUpdate_568503, schemes: {Scheme.Https})
type
  Call_ImagesGet_568489 = ref object of OpenApiRestCall_567667
proc url_ImagesGet_568491(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ImagesGet_568490(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568492 = path.getOrDefault("resourceGroupName")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "resourceGroupName", valid_568492
  var valid_568493 = path.getOrDefault("subscriptionId")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "subscriptionId", valid_568493
  var valid_568494 = path.getOrDefault("imageName")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "imageName", valid_568494
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_568495 = query.getOrDefault("$expand")
  valid_568495 = validateParameter(valid_568495, JString, required = false,
                                 default = nil)
  if valid_568495 != nil:
    section.add "$expand", valid_568495
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568496 = query.getOrDefault("api-version")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "api-version", valid_568496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568497: Call_ImagesGet_568489; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an image.
  ## 
  let valid = call_568497.validator(path, query, header, formData, body)
  let scheme = call_568497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568497.url(scheme.get, call_568497.host, call_568497.base,
                         call_568497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568497, url, valid)

proc call*(call_568498: Call_ImagesGet_568489; resourceGroupName: string;
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
  var path_568499 = newJObject()
  var query_568500 = newJObject()
  add(path_568499, "resourceGroupName", newJString(resourceGroupName))
  add(query_568500, "$expand", newJString(Expand))
  add(query_568500, "api-version", newJString(apiVersion))
  add(path_568499, "subscriptionId", newJString(subscriptionId))
  add(path_568499, "imageName", newJString(imageName))
  result = call_568498.call(path_568499, query_568500, nil, nil, nil)

var imagesGet* = Call_ImagesGet_568489(name: "imagesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
                                    validator: validate_ImagesGet_568490,
                                    base: "", url: url_ImagesGet_568491,
                                    schemes: {Scheme.Https})
type
  Call_ImagesUpdate_568525 = ref object of OpenApiRestCall_567667
proc url_ImagesUpdate_568527(protocol: Scheme; host: string; base: string;
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

proc validate_ImagesUpdate_568526(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568528 = path.getOrDefault("resourceGroupName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "resourceGroupName", valid_568528
  var valid_568529 = path.getOrDefault("subscriptionId")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "subscriptionId", valid_568529
  var valid_568530 = path.getOrDefault("imageName")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "imageName", valid_568530
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568531 = query.getOrDefault("api-version")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "api-version", valid_568531
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

proc call*(call_568533: Call_ImagesUpdate_568525; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an image.
  ## 
  let valid = call_568533.validator(path, query, header, formData, body)
  let scheme = call_568533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568533.url(scheme.get, call_568533.host, call_568533.base,
                         call_568533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568533, url, valid)

proc call*(call_568534: Call_ImagesUpdate_568525; resourceGroupName: string;
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
  var path_568535 = newJObject()
  var query_568536 = newJObject()
  var body_568537 = newJObject()
  add(path_568535, "resourceGroupName", newJString(resourceGroupName))
  add(query_568536, "api-version", newJString(apiVersion))
  add(path_568535, "subscriptionId", newJString(subscriptionId))
  add(path_568535, "imageName", newJString(imageName))
  if parameters != nil:
    body_568537 = parameters
  result = call_568534.call(path_568535, query_568536, nil, nil, body_568537)

var imagesUpdate* = Call_ImagesUpdate_568525(name: "imagesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesUpdate_568526, base: "", url: url_ImagesUpdate_568527,
    schemes: {Scheme.Https})
type
  Call_ImagesDelete_568514 = ref object of OpenApiRestCall_567667
proc url_ImagesDelete_568516(protocol: Scheme; host: string; base: string;
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

proc validate_ImagesDelete_568515(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568517 = path.getOrDefault("resourceGroupName")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "resourceGroupName", valid_568517
  var valid_568518 = path.getOrDefault("subscriptionId")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "subscriptionId", valid_568518
  var valid_568519 = path.getOrDefault("imageName")
  valid_568519 = validateParameter(valid_568519, JString, required = true,
                                 default = nil)
  if valid_568519 != nil:
    section.add "imageName", valid_568519
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568520 = query.getOrDefault("api-version")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = nil)
  if valid_568520 != nil:
    section.add "api-version", valid_568520
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568521: Call_ImagesDelete_568514; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Image.
  ## 
  let valid = call_568521.validator(path, query, header, formData, body)
  let scheme = call_568521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568521.url(scheme.get, call_568521.host, call_568521.base,
                         call_568521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568521, url, valid)

proc call*(call_568522: Call_ImagesDelete_568514; resourceGroupName: string;
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
  var path_568523 = newJObject()
  var query_568524 = newJObject()
  add(path_568523, "resourceGroupName", newJString(resourceGroupName))
  add(query_568524, "api-version", newJString(apiVersion))
  add(path_568523, "subscriptionId", newJString(subscriptionId))
  add(path_568523, "imageName", newJString(imageName))
  result = call_568522.call(path_568523, query_568524, nil, nil, nil)

var imagesDelete* = Call_ImagesDelete_568514(name: "imagesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesDelete_568515, base: "", url: url_ImagesDelete_568516,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsList_568538 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsList_568540(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsList_568539(path: JsonNode; query: JsonNode;
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
  var valid_568541 = path.getOrDefault("resourceGroupName")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "resourceGroupName", valid_568541
  var valid_568542 = path.getOrDefault("subscriptionId")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "subscriptionId", valid_568542
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568543 = query.getOrDefault("api-version")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "api-version", valid_568543
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568544: Call_VirtualMachineScaleSetsList_568538; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all VM scale sets under a resource group.
  ## 
  let valid = call_568544.validator(path, query, header, formData, body)
  let scheme = call_568544.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568544.url(scheme.get, call_568544.host, call_568544.base,
                         call_568544.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568544, url, valid)

proc call*(call_568545: Call_VirtualMachineScaleSetsList_568538;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsList
  ## Gets a list of all VM scale sets under a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568546 = newJObject()
  var query_568547 = newJObject()
  add(path_568546, "resourceGroupName", newJString(resourceGroupName))
  add(query_568547, "api-version", newJString(apiVersion))
  add(path_568546, "subscriptionId", newJString(subscriptionId))
  result = call_568545.call(path_568546, query_568547, nil, nil, nil)

var virtualMachineScaleSetsList* = Call_VirtualMachineScaleSetsList_568538(
    name: "virtualMachineScaleSetsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets",
    validator: validate_VirtualMachineScaleSetsList_568539, base: "",
    url: url_VirtualMachineScaleSetsList_568540, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsList_568548 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsList_568550(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsList_568549(path: JsonNode; query: JsonNode;
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
  var valid_568551 = path.getOrDefault("resourceGroupName")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "resourceGroupName", valid_568551
  var valid_568552 = path.getOrDefault("subscriptionId")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "subscriptionId", valid_568552
  var valid_568553 = path.getOrDefault("virtualMachineScaleSetName")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "virtualMachineScaleSetName", valid_568553
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
  var valid_568554 = query.getOrDefault("$expand")
  valid_568554 = validateParameter(valid_568554, JString, required = false,
                                 default = nil)
  if valid_568554 != nil:
    section.add "$expand", valid_568554
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568555 = query.getOrDefault("api-version")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "api-version", valid_568555
  var valid_568556 = query.getOrDefault("$select")
  valid_568556 = validateParameter(valid_568556, JString, required = false,
                                 default = nil)
  if valid_568556 != nil:
    section.add "$select", valid_568556
  var valid_568557 = query.getOrDefault("$filter")
  valid_568557 = validateParameter(valid_568557, JString, required = false,
                                 default = nil)
  if valid_568557 != nil:
    section.add "$filter", valid_568557
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568558: Call_VirtualMachineScaleSetVMsList_568548; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all virtual machines in a VM scale sets.
  ## 
  let valid = call_568558.validator(path, query, header, formData, body)
  let scheme = call_568558.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568558.url(scheme.get, call_568558.host, call_568558.base,
                         call_568558.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568558, url, valid)

proc call*(call_568559: Call_VirtualMachineScaleSetVMsList_568548;
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
  var path_568560 = newJObject()
  var query_568561 = newJObject()
  add(path_568560, "resourceGroupName", newJString(resourceGroupName))
  add(query_568561, "$expand", newJString(Expand))
  add(query_568561, "api-version", newJString(apiVersion))
  add(path_568560, "subscriptionId", newJString(subscriptionId))
  add(query_568561, "$select", newJString(Select))
  add(path_568560, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  add(query_568561, "$filter", newJString(Filter))
  result = call_568559.call(path_568560, query_568561, nil, nil, nil)

var virtualMachineScaleSetVMsList* = Call_VirtualMachineScaleSetVMsList_568548(
    name: "virtualMachineScaleSetVMsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines",
    validator: validate_VirtualMachineScaleSetVMsList_568549, base: "",
    url: url_VirtualMachineScaleSetVMsList_568550, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsCreateOrUpdate_568573 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsCreateOrUpdate_568575(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsCreateOrUpdate_568574(path: JsonNode;
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
  var valid_568576 = path.getOrDefault("vmScaleSetName")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "vmScaleSetName", valid_568576
  var valid_568577 = path.getOrDefault("resourceGroupName")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = nil)
  if valid_568577 != nil:
    section.add "resourceGroupName", valid_568577
  var valid_568578 = path.getOrDefault("subscriptionId")
  valid_568578 = validateParameter(valid_568578, JString, required = true,
                                 default = nil)
  if valid_568578 != nil:
    section.add "subscriptionId", valid_568578
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568579 = query.getOrDefault("api-version")
  valid_568579 = validateParameter(valid_568579, JString, required = true,
                                 default = nil)
  if valid_568579 != nil:
    section.add "api-version", valid_568579
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

proc call*(call_568581: Call_VirtualMachineScaleSetsCreateOrUpdate_568573;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a VM scale set.
  ## 
  let valid = call_568581.validator(path, query, header, formData, body)
  let scheme = call_568581.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568581.url(scheme.get, call_568581.host, call_568581.base,
                         call_568581.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568581, url, valid)

proc call*(call_568582: Call_VirtualMachineScaleSetsCreateOrUpdate_568573;
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
  var path_568583 = newJObject()
  var query_568584 = newJObject()
  var body_568585 = newJObject()
  add(path_568583, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568583, "resourceGroupName", newJString(resourceGroupName))
  add(query_568584, "api-version", newJString(apiVersion))
  add(path_568583, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568585 = parameters
  result = call_568582.call(path_568583, query_568584, nil, nil, body_568585)

var virtualMachineScaleSetsCreateOrUpdate* = Call_VirtualMachineScaleSetsCreateOrUpdate_568573(
    name: "virtualMachineScaleSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsCreateOrUpdate_568574, base: "",
    url: url_VirtualMachineScaleSetsCreateOrUpdate_568575, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGet_568562 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsGet_568564(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsGet_568563(path: JsonNode; query: JsonNode;
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
  var valid_568565 = path.getOrDefault("vmScaleSetName")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "vmScaleSetName", valid_568565
  var valid_568566 = path.getOrDefault("resourceGroupName")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "resourceGroupName", valid_568566
  var valid_568567 = path.getOrDefault("subscriptionId")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "subscriptionId", valid_568567
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568568 = query.getOrDefault("api-version")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "api-version", valid_568568
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568569: Call_VirtualMachineScaleSetsGet_568562; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Display information about a virtual machine scale set.
  ## 
  let valid = call_568569.validator(path, query, header, formData, body)
  let scheme = call_568569.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568569.url(scheme.get, call_568569.host, call_568569.base,
                         call_568569.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568569, url, valid)

proc call*(call_568570: Call_VirtualMachineScaleSetsGet_568562;
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
  var path_568571 = newJObject()
  var query_568572 = newJObject()
  add(path_568571, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568571, "resourceGroupName", newJString(resourceGroupName))
  add(query_568572, "api-version", newJString(apiVersion))
  add(path_568571, "subscriptionId", newJString(subscriptionId))
  result = call_568570.call(path_568571, query_568572, nil, nil, nil)

var virtualMachineScaleSetsGet* = Call_VirtualMachineScaleSetsGet_568562(
    name: "virtualMachineScaleSetsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsGet_568563, base: "",
    url: url_VirtualMachineScaleSetsGet_568564, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsUpdate_568597 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsUpdate_568599(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsUpdate_568598(path: JsonNode; query: JsonNode;
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
  var valid_568600 = path.getOrDefault("vmScaleSetName")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "vmScaleSetName", valid_568600
  var valid_568601 = path.getOrDefault("resourceGroupName")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "resourceGroupName", valid_568601
  var valid_568602 = path.getOrDefault("subscriptionId")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "subscriptionId", valid_568602
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568603 = query.getOrDefault("api-version")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "api-version", valid_568603
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

proc call*(call_568605: Call_VirtualMachineScaleSetsUpdate_568597; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a VM scale set.
  ## 
  let valid = call_568605.validator(path, query, header, formData, body)
  let scheme = call_568605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568605.url(scheme.get, call_568605.host, call_568605.base,
                         call_568605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568605, url, valid)

proc call*(call_568606: Call_VirtualMachineScaleSetsUpdate_568597;
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
  var path_568607 = newJObject()
  var query_568608 = newJObject()
  var body_568609 = newJObject()
  add(path_568607, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568607, "resourceGroupName", newJString(resourceGroupName))
  add(query_568608, "api-version", newJString(apiVersion))
  add(path_568607, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568609 = parameters
  result = call_568606.call(path_568607, query_568608, nil, nil, body_568609)

var virtualMachineScaleSetsUpdate* = Call_VirtualMachineScaleSetsUpdate_568597(
    name: "virtualMachineScaleSetsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsUpdate_568598, base: "",
    url: url_VirtualMachineScaleSetsUpdate_568599, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDelete_568586 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsDelete_568588(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsDelete_568587(path: JsonNode; query: JsonNode;
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
  var valid_568589 = path.getOrDefault("vmScaleSetName")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = nil)
  if valid_568589 != nil:
    section.add "vmScaleSetName", valid_568589
  var valid_568590 = path.getOrDefault("resourceGroupName")
  valid_568590 = validateParameter(valid_568590, JString, required = true,
                                 default = nil)
  if valid_568590 != nil:
    section.add "resourceGroupName", valid_568590
  var valid_568591 = path.getOrDefault("subscriptionId")
  valid_568591 = validateParameter(valid_568591, JString, required = true,
                                 default = nil)
  if valid_568591 != nil:
    section.add "subscriptionId", valid_568591
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568592 = query.getOrDefault("api-version")
  valid_568592 = validateParameter(valid_568592, JString, required = true,
                                 default = nil)
  if valid_568592 != nil:
    section.add "api-version", valid_568592
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568593: Call_VirtualMachineScaleSetsDelete_568586; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VM scale set.
  ## 
  let valid = call_568593.validator(path, query, header, formData, body)
  let scheme = call_568593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568593.url(scheme.get, call_568593.host, call_568593.base,
                         call_568593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568593, url, valid)

proc call*(call_568594: Call_VirtualMachineScaleSetsDelete_568586;
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
  var path_568595 = newJObject()
  var query_568596 = newJObject()
  add(path_568595, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568595, "resourceGroupName", newJString(resourceGroupName))
  add(query_568596, "api-version", newJString(apiVersion))
  add(path_568595, "subscriptionId", newJString(subscriptionId))
  result = call_568594.call(path_568595, query_568596, nil, nil, nil)

var virtualMachineScaleSetsDelete* = Call_VirtualMachineScaleSetsDelete_568586(
    name: "virtualMachineScaleSetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsDelete_568587, base: "",
    url: url_VirtualMachineScaleSetsDelete_568588, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDeallocate_568610 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsDeallocate_568612(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsDeallocate_568611(path: JsonNode;
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
  var valid_568613 = path.getOrDefault("vmScaleSetName")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "vmScaleSetName", valid_568613
  var valid_568614 = path.getOrDefault("resourceGroupName")
  valid_568614 = validateParameter(valid_568614, JString, required = true,
                                 default = nil)
  if valid_568614 != nil:
    section.add "resourceGroupName", valid_568614
  var valid_568615 = path.getOrDefault("subscriptionId")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "subscriptionId", valid_568615
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568616 = query.getOrDefault("api-version")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "api-version", valid_568616
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

proc call*(call_568618: Call_VirtualMachineScaleSetsDeallocate_568610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deallocates specific virtual machines in a VM scale set. Shuts down the virtual machines and releases the compute resources. You are not billed for the compute resources that this virtual machine scale set deallocates.
  ## 
  let valid = call_568618.validator(path, query, header, formData, body)
  let scheme = call_568618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568618.url(scheme.get, call_568618.host, call_568618.base,
                         call_568618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568618, url, valid)

proc call*(call_568619: Call_VirtualMachineScaleSetsDeallocate_568610;
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
  var path_568620 = newJObject()
  var query_568621 = newJObject()
  var body_568622 = newJObject()
  add(path_568620, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568620, "resourceGroupName", newJString(resourceGroupName))
  add(query_568621, "api-version", newJString(apiVersion))
  add(path_568620, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568622 = vmInstanceIDs
  result = call_568619.call(path_568620, query_568621, nil, nil, body_568622)

var virtualMachineScaleSetsDeallocate* = Call_VirtualMachineScaleSetsDeallocate_568610(
    name: "virtualMachineScaleSetsDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/deallocate",
    validator: validate_VirtualMachineScaleSetsDeallocate_568611, base: "",
    url: url_VirtualMachineScaleSetsDeallocate_568612, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDeleteInstances_568623 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsDeleteInstances_568625(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsDeleteInstances_568624(path: JsonNode;
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
  var valid_568626 = path.getOrDefault("vmScaleSetName")
  valid_568626 = validateParameter(valid_568626, JString, required = true,
                                 default = nil)
  if valid_568626 != nil:
    section.add "vmScaleSetName", valid_568626
  var valid_568627 = path.getOrDefault("resourceGroupName")
  valid_568627 = validateParameter(valid_568627, JString, required = true,
                                 default = nil)
  if valid_568627 != nil:
    section.add "resourceGroupName", valid_568627
  var valid_568628 = path.getOrDefault("subscriptionId")
  valid_568628 = validateParameter(valid_568628, JString, required = true,
                                 default = nil)
  if valid_568628 != nil:
    section.add "subscriptionId", valid_568628
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568629 = query.getOrDefault("api-version")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "api-version", valid_568629
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

proc call*(call_568631: Call_VirtualMachineScaleSetsDeleteInstances_568623;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes virtual machines in a VM scale set.
  ## 
  let valid = call_568631.validator(path, query, header, formData, body)
  let scheme = call_568631.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568631.url(scheme.get, call_568631.host, call_568631.base,
                         call_568631.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568631, url, valid)

proc call*(call_568632: Call_VirtualMachineScaleSetsDeleteInstances_568623;
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
  var path_568633 = newJObject()
  var query_568634 = newJObject()
  var body_568635 = newJObject()
  add(path_568633, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568633, "resourceGroupName", newJString(resourceGroupName))
  add(query_568634, "api-version", newJString(apiVersion))
  add(path_568633, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568635 = vmInstanceIDs
  result = call_568632.call(path_568633, query_568634, nil, nil, body_568635)

var virtualMachineScaleSetsDeleteInstances* = Call_VirtualMachineScaleSetsDeleteInstances_568623(
    name: "virtualMachineScaleSetsDeleteInstances", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/delete",
    validator: validate_VirtualMachineScaleSetsDeleteInstances_568624, base: "",
    url: url_VirtualMachineScaleSetsDeleteInstances_568625,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsList_568636 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetExtensionsList_568638(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetExtensionsList_568637(path: JsonNode;
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
  var valid_568639 = path.getOrDefault("vmScaleSetName")
  valid_568639 = validateParameter(valid_568639, JString, required = true,
                                 default = nil)
  if valid_568639 != nil:
    section.add "vmScaleSetName", valid_568639
  var valid_568640 = path.getOrDefault("resourceGroupName")
  valid_568640 = validateParameter(valid_568640, JString, required = true,
                                 default = nil)
  if valid_568640 != nil:
    section.add "resourceGroupName", valid_568640
  var valid_568641 = path.getOrDefault("subscriptionId")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "subscriptionId", valid_568641
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568642 = query.getOrDefault("api-version")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "api-version", valid_568642
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568643: Call_VirtualMachineScaleSetExtensionsList_568636;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of all extensions in a VM scale set.
  ## 
  let valid = call_568643.validator(path, query, header, formData, body)
  let scheme = call_568643.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568643.url(scheme.get, call_568643.host, call_568643.base,
                         call_568643.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568643, url, valid)

proc call*(call_568644: Call_VirtualMachineScaleSetExtensionsList_568636;
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
  var path_568645 = newJObject()
  var query_568646 = newJObject()
  add(path_568645, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568645, "resourceGroupName", newJString(resourceGroupName))
  add(query_568646, "api-version", newJString(apiVersion))
  add(path_568645, "subscriptionId", newJString(subscriptionId))
  result = call_568644.call(path_568645, query_568646, nil, nil, nil)

var virtualMachineScaleSetExtensionsList* = Call_VirtualMachineScaleSetExtensionsList_568636(
    name: "virtualMachineScaleSetExtensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions",
    validator: validate_VirtualMachineScaleSetExtensionsList_568637, base: "",
    url: url_VirtualMachineScaleSetExtensionsList_568638, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_568660 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetExtensionsCreateOrUpdate_568662(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetExtensionsCreateOrUpdate_568661(
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
  var valid_568663 = path.getOrDefault("vmScaleSetName")
  valid_568663 = validateParameter(valid_568663, JString, required = true,
                                 default = nil)
  if valid_568663 != nil:
    section.add "vmScaleSetName", valid_568663
  var valid_568664 = path.getOrDefault("resourceGroupName")
  valid_568664 = validateParameter(valid_568664, JString, required = true,
                                 default = nil)
  if valid_568664 != nil:
    section.add "resourceGroupName", valid_568664
  var valid_568665 = path.getOrDefault("subscriptionId")
  valid_568665 = validateParameter(valid_568665, JString, required = true,
                                 default = nil)
  if valid_568665 != nil:
    section.add "subscriptionId", valid_568665
  var valid_568666 = path.getOrDefault("vmssExtensionName")
  valid_568666 = validateParameter(valid_568666, JString, required = true,
                                 default = nil)
  if valid_568666 != nil:
    section.add "vmssExtensionName", valid_568666
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568667 = query.getOrDefault("api-version")
  valid_568667 = validateParameter(valid_568667, JString, required = true,
                                 default = nil)
  if valid_568667 != nil:
    section.add "api-version", valid_568667
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

proc call*(call_568669: Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_568660;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update an extension.
  ## 
  let valid = call_568669.validator(path, query, header, formData, body)
  let scheme = call_568669.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568669.url(scheme.get, call_568669.host, call_568669.base,
                         call_568669.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568669, url, valid)

proc call*(call_568670: Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_568660;
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
  var path_568671 = newJObject()
  var query_568672 = newJObject()
  var body_568673 = newJObject()
  add(path_568671, "vmScaleSetName", newJString(vmScaleSetName))
  if extensionParameters != nil:
    body_568673 = extensionParameters
  add(path_568671, "resourceGroupName", newJString(resourceGroupName))
  add(query_568672, "api-version", newJString(apiVersion))
  add(path_568671, "subscriptionId", newJString(subscriptionId))
  add(path_568671, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_568670.call(path_568671, query_568672, nil, nil, body_568673)

var virtualMachineScaleSetExtensionsCreateOrUpdate* = Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_568660(
    name: "virtualMachineScaleSetExtensionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsCreateOrUpdate_568661,
    base: "", url: url_VirtualMachineScaleSetExtensionsCreateOrUpdate_568662,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsGet_568647 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetExtensionsGet_568649(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetExtensionsGet_568648(path: JsonNode;
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
  var valid_568650 = path.getOrDefault("vmScaleSetName")
  valid_568650 = validateParameter(valid_568650, JString, required = true,
                                 default = nil)
  if valid_568650 != nil:
    section.add "vmScaleSetName", valid_568650
  var valid_568651 = path.getOrDefault("resourceGroupName")
  valid_568651 = validateParameter(valid_568651, JString, required = true,
                                 default = nil)
  if valid_568651 != nil:
    section.add "resourceGroupName", valid_568651
  var valid_568652 = path.getOrDefault("subscriptionId")
  valid_568652 = validateParameter(valid_568652, JString, required = true,
                                 default = nil)
  if valid_568652 != nil:
    section.add "subscriptionId", valid_568652
  var valid_568653 = path.getOrDefault("vmssExtensionName")
  valid_568653 = validateParameter(valid_568653, JString, required = true,
                                 default = nil)
  if valid_568653 != nil:
    section.add "vmssExtensionName", valid_568653
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_568654 = query.getOrDefault("$expand")
  valid_568654 = validateParameter(valid_568654, JString, required = false,
                                 default = nil)
  if valid_568654 != nil:
    section.add "$expand", valid_568654
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568655 = query.getOrDefault("api-version")
  valid_568655 = validateParameter(valid_568655, JString, required = true,
                                 default = nil)
  if valid_568655 != nil:
    section.add "api-version", valid_568655
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568656: Call_VirtualMachineScaleSetExtensionsGet_568647;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to get the extension.
  ## 
  let valid = call_568656.validator(path, query, header, formData, body)
  let scheme = call_568656.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568656.url(scheme.get, call_568656.host, call_568656.base,
                         call_568656.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568656, url, valid)

proc call*(call_568657: Call_VirtualMachineScaleSetExtensionsGet_568647;
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
  var path_568658 = newJObject()
  var query_568659 = newJObject()
  add(path_568658, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568658, "resourceGroupName", newJString(resourceGroupName))
  add(query_568659, "$expand", newJString(Expand))
  add(query_568659, "api-version", newJString(apiVersion))
  add(path_568658, "subscriptionId", newJString(subscriptionId))
  add(path_568658, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_568657.call(path_568658, query_568659, nil, nil, nil)

var virtualMachineScaleSetExtensionsGet* = Call_VirtualMachineScaleSetExtensionsGet_568647(
    name: "virtualMachineScaleSetExtensionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsGet_568648, base: "",
    url: url_VirtualMachineScaleSetExtensionsGet_568649, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsDelete_568674 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetExtensionsDelete_568676(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetExtensionsDelete_568675(path: JsonNode;
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
  var valid_568677 = path.getOrDefault("vmScaleSetName")
  valid_568677 = validateParameter(valid_568677, JString, required = true,
                                 default = nil)
  if valid_568677 != nil:
    section.add "vmScaleSetName", valid_568677
  var valid_568678 = path.getOrDefault("resourceGroupName")
  valid_568678 = validateParameter(valid_568678, JString, required = true,
                                 default = nil)
  if valid_568678 != nil:
    section.add "resourceGroupName", valid_568678
  var valid_568679 = path.getOrDefault("subscriptionId")
  valid_568679 = validateParameter(valid_568679, JString, required = true,
                                 default = nil)
  if valid_568679 != nil:
    section.add "subscriptionId", valid_568679
  var valid_568680 = path.getOrDefault("vmssExtensionName")
  valid_568680 = validateParameter(valid_568680, JString, required = true,
                                 default = nil)
  if valid_568680 != nil:
    section.add "vmssExtensionName", valid_568680
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568681 = query.getOrDefault("api-version")
  valid_568681 = validateParameter(valid_568681, JString, required = true,
                                 default = nil)
  if valid_568681 != nil:
    section.add "api-version", valid_568681
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568682: Call_VirtualMachineScaleSetExtensionsDelete_568674;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete the extension.
  ## 
  let valid = call_568682.validator(path, query, header, formData, body)
  let scheme = call_568682.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568682.url(scheme.get, call_568682.host, call_568682.base,
                         call_568682.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568682, url, valid)

proc call*(call_568683: Call_VirtualMachineScaleSetExtensionsDelete_568674;
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
  var path_568684 = newJObject()
  var query_568685 = newJObject()
  add(path_568684, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568684, "resourceGroupName", newJString(resourceGroupName))
  add(query_568685, "api-version", newJString(apiVersion))
  add(path_568684, "subscriptionId", newJString(subscriptionId))
  add(path_568684, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_568683.call(path_568684, query_568685, nil, nil, nil)

var virtualMachineScaleSetExtensionsDelete* = Call_VirtualMachineScaleSetExtensionsDelete_568674(
    name: "virtualMachineScaleSetExtensionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsDelete_568675, base: "",
    url: url_VirtualMachineScaleSetExtensionsDelete_568676,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568686 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568688(
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

proc validate_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568687(
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
  var valid_568689 = path.getOrDefault("vmScaleSetName")
  valid_568689 = validateParameter(valid_568689, JString, required = true,
                                 default = nil)
  if valid_568689 != nil:
    section.add "vmScaleSetName", valid_568689
  var valid_568690 = path.getOrDefault("resourceGroupName")
  valid_568690 = validateParameter(valid_568690, JString, required = true,
                                 default = nil)
  if valid_568690 != nil:
    section.add "resourceGroupName", valid_568690
  var valid_568691 = path.getOrDefault("subscriptionId")
  valid_568691 = validateParameter(valid_568691, JString, required = true,
                                 default = nil)
  if valid_568691 != nil:
    section.add "subscriptionId", valid_568691
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   platformUpdateDomain: JInt (required)
  ##                       : The platform update domain for which a manual recovery walk is requested
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568692 = query.getOrDefault("api-version")
  valid_568692 = validateParameter(valid_568692, JString, required = true,
                                 default = nil)
  if valid_568692 != nil:
    section.add "api-version", valid_568692
  var valid_568693 = query.getOrDefault("platformUpdateDomain")
  valid_568693 = validateParameter(valid_568693, JInt, required = true, default = nil)
  if valid_568693 != nil:
    section.add "platformUpdateDomain", valid_568693
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568694: Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568686;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Manual platform update domain walk to update virtual machines in a service fabric virtual machine scale set.
  ## 
  let valid = call_568694.validator(path, query, header, formData, body)
  let scheme = call_568694.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568694.url(scheme.get, call_568694.host, call_568694.base,
                         call_568694.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568694, url, valid)

proc call*(call_568695: Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568686;
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
  var path_568696 = newJObject()
  var query_568697 = newJObject()
  add(path_568696, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568696, "resourceGroupName", newJString(resourceGroupName))
  add(query_568697, "api-version", newJString(apiVersion))
  add(query_568697, "platformUpdateDomain", newJInt(platformUpdateDomain))
  add(path_568696, "subscriptionId", newJString(subscriptionId))
  result = call_568695.call(path_568696, query_568697, nil, nil, nil)

var virtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk* = Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568686(name: "virtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/forceRecoveryServiceFabricPlatformUpdateDomainWalk", validator: validate_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568687,
    base: "", url: url_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568688,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGetInstanceView_568698 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsGetInstanceView_568700(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsGetInstanceView_568699(path: JsonNode;
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
  var valid_568701 = path.getOrDefault("vmScaleSetName")
  valid_568701 = validateParameter(valid_568701, JString, required = true,
                                 default = nil)
  if valid_568701 != nil:
    section.add "vmScaleSetName", valid_568701
  var valid_568702 = path.getOrDefault("resourceGroupName")
  valid_568702 = validateParameter(valid_568702, JString, required = true,
                                 default = nil)
  if valid_568702 != nil:
    section.add "resourceGroupName", valid_568702
  var valid_568703 = path.getOrDefault("subscriptionId")
  valid_568703 = validateParameter(valid_568703, JString, required = true,
                                 default = nil)
  if valid_568703 != nil:
    section.add "subscriptionId", valid_568703
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568704 = query.getOrDefault("api-version")
  valid_568704 = validateParameter(valid_568704, JString, required = true,
                                 default = nil)
  if valid_568704 != nil:
    section.add "api-version", valid_568704
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568705: Call_VirtualMachineScaleSetsGetInstanceView_568698;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of a VM scale set instance.
  ## 
  let valid = call_568705.validator(path, query, header, formData, body)
  let scheme = call_568705.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568705.url(scheme.get, call_568705.host, call_568705.base,
                         call_568705.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568705, url, valid)

proc call*(call_568706: Call_VirtualMachineScaleSetsGetInstanceView_568698;
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
  var path_568707 = newJObject()
  var query_568708 = newJObject()
  add(path_568707, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568707, "resourceGroupName", newJString(resourceGroupName))
  add(query_568708, "api-version", newJString(apiVersion))
  add(path_568707, "subscriptionId", newJString(subscriptionId))
  result = call_568706.call(path_568707, query_568708, nil, nil, nil)

var virtualMachineScaleSetsGetInstanceView* = Call_VirtualMachineScaleSetsGetInstanceView_568698(
    name: "virtualMachineScaleSetsGetInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/instanceView",
    validator: validate_VirtualMachineScaleSetsGetInstanceView_568699, base: "",
    url: url_VirtualMachineScaleSetsGetInstanceView_568700,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsUpdateInstances_568709 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsUpdateInstances_568711(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsUpdateInstances_568710(path: JsonNode;
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
  var valid_568712 = path.getOrDefault("vmScaleSetName")
  valid_568712 = validateParameter(valid_568712, JString, required = true,
                                 default = nil)
  if valid_568712 != nil:
    section.add "vmScaleSetName", valid_568712
  var valid_568713 = path.getOrDefault("resourceGroupName")
  valid_568713 = validateParameter(valid_568713, JString, required = true,
                                 default = nil)
  if valid_568713 != nil:
    section.add "resourceGroupName", valid_568713
  var valid_568714 = path.getOrDefault("subscriptionId")
  valid_568714 = validateParameter(valid_568714, JString, required = true,
                                 default = nil)
  if valid_568714 != nil:
    section.add "subscriptionId", valid_568714
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568715 = query.getOrDefault("api-version")
  valid_568715 = validateParameter(valid_568715, JString, required = true,
                                 default = nil)
  if valid_568715 != nil:
    section.add "api-version", valid_568715
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

proc call*(call_568717: Call_VirtualMachineScaleSetsUpdateInstances_568709;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upgrades one or more virtual machines to the latest SKU set in the VM scale set model.
  ## 
  let valid = call_568717.validator(path, query, header, formData, body)
  let scheme = call_568717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568717.url(scheme.get, call_568717.host, call_568717.base,
                         call_568717.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568717, url, valid)

proc call*(call_568718: Call_VirtualMachineScaleSetsUpdateInstances_568709;
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
  var path_568719 = newJObject()
  var query_568720 = newJObject()
  var body_568721 = newJObject()
  add(path_568719, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568719, "resourceGroupName", newJString(resourceGroupName))
  add(query_568720, "api-version", newJString(apiVersion))
  add(path_568719, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568721 = vmInstanceIDs
  result = call_568718.call(path_568719, query_568720, nil, nil, body_568721)

var virtualMachineScaleSetsUpdateInstances* = Call_VirtualMachineScaleSetsUpdateInstances_568709(
    name: "virtualMachineScaleSetsUpdateInstances", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/manualupgrade",
    validator: validate_VirtualMachineScaleSetsUpdateInstances_568710, base: "",
    url: url_VirtualMachineScaleSetsUpdateInstances_568711,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568722 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568724(
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

proc validate_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568723(
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
  var valid_568725 = path.getOrDefault("vmScaleSetName")
  valid_568725 = validateParameter(valid_568725, JString, required = true,
                                 default = nil)
  if valid_568725 != nil:
    section.add "vmScaleSetName", valid_568725
  var valid_568726 = path.getOrDefault("resourceGroupName")
  valid_568726 = validateParameter(valid_568726, JString, required = true,
                                 default = nil)
  if valid_568726 != nil:
    section.add "resourceGroupName", valid_568726
  var valid_568727 = path.getOrDefault("subscriptionId")
  valid_568727 = validateParameter(valid_568727, JString, required = true,
                                 default = nil)
  if valid_568727 != nil:
    section.add "subscriptionId", valid_568727
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568728 = query.getOrDefault("api-version")
  valid_568728 = validateParameter(valid_568728, JString, required = true,
                                 default = nil)
  if valid_568728 != nil:
    section.add "api-version", valid_568728
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568729: Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568722;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a rolling upgrade to move all virtual machine scale set instances to the latest available Platform Image OS version. Instances which are already running the latest available OS version are not affected.
  ## 
  let valid = call_568729.validator(path, query, header, formData, body)
  let scheme = call_568729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568729.url(scheme.get, call_568729.host, call_568729.base,
                         call_568729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568729, url, valid)

proc call*(call_568730: Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568722;
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
  var path_568731 = newJObject()
  var query_568732 = newJObject()
  add(path_568731, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568731, "resourceGroupName", newJString(resourceGroupName))
  add(query_568732, "api-version", newJString(apiVersion))
  add(path_568731, "subscriptionId", newJString(subscriptionId))
  result = call_568730.call(path_568731, query_568732, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesStartOSUpgrade* = Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568722(
    name: "virtualMachineScaleSetRollingUpgradesStartOSUpgrade",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/osRollingUpgrade",
    validator: validate_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568723,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568724,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGetOSUpgradeHistory_568733 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsGetOSUpgradeHistory_568735(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsGetOSUpgradeHistory_568734(path: JsonNode;
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
  var valid_568736 = path.getOrDefault("vmScaleSetName")
  valid_568736 = validateParameter(valid_568736, JString, required = true,
                                 default = nil)
  if valid_568736 != nil:
    section.add "vmScaleSetName", valid_568736
  var valid_568737 = path.getOrDefault("resourceGroupName")
  valid_568737 = validateParameter(valid_568737, JString, required = true,
                                 default = nil)
  if valid_568737 != nil:
    section.add "resourceGroupName", valid_568737
  var valid_568738 = path.getOrDefault("subscriptionId")
  valid_568738 = validateParameter(valid_568738, JString, required = true,
                                 default = nil)
  if valid_568738 != nil:
    section.add "subscriptionId", valid_568738
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568739 = query.getOrDefault("api-version")
  valid_568739 = validateParameter(valid_568739, JString, required = true,
                                 default = nil)
  if valid_568739 != nil:
    section.add "api-version", valid_568739
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568740: Call_VirtualMachineScaleSetsGetOSUpgradeHistory_568733;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets list of OS upgrades on a VM scale set instance.
  ## 
  let valid = call_568740.validator(path, query, header, formData, body)
  let scheme = call_568740.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568740.url(scheme.get, call_568740.host, call_568740.base,
                         call_568740.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568740, url, valid)

proc call*(call_568741: Call_VirtualMachineScaleSetsGetOSUpgradeHistory_568733;
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
  var path_568742 = newJObject()
  var query_568743 = newJObject()
  add(path_568742, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568742, "resourceGroupName", newJString(resourceGroupName))
  add(query_568743, "api-version", newJString(apiVersion))
  add(path_568742, "subscriptionId", newJString(subscriptionId))
  result = call_568741.call(path_568742, query_568743, nil, nil, nil)

var virtualMachineScaleSetsGetOSUpgradeHistory* = Call_VirtualMachineScaleSetsGetOSUpgradeHistory_568733(
    name: "virtualMachineScaleSetsGetOSUpgradeHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/osUpgradeHistory",
    validator: validate_VirtualMachineScaleSetsGetOSUpgradeHistory_568734,
    base: "", url: url_VirtualMachineScaleSetsGetOSUpgradeHistory_568735,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsPerformMaintenance_568744 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsPerformMaintenance_568746(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsPerformMaintenance_568745(path: JsonNode;
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
  var valid_568747 = path.getOrDefault("vmScaleSetName")
  valid_568747 = validateParameter(valid_568747, JString, required = true,
                                 default = nil)
  if valid_568747 != nil:
    section.add "vmScaleSetName", valid_568747
  var valid_568748 = path.getOrDefault("resourceGroupName")
  valid_568748 = validateParameter(valid_568748, JString, required = true,
                                 default = nil)
  if valid_568748 != nil:
    section.add "resourceGroupName", valid_568748
  var valid_568749 = path.getOrDefault("subscriptionId")
  valid_568749 = validateParameter(valid_568749, JString, required = true,
                                 default = nil)
  if valid_568749 != nil:
    section.add "subscriptionId", valid_568749
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568750 = query.getOrDefault("api-version")
  valid_568750 = validateParameter(valid_568750, JString, required = true,
                                 default = nil)
  if valid_568750 != nil:
    section.add "api-version", valid_568750
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

proc call*(call_568752: Call_VirtualMachineScaleSetsPerformMaintenance_568744;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Perform maintenance on one or more virtual machines in a VM scale set. Operation on instances which are not eligible for perform maintenance will be failed. Please refer to best practices for more details: https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-maintenance-notifications
  ## 
  let valid = call_568752.validator(path, query, header, formData, body)
  let scheme = call_568752.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568752.url(scheme.get, call_568752.host, call_568752.base,
                         call_568752.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568752, url, valid)

proc call*(call_568753: Call_VirtualMachineScaleSetsPerformMaintenance_568744;
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
  var path_568754 = newJObject()
  var query_568755 = newJObject()
  var body_568756 = newJObject()
  add(path_568754, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568754, "resourceGroupName", newJString(resourceGroupName))
  add(query_568755, "api-version", newJString(apiVersion))
  add(path_568754, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568756 = vmInstanceIDs
  result = call_568753.call(path_568754, query_568755, nil, nil, body_568756)

var virtualMachineScaleSetsPerformMaintenance* = Call_VirtualMachineScaleSetsPerformMaintenance_568744(
    name: "virtualMachineScaleSetsPerformMaintenance", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/performMaintenance",
    validator: validate_VirtualMachineScaleSetsPerformMaintenance_568745,
    base: "", url: url_VirtualMachineScaleSetsPerformMaintenance_568746,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsPowerOff_568757 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsPowerOff_568759(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsPowerOff_568758(path: JsonNode;
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
  var valid_568760 = path.getOrDefault("vmScaleSetName")
  valid_568760 = validateParameter(valid_568760, JString, required = true,
                                 default = nil)
  if valid_568760 != nil:
    section.add "vmScaleSetName", valid_568760
  var valid_568761 = path.getOrDefault("resourceGroupName")
  valid_568761 = validateParameter(valid_568761, JString, required = true,
                                 default = nil)
  if valid_568761 != nil:
    section.add "resourceGroupName", valid_568761
  var valid_568762 = path.getOrDefault("subscriptionId")
  valid_568762 = validateParameter(valid_568762, JString, required = true,
                                 default = nil)
  if valid_568762 != nil:
    section.add "subscriptionId", valid_568762
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568763 = query.getOrDefault("api-version")
  valid_568763 = validateParameter(valid_568763, JString, required = true,
                                 default = nil)
  if valid_568763 != nil:
    section.add "api-version", valid_568763
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

proc call*(call_568765: Call_VirtualMachineScaleSetsPowerOff_568757;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Power off (stop) one or more virtual machines in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  let valid = call_568765.validator(path, query, header, formData, body)
  let scheme = call_568765.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568765.url(scheme.get, call_568765.host, call_568765.base,
                         call_568765.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568765, url, valid)

proc call*(call_568766: Call_VirtualMachineScaleSetsPowerOff_568757;
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
  var path_568767 = newJObject()
  var query_568768 = newJObject()
  var body_568769 = newJObject()
  add(path_568767, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568767, "resourceGroupName", newJString(resourceGroupName))
  add(query_568768, "api-version", newJString(apiVersion))
  add(path_568767, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568769 = vmInstanceIDs
  result = call_568766.call(path_568767, query_568768, nil, nil, body_568769)

var virtualMachineScaleSetsPowerOff* = Call_VirtualMachineScaleSetsPowerOff_568757(
    name: "virtualMachineScaleSetsPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/poweroff",
    validator: validate_VirtualMachineScaleSetsPowerOff_568758, base: "",
    url: url_VirtualMachineScaleSetsPowerOff_568759, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsRedeploy_568770 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsRedeploy_568772(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsRedeploy_568771(path: JsonNode;
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
  var valid_568773 = path.getOrDefault("vmScaleSetName")
  valid_568773 = validateParameter(valid_568773, JString, required = true,
                                 default = nil)
  if valid_568773 != nil:
    section.add "vmScaleSetName", valid_568773
  var valid_568774 = path.getOrDefault("resourceGroupName")
  valid_568774 = validateParameter(valid_568774, JString, required = true,
                                 default = nil)
  if valid_568774 != nil:
    section.add "resourceGroupName", valid_568774
  var valid_568775 = path.getOrDefault("subscriptionId")
  valid_568775 = validateParameter(valid_568775, JString, required = true,
                                 default = nil)
  if valid_568775 != nil:
    section.add "subscriptionId", valid_568775
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568776 = query.getOrDefault("api-version")
  valid_568776 = validateParameter(valid_568776, JString, required = true,
                                 default = nil)
  if valid_568776 != nil:
    section.add "api-version", valid_568776
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

proc call*(call_568778: Call_VirtualMachineScaleSetsRedeploy_568770;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Shuts down all the virtual machines in the virtual machine scale set, moves them to a new node, and powers them back on.
  ## 
  let valid = call_568778.validator(path, query, header, formData, body)
  let scheme = call_568778.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568778.url(scheme.get, call_568778.host, call_568778.base,
                         call_568778.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568778, url, valid)

proc call*(call_568779: Call_VirtualMachineScaleSetsRedeploy_568770;
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
  var path_568780 = newJObject()
  var query_568781 = newJObject()
  var body_568782 = newJObject()
  add(path_568780, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568780, "resourceGroupName", newJString(resourceGroupName))
  add(query_568781, "api-version", newJString(apiVersion))
  add(path_568780, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568782 = vmInstanceIDs
  result = call_568779.call(path_568780, query_568781, nil, nil, body_568782)

var virtualMachineScaleSetsRedeploy* = Call_VirtualMachineScaleSetsRedeploy_568770(
    name: "virtualMachineScaleSetsRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/redeploy",
    validator: validate_VirtualMachineScaleSetsRedeploy_568771, base: "",
    url: url_VirtualMachineScaleSetsRedeploy_568772, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsReimage_568783 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsReimage_568785(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsReimage_568784(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reimages (upgrade the operating system) one or more virtual machines in a VM scale set.
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
  var valid_568786 = path.getOrDefault("vmScaleSetName")
  valid_568786 = validateParameter(valid_568786, JString, required = true,
                                 default = nil)
  if valid_568786 != nil:
    section.add "vmScaleSetName", valid_568786
  var valid_568787 = path.getOrDefault("resourceGroupName")
  valid_568787 = validateParameter(valid_568787, JString, required = true,
                                 default = nil)
  if valid_568787 != nil:
    section.add "resourceGroupName", valid_568787
  var valid_568788 = path.getOrDefault("subscriptionId")
  valid_568788 = validateParameter(valid_568788, JString, required = true,
                                 default = nil)
  if valid_568788 != nil:
    section.add "subscriptionId", valid_568788
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568789 = query.getOrDefault("api-version")
  valid_568789 = validateParameter(valid_568789, JString, required = true,
                                 default = nil)
  if valid_568789 != nil:
    section.add "api-version", valid_568789
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

proc call*(call_568791: Call_VirtualMachineScaleSetsReimage_568783; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reimages (upgrade the operating system) one or more virtual machines in a VM scale set.
  ## 
  let valid = call_568791.validator(path, query, header, formData, body)
  let scheme = call_568791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568791.url(scheme.get, call_568791.host, call_568791.base,
                         call_568791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568791, url, valid)

proc call*(call_568792: Call_VirtualMachineScaleSetsReimage_568783;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsReimage
  ## Reimages (upgrade the operating system) one or more virtual machines in a VM scale set.
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
  var path_568793 = newJObject()
  var query_568794 = newJObject()
  var body_568795 = newJObject()
  add(path_568793, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568793, "resourceGroupName", newJString(resourceGroupName))
  add(query_568794, "api-version", newJString(apiVersion))
  add(path_568793, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568795 = vmInstanceIDs
  result = call_568792.call(path_568793, query_568794, nil, nil, body_568795)

var virtualMachineScaleSetsReimage* = Call_VirtualMachineScaleSetsReimage_568783(
    name: "virtualMachineScaleSetsReimage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/reimage",
    validator: validate_VirtualMachineScaleSetsReimage_568784, base: "",
    url: url_VirtualMachineScaleSetsReimage_568785, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsReimageAll_568796 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsReimageAll_568798(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsReimageAll_568797(path: JsonNode;
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
  var valid_568799 = path.getOrDefault("vmScaleSetName")
  valid_568799 = validateParameter(valid_568799, JString, required = true,
                                 default = nil)
  if valid_568799 != nil:
    section.add "vmScaleSetName", valid_568799
  var valid_568800 = path.getOrDefault("resourceGroupName")
  valid_568800 = validateParameter(valid_568800, JString, required = true,
                                 default = nil)
  if valid_568800 != nil:
    section.add "resourceGroupName", valid_568800
  var valid_568801 = path.getOrDefault("subscriptionId")
  valid_568801 = validateParameter(valid_568801, JString, required = true,
                                 default = nil)
  if valid_568801 != nil:
    section.add "subscriptionId", valid_568801
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568802 = query.getOrDefault("api-version")
  valid_568802 = validateParameter(valid_568802, JString, required = true,
                                 default = nil)
  if valid_568802 != nil:
    section.add "api-version", valid_568802
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

proc call*(call_568804: Call_VirtualMachineScaleSetsReimageAll_568796;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reimages all the disks ( including data disks ) in the virtual machines in a VM scale set. This operation is only supported for managed disks.
  ## 
  let valid = call_568804.validator(path, query, header, formData, body)
  let scheme = call_568804.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568804.url(scheme.get, call_568804.host, call_568804.base,
                         call_568804.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568804, url, valid)

proc call*(call_568805: Call_VirtualMachineScaleSetsReimageAll_568796;
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
  var path_568806 = newJObject()
  var query_568807 = newJObject()
  var body_568808 = newJObject()
  add(path_568806, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568806, "resourceGroupName", newJString(resourceGroupName))
  add(query_568807, "api-version", newJString(apiVersion))
  add(path_568806, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568808 = vmInstanceIDs
  result = call_568805.call(path_568806, query_568807, nil, nil, body_568808)

var virtualMachineScaleSetsReimageAll* = Call_VirtualMachineScaleSetsReimageAll_568796(
    name: "virtualMachineScaleSetsReimageAll", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/reimageall",
    validator: validate_VirtualMachineScaleSetsReimageAll_568797, base: "",
    url: url_VirtualMachineScaleSetsReimageAll_568798, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsRestart_568809 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsRestart_568811(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsRestart_568810(path: JsonNode;
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
  var valid_568812 = path.getOrDefault("vmScaleSetName")
  valid_568812 = validateParameter(valid_568812, JString, required = true,
                                 default = nil)
  if valid_568812 != nil:
    section.add "vmScaleSetName", valid_568812
  var valid_568813 = path.getOrDefault("resourceGroupName")
  valid_568813 = validateParameter(valid_568813, JString, required = true,
                                 default = nil)
  if valid_568813 != nil:
    section.add "resourceGroupName", valid_568813
  var valid_568814 = path.getOrDefault("subscriptionId")
  valid_568814 = validateParameter(valid_568814, JString, required = true,
                                 default = nil)
  if valid_568814 != nil:
    section.add "subscriptionId", valid_568814
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568815 = query.getOrDefault("api-version")
  valid_568815 = validateParameter(valid_568815, JString, required = true,
                                 default = nil)
  if valid_568815 != nil:
    section.add "api-version", valid_568815
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

proc call*(call_568817: Call_VirtualMachineScaleSetsRestart_568809; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts one or more virtual machines in a VM scale set.
  ## 
  let valid = call_568817.validator(path, query, header, formData, body)
  let scheme = call_568817.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568817.url(scheme.get, call_568817.host, call_568817.base,
                         call_568817.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568817, url, valid)

proc call*(call_568818: Call_VirtualMachineScaleSetsRestart_568809;
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
  var path_568819 = newJObject()
  var query_568820 = newJObject()
  var body_568821 = newJObject()
  add(path_568819, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568819, "resourceGroupName", newJString(resourceGroupName))
  add(query_568820, "api-version", newJString(apiVersion))
  add(path_568819, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568821 = vmInstanceIDs
  result = call_568818.call(path_568819, query_568820, nil, nil, body_568821)

var virtualMachineScaleSetsRestart* = Call_VirtualMachineScaleSetsRestart_568809(
    name: "virtualMachineScaleSetsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/restart",
    validator: validate_VirtualMachineScaleSetsRestart_568810, base: "",
    url: url_VirtualMachineScaleSetsRestart_568811, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesCancel_568822 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetRollingUpgradesCancel_568824(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetRollingUpgradesCancel_568823(path: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_568829: Call_VirtualMachineScaleSetRollingUpgradesCancel_568822;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the current virtual machine scale set rolling upgrade.
  ## 
  let valid = call_568829.validator(path, query, header, formData, body)
  let scheme = call_568829.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568829.url(scheme.get, call_568829.host, call_568829.base,
                         call_568829.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568829, url, valid)

proc call*(call_568830: Call_VirtualMachineScaleSetRollingUpgradesCancel_568822;
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
  var path_568831 = newJObject()
  var query_568832 = newJObject()
  add(path_568831, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568831, "resourceGroupName", newJString(resourceGroupName))
  add(query_568832, "api-version", newJString(apiVersion))
  add(path_568831, "subscriptionId", newJString(subscriptionId))
  result = call_568830.call(path_568831, query_568832, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesCancel* = Call_VirtualMachineScaleSetRollingUpgradesCancel_568822(
    name: "virtualMachineScaleSetRollingUpgradesCancel",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/rollingUpgrades/cancel",
    validator: validate_VirtualMachineScaleSetRollingUpgradesCancel_568823,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesCancel_568824,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesGetLatest_568833 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetRollingUpgradesGetLatest_568835(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetRollingUpgradesGetLatest_568834(
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
  var valid_568836 = path.getOrDefault("vmScaleSetName")
  valid_568836 = validateParameter(valid_568836, JString, required = true,
                                 default = nil)
  if valid_568836 != nil:
    section.add "vmScaleSetName", valid_568836
  var valid_568837 = path.getOrDefault("resourceGroupName")
  valid_568837 = validateParameter(valid_568837, JString, required = true,
                                 default = nil)
  if valid_568837 != nil:
    section.add "resourceGroupName", valid_568837
  var valid_568838 = path.getOrDefault("subscriptionId")
  valid_568838 = validateParameter(valid_568838, JString, required = true,
                                 default = nil)
  if valid_568838 != nil:
    section.add "subscriptionId", valid_568838
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568839 = query.getOrDefault("api-version")
  valid_568839 = validateParameter(valid_568839, JString, required = true,
                                 default = nil)
  if valid_568839 != nil:
    section.add "api-version", valid_568839
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568840: Call_VirtualMachineScaleSetRollingUpgradesGetLatest_568833;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of the latest virtual machine scale set rolling upgrade.
  ## 
  let valid = call_568840.validator(path, query, header, formData, body)
  let scheme = call_568840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568840.url(scheme.get, call_568840.host, call_568840.base,
                         call_568840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568840, url, valid)

proc call*(call_568841: Call_VirtualMachineScaleSetRollingUpgradesGetLatest_568833;
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
  var path_568842 = newJObject()
  var query_568843 = newJObject()
  add(path_568842, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568842, "resourceGroupName", newJString(resourceGroupName))
  add(query_568843, "api-version", newJString(apiVersion))
  add(path_568842, "subscriptionId", newJString(subscriptionId))
  result = call_568841.call(path_568842, query_568843, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesGetLatest* = Call_VirtualMachineScaleSetRollingUpgradesGetLatest_568833(
    name: "virtualMachineScaleSetRollingUpgradesGetLatest",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/rollingUpgrades/latest",
    validator: validate_VirtualMachineScaleSetRollingUpgradesGetLatest_568834,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesGetLatest_568835,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsListSkus_568844 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsListSkus_568846(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsListSkus_568845(path: JsonNode;
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
  var valid_568847 = path.getOrDefault("vmScaleSetName")
  valid_568847 = validateParameter(valid_568847, JString, required = true,
                                 default = nil)
  if valid_568847 != nil:
    section.add "vmScaleSetName", valid_568847
  var valid_568848 = path.getOrDefault("resourceGroupName")
  valid_568848 = validateParameter(valid_568848, JString, required = true,
                                 default = nil)
  if valid_568848 != nil:
    section.add "resourceGroupName", valid_568848
  var valid_568849 = path.getOrDefault("subscriptionId")
  valid_568849 = validateParameter(valid_568849, JString, required = true,
                                 default = nil)
  if valid_568849 != nil:
    section.add "subscriptionId", valid_568849
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568850 = query.getOrDefault("api-version")
  valid_568850 = validateParameter(valid_568850, JString, required = true,
                                 default = nil)
  if valid_568850 != nil:
    section.add "api-version", valid_568850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568851: Call_VirtualMachineScaleSetsListSkus_568844;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of SKUs available for your VM scale set, including the minimum and maximum VM instances allowed for each SKU.
  ## 
  let valid = call_568851.validator(path, query, header, formData, body)
  let scheme = call_568851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568851.url(scheme.get, call_568851.host, call_568851.base,
                         call_568851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568851, url, valid)

proc call*(call_568852: Call_VirtualMachineScaleSetsListSkus_568844;
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
  var path_568853 = newJObject()
  var query_568854 = newJObject()
  add(path_568853, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568853, "resourceGroupName", newJString(resourceGroupName))
  add(query_568854, "api-version", newJString(apiVersion))
  add(path_568853, "subscriptionId", newJString(subscriptionId))
  result = call_568852.call(path_568853, query_568854, nil, nil, nil)

var virtualMachineScaleSetsListSkus* = Call_VirtualMachineScaleSetsListSkus_568844(
    name: "virtualMachineScaleSetsListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/skus",
    validator: validate_VirtualMachineScaleSetsListSkus_568845, base: "",
    url: url_VirtualMachineScaleSetsListSkus_568846, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsStart_568855 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsStart_568857(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsStart_568856(path: JsonNode; query: JsonNode;
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
  var valid_568858 = path.getOrDefault("vmScaleSetName")
  valid_568858 = validateParameter(valid_568858, JString, required = true,
                                 default = nil)
  if valid_568858 != nil:
    section.add "vmScaleSetName", valid_568858
  var valid_568859 = path.getOrDefault("resourceGroupName")
  valid_568859 = validateParameter(valid_568859, JString, required = true,
                                 default = nil)
  if valid_568859 != nil:
    section.add "resourceGroupName", valid_568859
  var valid_568860 = path.getOrDefault("subscriptionId")
  valid_568860 = validateParameter(valid_568860, JString, required = true,
                                 default = nil)
  if valid_568860 != nil:
    section.add "subscriptionId", valid_568860
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568861 = query.getOrDefault("api-version")
  valid_568861 = validateParameter(valid_568861, JString, required = true,
                                 default = nil)
  if valid_568861 != nil:
    section.add "api-version", valid_568861
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

proc call*(call_568863: Call_VirtualMachineScaleSetsStart_568855; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts one or more virtual machines in a VM scale set.
  ## 
  let valid = call_568863.validator(path, query, header, formData, body)
  let scheme = call_568863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568863.url(scheme.get, call_568863.host, call_568863.base,
                         call_568863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568863, url, valid)

proc call*(call_568864: Call_VirtualMachineScaleSetsStart_568855;
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
  var path_568865 = newJObject()
  var query_568866 = newJObject()
  var body_568867 = newJObject()
  add(path_568865, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568865, "resourceGroupName", newJString(resourceGroupName))
  add(query_568866, "api-version", newJString(apiVersion))
  add(path_568865, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568867 = vmInstanceIDs
  result = call_568864.call(path_568865, query_568866, nil, nil, body_568867)

var virtualMachineScaleSetsStart* = Call_VirtualMachineScaleSetsStart_568855(
    name: "virtualMachineScaleSetsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/start",
    validator: validate_VirtualMachineScaleSetsStart_568856, base: "",
    url: url_VirtualMachineScaleSetsStart_568857, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsUpdate_568880 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsUpdate_568882(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsUpdate_568881(path: JsonNode;
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
  var valid_568883 = path.getOrDefault("vmScaleSetName")
  valid_568883 = validateParameter(valid_568883, JString, required = true,
                                 default = nil)
  if valid_568883 != nil:
    section.add "vmScaleSetName", valid_568883
  var valid_568884 = path.getOrDefault("resourceGroupName")
  valid_568884 = validateParameter(valid_568884, JString, required = true,
                                 default = nil)
  if valid_568884 != nil:
    section.add "resourceGroupName", valid_568884
  var valid_568885 = path.getOrDefault("subscriptionId")
  valid_568885 = validateParameter(valid_568885, JString, required = true,
                                 default = nil)
  if valid_568885 != nil:
    section.add "subscriptionId", valid_568885
  var valid_568886 = path.getOrDefault("instanceId")
  valid_568886 = validateParameter(valid_568886, JString, required = true,
                                 default = nil)
  if valid_568886 != nil:
    section.add "instanceId", valid_568886
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568887 = query.getOrDefault("api-version")
  valid_568887 = validateParameter(valid_568887, JString, required = true,
                                 default = nil)
  if valid_568887 != nil:
    section.add "api-version", valid_568887
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

proc call*(call_568889: Call_VirtualMachineScaleSetVMsUpdate_568880;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a virtual machine of a VM scale set.
  ## 
  let valid = call_568889.validator(path, query, header, formData, body)
  let scheme = call_568889.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568889.url(scheme.get, call_568889.host, call_568889.base,
                         call_568889.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568889, url, valid)

proc call*(call_568890: Call_VirtualMachineScaleSetVMsUpdate_568880;
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
  var path_568891 = newJObject()
  var query_568892 = newJObject()
  var body_568893 = newJObject()
  add(path_568891, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568891, "resourceGroupName", newJString(resourceGroupName))
  add(query_568892, "api-version", newJString(apiVersion))
  add(path_568891, "subscriptionId", newJString(subscriptionId))
  add(path_568891, "instanceId", newJString(instanceId))
  if parameters != nil:
    body_568893 = parameters
  result = call_568890.call(path_568891, query_568892, nil, nil, body_568893)

var virtualMachineScaleSetVMsUpdate* = Call_VirtualMachineScaleSetVMsUpdate_568880(
    name: "virtualMachineScaleSetVMsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsUpdate_568881, base: "",
    url: url_VirtualMachineScaleSetVMsUpdate_568882, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsGet_568868 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsGet_568870(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsGet_568869(path: JsonNode; query: JsonNode;
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
  var valid_568871 = path.getOrDefault("vmScaleSetName")
  valid_568871 = validateParameter(valid_568871, JString, required = true,
                                 default = nil)
  if valid_568871 != nil:
    section.add "vmScaleSetName", valid_568871
  var valid_568872 = path.getOrDefault("resourceGroupName")
  valid_568872 = validateParameter(valid_568872, JString, required = true,
                                 default = nil)
  if valid_568872 != nil:
    section.add "resourceGroupName", valid_568872
  var valid_568873 = path.getOrDefault("subscriptionId")
  valid_568873 = validateParameter(valid_568873, JString, required = true,
                                 default = nil)
  if valid_568873 != nil:
    section.add "subscriptionId", valid_568873
  var valid_568874 = path.getOrDefault("instanceId")
  valid_568874 = validateParameter(valid_568874, JString, required = true,
                                 default = nil)
  if valid_568874 != nil:
    section.add "instanceId", valid_568874
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568875 = query.getOrDefault("api-version")
  valid_568875 = validateParameter(valid_568875, JString, required = true,
                                 default = nil)
  if valid_568875 != nil:
    section.add "api-version", valid_568875
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568876: Call_VirtualMachineScaleSetVMsGet_568868; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a virtual machine from a VM scale set.
  ## 
  let valid = call_568876.validator(path, query, header, formData, body)
  let scheme = call_568876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568876.url(scheme.get, call_568876.host, call_568876.base,
                         call_568876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568876, url, valid)

proc call*(call_568877: Call_VirtualMachineScaleSetVMsGet_568868;
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
  var path_568878 = newJObject()
  var query_568879 = newJObject()
  add(path_568878, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568878, "resourceGroupName", newJString(resourceGroupName))
  add(query_568879, "api-version", newJString(apiVersion))
  add(path_568878, "subscriptionId", newJString(subscriptionId))
  add(path_568878, "instanceId", newJString(instanceId))
  result = call_568877.call(path_568878, query_568879, nil, nil, nil)

var virtualMachineScaleSetVMsGet* = Call_VirtualMachineScaleSetVMsGet_568868(
    name: "virtualMachineScaleSetVMsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsGet_568869, base: "",
    url: url_VirtualMachineScaleSetVMsGet_568870, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsDelete_568894 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsDelete_568896(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsDelete_568895(path: JsonNode;
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
  var valid_568897 = path.getOrDefault("vmScaleSetName")
  valid_568897 = validateParameter(valid_568897, JString, required = true,
                                 default = nil)
  if valid_568897 != nil:
    section.add "vmScaleSetName", valid_568897
  var valid_568898 = path.getOrDefault("resourceGroupName")
  valid_568898 = validateParameter(valid_568898, JString, required = true,
                                 default = nil)
  if valid_568898 != nil:
    section.add "resourceGroupName", valid_568898
  var valid_568899 = path.getOrDefault("subscriptionId")
  valid_568899 = validateParameter(valid_568899, JString, required = true,
                                 default = nil)
  if valid_568899 != nil:
    section.add "subscriptionId", valid_568899
  var valid_568900 = path.getOrDefault("instanceId")
  valid_568900 = validateParameter(valid_568900, JString, required = true,
                                 default = nil)
  if valid_568900 != nil:
    section.add "instanceId", valid_568900
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568901 = query.getOrDefault("api-version")
  valid_568901 = validateParameter(valid_568901, JString, required = true,
                                 default = nil)
  if valid_568901 != nil:
    section.add "api-version", valid_568901
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568902: Call_VirtualMachineScaleSetVMsDelete_568894;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a virtual machine from a VM scale set.
  ## 
  let valid = call_568902.validator(path, query, header, formData, body)
  let scheme = call_568902.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568902.url(scheme.get, call_568902.host, call_568902.base,
                         call_568902.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568902, url, valid)

proc call*(call_568903: Call_VirtualMachineScaleSetVMsDelete_568894;
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
  var path_568904 = newJObject()
  var query_568905 = newJObject()
  add(path_568904, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568904, "resourceGroupName", newJString(resourceGroupName))
  add(query_568905, "api-version", newJString(apiVersion))
  add(path_568904, "subscriptionId", newJString(subscriptionId))
  add(path_568904, "instanceId", newJString(instanceId))
  result = call_568903.call(path_568904, query_568905, nil, nil, nil)

var virtualMachineScaleSetVMsDelete* = Call_VirtualMachineScaleSetVMsDelete_568894(
    name: "virtualMachineScaleSetVMsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsDelete_568895, base: "",
    url: url_VirtualMachineScaleSetVMsDelete_568896, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsDeallocate_568906 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsDeallocate_568908(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsDeallocate_568907(path: JsonNode;
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
  var valid_568909 = path.getOrDefault("vmScaleSetName")
  valid_568909 = validateParameter(valid_568909, JString, required = true,
                                 default = nil)
  if valid_568909 != nil:
    section.add "vmScaleSetName", valid_568909
  var valid_568910 = path.getOrDefault("resourceGroupName")
  valid_568910 = validateParameter(valid_568910, JString, required = true,
                                 default = nil)
  if valid_568910 != nil:
    section.add "resourceGroupName", valid_568910
  var valid_568911 = path.getOrDefault("subscriptionId")
  valid_568911 = validateParameter(valid_568911, JString, required = true,
                                 default = nil)
  if valid_568911 != nil:
    section.add "subscriptionId", valid_568911
  var valid_568912 = path.getOrDefault("instanceId")
  valid_568912 = validateParameter(valid_568912, JString, required = true,
                                 default = nil)
  if valid_568912 != nil:
    section.add "instanceId", valid_568912
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568913 = query.getOrDefault("api-version")
  valid_568913 = validateParameter(valid_568913, JString, required = true,
                                 default = nil)
  if valid_568913 != nil:
    section.add "api-version", valid_568913
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568914: Call_VirtualMachineScaleSetVMsDeallocate_568906;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deallocates a specific virtual machine in a VM scale set. Shuts down the virtual machine and releases the compute resources it uses. You are not billed for the compute resources of this virtual machine once it is deallocated.
  ## 
  let valid = call_568914.validator(path, query, header, formData, body)
  let scheme = call_568914.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568914.url(scheme.get, call_568914.host, call_568914.base,
                         call_568914.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568914, url, valid)

proc call*(call_568915: Call_VirtualMachineScaleSetVMsDeallocate_568906;
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
  var path_568916 = newJObject()
  var query_568917 = newJObject()
  add(path_568916, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568916, "resourceGroupName", newJString(resourceGroupName))
  add(query_568917, "api-version", newJString(apiVersion))
  add(path_568916, "subscriptionId", newJString(subscriptionId))
  add(path_568916, "instanceId", newJString(instanceId))
  result = call_568915.call(path_568916, query_568917, nil, nil, nil)

var virtualMachineScaleSetVMsDeallocate* = Call_VirtualMachineScaleSetVMsDeallocate_568906(
    name: "virtualMachineScaleSetVMsDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/deallocate",
    validator: validate_VirtualMachineScaleSetVMsDeallocate_568907, base: "",
    url: url_VirtualMachineScaleSetVMsDeallocate_568908, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsGetInstanceView_568918 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsGetInstanceView_568920(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetVMsGetInstanceView_568919(path: JsonNode;
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
  var valid_568921 = path.getOrDefault("vmScaleSetName")
  valid_568921 = validateParameter(valid_568921, JString, required = true,
                                 default = nil)
  if valid_568921 != nil:
    section.add "vmScaleSetName", valid_568921
  var valid_568922 = path.getOrDefault("resourceGroupName")
  valid_568922 = validateParameter(valid_568922, JString, required = true,
                                 default = nil)
  if valid_568922 != nil:
    section.add "resourceGroupName", valid_568922
  var valid_568923 = path.getOrDefault("subscriptionId")
  valid_568923 = validateParameter(valid_568923, JString, required = true,
                                 default = nil)
  if valid_568923 != nil:
    section.add "subscriptionId", valid_568923
  var valid_568924 = path.getOrDefault("instanceId")
  valid_568924 = validateParameter(valid_568924, JString, required = true,
                                 default = nil)
  if valid_568924 != nil:
    section.add "instanceId", valid_568924
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568925 = query.getOrDefault("api-version")
  valid_568925 = validateParameter(valid_568925, JString, required = true,
                                 default = nil)
  if valid_568925 != nil:
    section.add "api-version", valid_568925
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568926: Call_VirtualMachineScaleSetVMsGetInstanceView_568918;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of a virtual machine from a VM scale set.
  ## 
  let valid = call_568926.validator(path, query, header, formData, body)
  let scheme = call_568926.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568926.url(scheme.get, call_568926.host, call_568926.base,
                         call_568926.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568926, url, valid)

proc call*(call_568927: Call_VirtualMachineScaleSetVMsGetInstanceView_568918;
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
  var path_568928 = newJObject()
  var query_568929 = newJObject()
  add(path_568928, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568928, "resourceGroupName", newJString(resourceGroupName))
  add(query_568929, "api-version", newJString(apiVersion))
  add(path_568928, "subscriptionId", newJString(subscriptionId))
  add(path_568928, "instanceId", newJString(instanceId))
  result = call_568927.call(path_568928, query_568929, nil, nil, nil)

var virtualMachineScaleSetVMsGetInstanceView* = Call_VirtualMachineScaleSetVMsGetInstanceView_568918(
    name: "virtualMachineScaleSetVMsGetInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/instanceView",
    validator: validate_VirtualMachineScaleSetVMsGetInstanceView_568919, base: "",
    url: url_VirtualMachineScaleSetVMsGetInstanceView_568920,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsPerformMaintenance_568930 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsPerformMaintenance_568932(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetVMsPerformMaintenance_568931(path: JsonNode;
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
  var valid_568933 = path.getOrDefault("vmScaleSetName")
  valid_568933 = validateParameter(valid_568933, JString, required = true,
                                 default = nil)
  if valid_568933 != nil:
    section.add "vmScaleSetName", valid_568933
  var valid_568934 = path.getOrDefault("resourceGroupName")
  valid_568934 = validateParameter(valid_568934, JString, required = true,
                                 default = nil)
  if valid_568934 != nil:
    section.add "resourceGroupName", valid_568934
  var valid_568935 = path.getOrDefault("subscriptionId")
  valid_568935 = validateParameter(valid_568935, JString, required = true,
                                 default = nil)
  if valid_568935 != nil:
    section.add "subscriptionId", valid_568935
  var valid_568936 = path.getOrDefault("instanceId")
  valid_568936 = validateParameter(valid_568936, JString, required = true,
                                 default = nil)
  if valid_568936 != nil:
    section.add "instanceId", valid_568936
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568937 = query.getOrDefault("api-version")
  valid_568937 = validateParameter(valid_568937, JString, required = true,
                                 default = nil)
  if valid_568937 != nil:
    section.add "api-version", valid_568937
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568938: Call_VirtualMachineScaleSetVMsPerformMaintenance_568930;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Performs maintenance on a virtual machine in a VM scale set.
  ## 
  let valid = call_568938.validator(path, query, header, formData, body)
  let scheme = call_568938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568938.url(scheme.get, call_568938.host, call_568938.base,
                         call_568938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568938, url, valid)

proc call*(call_568939: Call_VirtualMachineScaleSetVMsPerformMaintenance_568930;
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
  var path_568940 = newJObject()
  var query_568941 = newJObject()
  add(path_568940, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568940, "resourceGroupName", newJString(resourceGroupName))
  add(query_568941, "api-version", newJString(apiVersion))
  add(path_568940, "subscriptionId", newJString(subscriptionId))
  add(path_568940, "instanceId", newJString(instanceId))
  result = call_568939.call(path_568940, query_568941, nil, nil, nil)

var virtualMachineScaleSetVMsPerformMaintenance* = Call_VirtualMachineScaleSetVMsPerformMaintenance_568930(
    name: "virtualMachineScaleSetVMsPerformMaintenance",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/performMaintenance",
    validator: validate_VirtualMachineScaleSetVMsPerformMaintenance_568931,
    base: "", url: url_VirtualMachineScaleSetVMsPerformMaintenance_568932,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsPowerOff_568942 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsPowerOff_568944(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsPowerOff_568943(path: JsonNode;
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
  var valid_568945 = path.getOrDefault("vmScaleSetName")
  valid_568945 = validateParameter(valid_568945, JString, required = true,
                                 default = nil)
  if valid_568945 != nil:
    section.add "vmScaleSetName", valid_568945
  var valid_568946 = path.getOrDefault("resourceGroupName")
  valid_568946 = validateParameter(valid_568946, JString, required = true,
                                 default = nil)
  if valid_568946 != nil:
    section.add "resourceGroupName", valid_568946
  var valid_568947 = path.getOrDefault("subscriptionId")
  valid_568947 = validateParameter(valid_568947, JString, required = true,
                                 default = nil)
  if valid_568947 != nil:
    section.add "subscriptionId", valid_568947
  var valid_568948 = path.getOrDefault("instanceId")
  valid_568948 = validateParameter(valid_568948, JString, required = true,
                                 default = nil)
  if valid_568948 != nil:
    section.add "instanceId", valid_568948
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568949 = query.getOrDefault("api-version")
  valid_568949 = validateParameter(valid_568949, JString, required = true,
                                 default = nil)
  if valid_568949 != nil:
    section.add "api-version", valid_568949
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568950: Call_VirtualMachineScaleSetVMsPowerOff_568942;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Power off (stop) a virtual machine in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  let valid = call_568950.validator(path, query, header, formData, body)
  let scheme = call_568950.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568950.url(scheme.get, call_568950.host, call_568950.base,
                         call_568950.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568950, url, valid)

proc call*(call_568951: Call_VirtualMachineScaleSetVMsPowerOff_568942;
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
  var path_568952 = newJObject()
  var query_568953 = newJObject()
  add(path_568952, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568952, "resourceGroupName", newJString(resourceGroupName))
  add(query_568953, "api-version", newJString(apiVersion))
  add(path_568952, "subscriptionId", newJString(subscriptionId))
  add(path_568952, "instanceId", newJString(instanceId))
  result = call_568951.call(path_568952, query_568953, nil, nil, nil)

var virtualMachineScaleSetVMsPowerOff* = Call_VirtualMachineScaleSetVMsPowerOff_568942(
    name: "virtualMachineScaleSetVMsPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/poweroff",
    validator: validate_VirtualMachineScaleSetVMsPowerOff_568943, base: "",
    url: url_VirtualMachineScaleSetVMsPowerOff_568944, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsRedeploy_568954 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsRedeploy_568956(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsRedeploy_568955(path: JsonNode;
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
  var valid_568957 = path.getOrDefault("vmScaleSetName")
  valid_568957 = validateParameter(valid_568957, JString, required = true,
                                 default = nil)
  if valid_568957 != nil:
    section.add "vmScaleSetName", valid_568957
  var valid_568958 = path.getOrDefault("resourceGroupName")
  valid_568958 = validateParameter(valid_568958, JString, required = true,
                                 default = nil)
  if valid_568958 != nil:
    section.add "resourceGroupName", valid_568958
  var valid_568959 = path.getOrDefault("subscriptionId")
  valid_568959 = validateParameter(valid_568959, JString, required = true,
                                 default = nil)
  if valid_568959 != nil:
    section.add "subscriptionId", valid_568959
  var valid_568960 = path.getOrDefault("instanceId")
  valid_568960 = validateParameter(valid_568960, JString, required = true,
                                 default = nil)
  if valid_568960 != nil:
    section.add "instanceId", valid_568960
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568961 = query.getOrDefault("api-version")
  valid_568961 = validateParameter(valid_568961, JString, required = true,
                                 default = nil)
  if valid_568961 != nil:
    section.add "api-version", valid_568961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568962: Call_VirtualMachineScaleSetVMsRedeploy_568954;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Shuts down the virtual machine in the virtual machine scale set, moves it to a new node, and powers it back on.
  ## 
  let valid = call_568962.validator(path, query, header, formData, body)
  let scheme = call_568962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568962.url(scheme.get, call_568962.host, call_568962.base,
                         call_568962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568962, url, valid)

proc call*(call_568963: Call_VirtualMachineScaleSetVMsRedeploy_568954;
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
  var path_568964 = newJObject()
  var query_568965 = newJObject()
  add(path_568964, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568964, "resourceGroupName", newJString(resourceGroupName))
  add(query_568965, "api-version", newJString(apiVersion))
  add(path_568964, "subscriptionId", newJString(subscriptionId))
  add(path_568964, "instanceId", newJString(instanceId))
  result = call_568963.call(path_568964, query_568965, nil, nil, nil)

var virtualMachineScaleSetVMsRedeploy* = Call_VirtualMachineScaleSetVMsRedeploy_568954(
    name: "virtualMachineScaleSetVMsRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/redeploy",
    validator: validate_VirtualMachineScaleSetVMsRedeploy_568955, base: "",
    url: url_VirtualMachineScaleSetVMsRedeploy_568956, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsReimage_568966 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsReimage_568968(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsReimage_568967(path: JsonNode;
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
  var valid_568969 = path.getOrDefault("vmScaleSetName")
  valid_568969 = validateParameter(valid_568969, JString, required = true,
                                 default = nil)
  if valid_568969 != nil:
    section.add "vmScaleSetName", valid_568969
  var valid_568970 = path.getOrDefault("resourceGroupName")
  valid_568970 = validateParameter(valid_568970, JString, required = true,
                                 default = nil)
  if valid_568970 != nil:
    section.add "resourceGroupName", valid_568970
  var valid_568971 = path.getOrDefault("subscriptionId")
  valid_568971 = validateParameter(valid_568971, JString, required = true,
                                 default = nil)
  if valid_568971 != nil:
    section.add "subscriptionId", valid_568971
  var valid_568972 = path.getOrDefault("instanceId")
  valid_568972 = validateParameter(valid_568972, JString, required = true,
                                 default = nil)
  if valid_568972 != nil:
    section.add "instanceId", valid_568972
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568973 = query.getOrDefault("api-version")
  valid_568973 = validateParameter(valid_568973, JString, required = true,
                                 default = nil)
  if valid_568973 != nil:
    section.add "api-version", valid_568973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568974: Call_VirtualMachineScaleSetVMsReimage_568966;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reimages (upgrade the operating system) a specific virtual machine in a VM scale set.
  ## 
  let valid = call_568974.validator(path, query, header, formData, body)
  let scheme = call_568974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568974.url(scheme.get, call_568974.host, call_568974.base,
                         call_568974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568974, url, valid)

proc call*(call_568975: Call_VirtualMachineScaleSetVMsReimage_568966;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
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
  var path_568976 = newJObject()
  var query_568977 = newJObject()
  add(path_568976, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568976, "resourceGroupName", newJString(resourceGroupName))
  add(query_568977, "api-version", newJString(apiVersion))
  add(path_568976, "subscriptionId", newJString(subscriptionId))
  add(path_568976, "instanceId", newJString(instanceId))
  result = call_568975.call(path_568976, query_568977, nil, nil, nil)

var virtualMachineScaleSetVMsReimage* = Call_VirtualMachineScaleSetVMsReimage_568966(
    name: "virtualMachineScaleSetVMsReimage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/reimage",
    validator: validate_VirtualMachineScaleSetVMsReimage_568967, base: "",
    url: url_VirtualMachineScaleSetVMsReimage_568968, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsReimageAll_568978 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsReimageAll_568980(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsReimageAll_568979(path: JsonNode;
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
  var valid_568981 = path.getOrDefault("vmScaleSetName")
  valid_568981 = validateParameter(valid_568981, JString, required = true,
                                 default = nil)
  if valid_568981 != nil:
    section.add "vmScaleSetName", valid_568981
  var valid_568982 = path.getOrDefault("resourceGroupName")
  valid_568982 = validateParameter(valid_568982, JString, required = true,
                                 default = nil)
  if valid_568982 != nil:
    section.add "resourceGroupName", valid_568982
  var valid_568983 = path.getOrDefault("subscriptionId")
  valid_568983 = validateParameter(valid_568983, JString, required = true,
                                 default = nil)
  if valid_568983 != nil:
    section.add "subscriptionId", valid_568983
  var valid_568984 = path.getOrDefault("instanceId")
  valid_568984 = validateParameter(valid_568984, JString, required = true,
                                 default = nil)
  if valid_568984 != nil:
    section.add "instanceId", valid_568984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568985 = query.getOrDefault("api-version")
  valid_568985 = validateParameter(valid_568985, JString, required = true,
                                 default = nil)
  if valid_568985 != nil:
    section.add "api-version", valid_568985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568986: Call_VirtualMachineScaleSetVMsReimageAll_568978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Allows you to re-image all the disks ( including data disks ) in the a VM scale set instance. This operation is only supported for managed disks.
  ## 
  let valid = call_568986.validator(path, query, header, formData, body)
  let scheme = call_568986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568986.url(scheme.get, call_568986.host, call_568986.base,
                         call_568986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568986, url, valid)

proc call*(call_568987: Call_VirtualMachineScaleSetVMsReimageAll_568978;
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
  var path_568988 = newJObject()
  var query_568989 = newJObject()
  add(path_568988, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568988, "resourceGroupName", newJString(resourceGroupName))
  add(query_568989, "api-version", newJString(apiVersion))
  add(path_568988, "subscriptionId", newJString(subscriptionId))
  add(path_568988, "instanceId", newJString(instanceId))
  result = call_568987.call(path_568988, query_568989, nil, nil, nil)

var virtualMachineScaleSetVMsReimageAll* = Call_VirtualMachineScaleSetVMsReimageAll_568978(
    name: "virtualMachineScaleSetVMsReimageAll", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/reimageall",
    validator: validate_VirtualMachineScaleSetVMsReimageAll_568979, base: "",
    url: url_VirtualMachineScaleSetVMsReimageAll_568980, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsRestart_568990 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsRestart_568992(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsRestart_568991(path: JsonNode;
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
  var valid_568993 = path.getOrDefault("vmScaleSetName")
  valid_568993 = validateParameter(valid_568993, JString, required = true,
                                 default = nil)
  if valid_568993 != nil:
    section.add "vmScaleSetName", valid_568993
  var valid_568994 = path.getOrDefault("resourceGroupName")
  valid_568994 = validateParameter(valid_568994, JString, required = true,
                                 default = nil)
  if valid_568994 != nil:
    section.add "resourceGroupName", valid_568994
  var valid_568995 = path.getOrDefault("subscriptionId")
  valid_568995 = validateParameter(valid_568995, JString, required = true,
                                 default = nil)
  if valid_568995 != nil:
    section.add "subscriptionId", valid_568995
  var valid_568996 = path.getOrDefault("instanceId")
  valid_568996 = validateParameter(valid_568996, JString, required = true,
                                 default = nil)
  if valid_568996 != nil:
    section.add "instanceId", valid_568996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568997 = query.getOrDefault("api-version")
  valid_568997 = validateParameter(valid_568997, JString, required = true,
                                 default = nil)
  if valid_568997 != nil:
    section.add "api-version", valid_568997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568998: Call_VirtualMachineScaleSetVMsRestart_568990;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Restarts a virtual machine in a VM scale set.
  ## 
  let valid = call_568998.validator(path, query, header, formData, body)
  let scheme = call_568998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568998.url(scheme.get, call_568998.host, call_568998.base,
                         call_568998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568998, url, valid)

proc call*(call_568999: Call_VirtualMachineScaleSetVMsRestart_568990;
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
  var path_569000 = newJObject()
  var query_569001 = newJObject()
  add(path_569000, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569000, "resourceGroupName", newJString(resourceGroupName))
  add(query_569001, "api-version", newJString(apiVersion))
  add(path_569000, "subscriptionId", newJString(subscriptionId))
  add(path_569000, "instanceId", newJString(instanceId))
  result = call_568999.call(path_569000, query_569001, nil, nil, nil)

var virtualMachineScaleSetVMsRestart* = Call_VirtualMachineScaleSetVMsRestart_568990(
    name: "virtualMachineScaleSetVMsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/restart",
    validator: validate_VirtualMachineScaleSetVMsRestart_568991, base: "",
    url: url_VirtualMachineScaleSetVMsRestart_568992, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsStart_569002 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsStart_569004(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsStart_569003(path: JsonNode;
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
  var valid_569005 = path.getOrDefault("vmScaleSetName")
  valid_569005 = validateParameter(valid_569005, JString, required = true,
                                 default = nil)
  if valid_569005 != nil:
    section.add "vmScaleSetName", valid_569005
  var valid_569006 = path.getOrDefault("resourceGroupName")
  valid_569006 = validateParameter(valid_569006, JString, required = true,
                                 default = nil)
  if valid_569006 != nil:
    section.add "resourceGroupName", valid_569006
  var valid_569007 = path.getOrDefault("subscriptionId")
  valid_569007 = validateParameter(valid_569007, JString, required = true,
                                 default = nil)
  if valid_569007 != nil:
    section.add "subscriptionId", valid_569007
  var valid_569008 = path.getOrDefault("instanceId")
  valid_569008 = validateParameter(valid_569008, JString, required = true,
                                 default = nil)
  if valid_569008 != nil:
    section.add "instanceId", valid_569008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569009 = query.getOrDefault("api-version")
  valid_569009 = validateParameter(valid_569009, JString, required = true,
                                 default = nil)
  if valid_569009 != nil:
    section.add "api-version", valid_569009
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569010: Call_VirtualMachineScaleSetVMsStart_569002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a virtual machine in a VM scale set.
  ## 
  let valid = call_569010.validator(path, query, header, formData, body)
  let scheme = call_569010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569010.url(scheme.get, call_569010.host, call_569010.base,
                         call_569010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569010, url, valid)

proc call*(call_569011: Call_VirtualMachineScaleSetVMsStart_569002;
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
  var path_569012 = newJObject()
  var query_569013 = newJObject()
  add(path_569012, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569012, "resourceGroupName", newJString(resourceGroupName))
  add(query_569013, "api-version", newJString(apiVersion))
  add(path_569012, "subscriptionId", newJString(subscriptionId))
  add(path_569012, "instanceId", newJString(instanceId))
  result = call_569011.call(path_569012, query_569013, nil, nil, nil)

var virtualMachineScaleSetVMsStart* = Call_VirtualMachineScaleSetVMsStart_569002(
    name: "virtualMachineScaleSetVMsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/start",
    validator: validate_VirtualMachineScaleSetVMsStart_569003, base: "",
    url: url_VirtualMachineScaleSetVMsStart_569004, schemes: {Scheme.Https})
type
  Call_VirtualMachinesList_569014 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesList_569016(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesList_569015(path: JsonNode; query: JsonNode;
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
  var valid_569017 = path.getOrDefault("resourceGroupName")
  valid_569017 = validateParameter(valid_569017, JString, required = true,
                                 default = nil)
  if valid_569017 != nil:
    section.add "resourceGroupName", valid_569017
  var valid_569018 = path.getOrDefault("subscriptionId")
  valid_569018 = validateParameter(valid_569018, JString, required = true,
                                 default = nil)
  if valid_569018 != nil:
    section.add "subscriptionId", valid_569018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569019 = query.getOrDefault("api-version")
  valid_569019 = validateParameter(valid_569019, JString, required = true,
                                 default = nil)
  if valid_569019 != nil:
    section.add "api-version", valid_569019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569020: Call_VirtualMachinesList_569014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the virtual machines in the specified resource group. Use the nextLink property in the response to get the next page of virtual machines.
  ## 
  let valid = call_569020.validator(path, query, header, formData, body)
  let scheme = call_569020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569020.url(scheme.get, call_569020.host, call_569020.base,
                         call_569020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569020, url, valid)

proc call*(call_569021: Call_VirtualMachinesList_569014; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachinesList
  ## Lists all of the virtual machines in the specified resource group. Use the nextLink property in the response to get the next page of virtual machines.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_569022 = newJObject()
  var query_569023 = newJObject()
  add(path_569022, "resourceGroupName", newJString(resourceGroupName))
  add(query_569023, "api-version", newJString(apiVersion))
  add(path_569022, "subscriptionId", newJString(subscriptionId))
  result = call_569021.call(path_569022, query_569023, nil, nil, nil)

var virtualMachinesList* = Call_VirtualMachinesList_569014(
    name: "virtualMachinesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines",
    validator: validate_VirtualMachinesList_569015, base: "",
    url: url_VirtualMachinesList_569016, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCreateOrUpdate_569049 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesCreateOrUpdate_569051(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesCreateOrUpdate_569050(path: JsonNode; query: JsonNode;
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
  var valid_569052 = path.getOrDefault("resourceGroupName")
  valid_569052 = validateParameter(valid_569052, JString, required = true,
                                 default = nil)
  if valid_569052 != nil:
    section.add "resourceGroupName", valid_569052
  var valid_569053 = path.getOrDefault("subscriptionId")
  valid_569053 = validateParameter(valid_569053, JString, required = true,
                                 default = nil)
  if valid_569053 != nil:
    section.add "subscriptionId", valid_569053
  var valid_569054 = path.getOrDefault("vmName")
  valid_569054 = validateParameter(valid_569054, JString, required = true,
                                 default = nil)
  if valid_569054 != nil:
    section.add "vmName", valid_569054
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569055 = query.getOrDefault("api-version")
  valid_569055 = validateParameter(valid_569055, JString, required = true,
                                 default = nil)
  if valid_569055 != nil:
    section.add "api-version", valid_569055
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

proc call*(call_569057: Call_VirtualMachinesCreateOrUpdate_569049; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a virtual machine.
  ## 
  let valid = call_569057.validator(path, query, header, formData, body)
  let scheme = call_569057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569057.url(scheme.get, call_569057.host, call_569057.base,
                         call_569057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569057, url, valid)

proc call*(call_569058: Call_VirtualMachinesCreateOrUpdate_569049;
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
  var path_569059 = newJObject()
  var query_569060 = newJObject()
  var body_569061 = newJObject()
  add(path_569059, "resourceGroupName", newJString(resourceGroupName))
  add(query_569060, "api-version", newJString(apiVersion))
  add(path_569059, "subscriptionId", newJString(subscriptionId))
  add(path_569059, "vmName", newJString(vmName))
  if parameters != nil:
    body_569061 = parameters
  result = call_569058.call(path_569059, query_569060, nil, nil, body_569061)

var virtualMachinesCreateOrUpdate* = Call_VirtualMachinesCreateOrUpdate_569049(
    name: "virtualMachinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesCreateOrUpdate_569050, base: "",
    url: url_VirtualMachinesCreateOrUpdate_569051, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGet_569024 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesGet_569026(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesGet_569025(path: JsonNode; query: JsonNode;
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
  var valid_569027 = path.getOrDefault("resourceGroupName")
  valid_569027 = validateParameter(valid_569027, JString, required = true,
                                 default = nil)
  if valid_569027 != nil:
    section.add "resourceGroupName", valid_569027
  var valid_569028 = path.getOrDefault("subscriptionId")
  valid_569028 = validateParameter(valid_569028, JString, required = true,
                                 default = nil)
  if valid_569028 != nil:
    section.add "subscriptionId", valid_569028
  var valid_569029 = path.getOrDefault("vmName")
  valid_569029 = validateParameter(valid_569029, JString, required = true,
                                 default = nil)
  if valid_569029 != nil:
    section.add "vmName", valid_569029
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_569043 = query.getOrDefault("$expand")
  valid_569043 = validateParameter(valid_569043, JString, required = false,
                                 default = newJString("instanceView"))
  if valid_569043 != nil:
    section.add "$expand", valid_569043
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569044 = query.getOrDefault("api-version")
  valid_569044 = validateParameter(valid_569044, JString, required = true,
                                 default = nil)
  if valid_569044 != nil:
    section.add "api-version", valid_569044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569045: Call_VirtualMachinesGet_569024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the model view or the instance view of a virtual machine.
  ## 
  let valid = call_569045.validator(path, query, header, formData, body)
  let scheme = call_569045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569045.url(scheme.get, call_569045.host, call_569045.base,
                         call_569045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569045, url, valid)

proc call*(call_569046: Call_VirtualMachinesGet_569024; resourceGroupName: string;
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
  var path_569047 = newJObject()
  var query_569048 = newJObject()
  add(path_569047, "resourceGroupName", newJString(resourceGroupName))
  add(query_569048, "$expand", newJString(Expand))
  add(query_569048, "api-version", newJString(apiVersion))
  add(path_569047, "subscriptionId", newJString(subscriptionId))
  add(path_569047, "vmName", newJString(vmName))
  result = call_569046.call(path_569047, query_569048, nil, nil, nil)

var virtualMachinesGet* = Call_VirtualMachinesGet_569024(
    name: "virtualMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesGet_569025, base: "",
    url: url_VirtualMachinesGet_569026, schemes: {Scheme.Https})
type
  Call_VirtualMachinesUpdate_569073 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesUpdate_569075(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesUpdate_569074(path: JsonNode; query: JsonNode;
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
  var valid_569076 = path.getOrDefault("resourceGroupName")
  valid_569076 = validateParameter(valid_569076, JString, required = true,
                                 default = nil)
  if valid_569076 != nil:
    section.add "resourceGroupName", valid_569076
  var valid_569077 = path.getOrDefault("subscriptionId")
  valid_569077 = validateParameter(valid_569077, JString, required = true,
                                 default = nil)
  if valid_569077 != nil:
    section.add "subscriptionId", valid_569077
  var valid_569078 = path.getOrDefault("vmName")
  valid_569078 = validateParameter(valid_569078, JString, required = true,
                                 default = nil)
  if valid_569078 != nil:
    section.add "vmName", valid_569078
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569079 = query.getOrDefault("api-version")
  valid_569079 = validateParameter(valid_569079, JString, required = true,
                                 default = nil)
  if valid_569079 != nil:
    section.add "api-version", valid_569079
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

proc call*(call_569081: Call_VirtualMachinesUpdate_569073; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a virtual machine.
  ## 
  let valid = call_569081.validator(path, query, header, formData, body)
  let scheme = call_569081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569081.url(scheme.get, call_569081.host, call_569081.base,
                         call_569081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569081, url, valid)

proc call*(call_569082: Call_VirtualMachinesUpdate_569073;
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
  var path_569083 = newJObject()
  var query_569084 = newJObject()
  var body_569085 = newJObject()
  add(path_569083, "resourceGroupName", newJString(resourceGroupName))
  add(query_569084, "api-version", newJString(apiVersion))
  add(path_569083, "subscriptionId", newJString(subscriptionId))
  add(path_569083, "vmName", newJString(vmName))
  if parameters != nil:
    body_569085 = parameters
  result = call_569082.call(path_569083, query_569084, nil, nil, body_569085)

var virtualMachinesUpdate* = Call_VirtualMachinesUpdate_569073(
    name: "virtualMachinesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesUpdate_569074, base: "",
    url: url_VirtualMachinesUpdate_569075, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDelete_569062 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesDelete_569064(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesDelete_569063(path: JsonNode; query: JsonNode;
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
  var valid_569065 = path.getOrDefault("resourceGroupName")
  valid_569065 = validateParameter(valid_569065, JString, required = true,
                                 default = nil)
  if valid_569065 != nil:
    section.add "resourceGroupName", valid_569065
  var valid_569066 = path.getOrDefault("subscriptionId")
  valid_569066 = validateParameter(valid_569066, JString, required = true,
                                 default = nil)
  if valid_569066 != nil:
    section.add "subscriptionId", valid_569066
  var valid_569067 = path.getOrDefault("vmName")
  valid_569067 = validateParameter(valid_569067, JString, required = true,
                                 default = nil)
  if valid_569067 != nil:
    section.add "vmName", valid_569067
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569068 = query.getOrDefault("api-version")
  valid_569068 = validateParameter(valid_569068, JString, required = true,
                                 default = nil)
  if valid_569068 != nil:
    section.add "api-version", valid_569068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569069: Call_VirtualMachinesDelete_569062; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a virtual machine.
  ## 
  let valid = call_569069.validator(path, query, header, formData, body)
  let scheme = call_569069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569069.url(scheme.get, call_569069.host, call_569069.base,
                         call_569069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569069, url, valid)

proc call*(call_569070: Call_VirtualMachinesDelete_569062;
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
  var path_569071 = newJObject()
  var query_569072 = newJObject()
  add(path_569071, "resourceGroupName", newJString(resourceGroupName))
  add(query_569072, "api-version", newJString(apiVersion))
  add(path_569071, "subscriptionId", newJString(subscriptionId))
  add(path_569071, "vmName", newJString(vmName))
  result = call_569070.call(path_569071, query_569072, nil, nil, nil)

var virtualMachinesDelete* = Call_VirtualMachinesDelete_569062(
    name: "virtualMachinesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesDelete_569063, base: "",
    url: url_VirtualMachinesDelete_569064, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCapture_569086 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesCapture_569088(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesCapture_569087(path: JsonNode; query: JsonNode;
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
  var valid_569089 = path.getOrDefault("resourceGroupName")
  valid_569089 = validateParameter(valid_569089, JString, required = true,
                                 default = nil)
  if valid_569089 != nil:
    section.add "resourceGroupName", valid_569089
  var valid_569090 = path.getOrDefault("subscriptionId")
  valid_569090 = validateParameter(valid_569090, JString, required = true,
                                 default = nil)
  if valid_569090 != nil:
    section.add "subscriptionId", valid_569090
  var valid_569091 = path.getOrDefault("vmName")
  valid_569091 = validateParameter(valid_569091, JString, required = true,
                                 default = nil)
  if valid_569091 != nil:
    section.add "vmName", valid_569091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569092 = query.getOrDefault("api-version")
  valid_569092 = validateParameter(valid_569092, JString, required = true,
                                 default = nil)
  if valid_569092 != nil:
    section.add "api-version", valid_569092
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

proc call*(call_569094: Call_VirtualMachinesCapture_569086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Captures the VM by copying virtual hard disks of the VM and outputs a template that can be used to create similar VMs.
  ## 
  let valid = call_569094.validator(path, query, header, formData, body)
  let scheme = call_569094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569094.url(scheme.get, call_569094.host, call_569094.base,
                         call_569094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569094, url, valid)

proc call*(call_569095: Call_VirtualMachinesCapture_569086;
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
  var path_569096 = newJObject()
  var query_569097 = newJObject()
  var body_569098 = newJObject()
  add(path_569096, "resourceGroupName", newJString(resourceGroupName))
  add(query_569097, "api-version", newJString(apiVersion))
  add(path_569096, "subscriptionId", newJString(subscriptionId))
  add(path_569096, "vmName", newJString(vmName))
  if parameters != nil:
    body_569098 = parameters
  result = call_569095.call(path_569096, query_569097, nil, nil, body_569098)

var virtualMachinesCapture* = Call_VirtualMachinesCapture_569086(
    name: "virtualMachinesCapture", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/capture",
    validator: validate_VirtualMachinesCapture_569087, base: "",
    url: url_VirtualMachinesCapture_569088, schemes: {Scheme.Https})
type
  Call_VirtualMachinesConvertToManagedDisks_569099 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesConvertToManagedDisks_569101(protocol: Scheme;
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

proc validate_VirtualMachinesConvertToManagedDisks_569100(path: JsonNode;
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
  var valid_569102 = path.getOrDefault("resourceGroupName")
  valid_569102 = validateParameter(valid_569102, JString, required = true,
                                 default = nil)
  if valid_569102 != nil:
    section.add "resourceGroupName", valid_569102
  var valid_569103 = path.getOrDefault("subscriptionId")
  valid_569103 = validateParameter(valid_569103, JString, required = true,
                                 default = nil)
  if valid_569103 != nil:
    section.add "subscriptionId", valid_569103
  var valid_569104 = path.getOrDefault("vmName")
  valid_569104 = validateParameter(valid_569104, JString, required = true,
                                 default = nil)
  if valid_569104 != nil:
    section.add "vmName", valid_569104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569105 = query.getOrDefault("api-version")
  valid_569105 = validateParameter(valid_569105, JString, required = true,
                                 default = nil)
  if valid_569105 != nil:
    section.add "api-version", valid_569105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569106: Call_VirtualMachinesConvertToManagedDisks_569099;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Converts virtual machine disks from blob-based to managed disks. Virtual machine must be stop-deallocated before invoking this operation.
  ## 
  let valid = call_569106.validator(path, query, header, formData, body)
  let scheme = call_569106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569106.url(scheme.get, call_569106.host, call_569106.base,
                         call_569106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569106, url, valid)

proc call*(call_569107: Call_VirtualMachinesConvertToManagedDisks_569099;
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
  var path_569108 = newJObject()
  var query_569109 = newJObject()
  add(path_569108, "resourceGroupName", newJString(resourceGroupName))
  add(query_569109, "api-version", newJString(apiVersion))
  add(path_569108, "subscriptionId", newJString(subscriptionId))
  add(path_569108, "vmName", newJString(vmName))
  result = call_569107.call(path_569108, query_569109, nil, nil, nil)

var virtualMachinesConvertToManagedDisks* = Call_VirtualMachinesConvertToManagedDisks_569099(
    name: "virtualMachinesConvertToManagedDisks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/convertToManagedDisks",
    validator: validate_VirtualMachinesConvertToManagedDisks_569100, base: "",
    url: url_VirtualMachinesConvertToManagedDisks_569101, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDeallocate_569110 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesDeallocate_569112(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesDeallocate_569111(path: JsonNode; query: JsonNode;
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
  var valid_569113 = path.getOrDefault("resourceGroupName")
  valid_569113 = validateParameter(valid_569113, JString, required = true,
                                 default = nil)
  if valid_569113 != nil:
    section.add "resourceGroupName", valid_569113
  var valid_569114 = path.getOrDefault("subscriptionId")
  valid_569114 = validateParameter(valid_569114, JString, required = true,
                                 default = nil)
  if valid_569114 != nil:
    section.add "subscriptionId", valid_569114
  var valid_569115 = path.getOrDefault("vmName")
  valid_569115 = validateParameter(valid_569115, JString, required = true,
                                 default = nil)
  if valid_569115 != nil:
    section.add "vmName", valid_569115
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569116 = query.getOrDefault("api-version")
  valid_569116 = validateParameter(valid_569116, JString, required = true,
                                 default = nil)
  if valid_569116 != nil:
    section.add "api-version", valid_569116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569117: Call_VirtualMachinesDeallocate_569110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shuts down the virtual machine and releases the compute resources. You are not billed for the compute resources that this virtual machine uses.
  ## 
  let valid = call_569117.validator(path, query, header, formData, body)
  let scheme = call_569117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569117.url(scheme.get, call_569117.host, call_569117.base,
                         call_569117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569117, url, valid)

proc call*(call_569118: Call_VirtualMachinesDeallocate_569110;
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
  var path_569119 = newJObject()
  var query_569120 = newJObject()
  add(path_569119, "resourceGroupName", newJString(resourceGroupName))
  add(query_569120, "api-version", newJString(apiVersion))
  add(path_569119, "subscriptionId", newJString(subscriptionId))
  add(path_569119, "vmName", newJString(vmName))
  result = call_569118.call(path_569119, query_569120, nil, nil, nil)

var virtualMachinesDeallocate* = Call_VirtualMachinesDeallocate_569110(
    name: "virtualMachinesDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/deallocate",
    validator: validate_VirtualMachinesDeallocate_569111, base: "",
    url: url_VirtualMachinesDeallocate_569112, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGetExtensions_569121 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesGetExtensions_569123(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesGetExtensions_569122(path: JsonNode; query: JsonNode;
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
  var valid_569124 = path.getOrDefault("resourceGroupName")
  valid_569124 = validateParameter(valid_569124, JString, required = true,
                                 default = nil)
  if valid_569124 != nil:
    section.add "resourceGroupName", valid_569124
  var valid_569125 = path.getOrDefault("subscriptionId")
  valid_569125 = validateParameter(valid_569125, JString, required = true,
                                 default = nil)
  if valid_569125 != nil:
    section.add "subscriptionId", valid_569125
  var valid_569126 = path.getOrDefault("vmName")
  valid_569126 = validateParameter(valid_569126, JString, required = true,
                                 default = nil)
  if valid_569126 != nil:
    section.add "vmName", valid_569126
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_569127 = query.getOrDefault("$expand")
  valid_569127 = validateParameter(valid_569127, JString, required = false,
                                 default = nil)
  if valid_569127 != nil:
    section.add "$expand", valid_569127
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569128 = query.getOrDefault("api-version")
  valid_569128 = validateParameter(valid_569128, JString, required = true,
                                 default = nil)
  if valid_569128 != nil:
    section.add "api-version", valid_569128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569129: Call_VirtualMachinesGetExtensions_569121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get all extensions of a Virtual Machine.
  ## 
  let valid = call_569129.validator(path, query, header, formData, body)
  let scheme = call_569129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569129.url(scheme.get, call_569129.host, call_569129.base,
                         call_569129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569129, url, valid)

proc call*(call_569130: Call_VirtualMachinesGetExtensions_569121;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string; Expand: string = ""): Recallable =
  ## virtualMachinesGetExtensions
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
  var path_569131 = newJObject()
  var query_569132 = newJObject()
  add(path_569131, "resourceGroupName", newJString(resourceGroupName))
  add(query_569132, "$expand", newJString(Expand))
  add(query_569132, "api-version", newJString(apiVersion))
  add(path_569131, "subscriptionId", newJString(subscriptionId))
  add(path_569131, "vmName", newJString(vmName))
  result = call_569130.call(path_569131, query_569132, nil, nil, nil)

var virtualMachinesGetExtensions* = Call_VirtualMachinesGetExtensions_569121(
    name: "virtualMachinesGetExtensions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions",
    validator: validate_VirtualMachinesGetExtensions_569122, base: "",
    url: url_VirtualMachinesGetExtensions_569123, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsCreateOrUpdate_569146 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionsCreateOrUpdate_569148(protocol: Scheme;
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

proc validate_VirtualMachineExtensionsCreateOrUpdate_569147(path: JsonNode;
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
  var valid_569149 = path.getOrDefault("resourceGroupName")
  valid_569149 = validateParameter(valid_569149, JString, required = true,
                                 default = nil)
  if valid_569149 != nil:
    section.add "resourceGroupName", valid_569149
  var valid_569150 = path.getOrDefault("vmExtensionName")
  valid_569150 = validateParameter(valid_569150, JString, required = true,
                                 default = nil)
  if valid_569150 != nil:
    section.add "vmExtensionName", valid_569150
  var valid_569151 = path.getOrDefault("subscriptionId")
  valid_569151 = validateParameter(valid_569151, JString, required = true,
                                 default = nil)
  if valid_569151 != nil:
    section.add "subscriptionId", valid_569151
  var valid_569152 = path.getOrDefault("vmName")
  valid_569152 = validateParameter(valid_569152, JString, required = true,
                                 default = nil)
  if valid_569152 != nil:
    section.add "vmName", valid_569152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569153 = query.getOrDefault("api-version")
  valid_569153 = validateParameter(valid_569153, JString, required = true,
                                 default = nil)
  if valid_569153 != nil:
    section.add "api-version", valid_569153
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

proc call*(call_569155: Call_VirtualMachineExtensionsCreateOrUpdate_569146;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update the extension.
  ## 
  let valid = call_569155.validator(path, query, header, formData, body)
  let scheme = call_569155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569155.url(scheme.get, call_569155.host, call_569155.base,
                         call_569155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569155, url, valid)

proc call*(call_569156: Call_VirtualMachineExtensionsCreateOrUpdate_569146;
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
  var path_569157 = newJObject()
  var query_569158 = newJObject()
  var body_569159 = newJObject()
  if extensionParameters != nil:
    body_569159 = extensionParameters
  add(path_569157, "resourceGroupName", newJString(resourceGroupName))
  add(query_569158, "api-version", newJString(apiVersion))
  add(path_569157, "vmExtensionName", newJString(vmExtensionName))
  add(path_569157, "subscriptionId", newJString(subscriptionId))
  add(path_569157, "vmName", newJString(vmName))
  result = call_569156.call(path_569157, query_569158, nil, nil, body_569159)

var virtualMachineExtensionsCreateOrUpdate* = Call_VirtualMachineExtensionsCreateOrUpdate_569146(
    name: "virtualMachineExtensionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsCreateOrUpdate_569147, base: "",
    url: url_VirtualMachineExtensionsCreateOrUpdate_569148,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsGet_569133 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionsGet_569135(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionsGet_569134(path: JsonNode; query: JsonNode;
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
  var valid_569136 = path.getOrDefault("resourceGroupName")
  valid_569136 = validateParameter(valid_569136, JString, required = true,
                                 default = nil)
  if valid_569136 != nil:
    section.add "resourceGroupName", valid_569136
  var valid_569137 = path.getOrDefault("vmExtensionName")
  valid_569137 = validateParameter(valid_569137, JString, required = true,
                                 default = nil)
  if valid_569137 != nil:
    section.add "vmExtensionName", valid_569137
  var valid_569138 = path.getOrDefault("subscriptionId")
  valid_569138 = validateParameter(valid_569138, JString, required = true,
                                 default = nil)
  if valid_569138 != nil:
    section.add "subscriptionId", valid_569138
  var valid_569139 = path.getOrDefault("vmName")
  valid_569139 = validateParameter(valid_569139, JString, required = true,
                                 default = nil)
  if valid_569139 != nil:
    section.add "vmName", valid_569139
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_569140 = query.getOrDefault("$expand")
  valid_569140 = validateParameter(valid_569140, JString, required = false,
                                 default = nil)
  if valid_569140 != nil:
    section.add "$expand", valid_569140
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569141 = query.getOrDefault("api-version")
  valid_569141 = validateParameter(valid_569141, JString, required = true,
                                 default = nil)
  if valid_569141 != nil:
    section.add "api-version", valid_569141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569142: Call_VirtualMachineExtensionsGet_569133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get the extension.
  ## 
  let valid = call_569142.validator(path, query, header, formData, body)
  let scheme = call_569142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569142.url(scheme.get, call_569142.host, call_569142.base,
                         call_569142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569142, url, valid)

proc call*(call_569143: Call_VirtualMachineExtensionsGet_569133;
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
  var path_569144 = newJObject()
  var query_569145 = newJObject()
  add(path_569144, "resourceGroupName", newJString(resourceGroupName))
  add(query_569145, "$expand", newJString(Expand))
  add(query_569145, "api-version", newJString(apiVersion))
  add(path_569144, "vmExtensionName", newJString(vmExtensionName))
  add(path_569144, "subscriptionId", newJString(subscriptionId))
  add(path_569144, "vmName", newJString(vmName))
  result = call_569143.call(path_569144, query_569145, nil, nil, nil)

var virtualMachineExtensionsGet* = Call_VirtualMachineExtensionsGet_569133(
    name: "virtualMachineExtensionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsGet_569134, base: "",
    url: url_VirtualMachineExtensionsGet_569135, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsUpdate_569172 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionsUpdate_569174(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionsUpdate_569173(path: JsonNode;
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
  var valid_569175 = path.getOrDefault("resourceGroupName")
  valid_569175 = validateParameter(valid_569175, JString, required = true,
                                 default = nil)
  if valid_569175 != nil:
    section.add "resourceGroupName", valid_569175
  var valid_569176 = path.getOrDefault("vmExtensionName")
  valid_569176 = validateParameter(valid_569176, JString, required = true,
                                 default = nil)
  if valid_569176 != nil:
    section.add "vmExtensionName", valid_569176
  var valid_569177 = path.getOrDefault("subscriptionId")
  valid_569177 = validateParameter(valid_569177, JString, required = true,
                                 default = nil)
  if valid_569177 != nil:
    section.add "subscriptionId", valid_569177
  var valid_569178 = path.getOrDefault("vmName")
  valid_569178 = validateParameter(valid_569178, JString, required = true,
                                 default = nil)
  if valid_569178 != nil:
    section.add "vmName", valid_569178
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569179 = query.getOrDefault("api-version")
  valid_569179 = validateParameter(valid_569179, JString, required = true,
                                 default = nil)
  if valid_569179 != nil:
    section.add "api-version", valid_569179
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

proc call*(call_569181: Call_VirtualMachineExtensionsUpdate_569172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update the extension.
  ## 
  let valid = call_569181.validator(path, query, header, formData, body)
  let scheme = call_569181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569181.url(scheme.get, call_569181.host, call_569181.base,
                         call_569181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569181, url, valid)

proc call*(call_569182: Call_VirtualMachineExtensionsUpdate_569172;
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
  var path_569183 = newJObject()
  var query_569184 = newJObject()
  var body_569185 = newJObject()
  if extensionParameters != nil:
    body_569185 = extensionParameters
  add(path_569183, "resourceGroupName", newJString(resourceGroupName))
  add(query_569184, "api-version", newJString(apiVersion))
  add(path_569183, "vmExtensionName", newJString(vmExtensionName))
  add(path_569183, "subscriptionId", newJString(subscriptionId))
  add(path_569183, "vmName", newJString(vmName))
  result = call_569182.call(path_569183, query_569184, nil, nil, body_569185)

var virtualMachineExtensionsUpdate* = Call_VirtualMachineExtensionsUpdate_569172(
    name: "virtualMachineExtensionsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsUpdate_569173, base: "",
    url: url_VirtualMachineExtensionsUpdate_569174, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsDelete_569160 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionsDelete_569162(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionsDelete_569161(path: JsonNode;
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
  var valid_569163 = path.getOrDefault("resourceGroupName")
  valid_569163 = validateParameter(valid_569163, JString, required = true,
                                 default = nil)
  if valid_569163 != nil:
    section.add "resourceGroupName", valid_569163
  var valid_569164 = path.getOrDefault("vmExtensionName")
  valid_569164 = validateParameter(valid_569164, JString, required = true,
                                 default = nil)
  if valid_569164 != nil:
    section.add "vmExtensionName", valid_569164
  var valid_569165 = path.getOrDefault("subscriptionId")
  valid_569165 = validateParameter(valid_569165, JString, required = true,
                                 default = nil)
  if valid_569165 != nil:
    section.add "subscriptionId", valid_569165
  var valid_569166 = path.getOrDefault("vmName")
  valid_569166 = validateParameter(valid_569166, JString, required = true,
                                 default = nil)
  if valid_569166 != nil:
    section.add "vmName", valid_569166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569167 = query.getOrDefault("api-version")
  valid_569167 = validateParameter(valid_569167, JString, required = true,
                                 default = nil)
  if valid_569167 != nil:
    section.add "api-version", valid_569167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569168: Call_VirtualMachineExtensionsDelete_569160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete the extension.
  ## 
  let valid = call_569168.validator(path, query, header, formData, body)
  let scheme = call_569168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569168.url(scheme.get, call_569168.host, call_569168.base,
                         call_569168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569168, url, valid)

proc call*(call_569169: Call_VirtualMachineExtensionsDelete_569160;
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
  var path_569170 = newJObject()
  var query_569171 = newJObject()
  add(path_569170, "resourceGroupName", newJString(resourceGroupName))
  add(query_569171, "api-version", newJString(apiVersion))
  add(path_569170, "vmExtensionName", newJString(vmExtensionName))
  add(path_569170, "subscriptionId", newJString(subscriptionId))
  add(path_569170, "vmName", newJString(vmName))
  result = call_569169.call(path_569170, query_569171, nil, nil, nil)

var virtualMachineExtensionsDelete* = Call_VirtualMachineExtensionsDelete_569160(
    name: "virtualMachineExtensionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsDelete_569161, base: "",
    url: url_VirtualMachineExtensionsDelete_569162, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGeneralize_569186 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesGeneralize_569188(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesGeneralize_569187(path: JsonNode; query: JsonNode;
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
  var valid_569189 = path.getOrDefault("resourceGroupName")
  valid_569189 = validateParameter(valid_569189, JString, required = true,
                                 default = nil)
  if valid_569189 != nil:
    section.add "resourceGroupName", valid_569189
  var valid_569190 = path.getOrDefault("subscriptionId")
  valid_569190 = validateParameter(valid_569190, JString, required = true,
                                 default = nil)
  if valid_569190 != nil:
    section.add "subscriptionId", valid_569190
  var valid_569191 = path.getOrDefault("vmName")
  valid_569191 = validateParameter(valid_569191, JString, required = true,
                                 default = nil)
  if valid_569191 != nil:
    section.add "vmName", valid_569191
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569192 = query.getOrDefault("api-version")
  valid_569192 = validateParameter(valid_569192, JString, required = true,
                                 default = nil)
  if valid_569192 != nil:
    section.add "api-version", valid_569192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569193: Call_VirtualMachinesGeneralize_569186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the state of the virtual machine to generalized.
  ## 
  let valid = call_569193.validator(path, query, header, formData, body)
  let scheme = call_569193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569193.url(scheme.get, call_569193.host, call_569193.base,
                         call_569193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569193, url, valid)

proc call*(call_569194: Call_VirtualMachinesGeneralize_569186;
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
  var path_569195 = newJObject()
  var query_569196 = newJObject()
  add(path_569195, "resourceGroupName", newJString(resourceGroupName))
  add(query_569196, "api-version", newJString(apiVersion))
  add(path_569195, "subscriptionId", newJString(subscriptionId))
  add(path_569195, "vmName", newJString(vmName))
  result = call_569194.call(path_569195, query_569196, nil, nil, nil)

var virtualMachinesGeneralize* = Call_VirtualMachinesGeneralize_569186(
    name: "virtualMachinesGeneralize", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/generalize",
    validator: validate_VirtualMachinesGeneralize_569187, base: "",
    url: url_VirtualMachinesGeneralize_569188, schemes: {Scheme.Https})
type
  Call_VirtualMachinesInstanceView_569197 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesInstanceView_569199(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesInstanceView_569198(path: JsonNode; query: JsonNode;
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
  var valid_569200 = path.getOrDefault("resourceGroupName")
  valid_569200 = validateParameter(valid_569200, JString, required = true,
                                 default = nil)
  if valid_569200 != nil:
    section.add "resourceGroupName", valid_569200
  var valid_569201 = path.getOrDefault("subscriptionId")
  valid_569201 = validateParameter(valid_569201, JString, required = true,
                                 default = nil)
  if valid_569201 != nil:
    section.add "subscriptionId", valid_569201
  var valid_569202 = path.getOrDefault("vmName")
  valid_569202 = validateParameter(valid_569202, JString, required = true,
                                 default = nil)
  if valid_569202 != nil:
    section.add "vmName", valid_569202
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569203 = query.getOrDefault("api-version")
  valid_569203 = validateParameter(valid_569203, JString, required = true,
                                 default = nil)
  if valid_569203 != nil:
    section.add "api-version", valid_569203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569204: Call_VirtualMachinesInstanceView_569197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the run-time state of a virtual machine.
  ## 
  let valid = call_569204.validator(path, query, header, formData, body)
  let scheme = call_569204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569204.url(scheme.get, call_569204.host, call_569204.base,
                         call_569204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569204, url, valid)

proc call*(call_569205: Call_VirtualMachinesInstanceView_569197;
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
  var path_569206 = newJObject()
  var query_569207 = newJObject()
  add(path_569206, "resourceGroupName", newJString(resourceGroupName))
  add(query_569207, "api-version", newJString(apiVersion))
  add(path_569206, "subscriptionId", newJString(subscriptionId))
  add(path_569206, "vmName", newJString(vmName))
  result = call_569205.call(path_569206, query_569207, nil, nil, nil)

var virtualMachinesInstanceView* = Call_VirtualMachinesInstanceView_569197(
    name: "virtualMachinesInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/instanceView",
    validator: validate_VirtualMachinesInstanceView_569198, base: "",
    url: url_VirtualMachinesInstanceView_569199, schemes: {Scheme.Https})
type
  Call_VirtualMachinesPerformMaintenance_569208 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesPerformMaintenance_569210(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesPerformMaintenance_569209(path: JsonNode;
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
  var valid_569211 = path.getOrDefault("resourceGroupName")
  valid_569211 = validateParameter(valid_569211, JString, required = true,
                                 default = nil)
  if valid_569211 != nil:
    section.add "resourceGroupName", valid_569211
  var valid_569212 = path.getOrDefault("subscriptionId")
  valid_569212 = validateParameter(valid_569212, JString, required = true,
                                 default = nil)
  if valid_569212 != nil:
    section.add "subscriptionId", valid_569212
  var valid_569213 = path.getOrDefault("vmName")
  valid_569213 = validateParameter(valid_569213, JString, required = true,
                                 default = nil)
  if valid_569213 != nil:
    section.add "vmName", valid_569213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569214 = query.getOrDefault("api-version")
  valid_569214 = validateParameter(valid_569214, JString, required = true,
                                 default = nil)
  if valid_569214 != nil:
    section.add "api-version", valid_569214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569215: Call_VirtualMachinesPerformMaintenance_569208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to perform maintenance on a virtual machine.
  ## 
  let valid = call_569215.validator(path, query, header, formData, body)
  let scheme = call_569215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569215.url(scheme.get, call_569215.host, call_569215.base,
                         call_569215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569215, url, valid)

proc call*(call_569216: Call_VirtualMachinesPerformMaintenance_569208;
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
  var path_569217 = newJObject()
  var query_569218 = newJObject()
  add(path_569217, "resourceGroupName", newJString(resourceGroupName))
  add(query_569218, "api-version", newJString(apiVersion))
  add(path_569217, "subscriptionId", newJString(subscriptionId))
  add(path_569217, "vmName", newJString(vmName))
  result = call_569216.call(path_569217, query_569218, nil, nil, nil)

var virtualMachinesPerformMaintenance* = Call_VirtualMachinesPerformMaintenance_569208(
    name: "virtualMachinesPerformMaintenance", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/performMaintenance",
    validator: validate_VirtualMachinesPerformMaintenance_569209, base: "",
    url: url_VirtualMachinesPerformMaintenance_569210, schemes: {Scheme.Https})
type
  Call_VirtualMachinesPowerOff_569219 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesPowerOff_569221(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesPowerOff_569220(path: JsonNode; query: JsonNode;
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
  var valid_569222 = path.getOrDefault("resourceGroupName")
  valid_569222 = validateParameter(valid_569222, JString, required = true,
                                 default = nil)
  if valid_569222 != nil:
    section.add "resourceGroupName", valid_569222
  var valid_569223 = path.getOrDefault("subscriptionId")
  valid_569223 = validateParameter(valid_569223, JString, required = true,
                                 default = nil)
  if valid_569223 != nil:
    section.add "subscriptionId", valid_569223
  var valid_569224 = path.getOrDefault("vmName")
  valid_569224 = validateParameter(valid_569224, JString, required = true,
                                 default = nil)
  if valid_569224 != nil:
    section.add "vmName", valid_569224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569225 = query.getOrDefault("api-version")
  valid_569225 = validateParameter(valid_569225, JString, required = true,
                                 default = nil)
  if valid_569225 != nil:
    section.add "api-version", valid_569225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569226: Call_VirtualMachinesPowerOff_569219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to power off (stop) a virtual machine. The virtual machine can be restarted with the same provisioned resources. You are still charged for this virtual machine.
  ## 
  let valid = call_569226.validator(path, query, header, formData, body)
  let scheme = call_569226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569226.url(scheme.get, call_569226.host, call_569226.base,
                         call_569226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569226, url, valid)

proc call*(call_569227: Call_VirtualMachinesPowerOff_569219;
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
  var path_569228 = newJObject()
  var query_569229 = newJObject()
  add(path_569228, "resourceGroupName", newJString(resourceGroupName))
  add(query_569229, "api-version", newJString(apiVersion))
  add(path_569228, "subscriptionId", newJString(subscriptionId))
  add(path_569228, "vmName", newJString(vmName))
  result = call_569227.call(path_569228, query_569229, nil, nil, nil)

var virtualMachinesPowerOff* = Call_VirtualMachinesPowerOff_569219(
    name: "virtualMachinesPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/powerOff",
    validator: validate_VirtualMachinesPowerOff_569220, base: "",
    url: url_VirtualMachinesPowerOff_569221, schemes: {Scheme.Https})
type
  Call_VirtualMachinesRedeploy_569230 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesRedeploy_569232(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesRedeploy_569231(path: JsonNode; query: JsonNode;
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
  var valid_569233 = path.getOrDefault("resourceGroupName")
  valid_569233 = validateParameter(valid_569233, JString, required = true,
                                 default = nil)
  if valid_569233 != nil:
    section.add "resourceGroupName", valid_569233
  var valid_569234 = path.getOrDefault("subscriptionId")
  valid_569234 = validateParameter(valid_569234, JString, required = true,
                                 default = nil)
  if valid_569234 != nil:
    section.add "subscriptionId", valid_569234
  var valid_569235 = path.getOrDefault("vmName")
  valid_569235 = validateParameter(valid_569235, JString, required = true,
                                 default = nil)
  if valid_569235 != nil:
    section.add "vmName", valid_569235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569236 = query.getOrDefault("api-version")
  valid_569236 = validateParameter(valid_569236, JString, required = true,
                                 default = nil)
  if valid_569236 != nil:
    section.add "api-version", valid_569236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569237: Call_VirtualMachinesRedeploy_569230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shuts down the virtual machine, moves it to a new node, and powers it back on.
  ## 
  let valid = call_569237.validator(path, query, header, formData, body)
  let scheme = call_569237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569237.url(scheme.get, call_569237.host, call_569237.base,
                         call_569237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569237, url, valid)

proc call*(call_569238: Call_VirtualMachinesRedeploy_569230;
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
  var path_569239 = newJObject()
  var query_569240 = newJObject()
  add(path_569239, "resourceGroupName", newJString(resourceGroupName))
  add(query_569240, "api-version", newJString(apiVersion))
  add(path_569239, "subscriptionId", newJString(subscriptionId))
  add(path_569239, "vmName", newJString(vmName))
  result = call_569238.call(path_569239, query_569240, nil, nil, nil)

var virtualMachinesRedeploy* = Call_VirtualMachinesRedeploy_569230(
    name: "virtualMachinesRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/redeploy",
    validator: validate_VirtualMachinesRedeploy_569231, base: "",
    url: url_VirtualMachinesRedeploy_569232, schemes: {Scheme.Https})
type
  Call_VirtualMachinesRestart_569241 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesRestart_569243(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesRestart_569242(path: JsonNode; query: JsonNode;
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
  var valid_569244 = path.getOrDefault("resourceGroupName")
  valid_569244 = validateParameter(valid_569244, JString, required = true,
                                 default = nil)
  if valid_569244 != nil:
    section.add "resourceGroupName", valid_569244
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

proc call*(call_569248: Call_VirtualMachinesRestart_569241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to restart a virtual machine.
  ## 
  let valid = call_569248.validator(path, query, header, formData, body)
  let scheme = call_569248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569248.url(scheme.get, call_569248.host, call_569248.base,
                         call_569248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569248, url, valid)

proc call*(call_569249: Call_VirtualMachinesRestart_569241;
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
  var path_569250 = newJObject()
  var query_569251 = newJObject()
  add(path_569250, "resourceGroupName", newJString(resourceGroupName))
  add(query_569251, "api-version", newJString(apiVersion))
  add(path_569250, "subscriptionId", newJString(subscriptionId))
  add(path_569250, "vmName", newJString(vmName))
  result = call_569249.call(path_569250, query_569251, nil, nil, nil)

var virtualMachinesRestart* = Call_VirtualMachinesRestart_569241(
    name: "virtualMachinesRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/restart",
    validator: validate_VirtualMachinesRestart_569242, base: "",
    url: url_VirtualMachinesRestart_569243, schemes: {Scheme.Https})
type
  Call_VirtualMachinesStart_569252 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesStart_569254(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesStart_569253(path: JsonNode; query: JsonNode;
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
  var valid_569255 = path.getOrDefault("resourceGroupName")
  valid_569255 = validateParameter(valid_569255, JString, required = true,
                                 default = nil)
  if valid_569255 != nil:
    section.add "resourceGroupName", valid_569255
  var valid_569256 = path.getOrDefault("subscriptionId")
  valid_569256 = validateParameter(valid_569256, JString, required = true,
                                 default = nil)
  if valid_569256 != nil:
    section.add "subscriptionId", valid_569256
  var valid_569257 = path.getOrDefault("vmName")
  valid_569257 = validateParameter(valid_569257, JString, required = true,
                                 default = nil)
  if valid_569257 != nil:
    section.add "vmName", valid_569257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569258 = query.getOrDefault("api-version")
  valid_569258 = validateParameter(valid_569258, JString, required = true,
                                 default = nil)
  if valid_569258 != nil:
    section.add "api-version", valid_569258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569259: Call_VirtualMachinesStart_569252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to start a virtual machine.
  ## 
  let valid = call_569259.validator(path, query, header, formData, body)
  let scheme = call_569259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569259.url(scheme.get, call_569259.host, call_569259.base,
                         call_569259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569259, url, valid)

proc call*(call_569260: Call_VirtualMachinesStart_569252;
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
  var path_569261 = newJObject()
  var query_569262 = newJObject()
  add(path_569261, "resourceGroupName", newJString(resourceGroupName))
  add(query_569262, "api-version", newJString(apiVersion))
  add(path_569261, "subscriptionId", newJString(subscriptionId))
  add(path_569261, "vmName", newJString(vmName))
  result = call_569260.call(path_569261, query_569262, nil, nil, nil)

var virtualMachinesStart* = Call_VirtualMachinesStart_569252(
    name: "virtualMachinesStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/start",
    validator: validate_VirtualMachinesStart_569253, base: "",
    url: url_VirtualMachinesStart_569254, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListAvailableSizes_569263 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesListAvailableSizes_569265(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesListAvailableSizes_569264(path: JsonNode;
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
  var valid_569266 = path.getOrDefault("resourceGroupName")
  valid_569266 = validateParameter(valid_569266, JString, required = true,
                                 default = nil)
  if valid_569266 != nil:
    section.add "resourceGroupName", valid_569266
  var valid_569267 = path.getOrDefault("subscriptionId")
  valid_569267 = validateParameter(valid_569267, JString, required = true,
                                 default = nil)
  if valid_569267 != nil:
    section.add "subscriptionId", valid_569267
  var valid_569268 = path.getOrDefault("vmName")
  valid_569268 = validateParameter(valid_569268, JString, required = true,
                                 default = nil)
  if valid_569268 != nil:
    section.add "vmName", valid_569268
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569269 = query.getOrDefault("api-version")
  valid_569269 = validateParameter(valid_569269, JString, required = true,
                                 default = nil)
  if valid_569269 != nil:
    section.add "api-version", valid_569269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569270: Call_VirtualMachinesListAvailableSizes_569263;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available virtual machine sizes to which the specified virtual machine can be resized.
  ## 
  let valid = call_569270.validator(path, query, header, formData, body)
  let scheme = call_569270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569270.url(scheme.get, call_569270.host, call_569270.base,
                         call_569270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569270, url, valid)

proc call*(call_569271: Call_VirtualMachinesListAvailableSizes_569263;
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
  var path_569272 = newJObject()
  var query_569273 = newJObject()
  add(path_569272, "resourceGroupName", newJString(resourceGroupName))
  add(query_569273, "api-version", newJString(apiVersion))
  add(path_569272, "subscriptionId", newJString(subscriptionId))
  add(path_569272, "vmName", newJString(vmName))
  result = call_569271.call(path_569272, query_569273, nil, nil, nil)

var virtualMachinesListAvailableSizes* = Call_VirtualMachinesListAvailableSizes_569263(
    name: "virtualMachinesListAvailableSizes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/vmSizes",
    validator: validate_VirtualMachinesListAvailableSizes_569264, base: "",
    url: url_VirtualMachinesListAvailableSizes_569265, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
