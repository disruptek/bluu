
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ComputeManagementClient
## version: 2018-06-01
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

  OpenApiRestCall_593438 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593438](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593438): Option[Scheme] {.used.} =
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
  macServiceName = "compute"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593660 = ref object of OpenApiRestCall_593438
proc url_OperationsList_593662(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593661(path: JsonNode; query: JsonNode;
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
  var valid_593821 = query.getOrDefault("api-version")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "api-version", valid_593821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593844: Call_OperationsList_593660; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of compute operations.
  ## 
  let valid = call_593844.validator(path, query, header, formData, body)
  let scheme = call_593844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593844.url(scheme.get, call_593844.host, call_593844.base,
                         call_593844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593844, url, valid)

proc call*(call_593915: Call_OperationsList_593660; apiVersion: string): Recallable =
  ## operationsList
  ## Gets a list of compute operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_593916 = newJObject()
  add(query_593916, "api-version", newJString(apiVersion))
  result = call_593915.call(nil, query_593916, nil, nil, nil)

var operationsList* = Call_OperationsList_593660(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Compute/operations",
    validator: validate_OperationsList_593661, base: "", url: url_OperationsList_593662,
    schemes: {Scheme.Https})
type
  Call_AvailabilitySetsListBySubscription_593956 = ref object of OpenApiRestCall_593438
proc url_AvailabilitySetsListBySubscription_593958(protocol: Scheme; host: string;
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

proc validate_AvailabilitySetsListBySubscription_593957(path: JsonNode;
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
  var valid_593974 = path.getOrDefault("subscriptionId")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "subscriptionId", valid_593974
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : The expand expression to apply to the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593975 = query.getOrDefault("api-version")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "api-version", valid_593975
  var valid_593976 = query.getOrDefault("$expand")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "$expand", valid_593976
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593977: Call_AvailabilitySetsListBySubscription_593956;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all availability sets in a subscription.
  ## 
  let valid = call_593977.validator(path, query, header, formData, body)
  let scheme = call_593977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593977.url(scheme.get, call_593977.host, call_593977.base,
                         call_593977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593977, url, valid)

proc call*(call_593978: Call_AvailabilitySetsListBySubscription_593956;
          apiVersion: string; subscriptionId: string; Expand: string = ""): Recallable =
  ## availabilitySetsListBySubscription
  ## Lists all availability sets in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : The expand expression to apply to the operation.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593979 = newJObject()
  var query_593980 = newJObject()
  add(query_593980, "api-version", newJString(apiVersion))
  add(query_593980, "$expand", newJString(Expand))
  add(path_593979, "subscriptionId", newJString(subscriptionId))
  result = call_593978.call(path_593979, query_593980, nil, nil, nil)

var availabilitySetsListBySubscription* = Call_AvailabilitySetsListBySubscription_593956(
    name: "availabilitySetsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/availabilitySets",
    validator: validate_AvailabilitySetsListBySubscription_593957, base: "",
    url: url_AvailabilitySetsListBySubscription_593958, schemes: {Scheme.Https})
type
  Call_ImagesList_593981 = ref object of OpenApiRestCall_593438
proc url_ImagesList_593983(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ImagesList_593982(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_593984 = path.getOrDefault("subscriptionId")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "subscriptionId", valid_593984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593985 = query.getOrDefault("api-version")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "api-version", valid_593985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593986: Call_ImagesList_593981; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of Images in the subscription. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.
  ## 
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_ImagesList_593981; apiVersion: string;
          subscriptionId: string): Recallable =
  ## imagesList
  ## Gets the list of Images in the subscription. Use nextLink property in the response to get the next page of Images. Do this till nextLink is null to fetch all the Images.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593988 = newJObject()
  var query_593989 = newJObject()
  add(query_593989, "api-version", newJString(apiVersion))
  add(path_593988, "subscriptionId", newJString(subscriptionId))
  result = call_593987.call(path_593988, query_593989, nil, nil, nil)

var imagesList* = Call_ImagesList_593981(name: "imagesList",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/images",
                                      validator: validate_ImagesList_593982,
                                      base: "", url: url_ImagesList_593983,
                                      schemes: {Scheme.Https})
type
  Call_LogAnalyticsExportRequestRateByInterval_593990 = ref object of OpenApiRestCall_593438
proc url_LogAnalyticsExportRequestRateByInterval_593992(protocol: Scheme;
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

proc validate_LogAnalyticsExportRequestRateByInterval_593991(path: JsonNode;
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
  var valid_594010 = path.getOrDefault("subscriptionId")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "subscriptionId", valid_594010
  var valid_594011 = path.getOrDefault("location")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "location", valid_594011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594012 = query.getOrDefault("api-version")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "api-version", valid_594012
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

proc call*(call_594014: Call_LogAnalyticsExportRequestRateByInterval_593990;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Export logs that show Api requests made by this subscription in the given time window to show throttling activities.
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_LogAnalyticsExportRequestRateByInterval_593990;
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
  var path_594016 = newJObject()
  var query_594017 = newJObject()
  var body_594018 = newJObject()
  add(query_594017, "api-version", newJString(apiVersion))
  add(path_594016, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594018 = parameters
  add(path_594016, "location", newJString(location))
  result = call_594015.call(path_594016, query_594017, nil, nil, body_594018)

var logAnalyticsExportRequestRateByInterval* = Call_LogAnalyticsExportRequestRateByInterval_593990(
    name: "logAnalyticsExportRequestRateByInterval", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/logAnalytics/apiAccess/getRequestRateByInterval",
    validator: validate_LogAnalyticsExportRequestRateByInterval_593991, base: "",
    url: url_LogAnalyticsExportRequestRateByInterval_593992,
    schemes: {Scheme.Https})
type
  Call_LogAnalyticsExportThrottledRequests_594019 = ref object of OpenApiRestCall_593438
proc url_LogAnalyticsExportThrottledRequests_594021(protocol: Scheme; host: string;
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

proc validate_LogAnalyticsExportThrottledRequests_594020(path: JsonNode;
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
  var valid_594022 = path.getOrDefault("subscriptionId")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "subscriptionId", valid_594022
  var valid_594023 = path.getOrDefault("location")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "location", valid_594023
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594024 = query.getOrDefault("api-version")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "api-version", valid_594024
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

proc call*(call_594026: Call_LogAnalyticsExportThrottledRequests_594019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Export logs that show total throttled Api requests for this subscription in the given time window.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_LogAnalyticsExportThrottledRequests_594019;
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
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  var body_594030 = newJObject()
  add(query_594029, "api-version", newJString(apiVersion))
  add(path_594028, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594030 = parameters
  add(path_594028, "location", newJString(location))
  result = call_594027.call(path_594028, query_594029, nil, nil, body_594030)

var logAnalyticsExportThrottledRequests* = Call_LogAnalyticsExportThrottledRequests_594019(
    name: "logAnalyticsExportThrottledRequests", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/logAnalytics/apiAccess/getThrottledRequests",
    validator: validate_LogAnalyticsExportThrottledRequests_594020, base: "",
    url: url_LogAnalyticsExportThrottledRequests_594021, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesListPublishers_594031 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineImagesListPublishers_594033(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImagesListPublishers_594032(path: JsonNode;
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
  var valid_594034 = path.getOrDefault("subscriptionId")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "subscriptionId", valid_594034
  var valid_594035 = path.getOrDefault("location")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "location", valid_594035
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594036 = query.getOrDefault("api-version")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "api-version", valid_594036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594037: Call_VirtualMachineImagesListPublishers_594031;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual machine image publishers for the specified Azure location.
  ## 
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_VirtualMachineImagesListPublishers_594031;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## virtualMachineImagesListPublishers
  ## Gets a list of virtual machine image publishers for the specified Azure location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The name of a supported Azure region.
  var path_594039 = newJObject()
  var query_594040 = newJObject()
  add(query_594040, "api-version", newJString(apiVersion))
  add(path_594039, "subscriptionId", newJString(subscriptionId))
  add(path_594039, "location", newJString(location))
  result = call_594038.call(path_594039, query_594040, nil, nil, nil)

var virtualMachineImagesListPublishers* = Call_VirtualMachineImagesListPublishers_594031(
    name: "virtualMachineImagesListPublishers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers",
    validator: validate_VirtualMachineImagesListPublishers_594032, base: "",
    url: url_VirtualMachineImagesListPublishers_594033, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionImagesListTypes_594041 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineExtensionImagesListTypes_594043(protocol: Scheme;
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

proc validate_VirtualMachineExtensionImagesListTypes_594042(path: JsonNode;
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
  var valid_594044 = path.getOrDefault("subscriptionId")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "subscriptionId", valid_594044
  var valid_594045 = path.getOrDefault("publisherName")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "publisherName", valid_594045
  var valid_594046 = path.getOrDefault("location")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "location", valid_594046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594047 = query.getOrDefault("api-version")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "api-version", valid_594047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594048: Call_VirtualMachineExtensionImagesListTypes_594041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual machine extension image types.
  ## 
  let valid = call_594048.validator(path, query, header, formData, body)
  let scheme = call_594048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594048.url(scheme.get, call_594048.host, call_594048.base,
                         call_594048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594048, url, valid)

proc call*(call_594049: Call_VirtualMachineExtensionImagesListTypes_594041;
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
  var path_594050 = newJObject()
  var query_594051 = newJObject()
  add(query_594051, "api-version", newJString(apiVersion))
  add(path_594050, "subscriptionId", newJString(subscriptionId))
  add(path_594050, "publisherName", newJString(publisherName))
  add(path_594050, "location", newJString(location))
  result = call_594049.call(path_594050, query_594051, nil, nil, nil)

var virtualMachineExtensionImagesListTypes* = Call_VirtualMachineExtensionImagesListTypes_594041(
    name: "virtualMachineExtensionImagesListTypes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types",
    validator: validate_VirtualMachineExtensionImagesListTypes_594042, base: "",
    url: url_VirtualMachineExtensionImagesListTypes_594043,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionImagesListVersions_594052 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineExtensionImagesListVersions_594054(protocol: Scheme;
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

proc validate_VirtualMachineExtensionImagesListVersions_594053(path: JsonNode;
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
  var valid_594055 = path.getOrDefault("type")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "type", valid_594055
  var valid_594056 = path.getOrDefault("subscriptionId")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "subscriptionId", valid_594056
  var valid_594057 = path.getOrDefault("publisherName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "publisherName", valid_594057
  var valid_594058 = path.getOrDefault("location")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "location", valid_594058
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_594059 = query.getOrDefault("$orderby")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "$orderby", valid_594059
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594060 = query.getOrDefault("api-version")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "api-version", valid_594060
  var valid_594061 = query.getOrDefault("$top")
  valid_594061 = validateParameter(valid_594061, JInt, required = false, default = nil)
  if valid_594061 != nil:
    section.add "$top", valid_594061
  var valid_594062 = query.getOrDefault("$filter")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "$filter", valid_594062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594063: Call_VirtualMachineExtensionImagesListVersions_594052;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of virtual machine extension image versions.
  ## 
  let valid = call_594063.validator(path, query, header, formData, body)
  let scheme = call_594063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594063.url(scheme.get, call_594063.host, call_594063.base,
                         call_594063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594063, url, valid)

proc call*(call_594064: Call_VirtualMachineExtensionImagesListVersions_594052;
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
  var path_594065 = newJObject()
  var query_594066 = newJObject()
  add(path_594065, "type", newJString(`type`))
  add(query_594066, "$orderby", newJString(Orderby))
  add(query_594066, "api-version", newJString(apiVersion))
  add(path_594065, "subscriptionId", newJString(subscriptionId))
  add(query_594066, "$top", newJInt(Top))
  add(path_594065, "publisherName", newJString(publisherName))
  add(path_594065, "location", newJString(location))
  add(query_594066, "$filter", newJString(Filter))
  result = call_594064.call(path_594065, query_594066, nil, nil, nil)

var virtualMachineExtensionImagesListVersions* = Call_VirtualMachineExtensionImagesListVersions_594052(
    name: "virtualMachineExtensionImagesListVersions", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types/{type}/versions",
    validator: validate_VirtualMachineExtensionImagesListVersions_594053,
    base: "", url: url_VirtualMachineExtensionImagesListVersions_594054,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionImagesGet_594067 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineExtensionImagesGet_594069(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionImagesGet_594068(path: JsonNode;
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
  var valid_594070 = path.getOrDefault("type")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "type", valid_594070
  var valid_594071 = path.getOrDefault("version")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "version", valid_594071
  var valid_594072 = path.getOrDefault("subscriptionId")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "subscriptionId", valid_594072
  var valid_594073 = path.getOrDefault("publisherName")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "publisherName", valid_594073
  var valid_594074 = path.getOrDefault("location")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "location", valid_594074
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594075 = query.getOrDefault("api-version")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "api-version", valid_594075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594076: Call_VirtualMachineExtensionImagesGet_594067;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a virtual machine extension image.
  ## 
  let valid = call_594076.validator(path, query, header, formData, body)
  let scheme = call_594076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594076.url(scheme.get, call_594076.host, call_594076.base,
                         call_594076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594076, url, valid)

proc call*(call_594077: Call_VirtualMachineExtensionImagesGet_594067;
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
  var path_594078 = newJObject()
  var query_594079 = newJObject()
  add(path_594078, "type", newJString(`type`))
  add(query_594079, "api-version", newJString(apiVersion))
  add(path_594078, "version", newJString(version))
  add(path_594078, "subscriptionId", newJString(subscriptionId))
  add(path_594078, "publisherName", newJString(publisherName))
  add(path_594078, "location", newJString(location))
  result = call_594077.call(path_594078, query_594079, nil, nil, nil)

var virtualMachineExtensionImagesGet* = Call_VirtualMachineExtensionImagesGet_594067(
    name: "virtualMachineExtensionImagesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmextension/types/{type}/versions/{version}",
    validator: validate_VirtualMachineExtensionImagesGet_594068, base: "",
    url: url_VirtualMachineExtensionImagesGet_594069, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesListOffers_594080 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineImagesListOffers_594082(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImagesListOffers_594081(path: JsonNode;
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
  var valid_594083 = path.getOrDefault("subscriptionId")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "subscriptionId", valid_594083
  var valid_594084 = path.getOrDefault("publisherName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "publisherName", valid_594084
  var valid_594085 = path.getOrDefault("location")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "location", valid_594085
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594086 = query.getOrDefault("api-version")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "api-version", valid_594086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594087: Call_VirtualMachineImagesListOffers_594080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of virtual machine image offers for the specified location and publisher.
  ## 
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_VirtualMachineImagesListOffers_594080;
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
  var path_594089 = newJObject()
  var query_594090 = newJObject()
  add(query_594090, "api-version", newJString(apiVersion))
  add(path_594089, "subscriptionId", newJString(subscriptionId))
  add(path_594089, "publisherName", newJString(publisherName))
  add(path_594089, "location", newJString(location))
  result = call_594088.call(path_594089, query_594090, nil, nil, nil)

var virtualMachineImagesListOffers* = Call_VirtualMachineImagesListOffers_594080(
    name: "virtualMachineImagesListOffers", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers",
    validator: validate_VirtualMachineImagesListOffers_594081, base: "",
    url: url_VirtualMachineImagesListOffers_594082, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesListSkus_594091 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineImagesListSkus_594093(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImagesListSkus_594092(path: JsonNode; query: JsonNode;
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
  var valid_594094 = path.getOrDefault("subscriptionId")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "subscriptionId", valid_594094
  var valid_594095 = path.getOrDefault("publisherName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "publisherName", valid_594095
  var valid_594096 = path.getOrDefault("offer")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "offer", valid_594096
  var valid_594097 = path.getOrDefault("location")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "location", valid_594097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594098 = query.getOrDefault("api-version")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "api-version", valid_594098
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594099: Call_VirtualMachineImagesListSkus_594091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of virtual machine image SKUs for the specified location, publisher, and offer.
  ## 
  let valid = call_594099.validator(path, query, header, formData, body)
  let scheme = call_594099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594099.url(scheme.get, call_594099.host, call_594099.base,
                         call_594099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594099, url, valid)

proc call*(call_594100: Call_VirtualMachineImagesListSkus_594091;
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
  var path_594101 = newJObject()
  var query_594102 = newJObject()
  add(query_594102, "api-version", newJString(apiVersion))
  add(path_594101, "subscriptionId", newJString(subscriptionId))
  add(path_594101, "publisherName", newJString(publisherName))
  add(path_594101, "offer", newJString(offer))
  add(path_594101, "location", newJString(location))
  result = call_594100.call(path_594101, query_594102, nil, nil, nil)

var virtualMachineImagesListSkus* = Call_VirtualMachineImagesListSkus_594091(
    name: "virtualMachineImagesListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus",
    validator: validate_VirtualMachineImagesListSkus_594092, base: "",
    url: url_VirtualMachineImagesListSkus_594093, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesList_594103 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineImagesList_594105(protocol: Scheme; host: string;
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

proc validate_VirtualMachineImagesList_594104(path: JsonNode; query: JsonNode;
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
  var valid_594106 = path.getOrDefault("skus")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "skus", valid_594106
  var valid_594107 = path.getOrDefault("subscriptionId")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "subscriptionId", valid_594107
  var valid_594108 = path.getOrDefault("publisherName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "publisherName", valid_594108
  var valid_594109 = path.getOrDefault("offer")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "offer", valid_594109
  var valid_594110 = path.getOrDefault("location")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "location", valid_594110
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##   $filter: JString
  ##          : The filter to apply on the operation.
  section = newJObject()
  var valid_594111 = query.getOrDefault("$orderby")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "$orderby", valid_594111
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594112 = query.getOrDefault("api-version")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "api-version", valid_594112
  var valid_594113 = query.getOrDefault("$top")
  valid_594113 = validateParameter(valid_594113, JInt, required = false, default = nil)
  if valid_594113 != nil:
    section.add "$top", valid_594113
  var valid_594114 = query.getOrDefault("$filter")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "$filter", valid_594114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594115: Call_VirtualMachineImagesList_594103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all virtual machine image versions for the specified location, publisher, offer, and SKU.
  ## 
  let valid = call_594115.validator(path, query, header, formData, body)
  let scheme = call_594115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594115.url(scheme.get, call_594115.host, call_594115.base,
                         call_594115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594115, url, valid)

proc call*(call_594116: Call_VirtualMachineImagesList_594103; apiVersion: string;
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
  var path_594117 = newJObject()
  var query_594118 = newJObject()
  add(query_594118, "$orderby", newJString(Orderby))
  add(query_594118, "api-version", newJString(apiVersion))
  add(path_594117, "skus", newJString(skus))
  add(path_594117, "subscriptionId", newJString(subscriptionId))
  add(query_594118, "$top", newJInt(Top))
  add(path_594117, "publisherName", newJString(publisherName))
  add(path_594117, "offer", newJString(offer))
  add(path_594117, "location", newJString(location))
  add(query_594118, "$filter", newJString(Filter))
  result = call_594116.call(path_594117, query_594118, nil, nil, nil)

var virtualMachineImagesList* = Call_VirtualMachineImagesList_594103(
    name: "virtualMachineImagesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions",
    validator: validate_VirtualMachineImagesList_594104, base: "",
    url: url_VirtualMachineImagesList_594105, schemes: {Scheme.Https})
type
  Call_VirtualMachineImagesGet_594119 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineImagesGet_594121(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineImagesGet_594120(path: JsonNode; query: JsonNode;
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
  var valid_594122 = path.getOrDefault("skus")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "skus", valid_594122
  var valid_594123 = path.getOrDefault("version")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "version", valid_594123
  var valid_594124 = path.getOrDefault("subscriptionId")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "subscriptionId", valid_594124
  var valid_594125 = path.getOrDefault("publisherName")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "publisherName", valid_594125
  var valid_594126 = path.getOrDefault("offer")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "offer", valid_594126
  var valid_594127 = path.getOrDefault("location")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "location", valid_594127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594128 = query.getOrDefault("api-version")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "api-version", valid_594128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594129: Call_VirtualMachineImagesGet_594119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a virtual machine image.
  ## 
  let valid = call_594129.validator(path, query, header, formData, body)
  let scheme = call_594129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594129.url(scheme.get, call_594129.host, call_594129.base,
                         call_594129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594129, url, valid)

proc call*(call_594130: Call_VirtualMachineImagesGet_594119; apiVersion: string;
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
  var path_594131 = newJObject()
  var query_594132 = newJObject()
  add(query_594132, "api-version", newJString(apiVersion))
  add(path_594131, "skus", newJString(skus))
  add(path_594131, "version", newJString(version))
  add(path_594131, "subscriptionId", newJString(subscriptionId))
  add(path_594131, "publisherName", newJString(publisherName))
  add(path_594131, "offer", newJString(offer))
  add(path_594131, "location", newJString(location))
  result = call_594130.call(path_594131, query_594132, nil, nil, nil)

var virtualMachineImagesGet* = Call_VirtualMachineImagesGet_594119(
    name: "virtualMachineImagesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/publishers/{publisherName}/artifacttypes/vmimage/offers/{offer}/skus/{skus}/versions/{version}",
    validator: validate_VirtualMachineImagesGet_594120, base: "",
    url: url_VirtualMachineImagesGet_594121, schemes: {Scheme.Https})
type
  Call_UsageList_594133 = ref object of OpenApiRestCall_593438
proc url_UsageList_594135(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UsageList_594134(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594136 = path.getOrDefault("subscriptionId")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "subscriptionId", valid_594136
  var valid_594137 = path.getOrDefault("location")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "location", valid_594137
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594138 = query.getOrDefault("api-version")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "api-version", valid_594138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594139: Call_UsageList_594133; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets, for the specified location, the current compute resource usage information as well as the limits for compute resources under the subscription.
  ## 
  let valid = call_594139.validator(path, query, header, formData, body)
  let scheme = call_594139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594139.url(scheme.get, call_594139.host, call_594139.base,
                         call_594139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594139, url, valid)

proc call*(call_594140: Call_UsageList_594133; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## usageList
  ## Gets, for the specified location, the current compute resource usage information as well as the limits for compute resources under the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location for which resource usage is queried.
  var path_594141 = newJObject()
  var query_594142 = newJObject()
  add(query_594142, "api-version", newJString(apiVersion))
  add(path_594141, "subscriptionId", newJString(subscriptionId))
  add(path_594141, "location", newJString(location))
  result = call_594140.call(path_594141, query_594142, nil, nil, nil)

var usageList* = Call_UsageList_594133(name: "usageList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/usages",
                                    validator: validate_UsageList_594134,
                                    base: "", url: url_UsageList_594135,
                                    schemes: {Scheme.Https})
type
  Call_VirtualMachinesListByLocation_594143 = ref object of OpenApiRestCall_593438
proc url_VirtualMachinesListByLocation_594145(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesListByLocation_594144(path: JsonNode; query: JsonNode;
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
  var valid_594146 = path.getOrDefault("subscriptionId")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "subscriptionId", valid_594146
  var valid_594147 = path.getOrDefault("location")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "location", valid_594147
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594148 = query.getOrDefault("api-version")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "api-version", valid_594148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594149: Call_VirtualMachinesListByLocation_594143; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the virtual machines under the specified subscription for the specified location.
  ## 
  let valid = call_594149.validator(path, query, header, formData, body)
  let scheme = call_594149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594149.url(scheme.get, call_594149.host, call_594149.base,
                         call_594149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594149, url, valid)

proc call*(call_594150: Call_VirtualMachinesListByLocation_594143;
          apiVersion: string; subscriptionId: string; location: string): Recallable =
  ## virtualMachinesListByLocation
  ## Gets all the virtual machines under the specified subscription for the specified location.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location for which virtual machines under the subscription are queried.
  var path_594151 = newJObject()
  var query_594152 = newJObject()
  add(query_594152, "api-version", newJString(apiVersion))
  add(path_594151, "subscriptionId", newJString(subscriptionId))
  add(path_594151, "location", newJString(location))
  result = call_594150.call(path_594151, query_594152, nil, nil, nil)

var virtualMachinesListByLocation* = Call_VirtualMachinesListByLocation_594143(
    name: "virtualMachinesListByLocation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/virtualMachines",
    validator: validate_VirtualMachinesListByLocation_594144, base: "",
    url: url_VirtualMachinesListByLocation_594145, schemes: {Scheme.Https})
type
  Call_VirtualMachineSizesList_594153 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineSizesList_594155(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachineSizesList_594154(path: JsonNode; query: JsonNode;
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
  var valid_594156 = path.getOrDefault("subscriptionId")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "subscriptionId", valid_594156
  var valid_594157 = path.getOrDefault("location")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "location", valid_594157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594158 = query.getOrDefault("api-version")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "api-version", valid_594158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594159: Call_VirtualMachineSizesList_594153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This API is deprecated. Use [Resources Skus](https://docs.microsoft.com/en-us/rest/api/compute/resourceskus/list)
  ## 
  let valid = call_594159.validator(path, query, header, formData, body)
  let scheme = call_594159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594159.url(scheme.get, call_594159.host, call_594159.base,
                         call_594159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594159, url, valid)

proc call*(call_594160: Call_VirtualMachineSizesList_594153; apiVersion: string;
          subscriptionId: string; location: string): Recallable =
  ## virtualMachineSizesList
  ## This API is deprecated. Use [Resources Skus](https://docs.microsoft.com/en-us/rest/api/compute/resourceskus/list)
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : The location upon which virtual-machine-sizes is queried.
  var path_594161 = newJObject()
  var query_594162 = newJObject()
  add(query_594162, "api-version", newJString(apiVersion))
  add(path_594161, "subscriptionId", newJString(subscriptionId))
  add(path_594161, "location", newJString(location))
  result = call_594160.call(path_594161, query_594162, nil, nil, nil)

var virtualMachineSizesList* = Call_VirtualMachineSizesList_594153(
    name: "virtualMachineSizesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/locations/{location}/vmSizes",
    validator: validate_VirtualMachineSizesList_594154, base: "",
    url: url_VirtualMachineSizesList_594155, schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsListBySubscription_594163 = ref object of OpenApiRestCall_593438
proc url_ProximityPlacementGroupsListBySubscription_594165(protocol: Scheme;
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

proc validate_ProximityPlacementGroupsListBySubscription_594164(path: JsonNode;
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
  var valid_594166 = path.getOrDefault("subscriptionId")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "subscriptionId", valid_594166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594167 = query.getOrDefault("api-version")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "api-version", valid_594167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594168: Call_ProximityPlacementGroupsListBySubscription_594163;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all proximity placement groups in a subscription.
  ## 
  let valid = call_594168.validator(path, query, header, formData, body)
  let scheme = call_594168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594168.url(scheme.get, call_594168.host, call_594168.base,
                         call_594168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594168, url, valid)

proc call*(call_594169: Call_ProximityPlacementGroupsListBySubscription_594163;
          apiVersion: string; subscriptionId: string): Recallable =
  ## proximityPlacementGroupsListBySubscription
  ## Lists all proximity placement groups in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594170 = newJObject()
  var query_594171 = newJObject()
  add(query_594171, "api-version", newJString(apiVersion))
  add(path_594170, "subscriptionId", newJString(subscriptionId))
  result = call_594169.call(path_594170, query_594171, nil, nil, nil)

var proximityPlacementGroupsListBySubscription* = Call_ProximityPlacementGroupsListBySubscription_594163(
    name: "proximityPlacementGroupsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/proximityPlacementGroups",
    validator: validate_ProximityPlacementGroupsListBySubscription_594164,
    base: "", url: url_ProximityPlacementGroupsListBySubscription_594165,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsListAll_594172 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsListAll_594174(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsListAll_594173(path: JsonNode;
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
  var valid_594175 = path.getOrDefault("subscriptionId")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "subscriptionId", valid_594175
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594176 = query.getOrDefault("api-version")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "api-version", valid_594176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594177: Call_VirtualMachineScaleSetsListAll_594172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all VM Scale Sets in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM Scale Sets.
  ## 
  let valid = call_594177.validator(path, query, header, formData, body)
  let scheme = call_594177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594177.url(scheme.get, call_594177.host, call_594177.base,
                         call_594177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594177, url, valid)

proc call*(call_594178: Call_VirtualMachineScaleSetsListAll_594172;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsListAll
  ## Gets a list of all VM Scale Sets in the subscription, regardless of the associated resource group. Use nextLink property in the response to get the next page of VM Scale Sets. Do this till nextLink is null to fetch all the VM Scale Sets.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594179 = newJObject()
  var query_594180 = newJObject()
  add(query_594180, "api-version", newJString(apiVersion))
  add(path_594179, "subscriptionId", newJString(subscriptionId))
  result = call_594178.call(path_594179, query_594180, nil, nil, nil)

var virtualMachineScaleSetsListAll* = Call_VirtualMachineScaleSetsListAll_594172(
    name: "virtualMachineScaleSetsListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachineScaleSets",
    validator: validate_VirtualMachineScaleSetsListAll_594173, base: "",
    url: url_VirtualMachineScaleSetsListAll_594174, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListAll_594181 = ref object of OpenApiRestCall_593438
proc url_VirtualMachinesListAll_594183(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesListAll_594182(path: JsonNode; query: JsonNode;
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
  var valid_594184 = path.getOrDefault("subscriptionId")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "subscriptionId", valid_594184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594185 = query.getOrDefault("api-version")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "api-version", valid_594185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594186: Call_VirtualMachinesListAll_594181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the virtual machines in the specified subscription. Use the nextLink property in the response to get the next page of virtual machines.
  ## 
  let valid = call_594186.validator(path, query, header, formData, body)
  let scheme = call_594186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594186.url(scheme.get, call_594186.host, call_594186.base,
                         call_594186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594186, url, valid)

proc call*(call_594187: Call_VirtualMachinesListAll_594181; apiVersion: string;
          subscriptionId: string): Recallable =
  ## virtualMachinesListAll
  ## Lists all of the virtual machines in the specified subscription. Use the nextLink property in the response to get the next page of virtual machines.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594188 = newJObject()
  var query_594189 = newJObject()
  add(query_594189, "api-version", newJString(apiVersion))
  add(path_594188, "subscriptionId", newJString(subscriptionId))
  result = call_594187.call(path_594188, query_594189, nil, nil, nil)

var virtualMachinesListAll* = Call_VirtualMachinesListAll_594181(
    name: "virtualMachinesListAll", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Compute/virtualMachines",
    validator: validate_VirtualMachinesListAll_594182, base: "",
    url: url_VirtualMachinesListAll_594183, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsList_594190 = ref object of OpenApiRestCall_593438
proc url_AvailabilitySetsList_594192(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsList_594191(path: JsonNode; query: JsonNode;
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
  var valid_594193 = path.getOrDefault("resourceGroupName")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "resourceGroupName", valid_594193
  var valid_594194 = path.getOrDefault("subscriptionId")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "subscriptionId", valid_594194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594195 = query.getOrDefault("api-version")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = nil)
  if valid_594195 != nil:
    section.add "api-version", valid_594195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594196: Call_AvailabilitySetsList_594190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all availability sets in a resource group.
  ## 
  let valid = call_594196.validator(path, query, header, formData, body)
  let scheme = call_594196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594196.url(scheme.get, call_594196.host, call_594196.base,
                         call_594196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594196, url, valid)

proc call*(call_594197: Call_AvailabilitySetsList_594190;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## availabilitySetsList
  ## Lists all availability sets in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594198 = newJObject()
  var query_594199 = newJObject()
  add(path_594198, "resourceGroupName", newJString(resourceGroupName))
  add(query_594199, "api-version", newJString(apiVersion))
  add(path_594198, "subscriptionId", newJString(subscriptionId))
  result = call_594197.call(path_594198, query_594199, nil, nil, nil)

var availabilitySetsList* = Call_AvailabilitySetsList_594190(
    name: "availabilitySetsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets",
    validator: validate_AvailabilitySetsList_594191, base: "",
    url: url_AvailabilitySetsList_594192, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsCreateOrUpdate_594211 = ref object of OpenApiRestCall_593438
proc url_AvailabilitySetsCreateOrUpdate_594213(protocol: Scheme; host: string;
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

proc validate_AvailabilitySetsCreateOrUpdate_594212(path: JsonNode;
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
  var valid_594214 = path.getOrDefault("resourceGroupName")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "resourceGroupName", valid_594214
  var valid_594215 = path.getOrDefault("subscriptionId")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "subscriptionId", valid_594215
  var valid_594216 = path.getOrDefault("availabilitySetName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "availabilitySetName", valid_594216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594217 = query.getOrDefault("api-version")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "api-version", valid_594217
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

proc call*(call_594219: Call_AvailabilitySetsCreateOrUpdate_594211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an availability set.
  ## 
  let valid = call_594219.validator(path, query, header, formData, body)
  let scheme = call_594219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594219.url(scheme.get, call_594219.host, call_594219.base,
                         call_594219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594219, url, valid)

proc call*(call_594220: Call_AvailabilitySetsCreateOrUpdate_594211;
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
  var path_594221 = newJObject()
  var query_594222 = newJObject()
  var body_594223 = newJObject()
  add(path_594221, "resourceGroupName", newJString(resourceGroupName))
  add(query_594222, "api-version", newJString(apiVersion))
  add(path_594221, "subscriptionId", newJString(subscriptionId))
  add(path_594221, "availabilitySetName", newJString(availabilitySetName))
  if parameters != nil:
    body_594223 = parameters
  result = call_594220.call(path_594221, query_594222, nil, nil, body_594223)

var availabilitySetsCreateOrUpdate* = Call_AvailabilitySetsCreateOrUpdate_594211(
    name: "availabilitySetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsCreateOrUpdate_594212, base: "",
    url: url_AvailabilitySetsCreateOrUpdate_594213, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsGet_594200 = ref object of OpenApiRestCall_593438
proc url_AvailabilitySetsGet_594202(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsGet_594201(path: JsonNode; query: JsonNode;
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
  var valid_594203 = path.getOrDefault("resourceGroupName")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "resourceGroupName", valid_594203
  var valid_594204 = path.getOrDefault("subscriptionId")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "subscriptionId", valid_594204
  var valid_594205 = path.getOrDefault("availabilitySetName")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "availabilitySetName", valid_594205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594206 = query.getOrDefault("api-version")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = nil)
  if valid_594206 != nil:
    section.add "api-version", valid_594206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594207: Call_AvailabilitySetsGet_594200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about an availability set.
  ## 
  let valid = call_594207.validator(path, query, header, formData, body)
  let scheme = call_594207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594207.url(scheme.get, call_594207.host, call_594207.base,
                         call_594207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594207, url, valid)

proc call*(call_594208: Call_AvailabilitySetsGet_594200; resourceGroupName: string;
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
  var path_594209 = newJObject()
  var query_594210 = newJObject()
  add(path_594209, "resourceGroupName", newJString(resourceGroupName))
  add(query_594210, "api-version", newJString(apiVersion))
  add(path_594209, "subscriptionId", newJString(subscriptionId))
  add(path_594209, "availabilitySetName", newJString(availabilitySetName))
  result = call_594208.call(path_594209, query_594210, nil, nil, nil)

var availabilitySetsGet* = Call_AvailabilitySetsGet_594200(
    name: "availabilitySetsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsGet_594201, base: "",
    url: url_AvailabilitySetsGet_594202, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsUpdate_594235 = ref object of OpenApiRestCall_593438
proc url_AvailabilitySetsUpdate_594237(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsUpdate_594236(path: JsonNode; query: JsonNode;
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
  var valid_594238 = path.getOrDefault("resourceGroupName")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "resourceGroupName", valid_594238
  var valid_594239 = path.getOrDefault("subscriptionId")
  valid_594239 = validateParameter(valid_594239, JString, required = true,
                                 default = nil)
  if valid_594239 != nil:
    section.add "subscriptionId", valid_594239
  var valid_594240 = path.getOrDefault("availabilitySetName")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "availabilitySetName", valid_594240
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594241 = query.getOrDefault("api-version")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "api-version", valid_594241
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

proc call*(call_594243: Call_AvailabilitySetsUpdate_594235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an availability set.
  ## 
  let valid = call_594243.validator(path, query, header, formData, body)
  let scheme = call_594243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594243.url(scheme.get, call_594243.host, call_594243.base,
                         call_594243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594243, url, valid)

proc call*(call_594244: Call_AvailabilitySetsUpdate_594235;
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
  var path_594245 = newJObject()
  var query_594246 = newJObject()
  var body_594247 = newJObject()
  add(path_594245, "resourceGroupName", newJString(resourceGroupName))
  add(query_594246, "api-version", newJString(apiVersion))
  add(path_594245, "subscriptionId", newJString(subscriptionId))
  add(path_594245, "availabilitySetName", newJString(availabilitySetName))
  if parameters != nil:
    body_594247 = parameters
  result = call_594244.call(path_594245, query_594246, nil, nil, body_594247)

var availabilitySetsUpdate* = Call_AvailabilitySetsUpdate_594235(
    name: "availabilitySetsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsUpdate_594236, base: "",
    url: url_AvailabilitySetsUpdate_594237, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsDelete_594224 = ref object of OpenApiRestCall_593438
proc url_AvailabilitySetsDelete_594226(protocol: Scheme; host: string; base: string;
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

proc validate_AvailabilitySetsDelete_594225(path: JsonNode; query: JsonNode;
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
  var valid_594227 = path.getOrDefault("resourceGroupName")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "resourceGroupName", valid_594227
  var valid_594228 = path.getOrDefault("subscriptionId")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "subscriptionId", valid_594228
  var valid_594229 = path.getOrDefault("availabilitySetName")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "availabilitySetName", valid_594229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594230 = query.getOrDefault("api-version")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = nil)
  if valid_594230 != nil:
    section.add "api-version", valid_594230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594231: Call_AvailabilitySetsDelete_594224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an availability set.
  ## 
  let valid = call_594231.validator(path, query, header, formData, body)
  let scheme = call_594231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594231.url(scheme.get, call_594231.host, call_594231.base,
                         call_594231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594231, url, valid)

proc call*(call_594232: Call_AvailabilitySetsDelete_594224;
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
  var path_594233 = newJObject()
  var query_594234 = newJObject()
  add(path_594233, "resourceGroupName", newJString(resourceGroupName))
  add(query_594234, "api-version", newJString(apiVersion))
  add(path_594233, "subscriptionId", newJString(subscriptionId))
  add(path_594233, "availabilitySetName", newJString(availabilitySetName))
  result = call_594232.call(path_594233, query_594234, nil, nil, nil)

var availabilitySetsDelete* = Call_AvailabilitySetsDelete_594224(
    name: "availabilitySetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}",
    validator: validate_AvailabilitySetsDelete_594225, base: "",
    url: url_AvailabilitySetsDelete_594226, schemes: {Scheme.Https})
type
  Call_AvailabilitySetsListAvailableSizes_594248 = ref object of OpenApiRestCall_593438
proc url_AvailabilitySetsListAvailableSizes_594250(protocol: Scheme; host: string;
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

proc validate_AvailabilitySetsListAvailableSizes_594249(path: JsonNode;
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
  var valid_594251 = path.getOrDefault("resourceGroupName")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = nil)
  if valid_594251 != nil:
    section.add "resourceGroupName", valid_594251
  var valid_594252 = path.getOrDefault("subscriptionId")
  valid_594252 = validateParameter(valid_594252, JString, required = true,
                                 default = nil)
  if valid_594252 != nil:
    section.add "subscriptionId", valid_594252
  var valid_594253 = path.getOrDefault("availabilitySetName")
  valid_594253 = validateParameter(valid_594253, JString, required = true,
                                 default = nil)
  if valid_594253 != nil:
    section.add "availabilitySetName", valid_594253
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594254 = query.getOrDefault("api-version")
  valid_594254 = validateParameter(valid_594254, JString, required = true,
                                 default = nil)
  if valid_594254 != nil:
    section.add "api-version", valid_594254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594255: Call_AvailabilitySetsListAvailableSizes_594248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available virtual machine sizes that can be used to create a new virtual machine in an existing availability set.
  ## 
  let valid = call_594255.validator(path, query, header, formData, body)
  let scheme = call_594255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594255.url(scheme.get, call_594255.host, call_594255.base,
                         call_594255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594255, url, valid)

proc call*(call_594256: Call_AvailabilitySetsListAvailableSizes_594248;
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
  var path_594257 = newJObject()
  var query_594258 = newJObject()
  add(path_594257, "resourceGroupName", newJString(resourceGroupName))
  add(query_594258, "api-version", newJString(apiVersion))
  add(path_594257, "subscriptionId", newJString(subscriptionId))
  add(path_594257, "availabilitySetName", newJString(availabilitySetName))
  result = call_594256.call(path_594257, query_594258, nil, nil, nil)

var availabilitySetsListAvailableSizes* = Call_AvailabilitySetsListAvailableSizes_594248(
    name: "availabilitySetsListAvailableSizes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/availabilitySets/{availabilitySetName}/vmSizes",
    validator: validate_AvailabilitySetsListAvailableSizes_594249, base: "",
    url: url_AvailabilitySetsListAvailableSizes_594250, schemes: {Scheme.Https})
type
  Call_ImagesListByResourceGroup_594259 = ref object of OpenApiRestCall_593438
proc url_ImagesListByResourceGroup_594261(protocol: Scheme; host: string;
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

proc validate_ImagesListByResourceGroup_594260(path: JsonNode; query: JsonNode;
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
  var valid_594262 = path.getOrDefault("resourceGroupName")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "resourceGroupName", valid_594262
  var valid_594263 = path.getOrDefault("subscriptionId")
  valid_594263 = validateParameter(valid_594263, JString, required = true,
                                 default = nil)
  if valid_594263 != nil:
    section.add "subscriptionId", valid_594263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594264 = query.getOrDefault("api-version")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "api-version", valid_594264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594265: Call_ImagesListByResourceGroup_594259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of images under a resource group.
  ## 
  let valid = call_594265.validator(path, query, header, formData, body)
  let scheme = call_594265.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594265.url(scheme.get, call_594265.host, call_594265.base,
                         call_594265.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594265, url, valid)

proc call*(call_594266: Call_ImagesListByResourceGroup_594259;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## imagesListByResourceGroup
  ## Gets the list of images under a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594267 = newJObject()
  var query_594268 = newJObject()
  add(path_594267, "resourceGroupName", newJString(resourceGroupName))
  add(query_594268, "api-version", newJString(apiVersion))
  add(path_594267, "subscriptionId", newJString(subscriptionId))
  result = call_594266.call(path_594267, query_594268, nil, nil, nil)

var imagesListByResourceGroup* = Call_ImagesListByResourceGroup_594259(
    name: "imagesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images",
    validator: validate_ImagesListByResourceGroup_594260, base: "",
    url: url_ImagesListByResourceGroup_594261, schemes: {Scheme.Https})
type
  Call_ImagesCreateOrUpdate_594281 = ref object of OpenApiRestCall_593438
proc url_ImagesCreateOrUpdate_594283(protocol: Scheme; host: string; base: string;
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

proc validate_ImagesCreateOrUpdate_594282(path: JsonNode; query: JsonNode;
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
  var valid_594284 = path.getOrDefault("resourceGroupName")
  valid_594284 = validateParameter(valid_594284, JString, required = true,
                                 default = nil)
  if valid_594284 != nil:
    section.add "resourceGroupName", valid_594284
  var valid_594285 = path.getOrDefault("subscriptionId")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "subscriptionId", valid_594285
  var valid_594286 = path.getOrDefault("imageName")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "imageName", valid_594286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594287 = query.getOrDefault("api-version")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "api-version", valid_594287
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

proc call*(call_594289: Call_ImagesCreateOrUpdate_594281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update an image.
  ## 
  let valid = call_594289.validator(path, query, header, formData, body)
  let scheme = call_594289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594289.url(scheme.get, call_594289.host, call_594289.base,
                         call_594289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594289, url, valid)

proc call*(call_594290: Call_ImagesCreateOrUpdate_594281;
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
  var path_594291 = newJObject()
  var query_594292 = newJObject()
  var body_594293 = newJObject()
  add(path_594291, "resourceGroupName", newJString(resourceGroupName))
  add(query_594292, "api-version", newJString(apiVersion))
  add(path_594291, "subscriptionId", newJString(subscriptionId))
  add(path_594291, "imageName", newJString(imageName))
  if parameters != nil:
    body_594293 = parameters
  result = call_594290.call(path_594291, query_594292, nil, nil, body_594293)

var imagesCreateOrUpdate* = Call_ImagesCreateOrUpdate_594281(
    name: "imagesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesCreateOrUpdate_594282, base: "",
    url: url_ImagesCreateOrUpdate_594283, schemes: {Scheme.Https})
type
  Call_ImagesGet_594269 = ref object of OpenApiRestCall_593438
proc url_ImagesGet_594271(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ImagesGet_594270(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594272 = path.getOrDefault("resourceGroupName")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "resourceGroupName", valid_594272
  var valid_594273 = path.getOrDefault("subscriptionId")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "subscriptionId", valid_594273
  var valid_594274 = path.getOrDefault("imageName")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "imageName", valid_594274
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_594275 = query.getOrDefault("$expand")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = nil)
  if valid_594275 != nil:
    section.add "$expand", valid_594275
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594276 = query.getOrDefault("api-version")
  valid_594276 = validateParameter(valid_594276, JString, required = true,
                                 default = nil)
  if valid_594276 != nil:
    section.add "api-version", valid_594276
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594277: Call_ImagesGet_594269; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an image.
  ## 
  let valid = call_594277.validator(path, query, header, formData, body)
  let scheme = call_594277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594277.url(scheme.get, call_594277.host, call_594277.base,
                         call_594277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594277, url, valid)

proc call*(call_594278: Call_ImagesGet_594269; resourceGroupName: string;
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
  var path_594279 = newJObject()
  var query_594280 = newJObject()
  add(path_594279, "resourceGroupName", newJString(resourceGroupName))
  add(query_594280, "$expand", newJString(Expand))
  add(query_594280, "api-version", newJString(apiVersion))
  add(path_594279, "subscriptionId", newJString(subscriptionId))
  add(path_594279, "imageName", newJString(imageName))
  result = call_594278.call(path_594279, query_594280, nil, nil, nil)

var imagesGet* = Call_ImagesGet_594269(name: "imagesGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
                                    validator: validate_ImagesGet_594270,
                                    base: "", url: url_ImagesGet_594271,
                                    schemes: {Scheme.Https})
type
  Call_ImagesUpdate_594305 = ref object of OpenApiRestCall_593438
proc url_ImagesUpdate_594307(protocol: Scheme; host: string; base: string;
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

proc validate_ImagesUpdate_594306(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594308 = path.getOrDefault("resourceGroupName")
  valid_594308 = validateParameter(valid_594308, JString, required = true,
                                 default = nil)
  if valid_594308 != nil:
    section.add "resourceGroupName", valid_594308
  var valid_594309 = path.getOrDefault("subscriptionId")
  valid_594309 = validateParameter(valid_594309, JString, required = true,
                                 default = nil)
  if valid_594309 != nil:
    section.add "subscriptionId", valid_594309
  var valid_594310 = path.getOrDefault("imageName")
  valid_594310 = validateParameter(valid_594310, JString, required = true,
                                 default = nil)
  if valid_594310 != nil:
    section.add "imageName", valid_594310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594311 = query.getOrDefault("api-version")
  valid_594311 = validateParameter(valid_594311, JString, required = true,
                                 default = nil)
  if valid_594311 != nil:
    section.add "api-version", valid_594311
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

proc call*(call_594313: Call_ImagesUpdate_594305; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an image.
  ## 
  let valid = call_594313.validator(path, query, header, formData, body)
  let scheme = call_594313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594313.url(scheme.get, call_594313.host, call_594313.base,
                         call_594313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594313, url, valid)

proc call*(call_594314: Call_ImagesUpdate_594305; resourceGroupName: string;
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
  var path_594315 = newJObject()
  var query_594316 = newJObject()
  var body_594317 = newJObject()
  add(path_594315, "resourceGroupName", newJString(resourceGroupName))
  add(query_594316, "api-version", newJString(apiVersion))
  add(path_594315, "subscriptionId", newJString(subscriptionId))
  add(path_594315, "imageName", newJString(imageName))
  if parameters != nil:
    body_594317 = parameters
  result = call_594314.call(path_594315, query_594316, nil, nil, body_594317)

var imagesUpdate* = Call_ImagesUpdate_594305(name: "imagesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesUpdate_594306, base: "", url: url_ImagesUpdate_594307,
    schemes: {Scheme.Https})
type
  Call_ImagesDelete_594294 = ref object of OpenApiRestCall_593438
proc url_ImagesDelete_594296(protocol: Scheme; host: string; base: string;
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

proc validate_ImagesDelete_594295(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594297 = path.getOrDefault("resourceGroupName")
  valid_594297 = validateParameter(valid_594297, JString, required = true,
                                 default = nil)
  if valid_594297 != nil:
    section.add "resourceGroupName", valid_594297
  var valid_594298 = path.getOrDefault("subscriptionId")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "subscriptionId", valid_594298
  var valid_594299 = path.getOrDefault("imageName")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "imageName", valid_594299
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594300 = query.getOrDefault("api-version")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "api-version", valid_594300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594301: Call_ImagesDelete_594294; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an Image.
  ## 
  let valid = call_594301.validator(path, query, header, formData, body)
  let scheme = call_594301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594301.url(scheme.get, call_594301.host, call_594301.base,
                         call_594301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594301, url, valid)

proc call*(call_594302: Call_ImagesDelete_594294; resourceGroupName: string;
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
  var path_594303 = newJObject()
  var query_594304 = newJObject()
  add(path_594303, "resourceGroupName", newJString(resourceGroupName))
  add(query_594304, "api-version", newJString(apiVersion))
  add(path_594303, "subscriptionId", newJString(subscriptionId))
  add(path_594303, "imageName", newJString(imageName))
  result = call_594302.call(path_594303, query_594304, nil, nil, nil)

var imagesDelete* = Call_ImagesDelete_594294(name: "imagesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/images/{imageName}",
    validator: validate_ImagesDelete_594295, base: "", url: url_ImagesDelete_594296,
    schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsListByResourceGroup_594318 = ref object of OpenApiRestCall_593438
proc url_ProximityPlacementGroupsListByResourceGroup_594320(protocol: Scheme;
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

proc validate_ProximityPlacementGroupsListByResourceGroup_594319(path: JsonNode;
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
  var valid_594321 = path.getOrDefault("resourceGroupName")
  valid_594321 = validateParameter(valid_594321, JString, required = true,
                                 default = nil)
  if valid_594321 != nil:
    section.add "resourceGroupName", valid_594321
  var valid_594322 = path.getOrDefault("subscriptionId")
  valid_594322 = validateParameter(valid_594322, JString, required = true,
                                 default = nil)
  if valid_594322 != nil:
    section.add "subscriptionId", valid_594322
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594323 = query.getOrDefault("api-version")
  valid_594323 = validateParameter(valid_594323, JString, required = true,
                                 default = nil)
  if valid_594323 != nil:
    section.add "api-version", valid_594323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594324: Call_ProximityPlacementGroupsListByResourceGroup_594318;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all proximity placement groups in a resource group.
  ## 
  let valid = call_594324.validator(path, query, header, formData, body)
  let scheme = call_594324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594324.url(scheme.get, call_594324.host, call_594324.base,
                         call_594324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594324, url, valid)

proc call*(call_594325: Call_ProximityPlacementGroupsListByResourceGroup_594318;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## proximityPlacementGroupsListByResourceGroup
  ## Lists all proximity placement groups in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594326 = newJObject()
  var query_594327 = newJObject()
  add(path_594326, "resourceGroupName", newJString(resourceGroupName))
  add(query_594327, "api-version", newJString(apiVersion))
  add(path_594326, "subscriptionId", newJString(subscriptionId))
  result = call_594325.call(path_594326, query_594327, nil, nil, nil)

var proximityPlacementGroupsListByResourceGroup* = Call_ProximityPlacementGroupsListByResourceGroup_594318(
    name: "proximityPlacementGroupsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups",
    validator: validate_ProximityPlacementGroupsListByResourceGroup_594319,
    base: "", url: url_ProximityPlacementGroupsListByResourceGroup_594320,
    schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsCreateOrUpdate_594339 = ref object of OpenApiRestCall_593438
proc url_ProximityPlacementGroupsCreateOrUpdate_594341(protocol: Scheme;
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

proc validate_ProximityPlacementGroupsCreateOrUpdate_594340(path: JsonNode;
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
  var valid_594342 = path.getOrDefault("resourceGroupName")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "resourceGroupName", valid_594342
  var valid_594343 = path.getOrDefault("subscriptionId")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "subscriptionId", valid_594343
  var valid_594344 = path.getOrDefault("proximityPlacementGroupName")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "proximityPlacementGroupName", valid_594344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594345 = query.getOrDefault("api-version")
  valid_594345 = validateParameter(valid_594345, JString, required = true,
                                 default = nil)
  if valid_594345 != nil:
    section.add "api-version", valid_594345
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

proc call*(call_594347: Call_ProximityPlacementGroupsCreateOrUpdate_594339;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a proximity placement group.
  ## 
  let valid = call_594347.validator(path, query, header, formData, body)
  let scheme = call_594347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594347.url(scheme.get, call_594347.host, call_594347.base,
                         call_594347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594347, url, valid)

proc call*(call_594348: Call_ProximityPlacementGroupsCreateOrUpdate_594339;
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
  var path_594349 = newJObject()
  var query_594350 = newJObject()
  var body_594351 = newJObject()
  add(path_594349, "resourceGroupName", newJString(resourceGroupName))
  add(query_594350, "api-version", newJString(apiVersion))
  add(path_594349, "subscriptionId", newJString(subscriptionId))
  add(path_594349, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  if parameters != nil:
    body_594351 = parameters
  result = call_594348.call(path_594349, query_594350, nil, nil, body_594351)

var proximityPlacementGroupsCreateOrUpdate* = Call_ProximityPlacementGroupsCreateOrUpdate_594339(
    name: "proximityPlacementGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsCreateOrUpdate_594340, base: "",
    url: url_ProximityPlacementGroupsCreateOrUpdate_594341,
    schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsGet_594328 = ref object of OpenApiRestCall_593438
proc url_ProximityPlacementGroupsGet_594330(protocol: Scheme; host: string;
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

proc validate_ProximityPlacementGroupsGet_594329(path: JsonNode; query: JsonNode;
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
  var valid_594331 = path.getOrDefault("resourceGroupName")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "resourceGroupName", valid_594331
  var valid_594332 = path.getOrDefault("subscriptionId")
  valid_594332 = validateParameter(valid_594332, JString, required = true,
                                 default = nil)
  if valid_594332 != nil:
    section.add "subscriptionId", valid_594332
  var valid_594333 = path.getOrDefault("proximityPlacementGroupName")
  valid_594333 = validateParameter(valid_594333, JString, required = true,
                                 default = nil)
  if valid_594333 != nil:
    section.add "proximityPlacementGroupName", valid_594333
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594334 = query.getOrDefault("api-version")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "api-version", valid_594334
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594335: Call_ProximityPlacementGroupsGet_594328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a proximity placement group .
  ## 
  let valid = call_594335.validator(path, query, header, formData, body)
  let scheme = call_594335.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594335.url(scheme.get, call_594335.host, call_594335.base,
                         call_594335.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594335, url, valid)

proc call*(call_594336: Call_ProximityPlacementGroupsGet_594328;
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
  var path_594337 = newJObject()
  var query_594338 = newJObject()
  add(path_594337, "resourceGroupName", newJString(resourceGroupName))
  add(query_594338, "api-version", newJString(apiVersion))
  add(path_594337, "subscriptionId", newJString(subscriptionId))
  add(path_594337, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  result = call_594336.call(path_594337, query_594338, nil, nil, nil)

var proximityPlacementGroupsGet* = Call_ProximityPlacementGroupsGet_594328(
    name: "proximityPlacementGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsGet_594329, base: "",
    url: url_ProximityPlacementGroupsGet_594330, schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsUpdate_594363 = ref object of OpenApiRestCall_593438
proc url_ProximityPlacementGroupsUpdate_594365(protocol: Scheme; host: string;
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

proc validate_ProximityPlacementGroupsUpdate_594364(path: JsonNode;
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
  var valid_594366 = path.getOrDefault("resourceGroupName")
  valid_594366 = validateParameter(valid_594366, JString, required = true,
                                 default = nil)
  if valid_594366 != nil:
    section.add "resourceGroupName", valid_594366
  var valid_594367 = path.getOrDefault("subscriptionId")
  valid_594367 = validateParameter(valid_594367, JString, required = true,
                                 default = nil)
  if valid_594367 != nil:
    section.add "subscriptionId", valid_594367
  var valid_594368 = path.getOrDefault("proximityPlacementGroupName")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "proximityPlacementGroupName", valid_594368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594369 = query.getOrDefault("api-version")
  valid_594369 = validateParameter(valid_594369, JString, required = true,
                                 default = nil)
  if valid_594369 != nil:
    section.add "api-version", valid_594369
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

proc call*(call_594371: Call_ProximityPlacementGroupsUpdate_594363; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a proximity placement group.
  ## 
  let valid = call_594371.validator(path, query, header, formData, body)
  let scheme = call_594371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594371.url(scheme.get, call_594371.host, call_594371.base,
                         call_594371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594371, url, valid)

proc call*(call_594372: Call_ProximityPlacementGroupsUpdate_594363;
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
  var path_594373 = newJObject()
  var query_594374 = newJObject()
  var body_594375 = newJObject()
  add(path_594373, "resourceGroupName", newJString(resourceGroupName))
  add(query_594374, "api-version", newJString(apiVersion))
  add(path_594373, "subscriptionId", newJString(subscriptionId))
  add(path_594373, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  if parameters != nil:
    body_594375 = parameters
  result = call_594372.call(path_594373, query_594374, nil, nil, body_594375)

var proximityPlacementGroupsUpdate* = Call_ProximityPlacementGroupsUpdate_594363(
    name: "proximityPlacementGroupsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsUpdate_594364, base: "",
    url: url_ProximityPlacementGroupsUpdate_594365, schemes: {Scheme.Https})
type
  Call_ProximityPlacementGroupsDelete_594352 = ref object of OpenApiRestCall_593438
proc url_ProximityPlacementGroupsDelete_594354(protocol: Scheme; host: string;
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

proc validate_ProximityPlacementGroupsDelete_594353(path: JsonNode;
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
  var valid_594355 = path.getOrDefault("resourceGroupName")
  valid_594355 = validateParameter(valid_594355, JString, required = true,
                                 default = nil)
  if valid_594355 != nil:
    section.add "resourceGroupName", valid_594355
  var valid_594356 = path.getOrDefault("subscriptionId")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "subscriptionId", valid_594356
  var valid_594357 = path.getOrDefault("proximityPlacementGroupName")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "proximityPlacementGroupName", valid_594357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594358 = query.getOrDefault("api-version")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "api-version", valid_594358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594359: Call_ProximityPlacementGroupsDelete_594352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a proximity placement group.
  ## 
  let valid = call_594359.validator(path, query, header, formData, body)
  let scheme = call_594359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594359.url(scheme.get, call_594359.host, call_594359.base,
                         call_594359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594359, url, valid)

proc call*(call_594360: Call_ProximityPlacementGroupsDelete_594352;
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
  var path_594361 = newJObject()
  var query_594362 = newJObject()
  add(path_594361, "resourceGroupName", newJString(resourceGroupName))
  add(query_594362, "api-version", newJString(apiVersion))
  add(path_594361, "subscriptionId", newJString(subscriptionId))
  add(path_594361, "proximityPlacementGroupName",
      newJString(proximityPlacementGroupName))
  result = call_594360.call(path_594361, query_594362, nil, nil, nil)

var proximityPlacementGroupsDelete* = Call_ProximityPlacementGroupsDelete_594352(
    name: "proximityPlacementGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/proximityPlacementGroups/{proximityPlacementGroupName}",
    validator: validate_ProximityPlacementGroupsDelete_594353, base: "",
    url: url_ProximityPlacementGroupsDelete_594354, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsList_594376 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsList_594378(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsList_594377(path: JsonNode; query: JsonNode;
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
  var valid_594379 = path.getOrDefault("resourceGroupName")
  valid_594379 = validateParameter(valid_594379, JString, required = true,
                                 default = nil)
  if valid_594379 != nil:
    section.add "resourceGroupName", valid_594379
  var valid_594380 = path.getOrDefault("subscriptionId")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "subscriptionId", valid_594380
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594381 = query.getOrDefault("api-version")
  valid_594381 = validateParameter(valid_594381, JString, required = true,
                                 default = nil)
  if valid_594381 != nil:
    section.add "api-version", valid_594381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594382: Call_VirtualMachineScaleSetsList_594376; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all VM scale sets under a resource group.
  ## 
  let valid = call_594382.validator(path, query, header, formData, body)
  let scheme = call_594382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594382.url(scheme.get, call_594382.host, call_594382.base,
                         call_594382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594382, url, valid)

proc call*(call_594383: Call_VirtualMachineScaleSetsList_594376;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachineScaleSetsList
  ## Gets a list of all VM scale sets under a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594384 = newJObject()
  var query_594385 = newJObject()
  add(path_594384, "resourceGroupName", newJString(resourceGroupName))
  add(query_594385, "api-version", newJString(apiVersion))
  add(path_594384, "subscriptionId", newJString(subscriptionId))
  result = call_594383.call(path_594384, query_594385, nil, nil, nil)

var virtualMachineScaleSetsList* = Call_VirtualMachineScaleSetsList_594376(
    name: "virtualMachineScaleSetsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets",
    validator: validate_VirtualMachineScaleSetsList_594377, base: "",
    url: url_VirtualMachineScaleSetsList_594378, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsList_594386 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetVMsList_594388(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsList_594387(path: JsonNode; query: JsonNode;
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
  var valid_594389 = path.getOrDefault("resourceGroupName")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "resourceGroupName", valid_594389
  var valid_594390 = path.getOrDefault("subscriptionId")
  valid_594390 = validateParameter(valid_594390, JString, required = true,
                                 default = nil)
  if valid_594390 != nil:
    section.add "subscriptionId", valid_594390
  var valid_594391 = path.getOrDefault("virtualMachineScaleSetName")
  valid_594391 = validateParameter(valid_594391, JString, required = true,
                                 default = nil)
  if valid_594391 != nil:
    section.add "virtualMachineScaleSetName", valid_594391
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
  var valid_594392 = query.getOrDefault("$expand")
  valid_594392 = validateParameter(valid_594392, JString, required = false,
                                 default = nil)
  if valid_594392 != nil:
    section.add "$expand", valid_594392
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594393 = query.getOrDefault("api-version")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = nil)
  if valid_594393 != nil:
    section.add "api-version", valid_594393
  var valid_594394 = query.getOrDefault("$select")
  valid_594394 = validateParameter(valid_594394, JString, required = false,
                                 default = nil)
  if valid_594394 != nil:
    section.add "$select", valid_594394
  var valid_594395 = query.getOrDefault("$filter")
  valid_594395 = validateParameter(valid_594395, JString, required = false,
                                 default = nil)
  if valid_594395 != nil:
    section.add "$filter", valid_594395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594396: Call_VirtualMachineScaleSetVMsList_594386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of all virtual machines in a VM scale sets.
  ## 
  let valid = call_594396.validator(path, query, header, formData, body)
  let scheme = call_594396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594396.url(scheme.get, call_594396.host, call_594396.base,
                         call_594396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594396, url, valid)

proc call*(call_594397: Call_VirtualMachineScaleSetVMsList_594386;
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
  var path_594398 = newJObject()
  var query_594399 = newJObject()
  add(path_594398, "resourceGroupName", newJString(resourceGroupName))
  add(query_594399, "$expand", newJString(Expand))
  add(query_594399, "api-version", newJString(apiVersion))
  add(path_594398, "subscriptionId", newJString(subscriptionId))
  add(query_594399, "$select", newJString(Select))
  add(path_594398, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  add(query_594399, "$filter", newJString(Filter))
  result = call_594397.call(path_594398, query_594399, nil, nil, nil)

var virtualMachineScaleSetVMsList* = Call_VirtualMachineScaleSetVMsList_594386(
    name: "virtualMachineScaleSetVMsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines",
    validator: validate_VirtualMachineScaleSetVMsList_594387, base: "",
    url: url_VirtualMachineScaleSetVMsList_594388, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsCreateOrUpdate_594411 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsCreateOrUpdate_594413(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsCreateOrUpdate_594412(path: JsonNode;
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
  var valid_594414 = path.getOrDefault("vmScaleSetName")
  valid_594414 = validateParameter(valid_594414, JString, required = true,
                                 default = nil)
  if valid_594414 != nil:
    section.add "vmScaleSetName", valid_594414
  var valid_594415 = path.getOrDefault("resourceGroupName")
  valid_594415 = validateParameter(valid_594415, JString, required = true,
                                 default = nil)
  if valid_594415 != nil:
    section.add "resourceGroupName", valid_594415
  var valid_594416 = path.getOrDefault("subscriptionId")
  valid_594416 = validateParameter(valid_594416, JString, required = true,
                                 default = nil)
  if valid_594416 != nil:
    section.add "subscriptionId", valid_594416
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594417 = query.getOrDefault("api-version")
  valid_594417 = validateParameter(valid_594417, JString, required = true,
                                 default = nil)
  if valid_594417 != nil:
    section.add "api-version", valid_594417
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

proc call*(call_594419: Call_VirtualMachineScaleSetsCreateOrUpdate_594411;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create or update a VM scale set.
  ## 
  let valid = call_594419.validator(path, query, header, formData, body)
  let scheme = call_594419.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594419.url(scheme.get, call_594419.host, call_594419.base,
                         call_594419.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594419, url, valid)

proc call*(call_594420: Call_VirtualMachineScaleSetsCreateOrUpdate_594411;
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
  var path_594421 = newJObject()
  var query_594422 = newJObject()
  var body_594423 = newJObject()
  add(path_594421, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594421, "resourceGroupName", newJString(resourceGroupName))
  add(query_594422, "api-version", newJString(apiVersion))
  add(path_594421, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594423 = parameters
  result = call_594420.call(path_594421, query_594422, nil, nil, body_594423)

var virtualMachineScaleSetsCreateOrUpdate* = Call_VirtualMachineScaleSetsCreateOrUpdate_594411(
    name: "virtualMachineScaleSetsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsCreateOrUpdate_594412, base: "",
    url: url_VirtualMachineScaleSetsCreateOrUpdate_594413, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGet_594400 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsGet_594402(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsGet_594401(path: JsonNode; query: JsonNode;
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
  var valid_594403 = path.getOrDefault("vmScaleSetName")
  valid_594403 = validateParameter(valid_594403, JString, required = true,
                                 default = nil)
  if valid_594403 != nil:
    section.add "vmScaleSetName", valid_594403
  var valid_594404 = path.getOrDefault("resourceGroupName")
  valid_594404 = validateParameter(valid_594404, JString, required = true,
                                 default = nil)
  if valid_594404 != nil:
    section.add "resourceGroupName", valid_594404
  var valid_594405 = path.getOrDefault("subscriptionId")
  valid_594405 = validateParameter(valid_594405, JString, required = true,
                                 default = nil)
  if valid_594405 != nil:
    section.add "subscriptionId", valid_594405
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594406 = query.getOrDefault("api-version")
  valid_594406 = validateParameter(valid_594406, JString, required = true,
                                 default = nil)
  if valid_594406 != nil:
    section.add "api-version", valid_594406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594407: Call_VirtualMachineScaleSetsGet_594400; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Display information about a virtual machine scale set.
  ## 
  let valid = call_594407.validator(path, query, header, formData, body)
  let scheme = call_594407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594407.url(scheme.get, call_594407.host, call_594407.base,
                         call_594407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594407, url, valid)

proc call*(call_594408: Call_VirtualMachineScaleSetsGet_594400;
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
  var path_594409 = newJObject()
  var query_594410 = newJObject()
  add(path_594409, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594409, "resourceGroupName", newJString(resourceGroupName))
  add(query_594410, "api-version", newJString(apiVersion))
  add(path_594409, "subscriptionId", newJString(subscriptionId))
  result = call_594408.call(path_594409, query_594410, nil, nil, nil)

var virtualMachineScaleSetsGet* = Call_VirtualMachineScaleSetsGet_594400(
    name: "virtualMachineScaleSetsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsGet_594401, base: "",
    url: url_VirtualMachineScaleSetsGet_594402, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsUpdate_594435 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsUpdate_594437(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsUpdate_594436(path: JsonNode; query: JsonNode;
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
  var valid_594438 = path.getOrDefault("vmScaleSetName")
  valid_594438 = validateParameter(valid_594438, JString, required = true,
                                 default = nil)
  if valid_594438 != nil:
    section.add "vmScaleSetName", valid_594438
  var valid_594439 = path.getOrDefault("resourceGroupName")
  valid_594439 = validateParameter(valid_594439, JString, required = true,
                                 default = nil)
  if valid_594439 != nil:
    section.add "resourceGroupName", valid_594439
  var valid_594440 = path.getOrDefault("subscriptionId")
  valid_594440 = validateParameter(valid_594440, JString, required = true,
                                 default = nil)
  if valid_594440 != nil:
    section.add "subscriptionId", valid_594440
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594441 = query.getOrDefault("api-version")
  valid_594441 = validateParameter(valid_594441, JString, required = true,
                                 default = nil)
  if valid_594441 != nil:
    section.add "api-version", valid_594441
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

proc call*(call_594443: Call_VirtualMachineScaleSetsUpdate_594435; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update a VM scale set.
  ## 
  let valid = call_594443.validator(path, query, header, formData, body)
  let scheme = call_594443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594443.url(scheme.get, call_594443.host, call_594443.base,
                         call_594443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594443, url, valid)

proc call*(call_594444: Call_VirtualMachineScaleSetsUpdate_594435;
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
  var path_594445 = newJObject()
  var query_594446 = newJObject()
  var body_594447 = newJObject()
  add(path_594445, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594445, "resourceGroupName", newJString(resourceGroupName))
  add(query_594446, "api-version", newJString(apiVersion))
  add(path_594445, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594447 = parameters
  result = call_594444.call(path_594445, query_594446, nil, nil, body_594447)

var virtualMachineScaleSetsUpdate* = Call_VirtualMachineScaleSetsUpdate_594435(
    name: "virtualMachineScaleSetsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsUpdate_594436, base: "",
    url: url_VirtualMachineScaleSetsUpdate_594437, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDelete_594424 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsDelete_594426(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsDelete_594425(path: JsonNode; query: JsonNode;
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
  var valid_594427 = path.getOrDefault("vmScaleSetName")
  valid_594427 = validateParameter(valid_594427, JString, required = true,
                                 default = nil)
  if valid_594427 != nil:
    section.add "vmScaleSetName", valid_594427
  var valid_594428 = path.getOrDefault("resourceGroupName")
  valid_594428 = validateParameter(valid_594428, JString, required = true,
                                 default = nil)
  if valid_594428 != nil:
    section.add "resourceGroupName", valid_594428
  var valid_594429 = path.getOrDefault("subscriptionId")
  valid_594429 = validateParameter(valid_594429, JString, required = true,
                                 default = nil)
  if valid_594429 != nil:
    section.add "subscriptionId", valid_594429
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594430 = query.getOrDefault("api-version")
  valid_594430 = validateParameter(valid_594430, JString, required = true,
                                 default = nil)
  if valid_594430 != nil:
    section.add "api-version", valid_594430
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594431: Call_VirtualMachineScaleSetsDelete_594424; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a VM scale set.
  ## 
  let valid = call_594431.validator(path, query, header, formData, body)
  let scheme = call_594431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594431.url(scheme.get, call_594431.host, call_594431.base,
                         call_594431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594431, url, valid)

proc call*(call_594432: Call_VirtualMachineScaleSetsDelete_594424;
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
  var path_594433 = newJObject()
  var query_594434 = newJObject()
  add(path_594433, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594433, "resourceGroupName", newJString(resourceGroupName))
  add(query_594434, "api-version", newJString(apiVersion))
  add(path_594433, "subscriptionId", newJString(subscriptionId))
  result = call_594432.call(path_594433, query_594434, nil, nil, nil)

var virtualMachineScaleSetsDelete* = Call_VirtualMachineScaleSetsDelete_594424(
    name: "virtualMachineScaleSetsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}",
    validator: validate_VirtualMachineScaleSetsDelete_594425, base: "",
    url: url_VirtualMachineScaleSetsDelete_594426, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDeallocate_594448 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsDeallocate_594450(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsDeallocate_594449(path: JsonNode;
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
  var valid_594451 = path.getOrDefault("vmScaleSetName")
  valid_594451 = validateParameter(valid_594451, JString, required = true,
                                 default = nil)
  if valid_594451 != nil:
    section.add "vmScaleSetName", valid_594451
  var valid_594452 = path.getOrDefault("resourceGroupName")
  valid_594452 = validateParameter(valid_594452, JString, required = true,
                                 default = nil)
  if valid_594452 != nil:
    section.add "resourceGroupName", valid_594452
  var valid_594453 = path.getOrDefault("subscriptionId")
  valid_594453 = validateParameter(valid_594453, JString, required = true,
                                 default = nil)
  if valid_594453 != nil:
    section.add "subscriptionId", valid_594453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594454 = query.getOrDefault("api-version")
  valid_594454 = validateParameter(valid_594454, JString, required = true,
                                 default = nil)
  if valid_594454 != nil:
    section.add "api-version", valid_594454
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

proc call*(call_594456: Call_VirtualMachineScaleSetsDeallocate_594448;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deallocates specific virtual machines in a VM scale set. Shuts down the virtual machines and releases the compute resources. You are not billed for the compute resources that this virtual machine scale set deallocates.
  ## 
  let valid = call_594456.validator(path, query, header, formData, body)
  let scheme = call_594456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594456.url(scheme.get, call_594456.host, call_594456.base,
                         call_594456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594456, url, valid)

proc call*(call_594457: Call_VirtualMachineScaleSetsDeallocate_594448;
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
  var path_594458 = newJObject()
  var query_594459 = newJObject()
  var body_594460 = newJObject()
  add(path_594458, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594458, "resourceGroupName", newJString(resourceGroupName))
  add(query_594459, "api-version", newJString(apiVersion))
  add(path_594458, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_594460 = vmInstanceIDs
  result = call_594457.call(path_594458, query_594459, nil, nil, body_594460)

var virtualMachineScaleSetsDeallocate* = Call_VirtualMachineScaleSetsDeallocate_594448(
    name: "virtualMachineScaleSetsDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/deallocate",
    validator: validate_VirtualMachineScaleSetsDeallocate_594449, base: "",
    url: url_VirtualMachineScaleSetsDeallocate_594450, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsDeleteInstances_594461 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsDeleteInstances_594463(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsDeleteInstances_594462(path: JsonNode;
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
  var valid_594464 = path.getOrDefault("vmScaleSetName")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "vmScaleSetName", valid_594464
  var valid_594465 = path.getOrDefault("resourceGroupName")
  valid_594465 = validateParameter(valid_594465, JString, required = true,
                                 default = nil)
  if valid_594465 != nil:
    section.add "resourceGroupName", valid_594465
  var valid_594466 = path.getOrDefault("subscriptionId")
  valid_594466 = validateParameter(valid_594466, JString, required = true,
                                 default = nil)
  if valid_594466 != nil:
    section.add "subscriptionId", valid_594466
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594467 = query.getOrDefault("api-version")
  valid_594467 = validateParameter(valid_594467, JString, required = true,
                                 default = nil)
  if valid_594467 != nil:
    section.add "api-version", valid_594467
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

proc call*(call_594469: Call_VirtualMachineScaleSetsDeleteInstances_594461;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes virtual machines in a VM scale set.
  ## 
  let valid = call_594469.validator(path, query, header, formData, body)
  let scheme = call_594469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594469.url(scheme.get, call_594469.host, call_594469.base,
                         call_594469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594469, url, valid)

proc call*(call_594470: Call_VirtualMachineScaleSetsDeleteInstances_594461;
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
  var path_594471 = newJObject()
  var query_594472 = newJObject()
  var body_594473 = newJObject()
  add(path_594471, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594471, "resourceGroupName", newJString(resourceGroupName))
  add(query_594472, "api-version", newJString(apiVersion))
  add(path_594471, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_594473 = vmInstanceIDs
  result = call_594470.call(path_594471, query_594472, nil, nil, body_594473)

var virtualMachineScaleSetsDeleteInstances* = Call_VirtualMachineScaleSetsDeleteInstances_594461(
    name: "virtualMachineScaleSetsDeleteInstances", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/delete",
    validator: validate_VirtualMachineScaleSetsDeleteInstances_594462, base: "",
    url: url_VirtualMachineScaleSetsDeleteInstances_594463,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_594474 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_594476(
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

proc validate_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_594475(
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
  var valid_594477 = path.getOrDefault("vmScaleSetName")
  valid_594477 = validateParameter(valid_594477, JString, required = true,
                                 default = nil)
  if valid_594477 != nil:
    section.add "vmScaleSetName", valid_594477
  var valid_594478 = path.getOrDefault("resourceGroupName")
  valid_594478 = validateParameter(valid_594478, JString, required = true,
                                 default = nil)
  if valid_594478 != nil:
    section.add "resourceGroupName", valid_594478
  var valid_594479 = path.getOrDefault("subscriptionId")
  valid_594479 = validateParameter(valid_594479, JString, required = true,
                                 default = nil)
  if valid_594479 != nil:
    section.add "subscriptionId", valid_594479
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594480 = query.getOrDefault("api-version")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = nil)
  if valid_594480 != nil:
    section.add "api-version", valid_594480
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594481: Call_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_594474;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a rolling upgrade to move all extensions for all virtual machine scale set instances to the latest available extension version. Instances which are already running the latest extension versions are not affected.
  ## 
  let valid = call_594481.validator(path, query, header, formData, body)
  let scheme = call_594481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594481.url(scheme.get, call_594481.host, call_594481.base,
                         call_594481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594481, url, valid)

proc call*(call_594482: Call_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_594474;
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
  var path_594483 = newJObject()
  var query_594484 = newJObject()
  add(path_594483, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594483, "resourceGroupName", newJString(resourceGroupName))
  add(query_594484, "api-version", newJString(apiVersion))
  add(path_594483, "subscriptionId", newJString(subscriptionId))
  result = call_594482.call(path_594483, query_594484, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesStartExtensionUpgrade* = Call_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_594474(
    name: "virtualMachineScaleSetRollingUpgradesStartExtensionUpgrade",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensionRollingUpgrade", validator: validate_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_594475,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesStartExtensionUpgrade_594476,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsList_594485 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetExtensionsList_594487(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetExtensionsList_594486(path: JsonNode;
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
  var valid_594488 = path.getOrDefault("vmScaleSetName")
  valid_594488 = validateParameter(valid_594488, JString, required = true,
                                 default = nil)
  if valid_594488 != nil:
    section.add "vmScaleSetName", valid_594488
  var valid_594489 = path.getOrDefault("resourceGroupName")
  valid_594489 = validateParameter(valid_594489, JString, required = true,
                                 default = nil)
  if valid_594489 != nil:
    section.add "resourceGroupName", valid_594489
  var valid_594490 = path.getOrDefault("subscriptionId")
  valid_594490 = validateParameter(valid_594490, JString, required = true,
                                 default = nil)
  if valid_594490 != nil:
    section.add "subscriptionId", valid_594490
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594491 = query.getOrDefault("api-version")
  valid_594491 = validateParameter(valid_594491, JString, required = true,
                                 default = nil)
  if valid_594491 != nil:
    section.add "api-version", valid_594491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594492: Call_VirtualMachineScaleSetExtensionsList_594485;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of all extensions in a VM scale set.
  ## 
  let valid = call_594492.validator(path, query, header, formData, body)
  let scheme = call_594492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594492.url(scheme.get, call_594492.host, call_594492.base,
                         call_594492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594492, url, valid)

proc call*(call_594493: Call_VirtualMachineScaleSetExtensionsList_594485;
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
  var path_594494 = newJObject()
  var query_594495 = newJObject()
  add(path_594494, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594494, "resourceGroupName", newJString(resourceGroupName))
  add(query_594495, "api-version", newJString(apiVersion))
  add(path_594494, "subscriptionId", newJString(subscriptionId))
  result = call_594493.call(path_594494, query_594495, nil, nil, nil)

var virtualMachineScaleSetExtensionsList* = Call_VirtualMachineScaleSetExtensionsList_594485(
    name: "virtualMachineScaleSetExtensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions",
    validator: validate_VirtualMachineScaleSetExtensionsList_594486, base: "",
    url: url_VirtualMachineScaleSetExtensionsList_594487, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_594509 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetExtensionsCreateOrUpdate_594511(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetExtensionsCreateOrUpdate_594510(
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
  var valid_594512 = path.getOrDefault("vmScaleSetName")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "vmScaleSetName", valid_594512
  var valid_594513 = path.getOrDefault("resourceGroupName")
  valid_594513 = validateParameter(valid_594513, JString, required = true,
                                 default = nil)
  if valid_594513 != nil:
    section.add "resourceGroupName", valid_594513
  var valid_594514 = path.getOrDefault("subscriptionId")
  valid_594514 = validateParameter(valid_594514, JString, required = true,
                                 default = nil)
  if valid_594514 != nil:
    section.add "subscriptionId", valid_594514
  var valid_594515 = path.getOrDefault("vmssExtensionName")
  valid_594515 = validateParameter(valid_594515, JString, required = true,
                                 default = nil)
  if valid_594515 != nil:
    section.add "vmssExtensionName", valid_594515
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594516 = query.getOrDefault("api-version")
  valid_594516 = validateParameter(valid_594516, JString, required = true,
                                 default = nil)
  if valid_594516 != nil:
    section.add "api-version", valid_594516
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

proc call*(call_594518: Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_594509;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update an extension.
  ## 
  let valid = call_594518.validator(path, query, header, formData, body)
  let scheme = call_594518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594518.url(scheme.get, call_594518.host, call_594518.base,
                         call_594518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594518, url, valid)

proc call*(call_594519: Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_594509;
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
  var path_594520 = newJObject()
  var query_594521 = newJObject()
  var body_594522 = newJObject()
  add(path_594520, "vmScaleSetName", newJString(vmScaleSetName))
  if extensionParameters != nil:
    body_594522 = extensionParameters
  add(path_594520, "resourceGroupName", newJString(resourceGroupName))
  add(query_594521, "api-version", newJString(apiVersion))
  add(path_594520, "subscriptionId", newJString(subscriptionId))
  add(path_594520, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_594519.call(path_594520, query_594521, nil, nil, body_594522)

var virtualMachineScaleSetExtensionsCreateOrUpdate* = Call_VirtualMachineScaleSetExtensionsCreateOrUpdate_594509(
    name: "virtualMachineScaleSetExtensionsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsCreateOrUpdate_594510,
    base: "", url: url_VirtualMachineScaleSetExtensionsCreateOrUpdate_594511,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsGet_594496 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetExtensionsGet_594498(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetExtensionsGet_594497(path: JsonNode;
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
  var valid_594499 = path.getOrDefault("vmScaleSetName")
  valid_594499 = validateParameter(valid_594499, JString, required = true,
                                 default = nil)
  if valid_594499 != nil:
    section.add "vmScaleSetName", valid_594499
  var valid_594500 = path.getOrDefault("resourceGroupName")
  valid_594500 = validateParameter(valid_594500, JString, required = true,
                                 default = nil)
  if valid_594500 != nil:
    section.add "resourceGroupName", valid_594500
  var valid_594501 = path.getOrDefault("subscriptionId")
  valid_594501 = validateParameter(valid_594501, JString, required = true,
                                 default = nil)
  if valid_594501 != nil:
    section.add "subscriptionId", valid_594501
  var valid_594502 = path.getOrDefault("vmssExtensionName")
  valid_594502 = validateParameter(valid_594502, JString, required = true,
                                 default = nil)
  if valid_594502 != nil:
    section.add "vmssExtensionName", valid_594502
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_594503 = query.getOrDefault("$expand")
  valid_594503 = validateParameter(valid_594503, JString, required = false,
                                 default = nil)
  if valid_594503 != nil:
    section.add "$expand", valid_594503
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594504 = query.getOrDefault("api-version")
  valid_594504 = validateParameter(valid_594504, JString, required = true,
                                 default = nil)
  if valid_594504 != nil:
    section.add "api-version", valid_594504
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594505: Call_VirtualMachineScaleSetExtensionsGet_594496;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to get the extension.
  ## 
  let valid = call_594505.validator(path, query, header, formData, body)
  let scheme = call_594505.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594505.url(scheme.get, call_594505.host, call_594505.base,
                         call_594505.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594505, url, valid)

proc call*(call_594506: Call_VirtualMachineScaleSetExtensionsGet_594496;
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
  var path_594507 = newJObject()
  var query_594508 = newJObject()
  add(path_594507, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594507, "resourceGroupName", newJString(resourceGroupName))
  add(query_594508, "$expand", newJString(Expand))
  add(query_594508, "api-version", newJString(apiVersion))
  add(path_594507, "subscriptionId", newJString(subscriptionId))
  add(path_594507, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_594506.call(path_594507, query_594508, nil, nil, nil)

var virtualMachineScaleSetExtensionsGet* = Call_VirtualMachineScaleSetExtensionsGet_594496(
    name: "virtualMachineScaleSetExtensionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsGet_594497, base: "",
    url: url_VirtualMachineScaleSetExtensionsGet_594498, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetExtensionsDelete_594523 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetExtensionsDelete_594525(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetExtensionsDelete_594524(path: JsonNode;
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
  var valid_594526 = path.getOrDefault("vmScaleSetName")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = nil)
  if valid_594526 != nil:
    section.add "vmScaleSetName", valid_594526
  var valid_594527 = path.getOrDefault("resourceGroupName")
  valid_594527 = validateParameter(valid_594527, JString, required = true,
                                 default = nil)
  if valid_594527 != nil:
    section.add "resourceGroupName", valid_594527
  var valid_594528 = path.getOrDefault("subscriptionId")
  valid_594528 = validateParameter(valid_594528, JString, required = true,
                                 default = nil)
  if valid_594528 != nil:
    section.add "subscriptionId", valid_594528
  var valid_594529 = path.getOrDefault("vmssExtensionName")
  valid_594529 = validateParameter(valid_594529, JString, required = true,
                                 default = nil)
  if valid_594529 != nil:
    section.add "vmssExtensionName", valid_594529
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594530 = query.getOrDefault("api-version")
  valid_594530 = validateParameter(valid_594530, JString, required = true,
                                 default = nil)
  if valid_594530 != nil:
    section.add "api-version", valid_594530
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594531: Call_VirtualMachineScaleSetExtensionsDelete_594523;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to delete the extension.
  ## 
  let valid = call_594531.validator(path, query, header, formData, body)
  let scheme = call_594531.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594531.url(scheme.get, call_594531.host, call_594531.base,
                         call_594531.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594531, url, valid)

proc call*(call_594532: Call_VirtualMachineScaleSetExtensionsDelete_594523;
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
  var path_594533 = newJObject()
  var query_594534 = newJObject()
  add(path_594533, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594533, "resourceGroupName", newJString(resourceGroupName))
  add(query_594534, "api-version", newJString(apiVersion))
  add(path_594533, "subscriptionId", newJString(subscriptionId))
  add(path_594533, "vmssExtensionName", newJString(vmssExtensionName))
  result = call_594532.call(path_594533, query_594534, nil, nil, nil)

var virtualMachineScaleSetExtensionsDelete* = Call_VirtualMachineScaleSetExtensionsDelete_594523(
    name: "virtualMachineScaleSetExtensionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/extensions/{vmssExtensionName}",
    validator: validate_VirtualMachineScaleSetExtensionsDelete_594524, base: "",
    url: url_VirtualMachineScaleSetExtensionsDelete_594525,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_594535 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_594537(
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

proc validate_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_594536(
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
  var valid_594538 = path.getOrDefault("vmScaleSetName")
  valid_594538 = validateParameter(valid_594538, JString, required = true,
                                 default = nil)
  if valid_594538 != nil:
    section.add "vmScaleSetName", valid_594538
  var valid_594539 = path.getOrDefault("resourceGroupName")
  valid_594539 = validateParameter(valid_594539, JString, required = true,
                                 default = nil)
  if valid_594539 != nil:
    section.add "resourceGroupName", valid_594539
  var valid_594540 = path.getOrDefault("subscriptionId")
  valid_594540 = validateParameter(valid_594540, JString, required = true,
                                 default = nil)
  if valid_594540 != nil:
    section.add "subscriptionId", valid_594540
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   platformUpdateDomain: JInt (required)
  ##                       : The platform update domain for which a manual recovery walk is requested
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594541 = query.getOrDefault("api-version")
  valid_594541 = validateParameter(valid_594541, JString, required = true,
                                 default = nil)
  if valid_594541 != nil:
    section.add "api-version", valid_594541
  var valid_594542 = query.getOrDefault("platformUpdateDomain")
  valid_594542 = validateParameter(valid_594542, JInt, required = true, default = nil)
  if valid_594542 != nil:
    section.add "platformUpdateDomain", valid_594542
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594543: Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_594535;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Manual platform update domain walk to update virtual machines in a service fabric virtual machine scale set.
  ## 
  let valid = call_594543.validator(path, query, header, formData, body)
  let scheme = call_594543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594543.url(scheme.get, call_594543.host, call_594543.base,
                         call_594543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594543, url, valid)

proc call*(call_594544: Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_594535;
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
  var path_594545 = newJObject()
  var query_594546 = newJObject()
  add(path_594545, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594545, "resourceGroupName", newJString(resourceGroupName))
  add(query_594546, "api-version", newJString(apiVersion))
  add(query_594546, "platformUpdateDomain", newJInt(platformUpdateDomain))
  add(path_594545, "subscriptionId", newJString(subscriptionId))
  result = call_594544.call(path_594545, query_594546, nil, nil, nil)

var virtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk* = Call_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_594535(name: "virtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/forceRecoveryServiceFabricPlatformUpdateDomainWalk", validator: validate_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_594536,
    base: "", url: url_VirtualMachineScaleSetsForceRecoveryServiceFabricPlatformUpdateDomainWalk_594537,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGetInstanceView_594547 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsGetInstanceView_594549(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsGetInstanceView_594548(path: JsonNode;
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
  var valid_594550 = path.getOrDefault("vmScaleSetName")
  valid_594550 = validateParameter(valid_594550, JString, required = true,
                                 default = nil)
  if valid_594550 != nil:
    section.add "vmScaleSetName", valid_594550
  var valid_594551 = path.getOrDefault("resourceGroupName")
  valid_594551 = validateParameter(valid_594551, JString, required = true,
                                 default = nil)
  if valid_594551 != nil:
    section.add "resourceGroupName", valid_594551
  var valid_594552 = path.getOrDefault("subscriptionId")
  valid_594552 = validateParameter(valid_594552, JString, required = true,
                                 default = nil)
  if valid_594552 != nil:
    section.add "subscriptionId", valid_594552
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594553 = query.getOrDefault("api-version")
  valid_594553 = validateParameter(valid_594553, JString, required = true,
                                 default = nil)
  if valid_594553 != nil:
    section.add "api-version", valid_594553
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594554: Call_VirtualMachineScaleSetsGetInstanceView_594547;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of a VM scale set instance.
  ## 
  let valid = call_594554.validator(path, query, header, formData, body)
  let scheme = call_594554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594554.url(scheme.get, call_594554.host, call_594554.base,
                         call_594554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594554, url, valid)

proc call*(call_594555: Call_VirtualMachineScaleSetsGetInstanceView_594547;
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
  var path_594556 = newJObject()
  var query_594557 = newJObject()
  add(path_594556, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594556, "resourceGroupName", newJString(resourceGroupName))
  add(query_594557, "api-version", newJString(apiVersion))
  add(path_594556, "subscriptionId", newJString(subscriptionId))
  result = call_594555.call(path_594556, query_594557, nil, nil, nil)

var virtualMachineScaleSetsGetInstanceView* = Call_VirtualMachineScaleSetsGetInstanceView_594547(
    name: "virtualMachineScaleSetsGetInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/instanceView",
    validator: validate_VirtualMachineScaleSetsGetInstanceView_594548, base: "",
    url: url_VirtualMachineScaleSetsGetInstanceView_594549,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsUpdateInstances_594558 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsUpdateInstances_594560(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsUpdateInstances_594559(path: JsonNode;
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
  var valid_594561 = path.getOrDefault("vmScaleSetName")
  valid_594561 = validateParameter(valid_594561, JString, required = true,
                                 default = nil)
  if valid_594561 != nil:
    section.add "vmScaleSetName", valid_594561
  var valid_594562 = path.getOrDefault("resourceGroupName")
  valid_594562 = validateParameter(valid_594562, JString, required = true,
                                 default = nil)
  if valid_594562 != nil:
    section.add "resourceGroupName", valid_594562
  var valid_594563 = path.getOrDefault("subscriptionId")
  valid_594563 = validateParameter(valid_594563, JString, required = true,
                                 default = nil)
  if valid_594563 != nil:
    section.add "subscriptionId", valid_594563
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594564 = query.getOrDefault("api-version")
  valid_594564 = validateParameter(valid_594564, JString, required = true,
                                 default = nil)
  if valid_594564 != nil:
    section.add "api-version", valid_594564
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

proc call*(call_594566: Call_VirtualMachineScaleSetsUpdateInstances_594558;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upgrades one or more virtual machines to the latest SKU set in the VM scale set model.
  ## 
  let valid = call_594566.validator(path, query, header, formData, body)
  let scheme = call_594566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594566.url(scheme.get, call_594566.host, call_594566.base,
                         call_594566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594566, url, valid)

proc call*(call_594567: Call_VirtualMachineScaleSetsUpdateInstances_594558;
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
  var path_594568 = newJObject()
  var query_594569 = newJObject()
  var body_594570 = newJObject()
  add(path_594568, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594568, "resourceGroupName", newJString(resourceGroupName))
  add(query_594569, "api-version", newJString(apiVersion))
  add(path_594568, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_594570 = vmInstanceIDs
  result = call_594567.call(path_594568, query_594569, nil, nil, body_594570)

var virtualMachineScaleSetsUpdateInstances* = Call_VirtualMachineScaleSetsUpdateInstances_594558(
    name: "virtualMachineScaleSetsUpdateInstances", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/manualupgrade",
    validator: validate_VirtualMachineScaleSetsUpdateInstances_594559, base: "",
    url: url_VirtualMachineScaleSetsUpdateInstances_594560,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_594571 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_594573(
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

proc validate_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_594572(
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
  var valid_594574 = path.getOrDefault("vmScaleSetName")
  valid_594574 = validateParameter(valid_594574, JString, required = true,
                                 default = nil)
  if valid_594574 != nil:
    section.add "vmScaleSetName", valid_594574
  var valid_594575 = path.getOrDefault("resourceGroupName")
  valid_594575 = validateParameter(valid_594575, JString, required = true,
                                 default = nil)
  if valid_594575 != nil:
    section.add "resourceGroupName", valid_594575
  var valid_594576 = path.getOrDefault("subscriptionId")
  valid_594576 = validateParameter(valid_594576, JString, required = true,
                                 default = nil)
  if valid_594576 != nil:
    section.add "subscriptionId", valid_594576
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594577 = query.getOrDefault("api-version")
  valid_594577 = validateParameter(valid_594577, JString, required = true,
                                 default = nil)
  if valid_594577 != nil:
    section.add "api-version", valid_594577
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594578: Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_594571;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts a rolling upgrade to move all virtual machine scale set instances to the latest available Platform Image OS version. Instances which are already running the latest available OS version are not affected.
  ## 
  let valid = call_594578.validator(path, query, header, formData, body)
  let scheme = call_594578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594578.url(scheme.get, call_594578.host, call_594578.base,
                         call_594578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594578, url, valid)

proc call*(call_594579: Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_594571;
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
  var path_594580 = newJObject()
  var query_594581 = newJObject()
  add(path_594580, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594580, "resourceGroupName", newJString(resourceGroupName))
  add(query_594581, "api-version", newJString(apiVersion))
  add(path_594580, "subscriptionId", newJString(subscriptionId))
  result = call_594579.call(path_594580, query_594581, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesStartOSUpgrade* = Call_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_594571(
    name: "virtualMachineScaleSetRollingUpgradesStartOSUpgrade",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/osRollingUpgrade",
    validator: validate_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_594572,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesStartOSUpgrade_594573,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsGetOSUpgradeHistory_594582 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsGetOSUpgradeHistory_594584(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsGetOSUpgradeHistory_594583(path: JsonNode;
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
  var valid_594585 = path.getOrDefault("vmScaleSetName")
  valid_594585 = validateParameter(valid_594585, JString, required = true,
                                 default = nil)
  if valid_594585 != nil:
    section.add "vmScaleSetName", valid_594585
  var valid_594586 = path.getOrDefault("resourceGroupName")
  valid_594586 = validateParameter(valid_594586, JString, required = true,
                                 default = nil)
  if valid_594586 != nil:
    section.add "resourceGroupName", valid_594586
  var valid_594587 = path.getOrDefault("subscriptionId")
  valid_594587 = validateParameter(valid_594587, JString, required = true,
                                 default = nil)
  if valid_594587 != nil:
    section.add "subscriptionId", valid_594587
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594588 = query.getOrDefault("api-version")
  valid_594588 = validateParameter(valid_594588, JString, required = true,
                                 default = nil)
  if valid_594588 != nil:
    section.add "api-version", valid_594588
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594589: Call_VirtualMachineScaleSetsGetOSUpgradeHistory_594582;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets list of OS upgrades on a VM scale set instance.
  ## 
  let valid = call_594589.validator(path, query, header, formData, body)
  let scheme = call_594589.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594589.url(scheme.get, call_594589.host, call_594589.base,
                         call_594589.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594589, url, valid)

proc call*(call_594590: Call_VirtualMachineScaleSetsGetOSUpgradeHistory_594582;
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
  var path_594591 = newJObject()
  var query_594592 = newJObject()
  add(path_594591, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594591, "resourceGroupName", newJString(resourceGroupName))
  add(query_594592, "api-version", newJString(apiVersion))
  add(path_594591, "subscriptionId", newJString(subscriptionId))
  result = call_594590.call(path_594591, query_594592, nil, nil, nil)

var virtualMachineScaleSetsGetOSUpgradeHistory* = Call_VirtualMachineScaleSetsGetOSUpgradeHistory_594582(
    name: "virtualMachineScaleSetsGetOSUpgradeHistory", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/osUpgradeHistory",
    validator: validate_VirtualMachineScaleSetsGetOSUpgradeHistory_594583,
    base: "", url: url_VirtualMachineScaleSetsGetOSUpgradeHistory_594584,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsPerformMaintenance_594593 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsPerformMaintenance_594595(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetsPerformMaintenance_594594(path: JsonNode;
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
  var valid_594596 = path.getOrDefault("vmScaleSetName")
  valid_594596 = validateParameter(valid_594596, JString, required = true,
                                 default = nil)
  if valid_594596 != nil:
    section.add "vmScaleSetName", valid_594596
  var valid_594597 = path.getOrDefault("resourceGroupName")
  valid_594597 = validateParameter(valid_594597, JString, required = true,
                                 default = nil)
  if valid_594597 != nil:
    section.add "resourceGroupName", valid_594597
  var valid_594598 = path.getOrDefault("subscriptionId")
  valid_594598 = validateParameter(valid_594598, JString, required = true,
                                 default = nil)
  if valid_594598 != nil:
    section.add "subscriptionId", valid_594598
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594599 = query.getOrDefault("api-version")
  valid_594599 = validateParameter(valid_594599, JString, required = true,
                                 default = nil)
  if valid_594599 != nil:
    section.add "api-version", valid_594599
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

proc call*(call_594601: Call_VirtualMachineScaleSetsPerformMaintenance_594593;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Perform maintenance on one or more virtual machines in a VM scale set. Operation on instances which are not eligible for perform maintenance will be failed. Please refer to best practices for more details: https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-maintenance-notifications
  ## 
  let valid = call_594601.validator(path, query, header, formData, body)
  let scheme = call_594601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594601.url(scheme.get, call_594601.host, call_594601.base,
                         call_594601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594601, url, valid)

proc call*(call_594602: Call_VirtualMachineScaleSetsPerformMaintenance_594593;
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
  var path_594603 = newJObject()
  var query_594604 = newJObject()
  var body_594605 = newJObject()
  add(path_594603, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594603, "resourceGroupName", newJString(resourceGroupName))
  add(query_594604, "api-version", newJString(apiVersion))
  add(path_594603, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_594605 = vmInstanceIDs
  result = call_594602.call(path_594603, query_594604, nil, nil, body_594605)

var virtualMachineScaleSetsPerformMaintenance* = Call_VirtualMachineScaleSetsPerformMaintenance_594593(
    name: "virtualMachineScaleSetsPerformMaintenance", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/performMaintenance",
    validator: validate_VirtualMachineScaleSetsPerformMaintenance_594594,
    base: "", url: url_VirtualMachineScaleSetsPerformMaintenance_594595,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsPowerOff_594606 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsPowerOff_594608(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsPowerOff_594607(path: JsonNode;
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
  var valid_594609 = path.getOrDefault("vmScaleSetName")
  valid_594609 = validateParameter(valid_594609, JString, required = true,
                                 default = nil)
  if valid_594609 != nil:
    section.add "vmScaleSetName", valid_594609
  var valid_594610 = path.getOrDefault("resourceGroupName")
  valid_594610 = validateParameter(valid_594610, JString, required = true,
                                 default = nil)
  if valid_594610 != nil:
    section.add "resourceGroupName", valid_594610
  var valid_594611 = path.getOrDefault("subscriptionId")
  valid_594611 = validateParameter(valid_594611, JString, required = true,
                                 default = nil)
  if valid_594611 != nil:
    section.add "subscriptionId", valid_594611
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594612 = query.getOrDefault("api-version")
  valid_594612 = validateParameter(valid_594612, JString, required = true,
                                 default = nil)
  if valid_594612 != nil:
    section.add "api-version", valid_594612
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

proc call*(call_594614: Call_VirtualMachineScaleSetsPowerOff_594606;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Power off (stop) one or more virtual machines in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  let valid = call_594614.validator(path, query, header, formData, body)
  let scheme = call_594614.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594614.url(scheme.get, call_594614.host, call_594614.base,
                         call_594614.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594614, url, valid)

proc call*(call_594615: Call_VirtualMachineScaleSetsPowerOff_594606;
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
  var path_594616 = newJObject()
  var query_594617 = newJObject()
  var body_594618 = newJObject()
  add(path_594616, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594616, "resourceGroupName", newJString(resourceGroupName))
  add(query_594617, "api-version", newJString(apiVersion))
  add(path_594616, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_594618 = vmInstanceIDs
  result = call_594615.call(path_594616, query_594617, nil, nil, body_594618)

var virtualMachineScaleSetsPowerOff* = Call_VirtualMachineScaleSetsPowerOff_594606(
    name: "virtualMachineScaleSetsPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/poweroff",
    validator: validate_VirtualMachineScaleSetsPowerOff_594607, base: "",
    url: url_VirtualMachineScaleSetsPowerOff_594608, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsRedeploy_594619 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsRedeploy_594621(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsRedeploy_594620(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Redeploy one or more virtual machines in a VM scale set.
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
  var valid_594622 = path.getOrDefault("vmScaleSetName")
  valid_594622 = validateParameter(valid_594622, JString, required = true,
                                 default = nil)
  if valid_594622 != nil:
    section.add "vmScaleSetName", valid_594622
  var valid_594623 = path.getOrDefault("resourceGroupName")
  valid_594623 = validateParameter(valid_594623, JString, required = true,
                                 default = nil)
  if valid_594623 != nil:
    section.add "resourceGroupName", valid_594623
  var valid_594624 = path.getOrDefault("subscriptionId")
  valid_594624 = validateParameter(valid_594624, JString, required = true,
                                 default = nil)
  if valid_594624 != nil:
    section.add "subscriptionId", valid_594624
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594625 = query.getOrDefault("api-version")
  valid_594625 = validateParameter(valid_594625, JString, required = true,
                                 default = nil)
  if valid_594625 != nil:
    section.add "api-version", valid_594625
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

proc call*(call_594627: Call_VirtualMachineScaleSetsRedeploy_594619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Redeploy one or more virtual machines in a VM scale set.
  ## 
  let valid = call_594627.validator(path, query, header, formData, body)
  let scheme = call_594627.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594627.url(scheme.get, call_594627.host, call_594627.base,
                         call_594627.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594627, url, valid)

proc call*(call_594628: Call_VirtualMachineScaleSetsRedeploy_594619;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; vmInstanceIDs: JsonNode = nil): Recallable =
  ## virtualMachineScaleSetsRedeploy
  ## Redeploy one or more virtual machines in a VM scale set.
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
  var path_594629 = newJObject()
  var query_594630 = newJObject()
  var body_594631 = newJObject()
  add(path_594629, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594629, "resourceGroupName", newJString(resourceGroupName))
  add(query_594630, "api-version", newJString(apiVersion))
  add(path_594629, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_594631 = vmInstanceIDs
  result = call_594628.call(path_594629, query_594630, nil, nil, body_594631)

var virtualMachineScaleSetsRedeploy* = Call_VirtualMachineScaleSetsRedeploy_594619(
    name: "virtualMachineScaleSetsRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/redeploy",
    validator: validate_VirtualMachineScaleSetsRedeploy_594620, base: "",
    url: url_VirtualMachineScaleSetsRedeploy_594621, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsReimage_594632 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsReimage_594634(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsReimage_594633(path: JsonNode;
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
  var valid_594635 = path.getOrDefault("vmScaleSetName")
  valid_594635 = validateParameter(valid_594635, JString, required = true,
                                 default = nil)
  if valid_594635 != nil:
    section.add "vmScaleSetName", valid_594635
  var valid_594636 = path.getOrDefault("resourceGroupName")
  valid_594636 = validateParameter(valid_594636, JString, required = true,
                                 default = nil)
  if valid_594636 != nil:
    section.add "resourceGroupName", valid_594636
  var valid_594637 = path.getOrDefault("subscriptionId")
  valid_594637 = validateParameter(valid_594637, JString, required = true,
                                 default = nil)
  if valid_594637 != nil:
    section.add "subscriptionId", valid_594637
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594638 = query.getOrDefault("api-version")
  valid_594638 = validateParameter(valid_594638, JString, required = true,
                                 default = nil)
  if valid_594638 != nil:
    section.add "api-version", valid_594638
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

proc call*(call_594640: Call_VirtualMachineScaleSetsReimage_594632; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reimages (upgrade the operating system) one or more virtual machines in a VM scale set which don't have a ephemeral OS disk, for virtual machines who have a ephemeral OS disk the virtual machine is reset to initial state.
  ## 
  let valid = call_594640.validator(path, query, header, formData, body)
  let scheme = call_594640.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594640.url(scheme.get, call_594640.host, call_594640.base,
                         call_594640.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594640, url, valid)

proc call*(call_594641: Call_VirtualMachineScaleSetsReimage_594632;
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
  var path_594642 = newJObject()
  var query_594643 = newJObject()
  var body_594644 = newJObject()
  add(path_594642, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594642, "resourceGroupName", newJString(resourceGroupName))
  add(query_594643, "api-version", newJString(apiVersion))
  add(path_594642, "subscriptionId", newJString(subscriptionId))
  if vmScaleSetReimageInput != nil:
    body_594644 = vmScaleSetReimageInput
  result = call_594641.call(path_594642, query_594643, nil, nil, body_594644)

var virtualMachineScaleSetsReimage* = Call_VirtualMachineScaleSetsReimage_594632(
    name: "virtualMachineScaleSetsReimage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/reimage",
    validator: validate_VirtualMachineScaleSetsReimage_594633, base: "",
    url: url_VirtualMachineScaleSetsReimage_594634, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsReimageAll_594645 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsReimageAll_594647(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsReimageAll_594646(path: JsonNode;
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
  var valid_594648 = path.getOrDefault("vmScaleSetName")
  valid_594648 = validateParameter(valid_594648, JString, required = true,
                                 default = nil)
  if valid_594648 != nil:
    section.add "vmScaleSetName", valid_594648
  var valid_594649 = path.getOrDefault("resourceGroupName")
  valid_594649 = validateParameter(valid_594649, JString, required = true,
                                 default = nil)
  if valid_594649 != nil:
    section.add "resourceGroupName", valid_594649
  var valid_594650 = path.getOrDefault("subscriptionId")
  valid_594650 = validateParameter(valid_594650, JString, required = true,
                                 default = nil)
  if valid_594650 != nil:
    section.add "subscriptionId", valid_594650
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594651 = query.getOrDefault("api-version")
  valid_594651 = validateParameter(valid_594651, JString, required = true,
                                 default = nil)
  if valid_594651 != nil:
    section.add "api-version", valid_594651
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

proc call*(call_594653: Call_VirtualMachineScaleSetsReimageAll_594645;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reimages all the disks ( including data disks ) in the virtual machines in a VM scale set. This operation is only supported for managed disks.
  ## 
  let valid = call_594653.validator(path, query, header, formData, body)
  let scheme = call_594653.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594653.url(scheme.get, call_594653.host, call_594653.base,
                         call_594653.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594653, url, valid)

proc call*(call_594654: Call_VirtualMachineScaleSetsReimageAll_594645;
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
  var path_594655 = newJObject()
  var query_594656 = newJObject()
  var body_594657 = newJObject()
  add(path_594655, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594655, "resourceGroupName", newJString(resourceGroupName))
  add(query_594656, "api-version", newJString(apiVersion))
  add(path_594655, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_594657 = vmInstanceIDs
  result = call_594654.call(path_594655, query_594656, nil, nil, body_594657)

var virtualMachineScaleSetsReimageAll* = Call_VirtualMachineScaleSetsReimageAll_594645(
    name: "virtualMachineScaleSetsReimageAll", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/reimageall",
    validator: validate_VirtualMachineScaleSetsReimageAll_594646, base: "",
    url: url_VirtualMachineScaleSetsReimageAll_594647, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsRestart_594658 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsRestart_594660(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsRestart_594659(path: JsonNode;
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
  var valid_594661 = path.getOrDefault("vmScaleSetName")
  valid_594661 = validateParameter(valid_594661, JString, required = true,
                                 default = nil)
  if valid_594661 != nil:
    section.add "vmScaleSetName", valid_594661
  var valid_594662 = path.getOrDefault("resourceGroupName")
  valid_594662 = validateParameter(valid_594662, JString, required = true,
                                 default = nil)
  if valid_594662 != nil:
    section.add "resourceGroupName", valid_594662
  var valid_594663 = path.getOrDefault("subscriptionId")
  valid_594663 = validateParameter(valid_594663, JString, required = true,
                                 default = nil)
  if valid_594663 != nil:
    section.add "subscriptionId", valid_594663
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594664 = query.getOrDefault("api-version")
  valid_594664 = validateParameter(valid_594664, JString, required = true,
                                 default = nil)
  if valid_594664 != nil:
    section.add "api-version", valid_594664
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

proc call*(call_594666: Call_VirtualMachineScaleSetsRestart_594658; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts one or more virtual machines in a VM scale set.
  ## 
  let valid = call_594666.validator(path, query, header, formData, body)
  let scheme = call_594666.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594666.url(scheme.get, call_594666.host, call_594666.base,
                         call_594666.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594666, url, valid)

proc call*(call_594667: Call_VirtualMachineScaleSetsRestart_594658;
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
  var path_594668 = newJObject()
  var query_594669 = newJObject()
  var body_594670 = newJObject()
  add(path_594668, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594668, "resourceGroupName", newJString(resourceGroupName))
  add(query_594669, "api-version", newJString(apiVersion))
  add(path_594668, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_594670 = vmInstanceIDs
  result = call_594667.call(path_594668, query_594669, nil, nil, body_594670)

var virtualMachineScaleSetsRestart* = Call_VirtualMachineScaleSetsRestart_594658(
    name: "virtualMachineScaleSetsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/restart",
    validator: validate_VirtualMachineScaleSetsRestart_594659, base: "",
    url: url_VirtualMachineScaleSetsRestart_594660, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesCancel_594671 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetRollingUpgradesCancel_594673(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetRollingUpgradesCancel_594672(path: JsonNode;
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
  var valid_594674 = path.getOrDefault("vmScaleSetName")
  valid_594674 = validateParameter(valid_594674, JString, required = true,
                                 default = nil)
  if valid_594674 != nil:
    section.add "vmScaleSetName", valid_594674
  var valid_594675 = path.getOrDefault("resourceGroupName")
  valid_594675 = validateParameter(valid_594675, JString, required = true,
                                 default = nil)
  if valid_594675 != nil:
    section.add "resourceGroupName", valid_594675
  var valid_594676 = path.getOrDefault("subscriptionId")
  valid_594676 = validateParameter(valid_594676, JString, required = true,
                                 default = nil)
  if valid_594676 != nil:
    section.add "subscriptionId", valid_594676
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594677 = query.getOrDefault("api-version")
  valid_594677 = validateParameter(valid_594677, JString, required = true,
                                 default = nil)
  if valid_594677 != nil:
    section.add "api-version", valid_594677
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594678: Call_VirtualMachineScaleSetRollingUpgradesCancel_594671;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Cancels the current virtual machine scale set rolling upgrade.
  ## 
  let valid = call_594678.validator(path, query, header, formData, body)
  let scheme = call_594678.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594678.url(scheme.get, call_594678.host, call_594678.base,
                         call_594678.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594678, url, valid)

proc call*(call_594679: Call_VirtualMachineScaleSetRollingUpgradesCancel_594671;
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
  var path_594680 = newJObject()
  var query_594681 = newJObject()
  add(path_594680, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594680, "resourceGroupName", newJString(resourceGroupName))
  add(query_594681, "api-version", newJString(apiVersion))
  add(path_594680, "subscriptionId", newJString(subscriptionId))
  result = call_594679.call(path_594680, query_594681, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesCancel* = Call_VirtualMachineScaleSetRollingUpgradesCancel_594671(
    name: "virtualMachineScaleSetRollingUpgradesCancel",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/rollingUpgrades/cancel",
    validator: validate_VirtualMachineScaleSetRollingUpgradesCancel_594672,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesCancel_594673,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetRollingUpgradesGetLatest_594682 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetRollingUpgradesGetLatest_594684(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetRollingUpgradesGetLatest_594683(
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
  var valid_594685 = path.getOrDefault("vmScaleSetName")
  valid_594685 = validateParameter(valid_594685, JString, required = true,
                                 default = nil)
  if valid_594685 != nil:
    section.add "vmScaleSetName", valid_594685
  var valid_594686 = path.getOrDefault("resourceGroupName")
  valid_594686 = validateParameter(valid_594686, JString, required = true,
                                 default = nil)
  if valid_594686 != nil:
    section.add "resourceGroupName", valid_594686
  var valid_594687 = path.getOrDefault("subscriptionId")
  valid_594687 = validateParameter(valid_594687, JString, required = true,
                                 default = nil)
  if valid_594687 != nil:
    section.add "subscriptionId", valid_594687
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594688 = query.getOrDefault("api-version")
  valid_594688 = validateParameter(valid_594688, JString, required = true,
                                 default = nil)
  if valid_594688 != nil:
    section.add "api-version", valid_594688
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594689: Call_VirtualMachineScaleSetRollingUpgradesGetLatest_594682;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of the latest virtual machine scale set rolling upgrade.
  ## 
  let valid = call_594689.validator(path, query, header, formData, body)
  let scheme = call_594689.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594689.url(scheme.get, call_594689.host, call_594689.base,
                         call_594689.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594689, url, valid)

proc call*(call_594690: Call_VirtualMachineScaleSetRollingUpgradesGetLatest_594682;
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
  var path_594691 = newJObject()
  var query_594692 = newJObject()
  add(path_594691, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594691, "resourceGroupName", newJString(resourceGroupName))
  add(query_594692, "api-version", newJString(apiVersion))
  add(path_594691, "subscriptionId", newJString(subscriptionId))
  result = call_594690.call(path_594691, query_594692, nil, nil, nil)

var virtualMachineScaleSetRollingUpgradesGetLatest* = Call_VirtualMachineScaleSetRollingUpgradesGetLatest_594682(
    name: "virtualMachineScaleSetRollingUpgradesGetLatest",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/rollingUpgrades/latest",
    validator: validate_VirtualMachineScaleSetRollingUpgradesGetLatest_594683,
    base: "", url: url_VirtualMachineScaleSetRollingUpgradesGetLatest_594684,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsListSkus_594693 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsListSkus_594695(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsListSkus_594694(path: JsonNode;
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
  var valid_594696 = path.getOrDefault("vmScaleSetName")
  valid_594696 = validateParameter(valid_594696, JString, required = true,
                                 default = nil)
  if valid_594696 != nil:
    section.add "vmScaleSetName", valid_594696
  var valid_594697 = path.getOrDefault("resourceGroupName")
  valid_594697 = validateParameter(valid_594697, JString, required = true,
                                 default = nil)
  if valid_594697 != nil:
    section.add "resourceGroupName", valid_594697
  var valid_594698 = path.getOrDefault("subscriptionId")
  valid_594698 = validateParameter(valid_594698, JString, required = true,
                                 default = nil)
  if valid_594698 != nil:
    section.add "subscriptionId", valid_594698
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594699 = query.getOrDefault("api-version")
  valid_594699 = validateParameter(valid_594699, JString, required = true,
                                 default = nil)
  if valid_594699 != nil:
    section.add "api-version", valid_594699
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594700: Call_VirtualMachineScaleSetsListSkus_594693;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of SKUs available for your VM scale set, including the minimum and maximum VM instances allowed for each SKU.
  ## 
  let valid = call_594700.validator(path, query, header, formData, body)
  let scheme = call_594700.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594700.url(scheme.get, call_594700.host, call_594700.base,
                         call_594700.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594700, url, valid)

proc call*(call_594701: Call_VirtualMachineScaleSetsListSkus_594693;
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
  var path_594702 = newJObject()
  var query_594703 = newJObject()
  add(path_594702, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594702, "resourceGroupName", newJString(resourceGroupName))
  add(query_594703, "api-version", newJString(apiVersion))
  add(path_594702, "subscriptionId", newJString(subscriptionId))
  result = call_594701.call(path_594702, query_594703, nil, nil, nil)

var virtualMachineScaleSetsListSkus* = Call_VirtualMachineScaleSetsListSkus_594693(
    name: "virtualMachineScaleSetsListSkus", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/skus",
    validator: validate_VirtualMachineScaleSetsListSkus_594694, base: "",
    url: url_VirtualMachineScaleSetsListSkus_594695, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetsStart_594704 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetsStart_594706(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetsStart_594705(path: JsonNode; query: JsonNode;
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
  var valid_594707 = path.getOrDefault("vmScaleSetName")
  valid_594707 = validateParameter(valid_594707, JString, required = true,
                                 default = nil)
  if valid_594707 != nil:
    section.add "vmScaleSetName", valid_594707
  var valid_594708 = path.getOrDefault("resourceGroupName")
  valid_594708 = validateParameter(valid_594708, JString, required = true,
                                 default = nil)
  if valid_594708 != nil:
    section.add "resourceGroupName", valid_594708
  var valid_594709 = path.getOrDefault("subscriptionId")
  valid_594709 = validateParameter(valid_594709, JString, required = true,
                                 default = nil)
  if valid_594709 != nil:
    section.add "subscriptionId", valid_594709
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594710 = query.getOrDefault("api-version")
  valid_594710 = validateParameter(valid_594710, JString, required = true,
                                 default = nil)
  if valid_594710 != nil:
    section.add "api-version", valid_594710
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

proc call*(call_594712: Call_VirtualMachineScaleSetsStart_594704; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts one or more virtual machines in a VM scale set.
  ## 
  let valid = call_594712.validator(path, query, header, formData, body)
  let scheme = call_594712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594712.url(scheme.get, call_594712.host, call_594712.base,
                         call_594712.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594712, url, valid)

proc call*(call_594713: Call_VirtualMachineScaleSetsStart_594704;
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
  var path_594714 = newJObject()
  var query_594715 = newJObject()
  var body_594716 = newJObject()
  add(path_594714, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594714, "resourceGroupName", newJString(resourceGroupName))
  add(query_594715, "api-version", newJString(apiVersion))
  add(path_594714, "subscriptionId", newJString(subscriptionId))
  if vmInstanceIDs != nil:
    body_594716 = vmInstanceIDs
  result = call_594713.call(path_594714, query_594715, nil, nil, body_594716)

var virtualMachineScaleSetsStart* = Call_VirtualMachineScaleSetsStart_594704(
    name: "virtualMachineScaleSetsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/start",
    validator: validate_VirtualMachineScaleSetsStart_594705, base: "",
    url: url_VirtualMachineScaleSetsStart_594706, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsUpdate_594729 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetVMsUpdate_594731(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsUpdate_594730(path: JsonNode;
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
  var valid_594732 = path.getOrDefault("vmScaleSetName")
  valid_594732 = validateParameter(valid_594732, JString, required = true,
                                 default = nil)
  if valid_594732 != nil:
    section.add "vmScaleSetName", valid_594732
  var valid_594733 = path.getOrDefault("resourceGroupName")
  valid_594733 = validateParameter(valid_594733, JString, required = true,
                                 default = nil)
  if valid_594733 != nil:
    section.add "resourceGroupName", valid_594733
  var valid_594734 = path.getOrDefault("subscriptionId")
  valid_594734 = validateParameter(valid_594734, JString, required = true,
                                 default = nil)
  if valid_594734 != nil:
    section.add "subscriptionId", valid_594734
  var valid_594735 = path.getOrDefault("instanceId")
  valid_594735 = validateParameter(valid_594735, JString, required = true,
                                 default = nil)
  if valid_594735 != nil:
    section.add "instanceId", valid_594735
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594736 = query.getOrDefault("api-version")
  valid_594736 = validateParameter(valid_594736, JString, required = true,
                                 default = nil)
  if valid_594736 != nil:
    section.add "api-version", valid_594736
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

proc call*(call_594738: Call_VirtualMachineScaleSetVMsUpdate_594729;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a virtual machine of a VM scale set.
  ## 
  let valid = call_594738.validator(path, query, header, formData, body)
  let scheme = call_594738.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594738.url(scheme.get, call_594738.host, call_594738.base,
                         call_594738.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594738, url, valid)

proc call*(call_594739: Call_VirtualMachineScaleSetVMsUpdate_594729;
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
  var path_594740 = newJObject()
  var query_594741 = newJObject()
  var body_594742 = newJObject()
  add(path_594740, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594740, "resourceGroupName", newJString(resourceGroupName))
  add(query_594741, "api-version", newJString(apiVersion))
  add(path_594740, "subscriptionId", newJString(subscriptionId))
  add(path_594740, "instanceId", newJString(instanceId))
  if parameters != nil:
    body_594742 = parameters
  result = call_594739.call(path_594740, query_594741, nil, nil, body_594742)

var virtualMachineScaleSetVMsUpdate* = Call_VirtualMachineScaleSetVMsUpdate_594729(
    name: "virtualMachineScaleSetVMsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsUpdate_594730, base: "",
    url: url_VirtualMachineScaleSetVMsUpdate_594731, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsGet_594717 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetVMsGet_594719(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsGet_594718(path: JsonNode; query: JsonNode;
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
  var valid_594720 = path.getOrDefault("vmScaleSetName")
  valid_594720 = validateParameter(valid_594720, JString, required = true,
                                 default = nil)
  if valid_594720 != nil:
    section.add "vmScaleSetName", valid_594720
  var valid_594721 = path.getOrDefault("resourceGroupName")
  valid_594721 = validateParameter(valid_594721, JString, required = true,
                                 default = nil)
  if valid_594721 != nil:
    section.add "resourceGroupName", valid_594721
  var valid_594722 = path.getOrDefault("subscriptionId")
  valid_594722 = validateParameter(valid_594722, JString, required = true,
                                 default = nil)
  if valid_594722 != nil:
    section.add "subscriptionId", valid_594722
  var valid_594723 = path.getOrDefault("instanceId")
  valid_594723 = validateParameter(valid_594723, JString, required = true,
                                 default = nil)
  if valid_594723 != nil:
    section.add "instanceId", valid_594723
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594724 = query.getOrDefault("api-version")
  valid_594724 = validateParameter(valid_594724, JString, required = true,
                                 default = nil)
  if valid_594724 != nil:
    section.add "api-version", valid_594724
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594725: Call_VirtualMachineScaleSetVMsGet_594717; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a virtual machine from a VM scale set.
  ## 
  let valid = call_594725.validator(path, query, header, formData, body)
  let scheme = call_594725.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594725.url(scheme.get, call_594725.host, call_594725.base,
                         call_594725.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594725, url, valid)

proc call*(call_594726: Call_VirtualMachineScaleSetVMsGet_594717;
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
  var path_594727 = newJObject()
  var query_594728 = newJObject()
  add(path_594727, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594727, "resourceGroupName", newJString(resourceGroupName))
  add(query_594728, "api-version", newJString(apiVersion))
  add(path_594727, "subscriptionId", newJString(subscriptionId))
  add(path_594727, "instanceId", newJString(instanceId))
  result = call_594726.call(path_594727, query_594728, nil, nil, nil)

var virtualMachineScaleSetVMsGet* = Call_VirtualMachineScaleSetVMsGet_594717(
    name: "virtualMachineScaleSetVMsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsGet_594718, base: "",
    url: url_VirtualMachineScaleSetVMsGet_594719, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsDelete_594743 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetVMsDelete_594745(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsDelete_594744(path: JsonNode;
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
  var valid_594746 = path.getOrDefault("vmScaleSetName")
  valid_594746 = validateParameter(valid_594746, JString, required = true,
                                 default = nil)
  if valid_594746 != nil:
    section.add "vmScaleSetName", valid_594746
  var valid_594747 = path.getOrDefault("resourceGroupName")
  valid_594747 = validateParameter(valid_594747, JString, required = true,
                                 default = nil)
  if valid_594747 != nil:
    section.add "resourceGroupName", valid_594747
  var valid_594748 = path.getOrDefault("subscriptionId")
  valid_594748 = validateParameter(valid_594748, JString, required = true,
                                 default = nil)
  if valid_594748 != nil:
    section.add "subscriptionId", valid_594748
  var valid_594749 = path.getOrDefault("instanceId")
  valid_594749 = validateParameter(valid_594749, JString, required = true,
                                 default = nil)
  if valid_594749 != nil:
    section.add "instanceId", valid_594749
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594750 = query.getOrDefault("api-version")
  valid_594750 = validateParameter(valid_594750, JString, required = true,
                                 default = nil)
  if valid_594750 != nil:
    section.add "api-version", valid_594750
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594751: Call_VirtualMachineScaleSetVMsDelete_594743;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a virtual machine from a VM scale set.
  ## 
  let valid = call_594751.validator(path, query, header, formData, body)
  let scheme = call_594751.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594751.url(scheme.get, call_594751.host, call_594751.base,
                         call_594751.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594751, url, valid)

proc call*(call_594752: Call_VirtualMachineScaleSetVMsDelete_594743;
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
  var path_594753 = newJObject()
  var query_594754 = newJObject()
  add(path_594753, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594753, "resourceGroupName", newJString(resourceGroupName))
  add(query_594754, "api-version", newJString(apiVersion))
  add(path_594753, "subscriptionId", newJString(subscriptionId))
  add(path_594753, "instanceId", newJString(instanceId))
  result = call_594752.call(path_594753, query_594754, nil, nil, nil)

var virtualMachineScaleSetVMsDelete* = Call_VirtualMachineScaleSetVMsDelete_594743(
    name: "virtualMachineScaleSetVMsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}",
    validator: validate_VirtualMachineScaleSetVMsDelete_594744, base: "",
    url: url_VirtualMachineScaleSetVMsDelete_594745, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsDeallocate_594755 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetVMsDeallocate_594757(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsDeallocate_594756(path: JsonNode;
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
  var valid_594758 = path.getOrDefault("vmScaleSetName")
  valid_594758 = validateParameter(valid_594758, JString, required = true,
                                 default = nil)
  if valid_594758 != nil:
    section.add "vmScaleSetName", valid_594758
  var valid_594759 = path.getOrDefault("resourceGroupName")
  valid_594759 = validateParameter(valid_594759, JString, required = true,
                                 default = nil)
  if valid_594759 != nil:
    section.add "resourceGroupName", valid_594759
  var valid_594760 = path.getOrDefault("subscriptionId")
  valid_594760 = validateParameter(valid_594760, JString, required = true,
                                 default = nil)
  if valid_594760 != nil:
    section.add "subscriptionId", valid_594760
  var valid_594761 = path.getOrDefault("instanceId")
  valid_594761 = validateParameter(valid_594761, JString, required = true,
                                 default = nil)
  if valid_594761 != nil:
    section.add "instanceId", valid_594761
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594762 = query.getOrDefault("api-version")
  valid_594762 = validateParameter(valid_594762, JString, required = true,
                                 default = nil)
  if valid_594762 != nil:
    section.add "api-version", valid_594762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594763: Call_VirtualMachineScaleSetVMsDeallocate_594755;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deallocates a specific virtual machine in a VM scale set. Shuts down the virtual machine and releases the compute resources it uses. You are not billed for the compute resources of this virtual machine once it is deallocated.
  ## 
  let valid = call_594763.validator(path, query, header, formData, body)
  let scheme = call_594763.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594763.url(scheme.get, call_594763.host, call_594763.base,
                         call_594763.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594763, url, valid)

proc call*(call_594764: Call_VirtualMachineScaleSetVMsDeallocate_594755;
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
  var path_594765 = newJObject()
  var query_594766 = newJObject()
  add(path_594765, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594765, "resourceGroupName", newJString(resourceGroupName))
  add(query_594766, "api-version", newJString(apiVersion))
  add(path_594765, "subscriptionId", newJString(subscriptionId))
  add(path_594765, "instanceId", newJString(instanceId))
  result = call_594764.call(path_594765, query_594766, nil, nil, nil)

var virtualMachineScaleSetVMsDeallocate* = Call_VirtualMachineScaleSetVMsDeallocate_594755(
    name: "virtualMachineScaleSetVMsDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/deallocate",
    validator: validate_VirtualMachineScaleSetVMsDeallocate_594756, base: "",
    url: url_VirtualMachineScaleSetVMsDeallocate_594757, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsGetInstanceView_594767 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetVMsGetInstanceView_594769(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetVMsGetInstanceView_594768(path: JsonNode;
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
  var valid_594770 = path.getOrDefault("vmScaleSetName")
  valid_594770 = validateParameter(valid_594770, JString, required = true,
                                 default = nil)
  if valid_594770 != nil:
    section.add "vmScaleSetName", valid_594770
  var valid_594771 = path.getOrDefault("resourceGroupName")
  valid_594771 = validateParameter(valid_594771, JString, required = true,
                                 default = nil)
  if valid_594771 != nil:
    section.add "resourceGroupName", valid_594771
  var valid_594772 = path.getOrDefault("subscriptionId")
  valid_594772 = validateParameter(valid_594772, JString, required = true,
                                 default = nil)
  if valid_594772 != nil:
    section.add "subscriptionId", valid_594772
  var valid_594773 = path.getOrDefault("instanceId")
  valid_594773 = validateParameter(valid_594773, JString, required = true,
                                 default = nil)
  if valid_594773 != nil:
    section.add "instanceId", valid_594773
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594774 = query.getOrDefault("api-version")
  valid_594774 = validateParameter(valid_594774, JString, required = true,
                                 default = nil)
  if valid_594774 != nil:
    section.add "api-version", valid_594774
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594775: Call_VirtualMachineScaleSetVMsGetInstanceView_594767;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status of a virtual machine from a VM scale set.
  ## 
  let valid = call_594775.validator(path, query, header, formData, body)
  let scheme = call_594775.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594775.url(scheme.get, call_594775.host, call_594775.base,
                         call_594775.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594775, url, valid)

proc call*(call_594776: Call_VirtualMachineScaleSetVMsGetInstanceView_594767;
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
  var path_594777 = newJObject()
  var query_594778 = newJObject()
  add(path_594777, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594777, "resourceGroupName", newJString(resourceGroupName))
  add(query_594778, "api-version", newJString(apiVersion))
  add(path_594777, "subscriptionId", newJString(subscriptionId))
  add(path_594777, "instanceId", newJString(instanceId))
  result = call_594776.call(path_594777, query_594778, nil, nil, nil)

var virtualMachineScaleSetVMsGetInstanceView* = Call_VirtualMachineScaleSetVMsGetInstanceView_594767(
    name: "virtualMachineScaleSetVMsGetInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/instanceView",
    validator: validate_VirtualMachineScaleSetVMsGetInstanceView_594768, base: "",
    url: url_VirtualMachineScaleSetVMsGetInstanceView_594769,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsPerformMaintenance_594779 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetVMsPerformMaintenance_594781(protocol: Scheme;
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

proc validate_VirtualMachineScaleSetVMsPerformMaintenance_594780(path: JsonNode;
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
  var valid_594782 = path.getOrDefault("vmScaleSetName")
  valid_594782 = validateParameter(valid_594782, JString, required = true,
                                 default = nil)
  if valid_594782 != nil:
    section.add "vmScaleSetName", valid_594782
  var valid_594783 = path.getOrDefault("resourceGroupName")
  valid_594783 = validateParameter(valid_594783, JString, required = true,
                                 default = nil)
  if valid_594783 != nil:
    section.add "resourceGroupName", valid_594783
  var valid_594784 = path.getOrDefault("subscriptionId")
  valid_594784 = validateParameter(valid_594784, JString, required = true,
                                 default = nil)
  if valid_594784 != nil:
    section.add "subscriptionId", valid_594784
  var valid_594785 = path.getOrDefault("instanceId")
  valid_594785 = validateParameter(valid_594785, JString, required = true,
                                 default = nil)
  if valid_594785 != nil:
    section.add "instanceId", valid_594785
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594786 = query.getOrDefault("api-version")
  valid_594786 = validateParameter(valid_594786, JString, required = true,
                                 default = nil)
  if valid_594786 != nil:
    section.add "api-version", valid_594786
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594787: Call_VirtualMachineScaleSetVMsPerformMaintenance_594779;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Performs maintenance on a virtual machine in a VM scale set.
  ## 
  let valid = call_594787.validator(path, query, header, formData, body)
  let scheme = call_594787.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594787.url(scheme.get, call_594787.host, call_594787.base,
                         call_594787.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594787, url, valid)

proc call*(call_594788: Call_VirtualMachineScaleSetVMsPerformMaintenance_594779;
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
  var path_594789 = newJObject()
  var query_594790 = newJObject()
  add(path_594789, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594789, "resourceGroupName", newJString(resourceGroupName))
  add(query_594790, "api-version", newJString(apiVersion))
  add(path_594789, "subscriptionId", newJString(subscriptionId))
  add(path_594789, "instanceId", newJString(instanceId))
  result = call_594788.call(path_594789, query_594790, nil, nil, nil)

var virtualMachineScaleSetVMsPerformMaintenance* = Call_VirtualMachineScaleSetVMsPerformMaintenance_594779(
    name: "virtualMachineScaleSetVMsPerformMaintenance",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/performMaintenance",
    validator: validate_VirtualMachineScaleSetVMsPerformMaintenance_594780,
    base: "", url: url_VirtualMachineScaleSetVMsPerformMaintenance_594781,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsPowerOff_594791 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetVMsPowerOff_594793(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsPowerOff_594792(path: JsonNode;
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
  var valid_594794 = path.getOrDefault("vmScaleSetName")
  valid_594794 = validateParameter(valid_594794, JString, required = true,
                                 default = nil)
  if valid_594794 != nil:
    section.add "vmScaleSetName", valid_594794
  var valid_594795 = path.getOrDefault("resourceGroupName")
  valid_594795 = validateParameter(valid_594795, JString, required = true,
                                 default = nil)
  if valid_594795 != nil:
    section.add "resourceGroupName", valid_594795
  var valid_594796 = path.getOrDefault("subscriptionId")
  valid_594796 = validateParameter(valid_594796, JString, required = true,
                                 default = nil)
  if valid_594796 != nil:
    section.add "subscriptionId", valid_594796
  var valid_594797 = path.getOrDefault("instanceId")
  valid_594797 = validateParameter(valid_594797, JString, required = true,
                                 default = nil)
  if valid_594797 != nil:
    section.add "instanceId", valid_594797
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594798 = query.getOrDefault("api-version")
  valid_594798 = validateParameter(valid_594798, JString, required = true,
                                 default = nil)
  if valid_594798 != nil:
    section.add "api-version", valid_594798
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594799: Call_VirtualMachineScaleSetVMsPowerOff_594791;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Power off (stop) a virtual machine in a VM scale set. Note that resources are still attached and you are getting charged for the resources. Instead, use deallocate to release resources and avoid charges.
  ## 
  let valid = call_594799.validator(path, query, header, formData, body)
  let scheme = call_594799.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594799.url(scheme.get, call_594799.host, call_594799.base,
                         call_594799.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594799, url, valid)

proc call*(call_594800: Call_VirtualMachineScaleSetVMsPowerOff_594791;
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
  var path_594801 = newJObject()
  var query_594802 = newJObject()
  add(path_594801, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594801, "resourceGroupName", newJString(resourceGroupName))
  add(query_594802, "api-version", newJString(apiVersion))
  add(path_594801, "subscriptionId", newJString(subscriptionId))
  add(path_594801, "instanceId", newJString(instanceId))
  result = call_594800.call(path_594801, query_594802, nil, nil, nil)

var virtualMachineScaleSetVMsPowerOff* = Call_VirtualMachineScaleSetVMsPowerOff_594791(
    name: "virtualMachineScaleSetVMsPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/poweroff",
    validator: validate_VirtualMachineScaleSetVMsPowerOff_594792, base: "",
    url: url_VirtualMachineScaleSetVMsPowerOff_594793, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsRedeploy_594803 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetVMsRedeploy_594805(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsRedeploy_594804(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Redeploys a virtual machine in a VM scale set.
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
  var valid_594806 = path.getOrDefault("vmScaleSetName")
  valid_594806 = validateParameter(valid_594806, JString, required = true,
                                 default = nil)
  if valid_594806 != nil:
    section.add "vmScaleSetName", valid_594806
  var valid_594807 = path.getOrDefault("resourceGroupName")
  valid_594807 = validateParameter(valid_594807, JString, required = true,
                                 default = nil)
  if valid_594807 != nil:
    section.add "resourceGroupName", valid_594807
  var valid_594808 = path.getOrDefault("subscriptionId")
  valid_594808 = validateParameter(valid_594808, JString, required = true,
                                 default = nil)
  if valid_594808 != nil:
    section.add "subscriptionId", valid_594808
  var valid_594809 = path.getOrDefault("instanceId")
  valid_594809 = validateParameter(valid_594809, JString, required = true,
                                 default = nil)
  if valid_594809 != nil:
    section.add "instanceId", valid_594809
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594810 = query.getOrDefault("api-version")
  valid_594810 = validateParameter(valid_594810, JString, required = true,
                                 default = nil)
  if valid_594810 != nil:
    section.add "api-version", valid_594810
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594811: Call_VirtualMachineScaleSetVMsRedeploy_594803;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Redeploys a virtual machine in a VM scale set.
  ## 
  let valid = call_594811.validator(path, query, header, formData, body)
  let scheme = call_594811.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594811.url(scheme.get, call_594811.host, call_594811.base,
                         call_594811.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594811, url, valid)

proc call*(call_594812: Call_VirtualMachineScaleSetVMsRedeploy_594803;
          vmScaleSetName: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; instanceId: string): Recallable =
  ## virtualMachineScaleSetVMsRedeploy
  ## Redeploys a virtual machine in a VM scale set.
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
  var path_594813 = newJObject()
  var query_594814 = newJObject()
  add(path_594813, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594813, "resourceGroupName", newJString(resourceGroupName))
  add(query_594814, "api-version", newJString(apiVersion))
  add(path_594813, "subscriptionId", newJString(subscriptionId))
  add(path_594813, "instanceId", newJString(instanceId))
  result = call_594812.call(path_594813, query_594814, nil, nil, nil)

var virtualMachineScaleSetVMsRedeploy* = Call_VirtualMachineScaleSetVMsRedeploy_594803(
    name: "virtualMachineScaleSetVMsRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/redeploy",
    validator: validate_VirtualMachineScaleSetVMsRedeploy_594804, base: "",
    url: url_VirtualMachineScaleSetVMsRedeploy_594805, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsReimage_594815 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetVMsReimage_594817(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsReimage_594816(path: JsonNode;
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
  var valid_594818 = path.getOrDefault("vmScaleSetName")
  valid_594818 = validateParameter(valid_594818, JString, required = true,
                                 default = nil)
  if valid_594818 != nil:
    section.add "vmScaleSetName", valid_594818
  var valid_594819 = path.getOrDefault("resourceGroupName")
  valid_594819 = validateParameter(valid_594819, JString, required = true,
                                 default = nil)
  if valid_594819 != nil:
    section.add "resourceGroupName", valid_594819
  var valid_594820 = path.getOrDefault("subscriptionId")
  valid_594820 = validateParameter(valid_594820, JString, required = true,
                                 default = nil)
  if valid_594820 != nil:
    section.add "subscriptionId", valid_594820
  var valid_594821 = path.getOrDefault("instanceId")
  valid_594821 = validateParameter(valid_594821, JString, required = true,
                                 default = nil)
  if valid_594821 != nil:
    section.add "instanceId", valid_594821
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594822 = query.getOrDefault("api-version")
  valid_594822 = validateParameter(valid_594822, JString, required = true,
                                 default = nil)
  if valid_594822 != nil:
    section.add "api-version", valid_594822
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

proc call*(call_594824: Call_VirtualMachineScaleSetVMsReimage_594815;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reimages (upgrade the operating system) a specific virtual machine in a VM scale set.
  ## 
  let valid = call_594824.validator(path, query, header, formData, body)
  let scheme = call_594824.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594824.url(scheme.get, call_594824.host, call_594824.base,
                         call_594824.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594824, url, valid)

proc call*(call_594825: Call_VirtualMachineScaleSetVMsReimage_594815;
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
  var path_594826 = newJObject()
  var query_594827 = newJObject()
  var body_594828 = newJObject()
  add(path_594826, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594826, "resourceGroupName", newJString(resourceGroupName))
  add(query_594827, "api-version", newJString(apiVersion))
  add(path_594826, "subscriptionId", newJString(subscriptionId))
  add(path_594826, "instanceId", newJString(instanceId))
  if vmScaleSetVMReimageInput != nil:
    body_594828 = vmScaleSetVMReimageInput
  result = call_594825.call(path_594826, query_594827, nil, nil, body_594828)

var virtualMachineScaleSetVMsReimage* = Call_VirtualMachineScaleSetVMsReimage_594815(
    name: "virtualMachineScaleSetVMsReimage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/reimage",
    validator: validate_VirtualMachineScaleSetVMsReimage_594816, base: "",
    url: url_VirtualMachineScaleSetVMsReimage_594817, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsReimageAll_594829 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetVMsReimageAll_594831(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsReimageAll_594830(path: JsonNode;
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
  var valid_594832 = path.getOrDefault("vmScaleSetName")
  valid_594832 = validateParameter(valid_594832, JString, required = true,
                                 default = nil)
  if valid_594832 != nil:
    section.add "vmScaleSetName", valid_594832
  var valid_594833 = path.getOrDefault("resourceGroupName")
  valid_594833 = validateParameter(valid_594833, JString, required = true,
                                 default = nil)
  if valid_594833 != nil:
    section.add "resourceGroupName", valid_594833
  var valid_594834 = path.getOrDefault("subscriptionId")
  valid_594834 = validateParameter(valid_594834, JString, required = true,
                                 default = nil)
  if valid_594834 != nil:
    section.add "subscriptionId", valid_594834
  var valid_594835 = path.getOrDefault("instanceId")
  valid_594835 = validateParameter(valid_594835, JString, required = true,
                                 default = nil)
  if valid_594835 != nil:
    section.add "instanceId", valid_594835
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594836 = query.getOrDefault("api-version")
  valid_594836 = validateParameter(valid_594836, JString, required = true,
                                 default = nil)
  if valid_594836 != nil:
    section.add "api-version", valid_594836
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594837: Call_VirtualMachineScaleSetVMsReimageAll_594829;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Allows you to re-image all the disks ( including data disks ) in the a VM scale set instance. This operation is only supported for managed disks.
  ## 
  let valid = call_594837.validator(path, query, header, formData, body)
  let scheme = call_594837.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594837.url(scheme.get, call_594837.host, call_594837.base,
                         call_594837.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594837, url, valid)

proc call*(call_594838: Call_VirtualMachineScaleSetVMsReimageAll_594829;
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
  var path_594839 = newJObject()
  var query_594840 = newJObject()
  add(path_594839, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594839, "resourceGroupName", newJString(resourceGroupName))
  add(query_594840, "api-version", newJString(apiVersion))
  add(path_594839, "subscriptionId", newJString(subscriptionId))
  add(path_594839, "instanceId", newJString(instanceId))
  result = call_594838.call(path_594839, query_594840, nil, nil, nil)

var virtualMachineScaleSetVMsReimageAll* = Call_VirtualMachineScaleSetVMsReimageAll_594829(
    name: "virtualMachineScaleSetVMsReimageAll", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/reimageall",
    validator: validate_VirtualMachineScaleSetVMsReimageAll_594830, base: "",
    url: url_VirtualMachineScaleSetVMsReimageAll_594831, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsRestart_594841 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetVMsRestart_594843(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsRestart_594842(path: JsonNode;
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
  var valid_594844 = path.getOrDefault("vmScaleSetName")
  valid_594844 = validateParameter(valid_594844, JString, required = true,
                                 default = nil)
  if valid_594844 != nil:
    section.add "vmScaleSetName", valid_594844
  var valid_594845 = path.getOrDefault("resourceGroupName")
  valid_594845 = validateParameter(valid_594845, JString, required = true,
                                 default = nil)
  if valid_594845 != nil:
    section.add "resourceGroupName", valid_594845
  var valid_594846 = path.getOrDefault("subscriptionId")
  valid_594846 = validateParameter(valid_594846, JString, required = true,
                                 default = nil)
  if valid_594846 != nil:
    section.add "subscriptionId", valid_594846
  var valid_594847 = path.getOrDefault("instanceId")
  valid_594847 = validateParameter(valid_594847, JString, required = true,
                                 default = nil)
  if valid_594847 != nil:
    section.add "instanceId", valid_594847
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594848 = query.getOrDefault("api-version")
  valid_594848 = validateParameter(valid_594848, JString, required = true,
                                 default = nil)
  if valid_594848 != nil:
    section.add "api-version", valid_594848
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594849: Call_VirtualMachineScaleSetVMsRestart_594841;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Restarts a virtual machine in a VM scale set.
  ## 
  let valid = call_594849.validator(path, query, header, formData, body)
  let scheme = call_594849.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594849.url(scheme.get, call_594849.host, call_594849.base,
                         call_594849.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594849, url, valid)

proc call*(call_594850: Call_VirtualMachineScaleSetVMsRestart_594841;
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
  var path_594851 = newJObject()
  var query_594852 = newJObject()
  add(path_594851, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594851, "resourceGroupName", newJString(resourceGroupName))
  add(query_594852, "api-version", newJString(apiVersion))
  add(path_594851, "subscriptionId", newJString(subscriptionId))
  add(path_594851, "instanceId", newJString(instanceId))
  result = call_594850.call(path_594851, query_594852, nil, nil, nil)

var virtualMachineScaleSetVMsRestart* = Call_VirtualMachineScaleSetVMsRestart_594841(
    name: "virtualMachineScaleSetVMsRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/restart",
    validator: validate_VirtualMachineScaleSetVMsRestart_594842, base: "",
    url: url_VirtualMachineScaleSetVMsRestart_594843, schemes: {Scheme.Https})
type
  Call_VirtualMachineScaleSetVMsStart_594853 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineScaleSetVMsStart_594855(protocol: Scheme; host: string;
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

proc validate_VirtualMachineScaleSetVMsStart_594854(path: JsonNode;
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
  var valid_594856 = path.getOrDefault("vmScaleSetName")
  valid_594856 = validateParameter(valid_594856, JString, required = true,
                                 default = nil)
  if valid_594856 != nil:
    section.add "vmScaleSetName", valid_594856
  var valid_594857 = path.getOrDefault("resourceGroupName")
  valid_594857 = validateParameter(valid_594857, JString, required = true,
                                 default = nil)
  if valid_594857 != nil:
    section.add "resourceGroupName", valid_594857
  var valid_594858 = path.getOrDefault("subscriptionId")
  valid_594858 = validateParameter(valid_594858, JString, required = true,
                                 default = nil)
  if valid_594858 != nil:
    section.add "subscriptionId", valid_594858
  var valid_594859 = path.getOrDefault("instanceId")
  valid_594859 = validateParameter(valid_594859, JString, required = true,
                                 default = nil)
  if valid_594859 != nil:
    section.add "instanceId", valid_594859
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594860 = query.getOrDefault("api-version")
  valid_594860 = validateParameter(valid_594860, JString, required = true,
                                 default = nil)
  if valid_594860 != nil:
    section.add "api-version", valid_594860
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594861: Call_VirtualMachineScaleSetVMsStart_594853; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a virtual machine in a VM scale set.
  ## 
  let valid = call_594861.validator(path, query, header, formData, body)
  let scheme = call_594861.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594861.url(scheme.get, call_594861.host, call_594861.base,
                         call_594861.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594861, url, valid)

proc call*(call_594862: Call_VirtualMachineScaleSetVMsStart_594853;
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
  var path_594863 = newJObject()
  var query_594864 = newJObject()
  add(path_594863, "vmScaleSetName", newJString(vmScaleSetName))
  add(path_594863, "resourceGroupName", newJString(resourceGroupName))
  add(query_594864, "api-version", newJString(apiVersion))
  add(path_594863, "subscriptionId", newJString(subscriptionId))
  add(path_594863, "instanceId", newJString(instanceId))
  result = call_594862.call(path_594863, query_594864, nil, nil, nil)

var virtualMachineScaleSetVMsStart* = Call_VirtualMachineScaleSetVMsStart_594853(
    name: "virtualMachineScaleSetVMsStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{vmScaleSetName}/virtualmachines/{instanceId}/start",
    validator: validate_VirtualMachineScaleSetVMsStart_594854, base: "",
    url: url_VirtualMachineScaleSetVMsStart_594855, schemes: {Scheme.Https})
type
  Call_VirtualMachinesList_594865 = ref object of OpenApiRestCall_593438
proc url_VirtualMachinesList_594867(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesList_594866(path: JsonNode; query: JsonNode;
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
  var valid_594868 = path.getOrDefault("resourceGroupName")
  valid_594868 = validateParameter(valid_594868, JString, required = true,
                                 default = nil)
  if valid_594868 != nil:
    section.add "resourceGroupName", valid_594868
  var valid_594869 = path.getOrDefault("subscriptionId")
  valid_594869 = validateParameter(valid_594869, JString, required = true,
                                 default = nil)
  if valid_594869 != nil:
    section.add "subscriptionId", valid_594869
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594870 = query.getOrDefault("api-version")
  valid_594870 = validateParameter(valid_594870, JString, required = true,
                                 default = nil)
  if valid_594870 != nil:
    section.add "api-version", valid_594870
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594871: Call_VirtualMachinesList_594865; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the virtual machines in the specified resource group. Use the nextLink property in the response to get the next page of virtual machines.
  ## 
  let valid = call_594871.validator(path, query, header, formData, body)
  let scheme = call_594871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594871.url(scheme.get, call_594871.host, call_594871.base,
                         call_594871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594871, url, valid)

proc call*(call_594872: Call_VirtualMachinesList_594865; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## virtualMachinesList
  ## Lists all of the virtual machines in the specified resource group. Use the nextLink property in the response to get the next page of virtual machines.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594873 = newJObject()
  var query_594874 = newJObject()
  add(path_594873, "resourceGroupName", newJString(resourceGroupName))
  add(query_594874, "api-version", newJString(apiVersion))
  add(path_594873, "subscriptionId", newJString(subscriptionId))
  result = call_594872.call(path_594873, query_594874, nil, nil, nil)

var virtualMachinesList* = Call_VirtualMachinesList_594865(
    name: "virtualMachinesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines",
    validator: validate_VirtualMachinesList_594866, base: "",
    url: url_VirtualMachinesList_594867, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCreateOrUpdate_594900 = ref object of OpenApiRestCall_593438
proc url_VirtualMachinesCreateOrUpdate_594902(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesCreateOrUpdate_594901(path: JsonNode; query: JsonNode;
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
  var valid_594903 = path.getOrDefault("resourceGroupName")
  valid_594903 = validateParameter(valid_594903, JString, required = true,
                                 default = nil)
  if valid_594903 != nil:
    section.add "resourceGroupName", valid_594903
  var valid_594904 = path.getOrDefault("subscriptionId")
  valid_594904 = validateParameter(valid_594904, JString, required = true,
                                 default = nil)
  if valid_594904 != nil:
    section.add "subscriptionId", valid_594904
  var valid_594905 = path.getOrDefault("vmName")
  valid_594905 = validateParameter(valid_594905, JString, required = true,
                                 default = nil)
  if valid_594905 != nil:
    section.add "vmName", valid_594905
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594906 = query.getOrDefault("api-version")
  valid_594906 = validateParameter(valid_594906, JString, required = true,
                                 default = nil)
  if valid_594906 != nil:
    section.add "api-version", valid_594906
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

proc call*(call_594908: Call_VirtualMachinesCreateOrUpdate_594900; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to create or update a virtual machine.
  ## 
  let valid = call_594908.validator(path, query, header, formData, body)
  let scheme = call_594908.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594908.url(scheme.get, call_594908.host, call_594908.base,
                         call_594908.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594908, url, valid)

proc call*(call_594909: Call_VirtualMachinesCreateOrUpdate_594900;
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
  var path_594910 = newJObject()
  var query_594911 = newJObject()
  var body_594912 = newJObject()
  add(path_594910, "resourceGroupName", newJString(resourceGroupName))
  add(query_594911, "api-version", newJString(apiVersion))
  add(path_594910, "subscriptionId", newJString(subscriptionId))
  add(path_594910, "vmName", newJString(vmName))
  if parameters != nil:
    body_594912 = parameters
  result = call_594909.call(path_594910, query_594911, nil, nil, body_594912)

var virtualMachinesCreateOrUpdate* = Call_VirtualMachinesCreateOrUpdate_594900(
    name: "virtualMachinesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesCreateOrUpdate_594901, base: "",
    url: url_VirtualMachinesCreateOrUpdate_594902, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGet_594875 = ref object of OpenApiRestCall_593438
proc url_VirtualMachinesGet_594877(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesGet_594876(path: JsonNode; query: JsonNode;
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
  var valid_594878 = path.getOrDefault("resourceGroupName")
  valid_594878 = validateParameter(valid_594878, JString, required = true,
                                 default = nil)
  if valid_594878 != nil:
    section.add "resourceGroupName", valid_594878
  var valid_594879 = path.getOrDefault("subscriptionId")
  valid_594879 = validateParameter(valid_594879, JString, required = true,
                                 default = nil)
  if valid_594879 != nil:
    section.add "subscriptionId", valid_594879
  var valid_594880 = path.getOrDefault("vmName")
  valid_594880 = validateParameter(valid_594880, JString, required = true,
                                 default = nil)
  if valid_594880 != nil:
    section.add "vmName", valid_594880
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_594894 = query.getOrDefault("$expand")
  valid_594894 = validateParameter(valid_594894, JString, required = false,
                                 default = newJString("instanceView"))
  if valid_594894 != nil:
    section.add "$expand", valid_594894
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594895 = query.getOrDefault("api-version")
  valid_594895 = validateParameter(valid_594895, JString, required = true,
                                 default = nil)
  if valid_594895 != nil:
    section.add "api-version", valid_594895
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594896: Call_VirtualMachinesGet_594875; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the model view or the instance view of a virtual machine.
  ## 
  let valid = call_594896.validator(path, query, header, formData, body)
  let scheme = call_594896.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594896.url(scheme.get, call_594896.host, call_594896.base,
                         call_594896.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594896, url, valid)

proc call*(call_594897: Call_VirtualMachinesGet_594875; resourceGroupName: string;
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
  var path_594898 = newJObject()
  var query_594899 = newJObject()
  add(path_594898, "resourceGroupName", newJString(resourceGroupName))
  add(query_594899, "$expand", newJString(Expand))
  add(query_594899, "api-version", newJString(apiVersion))
  add(path_594898, "subscriptionId", newJString(subscriptionId))
  add(path_594898, "vmName", newJString(vmName))
  result = call_594897.call(path_594898, query_594899, nil, nil, nil)

var virtualMachinesGet* = Call_VirtualMachinesGet_594875(
    name: "virtualMachinesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesGet_594876, base: "",
    url: url_VirtualMachinesGet_594877, schemes: {Scheme.Https})
type
  Call_VirtualMachinesUpdate_594924 = ref object of OpenApiRestCall_593438
proc url_VirtualMachinesUpdate_594926(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesUpdate_594925(path: JsonNode; query: JsonNode;
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
  var valid_594927 = path.getOrDefault("resourceGroupName")
  valid_594927 = validateParameter(valid_594927, JString, required = true,
                                 default = nil)
  if valid_594927 != nil:
    section.add "resourceGroupName", valid_594927
  var valid_594928 = path.getOrDefault("subscriptionId")
  valid_594928 = validateParameter(valid_594928, JString, required = true,
                                 default = nil)
  if valid_594928 != nil:
    section.add "subscriptionId", valid_594928
  var valid_594929 = path.getOrDefault("vmName")
  valid_594929 = validateParameter(valid_594929, JString, required = true,
                                 default = nil)
  if valid_594929 != nil:
    section.add "vmName", valid_594929
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594930 = query.getOrDefault("api-version")
  valid_594930 = validateParameter(valid_594930, JString, required = true,
                                 default = nil)
  if valid_594930 != nil:
    section.add "api-version", valid_594930
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

proc call*(call_594932: Call_VirtualMachinesUpdate_594924; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update a virtual machine.
  ## 
  let valid = call_594932.validator(path, query, header, formData, body)
  let scheme = call_594932.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594932.url(scheme.get, call_594932.host, call_594932.base,
                         call_594932.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594932, url, valid)

proc call*(call_594933: Call_VirtualMachinesUpdate_594924;
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
  var path_594934 = newJObject()
  var query_594935 = newJObject()
  var body_594936 = newJObject()
  add(path_594934, "resourceGroupName", newJString(resourceGroupName))
  add(query_594935, "api-version", newJString(apiVersion))
  add(path_594934, "subscriptionId", newJString(subscriptionId))
  add(path_594934, "vmName", newJString(vmName))
  if parameters != nil:
    body_594936 = parameters
  result = call_594933.call(path_594934, query_594935, nil, nil, body_594936)

var virtualMachinesUpdate* = Call_VirtualMachinesUpdate_594924(
    name: "virtualMachinesUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesUpdate_594925, base: "",
    url: url_VirtualMachinesUpdate_594926, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDelete_594913 = ref object of OpenApiRestCall_593438
proc url_VirtualMachinesDelete_594915(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesDelete_594914(path: JsonNode; query: JsonNode;
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
  var valid_594916 = path.getOrDefault("resourceGroupName")
  valid_594916 = validateParameter(valid_594916, JString, required = true,
                                 default = nil)
  if valid_594916 != nil:
    section.add "resourceGroupName", valid_594916
  var valid_594917 = path.getOrDefault("subscriptionId")
  valid_594917 = validateParameter(valid_594917, JString, required = true,
                                 default = nil)
  if valid_594917 != nil:
    section.add "subscriptionId", valid_594917
  var valid_594918 = path.getOrDefault("vmName")
  valid_594918 = validateParameter(valid_594918, JString, required = true,
                                 default = nil)
  if valid_594918 != nil:
    section.add "vmName", valid_594918
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594919 = query.getOrDefault("api-version")
  valid_594919 = validateParameter(valid_594919, JString, required = true,
                                 default = nil)
  if valid_594919 != nil:
    section.add "api-version", valid_594919
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594920: Call_VirtualMachinesDelete_594913; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete a virtual machine.
  ## 
  let valid = call_594920.validator(path, query, header, formData, body)
  let scheme = call_594920.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594920.url(scheme.get, call_594920.host, call_594920.base,
                         call_594920.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594920, url, valid)

proc call*(call_594921: Call_VirtualMachinesDelete_594913;
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
  var path_594922 = newJObject()
  var query_594923 = newJObject()
  add(path_594922, "resourceGroupName", newJString(resourceGroupName))
  add(query_594923, "api-version", newJString(apiVersion))
  add(path_594922, "subscriptionId", newJString(subscriptionId))
  add(path_594922, "vmName", newJString(vmName))
  result = call_594921.call(path_594922, query_594923, nil, nil, nil)

var virtualMachinesDelete* = Call_VirtualMachinesDelete_594913(
    name: "virtualMachinesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}",
    validator: validate_VirtualMachinesDelete_594914, base: "",
    url: url_VirtualMachinesDelete_594915, schemes: {Scheme.Https})
type
  Call_VirtualMachinesCapture_594937 = ref object of OpenApiRestCall_593438
proc url_VirtualMachinesCapture_594939(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesCapture_594938(path: JsonNode; query: JsonNode;
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
  var valid_594940 = path.getOrDefault("resourceGroupName")
  valid_594940 = validateParameter(valid_594940, JString, required = true,
                                 default = nil)
  if valid_594940 != nil:
    section.add "resourceGroupName", valid_594940
  var valid_594941 = path.getOrDefault("subscriptionId")
  valid_594941 = validateParameter(valid_594941, JString, required = true,
                                 default = nil)
  if valid_594941 != nil:
    section.add "subscriptionId", valid_594941
  var valid_594942 = path.getOrDefault("vmName")
  valid_594942 = validateParameter(valid_594942, JString, required = true,
                                 default = nil)
  if valid_594942 != nil:
    section.add "vmName", valid_594942
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594943 = query.getOrDefault("api-version")
  valid_594943 = validateParameter(valid_594943, JString, required = true,
                                 default = nil)
  if valid_594943 != nil:
    section.add "api-version", valid_594943
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

proc call*(call_594945: Call_VirtualMachinesCapture_594937; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Captures the VM by copying virtual hard disks of the VM and outputs a template that can be used to create similar VMs.
  ## 
  let valid = call_594945.validator(path, query, header, formData, body)
  let scheme = call_594945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594945.url(scheme.get, call_594945.host, call_594945.base,
                         call_594945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594945, url, valid)

proc call*(call_594946: Call_VirtualMachinesCapture_594937;
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
  var path_594947 = newJObject()
  var query_594948 = newJObject()
  var body_594949 = newJObject()
  add(path_594947, "resourceGroupName", newJString(resourceGroupName))
  add(query_594948, "api-version", newJString(apiVersion))
  add(path_594947, "subscriptionId", newJString(subscriptionId))
  add(path_594947, "vmName", newJString(vmName))
  if parameters != nil:
    body_594949 = parameters
  result = call_594946.call(path_594947, query_594948, nil, nil, body_594949)

var virtualMachinesCapture* = Call_VirtualMachinesCapture_594937(
    name: "virtualMachinesCapture", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/capture",
    validator: validate_VirtualMachinesCapture_594938, base: "",
    url: url_VirtualMachinesCapture_594939, schemes: {Scheme.Https})
type
  Call_VirtualMachinesConvertToManagedDisks_594950 = ref object of OpenApiRestCall_593438
proc url_VirtualMachinesConvertToManagedDisks_594952(protocol: Scheme;
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

proc validate_VirtualMachinesConvertToManagedDisks_594951(path: JsonNode;
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
  var valid_594953 = path.getOrDefault("resourceGroupName")
  valid_594953 = validateParameter(valid_594953, JString, required = true,
                                 default = nil)
  if valid_594953 != nil:
    section.add "resourceGroupName", valid_594953
  var valid_594954 = path.getOrDefault("subscriptionId")
  valid_594954 = validateParameter(valid_594954, JString, required = true,
                                 default = nil)
  if valid_594954 != nil:
    section.add "subscriptionId", valid_594954
  var valid_594955 = path.getOrDefault("vmName")
  valid_594955 = validateParameter(valid_594955, JString, required = true,
                                 default = nil)
  if valid_594955 != nil:
    section.add "vmName", valid_594955
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594956 = query.getOrDefault("api-version")
  valid_594956 = validateParameter(valid_594956, JString, required = true,
                                 default = nil)
  if valid_594956 != nil:
    section.add "api-version", valid_594956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594957: Call_VirtualMachinesConvertToManagedDisks_594950;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Converts virtual machine disks from blob-based to managed disks. Virtual machine must be stop-deallocated before invoking this operation.
  ## 
  let valid = call_594957.validator(path, query, header, formData, body)
  let scheme = call_594957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594957.url(scheme.get, call_594957.host, call_594957.base,
                         call_594957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594957, url, valid)

proc call*(call_594958: Call_VirtualMachinesConvertToManagedDisks_594950;
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
  var path_594959 = newJObject()
  var query_594960 = newJObject()
  add(path_594959, "resourceGroupName", newJString(resourceGroupName))
  add(query_594960, "api-version", newJString(apiVersion))
  add(path_594959, "subscriptionId", newJString(subscriptionId))
  add(path_594959, "vmName", newJString(vmName))
  result = call_594958.call(path_594959, query_594960, nil, nil, nil)

var virtualMachinesConvertToManagedDisks* = Call_VirtualMachinesConvertToManagedDisks_594950(
    name: "virtualMachinesConvertToManagedDisks", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/convertToManagedDisks",
    validator: validate_VirtualMachinesConvertToManagedDisks_594951, base: "",
    url: url_VirtualMachinesConvertToManagedDisks_594952, schemes: {Scheme.Https})
type
  Call_VirtualMachinesDeallocate_594961 = ref object of OpenApiRestCall_593438
proc url_VirtualMachinesDeallocate_594963(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesDeallocate_594962(path: JsonNode; query: JsonNode;
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
  var valid_594964 = path.getOrDefault("resourceGroupName")
  valid_594964 = validateParameter(valid_594964, JString, required = true,
                                 default = nil)
  if valid_594964 != nil:
    section.add "resourceGroupName", valid_594964
  var valid_594965 = path.getOrDefault("subscriptionId")
  valid_594965 = validateParameter(valid_594965, JString, required = true,
                                 default = nil)
  if valid_594965 != nil:
    section.add "subscriptionId", valid_594965
  var valid_594966 = path.getOrDefault("vmName")
  valid_594966 = validateParameter(valid_594966, JString, required = true,
                                 default = nil)
  if valid_594966 != nil:
    section.add "vmName", valid_594966
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594967 = query.getOrDefault("api-version")
  valid_594967 = validateParameter(valid_594967, JString, required = true,
                                 default = nil)
  if valid_594967 != nil:
    section.add "api-version", valid_594967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594968: Call_VirtualMachinesDeallocate_594961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Shuts down the virtual machine and releases the compute resources. You are not billed for the compute resources that this virtual machine uses.
  ## 
  let valid = call_594968.validator(path, query, header, formData, body)
  let scheme = call_594968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594968.url(scheme.get, call_594968.host, call_594968.base,
                         call_594968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594968, url, valid)

proc call*(call_594969: Call_VirtualMachinesDeallocate_594961;
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
  var path_594970 = newJObject()
  var query_594971 = newJObject()
  add(path_594970, "resourceGroupName", newJString(resourceGroupName))
  add(query_594971, "api-version", newJString(apiVersion))
  add(path_594970, "subscriptionId", newJString(subscriptionId))
  add(path_594970, "vmName", newJString(vmName))
  result = call_594969.call(path_594970, query_594971, nil, nil, nil)

var virtualMachinesDeallocate* = Call_VirtualMachinesDeallocate_594961(
    name: "virtualMachinesDeallocate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/deallocate",
    validator: validate_VirtualMachinesDeallocate_594962, base: "",
    url: url_VirtualMachinesDeallocate_594963, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsList_594972 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineExtensionsList_594974(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionsList_594973(path: JsonNode; query: JsonNode;
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
  var valid_594975 = path.getOrDefault("resourceGroupName")
  valid_594975 = validateParameter(valid_594975, JString, required = true,
                                 default = nil)
  if valid_594975 != nil:
    section.add "resourceGroupName", valid_594975
  var valid_594976 = path.getOrDefault("subscriptionId")
  valid_594976 = validateParameter(valid_594976, JString, required = true,
                                 default = nil)
  if valid_594976 != nil:
    section.add "subscriptionId", valid_594976
  var valid_594977 = path.getOrDefault("vmName")
  valid_594977 = validateParameter(valid_594977, JString, required = true,
                                 default = nil)
  if valid_594977 != nil:
    section.add "vmName", valid_594977
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_594978 = query.getOrDefault("$expand")
  valid_594978 = validateParameter(valid_594978, JString, required = false,
                                 default = nil)
  if valid_594978 != nil:
    section.add "$expand", valid_594978
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594979 = query.getOrDefault("api-version")
  valid_594979 = validateParameter(valid_594979, JString, required = true,
                                 default = nil)
  if valid_594979 != nil:
    section.add "api-version", valid_594979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594980: Call_VirtualMachineExtensionsList_594972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get all extensions of a Virtual Machine.
  ## 
  let valid = call_594980.validator(path, query, header, formData, body)
  let scheme = call_594980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594980.url(scheme.get, call_594980.host, call_594980.base,
                         call_594980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594980, url, valid)

proc call*(call_594981: Call_VirtualMachineExtensionsList_594972;
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
  var path_594982 = newJObject()
  var query_594983 = newJObject()
  add(path_594982, "resourceGroupName", newJString(resourceGroupName))
  add(query_594983, "$expand", newJString(Expand))
  add(query_594983, "api-version", newJString(apiVersion))
  add(path_594982, "subscriptionId", newJString(subscriptionId))
  add(path_594982, "vmName", newJString(vmName))
  result = call_594981.call(path_594982, query_594983, nil, nil, nil)

var virtualMachineExtensionsList* = Call_VirtualMachineExtensionsList_594972(
    name: "virtualMachineExtensionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions",
    validator: validate_VirtualMachineExtensionsList_594973, base: "",
    url: url_VirtualMachineExtensionsList_594974, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsCreateOrUpdate_594997 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineExtensionsCreateOrUpdate_594999(protocol: Scheme;
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

proc validate_VirtualMachineExtensionsCreateOrUpdate_594998(path: JsonNode;
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
  var valid_595000 = path.getOrDefault("resourceGroupName")
  valid_595000 = validateParameter(valid_595000, JString, required = true,
                                 default = nil)
  if valid_595000 != nil:
    section.add "resourceGroupName", valid_595000
  var valid_595001 = path.getOrDefault("vmExtensionName")
  valid_595001 = validateParameter(valid_595001, JString, required = true,
                                 default = nil)
  if valid_595001 != nil:
    section.add "vmExtensionName", valid_595001
  var valid_595002 = path.getOrDefault("subscriptionId")
  valid_595002 = validateParameter(valid_595002, JString, required = true,
                                 default = nil)
  if valid_595002 != nil:
    section.add "subscriptionId", valid_595002
  var valid_595003 = path.getOrDefault("vmName")
  valid_595003 = validateParameter(valid_595003, JString, required = true,
                                 default = nil)
  if valid_595003 != nil:
    section.add "vmName", valid_595003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595004 = query.getOrDefault("api-version")
  valid_595004 = validateParameter(valid_595004, JString, required = true,
                                 default = nil)
  if valid_595004 != nil:
    section.add "api-version", valid_595004
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

proc call*(call_595006: Call_VirtualMachineExtensionsCreateOrUpdate_594997;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to create or update the extension.
  ## 
  let valid = call_595006.validator(path, query, header, formData, body)
  let scheme = call_595006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595006.url(scheme.get, call_595006.host, call_595006.base,
                         call_595006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595006, url, valid)

proc call*(call_595007: Call_VirtualMachineExtensionsCreateOrUpdate_594997;
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
  var path_595008 = newJObject()
  var query_595009 = newJObject()
  var body_595010 = newJObject()
  if extensionParameters != nil:
    body_595010 = extensionParameters
  add(path_595008, "resourceGroupName", newJString(resourceGroupName))
  add(query_595009, "api-version", newJString(apiVersion))
  add(path_595008, "vmExtensionName", newJString(vmExtensionName))
  add(path_595008, "subscriptionId", newJString(subscriptionId))
  add(path_595008, "vmName", newJString(vmName))
  result = call_595007.call(path_595008, query_595009, nil, nil, body_595010)

var virtualMachineExtensionsCreateOrUpdate* = Call_VirtualMachineExtensionsCreateOrUpdate_594997(
    name: "virtualMachineExtensionsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsCreateOrUpdate_594998, base: "",
    url: url_VirtualMachineExtensionsCreateOrUpdate_594999,
    schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsGet_594984 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineExtensionsGet_594986(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionsGet_594985(path: JsonNode; query: JsonNode;
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
  var valid_594987 = path.getOrDefault("resourceGroupName")
  valid_594987 = validateParameter(valid_594987, JString, required = true,
                                 default = nil)
  if valid_594987 != nil:
    section.add "resourceGroupName", valid_594987
  var valid_594988 = path.getOrDefault("vmExtensionName")
  valid_594988 = validateParameter(valid_594988, JString, required = true,
                                 default = nil)
  if valid_594988 != nil:
    section.add "vmExtensionName", valid_594988
  var valid_594989 = path.getOrDefault("subscriptionId")
  valid_594989 = validateParameter(valid_594989, JString, required = true,
                                 default = nil)
  if valid_594989 != nil:
    section.add "subscriptionId", valid_594989
  var valid_594990 = path.getOrDefault("vmName")
  valid_594990 = validateParameter(valid_594990, JString, required = true,
                                 default = nil)
  if valid_594990 != nil:
    section.add "vmName", valid_594990
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The expand expression to apply on the operation.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  var valid_594991 = query.getOrDefault("$expand")
  valid_594991 = validateParameter(valid_594991, JString, required = false,
                                 default = nil)
  if valid_594991 != nil:
    section.add "$expand", valid_594991
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594992 = query.getOrDefault("api-version")
  valid_594992 = validateParameter(valid_594992, JString, required = true,
                                 default = nil)
  if valid_594992 != nil:
    section.add "api-version", valid_594992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594993: Call_VirtualMachineExtensionsGet_594984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to get the extension.
  ## 
  let valid = call_594993.validator(path, query, header, formData, body)
  let scheme = call_594993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594993.url(scheme.get, call_594993.host, call_594993.base,
                         call_594993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594993, url, valid)

proc call*(call_594994: Call_VirtualMachineExtensionsGet_594984;
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
  var path_594995 = newJObject()
  var query_594996 = newJObject()
  add(path_594995, "resourceGroupName", newJString(resourceGroupName))
  add(query_594996, "$expand", newJString(Expand))
  add(query_594996, "api-version", newJString(apiVersion))
  add(path_594995, "vmExtensionName", newJString(vmExtensionName))
  add(path_594995, "subscriptionId", newJString(subscriptionId))
  add(path_594995, "vmName", newJString(vmName))
  result = call_594994.call(path_594995, query_594996, nil, nil, nil)

var virtualMachineExtensionsGet* = Call_VirtualMachineExtensionsGet_594984(
    name: "virtualMachineExtensionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsGet_594985, base: "",
    url: url_VirtualMachineExtensionsGet_594986, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsUpdate_595023 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineExtensionsUpdate_595025(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionsUpdate_595024(path: JsonNode;
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
  var valid_595026 = path.getOrDefault("resourceGroupName")
  valid_595026 = validateParameter(valid_595026, JString, required = true,
                                 default = nil)
  if valid_595026 != nil:
    section.add "resourceGroupName", valid_595026
  var valid_595027 = path.getOrDefault("vmExtensionName")
  valid_595027 = validateParameter(valid_595027, JString, required = true,
                                 default = nil)
  if valid_595027 != nil:
    section.add "vmExtensionName", valid_595027
  var valid_595028 = path.getOrDefault("subscriptionId")
  valid_595028 = validateParameter(valid_595028, JString, required = true,
                                 default = nil)
  if valid_595028 != nil:
    section.add "subscriptionId", valid_595028
  var valid_595029 = path.getOrDefault("vmName")
  valid_595029 = validateParameter(valid_595029, JString, required = true,
                                 default = nil)
  if valid_595029 != nil:
    section.add "vmName", valid_595029
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595030 = query.getOrDefault("api-version")
  valid_595030 = validateParameter(valid_595030, JString, required = true,
                                 default = nil)
  if valid_595030 != nil:
    section.add "api-version", valid_595030
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

proc call*(call_595032: Call_VirtualMachineExtensionsUpdate_595023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to update the extension.
  ## 
  let valid = call_595032.validator(path, query, header, formData, body)
  let scheme = call_595032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595032.url(scheme.get, call_595032.host, call_595032.base,
                         call_595032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595032, url, valid)

proc call*(call_595033: Call_VirtualMachineExtensionsUpdate_595023;
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
  var path_595034 = newJObject()
  var query_595035 = newJObject()
  var body_595036 = newJObject()
  if extensionParameters != nil:
    body_595036 = extensionParameters
  add(path_595034, "resourceGroupName", newJString(resourceGroupName))
  add(query_595035, "api-version", newJString(apiVersion))
  add(path_595034, "vmExtensionName", newJString(vmExtensionName))
  add(path_595034, "subscriptionId", newJString(subscriptionId))
  add(path_595034, "vmName", newJString(vmName))
  result = call_595033.call(path_595034, query_595035, nil, nil, body_595036)

var virtualMachineExtensionsUpdate* = Call_VirtualMachineExtensionsUpdate_595023(
    name: "virtualMachineExtensionsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsUpdate_595024, base: "",
    url: url_VirtualMachineExtensionsUpdate_595025, schemes: {Scheme.Https})
type
  Call_VirtualMachineExtensionsDelete_595011 = ref object of OpenApiRestCall_593438
proc url_VirtualMachineExtensionsDelete_595013(protocol: Scheme; host: string;
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

proc validate_VirtualMachineExtensionsDelete_595012(path: JsonNode;
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
  var valid_595014 = path.getOrDefault("resourceGroupName")
  valid_595014 = validateParameter(valid_595014, JString, required = true,
                                 default = nil)
  if valid_595014 != nil:
    section.add "resourceGroupName", valid_595014
  var valid_595015 = path.getOrDefault("vmExtensionName")
  valid_595015 = validateParameter(valid_595015, JString, required = true,
                                 default = nil)
  if valid_595015 != nil:
    section.add "vmExtensionName", valid_595015
  var valid_595016 = path.getOrDefault("subscriptionId")
  valid_595016 = validateParameter(valid_595016, JString, required = true,
                                 default = nil)
  if valid_595016 != nil:
    section.add "subscriptionId", valid_595016
  var valid_595017 = path.getOrDefault("vmName")
  valid_595017 = validateParameter(valid_595017, JString, required = true,
                                 default = nil)
  if valid_595017 != nil:
    section.add "vmName", valid_595017
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595018 = query.getOrDefault("api-version")
  valid_595018 = validateParameter(valid_595018, JString, required = true,
                                 default = nil)
  if valid_595018 != nil:
    section.add "api-version", valid_595018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595019: Call_VirtualMachineExtensionsDelete_595011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to delete the extension.
  ## 
  let valid = call_595019.validator(path, query, header, formData, body)
  let scheme = call_595019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595019.url(scheme.get, call_595019.host, call_595019.base,
                         call_595019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595019, url, valid)

proc call*(call_595020: Call_VirtualMachineExtensionsDelete_595011;
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
  var path_595021 = newJObject()
  var query_595022 = newJObject()
  add(path_595021, "resourceGroupName", newJString(resourceGroupName))
  add(query_595022, "api-version", newJString(apiVersion))
  add(path_595021, "vmExtensionName", newJString(vmExtensionName))
  add(path_595021, "subscriptionId", newJString(subscriptionId))
  add(path_595021, "vmName", newJString(vmName))
  result = call_595020.call(path_595021, query_595022, nil, nil, nil)

var virtualMachineExtensionsDelete* = Call_VirtualMachineExtensionsDelete_595011(
    name: "virtualMachineExtensionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/extensions/{vmExtensionName}",
    validator: validate_VirtualMachineExtensionsDelete_595012, base: "",
    url: url_VirtualMachineExtensionsDelete_595013, schemes: {Scheme.Https})
type
  Call_VirtualMachinesGeneralize_595037 = ref object of OpenApiRestCall_593438
proc url_VirtualMachinesGeneralize_595039(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesGeneralize_595038(path: JsonNode; query: JsonNode;
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
  var valid_595040 = path.getOrDefault("resourceGroupName")
  valid_595040 = validateParameter(valid_595040, JString, required = true,
                                 default = nil)
  if valid_595040 != nil:
    section.add "resourceGroupName", valid_595040
  var valid_595041 = path.getOrDefault("subscriptionId")
  valid_595041 = validateParameter(valid_595041, JString, required = true,
                                 default = nil)
  if valid_595041 != nil:
    section.add "subscriptionId", valid_595041
  var valid_595042 = path.getOrDefault("vmName")
  valid_595042 = validateParameter(valid_595042, JString, required = true,
                                 default = nil)
  if valid_595042 != nil:
    section.add "vmName", valid_595042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595043 = query.getOrDefault("api-version")
  valid_595043 = validateParameter(valid_595043, JString, required = true,
                                 default = nil)
  if valid_595043 != nil:
    section.add "api-version", valid_595043
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595044: Call_VirtualMachinesGeneralize_595037; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sets the state of the virtual machine to generalized.
  ## 
  let valid = call_595044.validator(path, query, header, formData, body)
  let scheme = call_595044.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595044.url(scheme.get, call_595044.host, call_595044.base,
                         call_595044.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595044, url, valid)

proc call*(call_595045: Call_VirtualMachinesGeneralize_595037;
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
  var path_595046 = newJObject()
  var query_595047 = newJObject()
  add(path_595046, "resourceGroupName", newJString(resourceGroupName))
  add(query_595047, "api-version", newJString(apiVersion))
  add(path_595046, "subscriptionId", newJString(subscriptionId))
  add(path_595046, "vmName", newJString(vmName))
  result = call_595045.call(path_595046, query_595047, nil, nil, nil)

var virtualMachinesGeneralize* = Call_VirtualMachinesGeneralize_595037(
    name: "virtualMachinesGeneralize", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/generalize",
    validator: validate_VirtualMachinesGeneralize_595038, base: "",
    url: url_VirtualMachinesGeneralize_595039, schemes: {Scheme.Https})
type
  Call_VirtualMachinesInstanceView_595048 = ref object of OpenApiRestCall_593438
proc url_VirtualMachinesInstanceView_595050(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesInstanceView_595049(path: JsonNode; query: JsonNode;
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
  var valid_595051 = path.getOrDefault("resourceGroupName")
  valid_595051 = validateParameter(valid_595051, JString, required = true,
                                 default = nil)
  if valid_595051 != nil:
    section.add "resourceGroupName", valid_595051
  var valid_595052 = path.getOrDefault("subscriptionId")
  valid_595052 = validateParameter(valid_595052, JString, required = true,
                                 default = nil)
  if valid_595052 != nil:
    section.add "subscriptionId", valid_595052
  var valid_595053 = path.getOrDefault("vmName")
  valid_595053 = validateParameter(valid_595053, JString, required = true,
                                 default = nil)
  if valid_595053 != nil:
    section.add "vmName", valid_595053
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595054 = query.getOrDefault("api-version")
  valid_595054 = validateParameter(valid_595054, JString, required = true,
                                 default = nil)
  if valid_595054 != nil:
    section.add "api-version", valid_595054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595055: Call_VirtualMachinesInstanceView_595048; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about the run-time state of a virtual machine.
  ## 
  let valid = call_595055.validator(path, query, header, formData, body)
  let scheme = call_595055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595055.url(scheme.get, call_595055.host, call_595055.base,
                         call_595055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595055, url, valid)

proc call*(call_595056: Call_VirtualMachinesInstanceView_595048;
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
  var path_595057 = newJObject()
  var query_595058 = newJObject()
  add(path_595057, "resourceGroupName", newJString(resourceGroupName))
  add(query_595058, "api-version", newJString(apiVersion))
  add(path_595057, "subscriptionId", newJString(subscriptionId))
  add(path_595057, "vmName", newJString(vmName))
  result = call_595056.call(path_595057, query_595058, nil, nil, nil)

var virtualMachinesInstanceView* = Call_VirtualMachinesInstanceView_595048(
    name: "virtualMachinesInstanceView", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/instanceView",
    validator: validate_VirtualMachinesInstanceView_595049, base: "",
    url: url_VirtualMachinesInstanceView_595050, schemes: {Scheme.Https})
type
  Call_VirtualMachinesPerformMaintenance_595059 = ref object of OpenApiRestCall_593438
proc url_VirtualMachinesPerformMaintenance_595061(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesPerformMaintenance_595060(path: JsonNode;
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
  var valid_595062 = path.getOrDefault("resourceGroupName")
  valid_595062 = validateParameter(valid_595062, JString, required = true,
                                 default = nil)
  if valid_595062 != nil:
    section.add "resourceGroupName", valid_595062
  var valid_595063 = path.getOrDefault("subscriptionId")
  valid_595063 = validateParameter(valid_595063, JString, required = true,
                                 default = nil)
  if valid_595063 != nil:
    section.add "subscriptionId", valid_595063
  var valid_595064 = path.getOrDefault("vmName")
  valid_595064 = validateParameter(valid_595064, JString, required = true,
                                 default = nil)
  if valid_595064 != nil:
    section.add "vmName", valid_595064
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595065 = query.getOrDefault("api-version")
  valid_595065 = validateParameter(valid_595065, JString, required = true,
                                 default = nil)
  if valid_595065 != nil:
    section.add "api-version", valid_595065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595066: Call_VirtualMachinesPerformMaintenance_595059;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The operation to perform maintenance on a virtual machine.
  ## 
  let valid = call_595066.validator(path, query, header, formData, body)
  let scheme = call_595066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595066.url(scheme.get, call_595066.host, call_595066.base,
                         call_595066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595066, url, valid)

proc call*(call_595067: Call_VirtualMachinesPerformMaintenance_595059;
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
  var path_595068 = newJObject()
  var query_595069 = newJObject()
  add(path_595068, "resourceGroupName", newJString(resourceGroupName))
  add(query_595069, "api-version", newJString(apiVersion))
  add(path_595068, "subscriptionId", newJString(subscriptionId))
  add(path_595068, "vmName", newJString(vmName))
  result = call_595067.call(path_595068, query_595069, nil, nil, nil)

var virtualMachinesPerformMaintenance* = Call_VirtualMachinesPerformMaintenance_595059(
    name: "virtualMachinesPerformMaintenance", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/performMaintenance",
    validator: validate_VirtualMachinesPerformMaintenance_595060, base: "",
    url: url_VirtualMachinesPerformMaintenance_595061, schemes: {Scheme.Https})
type
  Call_VirtualMachinesPowerOff_595070 = ref object of OpenApiRestCall_593438
proc url_VirtualMachinesPowerOff_595072(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesPowerOff_595071(path: JsonNode; query: JsonNode;
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
  var valid_595073 = path.getOrDefault("resourceGroupName")
  valid_595073 = validateParameter(valid_595073, JString, required = true,
                                 default = nil)
  if valid_595073 != nil:
    section.add "resourceGroupName", valid_595073
  var valid_595074 = path.getOrDefault("subscriptionId")
  valid_595074 = validateParameter(valid_595074, JString, required = true,
                                 default = nil)
  if valid_595074 != nil:
    section.add "subscriptionId", valid_595074
  var valid_595075 = path.getOrDefault("vmName")
  valid_595075 = validateParameter(valid_595075, JString, required = true,
                                 default = nil)
  if valid_595075 != nil:
    section.add "vmName", valid_595075
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595076 = query.getOrDefault("api-version")
  valid_595076 = validateParameter(valid_595076, JString, required = true,
                                 default = nil)
  if valid_595076 != nil:
    section.add "api-version", valid_595076
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595077: Call_VirtualMachinesPowerOff_595070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to power off (stop) a virtual machine. The virtual machine can be restarted with the same provisioned resources. You are still charged for this virtual machine.
  ## 
  let valid = call_595077.validator(path, query, header, formData, body)
  let scheme = call_595077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595077.url(scheme.get, call_595077.host, call_595077.base,
                         call_595077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595077, url, valid)

proc call*(call_595078: Call_VirtualMachinesPowerOff_595070;
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
  var path_595079 = newJObject()
  var query_595080 = newJObject()
  add(path_595079, "resourceGroupName", newJString(resourceGroupName))
  add(query_595080, "api-version", newJString(apiVersion))
  add(path_595079, "subscriptionId", newJString(subscriptionId))
  add(path_595079, "vmName", newJString(vmName))
  result = call_595078.call(path_595079, query_595080, nil, nil, nil)

var virtualMachinesPowerOff* = Call_VirtualMachinesPowerOff_595070(
    name: "virtualMachinesPowerOff", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/powerOff",
    validator: validate_VirtualMachinesPowerOff_595071, base: "",
    url: url_VirtualMachinesPowerOff_595072, schemes: {Scheme.Https})
type
  Call_VirtualMachinesRedeploy_595081 = ref object of OpenApiRestCall_593438
proc url_VirtualMachinesRedeploy_595083(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesRedeploy_595082(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation to redeploy a virtual machine.
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
  var valid_595084 = path.getOrDefault("resourceGroupName")
  valid_595084 = validateParameter(valid_595084, JString, required = true,
                                 default = nil)
  if valid_595084 != nil:
    section.add "resourceGroupName", valid_595084
  var valid_595085 = path.getOrDefault("subscriptionId")
  valid_595085 = validateParameter(valid_595085, JString, required = true,
                                 default = nil)
  if valid_595085 != nil:
    section.add "subscriptionId", valid_595085
  var valid_595086 = path.getOrDefault("vmName")
  valid_595086 = validateParameter(valid_595086, JString, required = true,
                                 default = nil)
  if valid_595086 != nil:
    section.add "vmName", valid_595086
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595087 = query.getOrDefault("api-version")
  valid_595087 = validateParameter(valid_595087, JString, required = true,
                                 default = nil)
  if valid_595087 != nil:
    section.add "api-version", valid_595087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595088: Call_VirtualMachinesRedeploy_595081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to redeploy a virtual machine.
  ## 
  let valid = call_595088.validator(path, query, header, formData, body)
  let scheme = call_595088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595088.url(scheme.get, call_595088.host, call_595088.base,
                         call_595088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595088, url, valid)

proc call*(call_595089: Call_VirtualMachinesRedeploy_595081;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          vmName: string): Recallable =
  ## virtualMachinesRedeploy
  ## The operation to redeploy a virtual machine.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   vmName: string (required)
  ##         : The name of the virtual machine.
  var path_595090 = newJObject()
  var query_595091 = newJObject()
  add(path_595090, "resourceGroupName", newJString(resourceGroupName))
  add(query_595091, "api-version", newJString(apiVersion))
  add(path_595090, "subscriptionId", newJString(subscriptionId))
  add(path_595090, "vmName", newJString(vmName))
  result = call_595089.call(path_595090, query_595091, nil, nil, nil)

var virtualMachinesRedeploy* = Call_VirtualMachinesRedeploy_595081(
    name: "virtualMachinesRedeploy", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/redeploy",
    validator: validate_VirtualMachinesRedeploy_595082, base: "",
    url: url_VirtualMachinesRedeploy_595083, schemes: {Scheme.Https})
type
  Call_VirtualMachinesReimage_595092 = ref object of OpenApiRestCall_593438
proc url_VirtualMachinesReimage_595094(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesReimage_595093(path: JsonNode; query: JsonNode;
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
  var valid_595095 = path.getOrDefault("resourceGroupName")
  valid_595095 = validateParameter(valid_595095, JString, required = true,
                                 default = nil)
  if valid_595095 != nil:
    section.add "resourceGroupName", valid_595095
  var valid_595096 = path.getOrDefault("subscriptionId")
  valid_595096 = validateParameter(valid_595096, JString, required = true,
                                 default = nil)
  if valid_595096 != nil:
    section.add "subscriptionId", valid_595096
  var valid_595097 = path.getOrDefault("vmName")
  valid_595097 = validateParameter(valid_595097, JString, required = true,
                                 default = nil)
  if valid_595097 != nil:
    section.add "vmName", valid_595097
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595098 = query.getOrDefault("api-version")
  valid_595098 = validateParameter(valid_595098, JString, required = true,
                                 default = nil)
  if valid_595098 != nil:
    section.add "api-version", valid_595098
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

proc call*(call_595100: Call_VirtualMachinesReimage_595092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reimages the virtual machine which has an ephemeral OS disk back to its initial state.
  ## 
  let valid = call_595100.validator(path, query, header, formData, body)
  let scheme = call_595100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595100.url(scheme.get, call_595100.host, call_595100.base,
                         call_595100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595100, url, valid)

proc call*(call_595101: Call_VirtualMachinesReimage_595092;
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
  var path_595102 = newJObject()
  var query_595103 = newJObject()
  var body_595104 = newJObject()
  add(path_595102, "resourceGroupName", newJString(resourceGroupName))
  add(query_595103, "api-version", newJString(apiVersion))
  add(path_595102, "subscriptionId", newJString(subscriptionId))
  add(path_595102, "vmName", newJString(vmName))
  if parameters != nil:
    body_595104 = parameters
  result = call_595101.call(path_595102, query_595103, nil, nil, body_595104)

var virtualMachinesReimage* = Call_VirtualMachinesReimage_595092(
    name: "virtualMachinesReimage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/reimage",
    validator: validate_VirtualMachinesReimage_595093, base: "",
    url: url_VirtualMachinesReimage_595094, schemes: {Scheme.Https})
type
  Call_VirtualMachinesRestart_595105 = ref object of OpenApiRestCall_593438
proc url_VirtualMachinesRestart_595107(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesRestart_595106(path: JsonNode; query: JsonNode;
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
  var valid_595108 = path.getOrDefault("resourceGroupName")
  valid_595108 = validateParameter(valid_595108, JString, required = true,
                                 default = nil)
  if valid_595108 != nil:
    section.add "resourceGroupName", valid_595108
  var valid_595109 = path.getOrDefault("subscriptionId")
  valid_595109 = validateParameter(valid_595109, JString, required = true,
                                 default = nil)
  if valid_595109 != nil:
    section.add "subscriptionId", valid_595109
  var valid_595110 = path.getOrDefault("vmName")
  valid_595110 = validateParameter(valid_595110, JString, required = true,
                                 default = nil)
  if valid_595110 != nil:
    section.add "vmName", valid_595110
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595111 = query.getOrDefault("api-version")
  valid_595111 = validateParameter(valid_595111, JString, required = true,
                                 default = nil)
  if valid_595111 != nil:
    section.add "api-version", valid_595111
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595112: Call_VirtualMachinesRestart_595105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to restart a virtual machine.
  ## 
  let valid = call_595112.validator(path, query, header, formData, body)
  let scheme = call_595112.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595112.url(scheme.get, call_595112.host, call_595112.base,
                         call_595112.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595112, url, valid)

proc call*(call_595113: Call_VirtualMachinesRestart_595105;
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
  var path_595114 = newJObject()
  var query_595115 = newJObject()
  add(path_595114, "resourceGroupName", newJString(resourceGroupName))
  add(query_595115, "api-version", newJString(apiVersion))
  add(path_595114, "subscriptionId", newJString(subscriptionId))
  add(path_595114, "vmName", newJString(vmName))
  result = call_595113.call(path_595114, query_595115, nil, nil, nil)

var virtualMachinesRestart* = Call_VirtualMachinesRestart_595105(
    name: "virtualMachinesRestart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/restart",
    validator: validate_VirtualMachinesRestart_595106, base: "",
    url: url_VirtualMachinesRestart_595107, schemes: {Scheme.Https})
type
  Call_VirtualMachinesStart_595116 = ref object of OpenApiRestCall_593438
proc url_VirtualMachinesStart_595118(protocol: Scheme; host: string; base: string;
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

proc validate_VirtualMachinesStart_595117(path: JsonNode; query: JsonNode;
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
  var valid_595119 = path.getOrDefault("resourceGroupName")
  valid_595119 = validateParameter(valid_595119, JString, required = true,
                                 default = nil)
  if valid_595119 != nil:
    section.add "resourceGroupName", valid_595119
  var valid_595120 = path.getOrDefault("subscriptionId")
  valid_595120 = validateParameter(valid_595120, JString, required = true,
                                 default = nil)
  if valid_595120 != nil:
    section.add "subscriptionId", valid_595120
  var valid_595121 = path.getOrDefault("vmName")
  valid_595121 = validateParameter(valid_595121, JString, required = true,
                                 default = nil)
  if valid_595121 != nil:
    section.add "vmName", valid_595121
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595122 = query.getOrDefault("api-version")
  valid_595122 = validateParameter(valid_595122, JString, required = true,
                                 default = nil)
  if valid_595122 != nil:
    section.add "api-version", valid_595122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595123: Call_VirtualMachinesStart_595116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation to start a virtual machine.
  ## 
  let valid = call_595123.validator(path, query, header, formData, body)
  let scheme = call_595123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595123.url(scheme.get, call_595123.host, call_595123.base,
                         call_595123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595123, url, valid)

proc call*(call_595124: Call_VirtualMachinesStart_595116;
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
  var path_595125 = newJObject()
  var query_595126 = newJObject()
  add(path_595125, "resourceGroupName", newJString(resourceGroupName))
  add(query_595126, "api-version", newJString(apiVersion))
  add(path_595125, "subscriptionId", newJString(subscriptionId))
  add(path_595125, "vmName", newJString(vmName))
  result = call_595124.call(path_595125, query_595126, nil, nil, nil)

var virtualMachinesStart* = Call_VirtualMachinesStart_595116(
    name: "virtualMachinesStart", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/start",
    validator: validate_VirtualMachinesStart_595117, base: "",
    url: url_VirtualMachinesStart_595118, schemes: {Scheme.Https})
type
  Call_VirtualMachinesListAvailableSizes_595127 = ref object of OpenApiRestCall_593438
proc url_VirtualMachinesListAvailableSizes_595129(protocol: Scheme; host: string;
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

proc validate_VirtualMachinesListAvailableSizes_595128(path: JsonNode;
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
  var valid_595130 = path.getOrDefault("resourceGroupName")
  valid_595130 = validateParameter(valid_595130, JString, required = true,
                                 default = nil)
  if valid_595130 != nil:
    section.add "resourceGroupName", valid_595130
  var valid_595131 = path.getOrDefault("subscriptionId")
  valid_595131 = validateParameter(valid_595131, JString, required = true,
                                 default = nil)
  if valid_595131 != nil:
    section.add "subscriptionId", valid_595131
  var valid_595132 = path.getOrDefault("vmName")
  valid_595132 = validateParameter(valid_595132, JString, required = true,
                                 default = nil)
  if valid_595132 != nil:
    section.add "vmName", valid_595132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595133 = query.getOrDefault("api-version")
  valid_595133 = validateParameter(valid_595133, JString, required = true,
                                 default = nil)
  if valid_595133 != nil:
    section.add "api-version", valid_595133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595134: Call_VirtualMachinesListAvailableSizes_595127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all available virtual machine sizes to which the specified virtual machine can be resized.
  ## 
  let valid = call_595134.validator(path, query, header, formData, body)
  let scheme = call_595134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595134.url(scheme.get, call_595134.host, call_595134.base,
                         call_595134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595134, url, valid)

proc call*(call_595135: Call_VirtualMachinesListAvailableSizes_595127;
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
  var path_595136 = newJObject()
  var query_595137 = newJObject()
  add(path_595136, "resourceGroupName", newJString(resourceGroupName))
  add(query_595137, "api-version", newJString(apiVersion))
  add(path_595136, "subscriptionId", newJString(subscriptionId))
  add(path_595136, "vmName", newJString(vmName))
  result = call_595135.call(path_595136, query_595137, nil, nil, nil)

var virtualMachinesListAvailableSizes* = Call_VirtualMachinesListAvailableSizes_595127(
    name: "virtualMachinesListAvailableSizes", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{vmName}/vmSizes",
    validator: validate_VirtualMachinesListAvailableSizes_595128, base: "",
    url: url_VirtualMachinesListAvailableSizes_595129, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
