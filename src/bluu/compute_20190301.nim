
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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
  Call_DedicatedHostGroupsListBySubscription_568210 = ref object of OpenApiRestCall_567667
proc url_DedicatedHostGroupsListBySubscription_568212(protocol: Scheme;
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

proc validate_DedicatedHostGroupsListBySubscription_568211(path: JsonNode;
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

proc call*(call_568215: Call_DedicatedHostGroupsListBySubscription_568210;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all of the dedicated host groups in the subscription. Use the nextLink property in the response to get the next page of dedicated host groups.
  ## 
  let valid = call_568215.validator(path, query, header, formData, body)
  let scheme = call_568215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568215.url(scheme.get, call_568215.host, call_568215.base,
                         call_568215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568215, url, valid)

proc call*(call_568216: Call_DedicatedHostGroupsListBySubscription_568210;
          apiVersion: string; subscriptionId: string): Recallable =
  ## dedicatedHostGroupsListBySubscription
  ## Lists all of the dedicated host groups in the subscription. Use the nextLink property in the response to get the next page of dedicated host groups.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568217 = newJObject()
  var query_568218 = newJObject()
  add(query_568218, "api-version", newJString(apiVersion))
  add(path_568217, "subscriptionId", newJString(subscriptionId))
  result = call_568216.call(path_568217, query_568218, nil, nil, nil)

var dedicatedHostGroupsListBySubscription* = Call_DedicatedHostGroupsListBySubscription_568210(
    name: "dedicatedHostGroupsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/hostGroups",
    validator: validate_DedicatedHostGroupsListBySubscription_568211, base: "",
    url: url_DedicatedHostGroupsListBySubscription_568212, schemes: {Scheme.Https})
type
  Call_ImagesList_568219 = ref object of OpenApiRestCall_567667
proc url_ImagesList_568221(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ImagesList_568220(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568222 = path.getOrDefault("subscriptionId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "subscriptionId", valid_568222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568223 = query.getOrDefault("api-version")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "api-version", valid_568223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568224: Call_ImagesList_568219; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Images in the subscription. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.
  ## 
  let valid = call_568224.validator(path, query, header, formData, body)
  let scheme = call_568224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568224.url(scheme.get, call_568224.host, call_568224.base,
                         call_568224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568224, url, valid)

proc call*(call_568225: Call_ImagesList_568219; apiVersion: string;
          subscriptionId: string): Recallable =
  ## imagesList
  ## Gets the list of Images in the subscription. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568226 = newJObject()
  var query_568227 = newJObject()
  add(query_568227, "api-version", newJString(apiVersion))
  add(path_568226, "subscriptionId", newJString(subscriptionId))
  result = call_568225.call(path_568226, query_568227, nil, nil, nil)

var imagesList* = Call_ImagesList_568219(name: "imagesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/images",
                                      validator: validate_ImagesList_568220,
                                      base: "", url: url_ImagesList_568221,
                                      schemes: {Scheme.Https})
type
  Call_LogAnalyticsExportRequestRateByInterval_568228 = ref object of OpenApiRestCall_567667
proc url_LogAnalyticsExportRequestRateByInterval_568230(protocol: Scheme;
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

proc validate_LogAnalyticsExportRequestRateByInterval_568229(path: JsonNode;
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
  var valid_568248 = path.getOrDefault("subscriptionId")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "subscriptionId", valid_568248
  var valid_568249 = path.getOrDefault("location")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "location", valid_568249
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568250 = query.getOrDefault("api-version")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "api-version", valid_568250
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

proc call*(call_568252: Call_LogAnalyticsExportRequestRateByInterval_568228;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Export logs that show Api requests made by this subscription in the given time window to show throttling activities.
  ## 
  let valid = call_568252.validator(path, query, header, formData, body)
  let scheme = call_568252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568252.url(scheme.get, call_568252.host, call_568252.base,
                         call_568252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568252, url, valid)

proc call*(call_568253: Call_LogAnalyticsExportRequestRateByInterval_568228;
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
  var path_568254 = newJObject()
  var query_568255 = newJObject()
  var body_568256 = newJObject()
  add(query_568255, "api-version", newJString(apiVersion))
  add(path_568254, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568256 = parameters
  add(path_568254, "location", newJString(location))
  result = call_568253.call(path_568254, query_568255, nil, nil, body_568256)

var logAnalyticsExportRequestRateByInterval* = Call_LogAnalyticsExportRequestRateByInterval_568228(
    name: "logAnalyticsExportRequestRateByInterval", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/logAnalytics/apiAccess/getRequestRateByInterval",
    validator: validate_LogAnalyticsExportRequestRateByInterval_568229, base: "",
    url: url_LogAnalyticsExportRequestRateByInterval_568230,
    schemes: {Scheme.Https})
type
  Call_LogAnalyticsExportThrottledRequests_568257 = ref object of OpenApiRestCall_567667
proc url_LogAnalyticsExportThrottledRequests_568259(protocol: Scheme; host: string;
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

proc validate_LogAnalyticsExportThrottledRequests_568258(path: JsonNode;
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
  var valid_568260 = path.getOrDefault("subscriptionId")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "subscriptionId", valid_568260
  var valid_568261 = path.getOrDefault("location")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "location", valid_568261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568262 = query.getOrDefault("api-version")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "api-version", valid_568262
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

proc call*(call_568264: Call_LogAnalyticsExportThrottledRequests_568257;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Export logs that show total throttled Api requests for this subscription in the given time window.
  ## 
  let valid = call_568264.validator(path, query, header, formData, body)
  let scheme = call_568264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568264.url(scheme.get, call_568264.host, call_568264.base,
                         call_568264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568264, url, valid)

proc call*(call_568265: Call_LogAnalyticsExportThrottledRequests_568257;
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
  var path_568266 = newJObject()
  var query_568267 = newJObject()
  var body_568268 = newJObject()
  add(query_568267, "api-version", newJString(apiVersion))
  add(path_568266, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568268 = parameters
  add(path_568266, "location", newJString(location))
  result = call_568265.call(path_568266, query_568267, nil, nil, body_568268)

var logAnalyticsExportThrottledRequests* = Call_LogAnalyticsExportThrottledRequests_568257(
    name: "logAnalyticsExportThrottledRequests", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/logAnalytics/apiAccess/getThrottledRequests",
    validator: validate_LogAnalyticsExportThrottledRequests_568258, base: "",
    url: url_LogAnalyticsExportThrottledRequests_568259, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesListPublishers_568269 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineImagesListPublishers_568271(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImagesListPublishers_568270(path: JsonNode;
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
  var valid_568272 = path.getOrDefault("subscriptionId")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "subscriptionId", valid_568272
  var valid_568273 = path.getOrDefault("location")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "location", valid_568273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568274 = query.getOrDefault("api-version")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "api-version", valid_568274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568275: Call_VirtualMachineImagesListPublishers_568269;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual machine image publishers for the specified Azure location.
  ## 
  let valid = call_568275.validator(path, query, header, formData, body)
  let scheme = call_568275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568275.url(scheme.get, call_568275.host, call_568275.base,
                         call_568275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568275, url, valid)

proc call*(call_568276: Call_VirtualMachineImagesListPublishers_568269;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## virtualMachineImagesListPublishers
  ## Gets a list of virtual machine image publishers for the specified Azure location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_568277 = newJObject()
  var query_568278 = newJObject()
  add(query_568278, "api-version", newJString(apiVersion))
  add(path_568277, "subscriptionId", newJString(subscriptionId))
  add(path_568277, "location", newJString(location))
  result = call_568276.call(path_568277, query_568278, nil, nil, nil)

var virtualMachineImagesListPublishers* = Call_VirtualMachineImagesListPublishers_568269(
    name: "virtualMachineImagesListPublishers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers",
    validator: validate_VirtualMachineImagesListPublishers_568270, base: "",
    url: url_VirtualMachineImagesListPublishers_568271, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionImagesListTypes_568279 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionImagesListTypes_568281(protocol: Scheme;
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

proc validate_VirtualMachineExtensionImagesListTypes_568280(path: JsonNode;
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
  var valid_568282 = path.getOrDefault("subscriptionId")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "subscriptionId", valid_568282
  var valid_568283 = path.getOrDefault("publisherName")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "publisherName", valid_568283
  var valid_568284 = path.getOrDefault("location")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "location", valid_568284
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568285 = query.getOrDefault("api-version")
  valid_568285 = validateParameter(valid_568285, JString, required = true,
                                 default = nil)
  if valid_568285 != nil:
    section.add "api-version", valid_568285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568286: Call_VirtualMachineExtensionImagesListTypes_568279;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual machine extension image types.
  ## 
  let valid = call_568286.validator(path, query, header, formData, body)
  let scheme = call_568286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568286.url(scheme.get, call_568286.host, call_568286.base,
                         call_568286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568286, url, valid)

proc call*(call_568287: Call_VirtualMachineExtensionImagesListTypes_568279;
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
  var path_568288 = newJObject()
  var query_568289 = newJObject()
  add(query_568289, "api-version", newJString(apiVersion))
  add(path_568288, "subscriptionId", newJString(subscriptionId))
  add(path_568288, "publisherName", newJString(publisherName))
  add(path_568288, "location", newJString(location))
  result = call_568287.call(path_568288, query_568289, nil, nil, nil)

var virtualMachineExtensionImagesListTypes* = Call_VirtualMachineExtensionImagesListTypes_568279(
    name: "virtualMachineExtensionImagesListTypes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types",
    validator: validate_VirtualMachineExtensionImagesListTypes_568280, base: "",
    url: url_VirtualMachineExtensionImagesListTypes_568281,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionImagesListVersions_568290 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionImagesListVersions_568292(protocol: Scheme;
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

proc validate_VirtualMachineExtensionImagesListVersions_568291(path: JsonNode;
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
  var valid_568293 = path.getOrDefault("type")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "type", valid_568293
  var valid_568294 = path.getOrDefault("subscriptionId")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "subscriptionId", valid_568294
  var valid_568295 = path.getOrDefault("publisherName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "publisherName", valid_568295
  var valid_568296 = path.getOrDefault("location")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "location", valid_568296
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_568297 = query.getOrDefault("$orderby")
  valid_568297 = validateParameter(valid_568297, JString, required = false,
                                 default = nil)
  if valid_568297 != nil:
    section.add "$orderby", valid_568297
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568298 = query.getOrDefault("api-version")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "api-version", valid_568298
  var valid_568299 = query.getOrDefault("$top")
  valid_568299 = validateParameter(valid_568299, JInt, required = false, default = nil)
  if valid_568299 != nil:
    section.add "$top", valid_568299
  var valid_568300 = query.getOrDefault("$filter")
  valid_568300 = validateParameter(valid_568300, JString, required = false,
                                 default = nil)
  if valid_568300 != nil:
    section.add "$filter", valid_568300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568301: Call_VirtualMachineExtensionImagesListVersions_568290;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual machine extension image versions.
  ## 
  let valid = call_568301.validator(path, query, header, formData, body)
  let scheme = call_568301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568301.url(scheme.get, call_568301.host, call_568301.base,
                         call_568301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568301, url, valid)

proc call*(call_568302: Call_VirtualMachineExtensionImagesListVersions_568290;
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
  var path_568303 = newJObject()
  var query_568304 = newJObject()
  add(path_568303, "type", newJString(`type`))
  add(query_568304, "$orderby", newJString(Orderby))
  add(query_568304, "api-version", newJString(apiVersion))
  add(path_568303, "subscriptionId", newJString(subscriptionId))
  add(query_568304, "$top", newJInt(Top))
  add(path_568303, "publisherName", newJString(publisherName))
  add(path_568303, "location", newJString(location))
  add(query_568304, "$filter", newJString(Filter))
  result = call_568302.call(path_568303, query_568304, nil, nil, nil)

var virtualMachineExtensionImagesListVersions* = Call_VirtualMachineExtensionImagesListVersions_568290(
    name: "virtualMachineExtensionImagesListVersions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types/{type}/versions",
    validator: validate_VirtualMachineExtensionImagesListVersions_568291,
    base: "", url: url_VirtualMachineExtensionImagesListVersions_568292,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionImagesGet_568305 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionImagesGet_568307(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionImagesGet_568306(path: JsonNode;
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
  var valid_568308 = path.getOrDefault("type")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "type", valid_568308
  var valid_568309 = path.getOrDefault("version")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "version", valid_568309
  var valid_568310 = path.getOrDefault("subscriptionId")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "subscriptionId", valid_568310
  var valid_568311 = path.getOrDefault("publisherName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "publisherName", valid_568311
  var valid_568312 = path.getOrDefault("location")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "location", valid_568312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568313 = query.getOrDefault("api-version")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "api-version", valid_568313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568314: Call_VirtualMachineExtensionImagesGet_568305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a virtual machine extension image.
  ## 
  let valid = call_568314.validator(path, query, header, formData, body)
  let scheme = call_568314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568314.url(scheme.get, call_568314.host, call_568314.base,
                         call_568314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568314, url, valid)

proc call*(call_568315: Call_VirtualMachineExtensionImagesGet_568305;
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
  var path_568316 = newJObject()
  var query_568317 = newJObject()
  add(path_568316, "type", newJString(`type`))
  add(query_568317, "api-version", newJString(apiVersion))
  add(path_568316, "version", newJString(version))
  add(path_568316, "subscriptionId", newJString(subscriptionId))
  add(path_568316, "publisherName", newJString(publisherName))
  add(path_568316, "location", newJString(location))
  result = call_568315.call(path_568316, query_568317, nil, nil, nil)

var virtualMachineExtensionImagesGet* = Call_VirtualMachineExtensionImagesGet_568305(
    name: "virtualMachineExtensionImagesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types/{type}/versions/{version}",
    validator: validate_VirtualMachineExtensionImagesGet_568306, base: "",
    url: url_VirtualMachineExtensionImagesGet_568307, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesListOffers_568318 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineImagesListOffers_568320(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImagesListOffers_568319(path: JsonNode;
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
  var valid_568321 = path.getOrDefault("subscriptionId")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "subscriptionId", valid_568321
  var valid_568322 = path.getOrDefault("publisherName")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "publisherName", valid_568322
  var valid_568323 = path.getOrDefault("location")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "location", valid_568323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568324 = query.getOrDefault("api-version")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "api-version", valid_568324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568325: Call_VirtualMachineImagesListOffers_568318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of virtual machine image offers for the specified location and publisher.
  ## 
  let valid = call_568325.validator(path, query, header, formData, body)
  let scheme = call_568325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568325.url(scheme.get, call_568325.host, call_568325.base,
                         call_568325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568325, url, valid)

proc call*(call_568326: Call_VirtualMachineImagesListOffers_568318;
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
  var path_568327 = newJObject()
  var query_568328 = newJObject()
  add(query_568328, "api-version", newJString(apiVersion))
  add(path_568327, "subscriptionId", newJString(subscriptionId))
  add(path_568327, "publisherName", newJString(publisherName))
  add(path_568327, "location", newJString(location))
  result = call_568326.call(path_568327, query_568328, nil, nil, nil)

var virtualMachineImagesListOffers* = Call_VirtualMachineImagesListOffers_568318(
    name: "virtualMachineImagesListOffers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers",
    validator: validate_VirtualMachineImagesListOffers_568319, base: "",
    url: url_VirtualMachineImagesListOffers_568320, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesListSkus_568329 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineImagesListSkus_568331(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImagesListSkus_568330(path: JsonNode; query: JsonNode;
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
  var valid_568332 = path.getOrDefault("subscriptionId")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = nil)
  if valid_568332 != nil:
    section.add "subscriptionId", valid_568332
  var valid_568333 = path.getOrDefault("publisherName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "publisherName", valid_568333
  var valid_568334 = path.getOrDefault("offer")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "offer", valid_568334
  var valid_568335 = path.getOrDefault("location")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "location", valid_568335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568336 = query.getOrDefault("api-version")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "api-version", valid_568336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568337: Call_VirtualMachineImagesListSkus_568329; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of virtual machine image SKUs for the specified location, publisher, and offer.
  ## 
  let valid = call_568337.validator(path, query, header, formData, body)
  let scheme = call_568337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568337.url(scheme.get, call_568337.host, call_568337.base,
                         call_568337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568337, url, valid)

proc call*(call_568338: Call_VirtualMachineImagesListSkus_568329;
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
  var path_568339 = newJObject()
  var query_568340 = newJObject()
  add(query_568340, "api-version", newJString(apiVersion))
  add(path_568339, "subscriptionId", newJString(subscriptionId))
  add(path_568339, "publisherName", newJString(publisherName))
  add(path_568339, "offer", newJString(offer))
  add(path_568339, "location", newJString(location))
  result = call_568338.call(path_568339, query_568340, nil, nil, nil)

var virtualMachineImagesListSkus* = Call_VirtualMachineImagesListSkus_568329(
    name: "virtualMachineImagesListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus",
    validator: validate_VirtualMachineImagesListSkus_568330, base: "",
    url: url_VirtualMachineImagesListSkus_568331, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesList_568341 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineImagesList_568343(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImagesList_568342(path: JsonNode; query: JsonNode;
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
  var valid_568344 = path.getOrDefault("skus")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = nil)
  if valid_568344 != nil:
    section.add "skus", valid_568344
  var valid_568345 = path.getOrDefault("subscriptionId")
  valid_568345 = validateParameter(valid_568345, JString, required = true,
                                 default = nil)
  if valid_568345 != nil:
    section.add "subscriptionId", valid_568345
  var valid_568346 = path.getOrDefault("publisherName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "publisherName", valid_568346
  var valid_568347 = path.getOrDefault("offer")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "offer", valid_568347
  var valid_568348 = path.getOrDefault("location")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "location", valid_568348
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_568349 = query.getOrDefault("$orderby")
  valid_568349 = validateParameter(valid_568349, JString, required = false,
                                 default = nil)
  if valid_568349 != nil:
    section.add "$orderby", valid_568349
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568350 = query.getOrDefault("api-version")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "api-version", valid_568350
  var valid_568351 = query.getOrDefault("$top")
  valid_568351 = validateParameter(valid_568351, JInt, required = false, default = nil)
  if valid_568351 != nil:
    section.add "$top", valid_568351
  var valid_568352 = query.getOrDefault("$filter")
  valid_568352 = validateParameter(valid_568352, JString, required = false,
                                 default = nil)
  if valid_568352 != nil:
    section.add "$filter", valid_568352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568353: Call_VirtualMachineImagesList_568341; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all virtual machine image versions for the specified location, publisher, offer, and SKU.
  ## 
  let valid = call_568353.validator(path, query, header, formData, body)
  let scheme = call_568353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568353.url(scheme.get, call_568353.host, call_568353.base,
                         call_568353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568353, url, valid)

proc call*(call_568354: Call_VirtualMachineImagesList_568341; apiVersion: string;
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
  var path_568355 = newJObject()
  var query_568356 = newJObject()
  add(query_568356, "$orderby", newJString(Orderby))
  add(query_568356, "api-version", newJString(apiVersion))
  add(path_568355, "skus", newJString(skus))
  add(path_568355, "subscriptionId", newJString(subscriptionId))
  add(query_568356, "$top", newJInt(Top))
  add(path_568355, "publisherName", newJString(publisherName))
  add(path_568355, "offer", newJString(offer))
  add(path_568355, "location", newJString(location))
  add(query_568356, "$filter", newJString(Filter))
  result = call_568354.call(path_568355, query_568356, nil, nil, nil)

var virtualMachineImagesList* = Call_VirtualMachineImagesList_568341(
    name: "virtualMachineImagesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions",
    validator: validate_VirtualMachineImagesList_568342, base: "",
    url: url_VirtualMachineImagesList_568343, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesGet_568357 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineImagesGet_568359(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineImagesGet_568358(path: JsonNode; query: JsonNode;
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
  var valid_568360 = path.getOrDefault("skus")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "skus", valid_568360
  var valid_568361 = path.getOrDefault("version")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "version", valid_568361
  var valid_568362 = path.getOrDefault("subscriptionId")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "subscriptionId", valid_568362
  var valid_568363 = path.getOrDefault("publisherName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "publisherName", valid_568363
  var valid_568364 = path.getOrDefault("offer")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "offer", valid_568364
  var valid_568365 = path.getOrDefault("location")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "location", valid_568365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568366 = query.getOrDefault("api-version")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "api-version", valid_568366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568367: Call_VirtualMachineImagesGet_568357; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a virtual machine image.
  ## 
  let valid = call_568367.validator(path, query, header, formData, body)
  let scheme = call_568367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568367.url(scheme.get, call_568367.host, call_568367.base,
                         call_568367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568367, url, valid)

proc call*(call_568368: Call_VirtualMachineImagesGet_568357; apiVersion: string;
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
  var path_568369 = newJObject()
  var query_568370 = newJObject()
  add(query_568370, "api-version", newJString(apiVersion))
  add(path_568369, "skus", newJString(skus))
  add(path_568369, "version", newJString(version))
  add(path_568369, "subscriptionId", newJString(subscriptionId))
  add(path_568369, "publisherName", newJString(publisherName))
  add(path_568369, "offer", newJString(offer))
  add(path_568369, "location", newJString(location))
  result = call_568368.call(path_568369, query_568370, nil, nil, nil)

var virtualMachineImagesGet* = Call_VirtualMachineImagesGet_568357(
    name: "virtualMachineImagesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions/{version}",
    validator: validate_VirtualMachineImagesGet_568358, base: "",
    url: url_VirtualMachineImagesGet_568359, schemes: {Scheme.Https})
type
  Call_UsageList_568371 = ref object of OpenApiRestCall_567667
proc url_UsageList_568373(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsageList_568372(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568374 = path.getOrDefault("subscriptionId")
  valid_568374 = validateParameter(valid_568374, JString, required = true,
                                 default = nil)
  if valid_568374 != nil:
    section.add "subscriptionId", valid_568374
  var valid_568375 = path.getOrDefault("location")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "location", valid_568375
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568376 = query.getOrDefault("api-version")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "api-version", valid_568376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568377: Call_UsageList_568371; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets, for the specified location, the current compute resource usage information as well as the limits for compute resources under the subscription.
  ## 
  let valid = call_568377.validator(path, query, header, formData, body)
  let scheme = call_568377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568377.url(scheme.get, call_568377.host, call_568377.base,
                         call_568377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568377, url, valid)

proc call*(call_568378: Call_UsageList_568371; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usageList
  ## Gets, for the specified location, the current compute resource usage information as well as the limits for compute resources under the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location for which resource usage is queried.
  var path_568379 = newJObject()
  var query_568380 = newJObject()
  add(query_568380, "api-version", newJString(apiVersion))
  add(path_568379, "subscriptionId", newJString(subscriptionId))
  add(path_568379, "location", newJString(location))
  result = call_568378.call(path_568379, query_568380, nil, nil, nil)

var usageList* = Call_UsageList_568371(name: "usageList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/usages",
                                    validator: validate_UsageList_568372,
                                    base: "", url: url_UsageList_568373,
                                    schemes: {Scheme.Https})
type
  Call_VirtualMachinesListByLocation_568381 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesListByLocation_568383(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesListByLocation_568382(path: JsonNode; query: JsonNode;
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
  var valid_568384 = path.getOrDefault("subscriptionId")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = nil)
  if valid_568384 != nil:
    section.add "subscriptionId", valid_568384
  var valid_568385 = path.getOrDefault("location")
  valid_568385 = validateParameter(valid_568385, JString, required = true,
                                 default = nil)
  if valid_568385 != nil:
    section.add "location", valid_568385
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568386 = query.getOrDefault("api-version")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "api-version", valid_568386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568387: Call_VirtualMachinesListByLocation_568381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the virtual machines under the specified subscription for the specified location.
  ## 
  let valid = call_568387.validator(path, query, header, formData, body)
  let scheme = call_568387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568387.url(scheme.get, call_568387.host, call_568387.base,
                         call_568387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568387, url, valid)

proc call*(call_568388: Call_VirtualMachinesListByLocation_568381;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## virtualMachinesListByLocation
  ## Gets all the virtual machines under the specified subscription for the specified location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location for which virtual machines under the subscription are queried.
  var path_568389 = newJObject()
  var query_568390 = newJObject()
  add(query_568390, "api-version", newJString(apiVersion))
  add(path_568389, "subscriptionId", newJString(subscriptionId))
  add(path_568389, "location", newJString(location))
  result = call_568388.call(path_568389, query_568390, nil, nil, nil)

var virtualMachinesListByLocation* = Call_VirtualMachinesListByLocation_568381(
    name: "virtualMachinesListByLocation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/virtualMachines",
    validator: validate_VirtualMachinesListByLocation_568382, base: "",
    url: url_VirtualMachinesListByLocation_568383, schemes: {Scheme.Https})
type
  Call_VirtualMachineSizesList_568391 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineSizesList_568393(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineSizesList_568392(path: JsonNode; query: JsonNode;
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
  var valid_568394 = path.getOrDefault("subscriptionId")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "subscriptionId", valid_568394
  var valid_568395 = path.getOrDefault("location")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "location", valid_568395
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

proc call*(call_568397: Call_VirtualMachineSizesList_568391; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This API is deprecated. Use [Resources Skus](https://docs.microsoft.com/en-us/rest/api/compute/resourceskus/list)
  ## 
  let valid = call_568397.validator(path, query, header, formData, body)
  let scheme = call_568397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568397.url(scheme.get, call_568397.host, call_568397.base,
                         call_568397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568397, url, valid)

proc call*(call_568398: Call_VirtualMachineSizesList_568391; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## virtualMachineSizesList
  ## This API is deprecated. Use [Resources Skus](https://docs.microsoft.com/en-us/rest/api/compute/resourceskus/list)
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  var path_568399 = newJObject()
  var query_568400 = newJObject()
  add(query_568400, "api-version", newJString(apiVersion))
  add(path_568399, "subscriptionId", newJString(subscriptionId))
  add(path_568399, "location", newJString(location))
  result = call_568398.call(path_568399, query_568400, nil, nil, nil)

var virtualMachineSizesList* = Call_VirtualMachineSizesList_568391(
    name: "virtualMachineSizesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/vmSizes",
    validator: validate_VirtualMachineSizesList_568392, base: "",
    url: url_VirtualMachineSizesList_568393, schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsListBySubscription_568401 = ref object of OpenApiRestCall_567667
proc url_ProximityPlacementGroupsListBySubscription_568403(protocol: Scheme;
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

proc validate_ProximityPlacementGroupsListBySubscription_568402(path: JsonNode;
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

proc call*(call_568406: Call_ProximityPlacementGroupsListBySubscription_568401;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all proximity placement groups in a subscription.
  ## 
  let valid = call_568406.validator(path, query, header, formData, body)
  let scheme = call_568406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568406.url(scheme.get, call_568406.host, call_568406.base,
                         call_568406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568406, url, valid)

proc call*(call_568407: Call_ProximityPlacementGroupsListBySubscription_568401;
          apiVersion: string; subscriptionId: string): Recallable =
  ## proximityPlacementGroupsListBySubscription
  ## Lists all proximity placement groups in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568408 = newJObject()
  var query_568409 = newJObject()
  add(query_568409, "api-version", newJString(apiVersion))
  add(path_568408, "subscriptionId", newJString(subscriptionId))
  result = call_568407.call(path_568408, query_568409, nil, nil, nil)

var proximityPlacementGroupsListBySubscription* = Call_ProximityPlacementGroupsListBySubscription_568401(
    name: "proximityPlacementGroupsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/proximityPlacementGroups",
    validator: validate_ProximityPlacementGroupsListBySubscription_568402,
    base: "", url: url_ProximityPlacementGroupsListBySubscription_568403,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsListAll_568410 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsListAll_568412(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsListAll_568411(path: JsonNode;
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

proc call*(call_568415: Call_VirtualMachineScaleSetsListAll_568410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all VM Scale Sets in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM Scale Sets.
  ## 
  let valid = call_568415.validator(path, query, header, formData, body)
  let scheme = call_568415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568415.url(scheme.get, call_568415.host, call_568415.base,
                         call_568415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568415, url, valid)

proc call*(call_568416: Call_VirtualMachineScaleSetsListAll_568410;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsListAll
  ## Gets a list of all VM Scale Sets in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM Scale Sets.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568417 = newJObject()
  var query_568418 = newJObject()
  add(query_568418, "api-version", newJString(apiVersion))
  add(path_568417, "subscriptionId", newJString(subscriptionId))
  result = call_568416.call(path_568417, query_568418, nil, nil, nil)

var virtualMachineScaleSetsListAll* = Call_VirtualMachineScaleSetsListAll_568410(
    name: "virtualMachineScaleSetsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachineScaleSets",
    validator: validate_VirtualMachineScaleSetsListAll_568411, base: "",
    url: url_VirtualMachineScaleSetsListAll_568412, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListAll_568419 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesListAll_568421(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesListAll_568420(path: JsonNode; query: JsonNode;
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
  var valid_568422 = path.getOrDefault("subscriptionId")
  valid_568422 = validateParameter(valid_568422, JString, required = true,
                                 default = nil)
  if valid_568422 != nil:
    section.add "subscriptionId", valid_568422
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568423 = query.getOrDefault("api-version")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "api-version", valid_568423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568424: Call_VirtualMachinesListAll_568419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the virtual machines in the specified subscription. Use the nextLink property in the response to get the next page of virtual machines.
  ## 
  let valid = call_568424.validator(path, query, header, formData, body)
  let scheme = call_568424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568424.url(scheme.get, call_568424.host, call_568424.base,
                         call_568424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568424, url, valid)

proc call*(call_568425: Call_VirtualMachinesListAll_568419; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachinesListAll
  ## Lists all of the virtual machines in the specified subscription. Use the nextLink property in the response to get the next page of virtual machines.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568426 = newJObject()
  var query_568427 = newJObject()
  add(query_568427, "api-version", newJString(apiVersion))
  add(path_568426, "subscriptionId", newJString(subscriptionId))
  result = call_568425.call(path_568426, query_568427, nil, nil, nil)

var virtualMachinesListAll* = Call_VirtualMachinesListAll_568419(
    name: "virtualMachinesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachines",
    validator: validate_VirtualMachinesListAll_568420, base: "",
    url: url_VirtualMachinesListAll_568421, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsList_568428 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsList_568430(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsList_568429(path: JsonNode; query: JsonNode;
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
  var valid_568431 = path.getOrDefault("resourceGroupName")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "resourceGroupName", valid_568431
  var valid_568432 = path.getOrDefault("subscriptionId")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "subscriptionId", valid_568432
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568433 = query.getOrDefault("api-version")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "api-version", valid_568433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568434: Call_AvailabilitySetsList_568428; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all availability sets in a resource group.
  ## 
  let valid = call_568434.validator(path, query, header, formData, body)
  let scheme = call_568434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568434.url(scheme.get, call_568434.host, call_568434.base,
                         call_568434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568434, url, valid)

proc call*(call_568435: Call_AvailabilitySetsList_568428;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## availabilitySetsList
  ## Lists all availability sets in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568436 = newJObject()
  var query_568437 = newJObject()
  add(path_568436, "resourceGroupName", newJString(resourceGroupName))
  add(query_568437, "api-version", newJString(apiVersion))
  add(path_568436, "subscriptionId", newJString(subscriptionId))
  result = call_568435.call(path_568436, query_568437, nil, nil, nil)

var availabilitySetsList* = Call_AvailabilitySetsList_568428(
    name: "availabilitySetsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets",
    validator: validate_AvailabilitySetsList_568429, base: "",
    url: url_AvailabilitySetsList_568430, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsCreateOrUpdate_568449 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsCreateOrUpdate_568451(protocol: Scheme; host: string;
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

proc validate_AvailabilitySetsCreateOrUpdate_568450(path: JsonNode;
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
  var valid_568452 = path.getOrDefault("resourceGroupName")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "resourceGroupName", valid_568452
  var valid_568453 = path.getOrDefault("subscriptionId")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "subscriptionId", valid_568453
  var valid_568454 = path.getOrDefault("availabilitySetName")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = nil)
  if valid_568454 != nil:
    section.add "availabilitySetName", valid_568454
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568455 = query.getOrDefault("api-version")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "api-version", valid_568455
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

proc call*(call_568457: Call_AvailabilitySetsCreateOrUpdate_568449; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an availability set.
  ## 
  let valid = call_568457.validator(path, query, header, formData, body)
  let scheme = call_568457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568457.url(scheme.get, call_568457.host, call_568457.base,
                         call_568457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568457, url, valid)

proc call*(call_568458: Call_AvailabilitySetsCreateOrUpdate_568449;
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
  var path_568459 = newJObject()
  var query_568460 = newJObject()
  var body_568461 = newJObject()
  add(path_568459, "resourceGroupName", newJString(resourceGroupName))
  add(query_568460, "api-version", newJString(apiVersion))
  add(path_568459, "subscriptionId", newJString(subscriptionId))
  add(path_568459, "availabilitySetName", newJString(availabilitySetName))
  if parameters != nil:
    body_568461 = parameters
  result = call_568458.call(path_568459, query_568460, nil, nil, body_568461)

var availabilitySetsCreateOrUpdate* = Call_AvailabilitySetsCreateOrUpdate_568449(
    name: "availabilitySetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsCreateOrUpdate_568450, base: "",
    url: url_AvailabilitySetsCreateOrUpdate_568451, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsGet_568438 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsGet_568440(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsGet_568439(path: JsonNode; query: JsonNode;
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
  var valid_568441 = path.getOrDefault("resourceGroupName")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "resourceGroupName", valid_568441
  var valid_568442 = path.getOrDefault("subscriptionId")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = nil)
  if valid_568442 != nil:
    section.add "subscriptionId", valid_568442
  var valid_568443 = path.getOrDefault("availabilitySetName")
  valid_568443 = validateParameter(valid_568443, JString, required = true,
                                 default = nil)
  if valid_568443 != nil:
    section.add "availabilitySetName", valid_568443
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568444 = query.getOrDefault("api-version")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "api-version", valid_568444
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568445: Call_AvailabilitySetsGet_568438; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about an availability set.
  ## 
  let valid = call_568445.validator(path, query, header, formData, body)
  let scheme = call_568445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568445.url(scheme.get, call_568445.host, call_568445.base,
                         call_568445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568445, url, valid)

proc call*(call_568446: Call_AvailabilitySetsGet_568438; resourceGroupName: string;
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
  var path_568447 = newJObject()
  var query_568448 = newJObject()
  add(path_568447, "resourceGroupName", newJString(resourceGroupName))
  add(query_568448, "api-version", newJString(apiVersion))
  add(path_568447, "subscriptionId", newJString(subscriptionId))
  add(path_568447, "availabilitySetName", newJString(availabilitySetName))
  result = call_568446.call(path_568447, query_568448, nil, nil, nil)

var availabilitySetsGet* = Call_AvailabilitySetsGet_568438(
    name: "availabilitySetsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsGet_568439, base: "",
    url: url_AvailabilitySetsGet_568440, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsUpdate_568473 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsUpdate_568475(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsUpdate_568474(path: JsonNode; query: JsonNode;
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
  var valid_568476 = path.getOrDefault("resourceGroupName")
  valid_568476 = validateParameter(valid_568476, JString, required = true,
                                 default = nil)
  if valid_568476 != nil:
    section.add "resourceGroupName", valid_568476
  var valid_568477 = path.getOrDefault("subscriptionId")
  valid_568477 = validateParameter(valid_568477, JString, required = true,
                                 default = nil)
  if valid_568477 != nil:
    section.add "subscriptionId", valid_568477
  var valid_568478 = path.getOrDefault("availabilitySetName")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "availabilitySetName", valid_568478
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568479 = query.getOrDefault("api-version")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "api-version", valid_568479
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

proc call*(call_568481: Call_AvailabilitySetsUpdate_568473; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an availability set.
  ## 
  let valid = call_568481.validator(path, query, header, formData, body)
  let scheme = call_568481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568481.url(scheme.get, call_568481.host, call_568481.base,
                         call_568481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568481, url, valid)

proc call*(call_568482: Call_AvailabilitySetsUpdate_568473;
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
  var path_568483 = newJObject()
  var query_568484 = newJObject()
  var body_568485 = newJObject()
  add(path_568483, "resourceGroupName", newJString(resourceGroupName))
  add(query_568484, "api-version", newJString(apiVersion))
  add(path_568483, "subscriptionId", newJString(subscriptionId))
  add(path_568483, "availabilitySetName", newJString(availabilitySetName))
  if parameters != nil:
    body_568485 = parameters
  result = call_568482.call(path_568483, query_568484, nil, nil, body_568485)

var availabilitySetsUpdate* = Call_AvailabilitySetsUpdate_568473(
    name: "availabilitySetsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsUpdate_568474, base: "",
    url: url_AvailabilitySetsUpdate_568475, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsDelete_568462 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsDelete_568464(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsDelete_568463(path: JsonNode; query: JsonNode;
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
  var valid_568465 = path.getOrDefault("resourceGroupName")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "resourceGroupName", valid_568465
  var valid_568466 = path.getOrDefault("subscriptionId")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "subscriptionId", valid_568466
  var valid_568467 = path.getOrDefault("availabilitySetName")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "availabilitySetName", valid_568467
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568468 = query.getOrDefault("api-version")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "api-version", valid_568468
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568469: Call_AvailabilitySetsDelete_568462; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an availability set.
  ## 
  let valid = call_568469.validator(path, query, header, formData, body)
  let scheme = call_568469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568469.url(scheme.get, call_568469.host, call_568469.base,
                         call_568469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568469, url, valid)

proc call*(call_568470: Call_AvailabilitySetsDelete_568462;
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
  var path_568471 = newJObject()
  var query_568472 = newJObject()
  add(path_568471, "resourceGroupName", newJString(resourceGroupName))
  add(query_568472, "api-version", newJString(apiVersion))
  add(path_568471, "subscriptionId", newJString(subscriptionId))
  add(path_568471, "availabilitySetName", newJString(availabilitySetName))
  result = call_568470.call(path_568471, query_568472, nil, nil, nil)

var availabilitySetsDelete* = Call_AvailabilitySetsDelete_568462(
    name: "availabilitySetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsDelete_568463, base: "",
    url: url_AvailabilitySetsDelete_568464, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsListAvailableSizes_568486 = ref object of OpenApiRestCall_567667
proc url_AvailabilitySetsListAvailableSizes_568488(protocol: Scheme; host: string;
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

proc validate_AvailabilitySetsListAvailableSizes_568487(path: JsonNode;
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
  var valid_568489 = path.getOrDefault("resourceGroupName")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "resourceGroupName", valid_568489
  var valid_568490 = path.getOrDefault("subscriptionId")
  valid_568490 = validateParameter(valid_568490, JString, required = true,
                                 default = nil)
  if valid_568490 != nil:
    section.add "subscriptionId", valid_568490
  var valid_568491 = path.getOrDefault("availabilitySetName")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "availabilitySetName", valid_568491
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568492 = query.getOrDefault("api-version")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "api-version", valid_568492
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568493: Call_AvailabilitySetsListAvailableSizes_568486;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available virtual machine sizes that can be used to create a new virtual machine in an existing availability set.
  ## 
  let valid = call_568493.validator(path, query, header, formData, body)
  let scheme = call_568493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568493.url(scheme.get, call_568493.host, call_568493.base,
                         call_568493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568493, url, valid)

proc call*(call_568494: Call_AvailabilitySetsListAvailableSizes_568486;
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
  var path_568495 = newJObject()
  var query_568496 = newJObject()
  add(path_568495, "resourceGroupName", newJString(resourceGroupName))
  add(query_568496, "api-version", newJString(apiVersion))
  add(path_568495, "subscriptionId", newJString(subscriptionId))
  add(path_568495, "availabilitySetName", newJString(availabilitySetName))
  result = call_568494.call(path_568495, query_568496, nil, nil, nil)

var availabilitySetsListAvailableSizes* = Call_AvailabilitySetsListAvailableSizes_568486(
    name: "availabilitySetsListAvailableSizes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}/vmSizes",
    validator: validate_AvailabilitySetsListAvailableSizes_568487, base: "",
    url: url_AvailabilitySetsListAvailableSizes_568488, schemes: {Scheme.Https})
type
  Call_DedicatedHostGroupsListByResourceGroup_568497 = ref object of OpenApiRestCall_567667
proc url_DedicatedHostGroupsListByResourceGroup_568499(protocol: Scheme;
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

proc validate_DedicatedHostGroupsListByResourceGroup_568498(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the dedicated host groups in the specified resource group. Use the nextLink property in the response to get the next page of dedicated host groups.
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
  var valid_568500 = path.getOrDefault("resourceGroupName")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = nil)
  if valid_568500 != nil:
    section.add "resourceGroupName", valid_568500
  var valid_568501 = path.getOrDefault("subscriptionId")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "subscriptionId", valid_568501
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568502 = query.getOrDefault("api-version")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "api-version", valid_568502
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568503: Call_DedicatedHostGroupsListByResourceGroup_568497;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all of the dedicated host groups in the specified resource group. Use the nextLink property in the response to get the next page of dedicated host groups.
  ## 
  let valid = call_568503.validator(path, query, header, formData, body)
  let scheme = call_568503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568503.url(scheme.get, call_568503.host, call_568503.base,
                         call_568503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568503, url, valid)

proc call*(call_568504: Call_DedicatedHostGroupsListByResourceGroup_568497;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## dedicatedHostGroupsListByResourceGroup
  ## Lists all of the dedicated host groups in the specified resource group. Use the nextLink property in the response to get the next page of dedicated host groups.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568505 = newJObject()
  var query_568506 = newJObject()
  add(path_568505, "resourceGroupName", newJString(resourceGroupName))
  add(query_568506, "api-version", newJString(apiVersion))
  add(path_568505, "subscriptionId", newJString(subscriptionId))
  result = call_568504.call(path_568505, query_568506, nil, nil, nil)

var dedicatedHostGroupsListByResourceGroup* = Call_DedicatedHostGroupsListByResourceGroup_568497(
    name: "dedicatedHostGroupsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups",
    validator: validate_DedicatedHostGroupsListByResourceGroup_568498, base: "",
    url: url_DedicatedHostGroupsListByResourceGroup_568499,
    schemes: {Scheme.Https})
type
  Call_DedicatedHostGroupsCreateOrUpdate_568518 = ref object of OpenApiRestCall_567667
proc url_DedicatedHostGroupsCreateOrUpdate_568520(protocol: Scheme; host: string;
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

proc validate_DedicatedHostGroupsCreateOrUpdate_568519(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a dedicated host group. For details of Dedicated Host and Dedicated Host Groups please see [Dedicated Host Documentation] (https://go.microsoft.com/fwlink/?linkid=2082596)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hostGroupName: JString (required)
  ##                : The name of the dedicated host group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568521 = path.getOrDefault("resourceGroupName")
  valid_568521 = validateParameter(valid_568521, JString, required = true,
                                 default = nil)
  if valid_568521 != nil:
    section.add "resourceGroupName", valid_568521
  var valid_568522 = path.getOrDefault("subscriptionId")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "subscriptionId", valid_568522
  var valid_568523 = path.getOrDefault("hostGroupName")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "hostGroupName", valid_568523
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568524 = query.getOrDefault("api-version")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = nil)
  if valid_568524 != nil:
    section.add "api-version", valid_568524
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

proc call*(call_568526: Call_DedicatedHostGroupsCreateOrUpdate_568518;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a dedicated host group. For details of Dedicated Host and Dedicated Host Groups please see [Dedicated Host Documentation] (https://go.microsoft.com/fwlink/?linkid=2082596)
  ## 
  let valid = call_568526.validator(path, query, header, formData, body)
  let scheme = call_568526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568526.url(scheme.get, call_568526.host, call_568526.base,
                         call_568526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568526, url, valid)

proc call*(call_568527: Call_DedicatedHostGroupsCreateOrUpdate_568518;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; hostGroupName: string): Recallable =
  ## dedicatedHostGroupsCreateOrUpdate
  ## Create or update a dedicated host group. For details of Dedicated Host and Dedicated Host Groups please see [Dedicated Host Documentation] (https://go.microsoft.com/fwlink/?linkid=2082596)
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Dedicated Host Group.
  ##   hostGroupName: string (required)
  ##                : The name of the dedicated host group.
  var path_568528 = newJObject()
  var query_568529 = newJObject()
  var body_568530 = newJObject()
  add(path_568528, "resourceGroupName", newJString(resourceGroupName))
  add(query_568529, "api-version", newJString(apiVersion))
  add(path_568528, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568530 = parameters
  add(path_568528, "hostGroupName", newJString(hostGroupName))
  result = call_568527.call(path_568528, query_568529, nil, nil, body_568530)

var dedicatedHostGroupsCreateOrUpdate* = Call_DedicatedHostGroupsCreateOrUpdate_568518(
    name: "dedicatedHostGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}",
    validator: validate_DedicatedHostGroupsCreateOrUpdate_568519, base: "",
    url: url_DedicatedHostGroupsCreateOrUpdate_568520, schemes: {Scheme.Https})
type
  Call_DedicatedHostGroupsGet_568507 = ref object of OpenApiRestCall_567667
proc url_DedicatedHostGroupsGet_568509(protocol: Scheme; host: string; base: string;
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

proc validate_DedicatedHostGroupsGet_568508(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves information about a dedicated host group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hostGroupName: JString (required)
  ##                : The name of the dedicated host group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568510 = path.getOrDefault("resourceGroupName")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "resourceGroupName", valid_568510
  var valid_568511 = path.getOrDefault("subscriptionId")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "subscriptionId", valid_568511
  var valid_568512 = path.getOrDefault("hostGroupName")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = nil)
  if valid_568512 != nil:
    section.add "hostGroupName", valid_568512
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568513 = query.getOrDefault("api-version")
  valid_568513 = validateParameter(valid_568513, JString, required = true,
                                 default = nil)
  if valid_568513 != nil:
    section.add "api-version", valid_568513
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568514: Call_DedicatedHostGroupsGet_568507; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a dedicated host group.
  ## 
  let valid = call_568514.validator(path, query, header, formData, body)
  let scheme = call_568514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568514.url(scheme.get, call_568514.host, call_568514.base,
                         call_568514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568514, url, valid)

proc call*(call_568515: Call_DedicatedHostGroupsGet_568507;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          hostGroupName: string): Recallable =
  ## dedicatedHostGroupsGet
  ## Retrieves information about a dedicated host group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hostGroupName: string (required)
  ##                : The name of the dedicated host group.
  var path_568516 = newJObject()
  var query_568517 = newJObject()
  add(path_568516, "resourceGroupName", newJString(resourceGroupName))
  add(query_568517, "api-version", newJString(apiVersion))
  add(path_568516, "subscriptionId", newJString(subscriptionId))
  add(path_568516, "hostGroupName", newJString(hostGroupName))
  result = call_568515.call(path_568516, query_568517, nil, nil, nil)

var dedicatedHostGroupsGet* = Call_DedicatedHostGroupsGet_568507(
    name: "dedicatedHostGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}",
    validator: validate_DedicatedHostGroupsGet_568508, base: "",
    url: url_DedicatedHostGroupsGet_568509, schemes: {Scheme.Https})
type
  Call_DedicatedHostGroupsUpdate_568542 = ref object of OpenApiRestCall_567667
proc url_DedicatedHostGroupsUpdate_568544(protocol: Scheme; host: string;
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

proc validate_DedicatedHostGroupsUpdate_568543(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an dedicated host group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hostGroupName: JString (required)
  ##                : The name of the dedicated host group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568545 = path.getOrDefault("resourceGroupName")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "resourceGroupName", valid_568545
  var valid_568546 = path.getOrDefault("subscriptionId")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "subscriptionId", valid_568546
  var valid_568547 = path.getOrDefault("hostGroupName")
  valid_568547 = validateParameter(valid_568547, JString, required = true,
                                 default = nil)
  if valid_568547 != nil:
    section.add "hostGroupName", valid_568547
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568548 = query.getOrDefault("api-version")
  valid_568548 = validateParameter(valid_568548, JString, required = true,
                                 default = nil)
  if valid_568548 != nil:
    section.add "api-version", valid_568548
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

proc call*(call_568550: Call_DedicatedHostGroupsUpdate_568542; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an dedicated host group.
  ## 
  let valid = call_568550.validator(path, query, header, formData, body)
  let scheme = call_568550.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568550.url(scheme.get, call_568550.host, call_568550.base,
                         call_568550.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568550, url, valid)

proc call*(call_568551: Call_DedicatedHostGroupsUpdate_568542;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; hostGroupName: string): Recallable =
  ## dedicatedHostGroupsUpdate
  ## Update an dedicated host group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Dedicated Host Group operation.
  ##   hostGroupName: string (required)
  ##                : The name of the dedicated host group.
  var path_568552 = newJObject()
  var query_568553 = newJObject()
  var body_568554 = newJObject()
  add(path_568552, "resourceGroupName", newJString(resourceGroupName))
  add(query_568553, "api-version", newJString(apiVersion))
  add(path_568552, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568554 = parameters
  add(path_568552, "hostGroupName", newJString(hostGroupName))
  result = call_568551.call(path_568552, query_568553, nil, nil, body_568554)

var dedicatedHostGroupsUpdate* = Call_DedicatedHostGroupsUpdate_568542(
    name: "dedicatedHostGroupsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}",
    validator: validate_DedicatedHostGroupsUpdate_568543, base: "",
    url: url_DedicatedHostGroupsUpdate_568544, schemes: {Scheme.Https})
type
  Call_DedicatedHostGroupsDelete_568531 = ref object of OpenApiRestCall_567667
proc url_DedicatedHostGroupsDelete_568533(protocol: Scheme; host: string;
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

proc validate_DedicatedHostGroupsDelete_568532(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a dedicated host group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hostGroupName: JString (required)
  ##                : The name of the dedicated host group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568534 = path.getOrDefault("resourceGroupName")
  valid_568534 = validateParameter(valid_568534, JString, required = true,
                                 default = nil)
  if valid_568534 != nil:
    section.add "resourceGroupName", valid_568534
  var valid_568535 = path.getOrDefault("subscriptionId")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "subscriptionId", valid_568535
  var valid_568536 = path.getOrDefault("hostGroupName")
  valid_568536 = validateParameter(valid_568536, JString, required = true,
                                 default = nil)
  if valid_568536 != nil:
    section.add "hostGroupName", valid_568536
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568537 = query.getOrDefault("api-version")
  valid_568537 = validateParameter(valid_568537, JString, required = true,
                                 default = nil)
  if valid_568537 != nil:
    section.add "api-version", valid_568537
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568538: Call_DedicatedHostGroupsDelete_568531; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a dedicated host group.
  ## 
  let valid = call_568538.validator(path, query, header, formData, body)
  let scheme = call_568538.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568538.url(scheme.get, call_568538.host, call_568538.base,
                         call_568538.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568538, url, valid)

proc call*(call_568539: Call_DedicatedHostGroupsDelete_568531;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          hostGroupName: string): Recallable =
  ## dedicatedHostGroupsDelete
  ## Delete a dedicated host group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hostGroupName: string (required)
  ##                : The name of the dedicated host group.
  var path_568540 = newJObject()
  var query_568541 = newJObject()
  add(path_568540, "resourceGroupName", newJString(resourceGroupName))
  add(query_568541, "api-version", newJString(apiVersion))
  add(path_568540, "subscriptionId", newJString(subscriptionId))
  add(path_568540, "hostGroupName", newJString(hostGroupName))
  result = call_568539.call(path_568540, query_568541, nil, nil, nil)

var dedicatedHostGroupsDelete* = Call_DedicatedHostGroupsDelete_568531(
    name: "dedicatedHostGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}",
    validator: validate_DedicatedHostGroupsDelete_568532, base: "",
    url: url_DedicatedHostGroupsDelete_568533, schemes: {Scheme.Https})
type
  Call_DedicatedHostsListByHostGroup_568555 = ref object of OpenApiRestCall_567667
proc url_DedicatedHostsListByHostGroup_568557(protocol: Scheme; host: string;
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

proc validate_DedicatedHostsListByHostGroup_568556(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the dedicated hosts in the specified dedicated host group. Use the nextLink property in the response to get the next page of dedicated hosts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hostGroupName: JString (required)
  ##                : The name of the dedicated host group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568558 = path.getOrDefault("resourceGroupName")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "resourceGroupName", valid_568558
  var valid_568559 = path.getOrDefault("subscriptionId")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "subscriptionId", valid_568559
  var valid_568560 = path.getOrDefault("hostGroupName")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "hostGroupName", valid_568560
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568561 = query.getOrDefault("api-version")
  valid_568561 = validateParameter(valid_568561, JString, required = true,
                                 default = nil)
  if valid_568561 != nil:
    section.add "api-version", valid_568561
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568562: Call_DedicatedHostsListByHostGroup_568555; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the dedicated hosts in the specified dedicated host group. Use the nextLink property in the response to get the next page of dedicated hosts.
  ## 
  let valid = call_568562.validator(path, query, header, formData, body)
  let scheme = call_568562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568562.url(scheme.get, call_568562.host, call_568562.base,
                         call_568562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568562, url, valid)

proc call*(call_568563: Call_DedicatedHostsListByHostGroup_568555;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          hostGroupName: string): Recallable =
  ## dedicatedHostsListByHostGroup
  ## Lists all of the dedicated hosts in the specified dedicated host group. Use the nextLink property in the response to get the next page of dedicated hosts.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hostGroupName: string (required)
  ##                : The name of the dedicated host group.
  var path_568564 = newJObject()
  var query_568565 = newJObject()
  add(path_568564, "resourceGroupName", newJString(resourceGroupName))
  add(query_568565, "api-version", newJString(apiVersion))
  add(path_568564, "subscriptionId", newJString(subscriptionId))
  add(path_568564, "hostGroupName", newJString(hostGroupName))
  result = call_568563.call(path_568564, query_568565, nil, nil, nil)

var dedicatedHostsListByHostGroup* = Call_DedicatedHostsListByHostGroup_568555(
    name: "dedicatedHostsListByHostGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}/hosts",
    validator: validate_DedicatedHostsListByHostGroup_568556, base: "",
    url: url_DedicatedHostsListByHostGroup_568557, schemes: {Scheme.Https})
type
  Call_DedicatedHostsCreateOrUpdate_568592 = ref object of OpenApiRestCall_567667
proc url_DedicatedHostsCreateOrUpdate_568594(protocol: Scheme; host: string;
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

proc validate_DedicatedHostsCreateOrUpdate_568593(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create or update a dedicated host .
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hostName: JString (required)
  ##           : The name of the dedicated host .
  ##   hostGroupName: JString (required)
  ##                : The name of the dedicated host group.
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
  var valid_568597 = path.getOrDefault("hostName")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "hostName", valid_568597
  var valid_568598 = path.getOrDefault("hostGroupName")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "hostGroupName", valid_568598
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568599 = query.getOrDefault("api-version")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = nil)
  if valid_568599 != nil:
    section.add "api-version", valid_568599
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

proc call*(call_568601: Call_DedicatedHostsCreateOrUpdate_568592; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a dedicated host .
  ## 
  let valid = call_568601.validator(path, query, header, formData, body)
  let scheme = call_568601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568601.url(scheme.get, call_568601.host, call_568601.base,
                         call_568601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568601, url, valid)

proc call*(call_568602: Call_DedicatedHostsCreateOrUpdate_568592;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          hostName: string; parameters: JsonNode; hostGroupName: string): Recallable =
  ## dedicatedHostsCreateOrUpdate
  ## Create or update a dedicated host .
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hostName: string (required)
  ##           : The name of the dedicated host .
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Create Dedicated Host.
  ##   hostGroupName: string (required)
  ##                : The name of the dedicated host group.
  var path_568603 = newJObject()
  var query_568604 = newJObject()
  var body_568605 = newJObject()
  add(path_568603, "resourceGroupName", newJString(resourceGroupName))
  add(query_568604, "api-version", newJString(apiVersion))
  add(path_568603, "subscriptionId", newJString(subscriptionId))
  add(path_568603, "hostName", newJString(hostName))
  if parameters != nil:
    body_568605 = parameters
  add(path_568603, "hostGroupName", newJString(hostGroupName))
  result = call_568602.call(path_568603, query_568604, nil, nil, body_568605)

var dedicatedHostsCreateOrUpdate* = Call_DedicatedHostsCreateOrUpdate_568592(
    name: "dedicatedHostsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}/hosts/{hostName}",
    validator: validate_DedicatedHostsCreateOrUpdate_568593, base: "",
    url: url_DedicatedHostsCreateOrUpdate_568594, schemes: {Scheme.Https})
type
  Call_DedicatedHostsGet_568566 = ref object of OpenApiRestCall_567667
proc url_DedicatedHostsGet_568568(protocol: Scheme; host: string; base: string;
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

proc validate_DedicatedHostsGet_568567(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves information about a dedicated host.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hostName: JString (required)
  ##           : The name of the dedicated host.
  ##   hostGroupName: JString (required)
  ##                : The name of the dedicated host group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568569 = path.getOrDefault("resourceGroupName")
  valid_568569 = validateParameter(valid_568569, JString, required = true,
                                 default = nil)
  if valid_568569 != nil:
    section.add "resourceGroupName", valid_568569
  var valid_568570 = path.getOrDefault("subscriptionId")
  valid_568570 = validateParameter(valid_568570, JString, required = true,
                                 default = nil)
  if valid_568570 != nil:
    section.add "subscriptionId", valid_568570
  var valid_568571 = path.getOrDefault("hostName")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "hostName", valid_568571
  var valid_568572 = path.getOrDefault("hostGroupName")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "hostGroupName", valid_568572
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_568586 = query.getOrDefault("$expand")
  valid_568586 = validateParameter(valid_568586, JString, required = false,
                                 default = newJString("instanceView"))
  if valid_568586 != nil:
    section.add "$expand", valid_568586
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

proc call*(call_568588: Call_DedicatedHostsGet_568566; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a dedicated host.
  ## 
  let valid = call_568588.validator(path, query, header, formData, body)
  let scheme = call_568588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568588.url(scheme.get, call_568588.host, call_568588.base,
                         call_568588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568588, url, valid)

proc call*(call_568589: Call_DedicatedHostsGet_568566; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; hostName: string;
          hostGroupName: string; Expand: string = "instanceView"): Recallable =
  ## dedicatedHostsGet
  ## Retrieves information about a dedicated host.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hostName: string (required)
  ##           : The name of the dedicated host.
  ##   hostGroupName: string (required)
  ##                : The name of the dedicated host group.
  var path_568590 = newJObject()
  var query_568591 = newJObject()
  add(path_568590, "resourceGroupName", newJString(resourceGroupName))
  add(query_568591, "$expand", newJString(Expand))
  add(query_568591, "api-version", newJString(apiVersion))
  add(path_568590, "subscriptionId", newJString(subscriptionId))
  add(path_568590, "hostName", newJString(hostName))
  add(path_568590, "hostGroupName", newJString(hostGroupName))
  result = call_568589.call(path_568590, query_568591, nil, nil, nil)

var dedicatedHostsGet* = Call_DedicatedHostsGet_568566(name: "dedicatedHostsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}/hosts/{hostName}",
    validator: validate_DedicatedHostsGet_568567, base: "",
    url: url_DedicatedHostsGet_568568, schemes: {Scheme.Https})
type
  Call_DedicatedHostsUpdate_568618 = ref object of OpenApiRestCall_567667
proc url_DedicatedHostsUpdate_568620(protocol: Scheme; host: string; base: string;
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

proc validate_DedicatedHostsUpdate_568619(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an dedicated host .
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hostName: JString (required)
  ##           : The name of the dedicated host .
  ##   hostGroupName: JString (required)
  ##                : The name of the dedicated host group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568621 = path.getOrDefault("resourceGroupName")
  valid_568621 = validateParameter(valid_568621, JString, required = true,
                                 default = nil)
  if valid_568621 != nil:
    section.add "resourceGroupName", valid_568621
  var valid_568622 = path.getOrDefault("subscriptionId")
  valid_568622 = validateParameter(valid_568622, JString, required = true,
                                 default = nil)
  if valid_568622 != nil:
    section.add "subscriptionId", valid_568622
  var valid_568623 = path.getOrDefault("hostName")
  valid_568623 = validateParameter(valid_568623, JString, required = true,
                                 default = nil)
  if valid_568623 != nil:
    section.add "hostName", valid_568623
  var valid_568624 = path.getOrDefault("hostGroupName")
  valid_568624 = validateParameter(valid_568624, JString, required = true,
                                 default = nil)
  if valid_568624 != nil:
    section.add "hostGroupName", valid_568624
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568625 = query.getOrDefault("api-version")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "api-version", valid_568625
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

proc call*(call_568627: Call_DedicatedHostsUpdate_568618; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an dedicated host .
  ## 
  let valid = call_568627.validator(path, query, header, formData, body)
  let scheme = call_568627.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568627.url(scheme.get, call_568627.host, call_568627.base,
                         call_568627.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568627, url, valid)

proc call*(call_568628: Call_DedicatedHostsUpdate_568618;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          hostName: string; parameters: JsonNode; hostGroupName: string): Recallable =
  ## dedicatedHostsUpdate
  ## Update an dedicated host .
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hostName: string (required)
  ##           : The name of the dedicated host .
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Dedicated Host operation.
  ##   hostGroupName: string (required)
  ##                : The name of the dedicated host group.
  var path_568629 = newJObject()
  var query_568630 = newJObject()
  var body_568631 = newJObject()
  add(path_568629, "resourceGroupName", newJString(resourceGroupName))
  add(query_568630, "api-version", newJString(apiVersion))
  add(path_568629, "subscriptionId", newJString(subscriptionId))
  add(path_568629, "hostName", newJString(hostName))
  if parameters != nil:
    body_568631 = parameters
  add(path_568629, "hostGroupName", newJString(hostGroupName))
  result = call_568628.call(path_568629, query_568630, nil, nil, body_568631)

var dedicatedHostsUpdate* = Call_DedicatedHostsUpdate_568618(
    name: "dedicatedHostsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}/hosts/{hostName}",
    validator: validate_DedicatedHostsUpdate_568619, base: "",
    url: url_DedicatedHostsUpdate_568620, schemes: {Scheme.Https})
type
  Call_DedicatedHostsDelete_568606 = ref object of OpenApiRestCall_567667
proc url_DedicatedHostsDelete_568608(protocol: Scheme; host: string; base: string;
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

proc validate_DedicatedHostsDelete_568607(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a dedicated host.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hostName: JString (required)
  ##           : The name of the dedicated host.
  ##   hostGroupName: JString (required)
  ##                : The name of the dedicated host group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568609 = path.getOrDefault("resourceGroupName")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "resourceGroupName", valid_568609
  var valid_568610 = path.getOrDefault("subscriptionId")
  valid_568610 = validateParameter(valid_568610, JString, required = true,
                                 default = nil)
  if valid_568610 != nil:
    section.add "subscriptionId", valid_568610
  var valid_568611 = path.getOrDefault("hostName")
  valid_568611 = validateParameter(valid_568611, JString, required = true,
                                 default = nil)
  if valid_568611 != nil:
    section.add "hostName", valid_568611
  var valid_568612 = path.getOrDefault("hostGroupName")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = nil)
  if valid_568612 != nil:
    section.add "hostGroupName", valid_568612
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568613 = query.getOrDefault("api-version")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "api-version", valid_568613
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568614: Call_DedicatedHostsDelete_568606; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a dedicated host.
  ## 
  let valid = call_568614.validator(path, query, header, formData, body)
  let scheme = call_568614.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568614.url(scheme.get, call_568614.host, call_568614.base,
                         call_568614.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568614, url, valid)

proc call*(call_568615: Call_DedicatedHostsDelete_568606;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          hostName: string; hostGroupName: string): Recallable =
  ## dedicatedHostsDelete
  ## Delete a dedicated host.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   hostName: string (required)
  ##           : The name of the dedicated host.
  ##   hostGroupName: string (required)
  ##                : The name of the dedicated host group.
  var path_568616 = newJObject()
  var query_568617 = newJObject()
  add(path_568616, "resourceGroupName", newJString(resourceGroupName))
  add(query_568617, "api-version", newJString(apiVersion))
  add(path_568616, "subscriptionId", newJString(subscriptionId))
  add(path_568616, "hostName", newJString(hostName))
  add(path_568616, "hostGroupName", newJString(hostGroupName))
  result = call_568615.call(path_568616, query_568617, nil, nil, nil)

var dedicatedHostsDelete* = Call_DedicatedHostsDelete_568606(
    name: "dedicatedHostsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/hostGroups/{hostGroupName}/hosts/{hostName}",
    validator: validate_DedicatedHostsDelete_568607, base: "",
    url: url_DedicatedHostsDelete_568608, schemes: {Scheme.Https})
type
  Call_ImagesListByResourceGroup_568632 = ref object of OpenApiRestCall_567667
proc url_ImagesListByResourceGroup_568634(protocol: Scheme; host: string;
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

proc validate_ImagesListByResourceGroup_568633(path: JsonNode; query: JsonNode;
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
  var valid_568635 = path.getOrDefault("resourceGroupName")
  valid_568635 = validateParameter(valid_568635, JString, required = true,
                                 default = nil)
  if valid_568635 != nil:
    section.add "resourceGroupName", valid_568635
  var valid_568636 = path.getOrDefault("subscriptionId")
  valid_568636 = validateParameter(valid_568636, JString, required = true,
                                 default = nil)
  if valid_568636 != nil:
    section.add "subscriptionId", valid_568636
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568637 = query.getOrDefault("api-version")
  valid_568637 = validateParameter(valid_568637, JString, required = true,
                                 default = nil)
  if valid_568637 != nil:
    section.add "api-version", valid_568637
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568638: Call_ImagesListByResourceGroup_568632; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of images under a resource group.
  ## 
  let valid = call_568638.validator(path, query, header, formData, body)
  let scheme = call_568638.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568638.url(scheme.get, call_568638.host, call_568638.base,
                         call_568638.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568638, url, valid)

proc call*(call_568639: Call_ImagesListByResourceGroup_568632;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## imagesListByResourceGroup
  ## Gets the list of images under a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568640 = newJObject()
  var query_568641 = newJObject()
  add(path_568640, "resourceGroupName", newJString(resourceGroupName))
  add(query_568641, "api-version", newJString(apiVersion))
  add(path_568640, "subscriptionId", newJString(subscriptionId))
  result = call_568639.call(path_568640, query_568641, nil, nil, nil)

var imagesListByResourceGroup* = Call_ImagesListByResourceGroup_568632(
    name: "imagesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images",
    validator: validate_ImagesListByResourceGroup_568633, base: "",
    url: url_ImagesListByResourceGroup_568634, schemes: {Scheme.Https})
type
  Call_ImagesCreateOrUpdate_568654 = ref object of OpenApiRestCall_567667
proc url_ImagesCreateOrUpdate_568656(protocol: Scheme; host: string; base: string;
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

proc validate_ImagesCreateOrUpdate_568655(path: JsonNode; query: JsonNode;
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
  var valid_568659 = path.getOrDefault("imageName")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "imageName", valid_568659
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568660 = query.getOrDefault("api-version")
  valid_568660 = validateParameter(valid_568660, JString, required = true,
                                 default = nil)
  if valid_568660 != nil:
    section.add "api-version", valid_568660
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

proc call*(call_568662: Call_ImagesCreateOrUpdate_568654; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an image.
  ## 
  let valid = call_568662.validator(path, query, header, formData, body)
  let scheme = call_568662.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568662.url(scheme.get, call_568662.host, call_568662.base,
                         call_568662.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568662, url, valid)

proc call*(call_568663: Call_ImagesCreateOrUpdate_568654;
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
  var path_568664 = newJObject()
  var query_568665 = newJObject()
  var body_568666 = newJObject()
  add(path_568664, "resourceGroupName", newJString(resourceGroupName))
  add(query_568665, "api-version", newJString(apiVersion))
  add(path_568664, "subscriptionId", newJString(subscriptionId))
  add(path_568664, "imageName", newJString(imageName))
  if parameters != nil:
    body_568666 = parameters
  result = call_568663.call(path_568664, query_568665, nil, nil, body_568666)

var imagesCreateOrUpdate* = Call_ImagesCreateOrUpdate_568654(
    name: "imagesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesCreateOrUpdate_568655, base: "",
    url: url_ImagesCreateOrUpdate_568656, schemes: {Scheme.Https})
type
  Call_ImagesGet_568642 = ref object of OpenApiRestCall_567667
proc url_ImagesGet_568644(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ImagesGet_568643(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568645 = path.getOrDefault("resourceGroupName")
  valid_568645 = validateParameter(valid_568645, JString, required = true,
                                 default = nil)
  if valid_568645 != nil:
    section.add "resourceGroupName", valid_568645
  var valid_568646 = path.getOrDefault("subscriptionId")
  valid_568646 = validateParameter(valid_568646, JString, required = true,
                                 default = nil)
  if valid_568646 != nil:
    section.add "subscriptionId", valid_568646
  var valid_568647 = path.getOrDefault("imageName")
  valid_568647 = validateParameter(valid_568647, JString, required = true,
                                 default = nil)
  if valid_568647 != nil:
    section.add "imageName", valid_568647
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_568648 = query.getOrDefault("$expand")
  valid_568648 = validateParameter(valid_568648, JString, required = false,
                                 default = nil)
  if valid_568648 != nil:
    section.add "$expand", valid_568648
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568649 = query.getOrDefault("api-version")
  valid_568649 = validateParameter(valid_568649, JString, required = true,
                                 default = nil)
  if valid_568649 != nil:
    section.add "api-version", valid_568649
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568650: Call_ImagesGet_568642; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an image.
  ## 
  let valid = call_568650.validator(path, query, header, formData, body)
  let scheme = call_568650.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568650.url(scheme.get, call_568650.host, call_568650.base,
                         call_568650.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568650, url, valid)

proc call*(call_568651: Call_ImagesGet_568642; resourceGroupName: string;
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
  var path_568652 = newJObject()
  var query_568653 = newJObject()
  add(path_568652, "resourceGroupName", newJString(resourceGroupName))
  add(query_568653, "$expand", newJString(Expand))
  add(query_568653, "api-version", newJString(apiVersion))
  add(path_568652, "subscriptionId", newJString(subscriptionId))
  add(path_568652, "imageName", newJString(imageName))
  result = call_568651.call(path_568652, query_568653, nil, nil, nil)

var imagesGet* = Call_ImagesGet_568642(name: "imagesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
                                    validator: validate_ImagesGet_568643,
                                    base: "", url: url_ImagesGet_568644,
                                    schemes: {Scheme.Https})
type
  Call_ImagesUpdate_568678 = ref object of OpenApiRestCall_567667
proc url_ImagesUpdate_568680(protocol: Scheme; host: string; base: string;
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

proc validate_ImagesUpdate_568679(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568683 = path.getOrDefault("imageName")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "imageName", valid_568683
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568684 = query.getOrDefault("api-version")
  valid_568684 = validateParameter(valid_568684, JString, required = true,
                                 default = nil)
  if valid_568684 != nil:
    section.add "api-version", valid_568684
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

proc call*(call_568686: Call_ImagesUpdate_568678; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an image.
  ## 
  let valid = call_568686.validator(path, query, header, formData, body)
  let scheme = call_568686.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568686.url(scheme.get, call_568686.host, call_568686.base,
                         call_568686.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568686, url, valid)

proc call*(call_568687: Call_ImagesUpdate_568678; resourceGroupName: string;
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
  var path_568688 = newJObject()
  var query_568689 = newJObject()
  var body_568690 = newJObject()
  add(path_568688, "resourceGroupName", newJString(resourceGroupName))
  add(query_568689, "api-version", newJString(apiVersion))
  add(path_568688, "subscriptionId", newJString(subscriptionId))
  add(path_568688, "imageName", newJString(imageName))
  if parameters != nil:
    body_568690 = parameters
  result = call_568687.call(path_568688, query_568689, nil, nil, body_568690)

var imagesUpdate* = Call_ImagesUpdate_568678(name: "imagesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesUpdate_568679, base: "", url: url_ImagesUpdate_568680,
    schemes: {Scheme.Https})
type
  Call_ImagesDelete_568667 = ref object of OpenApiRestCall_567667
proc url_ImagesDelete_568669(protocol: Scheme; host: string; base: string;
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

proc validate_ImagesDelete_568668(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568670 = path.getOrDefault("resourceGroupName")
  valid_568670 = validateParameter(valid_568670, JString, required = true,
                                 default = nil)
  if valid_568670 != nil:
    section.add "resourceGroupName", valid_568670
  var valid_568671 = path.getOrDefault("subscriptionId")
  valid_568671 = validateParameter(valid_568671, JString, required = true,
                                 default = nil)
  if valid_568671 != nil:
    section.add "subscriptionId", valid_568671
  var valid_568672 = path.getOrDefault("imageName")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "imageName", valid_568672
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568673 = query.getOrDefault("api-version")
  valid_568673 = validateParameter(valid_568673, JString, required = true,
                                 default = nil)
  if valid_568673 != nil:
    section.add "api-version", valid_568673
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568674: Call_ImagesDelete_568667; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Image.
  ## 
  let valid = call_568674.validator(path, query, header, formData, body)
  let scheme = call_568674.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568674.url(scheme.get, call_568674.host, call_568674.base,
                         call_568674.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568674, url, valid)

proc call*(call_568675: Call_ImagesDelete_568667; resourceGroupName: string;
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
  var path_568676 = newJObject()
  var query_568677 = newJObject()
  add(path_568676, "resourceGroupName", newJString(resourceGroupName))
  add(query_568677, "api-version", newJString(apiVersion))
  add(path_568676, "subscriptionId", newJString(subscriptionId))
  add(path_568676, "imageName", newJString(imageName))
  result = call_568675.call(path_568676, query_568677, nil, nil, nil)

var imagesDelete* = Call_ImagesDelete_568667(name: "imagesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesDelete_568668, base: "", url: url_ImagesDelete_568669,
    schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsListByResourceGroup_568691 = ref object of OpenApiRestCall_567667
proc url_ProximityPlacementGroupsListByResourceGroup_568693(protocol: Scheme;
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

proc validate_ProximityPlacementGroupsListByResourceGroup_568692(path: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_568697: Call_ProximityPlacementGroupsListByResourceGroup_568691;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all proximity placement groups in a resource group.
  ## 
  let valid = call_568697.validator(path, query, header, formData, body)
  let scheme = call_568697.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568697.url(scheme.get, call_568697.host, call_568697.base,
                         call_568697.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568697, url, valid)

proc call*(call_568698: Call_ProximityPlacementGroupsListByResourceGroup_568691;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## proximityPlacementGroupsListByResourceGroup
  ## Lists all proximity placement groups in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568699 = newJObject()
  var query_568700 = newJObject()
  add(path_568699, "resourceGroupName", newJString(resourceGroupName))
  add(query_568700, "api-version", newJString(apiVersion))
  add(path_568699, "subscriptionId", newJString(subscriptionId))
  result = call_568698.call(path_568699, query_568700, nil, nil, nil)

var proximityPlacementGroupsListByResourceGroup* = Call_ProximityPlacementGroupsListByResourceGroup_568691(
    name: "proximityPlacementGroupsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups",
    validator: validate_ProximityPlacementGroupsListByResourceGroup_568692,
    base: "", url: url_ProximityPlacementGroupsListByResourceGroup_568693,
    schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsCreateOrUpdate_568712 = ref object of OpenApiRestCall_567667
proc url_ProximityPlacementGroupsCreateOrUpdate_568714(protocol: Scheme;
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

proc validate_ProximityPlacementGroupsCreateOrUpdate_568713(path: JsonNode;
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
  var valid_568715 = path.getOrDefault("resourceGroupName")
  valid_568715 = validateParameter(valid_568715, JString, required = true,
                                 default = nil)
  if valid_568715 != nil:
    section.add "resourceGroupName", valid_568715
  var valid_568716 = path.getOrDefault("subscriptionId")
  valid_568716 = validateParameter(valid_568716, JString, required = true,
                                 default = nil)
  if valid_568716 != nil:
    section.add "subscriptionId", valid_568716
  var valid_568717 = path.getOrDefault("proximityPlacementGroupName")
  valid_568717 = validateParameter(valid_568717, JString, required = true,
                                 default = nil)
  if valid_568717 != nil:
    section.add "proximityPlacementGroupName", valid_568717
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568718 = query.getOrDefault("api-version")
  valid_568718 = validateParameter(valid_568718, JString, required = true,
                                 default = nil)
  if valid_568718 != nil:
    section.add "api-version", valid_568718
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

proc call*(call_568720: Call_ProximityPlacementGroupsCreateOrUpdate_568712;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a proximity placement group.
  ## 
  let valid = call_568720.validator(path, query, header, formData, body)
  let scheme = call_568720.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568720.url(scheme.get, call_568720.host, call_568720.base,
                         call_568720.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568720, url, valid)

proc call*(call_568721: Call_ProximityPlacementGroupsCreateOrUpdate_568712;
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
  var path_568722 = newJObject()
  var query_568723 = newJObject()
  var body_568724 = newJObject()
  add(path_568722, "resourceGroupName", newJString(resourceGroupName))
  add(query_568723, "api-version", newJString(apiVersion))
  add(path_568722, "subscriptionId", newJString(subscriptionId))
  add(path_568722, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  if parameters != nil:
    body_568724 = parameters
  result = call_568721.call(path_568722, query_568723, nil, nil, body_568724)

var proximityPlacementGroupsCreateOrUpdate* = Call_ProximityPlacementGroupsCreateOrUpdate_568712(
    name: "proximityPlacementGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsCreateOrUpdate_568713, base: "",
    url: url_ProximityPlacementGroupsCreateOrUpdate_568714,
    schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsGet_568701 = ref object of OpenApiRestCall_567667
proc url_ProximityPlacementGroupsGet_568703(protocol: Scheme; host: string;
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

proc validate_ProximityPlacementGroupsGet_568702(path: JsonNode; query: JsonNode;
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
  var valid_568704 = path.getOrDefault("resourceGroupName")
  valid_568704 = validateParameter(valid_568704, JString, required = true,
                                 default = nil)
  if valid_568704 != nil:
    section.add "resourceGroupName", valid_568704
  var valid_568705 = path.getOrDefault("subscriptionId")
  valid_568705 = validateParameter(valid_568705, JString, required = true,
                                 default = nil)
  if valid_568705 != nil:
    section.add "subscriptionId", valid_568705
  var valid_568706 = path.getOrDefault("proximityPlacementGroupName")
  valid_568706 = validateParameter(valid_568706, JString, required = true,
                                 default = nil)
  if valid_568706 != nil:
    section.add "proximityPlacementGroupName", valid_568706
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568707 = query.getOrDefault("api-version")
  valid_568707 = validateParameter(valid_568707, JString, required = true,
                                 default = nil)
  if valid_568707 != nil:
    section.add "api-version", valid_568707
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568708: Call_ProximityPlacementGroupsGet_568701; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a proximity placement group .
  ## 
  let valid = call_568708.validator(path, query, header, formData, body)
  let scheme = call_568708.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568708.url(scheme.get, call_568708.host, call_568708.base,
                         call_568708.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568708, url, valid)

proc call*(call_568709: Call_ProximityPlacementGroupsGet_568701;
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
  var path_568710 = newJObject()
  var query_568711 = newJObject()
  add(path_568710, "resourceGroupName", newJString(resourceGroupName))
  add(query_568711, "api-version", newJString(apiVersion))
  add(path_568710, "subscriptionId", newJString(subscriptionId))
  add(path_568710, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  result = call_568709.call(path_568710, query_568711, nil, nil, nil)

var proximityPlacementGroupsGet* = Call_ProximityPlacementGroupsGet_568701(
    name: "proximityPlacementGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsGet_568702, base: "",
    url: url_ProximityPlacementGroupsGet_568703, schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsUpdate_568736 = ref object of OpenApiRestCall_567667
proc url_ProximityPlacementGroupsUpdate_568738(protocol: Scheme; host: string;
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

proc validate_ProximityPlacementGroupsUpdate_568737(path: JsonNode;
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
  var valid_568739 = path.getOrDefault("resourceGroupName")
  valid_568739 = validateParameter(valid_568739, JString, required = true,
                                 default = nil)
  if valid_568739 != nil:
    section.add "resourceGroupName", valid_568739
  var valid_568740 = path.getOrDefault("subscriptionId")
  valid_568740 = validateParameter(valid_568740, JString, required = true,
                                 default = nil)
  if valid_568740 != nil:
    section.add "subscriptionId", valid_568740
  var valid_568741 = path.getOrDefault("proximityPlacementGroupName")
  valid_568741 = validateParameter(valid_568741, JString, required = true,
                                 default = nil)
  if valid_568741 != nil:
    section.add "proximityPlacementGroupName", valid_568741
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568742 = query.getOrDefault("api-version")
  valid_568742 = validateParameter(valid_568742, JString, required = true,
                                 default = nil)
  if valid_568742 != nil:
    section.add "api-version", valid_568742
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

proc call*(call_568744: Call_ProximityPlacementGroupsUpdate_568736; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a proximity placement group.
  ## 
  let valid = call_568744.validator(path, query, header, formData, body)
  let scheme = call_568744.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568744.url(scheme.get, call_568744.host, call_568744.base,
                         call_568744.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568744, url, valid)

proc call*(call_568745: Call_ProximityPlacementGroupsUpdate_568736;
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
  var path_568746 = newJObject()
  var query_568747 = newJObject()
  var body_568748 = newJObject()
  add(path_568746, "resourceGroupName", newJString(resourceGroupName))
  add(query_568747, "api-version", newJString(apiVersion))
  add(path_568746, "subscriptionId", newJString(subscriptionId))
  add(path_568746, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  if parameters != nil:
    body_568748 = parameters
  result = call_568745.call(path_568746, query_568747, nil, nil, body_568748)

var proximityPlacementGroupsUpdate* = Call_ProximityPlacementGroupsUpdate_568736(
    name: "proximityPlacementGroupsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsUpdate_568737, base: "",
    url: url_ProximityPlacementGroupsUpdate_568738, schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsDelete_568725 = ref object of OpenApiRestCall_567667
proc url_ProximityPlacementGroupsDelete_568727(protocol: Scheme; host: string;
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

proc validate_ProximityPlacementGroupsDelete_568726(path: JsonNode;
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
  var valid_568728 = path.getOrDefault("resourceGroupName")
  valid_568728 = validateParameter(valid_568728, JString, required = true,
                                 default = nil)
  if valid_568728 != nil:
    section.add "resourceGroupName", valid_568728
  var valid_568729 = path.getOrDefault("subscriptionId")
  valid_568729 = validateParameter(valid_568729, JString, required = true,
                                 default = nil)
  if valid_568729 != nil:
    section.add "subscriptionId", valid_568729
  var valid_568730 = path.getOrDefault("proximityPlacementGroupName")
  valid_568730 = validateParameter(valid_568730, JString, required = true,
                                 default = nil)
  if valid_568730 != nil:
    section.add "proximityPlacementGroupName", valid_568730
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568731 = query.getOrDefault("api-version")
  valid_568731 = validateParameter(valid_568731, JString, required = true,
                                 default = nil)
  if valid_568731 != nil:
    section.add "api-version", valid_568731
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568732: Call_ProximityPlacementGroupsDelete_568725; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a proximity placement group.
  ## 
  let valid = call_568732.validator(path, query, header, formData, body)
  let scheme = call_568732.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568732.url(scheme.get, call_568732.host, call_568732.base,
                         call_568732.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568732, url, valid)

proc call*(call_568733: Call_ProximityPlacementGroupsDelete_568725;
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
  var path_568734 = newJObject()
  var query_568735 = newJObject()
  add(path_568734, "resourceGroupName", newJString(resourceGroupName))
  add(query_568735, "api-version", newJString(apiVersion))
  add(path_568734, "subscriptionId", newJString(subscriptionId))
  add(path_568734, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  result = call_568733.call(path_568734, query_568735, nil, nil, nil)

var proximityPlacementGroupsDelete* = Call_ProximityPlacementGroupsDelete_568725(
    name: "proximityPlacementGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsDelete_568726, base: "",
    url: url_ProximityPlacementGroupsDelete_568727, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsList_568749 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsList_568751(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsList_568750(path: JsonNode; query: JsonNode;
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
  var valid_568752 = path.getOrDefault("resourceGroupName")
  valid_568752 = validateParameter(valid_568752, JString, required = true,
                                 default = nil)
  if valid_568752 != nil:
    section.add "resourceGroupName", valid_568752
  var valid_568753 = path.getOrDefault("subscriptionId")
  valid_568753 = validateParameter(valid_568753, JString, required = true,
                                 default = nil)
  if valid_568753 != nil:
    section.add "subscriptionId", valid_568753
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568754 = query.getOrDefault("api-version")
  valid_568754 = validateParameter(valid_568754, JString, required = true,
                                 default = nil)
  if valid_568754 != nil:
    section.add "api-version", valid_568754
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568755: Call_VirtualMachineScaleSetsList_568749; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all VM scale sets under a resource group.
  ## 
  let valid = call_568755.validator(path, query, header, formData, body)
  let scheme = call_568755.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568755.url(scheme.get, call_568755.host, call_568755.base,
                         call_568755.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568755, url, valid)

proc call*(call_568756: Call_VirtualMachineScaleSetsList_568749;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsList
  ## Gets a list of all VM scale sets under a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568757 = newJObject()
  var query_568758 = newJObject()
  add(path_568757, "resourceGroupName", newJString(resourceGroupName))
  add(query_568758, "api-version", newJString(apiVersion))
  add(path_568757, "subscriptionId", newJString(subscriptionId))
  result = call_568756.call(path_568757, query_568758, nil, nil, nil)

var virtualMachineScaleSetsList* = Call_VirtualMachineScaleSetsList_568749(
    name: "virtualMachineScaleSetsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets",
    validator: validate_VirtualMachineScaleSetsList_568750, base: "",
    url: url_VirtualMachineScaleSetsList_568751, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsList_568759 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsList_568761(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsList_568760(path: JsonNode; query: JsonNode;
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
  var valid_568762 = path.getOrDefault("resourceGroupName")
  valid_568762 = validateParameter(valid_568762, JString, required = true,
                                 default = nil)
  if valid_568762 != nil:
    section.add "resourceGroupName", valid_568762
  var valid_568763 = path.getOrDefault("subscriptionId")
  valid_568763 = validateParameter(valid_568763, JString, required = true,
                                 default = nil)
  if valid_568763 != nil:
    section.add "subscriptionId", valid_568763
  var valid_568764 = path.getOrDefault("virtualMachineScaleSetName")
  valid_568764 = validateParameter(valid_568764, JString, required = true,
                                 default = nil)
  if valid_568764 != nil:
    section.add "virtualMachineScaleSetName", valid_568764
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
  var valid_568765 = query.getOrDefault("$expand")
  valid_568765 = validateParameter(valid_568765, JString, required = false,
                                 default = nil)
  if valid_568765 != nil:
    section.add "$expand", valid_568765
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568766 = query.getOrDefault("api-version")
  valid_568766 = validateParameter(valid_568766, JString, required = true,
                                 default = nil)
  if valid_568766 != nil:
    section.add "api-version", valid_568766
  var valid_568767 = query.getOrDefault("$select")
  valid_568767 = validateParameter(valid_568767, JString, required = false,
                                 default = nil)
  if valid_568767 != nil:
    section.add "$select", valid_568767
  var valid_568768 = query.getOrDefault("$filter")
  valid_568768 = validateParameter(valid_568768, JString, required = false,
                                 default = nil)
  if valid_568768 != nil:
    section.add "$filter", valid_568768
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568769: Call_VirtualMachineScaleSetVMsList_568759; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all virtual machines in a VM scale sets.
  ## 
  let valid = call_568769.validator(path, query, header, formData, body)
  let scheme = call_568769.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568769.url(scheme.get, call_568769.host, call_568769.base,
                         call_568769.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568769, url, valid)

proc call*(call_568770: Call_VirtualMachineScaleSetVMsList_568759;
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
  var path_568771 = newJObject()
  var query_568772 = newJObject()
  add(path_568771, "resourceGroupName", newJString(resourceGroupName))
  add(query_568772, "$expand", newJString(Expand))
  add(query_568772, "api-version", newJString(apiVersion))
  add(path_568771, "subscriptionId", newJString(subscriptionId))
  add(query_568772, "$select", newJString(Select))
  add(path_568771, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  add(query_568772, "$filter", newJString(Filter))
  result = call_568770.call(path_568771, query_568772, nil, nil, nil)

var virtualMachineScaleSetVMsList* = Call_VirtualMachineScaleSetVMsList_568759(
    name: "virtualMachineScaleSetVMsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines",
    validator: validate_VirtualMachineScaleSetVMsList_568760, base: "",
    url: url_VirtualMachineScaleSetVMsList_568761, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsCreateOrUpdate_568784 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsCreateOrUpdate_568786(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsCreateOrUpdate_568785(path: JsonNode;
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
  var valid_568787 = path.getOrDefault("vmScaleSetName")
  valid_568787 = validateParameter(valid_568787, JString, required = true,
                                 default = nil)
  if valid_568787 != nil:
    section.add "vmScaleSetName", valid_568787
  var valid_568788 = path.getOrDefault("resourceGroupName")
  valid_568788 = validateParameter(valid_568788, JString, required = true,
                                 default = nil)
  if valid_568788 != nil:
    section.add "resourceGroupName", valid_568788
  var valid_568789 = path.getOrDefault("subscriptionId")
  valid_568789 = validateParameter(valid_568789, JString, required = true,
                                 default = nil)
  if valid_568789 != nil:
    section.add "subscriptionId", valid_568789
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568790 = query.getOrDefault("api-version")
  valid_568790 = validateParameter(valid_568790, JString, required = true,
                                 default = nil)
  if valid_568790 != nil:
    section.add "api-version", valid_568790
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

proc call*(call_568792: Call_VirtualMachineScaleSetsCreateOrUpdate_568784;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a VM scale set.
  ## 
  let valid = call_568792.validator(path, query, header, formData, body)
  let scheme = call_568792.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568792.url(scheme.get, call_568792.host, call_568792.base,
                         call_568792.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568792, url, valid)

proc call*(call_568793: Call_VirtualMachineScaleSetsCreateOrUpdate_568784;
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
  var path_568794 = newJObject()
  var query_568795 = newJObject()
  var body_568796 = newJObject()
  add(path_568794, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568794, "resourceGroupName", newJString(resourceGroupName))
  add(query_568795, "api-version", newJString(apiVersion))
  add(path_568794, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568796 = parameters
  result = call_568793.call(path_568794, query_568795, nil, nil, body_568796)

var virtualMachineScaleSetsCreateOrUpdate* = Call_VirtualMachineScaleSetsCreateOrUpdate_568784(
    name: "virtualMachineScaleSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsCreateOrUpdate_568785, base: "",
    url: url_VirtualMachineScaleSetsCreateOrUpdate_568786, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGet_568773 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsGet_568775(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsGet_568774(path: JsonNode; query: JsonNode;
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
  var valid_568776 = path.getOrDefault("vmScaleSetName")
  valid_568776 = validateParameter(valid_568776, JString, required = true,
                                 default = nil)
  if valid_568776 != nil:
    section.add "vmScaleSetName", valid_568776
  var valid_568777 = path.getOrDefault("resourceGroupName")
  valid_568777 = validateParameter(valid_568777, JString, required = true,
                                 default = nil)
  if valid_568777 != nil:
    section.add "resourceGroupName", valid_568777
  var valid_568778 = path.getOrDefault("subscriptionId")
  valid_568778 = validateParameter(valid_568778, JString, required = true,
                                 default = nil)
  if valid_568778 != nil:
    section.add "subscriptionId", valid_568778
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568779 = query.getOrDefault("api-version")
  valid_568779 = validateParameter(valid_568779, JString, required = true,
                                 default = nil)
  if valid_568779 != nil:
    section.add "api-version", valid_568779
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568780: Call_VirtualMachineScaleSetsGet_568773; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Display information about a virtual machine scale set.
  ## 
  let valid = call_568780.validator(path, query, header, formData, body)
  let scheme = call_568780.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568780.url(scheme.get, call_568780.host, call_568780.base,
                         call_568780.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568780, url, valid)

proc call*(call_568781: Call_VirtualMachineScaleSetsGet_568773;
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
  var path_568782 = newJObject()
  var query_568783 = newJObject()
  add(path_568782, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568782, "resourceGroupName", newJString(resourceGroupName))
  add(query_568783, "api-version", newJString(apiVersion))
  add(path_568782, "subscriptionId", newJString(subscriptionId))
  result = call_568781.call(path_568782, query_568783, nil, nil, nil)

var virtualMachineScaleSetsGet* = Call_VirtualMachineScaleSetsGet_568773(
    name: "virtualMachineScaleSetsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsGet_568774, base: "",
    url: url_VirtualMachineScaleSetsGet_568775, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsUpdate_568808 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsUpdate_568810(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsUpdate_568809(path: JsonNode; query: JsonNode;
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
  var valid_568811 = path.getOrDefault("vmScaleSetName")
  valid_568811 = validateParameter(valid_568811, JString, required = true,
                                 default = nil)
  if valid_568811 != nil:
    section.add "vmScaleSetName", valid_568811
  var valid_568812 = path.getOrDefault("resourceGroupName")
  valid_568812 = validateParameter(valid_568812, JString, required = true,
                                 default = nil)
  if valid_568812 != nil:
    section.add "resourceGroupName", valid_568812
  var valid_568813 = path.getOrDefault("subscriptionId")
  valid_568813 = validateParameter(valid_568813, JString, required = true,
                                 default = nil)
  if valid_568813 != nil:
    section.add "subscriptionId", valid_568813
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568814 = query.getOrDefault("api-version")
  valid_568814 = validateParameter(valid_568814, JString, required = true,
                                 default = nil)
  if valid_568814 != nil:
    section.add "api-version", valid_568814
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

proc call*(call_568816: Call_VirtualMachineScaleSetsUpdate_568808; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a VM scale set.
  ## 
  let valid = call_568816.validator(path, query, header, formData, body)
  let scheme = call_568816.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568816.url(scheme.get, call_568816.host, call_568816.base,
                         call_568816.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568816, url, valid)

proc call*(call_568817: Call_VirtualMachineScaleSetsUpdate_568808;
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
  var path_568818 = newJObject()
  var query_568819 = newJObject()
  var body_568820 = newJObject()
  add(path_568818, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568818, "resourceGroupName", newJString(resourceGroupName))
  add(query_568819, "api-version", newJString(apiVersion))
  add(path_568818, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568820 = parameters
  result = call_568817.call(path_568818, query_568819, nil, nil, body_568820)

var virtualMachineScaleSetsUpdate* = Call_VirtualMachineScaleSetsUpdate_568808(
    name: "virtualMachineScaleSetsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsUpdate_568809, base: "",
    url: url_VirtualMachineScaleSetsUpdate_568810, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDelete_568797 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsDelete_568799(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsDelete_568798(path: JsonNode; query: JsonNode;
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
  var valid_568800 = path.getOrDefault("vmScaleSetName")
  valid_568800 = validateParameter(valid_568800, JString, required = true,
                                 default = nil)
  if valid_568800 != nil:
    section.add "vmScaleSetName", valid_568800
  var valid_568801 = path.getOrDefault("resourceGroupName")
  valid_568801 = validateParameter(valid_568801, JString, required = true,
                                 default = nil)
  if valid_568801 != nil:
    section.add "resourceGroupName", valid_568801
  var valid_568802 = path.getOrDefault("subscriptionId")
  valid_568802 = validateParameter(valid_568802, JString, required = true,
                                 default = nil)
  if valid_568802 != nil:
    section.add "subscriptionId", valid_568802
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568803 = query.getOrDefault("api-version")
  valid_568803 = validateParameter(valid_568803, JString, required = true,
                                 default = nil)
  if valid_568803 != nil:
    section.add "api-version", valid_568803
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568804: Call_VirtualMachineScaleSetsDelete_568797; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VM scale set.
  ## 
  let valid = call_568804.validator(path, query, header, formData, body)
  let scheme = call_568804.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568804.url(scheme.get, call_568804.host, call_568804.base,
                         call_568804.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568804, url, valid)

proc call*(call_568805: Call_VirtualMachineScaleSetsDelete_568797;
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
  var path_568806 = newJObject()
  var query_568807 = newJObject()
  add(path_568806, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568806, "resourceGroupName", newJString(resourceGroupName))
  add(query_568807, "api-version", newJString(apiVersion))
  add(path_568806, "subscriptionId", newJString(subscriptionId))
  result = call_568805.call(path_568806, query_568807, nil, nil, nil)

var virtualMachineScaleSetsDelete* = Call_VirtualMachineScaleSetsDelete_568797(
    name: "virtualMachineScaleSetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsDelete_568798, base: "",
    url: url_VirtualMachineScaleSetsDelete_568799, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsConvertToSinglePlacementGroup_568821 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsConvertToSinglePlacementGroup_568823(
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

proc validate_VirtualMachineScaleSetsConvertToSinglePlacementGroup_568822(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Converts SinglePlacementGroup property to false for a existing virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   vmScaleSetName: JString (required)
  ##                 : The name of the virtual machine scale set to create or update.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `vmScaleSetName` field"
  var valid_568824 = path.getOrDefault("vmScaleSetName")
  valid_568824 = validateParameter(valid_568824, JString, required = true,
                                 default = nil)
  if valid_568824 != nil:
    section.add "vmScaleSetName", valid_568824
  var valid_568825 = path.getOrDefault("resourceGroupName")
  valid_568825 = validateParameter(valid_568825, JString, required = true,
                                 default = nil)
  if valid_568825 != nil:
    section.add "resourceGroupName", valid_568825
  var valid_568826 = path.getOrDefault("subscriptionId")
  valid_568826 = validateParameter(valid_568826, JString, required = true,
                                 default = nil)
  if valid_568826 != nil:
    section.add "subscriptionId", valid_568826
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

proc call*(call_568828: Call_VirtualMachineScaleSetsConvertToSinglePlacementGroup_568821;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Converts SinglePlacementGroup property to false for a existing virtual machine scale set.
  ## 
  let valid = call_568828.validator(path, query, header, formData, body)
  let scheme = call_568828.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568828.url(scheme.get, call_568828.host, call_568828.base,
                         call_568828.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568828, url, valid)

proc call*(call_568829: Call_VirtualMachineScaleSetsConvertToSinglePlacementGroup_568821;
          vmScaleSetName: string; resourceGroupName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## virtualMachineScaleSetsConvertToSinglePlacementGroup
  ## Converts SinglePlacementGroup property to false for a existing virtual machine scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the virtual machine scale set to create or update.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : The input object for ConvertToSinglePlacementGroup API.
  var path_568830 = newJObject()
  var body_568831 = newJObject()
  add(path_568830, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568830, "resourceGroupName", newJString(resourceGroupName))
  add(path_568830, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568831 = parameters
  result = call_568829.call(path_568830, nil, nil, nil, body_568831)

var virtualMachineScaleSetsConvertToSinglePlacementGroup* = Call_VirtualMachineScaleSetsConvertToSinglePlacementGroup_568821(
    name: "virtualMachineScaleSetsConvertToSinglePlacementGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/convertToSinglePlacementGroup",
    validator: validate_VirtualMachineScaleSetsConvertToSinglePlacementGroup_568822,
    base: "", url: url_VirtualMachineScaleSetsConvertToSinglePlacementGroup_568823,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDeallocate_568832 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsDeallocate_568834(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsDeallocate_568833(path: JsonNode;
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
  var valid_568835 = path.getOrDefault("vmScaleSetName")
  valid_568835 = validateParameter(valid_568835, JString, required = true,
                                 default = nil)
  if valid_568835 != nil:
    section.add "vmScaleSetName", valid_568835
  var valid_568836 = path.getOrDefault("resourceGroupName")
  valid_568836 = validateParameter(valid_568836, JString, required = true,
                                 default = nil)
  if valid_568836 != nil:
    section.add "resourceGroupName", valid_568836
  var valid_568837 = path.getOrDefault("subscriptionId")
  valid_568837 = validateParameter(valid_568837, JString, required = true,
                                 default = nil)
  if valid_568837 != nil:
    section.add "subscriptionId", valid_568837
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568838 = query.getOrDefault("api-version")
  valid_568838 = validateParameter(valid_568838, JString, required = true,
                                 default = nil)
  if valid_568838 != nil:
    section.add "api-version", valid_568838
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

proc call*(call_568840: Call_VirtualMachineScaleSetsDeallocate_568832;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deallocates specific virtual machines in a VM scale set. Shuts down the virtual machines and releases the compute resources. You are not billed for the compute resources that this virtual machine scale set deallocates.
  ## 
  let valid = call_568840.validator(path, query, header, formData, body)
  let scheme = call_568840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568840.url(scheme.get, call_568840.host, call_568840.base,
                         call_568840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568840, url, valid)

proc call*(call_568841: Call_VirtualMachineScaleSetsDeallocate_568832;
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
  var path_568842 = newJObject()
  var query_568843 = newJObject()
  var body_568844 = newJObject()
  add(path_568842, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568842, "resourceGroupName", newJString(resourceGroupName))
  add(query_568843, "api-version", newJString(apiVersion))
  add(path_568842, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568844 = vmInstanceIDs
  result = call_568841.call(path_568842, query_568843, nil, nil, body_568844)

var virtualMachineScaleSetsDeallocate* = Call_VirtualMachineScaleSetsDeallocate_568832(
    name: "virtualMachineScaleSetsDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/deallocate",
    validator: validate_VirtualMachineScaleSetsDeallocate_568833, base: "",
    url: url_VirtualMachineScaleSetsDeallocate_568834, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDeleteInstances_568845 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsDeleteInstances_568847(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsDeleteInstances_568846(path: JsonNode;
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
  var valid_568848 = path.getOrDefault("vmScaleSetName")
  valid_568848 = validateParameter(valid_568848, JString, required = true,
                                 default = nil)
  if valid_568848 != nil:
    section.add "vmScaleSetName", valid_568848
  var valid_568849 = path.getOrDefault("resourceGroupName")
  valid_568849 = validateParameter(valid_568849, JString, required = true,
                                 default = nil)
  if valid_568849 != nil:
    section.add "resourceGroupName", valid_568849
  var valid_568850 = path.getOrDefault("subscriptionId")
  valid_568850 = validateParameter(valid_568850, JString, required = true,
                                 default = nil)
  if valid_568850 != nil:
    section.add "subscriptionId", valid_568850
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568851 = query.getOrDefault("api-version")
  valid_568851 = validateParameter(valid_568851, JString, required = true,
                                 default = nil)
  if valid_568851 != nil:
    section.add "api-version", valid_568851
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

proc call*(call_568853: Call_VirtualMachineScaleSetsDeleteInstances_568845;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes virtual machines in a VM scale set.
  ## 
  let valid = call_568853.validator(path, query, header, formData, body)
  let scheme = call_568853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568853.url(scheme.get, call_568853.host, call_568853.base,
                         call_568853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568853, url, valid)

proc call*(call_568854: Call_VirtualMachineScaleSetsDeleteInstances_568845;
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
  var path_568855 = newJObject()
  var query_568856 = newJObject()
  var body_568857 = newJObject()
  add(path_568855, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568855, "resourceGroupName", newJString(resourceGroupName))
  add(query_568856, "api-version", newJString(apiVersion))
  add(path_568855, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568857 = vmInstanceIDs
  result = call_568854.call(path_568855, query_568856, nil, nil, body_568857)

var virtualMachineScaleSetsDeleteInstances* = Call_VirtualMachineScaleSetsDeleteInstances_568845(
    name: "virtualMachineScaleSetsDeleteInstances", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/delete",
    validator: validate_VirtualMachineScaleSetsDeleteInstances_568846, base: "",
    url: url_VirtualMachineScaleSetsDeleteInstances_568847,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_568858 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_568860(
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

proc validate_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_568859(
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
  var valid_568861 = path.getOrDefault("vmScaleSetName")
  valid_568861 = validateParameter(valid_568861, JString, required = true,
                                 default = nil)
  if valid_568861 != nil:
    section.add "vmScaleSetName", valid_568861
  var valid_568862 = path.getOrDefault("resourceGroupName")
  valid_568862 = validateParameter(valid_568862, JString, required = true,
                                 default = nil)
  if valid_568862 != nil:
    section.add "resourceGroupName", valid_568862
  var valid_568863 = path.getOrDefault("subscriptionId")
  valid_568863 = validateParameter(valid_568863, JString, required = true,
                                 default = nil)
  if valid_568863 != nil:
    section.add "subscriptionId", valid_568863
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568864 = query.getOrDefault("api-version")
  valid_568864 = validateParameter(valid_568864, JString, required = true,
                                 default = nil)
  if valid_568864 != nil:
    section.add "api-version", valid_568864
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568865: Call_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_568858;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a rolling upgrade to move all extensions for all virtual machine scale set instances to the latest available extension version. Instances which are already running the latest extension versions are not affected.
  ## 
  let valid = call_568865.validator(path, query, header, formData, body)
  let scheme = call_568865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568865.url(scheme.get, call_568865.host, call_568865.base,
                         call_568865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568865, url, valid)

proc call*(call_568866: Call_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_568858;
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
  var path_568867 = newJObject()
  var query_568868 = newJObject()
  add(path_568867, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568867, "resourceGroupName", newJString(resourceGroupName))
  add(query_568868, "api-version", newJString(apiVersion))
  add(path_568867, "subscriptionId", newJString(subscriptionId))
  result = call_568866.call(path_568867, query_568868, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesStartExtensionUpgrade* = Call_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_568858(
    name: "virtualMachineScaleSetRollingUpgradesStartExtensionUpgrade",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensionRollingUpgrade", validator: validate_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_568859,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_568860,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsList_568869 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetExtensionsList_568871(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetExtensionsList_568870(path: JsonNode;
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
  var valid_568872 = path.getOrDefault("vmScaleSetName")
  valid_568872 = validateParameter(valid_568872, JString, required = true,
                                 default = nil)
  if valid_568872 != nil:
    section.add "vmScaleSetName", valid_568872
  var valid_568873 = path.getOrDefault("resourceGroupName")
  valid_568873 = validateParameter(valid_568873, JString, required = true,
                                 default = nil)
  if valid_568873 != nil:
    section.add "resourceGroupName", valid_568873
  var valid_568874 = path.getOrDefault("subscriptionId")
  valid_568874 = validateParameter(valid_568874, JString, required = true,
                                 default = nil)
  if valid_568874 != nil:
    section.add "subscriptionId", valid_568874
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

proc call*(call_568876: Call_VirtualMachineScaleSetExtensionsList_568869;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of all extensions in a VM scale set.
  ## 
  let valid = call_568876.validator(path, query, header, formData, body)
  let scheme = call_568876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568876.url(scheme.get, call_568876.host, call_568876.base,
                         call_568876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568876, url, valid)

proc call*(call_568877: Call_VirtualMachineScaleSetExtensionsList_568869;
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
  var path_568878 = newJObject()
  var query_568879 = newJObject()
  add(path_568878, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568878, "resourceGroupName", newJString(resourceGroupName))
  add(query_568879, "api-version", newJString(apiVersion))
  add(path_568878, "subscriptionId", newJString(subscriptionId))
  result = call_568877.call(path_568878, query_568879, nil, nil, nil)

var virtualMachineScaleSetExtensionsList* = Call_VirtualMachineScaleSetExtensionsList_568869(
    name: "virtualMachineScaleSetExtensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions",
    validator: validate_VirtualMachineScaleSetExtensionsList_568870, base: "",
    url: url_VirtualMachineScaleSetExtensionsList_568871, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_568893 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetExtensionsCreateOrUpdate_568895(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetExtensionsCreateOrUpdate_568894(
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
  var valid_568896 = path.getOrDefault("vmScaleSetName")
  valid_568896 = validateParameter(valid_568896, JString, required = true,
                                 default = nil)
  if valid_568896 != nil:
    section.add "vmScaleSetName", valid_568896
  var valid_568897 = path.getOrDefault("resourceGroupName")
  valid_568897 = validateParameter(valid_568897, JString, required = true,
                                 default = nil)
  if valid_568897 != nil:
    section.add "resourceGroupName", valid_568897
  var valid_568898 = path.getOrDefault("subscriptionId")
  valid_568898 = validateParameter(valid_568898, JString, required = true,
                                 default = nil)
  if valid_568898 != nil:
    section.add "subscriptionId", valid_568898
  var valid_568899 = path.getOrDefault("vmssExtensionName")
  valid_568899 = validateParameter(valid_568899, JString, required = true,
                                 default = nil)
  if valid_568899 != nil:
    section.add "vmssExtensionName", valid_568899
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568900 = query.getOrDefault("api-version")
  valid_568900 = validateParameter(valid_568900, JString, required = true,
                                 default = nil)
  if valid_568900 != nil:
    section.add "api-version", valid_568900
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

proc call*(call_568902: Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_568893;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update an extension.
  ## 
  let valid = call_568902.validator(path, query, header, formData, body)
  let scheme = call_568902.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568902.url(scheme.get, call_568902.host, call_568902.base,
                         call_568902.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568902, url, valid)

proc call*(call_568903: Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_568893;
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
  var path_568904 = newJObject()
  var query_568905 = newJObject()
  var body_568906 = newJObject()
  add(path_568904, "vmScaleSetName", newJString(vmScaleSetName))
  if extensionParameters != nil:
    body_568906 = extensionParameters
  add(path_568904, "resourceGroupName", newJString(resourceGroupName))
  add(query_568905, "api-version", newJString(apiVersion))
  add(path_568904, "subscriptionId", newJString(subscriptionId))
  add(path_568904, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_568903.call(path_568904, query_568905, nil, nil, body_568906)

var virtualMachineScaleSetExtensionsCreateOrUpdate* = Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_568893(
    name: "virtualMachineScaleSetExtensionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsCreateOrUpdate_568894,
    base: "", url: url_VirtualMachineScaleSetExtensionsCreateOrUpdate_568895,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsGet_568880 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetExtensionsGet_568882(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetExtensionsGet_568881(path: JsonNode;
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
  var valid_568886 = path.getOrDefault("vmssExtensionName")
  valid_568886 = validateParameter(valid_568886, JString, required = true,
                                 default = nil)
  if valid_568886 != nil:
    section.add "vmssExtensionName", valid_568886
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_568887 = query.getOrDefault("$expand")
  valid_568887 = validateParameter(valid_568887, JString, required = false,
                                 default = nil)
  if valid_568887 != nil:
    section.add "$expand", valid_568887
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568888 = query.getOrDefault("api-version")
  valid_568888 = validateParameter(valid_568888, JString, required = true,
                                 default = nil)
  if valid_568888 != nil:
    section.add "api-version", valid_568888
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568889: Call_VirtualMachineScaleSetExtensionsGet_568880;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to get the extension.
  ## 
  let valid = call_568889.validator(path, query, header, formData, body)
  let scheme = call_568889.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568889.url(scheme.get, call_568889.host, call_568889.base,
                         call_568889.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568889, url, valid)

proc call*(call_568890: Call_VirtualMachineScaleSetExtensionsGet_568880;
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
  var path_568891 = newJObject()
  var query_568892 = newJObject()
  add(path_568891, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568891, "resourceGroupName", newJString(resourceGroupName))
  add(query_568892, "$expand", newJString(Expand))
  add(query_568892, "api-version", newJString(apiVersion))
  add(path_568891, "subscriptionId", newJString(subscriptionId))
  add(path_568891, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_568890.call(path_568891, query_568892, nil, nil, nil)

var virtualMachineScaleSetExtensionsGet* = Call_VirtualMachineScaleSetExtensionsGet_568880(
    name: "virtualMachineScaleSetExtensionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsGet_568881, base: "",
    url: url_VirtualMachineScaleSetExtensionsGet_568882, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsDelete_568907 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetExtensionsDelete_568909(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetExtensionsDelete_568908(path: JsonNode;
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
  var valid_568910 = path.getOrDefault("vmScaleSetName")
  valid_568910 = validateParameter(valid_568910, JString, required = true,
                                 default = nil)
  if valid_568910 != nil:
    section.add "vmScaleSetName", valid_568910
  var valid_568911 = path.getOrDefault("resourceGroupName")
  valid_568911 = validateParameter(valid_568911, JString, required = true,
                                 default = nil)
  if valid_568911 != nil:
    section.add "resourceGroupName", valid_568911
  var valid_568912 = path.getOrDefault("subscriptionId")
  valid_568912 = validateParameter(valid_568912, JString, required = true,
                                 default = nil)
  if valid_568912 != nil:
    section.add "subscriptionId", valid_568912
  var valid_568913 = path.getOrDefault("vmssExtensionName")
  valid_568913 = validateParameter(valid_568913, JString, required = true,
                                 default = nil)
  if valid_568913 != nil:
    section.add "vmssExtensionName", valid_568913
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568914 = query.getOrDefault("api-version")
  valid_568914 = validateParameter(valid_568914, JString, required = true,
                                 default = nil)
  if valid_568914 != nil:
    section.add "api-version", valid_568914
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568915: Call_VirtualMachineScaleSetExtensionsDelete_568907;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete the extension.
  ## 
  let valid = call_568915.validator(path, query, header, formData, body)
  let scheme = call_568915.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568915.url(scheme.get, call_568915.host, call_568915.base,
                         call_568915.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568915, url, valid)

proc call*(call_568916: Call_VirtualMachineScaleSetExtensionsDelete_568907;
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
  var path_568917 = newJObject()
  var query_568918 = newJObject()
  add(path_568917, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568917, "resourceGroupName", newJString(resourceGroupName))
  add(query_568918, "api-version", newJString(apiVersion))
  add(path_568917, "subscriptionId", newJString(subscriptionId))
  add(path_568917, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_568916.call(path_568917, query_568918, nil, nil, nil)

var virtualMachineScaleSetExtensionsDelete* = Call_VirtualMachineScaleSetExtensionsDelete_568907(
    name: "virtualMachineScaleSetExtensionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsDelete_568908, base: "",
    url: url_VirtualMachineScaleSetExtensionsDelete_568909,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568919 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568921(
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

proc validate_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568920(
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
  var valid_568922 = path.getOrDefault("vmScaleSetName")
  valid_568922 = validateParameter(valid_568922, JString, required = true,
                                 default = nil)
  if valid_568922 != nil:
    section.add "vmScaleSetName", valid_568922
  var valid_568923 = path.getOrDefault("resourceGroupName")
  valid_568923 = validateParameter(valid_568923, JString, required = true,
                                 default = nil)
  if valid_568923 != nil:
    section.add "resourceGroupName", valid_568923
  var valid_568924 = path.getOrDefault("subscriptionId")
  valid_568924 = validateParameter(valid_568924, JString, required = true,
                                 default = nil)
  if valid_568924 != nil:
    section.add "subscriptionId", valid_568924
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   platformUpdateDomain: JInt (required)
  ##                       : The platform update domain for which a manual recovery walk is requested
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568925 = query.getOrDefault("api-version")
  valid_568925 = validateParameter(valid_568925, JString, required = true,
                                 default = nil)
  if valid_568925 != nil:
    section.add "api-version", valid_568925
  var valid_568926 = query.getOrDefault("platformUpdateDomain")
  valid_568926 = validateParameter(valid_568926, JInt, required = true, default = nil)
  if valid_568926 != nil:
    section.add "platformUpdateDomain", valid_568926
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568927: Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568919;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Manual platform update domain walk to update virtual machines in a service fabric virtual machine scale set.
  ## 
  let valid = call_568927.validator(path, query, header, formData, body)
  let scheme = call_568927.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568927.url(scheme.get, call_568927.host, call_568927.base,
                         call_568927.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568927, url, valid)

proc call*(call_568928: Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568919;
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
  var path_568929 = newJObject()
  var query_568930 = newJObject()
  add(path_568929, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568929, "resourceGroupName", newJString(resourceGroupName))
  add(query_568930, "api-version", newJString(apiVersion))
  add(query_568930, "platformUpdateDomain", newJInt(platformUpdateDomain))
  add(path_568929, "subscriptionId", newJString(subscriptionId))
  result = call_568928.call(path_568929, query_568930, nil, nil, nil)

var virtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk* = Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568919(name: "virtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/forceRecoveryServiceFabricPlatformUpdateDomainWalk", validator: validate_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568920,
    base: "", url: url_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_568921,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGetInstanceView_568931 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsGetInstanceView_568933(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsGetInstanceView_568932(path: JsonNode;
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
  var valid_568934 = path.getOrDefault("vmScaleSetName")
  valid_568934 = validateParameter(valid_568934, JString, required = true,
                                 default = nil)
  if valid_568934 != nil:
    section.add "vmScaleSetName", valid_568934
  var valid_568935 = path.getOrDefault("resourceGroupName")
  valid_568935 = validateParameter(valid_568935, JString, required = true,
                                 default = nil)
  if valid_568935 != nil:
    section.add "resourceGroupName", valid_568935
  var valid_568936 = path.getOrDefault("subscriptionId")
  valid_568936 = validateParameter(valid_568936, JString, required = true,
                                 default = nil)
  if valid_568936 != nil:
    section.add "subscriptionId", valid_568936
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

proc call*(call_568938: Call_VirtualMachineScaleSetsGetInstanceView_568931;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of a VM scale set instance.
  ## 
  let valid = call_568938.validator(path, query, header, formData, body)
  let scheme = call_568938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568938.url(scheme.get, call_568938.host, call_568938.base,
                         call_568938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568938, url, valid)

proc call*(call_568939: Call_VirtualMachineScaleSetsGetInstanceView_568931;
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
  var path_568940 = newJObject()
  var query_568941 = newJObject()
  add(path_568940, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568940, "resourceGroupName", newJString(resourceGroupName))
  add(query_568941, "api-version", newJString(apiVersion))
  add(path_568940, "subscriptionId", newJString(subscriptionId))
  result = call_568939.call(path_568940, query_568941, nil, nil, nil)

var virtualMachineScaleSetsGetInstanceView* = Call_VirtualMachineScaleSetsGetInstanceView_568931(
    name: "virtualMachineScaleSetsGetInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/instanceView",
    validator: validate_VirtualMachineScaleSetsGetInstanceView_568932, base: "",
    url: url_VirtualMachineScaleSetsGetInstanceView_568933,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsUpdateInstances_568942 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsUpdateInstances_568944(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsUpdateInstances_568943(path: JsonNode;
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568948 = query.getOrDefault("api-version")
  valid_568948 = validateParameter(valid_568948, JString, required = true,
                                 default = nil)
  if valid_568948 != nil:
    section.add "api-version", valid_568948
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

proc call*(call_568950: Call_VirtualMachineScaleSetsUpdateInstances_568942;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upgrades one or more virtual machines to the latest SKU set in the VM scale set model.
  ## 
  let valid = call_568950.validator(path, query, header, formData, body)
  let scheme = call_568950.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568950.url(scheme.get, call_568950.host, call_568950.base,
                         call_568950.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568950, url, valid)

proc call*(call_568951: Call_VirtualMachineScaleSetsUpdateInstances_568942;
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
  var path_568952 = newJObject()
  var query_568953 = newJObject()
  var body_568954 = newJObject()
  add(path_568952, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568952, "resourceGroupName", newJString(resourceGroupName))
  add(query_568953, "api-version", newJString(apiVersion))
  add(path_568952, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568954 = vmInstanceIDs
  result = call_568951.call(path_568952, query_568953, nil, nil, body_568954)

var virtualMachineScaleSetsUpdateInstances* = Call_VirtualMachineScaleSetsUpdateInstances_568942(
    name: "virtualMachineScaleSetsUpdateInstances", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/manualupgrade",
    validator: validate_VirtualMachineScaleSetsUpdateInstances_568943, base: "",
    url: url_VirtualMachineScaleSetsUpdateInstances_568944,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568955 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568957(
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

proc validate_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568956(
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
  var valid_568958 = path.getOrDefault("vmScaleSetName")
  valid_568958 = validateParameter(valid_568958, JString, required = true,
                                 default = nil)
  if valid_568958 != nil:
    section.add "vmScaleSetName", valid_568958
  var valid_568959 = path.getOrDefault("resourceGroupName")
  valid_568959 = validateParameter(valid_568959, JString, required = true,
                                 default = nil)
  if valid_568959 != nil:
    section.add "resourceGroupName", valid_568959
  var valid_568960 = path.getOrDefault("subscriptionId")
  valid_568960 = validateParameter(valid_568960, JString, required = true,
                                 default = nil)
  if valid_568960 != nil:
    section.add "subscriptionId", valid_568960
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

proc call*(call_568962: Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568955;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a rolling upgrade to move all virtual machine scale set instances to the latest available Platform Image OS version. Instances which are already running the latest available OS version are not affected.
  ## 
  let valid = call_568962.validator(path, query, header, formData, body)
  let scheme = call_568962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568962.url(scheme.get, call_568962.host, call_568962.base,
                         call_568962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568962, url, valid)

proc call*(call_568963: Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568955;
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
  var path_568964 = newJObject()
  var query_568965 = newJObject()
  add(path_568964, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568964, "resourceGroupName", newJString(resourceGroupName))
  add(query_568965, "api-version", newJString(apiVersion))
  add(path_568964, "subscriptionId", newJString(subscriptionId))
  result = call_568963.call(path_568964, query_568965, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesStartOSUpgrade* = Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568955(
    name: "virtualMachineScaleSetRollingUpgradesStartOSUpgrade",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/osRollingUpgrade",
    validator: validate_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568956,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_568957,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGetOSUpgradeHistory_568966 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsGetOSUpgradeHistory_568968(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsGetOSUpgradeHistory_568967(path: JsonNode;
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568972 = query.getOrDefault("api-version")
  valid_568972 = validateParameter(valid_568972, JString, required = true,
                                 default = nil)
  if valid_568972 != nil:
    section.add "api-version", valid_568972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568973: Call_VirtualMachineScaleSetsGetOSUpgradeHistory_568966;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets list of OS upgrades on a VM scale set instance.
  ## 
  let valid = call_568973.validator(path, query, header, formData, body)
  let scheme = call_568973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568973.url(scheme.get, call_568973.host, call_568973.base,
                         call_568973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568973, url, valid)

proc call*(call_568974: Call_VirtualMachineScaleSetsGetOSUpgradeHistory_568966;
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
  var path_568975 = newJObject()
  var query_568976 = newJObject()
  add(path_568975, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568975, "resourceGroupName", newJString(resourceGroupName))
  add(query_568976, "api-version", newJString(apiVersion))
  add(path_568975, "subscriptionId", newJString(subscriptionId))
  result = call_568974.call(path_568975, query_568976, nil, nil, nil)

var virtualMachineScaleSetsGetOSUpgradeHistory* = Call_VirtualMachineScaleSetsGetOSUpgradeHistory_568966(
    name: "virtualMachineScaleSetsGetOSUpgradeHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/osUpgradeHistory",
    validator: validate_VirtualMachineScaleSetsGetOSUpgradeHistory_568967,
    base: "", url: url_VirtualMachineScaleSetsGetOSUpgradeHistory_568968,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsPerformMaintenance_568977 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsPerformMaintenance_568979(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsPerformMaintenance_568978(path: JsonNode;
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
  var valid_568980 = path.getOrDefault("vmScaleSetName")
  valid_568980 = validateParameter(valid_568980, JString, required = true,
                                 default = nil)
  if valid_568980 != nil:
    section.add "vmScaleSetName", valid_568980
  var valid_568981 = path.getOrDefault("resourceGroupName")
  valid_568981 = validateParameter(valid_568981, JString, required = true,
                                 default = nil)
  if valid_568981 != nil:
    section.add "resourceGroupName", valid_568981
  var valid_568982 = path.getOrDefault("subscriptionId")
  valid_568982 = validateParameter(valid_568982, JString, required = true,
                                 default = nil)
  if valid_568982 != nil:
    section.add "subscriptionId", valid_568982
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568983 = query.getOrDefault("api-version")
  valid_568983 = validateParameter(valid_568983, JString, required = true,
                                 default = nil)
  if valid_568983 != nil:
    section.add "api-version", valid_568983
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

proc call*(call_568985: Call_VirtualMachineScaleSetsPerformMaintenance_568977;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Perform maintenance on one or more virtual machines in a VM scale set. Operation on instances which are not eligible for perform maintenance will be failed. Please refer to best practices for more details: https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-maintenance-notifications
  ## 
  let valid = call_568985.validator(path, query, header, formData, body)
  let scheme = call_568985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568985.url(scheme.get, call_568985.host, call_568985.base,
                         call_568985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568985, url, valid)

proc call*(call_568986: Call_VirtualMachineScaleSetsPerformMaintenance_568977;
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
  var path_568987 = newJObject()
  var query_568988 = newJObject()
  var body_568989 = newJObject()
  add(path_568987, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_568987, "resourceGroupName", newJString(resourceGroupName))
  add(query_568988, "api-version", newJString(apiVersion))
  add(path_568987, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_568989 = vmInstanceIDs
  result = call_568986.call(path_568987, query_568988, nil, nil, body_568989)

var virtualMachineScaleSetsPerformMaintenance* = Call_VirtualMachineScaleSetsPerformMaintenance_568977(
    name: "virtualMachineScaleSetsPerformMaintenance", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/performMaintenance",
    validator: validate_VirtualMachineScaleSetsPerformMaintenance_568978,
    base: "", url: url_VirtualMachineScaleSetsPerformMaintenance_568979,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsPowerOff_568990 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsPowerOff_568992(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsPowerOff_568991(path: JsonNode;
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   skipShutdown: JBool
  ##               : The parameter to request non-graceful VM shutdown. True value for this flag indicates non-graceful shutdown whereas false indicates otherwise. Default value for this flag is false if not specified
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568996 = query.getOrDefault("api-version")
  valid_568996 = validateParameter(valid_568996, JString, required = true,
                                 default = nil)
  if valid_568996 != nil:
    section.add "api-version", valid_568996
  var valid_568997 = query.getOrDefault("skipShutdown")
  valid_568997 = validateParameter(valid_568997, JBool, required = false,
                                 default = newJBool(false))
  if valid_568997 != nil:
    section.add "skipShutdown", valid_568997
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

proc call*(call_568999: Call_VirtualMachineScaleSetsPowerOff_568990;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Power off (stop) one or more virtual machines in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  let valid = call_568999.validator(path, query, header, formData, body)
  let scheme = call_568999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568999.url(scheme.get, call_568999.host, call_568999.base,
                         call_568999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568999, url, valid)

proc call*(call_569000: Call_VirtualMachineScaleSetsPowerOff_568990;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; skipShutdown: bool = false;
          vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsPowerOff
  ## Power off (stop) one or more virtual machines in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   skipShutdown: bool
  ##               : The parameter to request non-graceful VM shutdown. True value for this flag indicates non-graceful shutdown whereas false indicates otherwise. Default value for this flag is false if not specified
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmInstanceIDs: JObject
  ##                : A list of virtual machine instance IDs from the VM scale set.
  var path_569001 = newJObject()
  var query_569002 = newJObject()
  var body_569003 = newJObject()
  add(path_569001, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569001, "resourceGroupName", newJString(resourceGroupName))
  add(query_569002, "api-version", newJString(apiVersion))
  add(query_569002, "skipShutdown", newJBool(skipShutdown))
  add(path_569001, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_569003 = vmInstanceIDs
  result = call_569000.call(path_569001, query_569002, nil, nil, body_569003)

var virtualMachineScaleSetsPowerOff* = Call_VirtualMachineScaleSetsPowerOff_568990(
    name: "virtualMachineScaleSetsPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/poweroff",
    validator: validate_VirtualMachineScaleSetsPowerOff_568991, base: "",
    url: url_VirtualMachineScaleSetsPowerOff_568992, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsRedeploy_569004 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsRedeploy_569006(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsRedeploy_569005(path: JsonNode;
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
  var valid_569007 = path.getOrDefault("vmScaleSetName")
  valid_569007 = validateParameter(valid_569007, JString, required = true,
                                 default = nil)
  if valid_569007 != nil:
    section.add "vmScaleSetName", valid_569007
  var valid_569008 = path.getOrDefault("resourceGroupName")
  valid_569008 = validateParameter(valid_569008, JString, required = true,
                                 default = nil)
  if valid_569008 != nil:
    section.add "resourceGroupName", valid_569008
  var valid_569009 = path.getOrDefault("subscriptionId")
  valid_569009 = validateParameter(valid_569009, JString, required = true,
                                 default = nil)
  if valid_569009 != nil:
    section.add "subscriptionId", valid_569009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569010 = query.getOrDefault("api-version")
  valid_569010 = validateParameter(valid_569010, JString, required = true,
                                 default = nil)
  if valid_569010 != nil:
    section.add "api-version", valid_569010
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

proc call*(call_569012: Call_VirtualMachineScaleSetsRedeploy_569004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Shuts down all the virtual machines in the virtual machine scale set, moves them to a new node, and powers them back on.
  ## 
  let valid = call_569012.validator(path, query, header, formData, body)
  let scheme = call_569012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569012.url(scheme.get, call_569012.host, call_569012.base,
                         call_569012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569012, url, valid)

proc call*(call_569013: Call_VirtualMachineScaleSetsRedeploy_569004;
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
  var path_569014 = newJObject()
  var query_569015 = newJObject()
  var body_569016 = newJObject()
  add(path_569014, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569014, "resourceGroupName", newJString(resourceGroupName))
  add(query_569015, "api-version", newJString(apiVersion))
  add(path_569014, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_569016 = vmInstanceIDs
  result = call_569013.call(path_569014, query_569015, nil, nil, body_569016)

var virtualMachineScaleSetsRedeploy* = Call_VirtualMachineScaleSetsRedeploy_569004(
    name: "virtualMachineScaleSetsRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/redeploy",
    validator: validate_VirtualMachineScaleSetsRedeploy_569005, base: "",
    url: url_VirtualMachineScaleSetsRedeploy_569006, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsReimage_569017 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsReimage_569019(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsReimage_569018(path: JsonNode;
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
  var valid_569020 = path.getOrDefault("vmScaleSetName")
  valid_569020 = validateParameter(valid_569020, JString, required = true,
                                 default = nil)
  if valid_569020 != nil:
    section.add "vmScaleSetName", valid_569020
  var valid_569021 = path.getOrDefault("resourceGroupName")
  valid_569021 = validateParameter(valid_569021, JString, required = true,
                                 default = nil)
  if valid_569021 != nil:
    section.add "resourceGroupName", valid_569021
  var valid_569022 = path.getOrDefault("subscriptionId")
  valid_569022 = validateParameter(valid_569022, JString, required = true,
                                 default = nil)
  if valid_569022 != nil:
    section.add "subscriptionId", valid_569022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569023 = query.getOrDefault("api-version")
  valid_569023 = validateParameter(valid_569023, JString, required = true,
                                 default = nil)
  if valid_569023 != nil:
    section.add "api-version", valid_569023
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

proc call*(call_569025: Call_VirtualMachineScaleSetsReimage_569017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reimages (upgrade the operating system) one or more virtual machines in a VM scale set which don't have a ephemeral OS disk, for virtual machines who have a ephemeral OS disk the virtual machine is reset to initial state.
  ## 
  let valid = call_569025.validator(path, query, header, formData, body)
  let scheme = call_569025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569025.url(scheme.get, call_569025.host, call_569025.base,
                         call_569025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569025, url, valid)

proc call*(call_569026: Call_VirtualMachineScaleSetsReimage_569017;
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
  var path_569027 = newJObject()
  var query_569028 = newJObject()
  var body_569029 = newJObject()
  add(path_569027, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569027, "resourceGroupName", newJString(resourceGroupName))
  add(query_569028, "api-version", newJString(apiVersion))
  add(path_569027, "subscriptionId", newJString(subscriptionId))
  if vmScaleSetReimageInput != nil:
    body_569029 = vmScaleSetReimageInput
  result = call_569026.call(path_569027, query_569028, nil, nil, body_569029)

var virtualMachineScaleSetsReimage* = Call_VirtualMachineScaleSetsReimage_569017(
    name: "virtualMachineScaleSetsReimage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/reimage",
    validator: validate_VirtualMachineScaleSetsReimage_569018, base: "",
    url: url_VirtualMachineScaleSetsReimage_569019, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsReimageAll_569030 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsReimageAll_569032(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsReimageAll_569031(path: JsonNode;
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
  var valid_569033 = path.getOrDefault("vmScaleSetName")
  valid_569033 = validateParameter(valid_569033, JString, required = true,
                                 default = nil)
  if valid_569033 != nil:
    section.add "vmScaleSetName", valid_569033
  var valid_569034 = path.getOrDefault("resourceGroupName")
  valid_569034 = validateParameter(valid_569034, JString, required = true,
                                 default = nil)
  if valid_569034 != nil:
    section.add "resourceGroupName", valid_569034
  var valid_569035 = path.getOrDefault("subscriptionId")
  valid_569035 = validateParameter(valid_569035, JString, required = true,
                                 default = nil)
  if valid_569035 != nil:
    section.add "subscriptionId", valid_569035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569036 = query.getOrDefault("api-version")
  valid_569036 = validateParameter(valid_569036, JString, required = true,
                                 default = nil)
  if valid_569036 != nil:
    section.add "api-version", valid_569036
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

proc call*(call_569038: Call_VirtualMachineScaleSetsReimageAll_569030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reimages all the disks ( including data disks ) in the virtual machines in a VM scale set. This operation is only supported for managed disks.
  ## 
  let valid = call_569038.validator(path, query, header, formData, body)
  let scheme = call_569038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569038.url(scheme.get, call_569038.host, call_569038.base,
                         call_569038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569038, url, valid)

proc call*(call_569039: Call_VirtualMachineScaleSetsReimageAll_569030;
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
  var path_569040 = newJObject()
  var query_569041 = newJObject()
  var body_569042 = newJObject()
  add(path_569040, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569040, "resourceGroupName", newJString(resourceGroupName))
  add(query_569041, "api-version", newJString(apiVersion))
  add(path_569040, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_569042 = vmInstanceIDs
  result = call_569039.call(path_569040, query_569041, nil, nil, body_569042)

var virtualMachineScaleSetsReimageAll* = Call_VirtualMachineScaleSetsReimageAll_569030(
    name: "virtualMachineScaleSetsReimageAll", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/reimageall",
    validator: validate_VirtualMachineScaleSetsReimageAll_569031, base: "",
    url: url_VirtualMachineScaleSetsReimageAll_569032, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsRestart_569043 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsRestart_569045(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsRestart_569044(path: JsonNode;
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
  var valid_569046 = path.getOrDefault("vmScaleSetName")
  valid_569046 = validateParameter(valid_569046, JString, required = true,
                                 default = nil)
  if valid_569046 != nil:
    section.add "vmScaleSetName", valid_569046
  var valid_569047 = path.getOrDefault("resourceGroupName")
  valid_569047 = validateParameter(valid_569047, JString, required = true,
                                 default = nil)
  if valid_569047 != nil:
    section.add "resourceGroupName", valid_569047
  var valid_569048 = path.getOrDefault("subscriptionId")
  valid_569048 = validateParameter(valid_569048, JString, required = true,
                                 default = nil)
  if valid_569048 != nil:
    section.add "subscriptionId", valid_569048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569049 = query.getOrDefault("api-version")
  valid_569049 = validateParameter(valid_569049, JString, required = true,
                                 default = nil)
  if valid_569049 != nil:
    section.add "api-version", valid_569049
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

proc call*(call_569051: Call_VirtualMachineScaleSetsRestart_569043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts one or more virtual machines in a VM scale set.
  ## 
  let valid = call_569051.validator(path, query, header, formData, body)
  let scheme = call_569051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569051.url(scheme.get, call_569051.host, call_569051.base,
                         call_569051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569051, url, valid)

proc call*(call_569052: Call_VirtualMachineScaleSetsRestart_569043;
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
  var path_569053 = newJObject()
  var query_569054 = newJObject()
  var body_569055 = newJObject()
  add(path_569053, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569053, "resourceGroupName", newJString(resourceGroupName))
  add(query_569054, "api-version", newJString(apiVersion))
  add(path_569053, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_569055 = vmInstanceIDs
  result = call_569052.call(path_569053, query_569054, nil, nil, body_569055)

var virtualMachineScaleSetsRestart* = Call_VirtualMachineScaleSetsRestart_569043(
    name: "virtualMachineScaleSetsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/restart",
    validator: validate_VirtualMachineScaleSetsRestart_569044, base: "",
    url: url_VirtualMachineScaleSetsRestart_569045, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesCancel_569056 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetRollingUpgradesCancel_569058(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetRollingUpgradesCancel_569057(path: JsonNode;
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
  var valid_569059 = path.getOrDefault("vmScaleSetName")
  valid_569059 = validateParameter(valid_569059, JString, required = true,
                                 default = nil)
  if valid_569059 != nil:
    section.add "vmScaleSetName", valid_569059
  var valid_569060 = path.getOrDefault("resourceGroupName")
  valid_569060 = validateParameter(valid_569060, JString, required = true,
                                 default = nil)
  if valid_569060 != nil:
    section.add "resourceGroupName", valid_569060
  var valid_569061 = path.getOrDefault("subscriptionId")
  valid_569061 = validateParameter(valid_569061, JString, required = true,
                                 default = nil)
  if valid_569061 != nil:
    section.add "subscriptionId", valid_569061
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569062 = query.getOrDefault("api-version")
  valid_569062 = validateParameter(valid_569062, JString, required = true,
                                 default = nil)
  if valid_569062 != nil:
    section.add "api-version", valid_569062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569063: Call_VirtualMachineScaleSetRollingUpgradesCancel_569056;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the current virtual machine scale set rolling upgrade.
  ## 
  let valid = call_569063.validator(path, query, header, formData, body)
  let scheme = call_569063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569063.url(scheme.get, call_569063.host, call_569063.base,
                         call_569063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569063, url, valid)

proc call*(call_569064: Call_VirtualMachineScaleSetRollingUpgradesCancel_569056;
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
  var path_569065 = newJObject()
  var query_569066 = newJObject()
  add(path_569065, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569065, "resourceGroupName", newJString(resourceGroupName))
  add(query_569066, "api-version", newJString(apiVersion))
  add(path_569065, "subscriptionId", newJString(subscriptionId))
  result = call_569064.call(path_569065, query_569066, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesCancel* = Call_VirtualMachineScaleSetRollingUpgradesCancel_569056(
    name: "virtualMachineScaleSetRollingUpgradesCancel",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/rollingUpgrades/cancel",
    validator: validate_VirtualMachineScaleSetRollingUpgradesCancel_569057,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesCancel_569058,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesGetLatest_569067 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetRollingUpgradesGetLatest_569069(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetRollingUpgradesGetLatest_569068(
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
  var valid_569070 = path.getOrDefault("vmScaleSetName")
  valid_569070 = validateParameter(valid_569070, JString, required = true,
                                 default = nil)
  if valid_569070 != nil:
    section.add "vmScaleSetName", valid_569070
  var valid_569071 = path.getOrDefault("resourceGroupName")
  valid_569071 = validateParameter(valid_569071, JString, required = true,
                                 default = nil)
  if valid_569071 != nil:
    section.add "resourceGroupName", valid_569071
  var valid_569072 = path.getOrDefault("subscriptionId")
  valid_569072 = validateParameter(valid_569072, JString, required = true,
                                 default = nil)
  if valid_569072 != nil:
    section.add "subscriptionId", valid_569072
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569073 = query.getOrDefault("api-version")
  valid_569073 = validateParameter(valid_569073, JString, required = true,
                                 default = nil)
  if valid_569073 != nil:
    section.add "api-version", valid_569073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569074: Call_VirtualMachineScaleSetRollingUpgradesGetLatest_569067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of the latest virtual machine scale set rolling upgrade.
  ## 
  let valid = call_569074.validator(path, query, header, formData, body)
  let scheme = call_569074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569074.url(scheme.get, call_569074.host, call_569074.base,
                         call_569074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569074, url, valid)

proc call*(call_569075: Call_VirtualMachineScaleSetRollingUpgradesGetLatest_569067;
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
  var path_569076 = newJObject()
  var query_569077 = newJObject()
  add(path_569076, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569076, "resourceGroupName", newJString(resourceGroupName))
  add(query_569077, "api-version", newJString(apiVersion))
  add(path_569076, "subscriptionId", newJString(subscriptionId))
  result = call_569075.call(path_569076, query_569077, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesGetLatest* = Call_VirtualMachineScaleSetRollingUpgradesGetLatest_569067(
    name: "virtualMachineScaleSetRollingUpgradesGetLatest",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/rollingUpgrades/latest",
    validator: validate_VirtualMachineScaleSetRollingUpgradesGetLatest_569068,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesGetLatest_569069,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsListSkus_569078 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsListSkus_569080(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsListSkus_569079(path: JsonNode;
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
  var valid_569081 = path.getOrDefault("vmScaleSetName")
  valid_569081 = validateParameter(valid_569081, JString, required = true,
                                 default = nil)
  if valid_569081 != nil:
    section.add "vmScaleSetName", valid_569081
  var valid_569082 = path.getOrDefault("resourceGroupName")
  valid_569082 = validateParameter(valid_569082, JString, required = true,
                                 default = nil)
  if valid_569082 != nil:
    section.add "resourceGroupName", valid_569082
  var valid_569083 = path.getOrDefault("subscriptionId")
  valid_569083 = validateParameter(valid_569083, JString, required = true,
                                 default = nil)
  if valid_569083 != nil:
    section.add "subscriptionId", valid_569083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569084 = query.getOrDefault("api-version")
  valid_569084 = validateParameter(valid_569084, JString, required = true,
                                 default = nil)
  if valid_569084 != nil:
    section.add "api-version", valid_569084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569085: Call_VirtualMachineScaleSetsListSkus_569078;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of SKUs available for your VM scale set, including the minimum and maximum VM instances allowed for each SKU.
  ## 
  let valid = call_569085.validator(path, query, header, formData, body)
  let scheme = call_569085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569085.url(scheme.get, call_569085.host, call_569085.base,
                         call_569085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569085, url, valid)

proc call*(call_569086: Call_VirtualMachineScaleSetsListSkus_569078;
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
  var path_569087 = newJObject()
  var query_569088 = newJObject()
  add(path_569087, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569087, "resourceGroupName", newJString(resourceGroupName))
  add(query_569088, "api-version", newJString(apiVersion))
  add(path_569087, "subscriptionId", newJString(subscriptionId))
  result = call_569086.call(path_569087, query_569088, nil, nil, nil)

var virtualMachineScaleSetsListSkus* = Call_VirtualMachineScaleSetsListSkus_569078(
    name: "virtualMachineScaleSetsListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/skus",
    validator: validate_VirtualMachineScaleSetsListSkus_569079, base: "",
    url: url_VirtualMachineScaleSetsListSkus_569080, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsStart_569089 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetsStart_569091(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsStart_569090(path: JsonNode; query: JsonNode;
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
  var valid_569092 = path.getOrDefault("vmScaleSetName")
  valid_569092 = validateParameter(valid_569092, JString, required = true,
                                 default = nil)
  if valid_569092 != nil:
    section.add "vmScaleSetName", valid_569092
  var valid_569093 = path.getOrDefault("resourceGroupName")
  valid_569093 = validateParameter(valid_569093, JString, required = true,
                                 default = nil)
  if valid_569093 != nil:
    section.add "resourceGroupName", valid_569093
  var valid_569094 = path.getOrDefault("subscriptionId")
  valid_569094 = validateParameter(valid_569094, JString, required = true,
                                 default = nil)
  if valid_569094 != nil:
    section.add "subscriptionId", valid_569094
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569095 = query.getOrDefault("api-version")
  valid_569095 = validateParameter(valid_569095, JString, required = true,
                                 default = nil)
  if valid_569095 != nil:
    section.add "api-version", valid_569095
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

proc call*(call_569097: Call_VirtualMachineScaleSetsStart_569089; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts one or more virtual machines in a VM scale set.
  ## 
  let valid = call_569097.validator(path, query, header, formData, body)
  let scheme = call_569097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569097.url(scheme.get, call_569097.host, call_569097.base,
                         call_569097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569097, url, valid)

proc call*(call_569098: Call_VirtualMachineScaleSetsStart_569089;
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
  var path_569099 = newJObject()
  var query_569100 = newJObject()
  var body_569101 = newJObject()
  add(path_569099, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569099, "resourceGroupName", newJString(resourceGroupName))
  add(query_569100, "api-version", newJString(apiVersion))
  add(path_569099, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_569101 = vmInstanceIDs
  result = call_569098.call(path_569099, query_569100, nil, nil, body_569101)

var virtualMachineScaleSetsStart* = Call_VirtualMachineScaleSetsStart_569089(
    name: "virtualMachineScaleSetsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/start",
    validator: validate_VirtualMachineScaleSetsStart_569090, base: "",
    url: url_VirtualMachineScaleSetsStart_569091, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsUpdate_569115 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsUpdate_569117(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsUpdate_569116(path: JsonNode;
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
  var valid_569118 = path.getOrDefault("vmScaleSetName")
  valid_569118 = validateParameter(valid_569118, JString, required = true,
                                 default = nil)
  if valid_569118 != nil:
    section.add "vmScaleSetName", valid_569118
  var valid_569119 = path.getOrDefault("resourceGroupName")
  valid_569119 = validateParameter(valid_569119, JString, required = true,
                                 default = nil)
  if valid_569119 != nil:
    section.add "resourceGroupName", valid_569119
  var valid_569120 = path.getOrDefault("subscriptionId")
  valid_569120 = validateParameter(valid_569120, JString, required = true,
                                 default = nil)
  if valid_569120 != nil:
    section.add "subscriptionId", valid_569120
  var valid_569121 = path.getOrDefault("instanceId")
  valid_569121 = validateParameter(valid_569121, JString, required = true,
                                 default = nil)
  if valid_569121 != nil:
    section.add "instanceId", valid_569121
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569122 = query.getOrDefault("api-version")
  valid_569122 = validateParameter(valid_569122, JString, required = true,
                                 default = nil)
  if valid_569122 != nil:
    section.add "api-version", valid_569122
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

proc call*(call_569124: Call_VirtualMachineScaleSetVMsUpdate_569115;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a virtual machine of a VM scale set.
  ## 
  let valid = call_569124.validator(path, query, header, formData, body)
  let scheme = call_569124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569124.url(scheme.get, call_569124.host, call_569124.base,
                         call_569124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569124, url, valid)

proc call*(call_569125: Call_VirtualMachineScaleSetVMsUpdate_569115;
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
  var path_569126 = newJObject()
  var query_569127 = newJObject()
  var body_569128 = newJObject()
  add(path_569126, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569126, "resourceGroupName", newJString(resourceGroupName))
  add(query_569127, "api-version", newJString(apiVersion))
  add(path_569126, "subscriptionId", newJString(subscriptionId))
  add(path_569126, "instanceId", newJString(instanceId))
  if parameters != nil:
    body_569128 = parameters
  result = call_569125.call(path_569126, query_569127, nil, nil, body_569128)

var virtualMachineScaleSetVMsUpdate* = Call_VirtualMachineScaleSetVMsUpdate_569115(
    name: "virtualMachineScaleSetVMsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsUpdate_569116, base: "",
    url: url_VirtualMachineScaleSetVMsUpdate_569117, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsGet_569102 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsGet_569104(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsGet_569103(path: JsonNode; query: JsonNode;
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
  var valid_569105 = path.getOrDefault("vmScaleSetName")
  valid_569105 = validateParameter(valid_569105, JString, required = true,
                                 default = nil)
  if valid_569105 != nil:
    section.add "vmScaleSetName", valid_569105
  var valid_569106 = path.getOrDefault("resourceGroupName")
  valid_569106 = validateParameter(valid_569106, JString, required = true,
                                 default = nil)
  if valid_569106 != nil:
    section.add "resourceGroupName", valid_569106
  var valid_569107 = path.getOrDefault("subscriptionId")
  valid_569107 = validateParameter(valid_569107, JString, required = true,
                                 default = nil)
  if valid_569107 != nil:
    section.add "subscriptionId", valid_569107
  var valid_569108 = path.getOrDefault("instanceId")
  valid_569108 = validateParameter(valid_569108, JString, required = true,
                                 default = nil)
  if valid_569108 != nil:
    section.add "instanceId", valid_569108
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_569109 = query.getOrDefault("$expand")
  valid_569109 = validateParameter(valid_569109, JString, required = false,
                                 default = newJString("instanceView"))
  if valid_569109 != nil:
    section.add "$expand", valid_569109
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569110 = query.getOrDefault("api-version")
  valid_569110 = validateParameter(valid_569110, JString, required = true,
                                 default = nil)
  if valid_569110 != nil:
    section.add "api-version", valid_569110
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569111: Call_VirtualMachineScaleSetVMsGet_569102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a virtual machine from a VM scale set.
  ## 
  let valid = call_569111.validator(path, query, header, formData, body)
  let scheme = call_569111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569111.url(scheme.get, call_569111.host, call_569111.base,
                         call_569111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569111, url, valid)

proc call*(call_569112: Call_VirtualMachineScaleSetVMsGet_569102;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string;
          Expand: string = "instanceView"): Recallable =
  ## virtualMachineScaleSetVMsGet
  ## Gets a virtual machine from a VM scale set.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   Expand: string
  ##         : The expand expression to apply on the operation.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_569113 = newJObject()
  var query_569114 = newJObject()
  add(path_569113, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569113, "resourceGroupName", newJString(resourceGroupName))
  add(query_569114, "$expand", newJString(Expand))
  add(query_569114, "api-version", newJString(apiVersion))
  add(path_569113, "subscriptionId", newJString(subscriptionId))
  add(path_569113, "instanceId", newJString(instanceId))
  result = call_569112.call(path_569113, query_569114, nil, nil, nil)

var virtualMachineScaleSetVMsGet* = Call_VirtualMachineScaleSetVMsGet_569102(
    name: "virtualMachineScaleSetVMsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsGet_569103, base: "",
    url: url_VirtualMachineScaleSetVMsGet_569104, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsDelete_569129 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsDelete_569131(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsDelete_569130(path: JsonNode;
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
  var valid_569132 = path.getOrDefault("vmScaleSetName")
  valid_569132 = validateParameter(valid_569132, JString, required = true,
                                 default = nil)
  if valid_569132 != nil:
    section.add "vmScaleSetName", valid_569132
  var valid_569133 = path.getOrDefault("resourceGroupName")
  valid_569133 = validateParameter(valid_569133, JString, required = true,
                                 default = nil)
  if valid_569133 != nil:
    section.add "resourceGroupName", valid_569133
  var valid_569134 = path.getOrDefault("subscriptionId")
  valid_569134 = validateParameter(valid_569134, JString, required = true,
                                 default = nil)
  if valid_569134 != nil:
    section.add "subscriptionId", valid_569134
  var valid_569135 = path.getOrDefault("instanceId")
  valid_569135 = validateParameter(valid_569135, JString, required = true,
                                 default = nil)
  if valid_569135 != nil:
    section.add "instanceId", valid_569135
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569136 = query.getOrDefault("api-version")
  valid_569136 = validateParameter(valid_569136, JString, required = true,
                                 default = nil)
  if valid_569136 != nil:
    section.add "api-version", valid_569136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569137: Call_VirtualMachineScaleSetVMsDelete_569129;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a virtual machine from a VM scale set.
  ## 
  let valid = call_569137.validator(path, query, header, formData, body)
  let scheme = call_569137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569137.url(scheme.get, call_569137.host, call_569137.base,
                         call_569137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569137, url, valid)

proc call*(call_569138: Call_VirtualMachineScaleSetVMsDelete_569129;
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
  var path_569139 = newJObject()
  var query_569140 = newJObject()
  add(path_569139, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569139, "resourceGroupName", newJString(resourceGroupName))
  add(query_569140, "api-version", newJString(apiVersion))
  add(path_569139, "subscriptionId", newJString(subscriptionId))
  add(path_569139, "instanceId", newJString(instanceId))
  result = call_569138.call(path_569139, query_569140, nil, nil, nil)

var virtualMachineScaleSetVMsDelete* = Call_VirtualMachineScaleSetVMsDelete_569129(
    name: "virtualMachineScaleSetVMsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsDelete_569130, base: "",
    url: url_VirtualMachineScaleSetVMsDelete_569131, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsDeallocate_569141 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsDeallocate_569143(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsDeallocate_569142(path: JsonNode;
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
  var valid_569144 = path.getOrDefault("vmScaleSetName")
  valid_569144 = validateParameter(valid_569144, JString, required = true,
                                 default = nil)
  if valid_569144 != nil:
    section.add "vmScaleSetName", valid_569144
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
  var valid_569147 = path.getOrDefault("instanceId")
  valid_569147 = validateParameter(valid_569147, JString, required = true,
                                 default = nil)
  if valid_569147 != nil:
    section.add "instanceId", valid_569147
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

proc call*(call_569149: Call_VirtualMachineScaleSetVMsDeallocate_569141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deallocates a specific virtual machine in a VM scale set. Shuts down the virtual machine and releases the compute resources it uses. You are not billed for the compute resources of this virtual machine once it is deallocated.
  ## 
  let valid = call_569149.validator(path, query, header, formData, body)
  let scheme = call_569149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569149.url(scheme.get, call_569149.host, call_569149.base,
                         call_569149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569149, url, valid)

proc call*(call_569150: Call_VirtualMachineScaleSetVMsDeallocate_569141;
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
  var path_569151 = newJObject()
  var query_569152 = newJObject()
  add(path_569151, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569151, "resourceGroupName", newJString(resourceGroupName))
  add(query_569152, "api-version", newJString(apiVersion))
  add(path_569151, "subscriptionId", newJString(subscriptionId))
  add(path_569151, "instanceId", newJString(instanceId))
  result = call_569150.call(path_569151, query_569152, nil, nil, nil)

var virtualMachineScaleSetVMsDeallocate* = Call_VirtualMachineScaleSetVMsDeallocate_569141(
    name: "virtualMachineScaleSetVMsDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/deallocate",
    validator: validate_VirtualMachineScaleSetVMsDeallocate_569142, base: "",
    url: url_VirtualMachineScaleSetVMsDeallocate_569143, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsGetInstanceView_569153 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsGetInstanceView_569155(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetVMsGetInstanceView_569154(path: JsonNode;
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
  var valid_569156 = path.getOrDefault("vmScaleSetName")
  valid_569156 = validateParameter(valid_569156, JString, required = true,
                                 default = nil)
  if valid_569156 != nil:
    section.add "vmScaleSetName", valid_569156
  var valid_569157 = path.getOrDefault("resourceGroupName")
  valid_569157 = validateParameter(valid_569157, JString, required = true,
                                 default = nil)
  if valid_569157 != nil:
    section.add "resourceGroupName", valid_569157
  var valid_569158 = path.getOrDefault("subscriptionId")
  valid_569158 = validateParameter(valid_569158, JString, required = true,
                                 default = nil)
  if valid_569158 != nil:
    section.add "subscriptionId", valid_569158
  var valid_569159 = path.getOrDefault("instanceId")
  valid_569159 = validateParameter(valid_569159, JString, required = true,
                                 default = nil)
  if valid_569159 != nil:
    section.add "instanceId", valid_569159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569160 = query.getOrDefault("api-version")
  valid_569160 = validateParameter(valid_569160, JString, required = true,
                                 default = nil)
  if valid_569160 != nil:
    section.add "api-version", valid_569160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569161: Call_VirtualMachineScaleSetVMsGetInstanceView_569153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of a virtual machine from a VM scale set.
  ## 
  let valid = call_569161.validator(path, query, header, formData, body)
  let scheme = call_569161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569161.url(scheme.get, call_569161.host, call_569161.base,
                         call_569161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569161, url, valid)

proc call*(call_569162: Call_VirtualMachineScaleSetVMsGetInstanceView_569153;
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
  var path_569163 = newJObject()
  var query_569164 = newJObject()
  add(path_569163, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569163, "resourceGroupName", newJString(resourceGroupName))
  add(query_569164, "api-version", newJString(apiVersion))
  add(path_569163, "subscriptionId", newJString(subscriptionId))
  add(path_569163, "instanceId", newJString(instanceId))
  result = call_569162.call(path_569163, query_569164, nil, nil, nil)

var virtualMachineScaleSetVMsGetInstanceView* = Call_VirtualMachineScaleSetVMsGetInstanceView_569153(
    name: "virtualMachineScaleSetVMsGetInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/instanceView",
    validator: validate_VirtualMachineScaleSetVMsGetInstanceView_569154, base: "",
    url: url_VirtualMachineScaleSetVMsGetInstanceView_569155,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsPerformMaintenance_569165 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsPerformMaintenance_569167(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetVMsPerformMaintenance_569166(path: JsonNode;
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
  var valid_569168 = path.getOrDefault("vmScaleSetName")
  valid_569168 = validateParameter(valid_569168, JString, required = true,
                                 default = nil)
  if valid_569168 != nil:
    section.add "vmScaleSetName", valid_569168
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
  var valid_569171 = path.getOrDefault("instanceId")
  valid_569171 = validateParameter(valid_569171, JString, required = true,
                                 default = nil)
  if valid_569171 != nil:
    section.add "instanceId", valid_569171
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
  if body != nil:
    result.add "body", body

proc call*(call_569173: Call_VirtualMachineScaleSetVMsPerformMaintenance_569165;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Performs maintenance on a virtual machine in a VM scale set.
  ## 
  let valid = call_569173.validator(path, query, header, formData, body)
  let scheme = call_569173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569173.url(scheme.get, call_569173.host, call_569173.base,
                         call_569173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569173, url, valid)

proc call*(call_569174: Call_VirtualMachineScaleSetVMsPerformMaintenance_569165;
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
  var path_569175 = newJObject()
  var query_569176 = newJObject()
  add(path_569175, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569175, "resourceGroupName", newJString(resourceGroupName))
  add(query_569176, "api-version", newJString(apiVersion))
  add(path_569175, "subscriptionId", newJString(subscriptionId))
  add(path_569175, "instanceId", newJString(instanceId))
  result = call_569174.call(path_569175, query_569176, nil, nil, nil)

var virtualMachineScaleSetVMsPerformMaintenance* = Call_VirtualMachineScaleSetVMsPerformMaintenance_569165(
    name: "virtualMachineScaleSetVMsPerformMaintenance",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/performMaintenance",
    validator: validate_VirtualMachineScaleSetVMsPerformMaintenance_569166,
    base: "", url: url_VirtualMachineScaleSetVMsPerformMaintenance_569167,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsPowerOff_569177 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsPowerOff_569179(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsPowerOff_569178(path: JsonNode;
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
  var valid_569180 = path.getOrDefault("vmScaleSetName")
  valid_569180 = validateParameter(valid_569180, JString, required = true,
                                 default = nil)
  if valid_569180 != nil:
    section.add "vmScaleSetName", valid_569180
  var valid_569181 = path.getOrDefault("resourceGroupName")
  valid_569181 = validateParameter(valid_569181, JString, required = true,
                                 default = nil)
  if valid_569181 != nil:
    section.add "resourceGroupName", valid_569181
  var valid_569182 = path.getOrDefault("subscriptionId")
  valid_569182 = validateParameter(valid_569182, JString, required = true,
                                 default = nil)
  if valid_569182 != nil:
    section.add "subscriptionId", valid_569182
  var valid_569183 = path.getOrDefault("instanceId")
  valid_569183 = validateParameter(valid_569183, JString, required = true,
                                 default = nil)
  if valid_569183 != nil:
    section.add "instanceId", valid_569183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   skipShutdown: JBool
  ##               : The parameter to request non-graceful VM shutdown. True value for this flag indicates non-graceful shutdown whereas false indicates otherwise. Default value for this flag is false if not specified
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569184 = query.getOrDefault("api-version")
  valid_569184 = validateParameter(valid_569184, JString, required = true,
                                 default = nil)
  if valid_569184 != nil:
    section.add "api-version", valid_569184
  var valid_569185 = query.getOrDefault("skipShutdown")
  valid_569185 = validateParameter(valid_569185, JBool, required = false,
                                 default = newJBool(false))
  if valid_569185 != nil:
    section.add "skipShutdown", valid_569185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569186: Call_VirtualMachineScaleSetVMsPowerOff_569177;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Power off (stop) a virtual machine in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  let valid = call_569186.validator(path, query, header, formData, body)
  let scheme = call_569186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569186.url(scheme.get, call_569186.host, call_569186.base,
                         call_569186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569186, url, valid)

proc call*(call_569187: Call_VirtualMachineScaleSetVMsPowerOff_569177;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string; skipShutdown: bool = false): Recallable =
  ## virtualMachineScaleSetVMsPowerOff
  ## Power off (stop) a virtual machine in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ##   vmScaleSetName: string (required)
  ##                 : The name of the VM scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   skipShutdown: bool
  ##               : The parameter to request non-graceful VM shutdown. True value for this flag indicates non-graceful shutdown whereas false indicates otherwise. Default value for this flag is false if not specified
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   instanceId: string (required)
  ##             : The instance ID of the virtual machine.
  var path_569188 = newJObject()
  var query_569189 = newJObject()
  add(path_569188, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569188, "resourceGroupName", newJString(resourceGroupName))
  add(query_569189, "api-version", newJString(apiVersion))
  add(query_569189, "skipShutdown", newJBool(skipShutdown))
  add(path_569188, "subscriptionId", newJString(subscriptionId))
  add(path_569188, "instanceId", newJString(instanceId))
  result = call_569187.call(path_569188, query_569189, nil, nil, nil)

var virtualMachineScaleSetVMsPowerOff* = Call_VirtualMachineScaleSetVMsPowerOff_569177(
    name: "virtualMachineScaleSetVMsPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/poweroff",
    validator: validate_VirtualMachineScaleSetVMsPowerOff_569178, base: "",
    url: url_VirtualMachineScaleSetVMsPowerOff_569179, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsRedeploy_569190 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsRedeploy_569192(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsRedeploy_569191(path: JsonNode;
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
  var valid_569193 = path.getOrDefault("vmScaleSetName")
  valid_569193 = validateParameter(valid_569193, JString, required = true,
                                 default = nil)
  if valid_569193 != nil:
    section.add "vmScaleSetName", valid_569193
  var valid_569194 = path.getOrDefault("resourceGroupName")
  valid_569194 = validateParameter(valid_569194, JString, required = true,
                                 default = nil)
  if valid_569194 != nil:
    section.add "resourceGroupName", valid_569194
  var valid_569195 = path.getOrDefault("subscriptionId")
  valid_569195 = validateParameter(valid_569195, JString, required = true,
                                 default = nil)
  if valid_569195 != nil:
    section.add "subscriptionId", valid_569195
  var valid_569196 = path.getOrDefault("instanceId")
  valid_569196 = validateParameter(valid_569196, JString, required = true,
                                 default = nil)
  if valid_569196 != nil:
    section.add "instanceId", valid_569196
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569197 = query.getOrDefault("api-version")
  valid_569197 = validateParameter(valid_569197, JString, required = true,
                                 default = nil)
  if valid_569197 != nil:
    section.add "api-version", valid_569197
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569198: Call_VirtualMachineScaleSetVMsRedeploy_569190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Shuts down the virtual machine in the virtual machine scale set, moves it to a new node, and powers it back on.
  ## 
  let valid = call_569198.validator(path, query, header, formData, body)
  let scheme = call_569198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569198.url(scheme.get, call_569198.host, call_569198.base,
                         call_569198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569198, url, valid)

proc call*(call_569199: Call_VirtualMachineScaleSetVMsRedeploy_569190;
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
  var path_569200 = newJObject()
  var query_569201 = newJObject()
  add(path_569200, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569200, "resourceGroupName", newJString(resourceGroupName))
  add(query_569201, "api-version", newJString(apiVersion))
  add(path_569200, "subscriptionId", newJString(subscriptionId))
  add(path_569200, "instanceId", newJString(instanceId))
  result = call_569199.call(path_569200, query_569201, nil, nil, nil)

var virtualMachineScaleSetVMsRedeploy* = Call_VirtualMachineScaleSetVMsRedeploy_569190(
    name: "virtualMachineScaleSetVMsRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/redeploy",
    validator: validate_VirtualMachineScaleSetVMsRedeploy_569191, base: "",
    url: url_VirtualMachineScaleSetVMsRedeploy_569192, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsReimage_569202 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsReimage_569204(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsReimage_569203(path: JsonNode;
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
  var valid_569205 = path.getOrDefault("vmScaleSetName")
  valid_569205 = validateParameter(valid_569205, JString, required = true,
                                 default = nil)
  if valid_569205 != nil:
    section.add "vmScaleSetName", valid_569205
  var valid_569206 = path.getOrDefault("resourceGroupName")
  valid_569206 = validateParameter(valid_569206, JString, required = true,
                                 default = nil)
  if valid_569206 != nil:
    section.add "resourceGroupName", valid_569206
  var valid_569207 = path.getOrDefault("subscriptionId")
  valid_569207 = validateParameter(valid_569207, JString, required = true,
                                 default = nil)
  if valid_569207 != nil:
    section.add "subscriptionId", valid_569207
  var valid_569208 = path.getOrDefault("instanceId")
  valid_569208 = validateParameter(valid_569208, JString, required = true,
                                 default = nil)
  if valid_569208 != nil:
    section.add "instanceId", valid_569208
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569209 = query.getOrDefault("api-version")
  valid_569209 = validateParameter(valid_569209, JString, required = true,
                                 default = nil)
  if valid_569209 != nil:
    section.add "api-version", valid_569209
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

proc call*(call_569211: Call_VirtualMachineScaleSetVMsReimage_569202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reimages (upgrade the operating system) a specific virtual machine in a VM scale set.
  ## 
  let valid = call_569211.validator(path, query, header, formData, body)
  let scheme = call_569211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569211.url(scheme.get, call_569211.host, call_569211.base,
                         call_569211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569211, url, valid)

proc call*(call_569212: Call_VirtualMachineScaleSetVMsReimage_569202;
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
  var path_569213 = newJObject()
  var query_569214 = newJObject()
  var body_569215 = newJObject()
  add(path_569213, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569213, "resourceGroupName", newJString(resourceGroupName))
  add(query_569214, "api-version", newJString(apiVersion))
  add(path_569213, "subscriptionId", newJString(subscriptionId))
  add(path_569213, "instanceId", newJString(instanceId))
  if vmScaleSetVMReimageInput != nil:
    body_569215 = vmScaleSetVMReimageInput
  result = call_569212.call(path_569213, query_569214, nil, nil, body_569215)

var virtualMachineScaleSetVMsReimage* = Call_VirtualMachineScaleSetVMsReimage_569202(
    name: "virtualMachineScaleSetVMsReimage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/reimage",
    validator: validate_VirtualMachineScaleSetVMsReimage_569203, base: "",
    url: url_VirtualMachineScaleSetVMsReimage_569204, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsReimageAll_569216 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsReimageAll_569218(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsReimageAll_569217(path: JsonNode;
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
  var valid_569219 = path.getOrDefault("vmScaleSetName")
  valid_569219 = validateParameter(valid_569219, JString, required = true,
                                 default = nil)
  if valid_569219 != nil:
    section.add "vmScaleSetName", valid_569219
  var valid_569220 = path.getOrDefault("resourceGroupName")
  valid_569220 = validateParameter(valid_569220, JString, required = true,
                                 default = nil)
  if valid_569220 != nil:
    section.add "resourceGroupName", valid_569220
  var valid_569221 = path.getOrDefault("subscriptionId")
  valid_569221 = validateParameter(valid_569221, JString, required = true,
                                 default = nil)
  if valid_569221 != nil:
    section.add "subscriptionId", valid_569221
  var valid_569222 = path.getOrDefault("instanceId")
  valid_569222 = validateParameter(valid_569222, JString, required = true,
                                 default = nil)
  if valid_569222 != nil:
    section.add "instanceId", valid_569222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569223 = query.getOrDefault("api-version")
  valid_569223 = validateParameter(valid_569223, JString, required = true,
                                 default = nil)
  if valid_569223 != nil:
    section.add "api-version", valid_569223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569224: Call_VirtualMachineScaleSetVMsReimageAll_569216;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Allows you to re-image all the disks ( including data disks ) in the a VM scale set instance. This operation is only supported for managed disks.
  ## 
  let valid = call_569224.validator(path, query, header, formData, body)
  let scheme = call_569224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569224.url(scheme.get, call_569224.host, call_569224.base,
                         call_569224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569224, url, valid)

proc call*(call_569225: Call_VirtualMachineScaleSetVMsReimageAll_569216;
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
  var path_569226 = newJObject()
  var query_569227 = newJObject()
  add(path_569226, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569226, "resourceGroupName", newJString(resourceGroupName))
  add(query_569227, "api-version", newJString(apiVersion))
  add(path_569226, "subscriptionId", newJString(subscriptionId))
  add(path_569226, "instanceId", newJString(instanceId))
  result = call_569225.call(path_569226, query_569227, nil, nil, nil)

var virtualMachineScaleSetVMsReimageAll* = Call_VirtualMachineScaleSetVMsReimageAll_569216(
    name: "virtualMachineScaleSetVMsReimageAll", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/reimageall",
    validator: validate_VirtualMachineScaleSetVMsReimageAll_569217, base: "",
    url: url_VirtualMachineScaleSetVMsReimageAll_569218, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsRestart_569228 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsRestart_569230(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsRestart_569229(path: JsonNode;
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
  var valid_569231 = path.getOrDefault("vmScaleSetName")
  valid_569231 = validateParameter(valid_569231, JString, required = true,
                                 default = nil)
  if valid_569231 != nil:
    section.add "vmScaleSetName", valid_569231
  var valid_569232 = path.getOrDefault("resourceGroupName")
  valid_569232 = validateParameter(valid_569232, JString, required = true,
                                 default = nil)
  if valid_569232 != nil:
    section.add "resourceGroupName", valid_569232
  var valid_569233 = path.getOrDefault("subscriptionId")
  valid_569233 = validateParameter(valid_569233, JString, required = true,
                                 default = nil)
  if valid_569233 != nil:
    section.add "subscriptionId", valid_569233
  var valid_569234 = path.getOrDefault("instanceId")
  valid_569234 = validateParameter(valid_569234, JString, required = true,
                                 default = nil)
  if valid_569234 != nil:
    section.add "instanceId", valid_569234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569235 = query.getOrDefault("api-version")
  valid_569235 = validateParameter(valid_569235, JString, required = true,
                                 default = nil)
  if valid_569235 != nil:
    section.add "api-version", valid_569235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569236: Call_VirtualMachineScaleSetVMsRestart_569228;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Restarts a virtual machine in a VM scale set.
  ## 
  let valid = call_569236.validator(path, query, header, formData, body)
  let scheme = call_569236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569236.url(scheme.get, call_569236.host, call_569236.base,
                         call_569236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569236, url, valid)

proc call*(call_569237: Call_VirtualMachineScaleSetVMsRestart_569228;
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
  var path_569238 = newJObject()
  var query_569239 = newJObject()
  add(path_569238, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569238, "resourceGroupName", newJString(resourceGroupName))
  add(query_569239, "api-version", newJString(apiVersion))
  add(path_569238, "subscriptionId", newJString(subscriptionId))
  add(path_569238, "instanceId", newJString(instanceId))
  result = call_569237.call(path_569238, query_569239, nil, nil, nil)

var virtualMachineScaleSetVMsRestart* = Call_VirtualMachineScaleSetVMsRestart_569228(
    name: "virtualMachineScaleSetVMsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/restart",
    validator: validate_VirtualMachineScaleSetVMsRestart_569229, base: "",
    url: url_VirtualMachineScaleSetVMsRestart_569230, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsStart_569240 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineScaleSetVMsStart_569242(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsStart_569241(path: JsonNode;
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
  var valid_569243 = path.getOrDefault("vmScaleSetName")
  valid_569243 = validateParameter(valid_569243, JString, required = true,
                                 default = nil)
  if valid_569243 != nil:
    section.add "vmScaleSetName", valid_569243
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
  var valid_569246 = path.getOrDefault("instanceId")
  valid_569246 = validateParameter(valid_569246, JString, required = true,
                                 default = nil)
  if valid_569246 != nil:
    section.add "instanceId", valid_569246
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

proc call*(call_569248: Call_VirtualMachineScaleSetVMsStart_569240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a virtual machine in a VM scale set.
  ## 
  let valid = call_569248.validator(path, query, header, formData, body)
  let scheme = call_569248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569248.url(scheme.get, call_569248.host, call_569248.base,
                         call_569248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569248, url, valid)

proc call*(call_569249: Call_VirtualMachineScaleSetVMsStart_569240;
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
  var path_569250 = newJObject()
  var query_569251 = newJObject()
  add(path_569250, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_569250, "resourceGroupName", newJString(resourceGroupName))
  add(query_569251, "api-version", newJString(apiVersion))
  add(path_569250, "subscriptionId", newJString(subscriptionId))
  add(path_569250, "instanceId", newJString(instanceId))
  result = call_569249.call(path_569250, query_569251, nil, nil, nil)

var virtualMachineScaleSetVMsStart* = Call_VirtualMachineScaleSetVMsStart_569240(
    name: "virtualMachineScaleSetVMsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/start",
    validator: validate_VirtualMachineScaleSetVMsStart_569241, base: "",
    url: url_VirtualMachineScaleSetVMsStart_569242, schemes: {Scheme.Https})
type
  Call_VirtualMachinesList_569252 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesList_569254(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesList_569253(path: JsonNode; query: JsonNode;
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
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569257 = query.getOrDefault("api-version")
  valid_569257 = validateParameter(valid_569257, JString, required = true,
                                 default = nil)
  if valid_569257 != nil:
    section.add "api-version", valid_569257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569258: Call_VirtualMachinesList_569252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the virtual machines in the specified resource group. Use the nextLink property in the response to get the next page of virtual machines.
  ## 
  let valid = call_569258.validator(path, query, header, formData, body)
  let scheme = call_569258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569258.url(scheme.get, call_569258.host, call_569258.base,
                         call_569258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569258, url, valid)

proc call*(call_569259: Call_VirtualMachinesList_569252; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachinesList
  ## Lists all of the virtual machines in the specified resource group. Use the nextLink property in the response to get the next page of virtual machines.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_569260 = newJObject()
  var query_569261 = newJObject()
  add(path_569260, "resourceGroupName", newJString(resourceGroupName))
  add(query_569261, "api-version", newJString(apiVersion))
  add(path_569260, "subscriptionId", newJString(subscriptionId))
  result = call_569259.call(path_569260, query_569261, nil, nil, nil)

var virtualMachinesList* = Call_VirtualMachinesList_569252(
    name: "virtualMachinesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines",
    validator: validate_VirtualMachinesList_569253, base: "",
    url: url_VirtualMachinesList_569254, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCreateOrUpdate_569274 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesCreateOrUpdate_569276(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesCreateOrUpdate_569275(path: JsonNode; query: JsonNode;
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
  var valid_569277 = path.getOrDefault("resourceGroupName")
  valid_569277 = validateParameter(valid_569277, JString, required = true,
                                 default = nil)
  if valid_569277 != nil:
    section.add "resourceGroupName", valid_569277
  var valid_569278 = path.getOrDefault("subscriptionId")
  valid_569278 = validateParameter(valid_569278, JString, required = true,
                                 default = nil)
  if valid_569278 != nil:
    section.add "subscriptionId", valid_569278
  var valid_569279 = path.getOrDefault("vmName")
  valid_569279 = validateParameter(valid_569279, JString, required = true,
                                 default = nil)
  if valid_569279 != nil:
    section.add "vmName", valid_569279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569280 = query.getOrDefault("api-version")
  valid_569280 = validateParameter(valid_569280, JString, required = true,
                                 default = nil)
  if valid_569280 != nil:
    section.add "api-version", valid_569280
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

proc call*(call_569282: Call_VirtualMachinesCreateOrUpdate_569274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a virtual machine.
  ## 
  let valid = call_569282.validator(path, query, header, formData, body)
  let scheme = call_569282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569282.url(scheme.get, call_569282.host, call_569282.base,
                         call_569282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569282, url, valid)

proc call*(call_569283: Call_VirtualMachinesCreateOrUpdate_569274;
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
  var path_569284 = newJObject()
  var query_569285 = newJObject()
  var body_569286 = newJObject()
  add(path_569284, "resourceGroupName", newJString(resourceGroupName))
  add(query_569285, "api-version", newJString(apiVersion))
  add(path_569284, "subscriptionId", newJString(subscriptionId))
  add(path_569284, "vmName", newJString(vmName))
  if parameters != nil:
    body_569286 = parameters
  result = call_569283.call(path_569284, query_569285, nil, nil, body_569286)

var virtualMachinesCreateOrUpdate* = Call_VirtualMachinesCreateOrUpdate_569274(
    name: "virtualMachinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesCreateOrUpdate_569275, base: "",
    url: url_VirtualMachinesCreateOrUpdate_569276, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGet_569262 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesGet_569264(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesGet_569263(path: JsonNode; query: JsonNode;
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
  var valid_569265 = path.getOrDefault("resourceGroupName")
  valid_569265 = validateParameter(valid_569265, JString, required = true,
                                 default = nil)
  if valid_569265 != nil:
    section.add "resourceGroupName", valid_569265
  var valid_569266 = path.getOrDefault("subscriptionId")
  valid_569266 = validateParameter(valid_569266, JString, required = true,
                                 default = nil)
  if valid_569266 != nil:
    section.add "subscriptionId", valid_569266
  var valid_569267 = path.getOrDefault("vmName")
  valid_569267 = validateParameter(valid_569267, JString, required = true,
                                 default = nil)
  if valid_569267 != nil:
    section.add "vmName", valid_569267
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_569268 = query.getOrDefault("$expand")
  valid_569268 = validateParameter(valid_569268, JString, required = false,
                                 default = newJString("instanceView"))
  if valid_569268 != nil:
    section.add "$expand", valid_569268
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

proc call*(call_569270: Call_VirtualMachinesGet_569262; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the model view or the instance view of a virtual machine.
  ## 
  let valid = call_569270.validator(path, query, header, formData, body)
  let scheme = call_569270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569270.url(scheme.get, call_569270.host, call_569270.base,
                         call_569270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569270, url, valid)

proc call*(call_569271: Call_VirtualMachinesGet_569262; resourceGroupName: string;
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
  var path_569272 = newJObject()
  var query_569273 = newJObject()
  add(path_569272, "resourceGroupName", newJString(resourceGroupName))
  add(query_569273, "$expand", newJString(Expand))
  add(query_569273, "api-version", newJString(apiVersion))
  add(path_569272, "subscriptionId", newJString(subscriptionId))
  add(path_569272, "vmName", newJString(vmName))
  result = call_569271.call(path_569272, query_569273, nil, nil, nil)

var virtualMachinesGet* = Call_VirtualMachinesGet_569262(
    name: "virtualMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesGet_569263, base: "",
    url: url_VirtualMachinesGet_569264, schemes: {Scheme.Https})
type
  Call_VirtualMachinesUpdate_569298 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesUpdate_569300(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesUpdate_569299(path: JsonNode; query: JsonNode;
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
  var valid_569301 = path.getOrDefault("resourceGroupName")
  valid_569301 = validateParameter(valid_569301, JString, required = true,
                                 default = nil)
  if valid_569301 != nil:
    section.add "resourceGroupName", valid_569301
  var valid_569302 = path.getOrDefault("subscriptionId")
  valid_569302 = validateParameter(valid_569302, JString, required = true,
                                 default = nil)
  if valid_569302 != nil:
    section.add "subscriptionId", valid_569302
  var valid_569303 = path.getOrDefault("vmName")
  valid_569303 = validateParameter(valid_569303, JString, required = true,
                                 default = nil)
  if valid_569303 != nil:
    section.add "vmName", valid_569303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569304 = query.getOrDefault("api-version")
  valid_569304 = validateParameter(valid_569304, JString, required = true,
                                 default = nil)
  if valid_569304 != nil:
    section.add "api-version", valid_569304
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

proc call*(call_569306: Call_VirtualMachinesUpdate_569298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a virtual machine.
  ## 
  let valid = call_569306.validator(path, query, header, formData, body)
  let scheme = call_569306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569306.url(scheme.get, call_569306.host, call_569306.base,
                         call_569306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569306, url, valid)

proc call*(call_569307: Call_VirtualMachinesUpdate_569298;
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
  var path_569308 = newJObject()
  var query_569309 = newJObject()
  var body_569310 = newJObject()
  add(path_569308, "resourceGroupName", newJString(resourceGroupName))
  add(query_569309, "api-version", newJString(apiVersion))
  add(path_569308, "subscriptionId", newJString(subscriptionId))
  add(path_569308, "vmName", newJString(vmName))
  if parameters != nil:
    body_569310 = parameters
  result = call_569307.call(path_569308, query_569309, nil, nil, body_569310)

var virtualMachinesUpdate* = Call_VirtualMachinesUpdate_569298(
    name: "virtualMachinesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesUpdate_569299, base: "",
    url: url_VirtualMachinesUpdate_569300, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDelete_569287 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesDelete_569289(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesDelete_569288(path: JsonNode; query: JsonNode;
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
  var valid_569290 = path.getOrDefault("resourceGroupName")
  valid_569290 = validateParameter(valid_569290, JString, required = true,
                                 default = nil)
  if valid_569290 != nil:
    section.add "resourceGroupName", valid_569290
  var valid_569291 = path.getOrDefault("subscriptionId")
  valid_569291 = validateParameter(valid_569291, JString, required = true,
                                 default = nil)
  if valid_569291 != nil:
    section.add "subscriptionId", valid_569291
  var valid_569292 = path.getOrDefault("vmName")
  valid_569292 = validateParameter(valid_569292, JString, required = true,
                                 default = nil)
  if valid_569292 != nil:
    section.add "vmName", valid_569292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569293 = query.getOrDefault("api-version")
  valid_569293 = validateParameter(valid_569293, JString, required = true,
                                 default = nil)
  if valid_569293 != nil:
    section.add "api-version", valid_569293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569294: Call_VirtualMachinesDelete_569287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a virtual machine.
  ## 
  let valid = call_569294.validator(path, query, header, formData, body)
  let scheme = call_569294.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569294.url(scheme.get, call_569294.host, call_569294.base,
                         call_569294.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569294, url, valid)

proc call*(call_569295: Call_VirtualMachinesDelete_569287;
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
  var path_569296 = newJObject()
  var query_569297 = newJObject()
  add(path_569296, "resourceGroupName", newJString(resourceGroupName))
  add(query_569297, "api-version", newJString(apiVersion))
  add(path_569296, "subscriptionId", newJString(subscriptionId))
  add(path_569296, "vmName", newJString(vmName))
  result = call_569295.call(path_569296, query_569297, nil, nil, nil)

var virtualMachinesDelete* = Call_VirtualMachinesDelete_569287(
    name: "virtualMachinesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesDelete_569288, base: "",
    url: url_VirtualMachinesDelete_569289, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCapture_569311 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesCapture_569313(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesCapture_569312(path: JsonNode; query: JsonNode;
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
  var valid_569314 = path.getOrDefault("resourceGroupName")
  valid_569314 = validateParameter(valid_569314, JString, required = true,
                                 default = nil)
  if valid_569314 != nil:
    section.add "resourceGroupName", valid_569314
  var valid_569315 = path.getOrDefault("subscriptionId")
  valid_569315 = validateParameter(valid_569315, JString, required = true,
                                 default = nil)
  if valid_569315 != nil:
    section.add "subscriptionId", valid_569315
  var valid_569316 = path.getOrDefault("vmName")
  valid_569316 = validateParameter(valid_569316, JString, required = true,
                                 default = nil)
  if valid_569316 != nil:
    section.add "vmName", valid_569316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569317 = query.getOrDefault("api-version")
  valid_569317 = validateParameter(valid_569317, JString, required = true,
                                 default = nil)
  if valid_569317 != nil:
    section.add "api-version", valid_569317
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

proc call*(call_569319: Call_VirtualMachinesCapture_569311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Captures the VM by copying virtual hard disks of the VM and outputs a template that can be used to create similar VMs.
  ## 
  let valid = call_569319.validator(path, query, header, formData, body)
  let scheme = call_569319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569319.url(scheme.get, call_569319.host, call_569319.base,
                         call_569319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569319, url, valid)

proc call*(call_569320: Call_VirtualMachinesCapture_569311;
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
  var path_569321 = newJObject()
  var query_569322 = newJObject()
  var body_569323 = newJObject()
  add(path_569321, "resourceGroupName", newJString(resourceGroupName))
  add(query_569322, "api-version", newJString(apiVersion))
  add(path_569321, "subscriptionId", newJString(subscriptionId))
  add(path_569321, "vmName", newJString(vmName))
  if parameters != nil:
    body_569323 = parameters
  result = call_569320.call(path_569321, query_569322, nil, nil, body_569323)

var virtualMachinesCapture* = Call_VirtualMachinesCapture_569311(
    name: "virtualMachinesCapture", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/capture",
    validator: validate_VirtualMachinesCapture_569312, base: "",
    url: url_VirtualMachinesCapture_569313, schemes: {Scheme.Https})
type
  Call_VirtualMachinesConvertToManagedDisks_569324 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesConvertToManagedDisks_569326(protocol: Scheme;
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

proc validate_VirtualMachinesConvertToManagedDisks_569325(path: JsonNode;
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
  var valid_569327 = path.getOrDefault("resourceGroupName")
  valid_569327 = validateParameter(valid_569327, JString, required = true,
                                 default = nil)
  if valid_569327 != nil:
    section.add "resourceGroupName", valid_569327
  var valid_569328 = path.getOrDefault("subscriptionId")
  valid_569328 = validateParameter(valid_569328, JString, required = true,
                                 default = nil)
  if valid_569328 != nil:
    section.add "subscriptionId", valid_569328
  var valid_569329 = path.getOrDefault("vmName")
  valid_569329 = validateParameter(valid_569329, JString, required = true,
                                 default = nil)
  if valid_569329 != nil:
    section.add "vmName", valid_569329
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569330 = query.getOrDefault("api-version")
  valid_569330 = validateParameter(valid_569330, JString, required = true,
                                 default = nil)
  if valid_569330 != nil:
    section.add "api-version", valid_569330
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569331: Call_VirtualMachinesConvertToManagedDisks_569324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Converts virtual machine disks from blob-based to managed disks. Virtual machine must be stop-deallocated before invoking this operation.
  ## 
  let valid = call_569331.validator(path, query, header, formData, body)
  let scheme = call_569331.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569331.url(scheme.get, call_569331.host, call_569331.base,
                         call_569331.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569331, url, valid)

proc call*(call_569332: Call_VirtualMachinesConvertToManagedDisks_569324;
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
  var path_569333 = newJObject()
  var query_569334 = newJObject()
  add(path_569333, "resourceGroupName", newJString(resourceGroupName))
  add(query_569334, "api-version", newJString(apiVersion))
  add(path_569333, "subscriptionId", newJString(subscriptionId))
  add(path_569333, "vmName", newJString(vmName))
  result = call_569332.call(path_569333, query_569334, nil, nil, nil)

var virtualMachinesConvertToManagedDisks* = Call_VirtualMachinesConvertToManagedDisks_569324(
    name: "virtualMachinesConvertToManagedDisks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/convertToManagedDisks",
    validator: validate_VirtualMachinesConvertToManagedDisks_569325, base: "",
    url: url_VirtualMachinesConvertToManagedDisks_569326, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDeallocate_569335 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesDeallocate_569337(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesDeallocate_569336(path: JsonNode; query: JsonNode;
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
  var valid_569338 = path.getOrDefault("resourceGroupName")
  valid_569338 = validateParameter(valid_569338, JString, required = true,
                                 default = nil)
  if valid_569338 != nil:
    section.add "resourceGroupName", valid_569338
  var valid_569339 = path.getOrDefault("subscriptionId")
  valid_569339 = validateParameter(valid_569339, JString, required = true,
                                 default = nil)
  if valid_569339 != nil:
    section.add "subscriptionId", valid_569339
  var valid_569340 = path.getOrDefault("vmName")
  valid_569340 = validateParameter(valid_569340, JString, required = true,
                                 default = nil)
  if valid_569340 != nil:
    section.add "vmName", valid_569340
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569341 = query.getOrDefault("api-version")
  valid_569341 = validateParameter(valid_569341, JString, required = true,
                                 default = nil)
  if valid_569341 != nil:
    section.add "api-version", valid_569341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569342: Call_VirtualMachinesDeallocate_569335; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shuts down the virtual machine and releases the compute resources. You are not billed for the compute resources that this virtual machine uses.
  ## 
  let valid = call_569342.validator(path, query, header, formData, body)
  let scheme = call_569342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569342.url(scheme.get, call_569342.host, call_569342.base,
                         call_569342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569342, url, valid)

proc call*(call_569343: Call_VirtualMachinesDeallocate_569335;
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
  var path_569344 = newJObject()
  var query_569345 = newJObject()
  add(path_569344, "resourceGroupName", newJString(resourceGroupName))
  add(query_569345, "api-version", newJString(apiVersion))
  add(path_569344, "subscriptionId", newJString(subscriptionId))
  add(path_569344, "vmName", newJString(vmName))
  result = call_569343.call(path_569344, query_569345, nil, nil, nil)

var virtualMachinesDeallocate* = Call_VirtualMachinesDeallocate_569335(
    name: "virtualMachinesDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/deallocate",
    validator: validate_VirtualMachinesDeallocate_569336, base: "",
    url: url_VirtualMachinesDeallocate_569337, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsList_569346 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionsList_569348(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionsList_569347(path: JsonNode; query: JsonNode;
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
  var valid_569349 = path.getOrDefault("resourceGroupName")
  valid_569349 = validateParameter(valid_569349, JString, required = true,
                                 default = nil)
  if valid_569349 != nil:
    section.add "resourceGroupName", valid_569349
  var valid_569350 = path.getOrDefault("subscriptionId")
  valid_569350 = validateParameter(valid_569350, JString, required = true,
                                 default = nil)
  if valid_569350 != nil:
    section.add "subscriptionId", valid_569350
  var valid_569351 = path.getOrDefault("vmName")
  valid_569351 = validateParameter(valid_569351, JString, required = true,
                                 default = nil)
  if valid_569351 != nil:
    section.add "vmName", valid_569351
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_569352 = query.getOrDefault("$expand")
  valid_569352 = validateParameter(valid_569352, JString, required = false,
                                 default = nil)
  if valid_569352 != nil:
    section.add "$expand", valid_569352
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569353 = query.getOrDefault("api-version")
  valid_569353 = validateParameter(valid_569353, JString, required = true,
                                 default = nil)
  if valid_569353 != nil:
    section.add "api-version", valid_569353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569354: Call_VirtualMachineExtensionsList_569346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get all extensions of a Virtual Machine.
  ## 
  let valid = call_569354.validator(path, query, header, formData, body)
  let scheme = call_569354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569354.url(scheme.get, call_569354.host, call_569354.base,
                         call_569354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569354, url, valid)

proc call*(call_569355: Call_VirtualMachineExtensionsList_569346;
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
  var path_569356 = newJObject()
  var query_569357 = newJObject()
  add(path_569356, "resourceGroupName", newJString(resourceGroupName))
  add(query_569357, "$expand", newJString(Expand))
  add(query_569357, "api-version", newJString(apiVersion))
  add(path_569356, "subscriptionId", newJString(subscriptionId))
  add(path_569356, "vmName", newJString(vmName))
  result = call_569355.call(path_569356, query_569357, nil, nil, nil)

var virtualMachineExtensionsList* = Call_VirtualMachineExtensionsList_569346(
    name: "virtualMachineExtensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions",
    validator: validate_VirtualMachineExtensionsList_569347, base: "",
    url: url_VirtualMachineExtensionsList_569348, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsCreateOrUpdate_569371 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionsCreateOrUpdate_569373(protocol: Scheme;
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

proc validate_VirtualMachineExtensionsCreateOrUpdate_569372(path: JsonNode;
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
  var valid_569374 = path.getOrDefault("resourceGroupName")
  valid_569374 = validateParameter(valid_569374, JString, required = true,
                                 default = nil)
  if valid_569374 != nil:
    section.add "resourceGroupName", valid_569374
  var valid_569375 = path.getOrDefault("vmExtensionName")
  valid_569375 = validateParameter(valid_569375, JString, required = true,
                                 default = nil)
  if valid_569375 != nil:
    section.add "vmExtensionName", valid_569375
  var valid_569376 = path.getOrDefault("subscriptionId")
  valid_569376 = validateParameter(valid_569376, JString, required = true,
                                 default = nil)
  if valid_569376 != nil:
    section.add "subscriptionId", valid_569376
  var valid_569377 = path.getOrDefault("vmName")
  valid_569377 = validateParameter(valid_569377, JString, required = true,
                                 default = nil)
  if valid_569377 != nil:
    section.add "vmName", valid_569377
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569378 = query.getOrDefault("api-version")
  valid_569378 = validateParameter(valid_569378, JString, required = true,
                                 default = nil)
  if valid_569378 != nil:
    section.add "api-version", valid_569378
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

proc call*(call_569380: Call_VirtualMachineExtensionsCreateOrUpdate_569371;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update the extension.
  ## 
  let valid = call_569380.validator(path, query, header, formData, body)
  let scheme = call_569380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569380.url(scheme.get, call_569380.host, call_569380.base,
                         call_569380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569380, url, valid)

proc call*(call_569381: Call_VirtualMachineExtensionsCreateOrUpdate_569371;
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
  var path_569382 = newJObject()
  var query_569383 = newJObject()
  var body_569384 = newJObject()
  if extensionParameters != nil:
    body_569384 = extensionParameters
  add(path_569382, "resourceGroupName", newJString(resourceGroupName))
  add(query_569383, "api-version", newJString(apiVersion))
  add(path_569382, "vmExtensionName", newJString(vmExtensionName))
  add(path_569382, "subscriptionId", newJString(subscriptionId))
  add(path_569382, "vmName", newJString(vmName))
  result = call_569381.call(path_569382, query_569383, nil, nil, body_569384)

var virtualMachineExtensionsCreateOrUpdate* = Call_VirtualMachineExtensionsCreateOrUpdate_569371(
    name: "virtualMachineExtensionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsCreateOrUpdate_569372, base: "",
    url: url_VirtualMachineExtensionsCreateOrUpdate_569373,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsGet_569358 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionsGet_569360(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionsGet_569359(path: JsonNode; query: JsonNode;
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
  var valid_569361 = path.getOrDefault("resourceGroupName")
  valid_569361 = validateParameter(valid_569361, JString, required = true,
                                 default = nil)
  if valid_569361 != nil:
    section.add "resourceGroupName", valid_569361
  var valid_569362 = path.getOrDefault("vmExtensionName")
  valid_569362 = validateParameter(valid_569362, JString, required = true,
                                 default = nil)
  if valid_569362 != nil:
    section.add "vmExtensionName", valid_569362
  var valid_569363 = path.getOrDefault("subscriptionId")
  valid_569363 = validateParameter(valid_569363, JString, required = true,
                                 default = nil)
  if valid_569363 != nil:
    section.add "subscriptionId", valid_569363
  var valid_569364 = path.getOrDefault("vmName")
  valid_569364 = validateParameter(valid_569364, JString, required = true,
                                 default = nil)
  if valid_569364 != nil:
    section.add "vmName", valid_569364
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_569365 = query.getOrDefault("$expand")
  valid_569365 = validateParameter(valid_569365, JString, required = false,
                                 default = nil)
  if valid_569365 != nil:
    section.add "$expand", valid_569365
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569366 = query.getOrDefault("api-version")
  valid_569366 = validateParameter(valid_569366, JString, required = true,
                                 default = nil)
  if valid_569366 != nil:
    section.add "api-version", valid_569366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569367: Call_VirtualMachineExtensionsGet_569358; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get the extension.
  ## 
  let valid = call_569367.validator(path, query, header, formData, body)
  let scheme = call_569367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569367.url(scheme.get, call_569367.host, call_569367.base,
                         call_569367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569367, url, valid)

proc call*(call_569368: Call_VirtualMachineExtensionsGet_569358;
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
  var path_569369 = newJObject()
  var query_569370 = newJObject()
  add(path_569369, "resourceGroupName", newJString(resourceGroupName))
  add(query_569370, "$expand", newJString(Expand))
  add(query_569370, "api-version", newJString(apiVersion))
  add(path_569369, "vmExtensionName", newJString(vmExtensionName))
  add(path_569369, "subscriptionId", newJString(subscriptionId))
  add(path_569369, "vmName", newJString(vmName))
  result = call_569368.call(path_569369, query_569370, nil, nil, nil)

var virtualMachineExtensionsGet* = Call_VirtualMachineExtensionsGet_569358(
    name: "virtualMachineExtensionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsGet_569359, base: "",
    url: url_VirtualMachineExtensionsGet_569360, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsUpdate_569397 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionsUpdate_569399(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionsUpdate_569398(path: JsonNode;
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
  var valid_569400 = path.getOrDefault("resourceGroupName")
  valid_569400 = validateParameter(valid_569400, JString, required = true,
                                 default = nil)
  if valid_569400 != nil:
    section.add "resourceGroupName", valid_569400
  var valid_569401 = path.getOrDefault("vmExtensionName")
  valid_569401 = validateParameter(valid_569401, JString, required = true,
                                 default = nil)
  if valid_569401 != nil:
    section.add "vmExtensionName", valid_569401
  var valid_569402 = path.getOrDefault("subscriptionId")
  valid_569402 = validateParameter(valid_569402, JString, required = true,
                                 default = nil)
  if valid_569402 != nil:
    section.add "subscriptionId", valid_569402
  var valid_569403 = path.getOrDefault("vmName")
  valid_569403 = validateParameter(valid_569403, JString, required = true,
                                 default = nil)
  if valid_569403 != nil:
    section.add "vmName", valid_569403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569404 = query.getOrDefault("api-version")
  valid_569404 = validateParameter(valid_569404, JString, required = true,
                                 default = nil)
  if valid_569404 != nil:
    section.add "api-version", valid_569404
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

proc call*(call_569406: Call_VirtualMachineExtensionsUpdate_569397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update the extension.
  ## 
  let valid = call_569406.validator(path, query, header, formData, body)
  let scheme = call_569406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569406.url(scheme.get, call_569406.host, call_569406.base,
                         call_569406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569406, url, valid)

proc call*(call_569407: Call_VirtualMachineExtensionsUpdate_569397;
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
  var path_569408 = newJObject()
  var query_569409 = newJObject()
  var body_569410 = newJObject()
  if extensionParameters != nil:
    body_569410 = extensionParameters
  add(path_569408, "resourceGroupName", newJString(resourceGroupName))
  add(query_569409, "api-version", newJString(apiVersion))
  add(path_569408, "vmExtensionName", newJString(vmExtensionName))
  add(path_569408, "subscriptionId", newJString(subscriptionId))
  add(path_569408, "vmName", newJString(vmName))
  result = call_569407.call(path_569408, query_569409, nil, nil, body_569410)

var virtualMachineExtensionsUpdate* = Call_VirtualMachineExtensionsUpdate_569397(
    name: "virtualMachineExtensionsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsUpdate_569398, base: "",
    url: url_VirtualMachineExtensionsUpdate_569399, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsDelete_569385 = ref object of OpenApiRestCall_567667
proc url_VirtualMachineExtensionsDelete_569387(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionsDelete_569386(path: JsonNode;
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
  var valid_569388 = path.getOrDefault("resourceGroupName")
  valid_569388 = validateParameter(valid_569388, JString, required = true,
                                 default = nil)
  if valid_569388 != nil:
    section.add "resourceGroupName", valid_569388
  var valid_569389 = path.getOrDefault("vmExtensionName")
  valid_569389 = validateParameter(valid_569389, JString, required = true,
                                 default = nil)
  if valid_569389 != nil:
    section.add "vmExtensionName", valid_569389
  var valid_569390 = path.getOrDefault("subscriptionId")
  valid_569390 = validateParameter(valid_569390, JString, required = true,
                                 default = nil)
  if valid_569390 != nil:
    section.add "subscriptionId", valid_569390
  var valid_569391 = path.getOrDefault("vmName")
  valid_569391 = validateParameter(valid_569391, JString, required = true,
                                 default = nil)
  if valid_569391 != nil:
    section.add "vmName", valid_569391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569392 = query.getOrDefault("api-version")
  valid_569392 = validateParameter(valid_569392, JString, required = true,
                                 default = nil)
  if valid_569392 != nil:
    section.add "api-version", valid_569392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569393: Call_VirtualMachineExtensionsDelete_569385; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete the extension.
  ## 
  let valid = call_569393.validator(path, query, header, formData, body)
  let scheme = call_569393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569393.url(scheme.get, call_569393.host, call_569393.base,
                         call_569393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569393, url, valid)

proc call*(call_569394: Call_VirtualMachineExtensionsDelete_569385;
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
  var path_569395 = newJObject()
  var query_569396 = newJObject()
  add(path_569395, "resourceGroupName", newJString(resourceGroupName))
  add(query_569396, "api-version", newJString(apiVersion))
  add(path_569395, "vmExtensionName", newJString(vmExtensionName))
  add(path_569395, "subscriptionId", newJString(subscriptionId))
  add(path_569395, "vmName", newJString(vmName))
  result = call_569394.call(path_569395, query_569396, nil, nil, nil)

var virtualMachineExtensionsDelete* = Call_VirtualMachineExtensionsDelete_569385(
    name: "virtualMachineExtensionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsDelete_569386, base: "",
    url: url_VirtualMachineExtensionsDelete_569387, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGeneralize_569411 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesGeneralize_569413(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesGeneralize_569412(path: JsonNode; query: JsonNode;
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
  var valid_569414 = path.getOrDefault("resourceGroupName")
  valid_569414 = validateParameter(valid_569414, JString, required = true,
                                 default = nil)
  if valid_569414 != nil:
    section.add "resourceGroupName", valid_569414
  var valid_569415 = path.getOrDefault("subscriptionId")
  valid_569415 = validateParameter(valid_569415, JString, required = true,
                                 default = nil)
  if valid_569415 != nil:
    section.add "subscriptionId", valid_569415
  var valid_569416 = path.getOrDefault("vmName")
  valid_569416 = validateParameter(valid_569416, JString, required = true,
                                 default = nil)
  if valid_569416 != nil:
    section.add "vmName", valid_569416
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569417 = query.getOrDefault("api-version")
  valid_569417 = validateParameter(valid_569417, JString, required = true,
                                 default = nil)
  if valid_569417 != nil:
    section.add "api-version", valid_569417
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569418: Call_VirtualMachinesGeneralize_569411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the state of the virtual machine to generalized.
  ## 
  let valid = call_569418.validator(path, query, header, formData, body)
  let scheme = call_569418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569418.url(scheme.get, call_569418.host, call_569418.base,
                         call_569418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569418, url, valid)

proc call*(call_569419: Call_VirtualMachinesGeneralize_569411;
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
  var path_569420 = newJObject()
  var query_569421 = newJObject()
  add(path_569420, "resourceGroupName", newJString(resourceGroupName))
  add(query_569421, "api-version", newJString(apiVersion))
  add(path_569420, "subscriptionId", newJString(subscriptionId))
  add(path_569420, "vmName", newJString(vmName))
  result = call_569419.call(path_569420, query_569421, nil, nil, nil)

var virtualMachinesGeneralize* = Call_VirtualMachinesGeneralize_569411(
    name: "virtualMachinesGeneralize", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/generalize",
    validator: validate_VirtualMachinesGeneralize_569412, base: "",
    url: url_VirtualMachinesGeneralize_569413, schemes: {Scheme.Https})
type
  Call_VirtualMachinesInstanceView_569422 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesInstanceView_569424(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesInstanceView_569423(path: JsonNode; query: JsonNode;
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
  var valid_569425 = path.getOrDefault("resourceGroupName")
  valid_569425 = validateParameter(valid_569425, JString, required = true,
                                 default = nil)
  if valid_569425 != nil:
    section.add "resourceGroupName", valid_569425
  var valid_569426 = path.getOrDefault("subscriptionId")
  valid_569426 = validateParameter(valid_569426, JString, required = true,
                                 default = nil)
  if valid_569426 != nil:
    section.add "subscriptionId", valid_569426
  var valid_569427 = path.getOrDefault("vmName")
  valid_569427 = validateParameter(valid_569427, JString, required = true,
                                 default = nil)
  if valid_569427 != nil:
    section.add "vmName", valid_569427
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569428 = query.getOrDefault("api-version")
  valid_569428 = validateParameter(valid_569428, JString, required = true,
                                 default = nil)
  if valid_569428 != nil:
    section.add "api-version", valid_569428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569429: Call_VirtualMachinesInstanceView_569422; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the run-time state of a virtual machine.
  ## 
  let valid = call_569429.validator(path, query, header, formData, body)
  let scheme = call_569429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569429.url(scheme.get, call_569429.host, call_569429.base,
                         call_569429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569429, url, valid)

proc call*(call_569430: Call_VirtualMachinesInstanceView_569422;
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
  var path_569431 = newJObject()
  var query_569432 = newJObject()
  add(path_569431, "resourceGroupName", newJString(resourceGroupName))
  add(query_569432, "api-version", newJString(apiVersion))
  add(path_569431, "subscriptionId", newJString(subscriptionId))
  add(path_569431, "vmName", newJString(vmName))
  result = call_569430.call(path_569431, query_569432, nil, nil, nil)

var virtualMachinesInstanceView* = Call_VirtualMachinesInstanceView_569422(
    name: "virtualMachinesInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/instanceView",
    validator: validate_VirtualMachinesInstanceView_569423, base: "",
    url: url_VirtualMachinesInstanceView_569424, schemes: {Scheme.Https})
type
  Call_VirtualMachinesPerformMaintenance_569433 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesPerformMaintenance_569435(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesPerformMaintenance_569434(path: JsonNode;
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
  var valid_569436 = path.getOrDefault("resourceGroupName")
  valid_569436 = validateParameter(valid_569436, JString, required = true,
                                 default = nil)
  if valid_569436 != nil:
    section.add "resourceGroupName", valid_569436
  var valid_569437 = path.getOrDefault("subscriptionId")
  valid_569437 = validateParameter(valid_569437, JString, required = true,
                                 default = nil)
  if valid_569437 != nil:
    section.add "subscriptionId", valid_569437
  var valid_569438 = path.getOrDefault("vmName")
  valid_569438 = validateParameter(valid_569438, JString, required = true,
                                 default = nil)
  if valid_569438 != nil:
    section.add "vmName", valid_569438
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569439 = query.getOrDefault("api-version")
  valid_569439 = validateParameter(valid_569439, JString, required = true,
                                 default = nil)
  if valid_569439 != nil:
    section.add "api-version", valid_569439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569440: Call_VirtualMachinesPerformMaintenance_569433;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to perform maintenance on a virtual machine.
  ## 
  let valid = call_569440.validator(path, query, header, formData, body)
  let scheme = call_569440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569440.url(scheme.get, call_569440.host, call_569440.base,
                         call_569440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569440, url, valid)

proc call*(call_569441: Call_VirtualMachinesPerformMaintenance_569433;
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
  var path_569442 = newJObject()
  var query_569443 = newJObject()
  add(path_569442, "resourceGroupName", newJString(resourceGroupName))
  add(query_569443, "api-version", newJString(apiVersion))
  add(path_569442, "subscriptionId", newJString(subscriptionId))
  add(path_569442, "vmName", newJString(vmName))
  result = call_569441.call(path_569442, query_569443, nil, nil, nil)

var virtualMachinesPerformMaintenance* = Call_VirtualMachinesPerformMaintenance_569433(
    name: "virtualMachinesPerformMaintenance", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/performMaintenance",
    validator: validate_VirtualMachinesPerformMaintenance_569434, base: "",
    url: url_VirtualMachinesPerformMaintenance_569435, schemes: {Scheme.Https})
type
  Call_VirtualMachinesPowerOff_569444 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesPowerOff_569446(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesPowerOff_569445(path: JsonNode; query: JsonNode;
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
  var valid_569447 = path.getOrDefault("resourceGroupName")
  valid_569447 = validateParameter(valid_569447, JString, required = true,
                                 default = nil)
  if valid_569447 != nil:
    section.add "resourceGroupName", valid_569447
  var valid_569448 = path.getOrDefault("subscriptionId")
  valid_569448 = validateParameter(valid_569448, JString, required = true,
                                 default = nil)
  if valid_569448 != nil:
    section.add "subscriptionId", valid_569448
  var valid_569449 = path.getOrDefault("vmName")
  valid_569449 = validateParameter(valid_569449, JString, required = true,
                                 default = nil)
  if valid_569449 != nil:
    section.add "vmName", valid_569449
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   skipShutdown: JBool
  ##               : The parameter to request non-graceful VM shutdown. True value for this flag indicates non-graceful shutdown whereas false indicates otherwise. Default value for this flag is false if not specified
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569450 = query.getOrDefault("api-version")
  valid_569450 = validateParameter(valid_569450, JString, required = true,
                                 default = nil)
  if valid_569450 != nil:
    section.add "api-version", valid_569450
  var valid_569451 = query.getOrDefault("skipShutdown")
  valid_569451 = validateParameter(valid_569451, JBool, required = false,
                                 default = newJBool(false))
  if valid_569451 != nil:
    section.add "skipShutdown", valid_569451
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569452: Call_VirtualMachinesPowerOff_569444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to power off (stop) a virtual machine. The virtual machine can be restarted with the same provisioned resources. You are still charged for this virtual machine.
  ## 
  let valid = call_569452.validator(path, query, header, formData, body)
  let scheme = call_569452.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569452.url(scheme.get, call_569452.host, call_569452.base,
                         call_569452.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569452, url, valid)

proc call*(call_569453: Call_VirtualMachinesPowerOff_569444;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string; skipShutdown: bool = false): Recallable =
  ## virtualMachinesPowerOff
  ## The operation to power off (stop) a virtual machine. The virtual machine can be restarted with the same provisioned resources. You are still charged for this virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   skipShutdown: bool
  ##               : The parameter to request non-graceful VM shutdown. True value for this flag indicates non-graceful shutdown whereas false indicates otherwise. Default value for this flag is false if not specified
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_569454 = newJObject()
  var query_569455 = newJObject()
  add(path_569454, "resourceGroupName", newJString(resourceGroupName))
  add(query_569455, "api-version", newJString(apiVersion))
  add(query_569455, "skipShutdown", newJBool(skipShutdown))
  add(path_569454, "subscriptionId", newJString(subscriptionId))
  add(path_569454, "vmName", newJString(vmName))
  result = call_569453.call(path_569454, query_569455, nil, nil, nil)

var virtualMachinesPowerOff* = Call_VirtualMachinesPowerOff_569444(
    name: "virtualMachinesPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/powerOff",
    validator: validate_VirtualMachinesPowerOff_569445, base: "",
    url: url_VirtualMachinesPowerOff_569446, schemes: {Scheme.Https})
type
  Call_VirtualMachinesRedeploy_569456 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesRedeploy_569458(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesRedeploy_569457(path: JsonNode; query: JsonNode;
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
  var valid_569459 = path.getOrDefault("resourceGroupName")
  valid_569459 = validateParameter(valid_569459, JString, required = true,
                                 default = nil)
  if valid_569459 != nil:
    section.add "resourceGroupName", valid_569459
  var valid_569460 = path.getOrDefault("subscriptionId")
  valid_569460 = validateParameter(valid_569460, JString, required = true,
                                 default = nil)
  if valid_569460 != nil:
    section.add "subscriptionId", valid_569460
  var valid_569461 = path.getOrDefault("vmName")
  valid_569461 = validateParameter(valid_569461, JString, required = true,
                                 default = nil)
  if valid_569461 != nil:
    section.add "vmName", valid_569461
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569462 = query.getOrDefault("api-version")
  valid_569462 = validateParameter(valid_569462, JString, required = true,
                                 default = nil)
  if valid_569462 != nil:
    section.add "api-version", valid_569462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569463: Call_VirtualMachinesRedeploy_569456; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shuts down the virtual machine, moves it to a new node, and powers it back on.
  ## 
  let valid = call_569463.validator(path, query, header, formData, body)
  let scheme = call_569463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569463.url(scheme.get, call_569463.host, call_569463.base,
                         call_569463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569463, url, valid)

proc call*(call_569464: Call_VirtualMachinesRedeploy_569456;
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
  var path_569465 = newJObject()
  var query_569466 = newJObject()
  add(path_569465, "resourceGroupName", newJString(resourceGroupName))
  add(query_569466, "api-version", newJString(apiVersion))
  add(path_569465, "subscriptionId", newJString(subscriptionId))
  add(path_569465, "vmName", newJString(vmName))
  result = call_569464.call(path_569465, query_569466, nil, nil, nil)

var virtualMachinesRedeploy* = Call_VirtualMachinesRedeploy_569456(
    name: "virtualMachinesRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/redeploy",
    validator: validate_VirtualMachinesRedeploy_569457, base: "",
    url: url_VirtualMachinesRedeploy_569458, schemes: {Scheme.Https})
type
  Call_VirtualMachinesReimage_569467 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesReimage_569469(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesReimage_569468(path: JsonNode; query: JsonNode;
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
  var valid_569470 = path.getOrDefault("resourceGroupName")
  valid_569470 = validateParameter(valid_569470, JString, required = true,
                                 default = nil)
  if valid_569470 != nil:
    section.add "resourceGroupName", valid_569470
  var valid_569471 = path.getOrDefault("subscriptionId")
  valid_569471 = validateParameter(valid_569471, JString, required = true,
                                 default = nil)
  if valid_569471 != nil:
    section.add "subscriptionId", valid_569471
  var valid_569472 = path.getOrDefault("vmName")
  valid_569472 = validateParameter(valid_569472, JString, required = true,
                                 default = nil)
  if valid_569472 != nil:
    section.add "vmName", valid_569472
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569473 = query.getOrDefault("api-version")
  valid_569473 = validateParameter(valid_569473, JString, required = true,
                                 default = nil)
  if valid_569473 != nil:
    section.add "api-version", valid_569473
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

proc call*(call_569475: Call_VirtualMachinesReimage_569467; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reimages the virtual machine which has an ephemeral OS disk back to its initial state.
  ## 
  let valid = call_569475.validator(path, query, header, formData, body)
  let scheme = call_569475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569475.url(scheme.get, call_569475.host, call_569475.base,
                         call_569475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569475, url, valid)

proc call*(call_569476: Call_VirtualMachinesReimage_569467;
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
  var path_569477 = newJObject()
  var query_569478 = newJObject()
  var body_569479 = newJObject()
  add(path_569477, "resourceGroupName", newJString(resourceGroupName))
  add(query_569478, "api-version", newJString(apiVersion))
  add(path_569477, "subscriptionId", newJString(subscriptionId))
  add(path_569477, "vmName", newJString(vmName))
  if parameters != nil:
    body_569479 = parameters
  result = call_569476.call(path_569477, query_569478, nil, nil, body_569479)

var virtualMachinesReimage* = Call_VirtualMachinesReimage_569467(
    name: "virtualMachinesReimage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/reimage",
    validator: validate_VirtualMachinesReimage_569468, base: "",
    url: url_VirtualMachinesReimage_569469, schemes: {Scheme.Https})
type
  Call_VirtualMachinesRestart_569480 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesRestart_569482(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesRestart_569481(path: JsonNode; query: JsonNode;
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
  var valid_569483 = path.getOrDefault("resourceGroupName")
  valid_569483 = validateParameter(valid_569483, JString, required = true,
                                 default = nil)
  if valid_569483 != nil:
    section.add "resourceGroupName", valid_569483
  var valid_569484 = path.getOrDefault("subscriptionId")
  valid_569484 = validateParameter(valid_569484, JString, required = true,
                                 default = nil)
  if valid_569484 != nil:
    section.add "subscriptionId", valid_569484
  var valid_569485 = path.getOrDefault("vmName")
  valid_569485 = validateParameter(valid_569485, JString, required = true,
                                 default = nil)
  if valid_569485 != nil:
    section.add "vmName", valid_569485
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569486 = query.getOrDefault("api-version")
  valid_569486 = validateParameter(valid_569486, JString, required = true,
                                 default = nil)
  if valid_569486 != nil:
    section.add "api-version", valid_569486
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569487: Call_VirtualMachinesRestart_569480; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to restart a virtual machine.
  ## 
  let valid = call_569487.validator(path, query, header, formData, body)
  let scheme = call_569487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569487.url(scheme.get, call_569487.host, call_569487.base,
                         call_569487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569487, url, valid)

proc call*(call_569488: Call_VirtualMachinesRestart_569480;
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
  var path_569489 = newJObject()
  var query_569490 = newJObject()
  add(path_569489, "resourceGroupName", newJString(resourceGroupName))
  add(query_569490, "api-version", newJString(apiVersion))
  add(path_569489, "subscriptionId", newJString(subscriptionId))
  add(path_569489, "vmName", newJString(vmName))
  result = call_569488.call(path_569489, query_569490, nil, nil, nil)

var virtualMachinesRestart* = Call_VirtualMachinesRestart_569480(
    name: "virtualMachinesRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/restart",
    validator: validate_VirtualMachinesRestart_569481, base: "",
    url: url_VirtualMachinesRestart_569482, schemes: {Scheme.Https})
type
  Call_VirtualMachinesStart_569491 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesStart_569493(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesStart_569492(path: JsonNode; query: JsonNode;
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
  var valid_569494 = path.getOrDefault("resourceGroupName")
  valid_569494 = validateParameter(valid_569494, JString, required = true,
                                 default = nil)
  if valid_569494 != nil:
    section.add "resourceGroupName", valid_569494
  var valid_569495 = path.getOrDefault("subscriptionId")
  valid_569495 = validateParameter(valid_569495, JString, required = true,
                                 default = nil)
  if valid_569495 != nil:
    section.add "subscriptionId", valid_569495
  var valid_569496 = path.getOrDefault("vmName")
  valid_569496 = validateParameter(valid_569496, JString, required = true,
                                 default = nil)
  if valid_569496 != nil:
    section.add "vmName", valid_569496
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569497 = query.getOrDefault("api-version")
  valid_569497 = validateParameter(valid_569497, JString, required = true,
                                 default = nil)
  if valid_569497 != nil:
    section.add "api-version", valid_569497
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569498: Call_VirtualMachinesStart_569491; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to start a virtual machine.
  ## 
  let valid = call_569498.validator(path, query, header, formData, body)
  let scheme = call_569498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569498.url(scheme.get, call_569498.host, call_569498.base,
                         call_569498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569498, url, valid)

proc call*(call_569499: Call_VirtualMachinesStart_569491;
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
  var path_569500 = newJObject()
  var query_569501 = newJObject()
  add(path_569500, "resourceGroupName", newJString(resourceGroupName))
  add(query_569501, "api-version", newJString(apiVersion))
  add(path_569500, "subscriptionId", newJString(subscriptionId))
  add(path_569500, "vmName", newJString(vmName))
  result = call_569499.call(path_569500, query_569501, nil, nil, nil)

var virtualMachinesStart* = Call_VirtualMachinesStart_569491(
    name: "virtualMachinesStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/start",
    validator: validate_VirtualMachinesStart_569492, base: "",
    url: url_VirtualMachinesStart_569493, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListAvailableSizes_569502 = ref object of OpenApiRestCall_567667
proc url_VirtualMachinesListAvailableSizes_569504(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesListAvailableSizes_569503(path: JsonNode;
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
  var valid_569505 = path.getOrDefault("resourceGroupName")
  valid_569505 = validateParameter(valid_569505, JString, required = true,
                                 default = nil)
  if valid_569505 != nil:
    section.add "resourceGroupName", valid_569505
  var valid_569506 = path.getOrDefault("subscriptionId")
  valid_569506 = validateParameter(valid_569506, JString, required = true,
                                 default = nil)
  if valid_569506 != nil:
    section.add "subscriptionId", valid_569506
  var valid_569507 = path.getOrDefault("vmName")
  valid_569507 = validateParameter(valid_569507, JString, required = true,
                                 default = nil)
  if valid_569507 != nil:
    section.add "vmName", valid_569507
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569508 = query.getOrDefault("api-version")
  valid_569508 = validateParameter(valid_569508, JString, required = true,
                                 default = nil)
  if valid_569508 != nil:
    section.add "api-version", valid_569508
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569509: Call_VirtualMachinesListAvailableSizes_569502;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available virtual machine sizes to which the specified virtual machine can be resized.
  ## 
  let valid = call_569509.validator(path, query, header, formData, body)
  let scheme = call_569509.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569509.url(scheme.get, call_569509.host, call_569509.base,
                         call_569509.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569509, url, valid)

proc call*(call_569510: Call_VirtualMachinesListAvailableSizes_569502;
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
  var path_569511 = newJObject()
  var query_569512 = newJObject()
  add(path_569511, "resourceGroupName", newJString(resourceGroupName))
  add(query_569512, "api-version", newJString(apiVersion))
  add(path_569511, "subscriptionId", newJString(subscriptionId))
  add(path_569511, "vmName", newJString(vmName))
  result = call_569510.call(path_569511, query_569512, nil, nil, nil)

var virtualMachinesListAvailableSizes* = Call_VirtualMachinesListAvailableSizes_569502(
    name: "virtualMachinesListAvailableSizes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/vmSizes",
    validator: validate_VirtualMachinesListAvailableSizes_569503, base: "",
    url: url_VirtualMachinesListAvailableSizes_569504, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
